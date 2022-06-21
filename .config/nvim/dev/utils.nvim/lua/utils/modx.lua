local M = {}

-- Returns the nth digit of a number (e.g. kthDigit(305, 0) -> 5, kthDigit(305, 2) -> 3)
function M.kthDigit(digit, nth)						return math.fmod(math.floor(digit / 10^nth), 10) end

-- EXCL: Not really used anymore
function M.ratio(value, max, steps)				return vim.fn.floor(value / max * steps) end
function M.percentage(value, max)					return M.ratio(value, max, 100) end
function M.lookupRatio(tbl, value, max)		return tbl[M.ratio(value, max, #tbl - 2) + 1] end

-- Center text in a string of set size
function M.center(stringsize, content)
	local space = stringsize - #content
	local lspace, rspace = space/2, space/2
	if math.fmod(space, 2) ~= 0 then rspace = rspace + 1 end
	return string.rep(' ', lspace), string.rep(' ', rspace)
end

-- Return filesize as a human-readable format
local fs = {"B", "kB", "MB", "GB", "TB", "PB", "EB", "?B" }
function M.humanReadable(size)
	if size == -1 then size = 0 end
	local id = 1

	while size > 1024 do
		size = size/1024
		id = id + 1
	end

	return string.format('%.2f%s', size, fs[id])
end

--- Tokenize strings
function M.tokenize(etok, tokens, max_tokens, escape_token)
	local nontoken = '(%%%%s)'
	local token = '(%%s)'
	local escape = escape_token or '@@@'
	local revertnontoken = '%%%%s'

	-- Match previous character
	local match = etok:match(token)
	if not match then return etok end

	-- Replace all %%. with @@@
	etok = etok:gsub(nontoken, escape)

	-- Error flag, prevent infinite
	local limit, at = max_tokens or 10, 0

	-- Token list or Token lambda?
	local tokenLambda = function(pat, tkn, nontkn, esc, tkn_str) return tokens[pat] end
	if type(tokens) == 'function' then tokenLambda = tokens end

	-- Check if there was a match and retrieve previous character
	while match do
		-- Retrieve next token, if fails, no command
		local nextToken = tokenLambda(at, token, revertnontoken, escape, etok)
		if not nextToken then a('Operation Cancelled!') return end
		etok = etok:gsub(token, nextToken, 1)

		-- Infinite loop check
		at = at + 1
		assert(at ~= limit, 'Parameter limit reached!')

		-- Repeat the check
		match = etok:match(token)
	end

	-- Revert non-tokens
	etok = etok:gsub(escape, revertnontoken)

	return etok
end

--- Highlight and Colors
-- Get color from highlight group
function M.getColor(from, where)
	local color = vim.fn.synIDattr(vim.fn.hlID(from), where or 'fg')
	if vim.fn.empty(color) == 0 then return color end
	return "#000000"
end

-- Set color for components
function M.setHi(dict)
	local generate = function(name, val)
		if val then return string.format('%s=%s ', name, val) end
	end

	for k, v in pairs(dict) do
		if type(v) == 'boolean'	and v == false then
			vim.cmd(string.format('highlight %s NONE', k))
		end

		if type(v) == 'table' then
			local cterm			= generate('cterm'	, v['cterm'])		or ''
			local ctermfg		= generate('ctermfg', v['ctermfg']) or ''
			local ctermbg		= generate('ctermbg', v['ctermbg']) or ''
			local gui				= generate('gui'		, v['gui'])			or ''
			local guifg			= generate('guifg'	, v['guifg']) 	or ''
			local guibg			= generate('guibg'	, v['guibg']) 	or ''
			vim.cmd(string.format('highlight %s %s%s%s%s%s%s', k, cterm, ctermfg, ctermbg, gui, guifg, guibg))
		end
	end
end


-- Cast hex to rgb3
function M.hex2rgb(hex)
	hex = hex:gsub("#","")
	return
		tonumber("0x"..hex:sub(1,2), 16),
		tonumber("0x"..hex:sub(3,4), 16),
		tonumber("0x"..hex:sub(5,6), 16)
end

-- Cast rgb3 to hex
function M.rgb2hex(r,g,b)
	return string.format('#%02x%02x%02x', r,g,b)
end

local function mix(n1, n2, Q)
	if Q>1 then Q=1
	elseif Q<0 then Q=0
	end

	return math.floor(((n1 * Q) + (n2 * (1 - Q))) + 0.5)
end

-- Mix two colors:
--	Smaller amounts tends towards the first
--	Bigger amounts tends towards the second
function M.mix(hexA, hexB, Q)
	local rA, gA, bA = M.hex2rgb(hexA)
	local rB, gB, bB = M.hex2rgb(hexB)
	local rC, gC, bC = mix(rA, rB, Q), mix(gA, gB, Q), mix(bA, bB, Q)
	return M.rgb2hex(rC,gC,bC)
end


return M



