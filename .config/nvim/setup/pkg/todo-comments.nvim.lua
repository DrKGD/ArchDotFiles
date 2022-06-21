--
-- Todo-comments
-- TODO: Does this have any effect?
--
return { 'folke/todo-comments.nvim',
	config = function()
		local C = PREFERENCES.misc.colors
		local mix	= require('utils.modx').mix

		local darken = function(c) return mix(c, '#000000', 0.85) end


		require("todo-comments").setup({
			keywords = {
				-- FIX: testing
				FIX		= {
					icon	= ' ',
					color = darken(C.orange),
					alt		= { 'FIXED', 'BUG', 'ISSUE', 'FIXME', 'TOFIX' }
				},
	
				-- TODO: testing
				TODO	= {
					icon	= ' ',
					color = darken(C.naplesyellow),
					alt		= {'NOT_IMPLEMENTED', 'WIP', 'WORK_IN_PROGRESS'}
				},

				-- HACK: testing
				HACK	= {
					icon	= 'ﮏ ',
					color	= darken(C.green),
					alt		= {'HAX'}
				},

				-- WARNING: testing
				WARNING	= {
					icon	= ' ',
					color	= darken(C.yellow),
					alt		= {'WARN','ERROR'}
				},

				-- DISABLED: testing
				DISABLED = {
					icon  = ' ',
					color = darken(C.cherryred),
					alt		= {'EXCL', 'ABORT', 'TRAP'}
				},

				-- OPTIMIZE: Optimize
				OPTIMIZE = {
					icon	= ' ',
					color	= darken(C.turquoise),
					alt		= {'API', 'ENHANCE', 'OPT', 'SPEED', 'PERFORMANCE', 'EXTEND'}
				},

				-- NOTE: testing
				NOTE		= {
					icon	= ' ',
					color	= darken(C.powder),
					alt		= {'INFO', 'EXPERIMENTAL', 'N.B.'}
				},

				-- TEST: testing
				TEST		= {
					icon  = ' ',
					color	= darken(C.naplesyellow),
					alt		= {'TESTCASE'}
				},

				-- THANKS:testing
				THANKS = {
					icon  = ' ',
					color	= darken(C.pink),
					alt		= {'THX', 'REF'}
				}
			}
		})
	end}

