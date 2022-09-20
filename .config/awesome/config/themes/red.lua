---@diagnostic disable: undefined-global

--------------------------------------------
-- Imports                    						--
--------------------------------------------

local asset				= require("beautiful.theme_assets")
local gears				= require("gears")
local b						= require('beautiful')
local themes_path = require("gears.filesystem").get_themes_dir()
local icondir			= require('gears').filesystem.get_configuration_dir() .. 'img/icons/'

--------------------------------------------
-- Theme configuration        						--
--------------------------------------------

local theme = {}
	-- Gaps
	theme.useless_gap				= 4
	theme.gap_single_client = true

	-- Background
	theme.bg_normal					= "#00000000"
	theme.bg_dark       		= "#3D000F"
	theme.bg_highlight  		= "#B8002E"
	theme.bg_focus      		= "#111111"
	theme.bg_urgent     		= "#FD5D88"
	theme.bg_minimize   		= "#444444"

	-- Foreground
	theme.fg_normal     		= "#ffffff"
	theme.fg_focus      		= "#e4e4e4"
	theme.fg_urgent     		= "#ffffff"
	theme.fg_minimize   		= "#ffffff"

	-- Font
	theme.font_size					= 15.0
	theme.font_family				= 'scientifica Bold'

	-- Border
	theme.border_width			= 4
	theme.border_normal 		= '#520016'
	theme.border_focus  		= '#FC0344'
	theme.border_marked 		= '#FD5D88'
	theme.font							= 'scientifica Bold 12'

	-- Widgets
	theme.clock = {
		bg					= '#c7e3e130',
		hours				= '#FC0344',
		minutes			= '#FD356A',
		seconds			= '#FD5D88'
	}

	-- Layout(s) 
	theme.layout_fairh				= themes_path.."default/layouts/fairhw.png"
	theme.layout_fairv 				= themes_path.."default/layouts/fairvw.png"
	theme.layout_floating			= themes_path.."default/layouts/floatingw.png"
	theme.layout_magnifier 		= themes_path.."default/layouts/magnifierw.png"
	theme.layout_max					= themes_path.."default/layouts/maxw.png"
	theme.layout_fullscreen		= themes_path.."default/layouts/fullscreenw.png"
	theme.layout_tilebottom 	= themes_path.."default/layouts/tilebottomw.png"
	theme.layout_tileleft   	= themes_path.."default/layouts/tileleftw.png"
	theme.layout_tile					= themes_path.."default/layouts/tilew.png"
	theme.layout_tiletop			= themes_path.."default/layouts/tiletopw.png"
	theme.layout_spiral				= themes_path.."default/layouts/spiralw.png"
	theme.layout_dwindle			= themes_path.."default/layouts/dwindlew.png"
	theme.layout_cornernw			= themes_path.."default/layouts/cornernww.png"
	theme.layout_cornerne			= themes_path.."default/layouts/cornernew.png"
	theme.layout_cornersw			= themes_path.."default/layouts/cornersww.png"
	theme.layout_cornerse			= themes_path.."default/layouts/cornersew.png"

	-- c.file				= pgen '#FD5D88'
	-- c.help				= pgen '#F5BC00'
	-- c.unknown 		= pgen '#A9A99E'
	-- c.tree				= pgen '#40C982'
	-- c.util				= pgen '#B17EC9'
	-- c.statusline	= pgen '#D96045'
	-- c.trouble			= pgen '#33AAFF'


	-- Realtime 
	theme.widget_bg_realtime = nil
	theme.widget_fg_realtime = nil

	-- hours				= '#FC0344',
	-- minutes			= '#FD356A',
	-- seconds			= '#FD5D88'

	-- Systray
	theme.bg_abs_systray							= '#8F0026'
	theme.bg_systray									= '#8F0026'

	-- Clock
	theme.clock_hour_fg								= '#C0C0C0'
	theme.clock_minute_fg							= '#C0C0C0'
	theme.clock_second_fg							= '#C0C0C0'
	theme.clock_date_fg								= '#ffffff'
	theme.clock_bg										= '#8F0026'

	-- Tasklist
	theme.tasklist_fg_normal					= '#ffffff'								-- Non-focus task
	theme.tasklist_bg_normal					= '#6F2C3E77'
	theme.tasklist_fg_focus						= '#ffffff'								-- Focus task
	theme.tasklist_bg_focus 					= '#B6315477' theme.tasklist_fg_urgent					= '#ffffff'								-- Urgent task
	theme.tasklist_bg_urgent					= '#FD5D88'
	theme.tasklist_border_focus				= '#F5BC00'
	theme.tasklist_border_normal			= '#ffffff'

	-- Taglist
	theme.taglist_fg_abs							= '#121212'								-- Absolute foreground of the widget
	theme.taglist_bg_focus						= '#FD356A'
	theme.taglist_bg_focustxt					= '#FD356A'
	theme.taglist_fg_focustxt					= '#ffffff'
	theme.taglist_bg_hover						= '#FD5D88'
	theme.taglist_bg_hover_toggle			= '#FD5D88'
	theme.taglist_bg_volatile					= '#000000'
	theme.taglist_bg_empty 						= '#8F0026'
	theme.taglist_bg_placeholder			= '#3D0010'
	theme.taglist_bg_occupied					= '#B80031'
	theme.taglist_bg_urgent						= '#FD5D88'
	theme.taglist_fallback_image			=	icondir .. 'help.png'

	-- Mode
	theme.clock_hour_fg								= '#C0C0C0'
	theme.clock_minute_fg							= '#C0C0C0'
	theme.clock_second_fg							= '#C0C0C0'
	theme.clock_date_fg								= '#ffffff'
	theme.clock_bg										= '#8F0026'
	theme.mode_bg_default							= '#8F0026' -- Default mode color if no other matching mode was not found
	theme.mode_fg_default							= '#C0C0C0'

	theme.mode_img_default						= icondir .. 'boom-gate-alert.png'
	theme.mode_img_workspacedvii1			=	icondir .. 'overscan.png'
	theme.mode_img_workspacedp1				=	icondir .. 'overscan.png'
	theme.mode_img_workspacehdmi0			=	icondir .. 'overscan.png'

	-- Toggle tags
	theme.taglist_fg_toggle						= theme.taglist_fg_empty	-- Default togglelist if element is missing
	theme.taglist_bg_toggle						= '#FA7921'
	theme.taglist_img_toggle					= icondir .. 'skull-scan.png'

	-- theme.mode_fg_workspacedvii1			=	'#FFFFFF'								-- Workspace(s)
	-- theme.mode_bg_workspacedvii1			= '#59798E'
	-- theme.mode_fg_workspacedp1				=	theme.mode_fg_workspacedvii1
	-- theme.mode_bg_workspacedp1				= theme.mode_bg_workspacedvii1
	-- theme.mode_fg_workspacehdmi0			=	theme.mode_fg_workspacedvii1
	-- theme.mode_bg_workspacehdmi0			= theme.mode_bg_workspacedvii1
	-- theme.mode_fg_run									=	'#FFFFFF'								-- Run mode
	-- theme.mode_bg_run									=	'#FC0344'
	-- theme.mode_fg_edit								=	'#FFFFFF'								-- Edit mode
	-- theme.mode_bg_edit								=	'#40C982'
	-- theme.mode_fg_toggle 							=	'#ffffff'								-- Toggle mode
	-- theme.mode_bg_toggle 							= '#D96045'
	-- theme.taglist_fg_toggle_telegram	= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_telegram	= '#0072C2'
	-- theme.taglist_fg_toggle_discord		= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_discord		= '#5863F8'
	-- theme.taglist_fg_toggle_incognito	= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_incognito	= '#B17EC9'
	-- theme.taglist_fg_toggle_search		= '#121212'
	-- theme.taglist_bg_toggle_search		= '#EFE9F4'
	-- theme.taglist_fg_toggle_whatsapp	= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_whatsapp	= '#40C982'
	-- theme.taglist_fg_toggle_instagram	= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_instagram	= '#F5BC00'
	-- theme.taglist_fg_toggle_youtube		= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_youtube		= '#C50A24'
	-- theme.taglist_fg_toggle_facebook	= theme.taglist_fg_abs
	-- theme.taglist_bg_toggle_facebook	= '#5FBFF9'

	-- Plugins
		theme.layout_machi = require('layout-machi').get_icon()

b.init(theme)

