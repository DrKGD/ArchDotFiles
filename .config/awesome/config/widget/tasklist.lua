--------------------------------------------
-- Imports                    						--
--------------------------------------------
local notify		= require('naughty').notify
local awful			= require('awful')
local gears			= require('gears')

local theme			= require('beautiful')
local wibox			= require('wibox')
	local _c				=	wibox.container
	local _w				=	wibox.widget
	local _l				= wibox.layout
	local _s				= require('config.widget.shapes')

local helperkbd		= require('helpers.kbd')
	local mod					= helperkbd.MODIFIERS
	local mouse				= helperkbd.MOUSE

local _m				= require('lain').util.markup
local rubato		= require('rubato')
local icondir		= require('gears').filesystem.get_configuration_dir() .. 'img/icons/'

--------------------------------------------
-- Re-usable components										--
--------------------------------------------
local buttons = gears.table.join (
		awful.button(mod.NONE, mouse.LEFT,	function(c)
			client.focus = c
			c:raise()
		end)

		-- TODO: Filter out toggle from this list
		-- awful.button(mod.CTRL, mouse.UP,		function(t) awful.tag.viewnext(t.screen) end),
		-- awful.button(mod.CTRL, mouse.DOWN,	function(t) awful.tag.viewprev(t.screen) end)
	)

--------------------------------------------
-- Task, which are currently opened       -- 
--------------------------------------------
local M = { }

-- Only apps on primary tag
M.apps_onprimarytag = function(override)
	override = override or { }

	return function(ui)
		return awful.widget.tasklist {
			-- For this screen only, exclude toggle-able tags
			screen   = override.screen or ui.screen,

			-- Show only selected tags from this screen, excluding toggle(s)
			filter   = function(client, screen)
				local tag = client.first_tag
				return tag.selected and not tag.toggle and tag.screen == screen
			end,

			buttons = buttons,

			layout = {
				layout = _l.fixed.horizontal,
				spacing = 8,
				spacing_widget = {
					valign = 'bottom',
					halign = 'center',
					widget = wibox.container.place,
					{ forced_width	= 4,
						thickness			= 4,
						widget				= wibox.widget.separator,
						color					= theme.tasklist_bg_focus,
						forced_height = ui.true_height * 0.5 }
				}
			},

			widget_template = {
				---@diagnostic disable-next-line: unused-local
				create_callback = function(self, c, index, objects)
					local border = self:get_children_by_id('border_role')[1]
					local bborder = self:get_children_by_id('bigborder_role')[1]

					-- On spawn, detect if the application was focussed
					if c == client.focus then
							bborder.bg = theme.tasklist_bg_focus
							border.bg = theme.tasklist_border_focus
						end

					c:connect_signal('focus', function(_)
						bborder.bg = theme.tasklist_bg_focus
						border.bg = theme.tasklist_border_focus
					end)

					c:connect_signal('unfocus', function(_)
						bborder.bg = theme.tasklist_bg_normal
						border.bg = theme.tasklist_border_normal
					end)
				end,

				id			= 'master_role',
				widget	= _l.fixed.vertical,
				{ widget	= _c.background,
					id			= 'bigborder_role',
					bg			= theme.tasklist_bg_normal,
					shape		= _s.fround,
					opacity = 0.65,
					{ widget	= _c.margin,
						top = 4, left = 4, right = 4,
						{ widget	= _c.background,
							id			= 'border_role',
							bg			= theme.tasklist_border_normal,
							forced_height = 4 }}},

				{ layout = _l.stack,
					-- Background
					{ widget	= _c.background,
						opacity = 0.65,
						id			= 'background_role',
						shape		= override.shape,
							{ widget = _c.place } },

					-- Icon 
					{ widget	= _c.margin,
						top			= ui.true_height * 0.10,
						bottom	= ui.true_height * 0.10,
						left		= ui.true_width * 0.0035,
						right 	= ui.true_width * 0.0035,
						{ widget	= _w.imagebox,
							image = gears.color.recolor_image(icondir .. 'application-outline.png', '#FFFFFF'),
							id			= 'icon_role'  }}},
			},
		}
	end
end


return M
