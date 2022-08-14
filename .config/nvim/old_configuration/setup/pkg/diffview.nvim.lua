--
-- Nvimdiff
-- Git repo differences
--
return { 'sindrets/diffview.nvim',
	-- TODO: Requires configuration
	requires = 'nvim-lua/plenary.nvim',
	config = function()
		require("diffview").setup()
	end }
