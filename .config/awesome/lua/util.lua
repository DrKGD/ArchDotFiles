--------------------------------------------
-- Imports                                --
--------------------------------------------
local awful		= require('awful')
local gears		= require('gears')
local notify	= require('naughty').notify

--------------------------------------------
-- Utility funcitons                      --
--------------------------------------------
local M = {}

-- Spawn as a daemon
-- THANKS: https://github.com/Stup0r38/iceberg-awesome/blob/master/awesome/apps.lua
M.daemon = function(app)
	local fmt = [[pgrep -u $USER -x %s >/dev/null || (%s)]]

	local firstspace = app:find([[ ]])
	local proc = app
	if firstspace then
		proc = app:sub(0, firstspace - 1)
	end

	awful.spawn.with_shell(fmt:format(proc, app), false)
end

-- Compacts array
	-- Returnsa compacted version of the table
M.compact = function(tbl, original_size)
	local compacted = { }


	local j=1
	for i=1, original_size do
		notify { text = tostring(i) .. ' ' .. tostring(j)}
		if tbl[i] ~= nil then
				compacted[j] = tbl[i]; j = j + 1;
			end
	end

	return compacted
end

-- Filter table content in place
--  Does not alter order
M.filter = function(tbl, filter)
	if type(filter) ~= 'function' then
		return tbl end

	local size = #tbl
	notify { text = tostring(size) }
	for i = 1, size do
		-- If it does not match the filter parameters
		if not filter(tbl[i]) then
			tbl[i] = nil end
	end

	tbl = M.compact(tbl, size)

	-- Returns table for convenience
	return tbl
end


-- Store and restore (deez nutz)! 
M.store = function(where, lambda)
	-- Write file
	local file = io.open(where, 'w+')
	if not file then return end

	-- Evaluate content
	if type(lambda) == 'function' then
		local content = lambda()
		if content then
			if type(content) ~= 'table' then
					content = { tostring(content) }
				end

			file:write(table.concat(content, '\n'), '\n')
		end
	else
		file:write(tostring(lambda), '\n')
	end

	file:close()
end

M.restore = function(from, lambda)
	-- Read file
	local file = io.open(from, 'r')
	if not file then return end

	-- Read into a table
	local content = { }
	for line in file:lines() do
		table.insert(content, line) end
	file:close()

	-- Run lambda
	if type(lambda) == 'function' then
			lambda(content)
		end

	return content
end

-- Table from CSV (or any character, really) 
M.csvtable = function(inputstr, sep)
	sep = sep or ';'

	local tbl = { }
	for str in string.gmatch(inputstr,  string.format("([^%s]+)", sep)) do
		table.insert(tbl, str)
	end

	return tbl
end

-- No restore token 
M.set_norestore = function()
	-- Open file in path
	local path = os.getenv("NORESTORE")
	if not path then return false end

	-- Write token, tbh the empty file is enough
	local f = io.open(path, 'w+')
	if not f then return false end
	f:close()

	return true
end

M.consume_norestore = function()
	local path = os.getenv("NORESTORE")
	if not path then return false end
	if gears.filesystem.file_readable(path) then
		awful.spawn.with_shell(string.format([[rm "%s"]], path))
		return true
	end

	return false
end

return M
