--
-- Colorschemes
-- All the user installed colorschemes
--
return {
		{ 'shaeinst/roshnivim-cs', opt = true, as = 'colorscheme.rvcs'},
		{ 'tanvirtin/monokai.nvim', opt = true, as = 'colorscheme.monokai'},
		{ 'tiagovla/tokyodark.nvim', opt = true, as = 'colorscheme.tokyodark', config = function()
				vim.g.tokyodark_transparent_background	= true
				vim.g.tokyodark_enable_italic_comment		= false
				vim.g.tokyodark_enable_italic						= false
				vim.g.tokyodark_color_gamma							= "0.85"
			end},
		{ 'B4mbus/oxocarbon-lua.nvim', opt = true, as = 'colorscheme.oxocarbon-lua'}
	}

