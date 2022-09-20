--------------------------------------------
-- Imports                                --
--------------------------------------------
local helper		= require('helpers.kbd')
local mod				= helper.MODIFIERS
local mode			= helper.mode

--------------------------------------------
-- Workspace keybindings!                 --
--------------------------------------------

local abs_tag = function(t)
	return function()
		-- Do not reselect
		if not t.selected then
			t:view_only()
		end
	end
end

local set_tag = function(t, dontfollow)
	return function()
		local client = client.focus
		if not client then return end

		client:move_to_tag(t)
		if not dontfollow then abs_tag(t) end
	end
end

return function(key, name, scr)
	local tags = scr.tags

	local binds = {}
	for id, t in ipairs(tags) do
		if not t.toggle then
			table.insert(binds, { lhs = id, on = abs_tag(t), desc = string.format([[switch to tag '%s']], t.name )})
			table.insert(binds, { lhs = id, mod = mod.SHIFT, on = set_tag(t), desc = string.format([[move and follow to tag '%s']], t.name)})
			table.insert(binds, { lhs = id, mod = mod.ALT, on = set_tag(t, true), desc = string.format([[move to tag '%s']], t.name)})
		end
	end

	return mode({ lhs = key, mod = mod.META, name = string.format('Workspace %s', name), binds = binds})
end


