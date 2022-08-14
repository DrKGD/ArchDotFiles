--
-- Telescope
-- Should I really explain what it does?
--
-- BUG: https://github.com/wbthomason/packer.nvim/pull/786 
return { 'nvim-telescope/telescope.nvim',
	after			=	{ 'utils.nvim' },
	requires = {
			{ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
			{ 'nvim-telescope/telescope-dap.nvim' },
			{ 'nvim-telescope/telescope-media-files.nvim' },
			{ 'nvim-telescope/telescope-frecency.nvim' },
			{ 'nvim-telescope/telescope-symbols.nvim' },
			{ 'nvim-telescope/telescope-packer.nvim' },
		},
	config = function()
		local tel = require('telescope')
		local act = require('telescope.actions')
		local path = require('utils.path')
		local e,s,a,w,i	= require('utils.message').setup('macro.lua')

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


		-- TODO: telescope find_files?
		local unbinded = function()
			print('Key not binded') end

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
				['<A-k>']				= unbinded,
				['<A-j>']				= unbinded,
				['<Up>']				= unbinded,
				['<Down>']			= unbinded,
				['<C-n>']				= unbinded,
				['<C-x>']				= unbinded,
				['<C-v>']				= unbinded,
				['<C-t>']				= unbinded,
				['<C-u>']				= unbinded,
				['<C-l>']				= unbinded,
				['<Tab>']				= unbinded,
				['<S-Tab>']			= unbinded,
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
				['<C-x>']				= unbinded,
				['<C-v>']				= unbinded,
				['<C-t>']				= unbinded,
				['<H>']					= unbinded,
				['<M>']					= unbinded,
				['<L>']					= unbinded,
				['<Tab>']				= unbinded,
				['<S-Tab>']			= unbinded,
			},
		}


		-- HACK: Disable those F@#$ING default HOTKEYS I cannot get used to
		local hijackHotkeys = function(prompt_bufnr, map, lambda)
			return function(prompt_bufnr, map)
				for mode, hotkeys in pairs(mappings) do
					for key, action in pairs(hotkeys) do
						map(mode, key, action)
					end
				end

				if lambda and type(lambda) == 'function' then
					return lambda() end

				return true
			end
		end

		tel.setup({
			defaults = {
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				set_env = { ["COLORTERM"] = "truecolor" },
				prompt_prefix 	= ' ',
				selection_caret	= '  ',
				entry_prefix		= ' ',
				scroll_strategy	= 'cycle',
				-- entry_prefix		= '● ',
				-- set_env = { ['COLORTERM'] = 'truecolor' },
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
				fzf = {
					fuzzy = true,
					override_generic_sorter=false,
					override_file_sorter=true,
					case_mode = "smart_case",
				},

				fzf_writer	= {
					use_highlighter = false,
					minimum_grep_characters = 3,
					minimum_files_characters = 2,
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

		--- Load extensions
		tel.load_extension('fzf')
		--tel.load_extension('projects')
		tel.load_extension('frecency')
		tel.load_extension('media_files')
		-- DISABLED:
		-- require('telescope').load_extension('goimpl')
		-- require('telescope').load_extension('dap')

		_G.CSTelescope = {}
		CSTelescope.symbols		= function()
			local lup = {
				markdown	=	function() return {'emoji', 'gitemoji'} end,
				tex				= function() return {'latex'} end,
				lua				= function() return {'emoji', 'gitemoji', 'kaomoji'} end,
				default		= function() return {'kaomoji'} end,
			}

			return require('telescope.builtin').symbols({
				layout_config = { width = 0.5 },
				layout_strategy = 'vertical',
				source = (lup[vim.bo.filetype] or lup.default)()
			})
		end

		CSTelescope.projects		= function()
			return require('telescope').extensions.projects.projects({
				layout_config = { width = 0.4 },
				layout_strategy = 'vertical',
				attach_mappings = hijackHotkeys(prompty_bufnr, map)
			})
		end

		-- Use the file inside the current folder to detect with files to ignore
		CSTelescope.wrap				= function(tbl, prompt)
			if not tbl then return e("No table selected!") end
			if not prompt then return e("No promprt selected!") end
			local ignore_table = ignore
			local ppath = vim.fn.getcwd() .. "/.telescope.lua"

			if path.fileExists(ppath) then
				local settings = require('util.generic').lodTable(ppath)
				ignore_table = vim.tbl_deep_extend("force", ignore_table, settings or {})
			end

			print(vim.inspect(ignore_table))

			return require(tbl)[prompt]({
				file_ignore_patterns = ignore_table,
			})
		end

		local bind = require('utils.wrap').bind

		--- Telescope global
		bind({ noremap = true}, 'n', '?>', ':lua custom.telescope.config()<CR>')

		-- Browser file, grep
		bind({ noremap = true}, 'n', '<Leader><Tab>',	':Telescope buffers<CR>')
		bind({ noremap = true}, 'n', '<Leader>.', ':lua CSTelescope.wrap("telescope.builtin", "find_files")<CR>')
		bind({ noremap = true}, 'n', '<Leader>ff', ':Telescope find_files<CR>')
		bind({ noremap = true}, 'n', '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>')
		bind({ noremap = true}, 'n', '<Leader>fs', ':Telescope live_grep<CR>')

		-- Browser git 
		bind({ noremap = true}, 'n', '<Leader>gs', ':Telescope git_status<CR>')
		bind({ noremap = true}, 'n', '<Leader>gc', ':Telescope git_commits<CR>')

		-- TODO: Rework this
		bind({ noremap = true}, 'n', '<Leader>fcg',		':lua custom.telescope.config()<CR>')

		-- Frecency, Symbols, Yank
		bind({ noremap = true}, 'n', '<Leader>f\\',	':Telescope frecency<CR>')
		bind({ noremap = true}, 'n', '<Leader>`', ':lua CSTelescope.symbols()<CR>')
		bind({ noremap = true}, 'n', '<Leader>=', ':Telescope neoclip<CR>')

		-- Todo in Telescope
		bind({ noremap = true}, 'n', '<Space>todo', ':TodoTelescope<CR>')

		-- Projects
		-- bind({ noremap = true}, 'n', '<Leader>j', ':lua CSTelescope.projects()<CR>')

		-- Help
		bind({ noremap = true}, 'n', '<Leader>ht', ':Telescope help_tags<CR>')
		bind({ noremap = true}, 'n', '<Leader>hk', ':Telescope keymaps<CR>')
		bind({ noremap = true}, 'n', '<Leader>hc', ':Telescope commands<CR>')
		bind({ noremap = true}, 'n', '<Leader>hp', ':lua require("telescope").extensions.packer.plugins()<CR>')
		bind({ noremap = true}, 'n', '<Leader>hT', ':Telescope builtin<CR>')
	end }
