-------------------------------------
-- Vim specific functions          --
-------------------------------------
-- Notification system
local n		= require("dd.notify")
local buf = require("util.buffers")

local M = {}

-- ENHANCE: vim api did not update it yet?
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  if next(lines) == nil then
    return nil
  end
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

-- Toggle options
M.toggleList			= function() vim.opt.list = not vim.opt.list._value end
M.toggleSpell			= function() vim.opt.spell = not vim.opt.spell._value end
M.toggleRelative	= function()
		vim.opt.number = not vim.opt.number._value
		vim.opt.relativenumber = not vim.opt.relativenumber._value
	end
M.toggleSearch		= function() vim.opt.hlsearch = not vim.opt.hlsearch._value end
M.toggleWordWrap	= function() vim.opt.wrap	= not vim.opt.wrap._value end

-- Paste content of register at position 
M.paste = function(fromRegister)
	local content = require('util.transform').split(vim.fn.getreg(fromRegister))
	if not content or content == '\n' then
		n.warn('No content in register <%s>, skipped!', fromRegister) return end

	vim.opt.paste = true
	vim.api.nvim_put(content, 'c', true, true)
	vim.opt.paste = false
	n.info('Pasted from system clipboard!')
end

-- M.setRegister = function(toRegister, lines)
-- 	lines = table.concat(lines, '\n')
-- 	if not lines or lines == '\n' or lines == '' then
-- 		n.warn('No lines to set for register <%s>, skipped!', toRegister) return end
--
-- 	vim.fn.setreg(toRegister, lines)
-- 	n.info('Register <%s> set!', toRegister)
-- end

-- Setup vim macros
M.setup = function(	)
	vim.api.nvim_create_user_command('DDToggleList', M.toggleList, {})
	vim.api.nvim_create_user_command('DDToggleSpell', M.toggleSpell, {})
	vim.api.nvim_create_user_command('DDToggleRelativeNumber', M.toggleRelative, {})
	vim.api.nvim_create_user_command('DDToggleSearch', M.toggleSearch, {})
	vim.api.nvim_create_user_command('DDToggleWordWrap', M.toggleWordWrap, {})
	vim.api.nvim_create_user_command('DDMoveUp', function() M.moveLine(1) end, {})
	vim.api.nvim_create_user_command('DDMoveDown', function() M.moveLine(-1) end, {})
	vim.api.nvim_create_user_command('Paste', function(register)
			M.paste(register.args)
		end, { nargs = 1 })
end



return M

