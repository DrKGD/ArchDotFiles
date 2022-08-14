-------------------------------------
-- Configuration update            --
-------------------------------------
-- Local variables                 --
-------------------------------------

-- Notification system
local n = require("dd.notify")

-------------------------------------

local M = {}

local register_hook = function()
	local plugin_file = string.format('%s/plugin/10-packer.lua', vim.fn.stdpath('config'))
	vim.cmd(string.format('luafile %s', plugin_file))

	vim.api.nvim_create_autocmd('User', { pattern = 'PackerCompileDone', command = 'DDKeep'})
end

-- Invoke packer's update, then restart keeping session
M.update = function()
	if not vim.fn.exists(":PackerUpdate") then
		n.error("PackerUpdate is not available!") return end

	-- Source init.lua then PackerSync, thus restart
	register_hook()
	require('packer').sync()
end

-- Invoke packer's compile, then restart keeping session
M.compile = function()
	if not vim.fn.exists(":PackerCompile") then
		n.error("PackerCompile is not available!") return end

	-- Source init.lua then PackerCompile, thus restart
	register_hook()
	require('packer').compile()
end

-- Invoke packer's compile, then restart keeping session
M.install = function()
	if not vim.fn.exists(":PackerInstall") then
		n.error("PackerCompile is not available!") return end

	-- Source init.lua then PackerCompile, thus restart
	register_hook()
	require('packer').install()
	require('packer').compile()
end


-- Setup vim macros
M.setup = function()
	vim.api.nvim_create_user_command('DDPUpdate', M.update, {})
	vim.api.nvim_create_user_command('DDPInstall', M.install, {})
	vim.api.nvim_create_user_command('DDPCompile', M.compile, {})
end

return M
