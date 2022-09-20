---@diagnostic disable: undefined-global
--------------------------------------------
-- Imports                                --
--------------------------------------------
local awful			= require('awful')
local helper		= require('helpers.kbd')
local mod				= helper.MODIFIERS
local mouse			= helper.MOUSE

--------------------------------------------
-- Mouse keybindings         						  --
--------------------------------------------
return require('gears').table.join(
	-- Click-to-focus 
	awful.button(mod.NONE, mouse.LEFT, function (c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),

	-- Resize with mouse + win
	awful.button(mod.META, mouse.LEFT, function (c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
	end)
)
