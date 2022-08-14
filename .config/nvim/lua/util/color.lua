-------------------------------------
-- Color manipolation functions    --
-------------------------------------

local M = {}

-- Cast hex to rgb3
M.hex2rgb = function(hex)
	hex = hex:gsub("#","")
	return
		tonumber("0x"..hex:sub(1,2), 16),
		tonumber("0x"..hex:sub(3,4), 16),
		tonumber("0x"..hex:sub(5,6), 16)
end

-- Cast hex to rgb3ratio
M.hex2rgbratio = function(hex)
	hex = hex:gsub("#","")
	return
		tonumber("0x"..hex:sub(1,2), 16)/255,
		tonumber("0x"..hex:sub(3,4), 16)/255,
		tonumber("0x"..hex:sub(5,6), 16)/255
end

-- Cast rgb3 to hex
M.rgb2hex = function(r,g,b)
	return string.format('#%02x%02x%02x', r,g,b)
end

-- Cast rgb3ratio to hex
M.rgbratio2hex = function(r,g,b)
	return string.format('#%02x%02x%02x', r*255, g*255, b*255)
end


-- Internal mix
local function mix(n1, n2, Q)
	if Q>1 then Q=1
	elseif Q<0 then Q=0
	end

	return math.floor(((n1 * Q) + (n2 * (1 - Q))) + 0.5)
end

-- Mix two colors:
--	Smaller amounts tends towards the first
--	Bigger amounts tends towards the second
M.mix = function(hexA, hexB, Q)
	local rA, gA, bA = M.hex2rgb(hexA)
	local rB, gB, bB = M.hex2rgb(hexB)
	local rC, gC, bC = mix(rA, rB, Q), mix(gA, gB, Q), mix(bA, bB, Q)
	return M.rgb2hex(rC,gC,bC)
end

-- Calculate a shade of the given color by factor
local function darken(n, f)
	return n * (1 - f) end

M.darken = function(hex, factor)
	local rF, gF, bF = M.hex2rgb(hex)
	return M.rgb2hex(darken(rF, factor),darken(gF, factor),darken(bF, factor))
end

-- Calculate a tint of the given color by factor
local function lighten(n, f)
	return math.min(n + (255 - n) * f, 255) end

M.lighten = function(hex, factor)
	local rF, gF, bF = M.hex2rgb(hex)
	return M.rgb2hex(lighten(rF, factor),lighten(gF, factor),lighten(bF, factor))
end

-- Inverse color
local function complement(n)
	return 255 - n end

M.invert = function(hex)
	local rF, gF, bF = M.hex2rgb(hex)
	return M.rgb2hex(complement(rF), complement(gF), complement(bF))
end

-- Return luminance (perceived luminosity) of a color using HSP color model
-- Notice that it is not perfectly accurate as it should've been calculated using this formula
-- sqrt(0.299*R^2.2 + 0.587*G^2.2 + 0.114*B^2.2) ^ (1/2.2)
-- THANKS: https://alienryderflex.com/hsp.html
M.luminance = function(hex)
	local rF, gF, bF = M.hex2rgbratio(hex)
	return math.min(math.sqrt( 0.299 * (rF * rF) + 0.587 * (gF * gF) + 0.144 * (bF * bF)), 1)
end

return M
