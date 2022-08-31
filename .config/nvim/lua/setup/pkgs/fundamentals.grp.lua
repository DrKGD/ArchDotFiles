-- -- Fundamentals
-- These plugins are required to some extent
--  They do not belong to a personal file as they
--	+ require little to no configuration
--  + their functionalities extends nvim functionalities
--  + they are passive plugins (e.g. icons)
--  + they do not belong in a plugin family (e.g. telescope extensions, treesitter, lsp)
--	+ they have a relative short configuration (<10 lines)
--
return {
	'wbthomason/packer.nvim',										-- Packer
	'nvim-lua/plenary.nvim',										-- Utility functions
	'nvim-lua/popup.nvim',											-- Popup wrapper for neovim
	'tami5/sqlite.lua',													-- Sqlite capabilities wrapper for neovim
	'lambdalisue/suda.vim',											-- Sudo wrapper (to save files)
	'mrjones2014/smart-splits.nvim',						-- Splits handler
	'anuvyklack/hydra.nvim',										-- Hydra menus for fast, visually appealing, user-generated tool tips on commands
	'linty-org/readline.nvim',									-- Provides useful keymappings for insert/command modes
	'antoinemadec/FixCursorHold.nvim',					-- Should fix CursorHold events
	'famiu/bufdelete.nvim',											-- Delete buffers, no layout change 

	{ 'b0o/mapx.nvim',													-- Better mappings
		config = function()
				require('mapx').setup({ whichkey = require('util.packer').loadPlugin('which-key.nvim')})
			end },

	{ "booperlv/nvim-gomove",										-- Handle horizontal movement
		config = function()
			require("gomove").setup {
				move_past_end_col = true,
				map_defaults = false,
				reindent = false,
				undojoin = true,
			} end },

	{ "numToStr/Comment.nvim",									-- NERDCommenter on steroids, defaults ain't that bad
		event = 'BufEnter',
    config = function()
        require('Comment').setup()
    end },

	{ "windwp/nvim-autopairs",									-- Autopairs, using TreeSitter
		event = 'BufEnter',
    config = function()
			local ap = require('nvim-autopairs')
			local HAS_TREESITTER = require('util.packer').loadPlugin('nvim-treesitter')

			ap.setup({
				enable_check_bracket_line = true,
				ignored_next_char = "[%w%.]",
				check_ts = HAS_TREESITTER,

				map_bs = false,
				map_cr = false,
				disable_filetype = { "TelescopePrompt", "NvimTree" },
				fast_wrap = {
					map = '<A-d>',
					chars = { '{', '[', '(', '"', "'" },
					pattern = [=[[%'%"%)%>%]%)%}%,]]=],
					end_key = '$',
					keys = 'qwertyuiopzxcvbnmasdfghjkl',
					check_comma = true,
					highlight = 'Search',
					highlight_grey='Comment'
				},
			})

    end },

	{ "nacro90/numb.nvim",											-- Peak at position
		config = function()
			require('numb').setup({
				centered_peeking = true,
				show_numbers = true,
				show_cursorline = false
			})
		end },

	{ "ggandor/lightspeed.nvim",								-- Jump around
		event = "BufRead",
		config = function()
			require('lightspeed').setup({
				jump_to_unique_chars = false,
				safe_labels = {}
			}	)
		end },

	{ 'phaazon/mind.nvim',											-- Take notes directly in nvim
		branch = 'v2',
		requires = { 'nvim-lua/plenary.nvim' },
		configure = function()
			require('mind').setup()
		end },

	{ "kylechui/nvim-surround",									-- Add (ys-motion), remove (ds-motion) or change (cs-motion) the surrounding characters
		event = 'BufEnter',
		config = function()
			require("nvim-surround").setup({

			})
		end },

	{ "otavioschwanck/cool-substitute.nvim",		-- Mark word in insert mode with gm, modify, then apply changes using M (or ga to all)
		event = 'BufEnter',
		config = function()
			require("cool-substitute").setup ({
				setup_keybindings = true
			})
		end},
}

