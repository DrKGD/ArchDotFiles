--
-- Gitsigns
-- Helpful to visualize filechanges
--
return { 'lewis6991/gitsigns.nvim',
	requires = {'nvim-lua/plenary.nvim'},
	config = function()
		require('gitsigns').setup({
			sign_priority = 6,
			signs = {
				add          = { text = '█', hl = 'GitSignsAdd'   , numhl='GitSignsAddNr'   , linehl='GitSignsAddLn',  },
				change       = { text = '█', hl = 'GitSignsAdd'	  , numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
				delete       = { text = '█', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
				topdelete    = { text = '█', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
				changedelete = { text = '█', hl = 'GitSignsChange', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
			},
			numhl = false,
			linehl = false,
			signcolumn = true,
			keymaps = {
				noremap = false,
				buffer	= false,
			},
			attach_to_untracked = true,
			current_line_blame = false,
		})
	end }
