local M = {}

-- Default settings
local defaults = {
	-- User Commands Prefix
	uc_prefix = 'KUT',

	-- Signals for restart and keep session
	EXSIGNAL = 17,
	UPSIGNAL = 18,

	--- Messages
	unknown_src = 'nvim',

	colors = {
		error		= '#FF004D',
		success = '#17FF7C',
		info		= '#FFFFFF',
		abort		= '#FF9507',
		confirm	= '#FF9507',
		warning	= '#DBED00'
	}

}


-- In-use options
M.options = {}


-- Setup plugin
M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", defaults, options or {})

	require('utils.macro').setup()


end

return M
