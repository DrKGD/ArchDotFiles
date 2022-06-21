--
-- harpoon
-- ThePrimeagen always has something for anything
--
return {'ThePrimeagen/harpoon',
	after = {'telescope.nvim'},
	config = function()
		require("harpoon").setup()

		local bind = require('utils.wrap').bind
		bind({ silent = true }, 'n', '<Space>ha',':lua require("harpoon.mark").add_file()<CR>')
		bind({ silent = true }, 'n', '|',':lua require("harpoon.ui").toggle_quick_menu()<CR>')
		bind({ silent = true }, 'n', '{',':lua require("harpoon.ui").nav_prev()<CR>')
		bind({ silent = true }, 'n', '}',':lua require("harpoon.ui").nav_next()<CR>')

		-- I really don't need it
		require('telescope').load_extension("harpoon")
	end }
