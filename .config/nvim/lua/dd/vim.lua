-------------------------------------
-- Vim specific functions          --
-------------------------------------
-- Notification system
local n		= require("dd.notify")
local buf = require("util.buffers")

local M = {}

-- Toggle options
M.toggleList			= function() vim.opt.list = not vim.opt.list._value end
M.toggleSpell			= function() vim.opt.spell = not vim.opt.spell._value end
M.toggleRelative	= function()
		vim.opt.number = not vim.opt.number._value
		vim.opt.relativenumber = not vim.opt.relativenumber._value
	end
M.toggleSearch		= function() vim.opt.hlsearch = not vim.opt.hlsearch._value end
M.toggleWordWrap	= function() vim.opt.wrap	= not vim.opt.wrap._value end

-- Paste command wrapped in nvim 
M.paste = function(lines, phase)
	if type(lines) == 'string' then
		lines = { lines } end

	vim.opt.paste = true
	vim.api.nvim_put(lines, 'c', true, true)
	vim.opt.paste = false
	n.info('Pasted from clipboard!')
end


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
			local content = vim.fn.getreg(register.args)
			if content == '\n' then
				return n.warn('No content in register <%s>, skipped', register.args) end

			content = require('util.transform').split(content)
			M.paste(content)
		end, { nargs = 1 })
end

return M
