--
-- Treesitter
-- Better text highlighting
--
-- BUG: https://github.com/wbthomason/packer.nvim/issues/776
return { 'nvim-treesitter/nvim-treesitter',
	requires = {
			-- Rainbow parenthesis
			{ 'p00f/nvim-ts-rainbow', disable = BOOTSTRAP_GUARD },
			{ 'nvim-treesitter/nvim-treesitter-textobjects', disable = BOOTSTRAP_GUARD },

			-- Extend '%' jumping functionalities
			{ 'andymass/vim-matchup', disable = BOOTSTRAP_GUARD },

			-- Treesitter context
			{ 'nvim-treesitter/nvim-treesitter-context', disable = BOOTSTRAP_GUARD}
		},
	run = function()
		if not BOOTSTRAP_GUARD then
			vim.cmd(':TSUpdate') end
	end,
	config = function()
		if BOOTSTRAP_GUARD then return end
		-- if true then return end

		local colors	= (function()
				-- Number of final colors = shades + 1
				local tbl				= {}
				local from			= PREFERENCES.palette.i3.focus
				local to				= require('util.color').invert(from)
				local shades		= 7

				local mix				= require('util.color').mix

				-- Add colors in order to the table
				local step			= 1 / shades
				for i = 1, shades - 1 do
					table.insert(tbl, mix(to, from, step * (i-1))) end
				table.insert(tbl, to)

				return tbl
			end)()

		require('nvim-treesitter.configs').setup {
			-- Tresitter on these languages
			ensure_installed = {"c", "lua", "json", "html", "python", "c_sharp", "latex"},

			-- Modules configuration
			highlight = { enable = true },
			indent	= { enable = false },

			rainbow = {
					enable = true,
					extended_mode = true,
					max_file_lines = 1000,
					colors = colors
				},

			matchup = {
					enable = true,
				},

			incremental_selection = {
				enable = false,
				keymaps = {
					init_selection = '<CR>',
					scope_incremental = '<CR>',
					node_incremental = '<Tab>',
					node_decremental = '<S-Tab>',
				},
			},
		}

		vim.g.matchup_matchparen_offscreen = { }
		require("treesitter-context").setup()
	end }


