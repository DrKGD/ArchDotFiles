-------------------------------------
-- File handler                    --
-------------------------------------
-- Local variables                 --
-------------------------------------

-- System separator
local separator = (function()
	if vim.fn.has('win32') == 1 then return '\\' end
	if vim.fn.has('unix') == 1 then return '/' end
	if vim.fn.has('mac') == 1 then return '/' end
	return nil
end)()

local input_prompt = function(msg, lambda)
	vim.ui.input({ prompt = msg,
		completion = 'dir'},
		lambda )
end


-- Notification system
local n = require("dd.notify")
local path= require("util.path")

-------------------------------------

local M = {}

-- Make new file, won't overwrite
M.touch = function(p)
	if path.fileExists(p) then
		n.error("File <%s> already exists, operation aborted!", p) return end

	local parent = path.dirParent(p)
	if not path.dirExists(parent) then
		n.error("Parent folder <%s> does not exist, operation aborted!", parent) return end

	vim.fn.writefile({}, p)
	n.info("File <%s> successfully written!", p)
end

-- Create directory
M.mkdir = function(p)
	vim.fn.mkdir(p, "")
	n.info("Directory <%s> successfully written!", p)
end

-- Copy file
M.cp		= function(src, dest)
	-- Check if file exists
	if not path.fileExists(src) then
		n.error("Source file <%s> does not exist, operation aborted!", src) return end
	if path.fileExists(dest) then
		n.error("Destination file <%s> already exists, operation aborted!", dest) return end

	-- Check if parent directory exists
	local parent = path.dirParent(dest)
	if not path.dirExists(parent) then
		n.error("Parent folder for destination <%s> does not exist, operation aborted!", parent) return end

	vim.fn.writefile(vim.fn.readfile(src, "b"), dest, "b")
	n.info("File <%s> copied onto <%s> with success!", src, dest)
end

-- Reload current file
M.reload	= function()
	local fn = vim.fn.expand("%:p")
	if vim.fn.empty(vim.fn.expand(fn)) == 1 then
		n.error("Reload denied, [No Name] buffer was selected!") return end

	if vim.bo.buftype == 'terminal' then
		n.error("Reload denied, current buffer is a terminal!") return end


	if vim.bo.modified and require('util.generic').confirm("Discard all file changes? [type 'yes'] ", 'yes') then
		n.info('Reload operation cancelled!') return end

	-- Reload
	vim.cmd([[e! %]])
	n.info('File <%s> was reloaded from disk!', fn)
end

-- Move file
M.mv		=	function(src, dest)
	-- Check if file exists
	if not path.fileExists(src) then
		n.error("Source file <%s> does not exist, operation aborted!", src) return end
	if path.fileExists(dest) then
		n.error("Destination file <%s> already exists, operation aborted!", dest) return end

	-- Check if parent directory exists
	local parent = path.dirParent(dest)
	if not path.dirExists(parent) then
		n.error("Parent folder for destination <%s> does not exist, operation aborted!", parent) return end

	-- If any window had this file open, we will switch to a temporary empty buffer
	local id = vim.fn.bufnr(vim.fn.fnamemodify(src, ':p'))
	local matches = require('util.windows').getWindowsDisplayingBuffers({ id })
	local b
	if not (next(matches) == nil) then
		b = require('util.buffers').newBuffer()
		for w, _ in pairs(matches) do
			vim.api.nvim_win_set_buf(w, b)
		end
	end

	-- Move, load buffer, and re-switch everything back to it
	vim.cmd(string.format([[silent! mv "%s" "%s"]], src, dest))
	vim.cmd(string.format([[silent! badd %s]], dest))
	local newId = vim.fn.bufnr(vim.fn.fnamemodify(dest, ':p'))
	for w, _ in pairs(matches) do
		vim.api.nvim_win_set_buf(w, newId)
	end

	-- Wipe temp from memory
	if b then require('bufdelete').bufwipeout(b) end
	n.info("File <%s> moved to <%s> with success!", src, dest)
end

-- Delete file (actually moving them to temporary folder)
M.rm		= function(p)
	if not path.fileExists(p) then
		n.error("File <%s> does not exist, operation aborted!", p) return end

	-- File destination
	local dest = string.format("%s%s_%s.rm", os.getenv("PID_GARBAGE"), vim.fn.fnamemodify(p, ":t"), vim.fn.strftime("%Y-%m-%d"))

	-- If any window had this file open in a buffer, replace with an empty buffer
	local id = vim.fn.bufnr(vim.fn.fnamemodify(p, ':p'))
	local matches = require('util.windows').getWindowsDisplayingBuffers({ id })
	if not (next(matches) == nil) then
		local b = require('util.buffers').newBuffer()
		for w, _ in pairs(matches) do
			vim.api.nvim_win_set_buf(w, b)
		end

		-- Wipe buffer from memory
		require('bufdelete').bufwipeout(id)
	end

	-- Finally move file somewhere else
	vim.cmd(string.format([[silent !mv "%s" "%s"]], p, dest))
	n.info("File <%s> was moved to the garbage bin, will be deleted upon restart (location: <%s>)!", p, dest)
end

-- Save current buffer (if possible)
M.save	= function()

	-- Check if help  buffer
	if vim.bo.buftype == 'help' then
		n.error("Do you need <help>? 😉 😉") return end

	-- Check if terminal buffer
	if vim.bo.buftype == 'terminal' then
		n.error("Denied, cannot save terminal(s)!") return end

	-- Check if buffer is nofile
	if vim.bo.buftype == 'nofile' then
		n.error("Sorry, won't be saving a <nofile> buffer!") return end

	-- Check if buffer is nofile
	if vim.bo.buftype == 'nowrite' then
		n.error("Sorry, won't be saving a <nowrite> buffer!") return end

	-- Handle readonly files
	if vim.bo.readonly then
		if vim.fn.exists(":SudaWrite")
			then vim.cmd("SudaWrite")
			else n.error("File is readonly, could not write!")
		end

		return
	end


	-- If file exists, overwrite
	local fn = vim.fn.expand("%:p")
	if fn~= '' then
		n.info('File <%s> written!', fn)
		vim.cmd('silent! w')
		return end

	-- Retrieve a name otherwise
	fn = input_prompt('(Save as): ')
	if vim.fn.empty(fn) == 1 then
		n.info("Save operation aborted!") return end

	-- Sanity checks (not a directory, parent exists, file already exists)
	if path.isDir(fn) then
		n.error("Denied, cannot save a file as a directory!", fn) return end

	if path.fileExists(fn) then
		n.error("Denied, file <%s> already exists!", fn) return end

	local parent = path.dirParent(fn)
	if not path.dirExists(parent) then
		n.error("Denied, parent folder <%s> does not exist!", parent) return end

	-- Save
	n.info('File <%s> created!', fn)
	vim.cmd(string.format("silent! w %s", fn))
end

M.setup = function()
	local prompt_or_run = function(p, title, run)
		if p.args ~= '' then run(p.args)
		else input_prompt(title, run) end
	end

	vim.api.nvim_create_user_command('DDSave', M.save, {})
	vim.api.nvim_create_user_command('DDReloadDocument', M.reload, {})
	vim.api.nvim_create_user_command('DDNew', function(p)
		prompt_or_run(p, 'New (file/directory)', function(input)
			if vim.fn.empty(input) == 1 then
				n.info("New file operation aborted!") return end

			if path.isDir(input)
				then M.mkdir(input)
				else M.touch(input)
			end
		end)
	end, { nargs = '?' })

	vim.api.nvim_create_user_command('DDCopy', function(p)
		local src	= vim.fn.expand("%:p")
		if vim.fn.empty(src) == 2 then
			n.error("[No Name] buffer was selected!") return end

		prompt_or_run(p, string.format("Copy <%s>", src), function(input)
			if vim.fn.empty(input) == 1 then
				n.info("Copy operation aborted") return end
			M.cp(src, input)
		end)
	end, { nargs = '?' })

	vim.api.nvim_create_user_command('DDMove', function(p)
		local src	= vim.fn.expand("%:p")
		if vim.fn.empty(src) == 2 then
			n.error("[No Name] buffer was selected!") return end

		prompt_or_run(p, string.format("Move <%s>", src), function(input)
			if vim.fn.empty(input) == 1 then
				n.info("Move operation aborted") return end
			M.mv(src, input)
		end)
	end, { nargs = '?' })


	vim.api.nvim_create_user_command('DDDelete', function(p)
		prompt_or_run(p, 'Delete', function(input)
			if vim.fn.empty(input) == 1 then
				n.info("Delete operation aborted!") return end

			if path.isDir(input)
				then n.error("Remove function won't support directory removal, as it is a dangerous operation!")
				else M.rm(input)
			end
		end)
	end, { nargs = '?' })
end

return M
