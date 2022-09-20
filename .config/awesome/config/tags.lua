--------------------------------------------
-- Imports                    						--
--------------------------------------------
local idir		= require('gears').filesystem.get_configuration_dir() .. 'img/icons/'
local mod			= require('helpers.kbd').MODIFIERS

---------------
--  Layouts  --
---------------
local awful		= require('awful')
local machi		= require('layout-machi')
local lain		= require('lain')

-- lain.layout.termfair.nmaster = 3
-- lain.layout.termfair.ncol		= 1

local M = {}

--------------------------------------------
-- Defined tags for configuration(s)      --
--------------------------------------------
-- Permanent workspaces
-- These workspaces are permanent and do not belong to any application
-- + visual		: which name should be displayed instead of the default one
-- + layouts	: define all the available layouts, first one is also the default one
-- + layout		: defines in-use layout 
-- + icon			: defined icon for the workspace
M.PERMANENT = {
	Social	= { visual = 'Social', icon = idir .. 'creation.png'											},
	Media		= { visual = 'Media' , icon = idir .. 'multimedia.png'										},
	Focus		= { visual = 'Focus' , icon = idir .. 'target.png'												},
	Home		= { visual = 'Home'	 , icon = idir .. 'radioactive-circle-outline.png'		},
	Game		= { visual = 'Game'	 , icon = idir .. 'keyboard-settings.png'							},
	Term		= { visual = 'Term'  , icon = idir .. 'console.png'												},
	Dev			= { visual = 'Dev'	 , icon = idir .. 'dev-to.png'												},
	File		= { visual = 'File'	 , icon = idir .. 'folder-settings.png' 							},
	Nav			= { visual = 'Nav'	 , layouts = { awful.layout.suit.tile.right}, icon = idir .. 'star-three-points.png'							},
	Misc		= { visual = 'Misc'  , icon = idir .. 'developer-board.png'								},
	Setup		= { visual = 'Setup' , icon = idir .. 'hammer-wrench.png'									},

	-- Fallback tag
	Fallback = { visual = '?'	, icon = idir .. 'help.png' }
}

-- Toggle workspaces
--	Usually only shows one application, they are togglable using workspace-mode
--  They are configured and behave differntly from permanent tags!
-- + lhs		: key which spawns the workspace
-- + mdf   	: modifier for even more available keys
-- + visual	: which name should be displayed instead of the default one
-- + class 	: which class should it match against (e.g. 'telegram'),
	-- n.b. the following matches either one or the other, thus id='a' and name='b' would match both 
	-- + id    	: on startup, if the application API allows it, defines the startup_id which helps in matching
	-- + name  	: which name should it match against
-- + layout : which layout should it be using, by default it is awful.layout.suit.tile
-- + icon		: defined icon for the workspace
M.TOGGLE		= {
	-- Keep
	Telegram		= { lhs = 't', mod = mod.NONE, class = 'TelegramDesktop', 'telegram-desktop', icon = idir .. 'telegram.svg', keep = true},
	Player			= { lhs = 'p', mod = mod.NONE, class = 'org.wezfurlong.wezterm.mpdclient', "wezterm start --always-new-process --class 'org.wezfurlong.wezterm.mpdclient' ncmpcpp",
		icon = idir .. 'disc-player.png', keep = true},
	Terminal		= { lhs = 'Return', mod = mod.NONE, class = 'org.wezfurlong.wezterm.unique', "wezterm start --always-new-process --class 'org.wezfurlong.wezterm.unique'", icon = idir .. 'console.png', keep = true},
	Torrent			= { lhs = '`', mod = mod.NONE, class = 'qBittorrent', 'qbittorrent', icon = idir .. 'file-arrow-left-right.png', keep = true},
	Discord 		= { lhs = 'd', mod = mod.NONE, class = 'discord', 'discord', icon = idir .. 'discord.svg', keep = true},
	Whatsapp		= { lhs = 'w', mod = mod.NONE, class = 'firefox', id = 'ssb_browser_whatsapp', 'firefox --new-window https://web.whatsapp.com -P "SSB"', icon = idir .. 'whatsapp.png', keep = true},
	Instagram		= { lhs = 'i', mod = mod.NONE, class = 'firefox', id = 'ssb_browser_instagram', 'firefox --new-window "https://instagram.com/?theme=dark" -P "SSB"', icon = idir .. 'instagram.svg', keep = true},
	Facebook		= { lhs = 'f', mod = mod.NONE, class = 'firefox', id = 'ssb_browser_facebook', 'firefox --new-window https://facebook.com -P "SSB"', icon = idir .. 'facebook.svg', keep = true},
	Youtube			= { lhs = 'y', mod = mod.NONE, class = 'firefox', id = 'ssb_browser_youtube', 'firefox --new-window https://www.youtube.com -P "SSB"', icon = idir .. 'youtube-tv.png', keep = true},

	-- Non-keep
	FirefoxDev	= { lhs = 'b', mod = mod.CTRL, class = 'firefoxdeveloperedition', id = 'developer_browser', 'firefox-developer-edition', icon = idir .. 'firefox.png' },
	Search 			= { lhs = 'b', mod = mod.NONE, class = 'firefox', id = 'ssb_browser_search', 'firefox --new-window https://www.google.com -P "SSB"', icon = idir .. 'feature-search-outline.png'},
}

return M
