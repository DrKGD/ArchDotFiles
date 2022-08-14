--
-- indent-blankline
-- Indentation characters before
--
return { "lukas-reineke/indent-blankline.nvim",
	after	 = 'utils.nvim',
	-- BUG: Wezterm flickers the screen in visual mode, no questions asked: gotta disable it
	disable = true,
	config = function()
		local qf				= 0.60
		local setHi			= require('utils.modx').setHi
		local mix				= require('utils.modx').mix
		local modx			= require('utils.modx')
		local fc1				= mix(PREFERENCES.misc.colors.orange, '#000000', qf)
		local fc2 			= mix(PREFERENCES.misc.colors.blue, '#000000', qf)

		setHi({
			IndentBlanklineIndent1			= { guifg = fc1},
			IndentBlanklineIndent2 			= { guifg = fc2},
			IndentBlanklineContextChar	= { guifg = PREFERENCES.misc.colors.green }
		})

		require('indent_blankline').setup({
			space_char_blankline = " ",
			show_current_context = true,
			-- char_highlight_list = {
			-- 	"IndentBlanklineIndent1",
			-- 	"IndentBlanklineIndent2",
			-- },
			-- space_char_highlight_list = {
			-- 	"IndentBlanklineIndent1",
			-- 	"IndentBlanklineIndent2",
			-- },
			show_trailing_blankline_indent = false,
		})
	end }
