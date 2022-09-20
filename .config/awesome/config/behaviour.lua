---@diagnostic disable: undefined-global
--------------------------------------------
-- Imports                                --
--------------------------------------------
local awful		= require('awful')
local gears		= require('gears')
local theme		= require('beautiful')

local naughty = require('naughty')
	local notify	= naughty.notify

local ruled		= require('ruled')
--------------------------------------------
-- Define global rules to respect   			--
--------------------------------------------
ruled.client.connect_signal('request::rules', function()
	-- Every client must respect these 
	ruled.client.append_rule {
			id = 'global',
			rule = { },
			properties = {
				-- Default values
				focus					= awful.client.focus.filter,
				raise					= true,
				screen				= awful.screen.preferred,
				placement			= awful.placement.no_overlap + awful.placement.no_offscreen, -- Bind these specific keys
				keys					= require('config.kbd.client'),
				buttons				= require('config.kbd.buttons'),

				-- Set border size and color
				border_width	= theme.border_width,
				border_color	= theme.border_color,
			}
		}

	-- Telegram's media viewer always floating 
	ruled.client.append_rule {
			id = 'floating',
			rule = { name = "Media viewer" },
			rule_any = { class = "telegram-desktop" },
			properties = {
				floating					= true,
				ontop							= true,
				titlebars_enabled = false,
				fullscreen				= true,
				border_width			= 0,
			},
		}

	-- Other applications that has to be floating
	ruled.client.append_rule {
			id = 'floating',
			rule_any = { class = { "feh", "PeaZip" } },
			properties = {
				floating					= true,
				ontop							= true,
				titlebars_enabled = true,
				fullscreen				= false,
				border_width			= 5,

				-- Reposition 
				callback = function(c)
					c.width = c.screen.workarea.width * 0.75
					c.height = c.screen.workarea.height * 0.75
					awful.placement.centered(c)
				end
			},
		}

	-- Dialogs have titlebars
	ruled.client.append_rule {
		id         = "titlebars",
		rule_any   = { type = { "dialog" } },
		properties = { titlebars_enabled = true      }
	}
end)

--------------------------------------------
-- Configuration                          --
--------------------------------------------
-- Use the HiQuality version of icons (64x64) if available
awesome.set_preferred_icon_size(64)

-- Center dialogs
client.connect_signal('manage', function(c)
    -- Center dialogs over parent
    if c.transient_for then
        awful.placement.centered(c, {
            parent = c.transient_for
        })
        awful.placement.no_offscreen(c)
    end
end)

-- Default layout 
awful.layout.layouts = {
		awful.layout.suit.tile,
	}

-- Enable focus and unfocus border(s)
client.connect_signal("focus",		function(c) c.border_color = theme.border_focus end)
client.connect_signal("unfocus",	function(c) c.border_color = theme.border_normal end)

-- On focus, raise client on top
client.connect_signal("focus",		function(c) c.ontop = true end)

-- Enable autofocus
require('awful.autofocus')

-- Signal new and dead clients, 
client.connect_signal("manage", function (c)
	awesome.emit_signal('client::new', c) end)
-- N.B.: dead clients do NOT have a first_tag field (c.first_tag)
client.connect_signal("unmanage", function (c)
	awesome.emit_signal('client::dead', c) end)

-- Floating always on top
client.connect_signal('property::floating', function(c)
	if c.floating then c.ontop = true end
end)

-- Store toggle selected tag 
gears.timer.delayed_call(function()
	tag.connect_signal('property::selected', function(t)
		if not t.toggle then
			if not t.selected then
				-- After switch, toggle becomes first-tag for a moment 
				local togg = t.screen.selected_tags[1]
				t._hasToggle = togg
			elseif t._hasToggle then
				t._hasToggle.selected = true
			end

		else
			-- On toggle deselection
			if not t.selected then
				local perm = t.screen.selected_tags[1]
				if perm then perm._hasToggle = nil end
			end

		end


	end)
end)


