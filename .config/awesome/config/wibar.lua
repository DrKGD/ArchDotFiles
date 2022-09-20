---@diagnostic disable: need-check-nil
--------------------------------------------
-- Imports                    						--
--------------------------------------------
local wibox			= require('wibox')
	local _c				=	wibox.container
	local _w				=	wibox.widget
	local _l				= wibox.layout
	local _s				= require('config.widget.shapes')

local lain			= require('lain')
	local law	= lain.widget

local helperui		= require('helpers.ui')
	local define			= helperui.wibar

local widgets		= require('config.widget')
	local mode				= widgets.mode
	local ws_toggle		= widgets.workspace.toggle
	local ws_perm			=	widgets.workspace.permanent_extended
	local ws_perm2		=	widgets.workspace.permanent_strict
	local ws_perm3		=	widgets.workspace.permanent_active
	local tasklist		= widgets.tasklist.apps_onprimarytag
	local time				= widgets.timedate.time
	local timedate		= widgets.timedate.timedate
	local systray			= widgets.utility.systray
	-- local volume 			= widgets.utility.volume

--------------------------------------------
-- Register widget object(s)  						--
--------------------------------------------
-- local tasklist = function(ui)
-- 	return awful.widget.tasklist {
--     screen   = ui.screen,
--     filter   = awful.widget.tasklist.filter.currenttags,
--     buttons  = nil,
--     style    = {
--         shape_border_width = 1,
--         shape_border_color = '#777777',
--         shape  = gears.shape.rounded_bar,
--     },
-- 	}
-- end


--------------------------------------------
-- Registering wibars                     --
--------------------------------------------
local M = {}

M.ygro = define({ name = 'Ygro', orientation = 'horizontal', width = '100%', height = '2.5%'}, {
		{ layout = _l.fixed.horizontal, spacing = -15,
				ws_perm3({ screen = 3, shape = _s.rline, nameshape = _s.rtag, spacing = -15 }),
				ws_perm2({ screen = 3, shape = _s.rline, spacing = -15 }),
				ws_toggle({ screen = 3, shape = _s.lfork })},
		{ layout = _l.fixed.horizontal, spacing = -1,
				ws_perm({ screen = 1, spacing = 0}),
				ws_toggle({ screen = 1, shape = _s.rround })},
		{ layout = _l.fixed.horizontal, spacing = -15,
				ws_toggle({ screen = 2, shape = _s.rfork }),
				ws_perm2({ screen = 2, shape = _s.pline, spacing = -15 }),
				ws_perm3({ screen = 2, invert = true, shape = _s.pline, nameshape = _s.ptag, spacing = -15 })},
})

M.ainz = define({ name = 'Ainz', orientation = 'horizontal', width = '100%', height = '3.5%'}, {
	{ layout = _l.fixed.horizontal, mode({ shape = _s.brround }) },
	{ layout = _l.fixed.horizontal, tasklist() },
	{ layout = _l.fixed.horizontal, timedate({ shape = _s.blround }), systray() },
})


M.lelouch = define({ name = 'Lelouch', orientation = 'horizontal', width = '100%', height = '3.5%'}, {
	{ layout = _l.fixed.horizontal},
	{ layout = _l.fixed.horizontal, tasklist() },
	{ layout = _l.fixed.horizontal},
})

return M
