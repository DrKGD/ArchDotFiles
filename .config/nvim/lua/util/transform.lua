-------------------------------------
-- Content manipulation            --
-------------------------------------
local M = {}

-------------------------------------
-- UTF8 string length              --
-------------------------------------
M.len = function(str)
	local _, c = str:gsub("[^\128-\193]", "");
	return c
end

-- Retrieve length of nth line
M.line_len = function(str, nth)
	local lines = M.split(str)
	return M.len(lines[nth or 1])
end

-- Count occurences of string
M.count_string = function(str, to_count)
	local _, count = str:gsub(to_count, '')
	return count
end

-- Retrieve longest line
M.max_len	= function(str)
	local lines = M.split(str)
	local index, max = 0, 0
	for i, line in ipairs(lines) do
		local now = M.len(line)
		if now > max then
				max = now
				index = i
			end
	end

	return max, lines[index]
end

-------------------------------------
-- Interleave tables      				 --
-------------------------------------
-- If tables are uneven, it does not matter!
M.interleave = function(tables, after_each)
	if #tables == 1 then return tables[1] end

	-- Get biggest table
	local max = 0
	for _, entry in ipairs(tables) do
		max = math.max(max, #entry) end

	-- Interleave
	local tbl = {}
	for i=1,max do
			for t=1, #tables do
					if tables[t][i] then
						table.insert(tbl, tables[t][i]) end
				end

			table.insert(tbl, after_each or '\n')
		end

	return tbl
end

-------------------------------------
-- Convert table to string				 --
-------------------------------------
-- Join tables in a string using joinstr string
M.join = function(tbl, joinstr)
	if type(tbl) == 'string' then return tbl end
	return table.concat(tbl, joinstr or '\n')
end

-- Join multiple tablesi in a string, inteleaving them lines
M.join_interleaved = function(tables)
	-- Has strings in it, must be a simple string table
	if type(tables[1]) == 'string' then return table.concat(tables) end

	-- Only one table, thus only join
	if #tables == 1 then return table.concat(tables[1]) end
	return table.concat(M.interleave(tables))
end

-------------------------------------
-- Aligning strings       				 --
-------------------------------------
local alignment_directions = {
	-- |%s ---- |
	left		= function(line, max, set_length)
			line = string.rep(' ', max - M.len(line)) .. line
			return line .. string.rep(' ', set_length - M.len(line))
		end,

	-- | ---- %s|
	right		= function(line, max, set_length)
			line = string.rep(' ', max - M.len(line)) .. line
			return string.rep(' ', set_length - M.len(line)) .. line 
		end,

	-- | --%s-- |
	center	= function(line, max, set_length)
			line = string.rep(' ', max - M.len(line)) .. line
			local spc = (set_length - M.len(line)) / 2
			local floorspc = math.floor(spc)

			if floorspc ~= spc then
				return string.rep(' ', floorspc) .. line .. string.rep(' ', floorspc + 1) end
			return string.rep(' ', floorspc) .. line .. string.rep(' ', floorspc)
		end,

	justified = function(line, _, set_length)
			-- Count zero occurences
			local _, matches = line:gsub('%z', '')

			-- Calculate space to set_length, then divide equally and get reminder
			local spc = (set_length - M.len(line) + matches)
			local floorspc = math.floor(spc / matches)
			local spcstring = string.rep(' ', floorspc + 1)
			local spcleft = spc - floorspc * matches

			-- Generate array in order (first, last, second, penultimate, third ... )
			local order = (function()
				local tbl		= {}

				for i=1, spcleft/2 do
					tbl[tostring(i)] = true
					tbl[tostring(matches - i + 1)] = true
				end

				-- Add reminder if required
				if math.fmod(spcleft, 2) == 1 then
					tbl[tostring(math.ceil(spcleft / 2))] = true end

				return tbl
			end)();

			local imatch = 0
			line = line:gsub('%z', function()
				imatch = imatch + 1
				if order[tostring(imatch)] then
					return spcstring end
				return spcstring:sub(2)
			end)

			return line
		end
}

M.align = function(str, set_length, direction)
	direction = direction or 'left'
	if not alignment_directions[direction] then
		error(string.format("<%s> is not a valid alignment direction!", direction)) end

	-- Get longest string
	local split = M.split(str)
	local max		= 0
	for _, entry in ipairs(split) do
		max = math.max(max, M.len(entry)) end

	-- Align each line, using set_length as total length (or max)
	local lambda = alignment_directions[direction]
	local tbl = {}
	for _, line in ipairs(M.split(str)) do
			table.insert(tbl, lambda(line, max, set_length or max))
		end

	return M.join(tbl)
end

-------------------------------------
-- Convert string to table				 --
-------------------------------------
local split_functions = {}

-- Split by newline
split_functions.by_newline = function(str)
		local tbl = {}

		-- Scan for newlines
		str:gsub("([^\n]*)\n?", function(e)
			table.insert(tbl, e)
		end)

		-- Remove last newline
		tbl[#tbl] = nil

		return tbl
	end

-- Split line every n characters (or '\n')
split_functions.by_number_of_characters = function(str, amount)
		local tbl = {}

		local processed = 1
		while processed < #str do
			-- Get number of characters equal to amount
			local substring		=
				str:sub(processed, processed + amount - 1)

			-- Check if it has newline
			local newline			= substring:find("\n")
			processed = processed + (newline or amount)

			-- Add line or a substring of it
			if newline then
				table.insert(tbl, substring:sub(1, newline - 1))
			else table.insert(tbl, substring) end
		end

		return tbl
	end

-- Split using separator, thus exclude it from string
split_functions.by_character = function(str, sep)
		-- Replace given separator character in string with null-byte character
		str = str:gsub(sep, '\0')

		-- Split string using null-byte as a separation character
		--  also consume newlines if any
		local tbl = {}
		str:gsub('\n*([^%z]+)%z?', function(add)
			for _, l in ipairs(split_functions.by_newline(add)) do
				table.insert(tbl, l)
			end

		end)

		return tbl
	end

M.split = function(str, splitpar)
	-- If already a table, noop
	if type(str) == 'table' then return str end

	-- Define lambda to split
	-- + splitpar is nil		-> split using newline as separator
	-- + splitpar is string -> split using char as separator
	-- + splitpar is number -> split having each line up to n characters
	-- n.b. methods will also take in consideration newlines
	--  e.g. split('hello;me;you\n;cat', ';') => { 'hello', 'me', 'you', '', 'cat'}
	--  thus strip newlines characters if this is unwanted!
	local lambda
	if			type(splitpar) == 'nil' then
		lambda = split_functions.by_newline
	elseif	type(splitpar) == 'string' then
		lambda = split_functions.by_character
	elseif	type(splitpar) == 'number' then
		lambda = split_functions.by_number_of_characters
	end

	return lambda(str, splitpar)
end

return M
