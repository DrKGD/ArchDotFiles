--------------------------------------------
-- Global imports                         --
--------------------------------------------
local notify		= require('naughty').notify
local gears			= require('gears')
local awful			= require('awful')
local layout		= require('wibox').layout
local theme			= require('beautiful')
local wibox			= require('wibox')

local M = {}

--------------------------------------------
-- Evaluate components in the ui          --
--------------------------------------------
M.eval = function(cmp, ui)
		if not cmp then return end

		-- Loop in reverse order over 'numeric' components
		for i = #cmp, 1, -1 do

			-- Explore deeper 
			if type(cmp[i]) == 'table' then
				M.eval(cmp[i], ui)

			-- Evaluate function types 
			elseif type(cmp[i]) == 'function' then

				-- LIMITATION: Won't be allowing more than one widget at the time per-eval 
				local rs = cmp[i](ui)

				-- LIMITATION: Won't care if it fails 
				cmp[i] = rs
				if rs.install_callback then
					rs.install_callback(cmp[i]) end

				-- Recurse
				M.eval(cmp[i], ui)

			-- Ignore all other types
			else return end
		end
	end

--------------------------------------------
-- Wibar(s)                               --
--------------------------------------------
local wibar_properties_defaults = {
		name				= 'noname',
		orientation = 'horizontal',
		width				= 24,
		height			= 24,
		default_horizontal = 'top',
		default_vertical   = 'left',
		bg = theme.bg_normal or '#121212',
		fg = theme.fg_normal or '#FFFFFF',
		margins			= { 0, 0 }
	}

M.wibar = function(properties, components, signals)
	local n = function(text) notify { title = 'Wibar definition', text = text }  end

	properties	= properties or { }
		properties.orientation	= (function()
			local orient = properties.orientation or 'horizontal'
			if orient ~= 'horizontal' and orient ~= 'vertical' then
				n(string.format("Unknown orientation '%s', '%s' will be used instead!", orient, wibar_properties_defaults.orientation))
				return wibar_properties_defaults.orientation
			end

			return orient
		end)()

		properties.name					= properties.name or wibar_properties_defaults.name
		properties.width				= properties.width or (function()
			if properties.orientation == 'horizontal' then
					return '100%' end
			return wibar_properties_defaults.width
		end)()

		properties.height				= properties.height or (function()
			if properties.orientation == 'vertical' then
					return '100%' end
			return wibar_properties_defaults.height
		end)()

		properties.bg						= properties.bg or wibar_properties_defaults.bg
		properties.fg						= properties.fg or wibar_properties_defaults.fg

	components 	= components or { }
		components.expand				= components.expand or 'none'
		components.layout				= components.layout or (function()
			if properties.orientation == 'vertical' then
				return layout.flex.vertical end
			return layout.align.horizontal
		end)()

	signals			= signals or { }

	return function(spawn, scr)
		spawn = spawn or { }
			spawn.position = spawn.position or (function()
				if properties.orientation == 'horizontal' then
					n(string.format("No spawn position were defined for <%s>, defaulting to '%s'!",
							properties.name, wibar_properties_defaults.default_horizontal))
					return wibar_properties_defaults.default_horizontal
				end

				n(string.format("No spawn position were defined for <%s>, defaulting to '%s'!",
						properties.name, wibar_properties_defaults.default_vertical))
				return wibar_properties_defaults.default_vertical
			end)()

		-- Width as a percentage string
		if type(properties.width) == 'string' and properties.width:sub(#properties.width) == '%' then
			properties.width = tonumber(properties.width:sub(1, -2)) / 100 * scr.geometry.width end

		-- Height as a percentage string
		if type(properties.height) == 'string' and properties.height:sub(#properties.height) == '%' then
			properties.height = tonumber(properties.height:sub(1, -2)) / 100 * scr.geometry.height end

		-- Margins will be added above/below and before/after based off the orientation
		local scaling = (function()
			if properties.orientation == 'horizontal' then return scr.geometry.height end
			return scr.geometry.width
		end)()

		for i, m in ipairs(spawn.margins or { }) do
			if type(m) == 'string' and m:sub(#m) == '%' then
				spawn.margins[i] = tonumber(m:sub(1, -2)) / 100 * scaling
			end
		end

		spawn.margins = spawn.margins or { }
			spawn.margins[1] = spawn.margins[1] or wibar_properties_defaults.margins[1]
			spawn.margins[2] = spawn.margins[2] or wibar_properties_defaults.margins[2]

		properties.true_height	= properties.height
		properties.true_width		= properties.width
		if properties.orientation == 'horizontal' then
			properties.height = properties.height + spawn.margins[1] + spawn.margins[2]
		else
			properties.width	= properties.width + spawn.margins[1] + spawn.margins[2]
		end

		-- Evaluate components
		local settings = {
			name					= properties.name,
			signals				= properties.signals,
			orientation 	= properties.orientation,
			width					= properties.width,
			height				= properties.height,
			true_width		= properties.true_width,
			true_height		= properties.true_height,
			rate					= spawn.rate,
			bg						= spawn.bg or properties.bg,
			fg						= spawn.fg or properties.fg,
			position			= spawn.position,
			margins				= spawn.margins,
			screen				= scr,
		}

		local clone = { widget = wibox.container.margin, gears.table.clone(components) }
		M.eval(clone, settings)
		if properties.orientation == 'horizontal' then
			clone.top = spawn.margins[1]
			clone.bottom = spawn.margins[2]
		else
			clone.left = spawn.margins[1]
			clone.right = spawn.margins[2]
		end

		return {
			settings = settings,
			components = clone
		}
	end
end

--------------------------------------------
-- Wibox(es)                              --
--------------------------------------------
local wibox_properties_defaults = {
		name				= 'noname',
		orientation = 'horizontal',
		position		= { x = 0, y = 0, anchor = 'top-left'},
		bg					= theme.bg_normal or '#121212',
		fg 					= theme.fg_normal or '#FFFFFF',
	}

local wibox_required = {
		'width', 'height'
	}

local posx_byanchor = {
	left		= function(ratio, _, geo, displ)		return ratio * geo.width + displ.x end,
	center	= function(ratio, size, geo, displ)	return ratio * geo.width - size.width / 2 + displ.x / 2 end,
	right		= function(ratio, size, geo, _)	return ratio * geo.width - size.width end,
}

local posy_byanchor = {
	top 		= function(ratio, _, geo, displ)		return ratio * geo.height + geo.y + displ.y end,
	center	= function(ratio, size, geo, displ) return ratio * geo.height - size.height / 2 + displ.y / 2 end,
	bottom	= function(ratio, size, geo, _) return ratio * geo.height - size.height end,
}

M.wibox = function(properties, components, signals)
	local n = function(text) notify { title = 'Wibox definition', text = text }  end
	if not properties or type(properties) ~= 'table' then
		n "Could not define wibox, missing properties!"; return
	end

	-- Check for missing, required properties
	for _, f in ipairs(wibox_required) do
		if not properties[f] then
			n(string.format("Could not define wibox, missing properties:%s!", f))
			return
		end
	end

	properties.orientation	= (function()
		local orient = properties.orientation or 'horizontal'
		if orient ~= 'horizontal' and orient ~= 'vertical' then
			n(string.format("Unknown orientation '%s', '%s' will be used instead!", orient, wibox_properties_defaults.orientation))
			return wibox_properties_defaults.orientation
		end

		return orient
	end)()

	properties.name					= properties.name or wibox_properties_defaults.name
	properties.bg						= properties.bg		or wibox_properties_defaults.bg
	properties.fg						= properties.fg		or wibox_properties_defaults.fg

	components 	= components or { }
		components.expand				= components.expand or 'none'
		components.layout				= components.layout or (function()
			if properties.orientation == 'vertical' then
				return layout.flex.vertical end
			return layout.align.horizontal
		end)()

	signals			= signals or { }

	return function(spawn, scr)
		spawn = spawn or { }
			spawn.position					= spawn.position or wibox_properties_defaults.position
			spawn.position.x				= spawn.position.x or wibox_properties_defaults.position.x
			spawn.position.y				= spawn.position.y or wibox_properties_defaults.position.y
			spawn.position.anchor		= spawn.position.anchor or wibox_properties_defaults.position.anchor
			if spawn.visible == nil then spawn.visible = true end

		-- Width as a percentage string
		if type(properties.width) == 'string' and properties.width:sub(#properties.width) == '%' then
			properties.width = tonumber(properties.width:sub(1, -2)) / 100 * scr.workarea.width end

		-- Height as a percentage string
		if type(properties.height) == 'string' and properties.height:sub(#properties.height) == '%' then
			properties.height = tonumber(properties.height:sub(1, -2)) / 100 * scr.workarea.height end

		-- Position by anchor point
		local yanchor, xanchor = spawn.position.anchor:match('(%a+)-(%a+)')
			if type(spawn.position.x) == 'string' and spawn.position.x:sub(#spawn.position.x) == '%' then
				spawn.position.x = posx_byanchor[xanchor](tonumber(spawn.position.x:sub(1, -2)) / 100, properties, scr.geometry, scr.workarea) end
			if type(spawn.position.y) == 'string' and spawn.position.y:sub(#spawn.position.y) == '%' then
				spawn.position.y = posy_byanchor[yanchor](tonumber(spawn.position.y:sub(1, -2)) / 100, properties, scr.geometry, scr.workarea) end

		return {
			settings = {
				name				= properties.name,
				signals			= properties.signals,
				orientation = properties.orientation,
				width				= properties.width,
				height			= properties.height,
				bg					= properties.bg,
				fg					= properties.fg,
				x						= spawn.position.x,
				y						= spawn.position.y,
				visible			= spawn.visible,
				screen			= scr,
				type				= 'toolbar'
			},

			components = components
		}
	end
end


return M
