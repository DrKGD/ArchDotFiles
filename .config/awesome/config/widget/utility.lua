---@diagnostic disable: need-check-nil
--------------------------------------------
-- Imports                    						--
--------------------------------------------
local theme			= require('beautiful')

local wibox			= require('wibox')
	local _c				=	wibox.container
	local _w				=	wibox.widget
	local _l				= wibox.layout
	local _m				= require('lain').util.markup

local volwidget	= require('awesome-wm-widgets.volume-widget.volume')

--------------------------------------------
-- Utility widget(s)               				--
--------------------------------------------
local M = { }

M.systray = function(override)
	override = override or { }

	return function(ui)
		return {
			layout	= _l.stack,
			{ widget	= _c.background,
				bg			= theme.bg_abs_systray,
				shape		= override.shape,
				{ widget = _c.place }},

			{ widget	= _c.place,
				{ widget	= _c.margin,
					left = ui.true_height * 0.20,
					right = ui.true_height * 0.20,
					{ widget = _w.systray,
						forced_width = ui.true_height * 0.85 }}}
		}
	end
end

M.volume = function(override)
	override = override or { }

	return function(ui)
		-- return volwidget()
		-- return lain.widget.pulse {
			-- timeout = 0.5,
			-- settings = function()
			-- 	local volume = volume_now.left
			--
			-- 	widget:set_markup(lain.util.markup("#330000", volume))
			-- end
			-- settings = function()
			-- 	vlevel = volume_now.left .. "-" .. volume_now.right .. "% | " .. volume_now.device
			-- 	if volume_now.muted == "yes" then
			-- 		vlevel = vlevel .. " M"
			-- 	end
			--
			-- 	widget:set_markup(lain.util.markup("#7493d2", vlevel))
			-- end
		-- }

	end
end


return M
