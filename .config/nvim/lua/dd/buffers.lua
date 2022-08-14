-------------------------------------
-- Special buffers                 --
-------------------------------------
local M = {}

local n			= require("dd.notify")
local buf		= require("util.buffers")
local m			=	require('mapx')
local pload = require('util.packer').loadPlugin

-------------------------------------
-- Bufferize buffer                --
-------------------------------------
local bufferize_buffer_opt = { buftype = 'nowrite', swapfile = false, bufhidden = 'hide' }

-- Run command and write the content to a new buffer 
M.bufferize = function(cmd)
	-- Handle buffer 
	local buf_id
	local bname = buf.matchBuffers(".*dd%.bufferize")
	if #bname > 0
		then buf_id = bname[1].id
		else buf_id = buf.newBuffer('.dd.bufferize', bufferize_buffer_opt)
	end

	-- Run command and retrieve lines
	local content = vim.split(vim.trim(vim.api.nvim_exec(cmd, true)), '\n')

	-- Write content
	vim.api.nvim_buf_set_lines(buf_id, 0, 1, false, { [[WARNING: Buffer will be wiped on exit!]], string.format('Output of command: <%s>', cmd) })
	vim.api.nvim_buf_set_lines(buf_id, 2, -1, false, content)

	-- Returns buffer id
	return buf_id
end

-- Destroy bufferize buffer 
local destroy_bufferize_buffers = function()
	local winget = require('util.windows').getWindowsDisplayingBuffers
	local wipe = require('bufdelete').bufwipeout
	local buff = require('util.buffers').matchBuffers(".*dd%.bufferize")

	-- Either no results or one result, so do not bother refractoring this
	-- TODO: Refractor, bad code
	for _, k in ipairs(buff) do
		local wlist = winget(k.id)
		local b = buf.newBuffer()

		-- Set No Name
		for window, _ in ipairs(wlist) do
			vim.api.nvim_win_set_buf(window, b) end

		n.info('Buffer <%s> was wiped!', vim.fn.fnamemodify(k.path, ':t'))
		wipe(k.id) end
end


-------------------------------------
-- Livecode buffers                --
-------------------------------------
local livecode_buffer_opts		= { buftype = 'nowrite', swapfile = false, bufhidden = 'hide' }
local livecode_ids						= nil
local livecodeoutput_buffer		= nil
local augroup_name						= 'ScratchPadGroup'
local augroup									= nil
local snipapi_register				= false

-- Register special commands for the buffer
local register_commands = function(buf_id)
	local cmd		= require('util.generic').cmd

	-- Add bindings
	m.group("silent", { buffer = buf_id }, function()
		-- Run whole snippet
		m.noremap('<C-s>', cmd '%SnipRun')

		-- Run current line
		m.noremap('<Space><Space>r', cmd 'SnipRun')

		-- Emergency Stop
		m.noremap('<Space><Space>s', cmd 'SnipReset')
	end)
end

-- API Listener
local api_listener  = function(d)
	local buf_id = M.scratchout()

	-- Write content to buffer
	vim.api.nvim_buf_set_lines(
		buf_id, 0, -1, false, { string.format('[[ COMMAND STATUS: <%s> ]]', d.status) })
	vim.api.nvim_buf_set_lines(
		buf_id, 1, -1, false, vim.split(d.message or 'No message available...', '\n'))
end

-- Setup snip.api
local sniprun_setup = function()
	require('sniprun.api').register_listener(api_listener)
end

-- Check against livecode_ids
local register_events = function()
	augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })

	-- Automatically close in_line evaluation on mode change 
	vim.api.nvim_create_autocmd("ModeChanged",{
	group = augroup,
	callback = function(args)
		if livecode_ids[args.buf] then
			require('sniprun.display').close_all() end
	end})
end

local register_perbuffer_events = function(ext)
	vim.api.nvim_create_autocmd('BufWipeout', {
		group = augroup,
		pattern = string.format('*dd.scratchpad.%s', ext),
		callback = function(args)
			livecode_ids[args.buf] = nil
			n.info('Buffer <%s> has been wiped!', vim.fn.fnamemodify(args.file, ':e'))
			return true
		end })
end

-- Add in livecode_ids
local add_event_listener = function(buf_id, ft)
	-- Run only once no matter what
	if not snipapi_register then
			snipapi_register = true
			sniprun_setup()
		end

	if not livecode_ids then
			livecode_ids = { }
			register_events()
		end

	register_perbuffer_events(ft)
	livecode_ids[buf_id] = true
end

-- Upon vim reload, restore buffers which matches the name
local restore_livecode_buffers = function()
	local buffers = require('util.buffers').matchBuffers(".*dd%.scratchpad%..*")
	if #buffers > 0 then
		pload('sniprun') end

	-- Register all the aforementioned commands 
	for _, k in ipairs(buffers) do
		n.info('Buffer <%s> was restored!', vim.fn.fnamemodify(k.path, ':t'))

		local ext = vim.fn.fnamemodify(k.path, ':e')
		local opts = vim.tbl_deep_extend("force", livecode_buffer_opts, { filetype = ext })
		buf.setupBuffer(k.id, opts )
		register_commands(k.id)
		add_event_listener(k.id, ext)
	end

	-- Restore output buffer as well
	local output = require('util.buffers').matchBuffers(".*dd%.scratch%.out")
	for _, k in ipairs(output) do
		n.info('Buffer <%s> was restored!', vim.fn.fnamemodify(k.path, ':t'))
		buf.setupBuffer(k.id, livecode_buffer_opts)
	end
end

-- Register an output buffer for all scratchpad
local outscratch_name = "dd.scratch.out"
M.scratchout = function()
	-- Buffer already exists and is valid
	if livecodeoutput_buffer and vim.api.nvim_buf_is_valid(livecodeoutput_buffer)
		then return livecodeoutput_buffer end

	-- If name is found, then just retrieve its id 
	local bname = buf.matchBuffers(".*dd%.scratch%.out")
	if #bname > 0
		then livecodeoutput_buffer =  bname[1].id
		else
			livecodeoutput_buffer = buf.newBuffer(outscratch_name, livecode_buffer_opts)
			vim.api.nvim_buf_set_lines(livecodeoutput_buffer, 0, -1, false, {
				'Hello? This is deatharte talking!',
				'This is the scratchpad buffer, it server no purpose',
				'... Not until you run a Scratch!',
				'  :Scratch <langauge>',
				'',
				'Also, do not type anything important in here',
				'It could be wiped! 😉'})
	end

	return livecodeoutput_buffer
end

-- New temporary buffer which automatically binds some operations 
M.scratch = function(filetype)
	local name = string.format("dd.scratchpad.%s", filetype)

	-- Handle buffer: either make a new one or return the previous one
	local buf_id
	local bname = buf.matchBuffers(string.format(".*%s", name))
	if #bname > 0
		-- Probably was already setup, just return its id 
		then
			buf_id = bname[1].id; return buf_id

		-- Setup new buffer 
		else
			local opts = vim.tbl_deep_extend("force", livecode_buffer_opts, { filetype = filetype })
			buf_id = buf.newBuffer(name, opts)
	end

	-- Load Sniprun
	pload('sniprun')
	register_commands(buf_id)
	add_event_listener(buf_id, filetype)

	-- TODO: On BufUnload, remove its id from

	return buf_id
end


-- Destroy all buffers 
M.scratchkillall = function()
	local wipe = require('bufdelete').bufwipeout

	-- Retrieve all window - buffer combination
	local buffers = {}
	vim.tbl_map(function(e)
			table.insert(buffers, e.id)
		end, require('util.buffers').matchBuffers(".*dd%.scratch.*%..*"))

	-- No buffers were detected
	if #buffers == 0 then
		return end

	-- Switch all instances to an empty noname buffer
	local tuples = require('util.windows').getWindowsDisplayingBuffers(buffers)
	local nonamebuf = buf.newBuffer()
	for w, b in pairs(tuples) do
			vim.api.nvim_win_set_buf(w, nonamebuf)
			wipe(b)
		end

	livecode_ids					= nil
	livecodeoutput_buffer = nil
	vim.api.nvim_del_augroup_by_name(augroup_name)
end


M.setup = function()
	-- Run bufferize and retrieve content in the current window
	vim.api.nvim_create_user_command('Bufferize', function(cmd)
			local bufid = M.bufferize(cmd.args)
			vim.schedule(function() vim.api.nvim_win_set_buf(0, bufid) end)
		end, { nargs='+' })

	-- Create new scratch buffer
	vim.api.nvim_create_user_command('Scratch', function(ftype)
			local bufid = M.scratch(ftype.args)
			vim.schedule(function() vim.api.nvim_win_set_buf(0, bufid) end)
		end, { nargs=1 })

	-- Set current buffer to the scratch output buffer, if it does not exist, create one 
	vim.api.nvim_create_user_command('ScratchOutput', function()
			local bufid = M.scratchout()
			vim.schedule(function() vim.api.nvim_win_set_buf(0, bufid) end)
		end, { nargs=0 })

	-- Kill all scratch buffers, which otherwise would be recovered in the next session
	vim.api.nvim_create_user_command('ScratchKillAll', function()
			M.scratchkillall()
		end, { nargs=0 })

	-- Cleanup
	vim.api.nvim_create_autocmd("VimEnter", { callback = function()
		destroy_bufferize_buffers()
		restore_livecode_buffers()

		return true
	end })
end


return M
