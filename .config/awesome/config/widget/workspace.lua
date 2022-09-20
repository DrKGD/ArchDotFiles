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

local helperkbd		= require('helpers.kbd')
	local mod					= helperkbd.MODIFIERS
	local mouse				= helperkbd.MOUSE

local _m				= require('lain').util.markup
local rubato		= require('rubato')
	
--------------------------------------------
-- Re-usable components										--
--------------------------------------------
local buttons = gears.table.join (
		awful.button(mod.NONE, mouse.LEFT,	function(t) if not t.selected then t:view_only() end end),

		-- TODO: Filter out toggle from this list
		awful.button(mod.CTRL, mouse.UP,		function(t) awful.tag.viewnext(t.screen) end),
		awful.button(mod.CTRL, mouse.DOWN,	function(t) awful.tag.viewprev(t.screen) end)
	)

--------------------------------------------
-- Tags, which workspace are you working  -- 
--------------------------------------------
local M = { }

-- Toggle workspaces
M.toggle		= function(override)
	override = override or { }

	return function(ui)
		local _hovertime = {
			intro			= 0.05,
			duration	= 0.25,
			rate			= ui.rate,
			easing		= rubato.zero
		}

		local dict = function(tagname)
				local _n = tagname:gsub("%W", ''):lower()

				return {
						fg	= theme['taglist_fg_toggle_'	..	_n] or theme.taglist_fg_toggle,
						bg	= theme['taglist_bg_toggle_'	..	_n] or theme.taglist_bg_toggle,
					}
			end

		return {
			---@diagnostic disable-next-line: unused-local
			install_callback = function(self)
				local placeholder = self[1]:get_children_by_id('placeholder_role')[1]
				self[1]._restore = { opacity = placeholder.opacity }

				local changes = function()
					placeholder.opacity = 0.0
					self[1]:emit_signal('widget::updated')
				end

				local revert = function()
					placeholder.opacity = self[1] ._restore.opacity
					self[1]:emit_signal('widget::updated')
				end

				awesome.connect_signal("awesomewm::configuration_done", function()
					local function ctags()
						if override.screen then
							return screen[override.screen].selected_tags end
						return ui.screen.selected_tags
					end

					-- local tags	= { }

					---@diagnostic disable-next-line: undefined-global
					for _, tag in ipairs(root.tags()) do
						---@diagnostic disable-next-line: undefined-global
						tag:connect_signal("property::selected", function()
							-- Toggle tag-switch selection
							for _, t in ipairs(ctags()) do
								if t.toggle and t.selected then return changes() end end

							-- No tag was selected
							revert()
						end)
					end
				end)
			end,

			widget = _l.stack,
				_w { widget = _c.background,
						id = 'placeholder_role',
						forced_width = ui.true_width * 0.015,
						shape = override.shape,
						opacity = 0.65,
						bg = theme.taglist_bg_placeholder,
						{ widget = _c.place } },

				awful.widget.taglist {
					-- LMB deselects 
					buttons  = gears.table.join (
						awful.button(mod.NONE, mouse.LEFT,	function(t) t.selected = false end)
					),

					-- For this screen only, exclude toggle-able tags
					screen   = override.screen or ui.screen,
					filter   = function(tag)
						return tag.toggle and tag.selected
					end,

					-- Powerline style!
					style		= {
						shape = override.shape
					},

					layout = {
						layout  = wibox.layout.fixed.horizontal,
						spacing = override.spacing,
					},

					widget_template = {
							-- Callback
							---@diagnostic disable-next-line: unused-local
							create_callback = function(self, tag, index, tags)
								local d			= dict(tag.name)
								local back	= self:get_children_by_id('toggle_role')[1]
									back.bg = d.bg
								local hover = self:get_children_by_id('overlay_role')[1]
								local icon	= self:get_children_by_id('toggle_img_role')[1]
									icon.image = tag.icon or theme.taglist_toggle_img

								tag:connect_signal("property::selected", function()
									if tag.selected then
											back.bg = d.bg
											icon.image = gears.color.recolor_image(tag.icon, d.fg)
											tag:emit_signal('widget::updated')
										end
								end)

								local timer = rubato.timed(_hovertime)
									timer:subscribe(function(animpos)
										hover.opacity = 0.65 * animpos
										back.opacity	= 1.0 - animpos
										self:emit_signal('widget::updated')
									end)

								self:connect_signal('mouse::enter', function() timer.target = 1 end)
								self:connect_signal('mouse::leave', function() timer.target = 0 end)
							end,

							-- Container
							id			= 'master_role',
							widget	= _l.stack,
								-- Background
								{ widget	= _c.background,
									opacity = 0.65,
									shape		= override.shape,
									id			= 'toggle_role',
									bg			= theme.taglist_bg_toggle,
									{ widget = _c.place }},

								-- Icon 
								{ widget	= _c.margin,
									top			= ui.true_height * 0.15,
									bottom	= ui.true_height * 0.15,
									left		= ui.true_width * 0.0080,
									right 	= ui.true_width * 0.0080,
									{ widget	= _w.imagebox,
										id			= 'toggle_img_role' }},

								-- Hover-overlay 
								{ widget	= _c.background,
									shape		= override.shape,
									bg			= theme.taglist_bg_hover_toggle,
									opacity = 0.0,
									id			= 'overlay_role',
									{ widget = _c.margin,
										{ widget	= _w.textbox,
											align		= 'center',
											font		= string.format("scientifica %f", ui.true_height * 0.45),
											markup	= '<span>OFF</span>'}}}
						}
					}
				}
	end
end




-- Permanent selected
M.permanent_extended	= function(override)
	override = override or { }

	return function(ui)
		return awful.widget.taglist {
			-- For this screen only, exclude toggle-able tags
			screen   = override.screen or ui.screen,
			filter   = function(tag)
				return not tag.toggle
			end,

			-- LMB selects, Wheels skips to the next workspace
			buttons  = buttons,

			-- Layout
			layout = {
				layout = _l.fixed.horizontal,
				spacing = override.spacing,
			},

			-- Style
			style = {
				shape = override.shape
			},

			widget_template = {
				-- Update function
				---@diagnostic disable-next-line: unused-local
				create_callback = function(self, tag, index, tags)
					local back	= self:get_children_by_id('background_role')[1]
					local master = self:get_children_by_id('master_role')[1]
					local tagmaster = self:get_children_by_id('tagmaster_role')[1]
					local hover = self:get_children_by_id('overlay_role')[1]
					local hovertxt = self:get_children_by_id('overlay_txt_role')[1]

					-- Setup tag text
					local tagtxt = self:get_children_by_id('tagtxt_role')[1]
						tagtxt.markup = _m.fontfg(string.format('scientifica Bold %f', ui.true_height * 0.65), theme.taglist_fg_focustxt, tag.name)

					-- Handle overlay opacity in animation
					local op		= 0.65
					local hover_animation = {
						intro			= 0.05,
						duration	= 0.25,
						rate			= ui.rate,
						easing		= rubato.zero }

					local timer = rubato.timed(hover_animation)
						timer:subscribe(function(animpos)
							hover.opacity = op * animpos
							back.opacity	= op - ( op * animpos)
							self:emit_signal('widget::updated')
						end)

					self:connect_signal('mouse::enter', function() timer.target = 1 end)
					self:connect_signal('mouse::leave', function() timer.target = 0 end)

					-- Display only selected tag name
					if tag.selected then
						master.spacing = override.spacing 
						hovertxt.markup = '<span>NOW</span>'
						tagmaster.visible = true
					end

					tag:connect_signal('property::selected', function()
						if tag.selected then
							master.spacing = override.spacing
							hovertxt.markup = '<span>NOW</span>'
							tagmaster.visible = true
						else
							master.spacing = 1
							hovertxt.markup = '<span>GO</span>'
							tagmaster.visible = false
						end
					end)
				end,

				id			= 'master_role',
				widget	= _l.fixed.horizontal,
				spacing = 1,
				{ layout = _l.stack,
					-- Background
					{ widget	= _c.background,
						shape		= override.shape,
						id			= 'background_role',
							{ widget = _c.place } },

					-- Icon 
					{ widget	= _c.margin,
						top			= ui.true_height * 0.1,
						bottom	= ui.true_height * 0.1,
						left		= ui.true_width * 0.0060,
						right 	= ui.true_width * 0.0055,
						{ widget	= _w.imagebox,
							id			= 'icon_role'  }},

					-- Hover-overlay 
					{ widget	= _c.background,
						shape		= override.shape,
						bg			= theme.taglist_bg_hover,
						id			= 'overlay_role',
						{ widget	= _w.textbox,
							align		= 'center',
							id			= 'overlay_txt_role',
							font		= string.format("scientifica %f", ui.true_height * 0.45),
							markup	= '<span>GO</span>'}}},

				{ id = 'tagmaster_role',
					layout = _l.stack,
					visible = false,
					{ widget	= _c.background,
						visible = true,
						opacity	= 0.35,
						shape		= override.shape,
						bg			= theme.taglist_bg_focustxt },

					{ widget	= _c.margin,
						left		= ui.true_width * 0.0125,
						right 	= ui.true_width * 0.0125,
						{ widget	= _w.textbox,
							forced_width = ui.true_width * 0.05,
							align		= 'center',
							id			= 'tagtxt_role' }}},
			}
		}
	end
end

-- Permanent selected
M.permanent_strict = function(override)
	override = override or { }

	return function(ui)
		return awful.widget.taglist {
			-- For this screen only, exclude toggle-able tags
			screen   = override.screen or ui.screen,
			filter   = function(tag)
				return not tag.toggle
			end,

			-- LMB selects, Wheels skips to the next workspace
			buttons  = buttons,

			-- Layout
			layout = {
				layout = _l.fixed.horizontal,
				spacing = override.spacing,
			},

			-- Style
			style = {
				shape = override.shape
			},

			widget_template = {
				-- Update function
				---@diagnostic disable-next-line: unused-local
				create_callback = function(self, tag, index, tags)
					local back	= self:get_children_by_id('background_role')[1]
					local hover = self:get_children_by_id('overlay_role')[1]
					local hovertxt = self:get_children_by_id('overlay_txt_role')[1]

					-- Handle overlay opacity in animation
					local op		= 0.65
					local hover_animation = {
						intro			= 0.05,
						duration	= 0.25,
						rate			= ui.rate,
						easing		= rubato.zero }

					local timer = rubato.timed(hover_animation)
						timer:subscribe(function(animpos)
							hover.opacity = op * animpos
							back.opacity	= op - ( op * animpos)
							self:emit_signal('widget::updated')
						end)

					self:connect_signal('mouse::enter', function() timer.target = 1 end)
					self:connect_signal('mouse::leave', function() timer.target = 0 end)

					-- Display only selected tag name
					if tag.selected then
						hovertxt.markup = '<span>NOW</span>'
					end

					tag:connect_signal('property::selected', function()
						if tag.selected then
							hovertxt.markup = '<span>NOW</span>'
						else
							hovertxt.markup = '<span>GO</span>'
						end
					end)
				end,

				id			= 'master_role',
				widget	= _l.fixed.horizontal,
				{ layout = _l.stack,
					-- Background
					{ widget	= _c.background,
						shape		= override.shape,
						id			= 'background_role',
							{ widget = _c.place } },

					-- Icon 
					{ widget	= _c.margin,
						top			= ui.true_height * 0.1,
						bottom	= ui.true_height * 0.1,
						left		= ui.true_width * 0.0090,
						right 	= ui.true_width * 0.0085,
						{ widget	= _w.imagebox,
							id			= 'icon_role'  }},

					-- Hover-overlay 
					{ widget	= _c.background,
						shape		= override.shape,
						bg			= theme.taglist_bg_hover,
						id			= 'overlay_role',
						{ widget	= _w.textbox,
							align		= 'center',
							id			= 'overlay_txt_role',
							font		= string.format("scientifica %f", ui.true_height * 0.45),
							markup	= '<span>GO</span>'}}}
			}
		}
	end
end

-- Only permanent 
M.permanent_active = function(override)
	override = override or { }

	if not override.invert then override.invert = false end

	return function(ui)
		return awful.widget.taglist {
			-- For this screen only, exclude toggle-able tags
			screen   = override.screen or ui.screen,
			filter   = function(tag)
				return not tag.toggle and tag.selected
			end,

			widget_template = {
				-- Update function
				---@diagnostic disable-next-line: unused-local
				create_callback = function(self, tag, index, tags)
					-- Setup tag text
					local tagtxt = self:get_children_by_id('tagtxt_role')[1]
						tagtxt.markup = _m.fontfg(string.format('scientifica Bold %f', ui.true_height * 0.65), theme.taglist_fg_focustxt, tag.name)
				end,

				layout = _l.fixed.horizontal,
				spacing = override.spacing,
				not override.invert and { widget = _c.background,
					bg = theme.taglist_bg_focustxt,
					shape = override.nameshape,
					forced_width = 35 },
				{ layout = _l.stack,
					{ widget	= _c.background,
						visible = true,
						opacity	= 0.35,
						shape		= override.shape,
						bg			= theme.taglist_bg_focustxt },

					{ widget	= _c.margin,
						left		= ui.true_width * 0.0125,
						right 	= ui.true_width * 0.0125,
						{ widget	= _w.textbox,
							forced_width = ui.true_width * 0.05,
							align		= 'center',
							id			= 'tagtxt_role' }}},
				override.invert and { widget = _c.background,
					bg = theme.taglist_bg_focustxt,
					shape = override.nameshape,
					forced_width = 35 },
			}
		}

	end
end


return M
