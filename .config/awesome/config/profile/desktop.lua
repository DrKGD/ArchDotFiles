---@diagnostic disable: undefined-global --------------------------------------------
-- Imports                                --
--------------------------------------------
local _tags			= require('config.tags').PERMANENT
local _bar			= require('config.wibar')
local _box			= require('config.wibox')
local _eval			= require('helpers.eval')
local awful			= require('awful')
local notify		= require('naughty').notify
local gears			= require('gears')
local wibox			= require('wibox')
local ruled			= require('ruled')
local	machi			= require('layout-machi')

local helper		= require('helpers.workspace')
	local _ws				= helper.define

--------------------------------------------
-- Configuring tag rules                  --
--------------------------------------------
local may = machi.layout.create { new_placement_cb = machi.layout.placement.empty_then_fair }

_tags.Home.configure		= helper.fixed_newisslave({ master_width_factor = 0.35})
_tags.Dev.configure			= helper.alter({ layouts = { may }})
_tags.Term.configure		= helper.fixed_setslave({ master_width_factor = 0.35}, 'org.wezfurlong.wezterm')
_tags.Nav.configure			= helper.fixed_setslave({ master_width_factor = 0.25}, 'firefox')
_tags.Social.configure	= helper.fixed({ master_width_factor = 0.35})

--------------------------------------------
-- Workspaces (= screen) configuration    --
--------------------------------------------
local WORKSPACES = {
		_ws([[DP-1]],			[[1]], 60, { _tags.Social, _tags.Media, _tags.Focus },{
				-- { _bar.ygro, spawn = { position = 'top' }},
				{ _bar.lelouch, spawn = { position = 'bottom' }},
			}, {
				-- { _box.rect, spawn = { position = { x = '1%', y = '1.5%', anchor = 'top-left'}}},
				-- { _box.clock, spawn = { position = { x = '1%', y = '1.5%'}}},
			}),

		_ws([[DVI-I-1]],	[[2]], 144, { _tags.Home, _tags.Term, _tags.Dev, _tags.File, _tags.Game }, {
				{ _bar.ygro, spawn = { position = 'top', margins = { '0.75%', '0.35%'} }},
				{ _bar.ainz, spawn = { position = 'bottom', margins = { '0.35%', 0 }}},
			}, {
				-- { _box.clock, spawn = { position = { x = '1%', y = '1.5%'}}},
			}),
		_ws([[HDMI-0]],		[[3]], 60, { _tags.Nav, _tags.Misc, _tags.Setup}, {
				{ _bar.lelouch, spawn = { position = 'bottom' }},
				-- { _bar.ygro, spawn = { position = 'top' }},
		},{
				-- { _box.clock, spawn = { position = { x = '1%', y = '1.5%'}}},
		})
	}

table.sort(WORKSPACES, -- Ensure order matches screen order
	function(a,b) return a.ID < b.ID end)

awful.screen.connect_for_each_screen(function(scr)
	------------------
	-- Screen dect  --
	------------------
	local cfg = WORKSPACES[scr.index]
	if not cfg then
		-- TODO: Should throw an error!
		notify {	title = 'Error in screen configuration',
							text = string.format('No configuration found for <%s>!', selected)} return end

	------------------
	-- Install tags --
	------------------
	local ws_opts =
		{ index = id, screen = scr }

	for id, ws in ipairs(cfg.TAGS or { _tags.Fallback }) do
		-- Pre-hook
		-- if ws.configure and type(ws.configure) == 'function' then ws.configure(ws) end
		if ws.configure and type(ws.configure) == 'function' then ws.configure(ws) end

		local layout = ws.layout
		if not layout and ws.layouts
			then layout = ws.layouts[1]
			else layout = awful.layout.layouts[1] end

		local extend = {
			selected = ( id == 1),
			layout = layout,
			layouts = ws.layouts or { layout }
		}

		local t = awful.tag.add( ws.visual, gears.table.join(ws, ws_opts, extend))

		-- Post-hook rules 
		if ws.rules and type(ws.rules) == 'function' then ws.rules(t) end
	end


	----------------
	-- Wibar(s)   --
	----------------
	for _, ln in ipairs(cfg.WIBAR or { }) do
		if ln[1] then
			ln.spawn.rate = cfg.RATE
			local bar = ln[1](ln.spawn, scr)

			-- Spawn bar, evaluate components, apply components
			local wbar =
				awful.wibar(bar.settings)
				wbar:setup(bar.components)

		else notify { title = 'Wibar spawn', text = 'Wibar spawn failed, bad definition?' } end
	end

	----------------
	-- Wibox(es)  --
	----------------
	for _, ln in ipairs(cfg.WIBOX or { }) do
		if ln[1] then
			local box = ln[1](ln.spawn, scr)

			-- local wbox =
			-- 	wibox(box.settings)
			-- 	_eval(box.components, src, box.settings)
				-- notify { text = gears.debug.dump_return{box.components}}
				-- wbox:setup(box.components)
		else notify { title = 'Wibox spawn', text = 'Wibox spawn failed, bad definition?' } end
	end


	-- local box = wibox({ width = 100, height = 100, screen = scr.index, ontop = false, x = 0, y = 0, type = 'toolbar', visible = true})
	-- box:setup()
end)

--------------------------------------------
-- Keybindings                            --
--------------------------------------------
local keybindings = (function()
	local global			= require('config.kbd.global')
	local layout			= require('config.kbd.layout')
	local wsmode			= require('config.kbd.workspace')


	local wsmodes			= {}
	for _, cfg in pairs(WORKSPACES) do
		for _, entry in ipairs(wsmode(cfg.KEY, cfg.NAME, screen[cfg.ID])) do
			table.insert(wsmodes, entry)
		end
	end

	return gears.table.join(global, wsmodes, layout)
end)()

root.keys(keybindings)

--------------------------------------------
-- Background                             --
--------------------------------------------
local bg = gears.filesystem.get_configuration_dir() .. 'img/bg/space3240.jpg'
require('lua.util').daemon(string.format([[gm convert '%s' -gamma '0.75' - | feh --bg-scale --no-xinerama -]], bg))

