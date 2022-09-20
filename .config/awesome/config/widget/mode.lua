--------------------------------------------
-- Imports                    						--
--------------------------------------------
local theme			= require('beautiful')
local gears			= require('gears')
	local _s				= gears.shape

local wibox			= require('wibox')
	local _c				=	wibox.container
	local _w				=	wibox.widget
	local _l				= wibox.layout

local _m				= require('lain').util.markup

--------------------------------------------
-- Mode widget, detects modes! O_O				--
--------------------------------------------
return function(override)
	override = override or { }

	return function(ui)
		local default =
			{ bg = theme.mode_bg_default, fg = theme.mode_fg_default, img = theme.mode_img_default }

		local dict = function(mode)
				local _n = mode:gsub("%W", ''):lower()

				return {
						fg	= theme['mode_fg_'	..	_n] or default.fg,
						bg	= theme['mode_bg_'	..	_n] or default.bg,
						img = theme['mode_img_' ..	_n] or default.img
					}
			end

		local mode = _w {
			install_callback = function(self)
				local icon		= self:get_children_by_id('icon_role')[1]
				local label		= self:get_children_by_id('text_role')[1]
				local back		= self:get_children_by_id('background_role')[1]
				self._restore = { label = markup or '' }

				awesome.connect_signal("mode::enter", function(event)
					local d					= dict(event.mode)

					-- Set content
					label.markup		= _m.fontfg(string.format('scientifica Bold %f', ui.true_height * 0.40), d.fg, 'mode: ' .. event.mode:upper())
					back.bg					= d.bg
					back.visible		= true
					icon.image			= gears.color.recolor_image(d.img, d.fg)


					-- Set opacity to 'visible'
					self:emit_signal('widget::updated')
				end)

				awesome.connect_signal("mode::leave", function(event)
					-- Set content
					label.markup		= ''
					back.bg					= default.bg
					back.visible		= false
					icon.image			= nil

					self:emit_signal('widget::updated')
				end)
			end,

			-- Container
			widget	= _l.stack,
			id			= 'master_role',
			-- Background
			{ widget	= _c.background,
				id			= 'background_role',
				opacity = 0.75,
				shape		= override.shape,
				bg			= default.bg,
				visible	= false,
				{ widget = _c.place }},

			-- Mode 
			{ widget	= _c.margin,
				top			= ui.true_height * 0.065,
				bottom	= ui.true_height * 0.065,
				left		= ui.true_width * 0.0095 - ui.true_height * 0.125,
				right 	= ui.true_width * 0.0095,
				{ widget = _l.align.horizontal,
					-- Icon
					{ widget	= _c.margin,
						top			= ui.true_height * 0.125,
						bottom	= ui.true_height * 0.125,
						left		= ui.true_height	* 0.125,
						right 	= ui.true_height	* 0.125,
						{ widget	= _w.imagebox,
							id			= 'icon_role' }},

					-- Label 
					{ widget	= _w.textbox,
						id			= 'text_role',
						align		= 'right',
						valign	= 'center' }}},
		}

		return mode
	end
end

