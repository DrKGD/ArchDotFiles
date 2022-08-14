--
-- Language Server Protocol
--  configuration(s)
--
return {
	{ "neovim/nvim-lspconfig",																-- LSP
		-- Installer(s)
		requires = {
				-- Configurators and installers
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				-- UI
				{ "glepnir/lspsaga.nvim", branch = 'main' },
				"SmiteshP/nvim-navic",

				-- Enhance menu
				"onsails/lspkind.nvim",

				-- Completion engine
				'hrsh7th/nvim-cmp',

				-- Sources
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',
				'hrsh7th/cmp-emoji',
				'f3fora/cmp-spell',
				'hrsh7th/cmp-nvim-lsp-signature-help',
				'ray-x/cmp-treesitter',

				-- Snip engine
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',
			},
		config = function()
			require('mason').setup()

			-- Install LSP Servers
			require('mason-lspconfig').setup({
					ensure_installed = PREFERENCES.mason.lsp
				})

			-- Install Tools  (DAPs, Linters, Formatters)
			require('mason-tool-installer').setup({
					ensure_installed = PREFERENCES.mason.tools,
					auto_update = false,
					run_on_start = false
				})

			-- LSPSaga configuration
			-- local saga = require('lspsaga')
			-- saga.init_lsp_saga({
			-- 	saga_winblend = 30,
			-- 	move_in_saga = { prev = '<C-e>', next = '<C-d>' },
   --
			-- 	code_action_icon = '💡',
			-- 	code_action_lightbulb = {
			-- 		enable = true,
			-- 		sign = false,
			-- 		enable_in_insert = true,
			-- 		virtual_text = true
			-- 	}
   --
			-- })

			-- Navic for treesitter nodes
			local navic = require('nvim-navic')
			navic.setup({
					icons = {
						File          = "  ",
						Module        = "  ",
						Namespace     = "  ",
						Package       = "  ",
						Class         = "  ",
						Method        = "  ",
						Property      = "  ",
						Field         = "  ",
						Constructor   = "  ",
						Enum          = "練 ",
						Interface     = "練 ",
						Function      = "  ",
						Variable      = "  ",
						Constant      = "  ",
						String        = "  ",
						Number        = "  ",
						Boolean       = "◩  ",
						Array         = "  ",
						Object        = "  ",
						Key           = "  ",
						Null          = "ﳠ  ",
						EnumMember    = "  ",
						Struct        = "  ",
						Event         = "  ",
						Operator      = "  ",
						TypeParameter = "  ",
					},

					highlight = false
				})

			-- RTPs
			local runtime_path = vim.split(package.path, ';')
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")

			-- Table of configurations
			local langs = {
				["sumneko_lua"] = {
						settings = {
							Lua = {
								runtime = { version = 'LuaJIT', path = runtime_path },
								diagnostics = { globals = {'vim' } },
								workspace = { library = vim.api.nvim_get_runtime_file("", true) },
								telemetry = { enable = false },
							}
						}
					}
				}

			-- Key configuration
			local m		= require('mapx')
			local fn	= require('util.generic').fn
			local cmd = require('util.generic').cmd
			local attach		= function(client, bufnr)
			local a= " this is a string:?"
				-- ('n', '<space>a', vim.lsp.buf.code_action, bufopts)
				m.group("silent", { buffer = bufnr }, function()
					-- m.nmap('<space>a', cmd 'Lspsaga code_action')
					-- m.nmap('K', cmd 'Lspsaga hover_doc')
					-- m.nmap('gr', cmd 'Lspsaga rename')
					-- m.nmap('gh', cmd 'Lspsaga rename')

				end)

				navic.attach(client, bufnr)
			end

			-- Setup completion engine
			local cmp		= require('cmp')
			local snip  = require('luasnip')

			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local prev_is_whitespace = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 or vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
			end

			-- Configure cmp
			cmp.setup({
				min_length = 1,
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) end
				},

				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 30 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						local source = ({
							buffer		= "  BUF ",
							spell			= "  CHK ",
							path			= " PATH ",
							nvim_lsp	= "  LSP ",
							nvim_lua 	= "  LUA ",
							calc			= " CALC ",
							emoji			= " EMOJ ",
							luasnip		= " SNIP ",
							treesitter= " TREE "
						})[entry.source.name]

						kind.kind = string.format(" %s  ", strings[1])
						kind.menu = string.format("%s%s", source or 'NOT LISTED', strings[2])

						return kind
					end,
				},

				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = 0,
						side_padding = 0,
					},
				},

				mapping = {
					-- Select next item 
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						elseif snip.expand_or_jumpable() then
							snip.expand_or_jump()
						else fallback() end
					end, { 'i', 's', 'c'}),

					-- Select prev item 
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
						elseif snip.jumpable(-1) then
							snip.jump(-1)
						else fallback() end
					end, { 'i', 's', 'c'}),

					-- Expand/Accept the current match
					["<C-Space>"] = cmp.mapping.confirm(
						{ behavior = cmp.ConfirmBehavior.Insert, select = true }),
				},

				enabled = function()
					-- Disable completion for command mode
					if vim.api.nvim_get_mode().mode == 'c' then
						return false end

					-- Disable in comment contexts 
					local context = require 'cmp.config.context'
					if context.in_treesitter_capture('comment') or context.in_syntax_group('Comment') then
						return false end

					-- if context.in_treesitter_capture('string') or context.in_syntax_group('Strings'") then
					-- 	return false end

					return true
				end,

				sources = cmp.config.sources ({ -- Snippets and lsp
					{ name = 'luasnip', priority = 100},
					{ name = 'nvim_lsp', priority = 99 },
					{ name = 'nvim_lsp_signature_help', priority = 98 },
					{ name = 'spell', priority = 97},												-- Only enabled when spell is
				},{ -- Buffer and path 
					{ name = 'buffer'},
					{ name = 'path'},
				})
			})

			-- Setup lspconfig
			local cp = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
			local common		= { on_attach = attach, flags = { debounce_text_changes = 150 }, capabilities = cp }

			require('mason-lspconfig').setup_handlers({
				function(server)
					local cfg = vim.tbl_deep_extend("force", common, langs[server] or {})
					require('lspconfig')[server].setup(cfg)
				end,
			})

			-- Setup gutter signs for diagnostics
			vim.fn.sign_define('DiagnosticSignError', { text = 'ﲅ ', texthl='DiagnosticSignError'})
			vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl='DiagnosticSignWarn'})
			vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl='DiagnosticSignInfo'})
			vim.fn.sign_define('DiagnosticSignHint', { text = ' ', texthl='DiagnosticSignHint'})
		end },

	-- ENHANCE: Not really found an use for it yet
	{ "mfussenegger/nvim-lint",															-- Additional Linters
		opt = true,
		config = function()
			require('lint').linters_by_ft = {

			}

		end },

	{ "mhartington/formatter.nvim",													-- Formatters
		opt = true,
		event = 'BufWritePre',
		config = function()
			require('formatter').setup({
				filetype = {
					-- Remove trailing whitespaces
					["*"] =
						{ require('formatter.filetypes.any').remove_trailing_whitespace }
				},
			})

			-- Enable formatting on save
			-- vim.api.nvim_create_autocmd("BufWritePost", { command = 'FormatWrite'})
		end },


	{ "mfussenegger/nvim-dap",															-- Debug Adapter(s)
		opt = true,
		config = function()
			vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
	vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
	vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
	vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
	vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })


		end },
}
