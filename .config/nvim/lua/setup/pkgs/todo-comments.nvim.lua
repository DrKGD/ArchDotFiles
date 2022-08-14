--
-- Todo-comments
-- TODO: If you can see this, grats this plugin is active and running!
--
return { 'folke/todo-comments.nvim',
	event	= "BufRead",
	config = function()
		require("todo-comments").setup({
			keywords = {
				-- FIX: testing
				FIX		= {
					icon	= ' ',
					color = '#FF9507',
					alt		= { 'FIXED', 'BUG', 'ISSUE', 'FIXME', 'TOFIX' }
				},

				-- TODO: testing
				TODO	= {
					icon	= ' ',
					color = '#FFDF64',
					alt		= {'NOT_IMPLEMENTED', 'WIP', 'WORK_IN_PROGRESS'}
				},

				-- HACK: testing
				HACK	= {
					icon	= 'ﮏ ',
					color	= '#17FF7c',
					alt		= {'HAX'}
				},

				-- WARNING: testing
				WARNING	= {
					icon	= ' ',
					color	= '#DBED00',
					alt		= {'WARN','ERROR'}
				},

				-- DISABLED: testing
				DISABLED = {
					icon  = ' ',
					color = '#FD5D88',
					alt		= {'EXCL', 'ABORT', 'TRAP'}
				},

				-- OPTIMIZE: Optimize
				OPTIMIZE = {
					icon	= ' ',
					color	= '#179AFF',
					alt		= {'API', 'ENHANCE', 'OPT', 'SPEED', 'PERFORMANCE', 'EXTEND'}
				},

				-- NOTE: testing
				NOTE		= {
					icon	= ' ',
					color	= '#FFFFFF',
					alt		= {'INFO', 'EXPERIMENTAL', 'N.B.'}
				},

				-- TEST: testing
				TEST		= {
					icon  = ' ',
					color	= '#DBED00',
					alt		= {'TESTCASE'}
				},

				-- THANKS:testing
				THANKS = {
					icon  = ' ',
					color	= '#FD5DBB',
					alt		= {'THX', 'REF'}
				}
			}
		})
	end }


