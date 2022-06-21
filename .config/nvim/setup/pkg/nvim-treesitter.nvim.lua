--
-- Treesitter
-- Better text highlighting
--
return { 'nvim-treesitter/nvim-treesitter',
	run = ':TSUpdate',
	requires = {
			'p00f/nvim-ts-rainbow',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
	config = function()
		-- util.wrap.setHi({
		-- 	TSComment				= { gui   = 'NONE', guifg = '#FF0000' },
		-- })

		require('nvim-treesitter.configs').setup {
			highlight = {
				enable = true,
			},

			indent	= {
				enable = false,
			},

			ensure_installed = "all",

			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = 1000,
				colors = {
					PREFERENCES.misc.colors.cherryred,
					PREFERENCES.misc.colors.turquoise,
					PREFERENCES.misc.colors.orange,
					PREFERENCES.misc.colors.blue,
					PREFERENCES.misc.colors.green,
					PREFERENCES.misc.colors.pink
				}
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<CR>',
					scope_incremental = '<CR>',
					node_incremental = '<Tab>',
					node_decremental = '<S-Tab>',
				},
			},
		}

		-- Folds with treesitter
		vim.opt.foldmethod		= 'expr'
		vim.opt.foldexpr			= "nvim_treesitter#foldexpr()"
		vim.opt.foldminlines	= 1
		vim.opt.foldnestmax		= 3
		vim.opt.fillchars			= "fold: "
		vim.opt.foldtext			= [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
		
	end}
