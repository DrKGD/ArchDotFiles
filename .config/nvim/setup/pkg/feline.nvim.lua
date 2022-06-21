--
-- Feline
-- Statusline configuration
--
return { 'famiu/feline.nvim',
	after	 = 'utils.nvim',
	config = function()

		local setHi			= require('utils.modx').setHi
		local mix				= require('utils.modx').mix
		local modx			= require('utils.modx')
		local procolor	= PREFERENCES.misc.colors
		local jobmake		= require('utils.job').make
		local timermake = require('utils.timer').make

		local conf = {
			-- Exclude these file
			force_inactive = {
				filetypes				= {
					"NvimTree",
					"dashboard",
					"dbui",
					"packer",
					"startify",
					"fugitive",
					"fugitiveblame",
					"Trouble",
					"	lir",
					"TelescopePrompt",
					"harpoon"
				},

				buftypes				= {
					"^terminal$",
				},

				bufnames				= {
				},
			},

			-- Set vi mode colors
			vi_mode_colors	= {
				NORMAL 				= 'white',
				OP 						= 'white',
				INSERT 				= 'red',
				VISUAL 				=	'turk',
				BLOCK 				= 'turk',
				REPLACE 			= 'violet',
				['V-REPLACE'] = 'violet',
				ENTER 				= 'blue',
				MORE 					= 'blue',
				SELECT				= 'orange',
				COMMAND 			= 'green',
				SHELL 				= 'green',
				TERM 					=	'green',
				NONE 					= 'black'
			},

			-- Components
			components			= {
				active		= { {}, {}, {}},
				inactive		= { {}, {}, {}}
			},

			-- Colors
			theme = {
				green		= mix(procolor.green,	'#000000', 0.35	),
				dgreen	= mix(procolor.green,  '#000000', 0.12	),
				lblue		= mix(procolor.blue,  '#FFFFFF', 0.5	),
				blue		= mix(procolor.blue,  '#000000', 0.4	),
				mblue		= mix(procolor.blue, '#000000', 0.25	),
				dblue		= mix(procolor.blue, '#000000', 0.10	),
				lred		= mix(procolor.cherryred,	'#FFFFFF', 0.5	),
				red			= mix(procolor.cherryred,	'#000000', 0.9	),
				mred		= mix(procolor.cherryred,	'#000000', 0.5	),
				dred		= mix(procolor.cherryred,	'#000000', 0.2	),
				violet	= mix(procolor.violet, '#000000', 0.9	),
				lorange	= mix(procolor.orange, '#FFFFFF', 0.4	),
				orange	= mix(procolor.orange, '#000000', 0.9	),
				dorange	= mix(procolor.orange, '#000000', 0.2	),
				turk		= mix(procolor.turquoise,	'#000000', 0.9	),
				dturk		= mix(procolor.turquoise,	'#000000', 0.25	),
				marc		= mix('#860050',	'#000000', 0.25	),
				lgray		= mix('#FFFFFF',	'#000000', 0.35	),
				gray		= mix('#FFFFFF',	'#000000', 0.10	),
				mgray		= mix('#FFFFFF',	'#000000', 0.05	),
				white		= '#FFFFFF',
				black		= '#121212',

				-- Text color
				fg				= 'white',

				-- Background color
				bg				= 'NONE',
				
				-- Primary color
				primary		= 'green',
			},

			-- Custom providers
			custom_providers = {},
		}

		local function new(name, lambda)
			conf.custom_providers[name] = lambda
		end

		new('getExtension', function(c)
			local file = vim.fn.expand('%')
			local fn	 = vim.fn.fnamemodify(file, ':t')
			local ext	 = vim.bo.filetype
			local icon = require('nvim-web-devicons').get_icon(fn, ext, {default = true})

			return string.format('%s%s%s', icon, ' ', ext:upper())
		end)

		local mode_alias = {
			['n']			= 'NORMAL',
			['no']		= 'OP',
			['nov'] 	= 'OP',
			['noV'] 	= 'OP',
			['no']	= 'OP',
			['niI']		= 'NORMAL',
			['niR'] 	= 'NORMAL',
			['niV'] 	= 'NORMAL',
			['v']			= 'VISUAL',
			['V'] 		= 'LINES',
			['']		= 'BLOCK',
			['s']			= 'SELECT',
			['S'] 		= 'SELECT',
			['']		= 'BLOCK',
			['i']			= 'INSERT',
			['ic']		= 'INSERT',
			['ix'] 		= 'INSERT',
			['R']			= 'REPLACE',
			['Rc']		= 'REPLACE',
			['Rv'] 		= 'V-REPLACE',
			['Rx'] 		= 'REPLACE',
			['c']			= 'COMMAND',
			['cv']		= 'COMMAND',
			['ce']		= 'COMMAND',
			['r']			= 'ENTER',
			['rm']		= 'MORE',
			['r?']		= 'CONFIRM',
			['!']			= 'SHELL',
			['t']			= 'TERM',
			['null']	= 'NONE',
		}

		-- Compare window size
		local winsize = function(req)
			return function() return vim.fn.winwidth(0) >= tonumber(req) end
		end

		-- Returns wheter or not is using a tiling window manager
		local tilewm = (function()
			return vim.env.i3WM or vim.env.AwesaomeWM
		end)()

		local maxlen_mode = (function()
			local len = 0
			for _, v in pairs(mode_alias) do len = math.max(len, #v) end
			return len
		end)()

		new('getFileName', function(c)
			c.max = c.max or 15
			local fn	= vim.fn.expand('%:t')
			if fn == '' then fn = 'unnamed' end
			local rep	= c.max - #fn
			if rep >= c.max then rep = 0 end

			return string.format('%s%s', fn, string.rep(' ', rep))
		end)

		-- new('getProject', function(c)
		-- 	if not _G.packer_plugins['neoproj.nvim'] then return 'ERR' end
		-- 
		-- 	local pj = require('neoproj.handler').getName()
		-- 	if not pj then return '' end
		-- 
		-- 	return string.format(' %s ', pj:upper())
		-- end)

		new('getPosition', function(c)
			c.symbol = c.symbol or ' '
			return string.format('%s%s%3d:%-3d',
				c.symbol, (c.inbetween or ' '), vim.fn.line('.'), vim.fn.col('.'))
		end)

		new('getCurrentWorkingDirectory', function(c)
			return string.format(vim.fn.getcwd())
		end)

		new('getModeAlias', function(c)
			local m = mode_alias[vim.fn.mode()]
			c.symbol = c.symbol or ' '
			c.inbetween = c.inbetween or ' '

			local content = string.format('%s%s%s', c.symbol, c.inbetween, m)
			local lspace, rspace = modx.center(maxlen_mode + #c.symbol + #c.inbetween, content)
			return string.format('%s%s%s', lspace, content, rspace)
		end)

		new('getFileEncoding', function(c)
			local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
			return string.format('%s%s%s', enc:upper(), c.inbetween or ' ', c.symbol or ' ')
		end)

		new('getFileSize', function(c)
			local fs = vim.fn.getfsize(vim.fn.expand('%:p'))
			return string.format('%s%s%s',c.symbol or '猪', c.inbetween or ' ', modx.humanReadable(fs))
		end)

		new('getFileModified', function(c)
			local fileModified = vim.bo.modified
			if fileModified then return c.symbol or ' ' end
			return ' '
		end)

		-- Default tables
		local tblBars = {
			up				= {" ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", ""},
			down			= {"█","▇", "▆","▅", "▄", "▃", "▂","▁", " ", ""},
			battery		= { "","","","","","","","","","","",""},
		}

		local tblDigit = {
			subscript		= {"₀", "₁","₂","₃","₄","₅","₆","₇","₈","₉", ""},
			superscript = {"⁰", "¹","²","³","⁴","⁵","⁶","⁷","⁸","⁹",""},
			normal			= {"0", "1","2","3","4","5","6","7","8","9", ""}
		}

		local fileInfo = {
			-- Encoding
			function(x)
				local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
				local cont = string.format('%s%s%s', enc:upper(), x.inbetween or ' ', '')
				local lspace, rspace = modx.center(x.max or 12, cont)
				return string.format('%s%s%s', lspace, cont, rspace)
			end,

			-- File size
			function(x)
				local fs = vim.fn.getfsize(vim.fn.expand('%:p'))
				local cont = string.format('%s%s%s', modx.humanReadable(fs), x.inbetween or ' ', '')
				local lspace, rspace = modx.center(x.max or 12, cont)
				return string.format('%s%s%s', lspace, cont, rspace)
			end,

			-- Lines
			function(x)
				local cont = string.format('%s%s%s', vim.fn.line('$'), x.inbetween or ' ', '' )
				local lspace, rspace = modx.center(x.max or 12, cont)
				return string.format('%s%s%s', lspace, cont, rspace)
			end,

			-- File Format
			function(x)
				local ff = (vim.bo.ff ~= '' and vim.bo.ff) or vim.o.ff
				local lup = { dos  = '', unix = '', mac  = '' }
				local cont = string.format('%5s%s%s', ff:upper(), x.inbetween or ' ', lup[ff])
				local lspace, rspace = modx.center(x.max or 12, cont)
				return string.format('%s%s%s', lspace, cont, rspace)
			end
		}


		-- HAX: https://github.com/feline-nvim/feline.nvim/blob/master/lua/feline/providers/lsp.lua
		local function get_diagnostics(severity)
			local c = vim.tbl_count(vim.diagnostic.get(0, severity and { severity = severity}))

			return c ~= 0 and tostring(c)
		end

		-- TODO: Fix diagnostics, feline update broke this ffs
		local diagnosticsInfo = {
			-- Errors
			function(x)
				if get_diagnostics(1)
					then return " " end
				return '  '
			end,
			-- Warning
			function(x)
				if get_diagnostics(2)
					then return " " end
				return '  '
			end,
			-- Hint
			function(x)
				if get_diagnostics(3)
					then return " " end
				return '  '
			end,
			-- Info
			function(x)
				if get_diagnostics(4)
					then return " " end
				return '  '
			end
		}

		local gitInfo = {

			-- Added
			function(x)
				local git = vim.b.gitsigns_status_dict
				if not git then return ' ' end
				return string.format('%s%02d', ' ', math.min(git.added, 99))
			end,

			-- Remove
			function(x)
				local git = vim.b.gitsigns_status_dict
				if not git then return ' ' end
				return string.format('%s%02d', ' ', math.min(git.removed, 99))
			end,

			-- Change
			function(x)
				local git = vim.b.gitsigns_status_dict
				if not git then return ' ' end
				return string.format('%s%02d', ' ', math.min(git.changed, 99))
			end,
		}

		--- Generate a scroll bar using two lambda functions and a table
		-- By default, use file first and last line
		new('makeScrollBar', function(c)
			c.table			= c.table or tblBars.down
			c.size			= c.size			or 2
			c.value			= c.value or
				{current = function() return vim.fn.line('.') end, max = function() return vim.fn.line('$') end }

			return string.format('%s',
				string.rep(modx.lookupRatio(c.table, c.value.current(), c.value.max()), c.size))
		end)

		--- Generate a percentage using two lambda functions and a table
		-- By default, use file first and last line
		new('makePercentage', function(c)
			c.table			= c.table or tblDigit.normal
			c.symbols		= c.symbols or
				{ start		= '﮵ ', eof = "﮴ ", unk = " ", normal = ' ' }
			c.value			= c.value or {
				min = function() return 1 end,
				current = function() return vim.fn.line('.') end,
				max = function() return vim.fn.line('$') end
			}

			if c.value.max()			== c.value.min() then return string.format(' %s ', c.symbols.unk) end
			if c.value.current()	== c.value.min() then return string.format(' %s ', c.symbols.start) end
			if c.value.current()	== c.value.max() then return string.format(' %s ', c.symbols.eof) end

			local percentage	= modx.percentage(c.value.current(), c.value.max())
			local at					= function(ix) return c.table[ix + 1] end
			return string.format('%s%s%s%s',
				c.symbols.normal, c.inbetween or '', at(modx.kthDigit(percentage, 1)), at(modx.kthDigit(percentage, 0)))
		end)

		--- Job and Timers in the statusline?
		-- Trust, it works!
		new('makeTask', function(c)
			if type(c.lambda) == 'function' then return c.lambda(c) end
			return 'noref?'
		end)

		--- Git components
		new('getGitUntracked', function(c)
			return string.format('%s%s%s', c.symbol or ' ', c.inbetween or ' ', c.message or 'untracked')
		end)

		new('getGitBranch', function(c)
			local git = vim.b.gitsigns_status_dict
			if not git then return ' ' end
			if not git.head then return ' ' end

			local head = git.head
			if vim.fn.empty(head) == 1 then head = 'unk' end

			return string.format('%s%s%s', c.symbol or ' ', c.inbetween or ' ', head)
		end)

		new('getGitAdd', function(c)
			local git = vim.b.gitsigns_status_dict
			if not git then return ' ' end
			return string.format('%s%02d', c.symbol or ' ', math.min(git.added, 99))
		end)

		new('getGitRemove', function(c)
			local git = vim.b.gitsigns_status_dict
			if not git then return ' ' end
			return string.format('%s%02d', c.symbol or ' ', math.min(git.removed, 99))
		end)

		new('getGitModified', function(c)
			local git = vim.b.gitsigns_status_dict
			if not git then return ' ' end
			return string.format('%s%02d', c.symbol or ' ', math.min(git.changed, 99))
		end)

		--- Statusline definition
		-- Left aligned components
		conf.components.active[1] = {
			-- { provider = 'getProject',
			-- 	left_sep = {'block'},
			-- 	right_sep = { 'block', 'vertical_bar'},
			-- 	hl = function()
			-- 		if not require('neoproj.handler').getName() then
			-- 			return { fg = 'red', bg = 'gray' } end
			-- 		return { fg = 'turk', bg = 'dturk' }
			-- 	end },

			{ provider = 'getFileName',
				left_sep  = { 'block' },
				hl = { bg = 'primary' },
					},

			{ provider = 'getFileModified',
				left_sep  = { 'block' },
				right_sep = { 'block' },
				hl = function()
					return {
						fg = 'orange',
						bg = 'primary',
					} end },

			-- BUG: Cannot return a table from a separator function
			-- ENHANCE: Make a component that processes separators
			{ provider = '┃',
				enabled = function() return MinimalStatusline end,
				hl = { fg = 'primary' }
				},

			-- Git
			{ provider = 'getGitBranch',
				enabled = function() return not MinimalStatusline and vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.added and winsize(100)() end,
				left_sep = { 'vertical_bar', 'block' },
				right_sep = { 'block' },
				hl = function()
					return {
						bg = 'gray',
					} end },

			{ provider = 'makeTask',
				enabled = function() return not MinimalStatusline and vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.added and winsize(100)() end,
				lambda = timermake(
					'gitInfo',
					1,
					function(p)			return math.max(math.fmod(p + 1, #gitInfo + 1), 1) end,
					function(p, c)	return 1500 end,
					function(c, x)
						local lup = {
								'green',
								'red',
								'orange',
						}

						x.hl.fg = lup[c]
						return gitInfo[c](x)
					end
				),
				left_sep = { 'block' },
				right_sep = { 'block', 'vertical_bar' },
				hl = { fg = 'red', bg = 'gray' },
			},

			-- Git disabled
			{ provider = 'getGitUntracked',
				enabled = function() return not MinimalStatusline and not (vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.added) and winsize(100)()end,
				left_sep = { 'vertical_bar', 'block' },
				right_sep = { 'block', 'vertical_bar' },
				hl = function()
					return {
						fg = 'white',
						bg = 'gray',
					} end },

			{ provider = 'makeTask',
				enabled = function() return vim.lsp.buf_get_clients() and winsize(70)() end,
				lambda = timermake(
					'diagnosticsInfo',
					1,
					function(p)			return math.max(math.fmod(p + 1, #diagnosticsInfo + 1), 1) end,
					function(p, c)	return 500 end,
					function(c, x)
						local lup = {
								'red',
								'orange',
								'white',
								'turk'
						}

						x.hl.fg = lup[c]
						return diagnosticsInfo[c](x)
					end
				),
				left_sep = { 'block' },
				right_sep = { 'block' },
				hl = { bg = 'marc' }
					},

			{ provider = 'getExtension',
				left_sep  = { 'vertical_bar', 'block' },
				right_sep = { 'block', 'slant_right' },
				hl = function()
					return {
						fg = 'black',
						bg = 'orange'
					} end },
		}

		-- Center aligned components
		conf.components.active[2] = {
			{ provider = 'getModeAlias',
				enabled = winsize(55),
				left_sep = { 'slant_left' },
				right_sep = { 'slant_right' },
				hl = function()
					return {
						fg = require('feline.providers.vi_mode').get_mode_color(),
						bg = 'primary'
					} end },

			{ provider = function() return vim.fn.mode() end,
				enabled = function() return not winsize(55)() end,
				left_sep = { 'slant_left', 'block' },
				right_sep = { 'block', 'slant_right' },
				hl = function()
					return {
						fg = require('feline.providers.vi_mode').get_mode_color(),
						bg = 'primary'
					} end },
		}

		-- Right aligned components
		conf.components.active[3] = {
			{ provider = 'getPosition',
				left_sep = { 'slant_left', 'block' },
				hl = function()
					return {
						fg = 'lblue',
						bg = 'primary'
					} end },

			{ provider = 'makeTask',
				enabled = function() return not MinimalStatusline and winsize(100)() end,
				lambda = timermake(
					'fileInfo',
					1,
					function(p)			return math.max(math.fmod(p + 1, #fileInfo + 1), 1) end,
					function(p, c)	return 1250 end,
					function(c, x)	return fileInfo[c](x) end
				),
				left_sep = { 'vertical_bar', 'block' },
				right_sep = { 'block', 'vertical_bar' },
				hl = function()
					return {
						bg = 'gray',
					} end },

			-- BUG: Cannot return a table from a separator function
			-- ENHANCE: Make a component that processes separators
			{ provider = '┃',
				enabled = function() return MinimalStatusline end,
				hl = { fg = 'primary' }
				},

			{ provider = 'makePercentage',
				enabled = winsize(55),
				left_sep  = { 'block' },
				hl = function()
					return {
						fg = 'lred',
						bg = 'mred',
					} end },

			{ provider = 'makeScrollBar',
				enabled = winsize(55),
				right_sep = { str = 'block',
					hl =  { fg = 'mred' } },
				hl = function()
					return {
						fg = 'lred',
						bg = 'dred',
					} end },

			{ provider = 'makeTask',
				left_sep = { 'vertical_bar', 'block' },
				enabled = function() return not tilewm and not MinimalStatusline and winsize(140)() end,
				lambda = jobmake('memory', 'free',
					[[free --mega -s 1 | awk '$1 ~ /Mem:/ {print $3,$2}']],
					{0, 0},
					function(c)
						local _, _, use, max = c[1]:find('(%d+)%s(%d+)')
						return { tonumber(use), tonumber(max)}
					end,
					function(c, x)
						x.hl.fg = mix(procolor.green, '#FFFFFF', c[1]/c[2] * 2)
						return string.format('%.2f/%.2fgb  ', c[1]/1024, c[2]/1024)
					end
					),
				hl = { bg = 'dorange' }
				},

			{ provider = 'makeTask',
				left_sep = { 'block' },
				-- right_sep = { 'block' },
				enabled = function() return not tilewm and MinimalStatusline and winsize(140)() end,
				lambda = jobmake('cpu', 'mpstat',
					[[mpstat -P all 1 | awk '$3 ~ /all/ {print $13}']],
					0,
					function(c)
						return 100 - tonumber(c[1])
					end,
					function(c, x)
						x.hl.fg = mix(procolor.red, '#FFFFFF', c/25)
						return string.format('%.2f', c) .. '%%' .. '  '
					end
					),
				hl = { bg = 'dorange' }
				},

			{ provider = 'makeTask',
				format = '%H:%M:%S',
				enabled = function() return not tilewm and winsize(120) end,
				lambda = timermake(
					'getTime',
					nil,
					function(p) return nil end,
					function(p, c) return 1000 end,
					function(c, x) return string.format('%s %s', ' ', os.date(x.format)) end
				),
				left_sep = { 'vertical_bar', 'block' },
				right_sep = { 'block' },
				priority = 2,
				hl = function()
					return {
						fg = 'turk',
						bg = 'dturk',
					} end },
		}


		-- Left aligned inactive components
		conf.components.inactive[1] = {
			{ provider = 'INACTIVE',
				left_sep  = { 'block' },
				right_sep = { 'block' },
				hl = function()
					return {
						fg = 'lgray',
						bg = 'gray',
					} end },

			{ provider = 'getFileName',
				left_sep  = { 'block' },
				hl = function()
					return {
						fg = 'lgray',
						bg = 'mgray',
					} end },
		}

		-- Center aligned inactive components
		conf.components.inactive[2] = { }

		-- Right aligned inactive components
		conf.components.inactive[3] = {
			{ provider = 'makeTask',
				left_sep = { 'block' },
				right_sep = { 'block' },
				format = '%H:%M:%S',
				lambda = timermake(
					'quoteBox',
					math.random(#PREFERENCES.misc.quotes),
					function(p)
						-- Prevent same quote twice in a row
						local r = math.random(#PREFERENCES.misc.quotes)
						while p == r do r = math.random(#PREFERENCES.misc.quotes) end
						return r
					end,
					function(p, c)
						-- Time on screen depends on the length of the quote
						vim.cmd([[redraw!]])
						return 3000 + #PREFERENCES.misc.quotes[c][1] * math.random(25, 55)
					end,
					function(c, x)
						local quote = PREFERENCES.misc.quotes[c]
						return string.format('ﱢ  %s ﱢ  %s', quote[1], quote[2])
					end
				),
				hl = function()
					return {
						fg = 'lgray',
						bg = 'gray',
					} end },
		}

		require('feline').setup(conf)
	end }
