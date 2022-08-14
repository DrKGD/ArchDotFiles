--
-- nvim-window
-- Window selection prompt
--
return { 'https://gitlab.com/yorickpeterse/nvim-window',
	config = function()
		-- ["orange"]					= "#FF9507",
		-- ["blue"]						= "#179AFF",
		vim.cmd([[hi NvimWindowStyle guifg=#FF9507 guibg=#2c1c0c]])

		require('nvim-window').setup({
			normal_hl = 'NvimWindowStyle',
			hint_hl = 'Bold',
			border = 'none'
		})

		require('utils.wrap').bind({ noremap = true}, 'n', '<Leader><Space>', ":lua require('nvim-window').pick()<CR>")
	end}
