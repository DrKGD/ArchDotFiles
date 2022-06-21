PREFERENCES = (function()
	----------------
	-- Profiles   --
	----------------
	local DEFAULT =(function()
		local M = {}

		--- Directories
		M.dirs                  = {}
		M.dirs.swap     = vim.fn.stdpath('data') .. '/.swp/'
		M.dirs.back     = vim.fn.stdpath('data') .. '/.bak/'
		M.dirs.undo     = vim.fn.stdpath('data') .. '/.undo/'

		--- Misc
		M.misc = {}
		M.misc.showbreak = '»'
		M.misc.listchars = 'tab:→\\ ,space:·,extends:›,precedes:‹,nbsp:·,trail:•,eol:¬,nbsp:¡'
		M.misc.colors = {
			["orange"] = "#FF9507",
			["blue"] = "#179AFF",
			["sapphire"] = "#2B50AA",
			["cherryred"] = "#FF004D",
			["turquoise"] = "#00F5CC",
			["green"] = "#17FF7C",
			["red"] = "#FF3E4B",
			["yellow"] = "#DBED00",
			["powder"] = "#F4F4ED",
			["naplesyellow"] = "#FFDF64",
			["violet"] = "#47007D",
			["pink"] = "#FF69B4"
		}

		M.misc.quotes                   = {
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

		--- Hooks
		M.hooks = {
			interface = function()
				vim.cmd('colorscheme torte')
			end
		}

		return M
	end)()

	-- Current Profile Settings
	local currprofile = (function()
		local lup = {
			['DESKTOP-DRKGD'] = 'DESKTOP',
			['LAPTOP-DRKGD'] = 'LAPTOP'
		}

		return lup[vim.fn.hostname()] or nil
	end)()


	local PROFILES = {}

	PROFILES.DESKTOP = {
		hooks = {
			interface = function()
				vim.cmd([[colorscheme zephyrium]])

				vim.defer_fn(function()
					local setHi = require('utils.modx').setHi
					local mix		= require('utils.modx').mix

					local persistent = {
						selection = mix(PREFERENCES.misc.colors.orange,			'#000000', 0.5)
					}

					setHi({
						-- Line Number, above and below
						LineNrAbove			= { guifg = mix(PREFERENCES.misc.colors.blue,				'#000000', 0.5) },
						LineNr					= { guifg = mix(PREFERENCES.misc.colors.green,			'#000000', 0.85), guibg = 'NONE'},
						LineNrBelow			= { guifg = mix(PREFERENCES.misc.colors.orange,			'#000000', 0.5) },

						-- Visual selection and normal text
						Visual					= { guibg = persistent.selection, guifg = '#NONE'},
						Normal					= { guifg = mix(PREFERENCES.misc.colors.orange,			'#FFFFFF', 0.50), guibg = 'NONE'},
						MsgArea					= { gui='bold',  guibg = 'NONE', guifg = PREFERENCES.misc.colors.green},

						-- Gutter
						SignColumn			= { guibg = 'NONE' },
						GitSignsAdd			= { guifg = mix(PREFERENCES.misc.colors.green,			'#000000', 0.6), guibg = 'NONE'},
						GitSignsChange	= { guifg = mix(PREFERENCES.misc.colors.yellow,			'#000000', 0.6), guibg = 'NONE'},
						GitSignsDelete	= { guifg = mix(PREFERENCES.misc.colors.red,				'#000000', 0.6), guibg = 'NONE'},

						-- Transparent window separator
						WinSeparator		= { guibg = 'NONE', guifg = PREFERENCES.misc.colors.orange},

						-- Transparent EOF
						NonText					= { guibg	= 'NONE' },

						-- Transparent non-selected buffer
						NormalNC				= { guibg		= 'NONE' },

						-- Should I keep italics?
						Comment					= { gui   = 'NONE' },
						SpecialComment	= { gui   = 'NONE' },
						TSComment				= { gui   = 'NONE' },

						-- Folds
						Folded					= { guifg = mix(PREFERENCES.misc.colors.orange,				'#FFFFFF', 0.25), guibg = 'NONE'},

						-- Telescope Buffer 
						TelescopeNormal	= { gui = 'NONE' },
						TelescopeBorder = { guibg = 'NONE' },
						TelescopeSelection = { guibg = persistent.selection },
					})

					-- vim.cmd([[TransparentEnable]])
				end, 50)
			end
		}
	}

	PROFILES.LAPTOP = PROFILES.DESKTOP

	-- Pick among built profiles, otherwise use defaults
	return vim.tbl_deep_extend("force", DEFAULT, PROFILES[currprofile] or {})
	end)()
