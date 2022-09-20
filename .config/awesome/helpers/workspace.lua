---@diagnostic disable: undefined-global

--------------------------------------------
-- Imports                                --
--------------------------------------------
local notify		= require('naughty').notify
local gears			= require('gears')
local awful			= require('awful')

--------------------------------------------
-- Functions                              --
--------------------------------------------
local M = {}

-- Order of screen(s)
local detected_screens = {}
for scr in screen do
		for name, _ in pairs(scr.outputs)	 do
			detected_screens[name] = scr.index
		end
	end

-- Define workspace configuration
-- + name: workspace name (screen)
-- + key: which key to access workspace-specific keybindings
-- + rate: 'refresh rate' of the screen, for animations
-- + tags: which tags are associated with the workspace 
-- + wibar: wibar(s)
-- + wibox: wibox(es)
M.define = function(name, key, rate, tags, wibar, wibox)
	if not key then
		notify { title = 'Error in workspace definition', text = 'Missing key!'} return end

	if not tags then
		notify { title = 'Error in workspace definition', text = 'Missing tags!'} return end

	return {
			NAME	= name,
			ID		= detected_screens[name] or '?',
			RATE	= rate, KEY		= key,
			TAGS	= tags,
			WIBAR	= wibar or { },
			WIBOX = wibox or { },
		}
end

--------------------------------------------
-- Modifying workspace                    --
--------------------------------------------

-- Append these rules to the existing workspace definition
M.alter	= function(apply, inject_rules)
	return function(set)
		for n, k in pairs(apply or { }) do
			set[n] = k
		end

		if inject_rules and type(inject_rules) == 'function' then
			set.rules = inject_rules end
	end
end

-- Number of masters increment with the number of clients thus having only one slave
-- + in tile left, the slave's on the left
-- + in tile right, the slave's on the right 
M.fixed = function(apply, inject_rules)
	return M.alter(apply, function(self)
		local function filtered_clients(tag)
			local cclients = 0
			for _, c in ipairs(tag:clients()) do
				if c.type == 'normal' and not c.floating then
					cclients = cclients + 1 end
			end

			return cclients
		end

		-- Mantain 1:4 ratio
		self:connect_signal("tagged", function(tag)
			filtered_clients(tag)
			self.master_count = math.max(filtered_clients(tag) - 1, 1)
		end)

		self:connect_signal("untagged", function(tag)
			filtered_clients(tag)
			self.master_count = math.max(filtered_clients(tag) - 1, 1)
		end)

		if inject_rules and type(inject_rules) == 'function'
			then inject_rules(self) end
	end)
end

local check_lup = { }

-- TEST: Requires more testing
awesome.connect_signal("client::new", function(client)
	for tagname, entry in pairs(check_lup) do
		-- notify { text = 'Requires: ' .. tagname .. ';' .. name}
		-- notify { text = 'Spawn: ' .. client.first_tag.name .. ';' .. client.class }
		if client.first_tag.name == entry.tag.name then
			for _, app in ipairs(entry.apps) do
				if client.class == app and not entry.tag['_' .. app] then
					entry.tag['_' .. app] = client
					if type(entry.action) == 'function' then
						entry.action(client) end

					-- notify { text = 'hi ' .. client.name }
				end
			end
		end
	end
end)

-- TEST: Requires more testing
awesome.connect_signal("client::dead", function(client)
	for tagname, entry in pairs(check_lup) do
		for _, app in ipairs(entry.apps) do
			if entry.tag['_' .. app] == client then
				-- notify { text = 'client is ded :(' .. client.name }

				for _, c in ipairs(entry.tag:clients() or { }) do
					if c.class == app then
						entry.tag['_' .. app] = c
						if type(entry.action) == 'function' then
							entry.action(c) end
						-- notify { text = 'new client set to ' .. c.name }
						return
					end
				end

				-- notify { text = 'client deleted'}
				entry.tag['_' .. app] = nil
			end
		end
	end
end)

-- Move detected app(s) to the right
M.fixed_setslave = function(apply, apps, inject_rules)
	return M.fixed(apply, function(self)
		if type(apps) ~= 'table' then apps = { apps } end
		check_lup[self.name] = { tag = self, apps = apps , action = awful.client.setslave }

		if inject_rules and type(inject_rules) == 'function'
			then inject_rules(self) end
	end)
end

-- Set everything as slave on connect 
M.fixed_newisslave = function(apply, inject_rules)
	return M.fixed(apply, function(self)
		self:connect_signal("tagged", function(_, c)
			awful.client.setslave(c)
		end)

		if inject_rules and type(inject_rules) == 'function'
			then inject_rules(self) end
	end)
end

return M
