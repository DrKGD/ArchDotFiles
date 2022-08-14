--
-- Focus
-- Auto-resize windows
--
return { 'beauwilliams/focus.nvim',
	after = { 'utils.nvim' },
	config = function()
		require('focus').setup({
			enable = true,
			bufnew = true,
			cursorline = false,
			signcolumn = false,
			relativenumber = false,

			excluded_filetypes = {'TelescopePrompt', 'harpoon'},
		})

		-- Darken background for inactive windows
		-- require('utils.modx').setHi({
		-- 	UnfocusedWindow = { guibg = '#101010' }})

		-- Split with a bufnew and move to split
		local bind = require('utils.wrap').bind
		bind({ silent = true }, 'n', '*k', ':FocusSplitUp<CR>')
		bind({ silent = true }, 'n', '*j', ':FocusSplitDown<CR>')
		bind({ silent = true }, 'n', '*h', ':FocusSplitLeft<CR>')
		bind({ silent = true }, 'n', '*l', ':FocusSplitRight<CR>')
	end }
