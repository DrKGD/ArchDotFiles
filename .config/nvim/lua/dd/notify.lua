-------------------------------------
-- Setup notification system       --
-------------------------------------
-- Default notification system     --
-------------------------------------

local DEFAULT = {}

DEFAULT.info	= function(msg, ...)
	vim.notify(string.format(msg, ...), vim.diagnostic.severity.INFO) end

DEFAULT.error = function(msg, ...)
	vim.notify(string.format(msg, ...), vim.diagnostic.severity.ERROR) end

DEFAULT.warn	= function(msg, ...)
	vim.notify(string.format(msg, ...), vim.diagnostic.severity.WARN) end

DEFAULT.hint	= function(msg, ...)
	vim.notify(string.format(msg, ...), vim.diagnostic.severity.HINT) end

-------------------------------------
-- Use nvim-notify plugin          --
-------------------------------------
local NOTIFY = {}

NOTIFY.info	= function(msg, ...)
	vim.notify(string.format(msg, ...), 'info', { render = "minimal"}) end

NOTIFY.error = function(msg, ...)
	vim.notify(string.format(msg, ...), 'error', { render = "minimal"}) end

NOTIFY.warn	= function(msg, ...)
	vim.notify(string.format(msg, ...), 'warn', { render = "minimal"}) end

NOTIFY.hint	= function(msg, ...)
	vim.notify(string.format(msg, ...), 'info', { render = "minimal"}) end

return (function()
	local HAS_NVIM_NOTIFY = pcall(require, "notify")

	if HAS_NVIM_NOTIFY
		then return NOTIFY
		else return DEFAULT
	end
end)()
