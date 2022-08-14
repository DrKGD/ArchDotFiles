--
-- Eyecandy 
--  If it has a GUI, it belongs here
--
return {
	{ 'kyazdani42/nvim-web-devicons',										-- Devicons, it is required from most plugins
		config = function()
			require('nvim-web-devicons').setup()
		end },

	{ "ThePrimeagen/harpoon",														-- 'Anchor' a buffer at a specific spot
		event = "BufEnter",
		config = function()
			require('harpoon').setup({
				excluded_filetypes = { "harpoon", "NvimTree", "TelescopePrompt" }
			})
		end },

	{ 'rcarriga/nvim-notify',														-- Stylize notifications
		config = function()
			local n = require('notify')

			n.setup({
				timeout = 2500,
				stages	= 'fade',
				fps = 144,
				background_colour = '#000000',
				on_open = function(win)
					vim.api.nvim_exec_autocmds("User", { pattern = "NvimNotificationOpen" })
					require('plug.notify').on_enter(win)
				end,

				on_close = function(_)
					vim.api.nvim_exec_autocmds("User", { pattern = "NvimNotificationClose" })
				end,
			})

			-- Replace default notification system
			vim.notify = n
		end },


	{ "lukas-reineke/indent-blankline.nvim",						-- Indentation visualizer
		event =	'BufEnter',
		config = function()
			local colors	= (function()
					local c					= require('util.color')
					-- Number of final colors = shades + 1
					local tbl				= {}

					local from			= c.invert(c.lighten(PREFERENCES.palette.i3.urgent, 0.45))
					local shades		= 10
					local to				= c.darken(from, 0.70)

					local mix				= require('util.color').mix

					-- Add colors in order to the table
					local step			= 1 / shades
					for i = 1, shades - 1 do
						table.insert(tbl, mix(to, from, step * (i-1))) end
					table.insert(tbl, to)

					return tbl
				end)()

			-- Define shades
			local shades = {}
			for i, color in ipairs(colors) do
				local name = string.format([[IndentBlanklineColor%d]], i)
				table.insert(shades, name)
				vim.schedule(function()
					vim.api.nvim_set_hl(0, name, { fg = color})
				end)
			end

			-- Override current_context color
			vim.schedule(function()
				vim.api.nvim_set_hl(0, [[IndentBlanklineContextChar]], { fg = require('util.color').lighten(PREFERENCES.palette.i3.urgent, 0.35) })
			end)

			require('indent_blankline').setup({
				char = "░",
				context_char = "▒",
				show_foldtext = false,

				show_current_context = true,
				show_current_context_start = false,
				char_highlight_list = shades
			})
		end },

	{ "rebelot/heirline.nvim",													-- Statusline
		config = function()
			local sl, wb = unpack(require('plug.heirline'))
			require("heirline").setup(sl)--, WinBar)
			require("heirline").winbar = require("heirline.statusline"):new(wb)
			vim.opt.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
		end },

	{ "brenoprata10/nvim-highlight-colors",							-- Color highlight
		config = function()
			require('nvim-highlight-colors').setup({
					render = 'background'
				})
		end},

	{ "lewis6991/gitsigns.nvim",												-- Git changes, colorized
		event = 'BufEnter',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('gitsigns').setup({
				sign_priority = 6,
				signs = {
					add          = { text = '▒', hl = 'GitSignsAdd'   , numhl='GitSignsAddNr'   , linehl='GitSignsAddLn',  },
					change       = { text = '▒', hl = 'GitSignsAdd'	  , numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
					delete       = { text = '▒', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
					topdelete    = { text = '▒', hl = 'GitSignsDelete', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
					changedelete = { text = '▒', hl = 'GitSignsChange', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
				},
				numhl = false,
				linehl = true,
				signcolumn = true,
				keymaps = {
					noremap = false,
					buffer	= false,
				},
				attach_to_untracked = true,
				current_line_blame = false,
			})
		end},

	{ "folke/trouble.nvim",															-- Don't get into troubles!
		cmd = { 'Trouble', 'TroubleToggle' },
		config = function()
			require('trouble').setup({
				position = 'right',
				width = 40,
			})

			-- Trouble must wrap 
			vim.api.nvim_create_autocmd({'BufWinEnter'},{
				callback = function(args)
					local widlist = require('util.windows').getWindowsDisplayingBuffers(args.buf)

					vim.schedule(function()
						for wid, _ in pairs(widlist) do
							vim.api.nvim_win_set_option(wid, 'wrap', true) end
					end)

					return true
				end})
		end},

	{ "matbme/JABS.nvim",																-- Just Another Buff Switcher
		cmd = 'JABSOpen',
		config = function()
			require('jabs').setup({
				width = 80,
				height = 15,
				border = 'single',

				keymap = {
					close			= 'q',
					jump			= '<CR>',
				},

				highlight = {
					current = 'JabsNormal',
					hidden  = 'JabsHidden',
					split   = 'JabsSplit',
					alternate = 'JabsAlternate',
				},

				symbols = {
					current = " ",
					split = " " ,
					alternate = " ",
					hidden = "﬘ ",
					locked = " ",
					ro = " ",
					edited = " ",
					terminal = " ",
					default_file = " "
				},
			})
		end},

	{ "kyazdani42/nvim-tree.lua", tag = 'nightly',			-- NERDTree
		config = function()
			local nt = require("nvim-tree")

			-- nt.remove_keymaps(true)

			nt.setup({
				remove_keymaps = true,
				filters = { custom = { "^.git$" } },
				view = {
					adaptive_size = false,
					width = 40,
					signcolumn = "no",
					mappings = {
						custom_only = false,
						list				= {
							{ key = "h", action = [[close_node]] },
							{ key = "l", action = [[edit]] },
							{ key = ">", action = [[cd]] },
							{ key = "<", action = [[dir_up]] },
							{ key = "r", action = [[rename]] },
							{ key = "dd", action = [[remove]] },
							{ key = "n", action = [[create]] },
							{ key = "q", action = [[close]] },
							{ key = "c", action = [[collapse_all]] },
							{ key = "C", action = [[expand_all]] },
							{ key = "R", action = [[refresh]] },
							{ key = "p", action = [[preview]] },
							{ key = "o", action = [[edit]] },
							{ key = "1", action = [[first_sibling]] },
							{ key = "$", action = [[last_sibling]] },
							{ key = "y", action = [[copy_name]] },
							{ key = "Y", action = [[copy_path]] },
						}

					}
				},

				renderer = {
					icons = {
						webdev_colors = false,
						padding = "  ",
						glyphs = {
							folder = {
								default = '',
								open = '',
							}
						}
					}
				}
			})
		end },

	{ "stevearc/dressing.nvim",														-- Input and Select UIs
		config = function()
			local load_once = false

			require('dressing').setup({
				input = {
					winblend = 30,
					relative = 'editor',
					border	= 'single',
					min_width = { 40, 0.4 },
					max_width = { 40, 0.4 },
				},
				select = {
					-- Load Telescope
					get_config = function(conf)
						-- Lazy load telescope on the first selection
						if not load_once then
								require('util.packer').loadPlugin('telescope.nvim')
							end
					end

				}
			})
		end },

	{ "ziontee113/icon-picker.nvim",
		requires = 'dressing.nvim',
		config = function()
			require("icon-picker").setup({
				disable_legacy_commands = true
			})
		end },


	{ "folke/which-key.nvim",
		config = function()
			require("which-key").setup {
				marks = false,
				registers = false,

				window = {
					border = "none", -- none, single, double, shadow
					position = "top", -- bottom, top
					margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
					padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
					winblend = 0
				},

				layout = {
					spacing = 2,
					align = "left",
					width = { min = 10, max = 50 },
					height = { min = 2, max = 20 }
				},

				popup_mappings = {
					scroll_up = "<PageUp>",
					scroll_down = "<PageDown>",
				},
			}
		end }
}
