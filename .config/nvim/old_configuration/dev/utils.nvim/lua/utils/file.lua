local e,s,a,w,info	= require('utils.message').setup('utils.file')
local	pathfun		= require('utils.path')
local istrue		= require('utils.shenanigans').is_true
local isfalse 	= require('utils.shenanigans').is_false

local function trycatch(lambda, catch, parameters)
	local ok, err = pcall(lambda, unpack(parameters))
	if not ok
		then catch(err, unpack(parameters)) return true end
	return false
end

local MSG = {
	ErrRM						=	function()
		e('I do not know how to "rm"!') end,
	ErrNoFile				= function(path)
		e(string.format('File [%s] does not exist!', path)) end,
	ErrNoDir				= function(path)
		e(string.format('Destination folder [%s] does not exist!', path)) end,
	ErrNotADir				= function(path)
		e(string.format('[%s] is not a directory!', path)) end,
	ErrNotAllowed		= function(path)
		e(string.format('File [%s] already exists (nor overwrite and append were set)!', path)) end,
	ErrFileExist		= function(path)
		e(string.format('File [%s] already exists (nor overwrite and append were set)!', path)) end,
	ErrFolderExists = function(path)
		e(string.format('Folder [%s] already exists!', path)) end,
	ErrMvFileExists = function(path)
		e(string.format('Already a file [%s] at move location (overwrite: false)!', path)) end,
	ExcWriteFailed	= function(path, err)
		e(string.format('[Exception]: Write operation of [%s] returned an e: %s', path, err)) end,
	ExcMkdirFailed	= function(path, err)
		e(string.format('[Exception]: mkdir operation of [%s] returned an e: %s', path, err)) end,
	ErrUnknownOp		= function(op)
		e(string.format('I do not know how to [%s]!', op)) end,
	SuccRM					= function(name)
		s(string.format('File [%s] deleted!', name)) end,
	SuccWrite				= function(name)
		s(string.format('File [%s] written!', name)) end,
	SuccMoveFile		= function(from, to)
		s(string.format('File [%s] moved to [%s]!', from, to)) end,
	SuccMkdir				= function(name)
		s(string.format('Folder [%s] created!', name)) end,
	SuccRmdir				= function(name)
		s(string.format('Folder [%s] deleted!', name)) end,
}

local M = {}

--- Read the content of the file into a table
-- Returns nothing if file was not found
function M.read(path)
	if not path then return end
	if not pathfun.fileExists(path)
		then MSG.ErrNoFile(path) return end

	return vim.fn.readfile(path)
end

--- Write table to file
function M.write(path, content, flags)
	if not path then return end
	content = content or {}
	flags = flags or {}

	-- Destination folder does not exist
	if not pathfun.directoryExists(vim.fn.fnamemodify(path, ":p:h"))
		then MSG.ErrNoDir(path) return end

	-- If file already exists, and neither overwrite nor append were set, then prevent accidental write
	if (not flags.overwrite and not flags.append) and pathfun.fileExists(path)
		then MSG.ErrNotAllowed(path) return end

	-- Make file
	-- @diagnostic disable-next-line: redefined-local
	local catchblock = function(err, _, pth)
		MSG.ExcWriteFailed(path, err)
	end

	-- Operate flags
	local fstring = ''
	if flags.append then fstring = fstring .. 'a' end

	-- If s, return path, otherwise return nothing
	if trycatch(vim.fn.writefile, catchblock, {content, path, fstring}) then
		return nil end
	MSG.SuccWrite(path)
	return path
end

-- Remove operation
local rm = (function()
	if istrue(vim.fn.has('win32'))	then return 'del' end
	if istrue(vim.fn.has('unix'))		then return 'rm' end
	if istrue(vim.fn.has('mac'))		then return 'rm' end
	return nil
end)()

-- Remove without confirm, thus allowing non-interactive operation
local rmforced	= (function()
	if istrue(vim.fn.has('win32'))	then return '/f' end
	if istrue(vim.fn.has('unix')) 	then return '-f' end
	if istrue(vim.fn.has('mac'))		then return '-f' end
	return nil
end)()

-- Remove recursive, thus affecting subfolders and subfiles
local rmrecursive	= (function()
	if istrue(vim.fn.has('win32'))	then return '/s' end
	if istrue(vim.fn.has('unix'))		then return '-r' end
	if istrue(vim.fn.has('mac'))		then return '-r' end
	return nil
end)()

local rmcommand = function(forced, recursive)
	local opName			= rm or nil
	if not opName then return nil end
	local opForced		= (function() if forced then return rmforced end end)() or ''
	local opRecursive = (function() if recursive then return rmrecursive end end)() or ''

	return vim.trim(string.format('!%s %s %s', opName, opForced, opRecursive))
end

-- Delete file
function M.rmfile(path, forced)
	if not path then return end
	if not forced	then forced = false end

	-- If path does not exist
  if not pathfun.fileExists(path)
			then MSG.ErrNoFile(path) return end

	-- Assemble command
	local rmcmd = rmcommand(forced)
	if not rmcmd then MSG.ErrRM() return end
	vim.cmd(string.format('silent %s -- %s', rmcmd, path))
	MSG.SuccRM(path)
end

-- Remove directory
function M.rmdir(path)
	if not path then return end

	-- If directory does not exists
	if not pathfun.directoryExists(path)
		then MSG.ErrNoFile(path) return end

	-- If not a directrory
	if not pathfun.isDirectory(path)
		then MSG.ErrNotADir(path) return end

	-- Assemble command
	local rmcmd = rmcommand(true, true)
	if not rmcmd then MSG.ErrUnknownOp('rm') return end
	vim.cmd(string.format('silent %s -- %s', rmcmd, path))
	MSG.SuccRmdir(path)
end

-- Move operation
local mv = (function()
	if vim.fn.has('win32')	== 1 then return 'move' end
	if vim.fn.has('unix')		== 1 then return 'mv' end
	if vim.fn.has('mac')		== 1 then return 'mv' end
	return nil
end)()

-- Move without confirm, non-interactive operation
local mvforced	= (function()
	if vim.fn.has('win32')	== 1 then return '/Y' end
	if vim.fn.has('unix')		== 1 then return '-f' end
	if vim.fn.has('mac')		== 1 then return '-f' end
	return nil
end)()


local mvcommand = (function(forced)
	local opName			= mv
	local opForced		= (function() if forced then return mvforced end end)() or ''

	return opName, opForced
end)

--- Move file
function M.mvfile(old, new, overwrite)
	if not old or not new then return nil end
	if overwrite == nil then overwrite = false end
	local parameters = parameters or ''

	-- If to-move file doesn't exist
  if not pathfun.fileExists(old)
		then MSG.ErrNoFile(old) return end

	-- If the new location already exists and overwrite flags is off
	if pathfun.fileExists(new) and not overwrite
		then MSG.ErrMvFileExists(new) return end

	-- Assemble command
	local opName, opForced = mvcommand(forced, false)
	if not opName then MSG.ErrUnknownOp('mv') return end
	-- Write, go to a previously opened buffer, unload buffer
	vim.cmd([[w|b#|bd#]])
	vim.cmd(string.format('silent !%s %s "%s" "%s"', opName, opForced, old, new))
	vim.cmd(string.format('e %s', new))
	MSG.SuccMoveFile(old, new)
end


--- Wrapper for mkdir
function M.mkdir(path, parameters, permission)
	if not path then return nil end
	path = vim.fn.expand(path)
	-- HAX: Cannot make hyphen (-) folders without 'p'
	parameters = parameters or 'p'

	-- If directory already exists
	if pathfun.directoryExists(path)
		then MSG.ErrFolderExists(path) return end

	-- Parent Directory does not exist
	local destFolder = vim.fn.fnamemodify(path, ':p:h:h')
	if not parameters:find('p') and not pathfun.directoryExists(destFolder) then
		MSG.ErrNoDir(destFolder) return end

	-- Make directory
	local catchblock = function(e, p) MSG.ExcMkdirFailed(p, e) end

	-- If s, return path, otherwise return nothing
	if trycatch(vim.fn.mkdir, catchblock, {path, parameters, permission}) then
		return nil end

	MSG.SuccMkdir(path)
	return path
end

return M
