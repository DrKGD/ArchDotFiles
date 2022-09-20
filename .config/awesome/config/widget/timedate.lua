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

--------------------------------------------
-- Time widget                    				--
--------------------------------------------
local M = { }
M.time = function(override)
	override = override or { }

	return function(ui)
		local fface = function(scale) return string.format('scientifica Bold %f', ui.true_height * scale) end
		local pangoclock =
			_m.fontfg(fface(0.45), theme.clock_hour_fg, '%H')		..
			_m.fontfg(fface(0.45), theme.clock_minute_fg, ':%M')	..
			_m.fontfg(fface(0.45), theme.clock_second_fg, ':%S')


		return {
			layout	= _l.stack,
			{ widget	= _c.background,
				bg			= theme.clock_bg,
				opacity = 0.75,
				shape		= override.shape,
				{ widget = _c.place }},

			{ widget	= _c.margin,
				top			= ui.true_height * 0.350,
				bottom	= ui.true_height * 0.200,
				left		= ui.true_height * 0.350,
				right 	= ui.true_height * 0.200,
				{ refresh = override.refresh or 0.4,
					format = pangoclock,
					widget = _w.textclock }}
		}
	end
end

M.timedate = function(override)
	override = override or { }

	return function(ui)
		local fface = function(scale) return string.format('scientifica Bold %f', ui.true_height * scale) end
		local pangoclock =
			_m.fontfg(fface(0.45), theme.clock_hour_fg, '%H')		..
			_m.fontfg(fface(0.45), theme.clock_minute_fg, ':%M')	..
			_m.fontfg(fface(0.45), theme.clock_second_fg, ':%S')

		local pangodate	=
			_m.fontfg(fface(0.25), theme.clock_date_fg, '%b %d, %A')


		return {
			layout	= _l.stack,
			{ widget	= _c.background,
				bg			= theme.clock_bg,
				opacity = 0.45,
				shape		= override.shape,
				{ widget = _c.place }},

				{ widget	= _c.margin,
					top			= ui.true_height * 0.100,
					left		= ui.true_width * 0.013,
					right 	= ui.true_width * 0.010,
					{ layout = _l.fixed.vertical,
						{ refresh = override.refresh or 0.4,
							format = pangoclock,
							align	= 'center',
							valign	= 'bottom',
							widget = _w.textclock },
						{ refresh = override.refresh or 0.4,
							align	= 'center',
							valign	= 'top',
							format = pangodate,
							widget = _w.textclock }}}
		}
	end
end


return M
