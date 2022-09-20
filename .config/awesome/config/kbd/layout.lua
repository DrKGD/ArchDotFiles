---@diagnostic disable: undefined-global
--------------------------------------------
-- Imports                                --
--------------------------------------------
local notify		= require('naughty').notify
local awful			= require('awful')
local helper		= require('helpers.kbd')
local gears			= require('gears')
local mod				= helper.MODIFIERS
local bind			= helper.bind
local mode			= helper.mode
local helpadd		= require('awful.hotkeys_popup.widget').add_hotkeys
local lain			= require('lain')
local machi			= require('layout-machi')
-- local machina		= require('machina.methods')

--------------------------------------------
-- Utility functionalities              	--
--------------------------------------------
local abs = function(client)
	return { x = client.x - client.screen.geometry.x, y = client.y - client.screen.geometry.y }
end

-- Move floating window(s)
local float_move = function(direction)
	local float = (function()
		local lup = {
			left	= function(cl) cl:relative_move(-20, 0, 0, 0) end,
			right = function(cl) cl:relative_move(20, 0, 0, 0) end,
			up		= function(cl) cl:relative_move(0, -20, 0, 0) end,
			down	= function(cl) cl:relative_move(0, 20, 0, 0) end,
		}

		return lup[direction]
	end)()

	return function(c) float(c) end
end

-- Move towards (position)
-- + If finds neib, switches position
-- + Otherwise onto the next output (screen)
local tile_move = function(direction)
	local tile = (function()
		local lup = {
			left	= function(current, other) return other.x < current.x end,
			right	= function(current, other) return other.x > current.x end,
			down	= function(current, other) return other.y > current.y end,
			up		= function(current, other) return other.y < current.y end
		}

		return lup[direction]
	end)()

	return function(c)
		-- Swap if it has a neib on the way
		for _, k in ipairs(c.screen.selected_tag:clients()) do
			if not k.toggle and tile(c, k) then
				return awful.client.swap.bydirection(direction) end
		end

		-- Else move onto the next output, if any
		local screen_next = c.screen:get_next_in_direction(direction)
		if screen_next then c:move_to_screen(screen_next.index) end
	end
end

-- Resize in floating
local float_resize = function(direction)
	local float = (function()
		local lup = {
			left	= function(cl) cl:relative_move(0, 0, -20, 0) end,
			right = function(cl) cl:relative_move(0, 0, 20, 0) end,
			up		= function(cl) cl:relative_move(0, 0, 0, -20) end,
			down	= function(cl) cl:relative_move(0, 0, 0, 20) end,
		}

		return lup[direction]
	end)()

	return function(c) float(c) end
end

-- Resize while in tiling
local tile_resize = function(direction)
	local tile = (function()
		local lup = {
			left	= function() awful.tag.incmwfact(-0.050)		end,
			right = function() awful.tag.incmwfact(0.050)			end,
			up		= function() awful.client.incwfact(-0.050)	end,
			down	= function() awful.client.incwfact(0.050)		end,
		}

		return lup[direction]
	end)()

	return function() tile() end
end

---------------------------------------------
-- Internal functions                      --
---------------------------------------------
local smart_move = function(direction)
	local iffloat = float_move(direction)
	local iftile	= tile_move(direction)

	return function()
		-- Ensure client is selected
		local c = client.focus
		if not c then notify { text = 'No client is selected!' } return end

		-- If floating, just move it around as requested
		if c.floating then iffloat(c)
		else iftile(c) end
	end
end

local smart_resize = function(direction)
	local iffloat = float_resize(direction)
	local iftile	= tile_resize(direction)

	return function()
		local cl = client.focus
		if cl and cl.floating then
			iffloat(cl)
		else iftile() end
	end
end

-- Get current selected tag
local current_tag = function() return awful.screen.focused().selected_tag end

-- Default non-action
local no_action		= function(m, key, layout_name)
	if m then m = table.concat(m, '+') .. '+' end
	return function()
			notify {
				title = 'Missing binding',
				text = string.format('Key [%s%s] is not configured for [%s] layout!', m or '', key, layout_name)
			}
		end
	end

-- Which layout should handle
-- local handle_layouts = (function()
--
-- 	-- AwesoemWM stock layouts
-- 	local tbl = { }
-- 	for name, _ in pairs(awful.layout.suit) do
-- 		table.insert(tbl, name)
-- 	end
--
-- 	-- Lain layouts
-- 	local lain_layouts		= (function()
-- 		return {
-- 				lain.layout.termfair.name,
-- 				lain.layout.termfair.center.name,
-- 				lain.layout.cascade.name,
-- 				lain.layout.centerwork.name
-- 			}
-- 	end)()
--
-- 	for _, name in pairs(lain_layouts) do
-- 		table.insert(tbl, name)
-- 	end
--
-- 	local machi_layouts		= (function()
-- 		return {
-- 			machi.default_layout.name
-- 		}
-- 	end)()
--
-- 	for _, name in pairs(machi_layouts) do
-- 		table.insert(tbl, name)
-- 	end
--
-- 	return tbl
-- end)()

-- local tagBind = function(b)
-- 	-- TODO: Enhance with line of error
-- 	if not b.lhs then
-- 		notify { text = 'No key selected' } return end
--
-- 	-- Help tooltip
-- 	local help	= { }
--
-- 	-- Default bindings for missing modes
-- 	local lup		= { }
--
-- 	-- Apply defined bindings
-- 	for _, entry in ipairs(b) do
-- 		local lys = entry[1] or entry.lys
-- 		if type(lys) == 'string' then lys = { lys } end
-- 		if type(lys) ~= 'table'	then
-- 				-- TODO: Enhance with line of error and lhs/mod
-- 				notify { text = string.format('Wrong format binding') }
-- 				goto continue
-- 			end
--
-- 		-- Bind a mode
-- 		if entry.mode then
-- 			local md = {}
-- 				md.name		= string.format('%s', entry.mode)
-- 				md.lhs		= b.lhs
-- 				md.mod		= b.mod
-- 				md.binds	= entry.binds
--
-- 			-- Bind foreach layout defined below
-- 			local mode, mode_help = mode(md, true)
--
-- 			for _, ly in ipairs(lys) do
-- 				lup[ly]		= mode
--
-- 				-- Add tooltip for each mode 
-- 				local group = string.format('Layout %s', ly)
-- 				help[group] = {
-- 					{ modifiers = b.mod or { }, keys = { [b.lhs] = string.format('Enter [%s]', md.name)} } }
-- 			end
--
-- 			helpadd(mode_help)
--
-- 		-- Bind a key
-- 		else
--
-- 			-- Bind foreach layout defined below
-- 			for _, ly in ipairs(lys) do
-- 				if entry.desc then
-- 					local group = string.format('Layout %s', ly)
-- 					help[group] = {
-- 						{ modifiers = b.mod or { }, keys = { [b.lhs] = entry.desc } } }
-- 				end
--
-- 				lup[ly] = entry.on or no_action(b.mod, b.lhs, ly)
-- 			end
-- 		end
--
-- 		::continue::
-- 	end
--
-- 	-- Add tooltip
-- 	helpadd(help)
--
-- 	-- Apply binding
-- 	b.group = nil
-- 	b.desc	= nil
-- 	b.on		= function()
-- 		lup[current_tag().layout.name]()
-- 	end
--
-- 	return bind(b)
-- end

-- Returns the current tag
local current_tag = function()
	return awful.screen.focused().selected_tag end

local tagBind = function(b)
	-- ENHANCE: Better error handling (like a message or smh?)
	-- In case no key was selected
	local warn = function(msg)
		local info = debug.getinfo(3)
		notify { title = 'TagBind, bind ill formed',
			text = string.format('A given binding was ill formed, thus will not be active.\n%s\nAt line [%d]', msg, info.currentline)}
	end

	if not b.lhs then
		warn 'No key defined!' return end

	-- Dynamic fields 
	local genhelp = { }
	local genlup	= { }

	for _, entry in ipairs(b) do
		-- For which layout are being defined
		local lys = entry[1] or entry.lys
		if type(lys) == 'string'	then lys = { lys } end
		if type(lys) ~= 'table'		then
			notify('Layout definition is ill formed: ' .. tostring(lys))  return end


		-- Detect if a mode is being binded or a key
		if entry.mode then
			local md = { }
				md.name		= string.format('%s', entry.mode )
				md.lhs		= b.lhs
				md.mod		= b.mod
				md.binds	= entry.binds or { }

			-- Obtain raw mode definition
			local mode, modegenhelp = mode(md, true)

			-- Bind to each layout
			for _, ly in ipairs(lys) do
				genlup[ly] = mode
			end

		elseif entry.on then
			for _, ly in ipairs(lys) do
				genlup[ly] = entry.on
			end
		else warn 'Missing both [on] or [mode] in binding!' return end
	end

	-- The real binding will use the lookup table
	local pBind = { }
		pBind.lhs = b.lhs
		pBind.mod = b.mod
		pBind.on	= function()
			local now = current_tag().layout.name
			local on	= genlup[now] or no_action(pBind.mod, pBind.lhs, now)
			on()
		end

	return bind(pBind)
end

---------------------------------------------
-- Define layout-specific bindings         --
---------------------------------------------
local join = gears.table.join

local tilegroup =
	{ 'tile', 'tileleft', 'tileright', 'tiletop', 'tilebottom' }

local laingroup	=
	{ 'centerfair', 'termfair', 'centerwork'}

local machigroup =
	{ 'machi' }

-- Regroup tiled-like in this category
local tile_like = join(tilegroup, laingroup)


return gears.table.join(
	-- meta+hljk, movement
	tagBind { lhs = [[h]],
		mod		= mod.META,
		{ lys = join(tilegroup, machigroup),
				on		=	function() awful.client.focus.global_bydirection('left') end,
				desc	= 'Focus left' },

		-- { lys = machigroup,
		-- 		on = machina.focus_by_direction("left"),
		-- 		desc = 'Focus left' }
	},

	tagBind { lhs = [[j]],
		mod		= mod.META,
		{ lys =	join(tilegroup, machigroup),
				on		=	function() awful.client.focus.global_bydirection('down') end,
				desc	= 'Focus down' },
		--
		-- { lys = machigroup,
		-- 		on = machina.focus_by_direction("down"),
		-- 		desc = 'Focus down' }
	},

	tagBind { lhs = [[k]],
		mod		= mod.META,
		{ lys = join(tilegroup, machigroup),
				on		=	function() awful.client.focus.global_bydirection('up') end,
				desc	= 'Focus up' },

		-- { lys = machigroup,
		-- 		on = machina.focus_by_direction("up"),
		-- 		desc = 'Focus up' }
	},

	tagBind { lhs = [[l]],
		mod		= mod.META,
		{ lys = join(tilegroup, machigroup),
				on		=	function() awful.client.focus.global_bydirection('right') end,
				desc	= 'Focus right' },

		-- { lys = machigroup,
		-- 		on = machina.focus_by_direction("right"),
		-- 		desc = 'Focus up' }
	},

	-- meta+e, enter edit mode
	tagBind { lhs = [[e]],
		mod		= mod.META,
		{ lys = tilegroup,
				mode = 'edit',
				binds = {
					{ mod = mod.SHIFT, lhs = [[h]], no_exit = true, desc = 'Decrease window width',	on = smart_resize('left')},
					{ mod = mod.SHIFT, lhs = [[l]], no_exit = true, desc = 'Increase window width',	on = smart_resize('right')},
					{ mod = mod.SHIFT, lhs = [[k]], no_exit = true, desc = 'Decrease window height', on = smart_resize('up')},
					{ mod = mod.SHIFT, lhs = [[j]], no_exit = true, desc = 'Increase window height', on = smart_resize('down')},
					{ lhs = [[h]], no_exit = true, desc = 'Move left',	on = smart_move('left')},
					{ lhs = [[l]], no_exit = true, desc = 'Move right',	on = smart_move('right')},
					{ lhs = [[k]], no_exit = true, desc = 'Move up',		on = smart_move('up')},
					{ lhs = [[j]], no_exit = true, desc = 'Move down',	on = smart_move('down')},
					{ lhs = "[", no_exit = true, desc = 'Decrease number of masters', on = function() awful.tag.incnmaster(-1, nil, true) end},
					{ lhs = "]", no_exit = true, desc = 'Increase number of masters', on = function() awful.tag.incnmaster(1, nil, true) end},
					{ lhs = "-", no_exit = true, desc = 'Decrease number of columns', on = function() awful.tag.incncol(-1, nil, true) end},
					{ lhs = "=", no_exit = true, desc = 'Increase number of columns', on = function() awful.tag.incncol(1, nil, true) end},
				} },

		{ lys = machigroup,
				on = machi.default_editor.start_interactive,
				desc = 'Start machi editor' }
	},

	tagBind { lhs = [[e]],
		mod		= mod.META_CTRL,
		{ lys = machigroup,
				on = function() machi.switcher.start(client.focus) end,
				desc = 'Start machi layout editor' }
	},

	-- Split h/v like in i3!
	-- tagBind { lhs = [[s]],
	-- 	mod		= mod.META,
	-- 	{ lys = { 'tile', 'termfair' , 'centerfair', 'centerwork'},
	-- 			on = function() awful.rules.rules[1].callback = awful.client.setslave end,
	-- 			desc	= 'Run will use setslave' },
	-- },
	--
	-- tagBind { lhs = [[v]],
	-- 	mod		= mod.META,
	-- 	{ lys = { 'tile', 'termfair' , 'centerfair', 'centerwork'},
	-- 			on = function() awful.rules.rules[1].callback = awful.client.setmaster end,
	-- 			desc	= 'Run will use setmaster' },
	-- },

	-- meta+ctrl+hljk, move window
	tagBind { lhs = [[h]],
		mod		= mod.META_CTRL,
		{ lys = join(tilegroup, machigroup),
				on = smart_move('left'),
				desc	= 'Move current client left' },

		-- { lys = machigroup,
		-- 		on = machina.shift_by_direction("left", "swap"),
		-- 		desc = 'Move current client left' }
	},

	tagBind { lhs = [[j]],
		mod		= mod.META_CTRL,
		{ lys = tilegroup,
				on = smart_move('down'),
				desc	= 'Move current client down' },

		-- { lys = machigroup,
		-- 		on = machina.shift_by_direction("down", "swap"),
		-- 		desc = 'Move current client down' }
	},

	tagBind { lhs = [[k]],
		mod		= mod.META_CTRL,
		{ lys = tilegroup,
				on = smart_move('up'),
				desc	= 'Move current client up' },

		-- { lys = machigroup,
		-- 		on = machina.shift_by_direction("up", "swap"),
		-- 		desc = 'Move current client up' }
	},

	tagBind { lhs = [[l]],
		mod		= mod.META_CTRL,
		{ lys = tilegroup,
				on = smart_move('right'),
				desc	= 'Move current client right' },

		-- { lys = machigroup,
		-- 		on = machina.shift_by_direction("left", "swap"),
		-- 		desc = 'Move current client left' }
	}
)
