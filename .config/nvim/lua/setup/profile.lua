-------------------------------------
-- Profile handler                 --
-------------------------------------
local currentProfile = (function()
	local lup = {
		['desktop']	= 'DESKTOP',
		['laptop']	= 'LAPTOP',
	}

	return lup[os.getenv('PROFILE')] or nil
end)()

local DEFAULT = {}

-------------------------------------
-- Plugin configuraiton            --
-------------------------------------
DEFAULT.plugin		= {}
DEFAULT.plugin.compiled		= string.format('%s/plugin/02-compiled.lua', vim.fn.stdpath('config'))
DEFAULT.plugin.updatehook	= string.format('%s/.issue_update_hook', vim.fn.stdpath('data'))
DEFAULT.plugin.packerpath	= string.format('%s/site/pack/packer/start/packer.nvim', vim.fn.stdpath('data'))

-------------------------------------
-- Editor (misc) configuration     --
-------------------------------------
DEFAULT.editor	= {}
DEFAULT.editor.base_colorscheme			= 'torte'
DEFAULT.editor.notification_ratio		= 0.47			-- Notification width

-------------------------------------
-- Mason Configuration             --
-------------------------------------
DEFAULT.mason				= {}
DEFAULT.mason.lsp		= { 'sumneko_lua', 'clangd' }
DEFAULT.mason.tools	= { 'shellcheck' }

-------------------------------------
-- Directories configuration       --
-------------------------------------
DEFAULT.dirs	= {}
DEFAULT.dirs.swap = vim.fn.stdpath('data') .. '/.swp/'
DEFAULT.dirs.back = os.getenv('BACK_UP') or
	vim.fn.stdpath('data') .. '/.bak/'
DEFAULT.dirs.undo = vim.fn.stdpath('data') .. '/.undo/'

-------------------------------------
-- Misc configurations             --
-------------------------------------
DEFAULT.misc	= {}
DEFAULT.misc.showbreak = '»'
DEFAULT.misc.listchars = 'tab:→\\ ,space:·,extends:›,precedes:‹,nbsp:·,trail:•,eol:¬,nbsp:¡'
DEFAULT.misc.quotes	= {
	{"I am evil, stop laughing!", "Veigar"},
	{"Surpass the limit of your form.", "Aatrox"},
	{"I am not YOUR enemy, I am THE enemy!", "Aatrox"},
	{"I am Darkin! I do not die!", "Aatrox"},
	{"You would fight me?! Come, let me show you HELL!", "Aatrox"},
	{"Die with your lords!", "Sylas"},
	{"Mages, unite!", "Sylas"},
	{"No more cages!", "Sylas"},
	{"Double Sunday!", "Raditz"},
	{"Saturday Crash!", "Raditz"},
	{"JuvdashavnothinpeelleskafbadudachechigawAstauxtekalonshamilupvevuvenivanovafle", "Viceblanka"},
	{"Hack the Planet!", "Hackers (1995)"},
	{"Mess with the best, die like the rest.", "Zero Cool"},
	{"Out of all the things I have lost, I miss my mind the most.", "Mark Twain"},
	{"There is no right or wrong, just fun and boring", "Eugene Belford"},
	{"I'll make good use of this.", "Sylas"},
	{"כולנו אבודים בחלל", "Infected Mushroom"},
	{"The enemy is you as well, the enemy is I", "Jimmy Eat World"},
	{"Bleed the sound wave, the truth will send you falling", "Saosin"},
	{"I haven't got the will to try and fight, against a new tomorrow", "Raf"},
	{"Your feeling of helplessness is your best friend, savage.", "The Brain (1957)"},
	{"Ani mevushal, ani metugan, Ani meturlal, ani mehushmal", "Infected Mushroom"}
}

-------------------------------------
-- Colors configuration            --
-------------------------------------
DEFAULT.palette			= {}
DEFAULT.palette.i3	= (function()
	local tbl			= {}

	local rgx			= [[([^:]+):(#[%x][%x][%x][%x][%x][%x])(.*)]]
	local i3query = require('util.ext')
		.run([[cat $HOME/.config/i3/conf.d/30-visual.i3.inc | grep "set \$color_" | awk '{sub(/\$color_/, "", $2); printf "%s:%s\n", $2, $3}']])

	for _, line in ipairs(i3query) do
		local name, value, _ = line:match(rgx)
		tbl[name] = value
	end

	return tbl
end)()

-------------------------------------
-- Hydra bulider configuration     --
-------------------------------------
DEFAULT.hydra = {}
DEFAULT.hydra.keys	 = "wertyuiopasdfghjklzxcvnm"

-------------------------------------
-- Heirline configuration          --
-------------------------------------
DEFAULT.heirline = {}
DEFAULT.heirline.palette = {}
DEFAULT.heirline.palette.foreground = DEFAULT.palette.i3.focus

-------------------------------------
-- Hook(s)                         --
-------------------------------------
DEFAULT.hooks = {}
DEFAULT.hooks.colorscheme = function()
	-- Retrieve selected colorscheme
	local selection = PREFERENCES.editor.base_colorscheme
	if not selection then
		vim.schedule(function() vim.notify("No colorscheme was selected, default will be used", "warn", { render = "minimal"}) end) return end

	-- Check if colorscheme is in the list of colorschemes
	if not vim.tbl_contains(require('util.generic').colorschemes(), selection) then
		vim.schedule(function() vim.notify(string.format("Selected colorscheme <%s> does not exist!", selection), "error", { render = "minimal"}) end) return end

	-- Assume plugin is not loaded and optional, thus apply
	if require('util.packer').loadPlugin('colorscheme.' .. selection) then
		vim.cmd('colorscheme ' .. selection) end
end


-- On backup, inject timestamp
DEFAULT.hooks.backup		= function()
	-- Only if a different backup location was specified!
	if not os.getenv('BACK_UP') then return end

	vim.api.nvim_create_autocmd('BufWritePre', {
		group = vim.api.nvim_create_augroup('timestamp_backupext', { clear = true }),
		desc = 'Add timestamp to backup extension',
		pattern = '*',
		callback = function()
			vim.opt.backupext = '-' .. vim.fn.strftime('%Y%m%d%H%M')
		end,
	})
end


-- Welcome message
DEFAULT.hooks.welcome		= function()
		-- Kill it with any key press
		local HAS_NVIM_NOTIFY, n = pcall(require, "notify")

		-- Welcome message
		vim.schedule(function()
				if HAS_NVIM_NOTIFY then
					vim.api.nvim_create_autocmd('User', { pattern = 'KeyPress', once = true,
						callback = vim.schedule_wrap(function() n.dismiss() end)}) end

				vim.notify(string.format("Welcome back, %s!", os.getenv("USER")), 'info', { render = "minimal" })
			end)
	end

-- Dim inactive windows
DEFAULT.hooks.dim				= function()
		local utilwin			= require('util.windows')
		local utilbuf			= require('util.buffers')
		local	hi					= require('util.generic').hi
		local desaturate	= require('util.color').desaturate

		-- Which highlight group should be darkened
		local affect		= {
			-- Buffer 
			'Normal',
			'CursorLineNr',

			-- Line Number 
			-- BUG: somewhat buggy, does not work on startup
			'LineNr',
			'LineNrAbove',
			'LineNrBelow',

			-- Diff
			'DiffAdd', 'DiffChange', 'DiffDelete', 'DiffText',

			-- Treesitter and objects
			'Error', 'Todo', 'String', 'Constant', 'Character', 'Comment',
			'Number', 'Boolean', 'Float', 'Function', 'Identifier', 'Conditional',
			'Statement', 'Repeat', 'Label', 'Keyword', 'Exception', 'Include', 'PreProc',
			'Define', 'Macro','PreCondit', 'StorageClass', 'Type', 'Structure', 'Typedef',
			'Tag', 'Special', 'SpecialChar', 'Delimiter', 'SpecialComment', 'Debug',

			-- Diagnostics
			'DiagnosticError', 'DiagnosticWarn', 'DiagnosticInfo', 'DiagnosticHint',
			'DiagnosticUnderlineError', 'DiagnosticUnderlineWarn', 'DiagnosticUnderlineInfo', 'DiagnosticUnderlineHint',
			'DiagnosticVirtualTextError', 'DiagnosticVirtualTextWarn', 'DiagnosticVirtualTextInfo', 'DiagnosticVirtualTextHint',
			'DiagnosticFloatingError', 'DiagnosticFloatingWarn', 'DiagnosticFloatingInfo', 'DiagnosticFloatingHint',
			'DiagnosticSignError', 'DiagnosticSignWarn', 'DiagnosticSignInfo', 'DiagnosticSignHint',

			-- TODOs
			'TodoBgTEST', 'TODOFgTEST', 'TODOSignTEST',
			'TodoBgTODO', 'TODOFgTODO', 'TODOSignTODO',
			'TodoBgOPTIMIZE', 'TODOFgOPTIMIZE', 'TODOSignOPTIMIZE',
			'TodoBgTHANKS', 'TODOFgTHANKS', 'TODOSignTHANKS',
			'TodoBgNOTE', 'TODOFgNOTE', 'TODOSignNOTE',
			'TodoBgFIX', 'TODOFgFIX', 'TODOSignFIX',
			'TodoBgHACK', 'TODOFgHACK', 'TODOSignHACK',
			'TodoBgWARN', 'TODOFgWARN', 'TODOSignWARN',
			'TodoBgPERF', 'TODOFgPERF', 'TODOSignPERF',

			-- IndentBlankline
			'IndentBlanklineColor1',
			'IndentBlanklineColor2',
			'IndentBlanklineColor3',
			'IndentBlanklineColor4',
			'IndentBlanklineColor5',
			'IndentBlanklineColor6',
			'IndentBlanklineColor7',
			'IndentBlanklineColor8',
			'IndentBlanklineColor9',
			'IndentBlanklineColor10',
			'IndentBlanklineContextStart',
			'IndentBlanklineSpaceChar',
			'IndentBlanklineSpaceCharBlankline',
			'IndentBlanklineChar',
			'IndentBlanklineContextChar',

			-- Rainbow parenthesis
			'rainbowcol1',
			'rainbowcol2',
			'rainbowcol3',
			'rainbowcol4',
			'rainbowcol5',
			'rainbowcol6',
			'rainbowcol7',
		}

		local register = function()
			local dimset		= { }
			local winhlset  = ''
			local amnt			= 0.70
			local not_found = { }

			-- Generate list of highlights
			for i, hl in ipairs(affect or { }) do
				local dimhl		= string.format('Dim%s', hl)
				local concat	= string.format('%s:%s', hl, dimhl)

				-- Extract and convert to hexadecimal
				local e, extract = pcall(vim.api.nvim_get_hl_by_name, hl, true)
				if not e then table.insert(not_found, hl)
				else
					for field, color in pairs(extract) do
						if type(field) == 'string' and type(color) == 'number' then
							extract[field] = desaturate(string.format('#%06x', color), amnt)
						else
								extract[field] = nil
							end
					end

					dimset[dimhl] = extract

					if i == 1 then
						winhlset = concat
					else
						winhlset = string.format('%s,%s:%s', winhlset, hl, dimhl)
					end
				end
			end

			-- Append to current highlight list
			hi(dimset)

			-- Warn user about all the unexisting hilightgroups
			if #not_found > 0 then
				vim.schedule(function()
					local str = string.format("The following highlight groups were not found\n%s",
						table.concat(not_found, '\n'))

					vim.notify(str, 'warn', { render = "minimal"})
				end)
			end

			-- Events on window switch
			local group		= vim.api.nvim_create_augroup('dim_inactive_window', { clear = true })
			vim.api.nvim_create_autocmd({ 'WinEnter' , 'BufWinEnter'}, {
				group = group,
				desc	= 'Restore active window',
				callback = function(_)
					vim.schedule(function()
						vim.wo.winhl = nil
					end)
				end,
			})

			vim.api.nvim_create_autocmd('WinLeave', {
				group = group,
				desc	= 'Dim inactive window',
				callback = function(event)
					vim.schedule(function()
						for win, _ in pairs(utilwin.getWindowsDisplayingBuffers(event.buf)) do
							vim.wo[win].winhl = winhlset
						end
					end)
				end,
			})

			-- vim.api.nvim_create_autocmd('FocusLost', {
			-- 	group = group,
			-- 	desc	= 'Undim all windows',
			-- 	callback = function()
			-- 		vim.schedule(function()
			-- 			for win, _ in pairs(utilwin.getWindowsDisplayingBuffers(utilbuf.getBuffers())) do
			-- 				vim.wo[win].winhl = nil
			-- 			end
			-- 		end)
			-- 	end,
			-- })
			--
			-- vim.api.nvim_create_autocmd('FocusGained', {
			-- 	group = group,
			-- 	desc	= 'Undim all windows',
			-- 	callback = function()
			-- 		vim.schedule(function()
			-- 			local currwin = vim.fn.win_getid()
			-- 			for win, _ in pairs(utilwin.getWindowsDisplayingBuffers(utilbuf.getBuffers())) do
			-- 				if win ~= currwin then
			-- 					vim.wo[win].winhl = winhlset end
			-- 			end
			-- 		end)
			-- 	end,
			-- })
		end

		vim.api.nvim_create_autocmd('VimEnter', { callback = function()
			vim.schedule(function()
				register()
			end)

			return true
		end})
	end

-------------------------------------
-- Other profile(s) configuration  --
-------------------------------------
local PROFILES = {}

PROFILES.DESKTOP	= {}
PROFILES.DESKTOP.editor = {}
PROFILES.DESKTOP.editor.base_colorscheme = 'tokyodark'


PROFILES.DESKTOP.hooks = {}

PROFILES.DESKTOP.hooks.colorscheme = function()
		-- Run default hook (extend)
		DEFAULT.hooks.colorscheme()

		-- Setup palette
		local p					= PREFERENCES.palette.i3
		local cfocus		= p.focus			or '#000000'
		local cnofocus	= p.nofocus		or '#000000'
		local celegible = p.elegible	or '#000000'
		local curgent		= p.urgent		or '#000000'

		-- Customize theme
		local darken	= require('util.color').darken
		local lighten = require('util.color').lighten
		local mix			= require('util.color').mix
		local invert	= require('util.color').invert
		local	hi			= require('util.generic').hi
		local darken	= require('util.color').darken
		local desaturate = require('util.color').desaturate

		hi({
			-- Numberline
			LineNrAbove = { fg = cfocus, bg = 'NONE' },
			LineNr			= { fg = lighten(cfocus, 0.90), bg = 'NONE' },
			CursorLineNr= { fg = lighten(cfocus, 0.90), bg = 'NONE' },
			LineNrBelow = { fg = cfocus, bg = 'NONE' },

			-- Highlight
			Visual			= { bg = mix(curgent, '#220C07', 0.20)},
			Normal			= { bg = 'NONE', fg = '#F5D4CC' },
			Comment			= { bg = 'NONE', fg = '#DC6E56', italic = false	},
			MsgArea			= { bg = cnofocus, fg = lighten(curgent, 0.75) },
			CursorLine	= { bg = darken(cnofocus, 0.60)},
			Search			= { bg = darken(invert(curgent), 0.45) },

			-- Gutter 
			SignColumn			= { bg = 'NONE' },

			-- Jabs
			JabsNormal			= { bg = 'NONE', fg = '#F0F090' },
			JabsHidden			= { bg = 'NONE', fg = '#555555' },
			JabsSplit				= { bg = 'NONE', fg = '#FF9A5C' },
			JabsAlternate		= { bg = 'NONE' },

			-- Git
			GitSignsAdd				= { fg = '#33AAFF', bg = 'NONE'},
			GitSignsChange		= { fg = '#D99D08', bg = 'NONE'},
			GitSignsDelete		= { fg = '#DA3E52', bg = 'NONE'},
			GitSignsAddLn			= { bg = darken('#33AAFF', 0.80), fg = 'NONE'},
			GitSignsChangeLn	= { bg = darken('#D99D08', 0.75), fg = 'NONE'},
			GitSignsDeleteLn	= { bg = darken('#DA3E52', 0.75), fg = 'NONE'},

			-- Trouble 
			TroubleNormal				= { bg = darken('#33AAFF', 0.90), fg = lighten('#33AAFF', 0.70) },

			-- Treesiter
			TreesitterContext							= { bg = desaturate(cfocus, 0.75), nocombine = true},
			TreesitterContextLineNumber		= { fg = '#D99D08', bg = desaturate(cfocus, 0.75)},

			-- Diagnostic
			DiagnosticSignError = { fg = '#FF3333'},
			DiagnosticSignWarn	= { fg = '#FF9A5C'},
			DiagnosticSignInfo 	= { fg = '#E3F68D'},
			DiagnosticSignHint 	= { fg = '#B4D2E7'},

			-- Float(s)
			NormalFloat = { fg = '#F5D4CC', bg = darken(curgent, 0.70)},
			FloatBorder = { fg = '#F5D4CC', bg = darken(curgent, 0.70)},
			FloatTitle = { fg = '#F5D4CC', bg = darken(curgent, 0.30)},

			-- Transparency
			WinSeparator		= { bg = 'NONE', fg = cnofocus},
			NonText					= { bg = 'NONE', fg = curgent},
			NormalNC				= { bg = 'NONE'},

			-- Nvim-Tree
			NvimTreeRootFolder  = { fg = '#40C982' },
			NvimTreeNormal			= { bg = darken(curgent, 0.90), fg = lighten(curgent, 0.70) },
			NvimTreeFolderName	= { fg = curgent },
			NvimTreeFileIcon		= { fg = lighten(curgent, 0.60) },
			NvimTreeFolderIcon	= { fg = darken(curgent, 0.40) },
			NvimTreeEmptyFolderName = { fg = celegible },
			NvimTreeOpenedFolderName = { fg = cfocus },
			NvimTreeWinSeparator = { bg = 'NONE', fg = cnofocus},
			NvimTreeExecFile	= { fg = '#F5BC00'},

			-- Lightspeed
			LightspeedGreyWash	= { fg = invert('#DC6E5F') },

			-- Absolutamente no italics
			Special					= { bg = 'NONE', fg = curgent},
			SpecialKey			= { bg = 'NONE', fg = curgent},
			SpecialChar			= { bg = 'NONE', fg = curgent},
			SpecialComment	= { italic = false },

			TSComment				= { italic = false },

			-- Pum and Autocomplete 
			Pmenu = { fg = '#F5D4CC', bg = darken(curgent, 0.90)},
			PmenuSel = { bg = cfocus, fg = cfocus },
			PmenuSBar = { bg = darken(curgent, 0.30), fg = lighten(curgent, 0.20) },
			PmenuThumb = { bg = 'NONE'},

			-- Wilder
			WilderMenu	= { fg = '#F5D4CC', bg = darken(curgent, 0.70)},
			WilderSelected	= { bg = darken(invert(curgent), 0.40) },
			WilderAccent	= { fg = curgent },
			WilderSelectedAccent = { fg = lighten(invert(curgent), 0.50), bg = darken(invert(curgent), 0.40)},
			WilderEmpty	= { fg = lighten(curgent, 0.20) },

			CmpItemAbbrDeprecated = { fg = "#FFFFFF", bg = "NONE"},
			CmpItemAbbrMatch = { fg = "#FFFFFF", bg = "NONE"},
			CmpItemAbbrMatchFuzzy = { fg = "#FFFFFF", bg = "NONE"},
			CmpItemMenu = { fg = "#FFFFFF", bg = "NONE"},

			CmpItemKindField = { fg = "#FFFFFF", bg = "#FA6F38" },
			CmpItemKindProperty = { fg = "#FFFFFF", bg = "#FA6F38" },
			CmpItemKindEvent = { fg = "#FFFFFF", bg = "#FA6F38" },

			CmpItemKindText = { fg = "#FFFFFF", bg = "#CC8828" },
			CmpItemKindEnum = { fg = "#FFFFFF", bg = "#CC8828" },
			CmpItemKindKeyword = { fg = "#FFFFFF", bg = "#CC8828" },

			CmpItemKindConstant = { fg = "#FFFFFF", bg = "#243E36" },
			CmpItemKindConstructor = { fg = "#FFFFFF", bg = "#243E36" },
			CmpItemKindReference = { fg = "#FFFFFF", bg = "#243E36" },

			CmpItemKindFunction = { fg = "#FFFFFF", bg = "#A377BF" },
			CmpItemKindStruct = { fg = "#FFFFFF", bg = "#A377BF" },
			CmpItemKindClass = { fg = "#FFFFFF", bg = "#A377BF" },
			CmpItemKindModule = { fg = "#FFFFFF", bg = "#A377BF" },
			CmpItemKindOperator = { fg = "#FFFFFF", bg = "#A377BF" },

			CmpItemKindVariable = { fg = "#FFFFFF", bg = "#7E8294" },
			CmpItemKindFile = { fg = "#FFFFFF", bg = "#7E8294" },

			CmpItemKindUnit = { fg = "#FFFFFF", bg = "#D4A959" },
			CmpItemKindSnippet = { fg = "#FFFFFF", bg = "#D4A959" },
			CmpItemKindFolder = { fg = "#FFFFFF", bg = "#D4A959" },

			CmpItemKindMethod = { fg = "#FFFFFF", bg = "#6C8ED4" },
			CmpItemKindValue = { fg = "#FFFFFF", bg = "#6C8ED4" },
			CmpItemKindEnumMember = { fg = "#FFFFFF", bg = "#6C8ED4" },

			CmpItemKindInterface = { fg = "#FFFFFF", bg = "#58B5A8" },
			CmpItemKindColor = { fg = "#FFFFFF", bg = "#58B5A8" },
			CmpItemKindTypeParameter = { fg = "#FFFFFF", bg = "#58B5A8" },

			-- -- Transparent EOF
			-- NonText					= { guibg	= 'NONE' },
			--
			-- -- Transparent non-selected buffer
			-- NormalNC				= { guibg		= 'NONE' },
			--
			-- -- Should I keep italics?
		})
	end

PROFILES.LAPTOP		= PROFILES.DESKTOP

-------------------------------------
-- Return merged configuration     --
-------------------------------------
return vim.tbl_deep_extend("force", DEFAULT, PROFILES[currentProfile] or {})
