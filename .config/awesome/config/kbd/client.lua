---@diagnostic disable: undefined-global
--------------------------------------------
-- Imports                                --
--------------------------------------------
local helper		= require('helpers.kbd')
local mod				= helper.MODIFIERS
local bind			= helper.bind
local awful			= require('awful')
local notify		= require('naughty').notify

--------------------------------------------
-- Client keybindings         						--
--------------------------------------------
return require('gears').table.join(
	-- Kill client 
	-- ... Actually do toggle on toggle tags
	bind { lhs = [[q]],
		mod		= mod.META,
		on		= function(cl)
			local tag = cl.first_tag

			-- Deselect toggle tags
			if tag.toggle then
				tag.selected = false end

			-- Kill if it is a normal application (= not spawned in a toggle workspace)
			if not tag.keep then
				cl:kill() end
		end,
		group = 'AwesomeWM',
		desc	= 'Kill client'
	},


	-- Kill client 
	-- ... Wait, same thing as above? Na, that FORCE kills.
	bind { lhs = [[q]],
		mod		= mod.META_CTRL,
		on		= function(cl)
			local tag = cl.first_tag

			-- Deselect toggle tags
			if tag.toggle then
				tag.selected = false end

			-- Kill application
			cl:kill()
		end,
		group = 'AwesomeWM',
		desc	= 'Kill client'
	},

	-- Toggle floating mode 
	bind { lhs = [[Return]],
		mod		= mod.META,
		on		= awful.client.floating.toggle,
		group = 'AwesomeWM',
		desc	= 'Toggle floating'
	},

	-- Toggle fullscreen mode 
	bind { lhs = [[f]],
		mod		= mod.META,
		on		= function(c) c.fullscreen = not c.fullscreen; c:raise() end,
		group = 'AwesomeWM',
		desc	= 'Toggle fullscreen'
	}
)
