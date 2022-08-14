--
-- Wilder 
--  Command line has never been better 
--
return { "gelguy/wilder.nvim",
	rocks = { 'pcre2' },
	requires = { 'romgrk/fzy-lua-native' },
	event = 'CmdlineEnter',
	run = ":UpdateRemotePlugins",
	config = function()
		-- Initial setup
		local w = require('wilder')
		w.setup({modes = { '/', '?', ':'}})

		-- Available highlighters
		local hi =
			{ w.lua_pcre2_highlighter(), w.lua_fzy_highlighter() }

		local colors =  {
			default = 'WilderMenu',
			selected = 'WilderSelected',
			accent = 'WilderAccent',
			selected_accent = 'WilderSelectedAccent',
			error = 'WilderEmpty',
			empty_message = 'WilderEmpty'
		}

		local popup_renderer = w.popupmenu_renderer(
			w.popupmenu_palette_theme({
				-- pumblend = 40,
				highlighter = hi,
				highlights  = colors,

				left = {w.popupmenu_devicons(), '  '},
				right = {w.popupmenu_scrollbar()},

				border = 'single',
				max_height = '30%',
				min_height = '30%',
				prompt_position = 'top',
			})
		)

		local wildmenu_renderer = w.wildmenu_renderer({
			highlighter = hi
		})


		w.set_option('renderer', w.renderer_mux({
			[':'] = popup_renderer,
			['/'] = wildmenu_renderer,
			['?'] = wildmenu_renderer,
			['substitute'] = wildmenu_renderer
		}))

	end }
