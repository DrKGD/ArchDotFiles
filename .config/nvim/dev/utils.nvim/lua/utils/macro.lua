local pathfun		= require('utils.path')
local filefun		= require('utils.file')
local systeminf = require('utils.system')
local e,s,a,w,i	= require('utils.message').setup('macro.lua')
local confirm		= require('utils.message').confirm
local channel		= require('utils.channel')
local tokenize	= require('utils.modx').tokenize

local M = {}

-- For those that are not implemented yet, as a reminder
M.not_implemented = function() w('This function is yet to be implemented!') end

--- Vim wrappers  ---
M.toggleList = function() vim.opt.list = not vim.opt.list['_value'] end
M.toggleSpell = function() vim.opt.spell = not vim.opt.spell['_value'] end

--- File handlers ---
-- Save file
M.save = function()
	-- Check if readonly
	if vim.bo.readonly then
		vim.cmd('SudaWrite') return end

	-- Check if terminal
	if vim.bo.buftype == 'terminal' then
		e('Denied: cannot save terminal!') return end

	local fn = vim.fn.expand('%')

	-- If file exists, just rewrite it (save)
	if fn ~= ''	then vim.cmd('w') return end

	local name = vim.fn.input('(Save as) > ', vim.fn.getcwd() .. systeminf.separator, 'dir')
	if vim.fn.empty(name) > 0 then a('Operation cancelled!') return end

	-- Bad name
	if pathfun.isDirectory(name) then
		e('Denied: cannot save a file as a directory!') return end
	-- Folder does not exists
	if not pathfun.directoryExists(vim.fn.fnamemodify(name, ':p:h')) then
		e('Denied: destination folder does not exists!') return end

	-- File already exists
	if pathfun.fileExists(name) then
		e('Denied: file already exists (overwrite not allowed)!') return end
	vim.cmd(string.format('w %s', name))
end

-- Reload current file without saving
M.refresh = function()
	if vim.bo.buftype == 'terminal' then
		channel.send('clear')   return end

	if vim.bo.modified and not confirm("Discard all file changes? [type 'yes'] ", 'yes') then
		a('Operation cancelled!') return end
	vim.cmd([[e! %]])
end

-- New file/directory
M.new = function()
	local fname = vim.fn.input("New (file/folder): ", vim.fn.expand('%:p:h') .. systeminf.separator, 'dir')
	if vim.fn.empty(fname) > 0 then a('Operation cancelled!') return end

	-- Check whether or not it is a directory
	if pathfun.isDirectory(fname)
		then filefun.mkdir(vim.fn.fnamemodify(fname, ":p:h")) return end
	filefun.write(fname)
end

-- Delete file/directory
M.remove = function()
	local fname = vim.fn.input("Delete file: ", vim.fn.getcwd() .. systeminf.separator, 'file')
	if vim.fn.empty(fname) > 0 then a('Operation cancelled!') return end

	-- If file or directory does not exist, do not continue
	if not pathfun.fileExists(fname) and not pathfun.directoryExists(fname) then
		e(string.format('Operation failed, [%s] does not exist!', fname)) return end

	-- Is directory
	if pathfun.isDirectory(fname) then
		local msg = string.format('Are you sure you want to delete %s? [type "yes"] ', fname)
		if not confirm(msg, 'yes') then a('Operation cancelled!') return end
		filefun.rmdir(fname)
	-- Is file
	else
		filefun.rmfile(fname)
	end
end

-- Move file/directory (also acts as rename)
M.move = function(old)
	old = old or vim.fn.input("Move: ", vim.fn.getcwd() .. systeminf.separator, 'file')
	if vim.fn.empty(old) > 0 then e(string.format("Can't move[%s], not a file!", old)) return end

	local new = vim.fn.input(string.format('(%s) to: ', vim.fn.fnamemodify(old, ':t')), vim.fn.fnamemodify(old, ':h') .. systeminf.separator)
	if vim.fn.empty(new) > 0 then a('Operation cancelled!') return end

	filefun.mvfile(old, new, false)
end


--- Session Handler ---
local session = function()
	return string.format('mksession! %s/%s.lastSession | ', vim.fn.stdpath('data'), tostring(vim.env.PID)) end

local cq = function(signal)
	return string.format('%dcq!', signal) end

-- Quit nvim with signal UPSIGNAL
M.restart = function()
	local sig = require('utils.config').options.UPSIGNAL

	vim.cmd(cq(sig))
end

-- Quit nvim with signal EXSIGNAL 
M.restart_keepsession = function()
	local sig = require('utils.config').options.EXSIGNAL

	vim.cmd(string.format('%s%s', session(), cq(sig)))
end

-- Packer Compile then signal EXSIGNAL
M.compile_keepsession = function()
	local sig = require('utils.config').options.EXSIGNAL

	-- Source init.lua
	vim.cmd(string.format('source %s/init.lua', vim.fn.stdpath('config')))

	-- Append exit command on compile
	vim.cmd(string.format('autocmd User PackerCompileDone %s%s', session(), cq(sig)))
	
	-- Finally compile
	vim.cmd('PackerCompile')
end

--- Terminal commands
local function getToken(at, tkn, nontkn, esc, cmd)
	-- Retrieve non tkn
	cmd = cmd:gsub(tkn, ' ﱢ ﱢ ﱢ  ', 1)
	cmd = cmd:gsub(esc, nontkn)
	local param = vim.fn.input(string.format('(%s) > ', cmd))
	if vim.fn.empty(param) > 0 then return nil end

	-- TODO: Allow lua commands?
	return vim.fn.expand(param)
end

-- Repeat last command (de-tokenized)
M.shell_repeat_tokenize = function()
	if not channel.lastCommand then
		e(string.format([[Denied: No commands were issued this session!]])) return end

	-- Command coulnd't be tokenized
	local etok = tokenize(channel.lastCommand, getToken)
	if not etok then return end

	channel.make()
	channel.send(etok)
	s('Command ran successfully, check terminal buffer!')
end

-- Repeat last command (shell)
M.shell_repeat = function()
	channel.make()

	-- The space serves as a magic-space
	channel.send('!! ')
end

-- Run command in shell
M.shell_run = function()
	-- Read Command
	local command = vim.fn.input('(ext) > ')
	if vim.fn.empty(command) > 0 then
		a('Operation cancelled!') return end

	-- Tokenize
	local etok = tokenize(command, getToken)
	if not etok then
		e('Command could not be tokenized!') return end
	channel.make()
	channel.send(etok)
	s('Command ran successfully, check terminal buffer!')
	channel.lastCommand = command
end

--- Toggle MinimalStatusLine
-- <F12> Toggle Statusline components or Update cd in terminal
M.toggle_minimal_statusline = function()
	MinimalStatusline = not MinimalStatusline
end

--- Paste in Terminal, prevent autoex
M.paste_terminal = function()
	return vim.fn.getreg('+'):gsub('\n$', ''):gsub("\n",' && ')
end

M.setup = function()
	local prefix = require('utils.config').options.uc_prefix

	local uc = function(name, command, args)
		vim.api.nvim_create_user_command(prefix .. name, command, args or {}) end

	uc('ToggleList', [[lua require('utils.macro').toggleList()]])
	uc('ToggleSpell', [[lua require('utils.macro').toggleList()]])
	uc('ToggleMinimalStatusLine', [[lua require('utils.macro').toggle_minimal_statusline()]])
	uc('New', [[lua require('utils.macro').new()]])
	uc('Remove', [[lua require('utils.macro').remove()]])
	uc('Rename', [[lua require('utils.macro').move(vim.fn.expand('%:p'))]])
	uc('Move', [[lua require('utils.macro').move()]])
	uc('Restart', [[lua require('utils.macro').restart()]])
	uc('KeepSessionRestart', [[lua require('utils.macro').restart_keepsession()]])
	uc('CompileRestart', [[lua require('utils.macro').compile_keepsession()]])
	uc('Save', [[lua require('utils.macro').save()]])
	uc('Refresh', [[lua require('utils.macro').refresh()]])
	uc('ShellRun', [[lua require('utils.macro').shell_run()]])
	uc('ShellRepeat', [[lua require('utils.macro').shell_repeat()]])
	uc('ShellRepeatTokenize', [[lua require('utils.macro').shell_repeat_tokenize()]])
end


return M
