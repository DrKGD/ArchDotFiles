--
-- Telescope
-- Should I really explain what it does?
--
-- BUG: https://github.com/wbthomason/packer.nvim/issues/776
return { 'nvim-telescope/telescope.nvim',
	cmd = { 'Telescope', 'TSFindFiles' },
	requires = {
		-- Once telescope loads, these loads
		{ "chip/telescope-software-licenses.nvim", opt = true, disable = BOOTSTRAP_GUARD  },
		{ "nvim-telescope/telescope-fzy-native.nvim", opt = true, disable = BOOTSTRAP_GUARD },
		{ "nvim-telescope/telescope-ui-select.nvim", opt = true, disable = BOOTSTRAP_GUARD }
	},

	config = function()
		local pload = require('util.packer').loadPlugin
		pload('telescope-software-licenses.nvim')
		pload('telescope-fzy-native.nvim')
		pload('telescope-ui-select.nvim')


		local ts		= require('telescope')
		local act		= require('telescope.actions')

		-- Unbinded function lambda
		local unbinded = function(key)
				return function() vim.notify(string.format("Key %s is disabled!", key), 'warn', { render = "minimal"}) end
			end

		local readline = require('readline')
		local mappings = {
			i = {
				['<C-g>']				= act.move_to_top,
				['<C-S-g>']			= act.move_to_bottom,
				['<A-e>']				= act.file_edit,
				['<CR>']				= act.select_default,
				['<C-e>']				= act.move_selection_previous,
				['<C-d>']				= act.move_selection_next,
				['<PageUp>']		= act.preview_scrolling_up,
				['<PageDown>']	= act.preview_scrolling_down,
				['<C-q>']				= act.close,
				['<C-a>']				= act.file_edit,

				-- Disabled
				['<A-k>']				= unbinded '<A-k>',
				['<A-j>']				= unbinded '<A-j>',
				['<Up>']				= unbinded '<Up>',
				['<Down>']			= unbinded '<Down>',
				['<C-n>']				= unbinded '<C-n>',
				['<C-x>']				= unbinded '<C-x>',
				['<C-v>']				= unbinded '<C-v>',
				['<C-t>']				= unbinded '<C-t>',
				['<C-u>']				= readline.backward_kill_line,
				['<C-l>']				= readline.kill_line,
				['<Tab>']				= readline.end_of_line,
				['<S-Tab>']			= readline.beginning_of_line,
				['<C-V>']				= unbinded '<C-v>',
			},

			n = {
				['gg']					= act.move_to_top,
				['G']						= act.move_to_bottom,
				['<A-e>']				= act.file_edit,
				['<C-e>']				= act.file_edit,
				['k']						= act.move_selection_previous,
				['j']						= act.move_selection_next,
				['<PageUp>']		= act.preview_scrolling_up,
				['<PageDown>']	= act.preview_scrolling_down,
				['<A-k>']				= act.preview_scrolling_up,
				['<A-j>']				= act.preview_scrolling_down,
				['<Up>']				= act.preview_scrolling_up,
				['<Down>']			= act.preview_scrolling_down,
				['<ESC>']				= act.close,
				['<C-q>']				= act.close,

				-- Disabled
				['<C-x>']				= unbinded '<C-x>',
				['<C-v>']				= unbinded '<C-v>',
				['<C-t>']				= unbinded '<C-t>',
				['<H>']					= unbinded '<H>',
				['<M>']					= unbinded '<M>',
				['<L>']					= unbinded '<L>',
				['<Tab>']				= unbinded '<Tab>',
				['<S-Tab>']			= unbinded '<S-Tab>',
			},
		}

		local grep = {
			'rg',
			'--color=never',
			'--hidden',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case',
			'--unrestricted',
			'--unrestricted',
		}

		local find = {
			'fd',
			'--hidden',
			'--no-ignore',
			'--type',
			'f',
			'--strip-cwd-prefix'
		}

		local ignore = {
			-- Project Folders
			".git$",																	-- Ignore git file
			".git[/\\]",															-- Ignore git folder
			"exe[/\\]", "build[/\\]", "bin[/\\]",			-- Ignore executable folders
			"obj[/\\]", "rocks[/\\]", "lib[/\\]",			-- Ignore compiled and external libraries

			-- Non-Specic sub folders
			"fonts[/\\]",															-- Ignore fonts folder
			"share[/\\]",															-- Ignore share temporary file folder
			"spell[/\\]", ".bak[/\\]",
			".swap[/\\]",															-- Ignore vim specific folders

			"nlsp-settings[/\\]",											-- Ignore nlsp-settings "plugin" folder
			"packer_compiled.lua",										-- Ignore this file

			-- Filetypes
			".pdf$", ".docx$", ".xls$",								-- Compressed documents
			".zip$", ".rar$", ".tar$",								-- Archives
			".o$", ".d$", ".class$",									-- Hide compilation objects
			".secret$",																-- Hidden
			".exe$",																	-- Executables
			".png$", ".jpg$", ".jpeg$", ".gif$",			-- Image Media
			".webp$", ".mp3$", ".wav$", ".flac$",			-- Audio Media
			".mp4$", ".vlc$", ".mkv$",								-- Video Media
		}

		ts.setup({
			defaults = {
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				set_env = { ["COLORTERM"] = "truecolor" },
				prompt_prefix 	= ' ',
				selection_caret	= '  ',
				entry_prefix		= '  ',
				scroll_strategy	= 'cycle',
				layout_strategy = 'flex',
				layout_config = {
					horizontal	= { width = 0.85, height = 0.85, prompt_position = "bottom", preview_width = 0.65 },
					vertical		= { width = 0.80, height = 0.95 },
					flex				= { flip_columns = 140 } ,
				},


				mappings = mappings
			},

			pickers = {
				buffers = {
					sort_lastused = true,
				},

				find_files = {
					file_ignore_patterns = ignore,
					find_command = find
				},

				live_grep = {
					file_ignore_patterns = ignore,
					vimgrep_arguments = grep
				},

				current_buffer_fuzzy_find = {
					previewer = false
				},

				builtin = {
					previewer = false,
					include_extensions = true,
					layout_config = { width = 0.25 },
					layout_strategy = 'vertical'
				},

				file_browser = {
					-- attach_mappings = hijackHotkeys(prompt_bufnr, map)
					mappings = mappings
				},
			},

			file_sorter = require'telescope.sorters'.get_fuzzy_file,

			extensions = {
				fzy_native = {
					override_generic_sorter = true,
					override_file_sorter = true,
        },

				["ui-select"] = {
					require("telescope.themes").get_dropdown({

					})
				},


				-- NOTE: Previewer only works on Xorg
				media_files = {
					filetypes = {"png", "webp", "jpg", "jpeg", "pdf", "mp4", "ttf"},
					find_cmd = "rg"
				},

				-- Frequent files setup
				frecency		= {
					show_scores			= true,
					show_unindexed	= true,
					ignore_patterns = ignore
				},
			},
		})

		-- Load extensions
		pcall(ts.load_extension, "fzy_native")
		pcall(ts.load_extension, "ui-select")

		-- Register custom pickers
		local lodTable		= require('util.generic').lodTable
		local reconfigure = require('plug.telescope').reconfigure
		vim.api.nvim_create_user_command('TSFindFiles',
			function() reconfigure('telescope.builtin', 'find_files', lodTable(vim.fn.getcwd() .. '/.telescope.lua')) end, {})
	end
}
