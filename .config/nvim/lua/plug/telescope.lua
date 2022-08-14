-------------------------------------
-- Telescope utility               --
-------------------------------------

local M = {}

M.reconfigure = function(tbl, picker, override)
		-- Sanity check

		if not picker then return vim.notify("No promprt selected!") end

		-- Return default if no configuraiton was overriden (no table given)
		if not override then return require(tbl)[picker]() end

		-- Override configuration
		local src = require('telescope.config').pickers[picker]
		local dest = vim.tbl_deep_extend("force", src, override)
		return require(tbl)[picker](dest)
	end

return M
