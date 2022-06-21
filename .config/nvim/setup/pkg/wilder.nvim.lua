--
-- Wilder
-- Fuzzy finder for cmd, search and substitute
--
return { 'gelguy/wilder.nvim',
			--- Post installation hook
			-- run = vim.cmd([[
			-- 	let &rtp = &rtp
			-- 	UpdateRemotePlugins
			-- ]]),

			--- Requires rocks
			rocks = { 'pcre2'},
			run = ":UpdateRemotePlugins"

			--- Required packages
			requires = {
					{ 'nixprime/cpsm', run='./install.sh' },
					{ 'romgrk/fzy-lua-native' },
				},


			--- Configuration
			config = function()

				local wilder = require('wilder')
				wilder.setup({modes = {'/', '?', ':'}})

				local highlighters =
					{ wilder.lua_pcre2_highlighter(), wilder.lua_fzy_highlighter() }

				-- FIX: This has to be fixed
				-- No clue what is causing the problem...
				wilder.set_option('pipeline', {
						wilder.branch(
							wilder.python_file_finder_pipeline({
								file_command = function(_, arg)
									if vim.fn.stridx(arg, '.') ~= -1 then return {'fd', '-tf', '-H'} end
									return {'fd', '-tf'}
								end,
								dir_command = {'fd', '-td'},
								filters = {'cpsm_filter'}
							}),

							wilder.substitute_pipeline({
								pipeline = wilder.python_search_pipeline({
									skip_cmdtype_check = 1,
									pattern = wilder.python_fuzzy_pattern({ start_at_boundary = 0})
								})
							}),

							wilder.cmdline_pipeline({
								fuzzy = 1,
								fuzzy_filter = wilder.lua_fzy_filter()
							}),

							{
								wilder.check(function(_, x) return vim.fn.empty(x) end),
								wilder.history()
							},

							wilder.python_search_pipeline({
								pattern = wilder.python_fuzzy_pattern({ start_at_boundary = 0})
							})
						)


					})

				local popupmenu_renderer = wilder.popupmenu_renderer( wilder.popupmenu_border_theme({ 
						highlighter = highlighters,
						pumblend = 40,
						highlights = { accent = wilder.make_hl('WilderAccent', 'Pmenu', {{}, {}, {foreground = 'ff0000'}}) },
						border = 'single',
						min_width = '33%',
						reverse = 1,
						empty_message = wilder.popupmenu_empty_message_with_spinner()
					}))


				local wildmenu_renderer = wilder.wildmenu_renderer({
						highlighter = highlighters 
					})


				wilder.set_option('renderer', wilder.renderer_mux({
						[':'] = popupmenu_renderer,
						['/'] = wildmenu_renderer,
						['substitute'] = wildmenu_renderer,
					}))

			
				-- TOFIX: remove this 
				-- wilder.disable()


			end }
