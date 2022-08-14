-------------------------------------
-- Session Manager for NVIM        --
-------------------------------------

local M = {}

-- Keep Session Restart
M.keepSession = function()
	vim.cmd(string.format([[mksession! %s | %dcq!]], os.getenv("PID_SESSION"), os.getenv("SIGKEEP") or 0)) end

-- Discard Session Restart
M.discardSession = function()
	vim.cmd(string.format([[%dcq!]], os.getenv("SIGDISCARD") or 0)) end

-- Setup vim macros
M.setup = function()
	vim.api.nvim_create_user_command('DDKeep', M.keepSession, {})
	vim.api.nvim_create_user_command('DDRestart', M.discardSession, {})
end

return M
