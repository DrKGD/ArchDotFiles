--
-- LSP
-- Handler and its configuration
--
return { 'neovim/nvim-lspconfig',
	requires = {
			-- Side panel with file informations
			-- TODO: Keybindings setup
			{ 'ldelossa/litee-symboltree.nvim'},
			{ 'ldelossa/litee-filetree.nvim'},
			{ 'ldelossa/litee-calltree.nvim' },
			{ 'ldelossa/litee-bookmarks.nvim'},
			{ 'ldelossa/litee.nvim' },
			-- Installer
			{ 'williamboman/nvim-lsp-installer' },
			-- Side Pannel
			{ 'litee.nvim' },
			-- Completer
			{ 'ms-jpq/coq_nvim', branch = 'coq', run = ':COQdeps'},
			{ 'ms-jpq/coq.artifacts', branch = 'artifacts'},
			{ 'ms-jpq/coq.thirdparty', branch = '3p'},
			-- LSPColors to support more themes
			{ 'folke/lsp-colors.nvim' },
			-- TODO: Requires keybinding setup(s), LSPSaga
			{ 'tami5/lspsaga.nvim' },
			-- Add pictograms to completer
			{ 'onsails/lspkind-nvim' },
			-- Show diagnostics
			{ 'folke/trouble.nvim'},
			-- -- TODO: Requires setup
			-- { 'simrat39/symbols-outline.nvim' },
			-- Show annotation
			{ 'jubnzv/virtual-types.nvim' },
		},
	after = { 'utils.nvim', 'nvim-autopairs'},
	config = function()

		vim.g.coq_settings = {
			auto_start = 'shut-up',

			-- clients = {
			-- 	-- I don't even know what tabnine is about
			-- 	tabnine			= {
			-- 		enabled		= false
			-- 	},
			-- 	buffers			= {
			-- 		enabled = true,
			-- 		weight_adjust = -1.9
			-- 	},
			-- 	tree_sitter	= {
			-- 		enabled = true,
			-- 		weight_adjust = -1.9
			-- 	},
			-- 	lsp					= {
			-- 		enabled = false,
			-- 		weight_adjust = 1.5
			-- 	},
			-- 	snippets = {
			-- 		enabled = true,
			-- 		weight_adjust = 1.9
			-- 	}
			-- },

			

			display = {
				pum = {
					fast_close = false
				},

				ghost_text = {
					enabled = false
				},

				icons = {
					mode = 'short'
				}
			},

			match = {
				max_results = 50
			},


			limits = {
				completion_auto_timeout = 10.0,
				idle_timeout = 1000,
			},


			keymap	= {
				['pre_select']	= true,
				recommended			= false,
				jump_to_mark		=	'<C-Space>',
				-- WARNING: DO NOT CHANGE THOSE, BUGGED AS HELL
				manual_complete = '',
				bigger_preview	=	''
			}--,
		}


		local coq = require('coq')
		local pairs = require('nvim-autopairs')
		local flags = { noremap = true, expr = true, silent = true }
		local bind = require('utils.wrap').bind

		-- Scroll list with C-e, C-d
		bind(flags, 'i', '<C-e>',
			[[pumvisible() ? "<C-p>" : "<C-e>"]])

		bind(flags, 'i', '<C-d>',
			[[pumvisible() ? "<C-n>" : "<C-d>"]])

		-- Return to normal mode
		bind(flags, 'i', '<Esc>',
			[[pumvisible() ? "<C-e><Esc>" : "<Esc>"]])

		-- Have no idea, maybe 'cancels' something?
		-- Otherwise virtual text doesn't get deleted
		bind(flags, 'i', '<C-c>',
			[[pumvisible() ? "<C-e><C-c>" : "<C-c>"]])

		-- Enter does not complete
		bind(flags, 'i', '<CR>',
			[[pumvisible() ? "<C-e><CR>" : "<CR>"]])

		-- C-Enter to complete (NL or F36)
		bind(flags, 'i', '<NL>',
			"v:lua.require('utils.shenanigans').CR()")
		bind(flags, 'i', '<F36>',
			"v:lua.require('utils.shenanigans').CR()")

		-- Backspace also deletes lone parenthesis
		bind(flags, 'i', '<BS>',
			"v:lua.require('utils.shenanigans').BS()")

		local lspconfig = require('lspconfig')
		local lspinstall = require('nvim-lsp-installer')
		local reqservers = {'sumneko_lua', 'clangd', 'texlab' }

		-- RTPs
		local runtime_path = vim.split(package.path, ';')
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		--- Install servers
		for _, s in ipairs(reqservers) do
			local found, requested = lspinstall.get_server(s)

			-- If server does not exist
			if not found then
				print(string.format('Could not get the requested lsp-server [%s]', s))
			-- If server exists and it is not installed
			elseif not requested:is_installed() then
				requested:install()
			end
		end

		--- On attach event
		local on_attach = function(client, bufnr)
			local bind_to = require('utils.wrap').bind_to

			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gr', ':lua vim.lsp.buf.references()<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gf', ':lua vim.lsp.buf.formatting()<CR>')

			-- LSP Saga
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gn', ':Lspsaga rename<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', '<Space>a', ':Lspsaga code_action<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'v', '<Space>a', ':Lspsaga range_code_action<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'go', ':Lspsaga show_line_diagnostics<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gj', ':Lspsaga diagnostic_jump_next<CR>')
			bind_to(bufnr, { silent = true, noremap = true }, 'n', 'gk', ':Lspsaga diagnostic_jump_prev<CR>')

			-- Bind virtual types
			require('virtualtypes').on_attach()
		end

		-- Ready servers
		local opts = {}
		opts.sumneko_lua = {
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = {
						version = 'LuaJIT',
						path = runtime_path,
					},
					diagnostics = {
						globals = {'vim'},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}

		opts.clangd = {
			on_attach = on_attach,
			cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
			},
			filetypes = {"c", "cpp", "objc", "objcpp"},
		}

		-- local opts = {
		-- 	['sumneko_lua'] = { 
		-- 		settings = { 
		-- 			Lua = {
		-- 			runtime = { version = 'LuaJIT', path = runtime_path },
		-- 			diagnostics = { globals = {'vim'} },
		-- 			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
		-- 			telemetry = { enable = false },
		-- 	}}},
		-- }

		lspinstall.on_server_ready(function(server)
			local default = { on_attach = on_attach }
			
			if opts[server.name] then
				default = opts[server.name]
			end

			server:setup(default)
		end)

		lspconfig.html.setup{}

		-- LSP Saga
		require('lspsaga').setup()

		-- Trouble
		require('trouble').setup()

		bind({ noremap = true }, 'n', '<Space><Space>T', ':TroubleToggle<CR>')

		-- Symbols for the autocompleter
		require('lspkind').init()

		-- Symbols outliner
		vim.g.symbols_outline = {
			position = 'left',
			width = 70,
			relative_width = false,
		}

		bind({ noremap = true }, 'n', '<Space><Space>S', ':SymbolsOutline<CR>')

		require('litee.lib').setup()
		require('litee.calltree').setup()
		require('litee.symboltree').setup()
		require('litee.filetree').setup()
	end }
