-------------------------------------
-- ASCII characters								 --
-------------------------------------
local ASCII_SYM = {}
ASCII_SYM.A = [[
 ▄▄▄ 
█   █
█▀▀▀█
█   █
▀   ▀
]]

ASCII_SYM.B	= [[
▄▄▄▄ 
█   █
█▄▄▄▀
█   █
▀▀▀▀ 
]]

ASCII_SYM.C	= [[
▄▄▄▄▄
█   ▀
█    
█   ▄
▀▀▀▀▀
]]

ASCII_SYM.D	= [[
▄▄▄▄ 
█   █
█   █
█   █
▀▀▀▀ 
]]

ASCII_SYM.E	= [[
▄▄▄▄▄
█    
█▀▀▀▀
█    
▀▀▀▀▀
]]

ASCII_SYM.F	= [[
▄▄▄▄▄
█    
█▀▀▀▀
█    
▀    
]]

ASCII_SYM.G	= [[
▄▄▄▄▄
█   ▀
█    
█ ▀▀█
▀▀▀▀▀
]]

ASCII_SYM.H = [[
▄   ▄
█   █
█▀▀▀█
█   █
▀   ▀
]]

ASCII_SYM.I = [[
▄▄▄▄▄
  █  
  █  
  █  
▀▀▀▀▀
]]

ASCII_SYM.J = [[
  ▄▄▄
    █
▄   █
█   █
 ▀▀▀ 
]]

ASCII_SYM.K = [[
▄   ▄
█  ▄▀
███  
█  ▀▄
▀   ▀
]]

ASCII_SYM.L = [[
▄    
█    
█    
█    
▀▀▀▀▀
]]


ASCII_SYM.M = [[
▄   ▄
█▀▄▀█
█ ▀ █
█   █
▀   ▀
]]


ASCII_SYM.N = [[
▄   ▄
█▀▄ █
█ ▀▄█
█  ▀█
▀   ▀
]]


ASCII_SYM.O = [[
 ▄▄▄ 
█   █
█   █
█   █
 ▀▀▀ 
]]

ASCII_SYM.P = [[
▄▄▄▄ 
█   █
█▀▀▀ 
█    
▀    
]]

ASCII_SYM.Q = [[
 ▄▄▄ 
█   █
█ █ █
█ ▀█▀
 ▀▀ ▀ 
]]

ASCII_SYM.R = [[
▄▄▄▄ 
█   █
█▀▀▀▄
█   █
▀   ▀
]]

ASCII_SYM.S = [[
 ▄▄▄▄
█    
▀▀▀▀█
    █
▀▀▀▀ 
]]

ASCII_SYM.T = [[
▄▄▄▄▄
  █  
  █  
  █  
  ▀  
]]

ASCII_SYM.U	= [[
▄   ▄
█   █
█   █
█   █
 ▀▀▀ 
]]

ASCII_SYM.V	= [[
▄   ▄
█   █
█   █
 █ █ 
  ▀  
]]


ASCII_SYM.W = [[
▄   ▄
█   █
█ ▄ █
█▄▀▄█
▀   ▀
]]


ASCII_SYM.X = [[
▄   ▄
▀▄ ▄▀
  █  
▄▀ ▀▄
▀   ▀
]]

ASCII_SYM.Y = [[
▄   ▄
▀▄ ▄▀
  █  
  █  
  ▀  
]]


ASCII_SYM.Z = [[
▄▄▄▄▄
    ▄
  ▄▀ 
▄▀   
▀▀▀▀▀
]]

ASCII_SYM['!'] = [[
▄
█
█
▀
▀
]]

ASCII_SYM['?'] = [[
 ▄▄▄ 
█   █
  ▄▄█
  ▀  
  ▀  
]]

ASCII_SYM['|']= [[
▄
█
█
█
▀
]]

ASCII_SYM.ERROR = [[
▄  ▄▄▄ 
█ █   █
█   ▄▄█
▀   ▀  
▀   ▀  
]]

ASCII_SYM[' '] = [[
 
 
 
 
 
]]

-------------------------------------
-- Functions       								 --
-------------------------------------
local M = {}

-- Get table of tables with elements
local spc = require('util.transform').split(ASCII_SYM[' '])
function M.getASCII(input)
	local tbl = {}
	local spaces = #input - 1
	input:gsub(".", function(c)
			table.insert(tbl, require('util.transform').split(ASCII_SYM[c] or ASCII_SYM.ERROR))
			if spaces>0 then table.insert(tbl, spc); spaces = spaces - 1 end
		end)

	return tbl
end

-- Returns the iphotetical size of a string in input
function M.getIphoteticalSize(input)
	if not input then return 0 end
	local line_len = require('util.transform').line_len
	local count = 0
	input:gsub(".", function(c)
			count = count + line_len(ASCII_SYM[c] or ASCII_SYM.ERROR)
		end)

	return count + #input * line_len(ASCII_SYM[' ']) - 1
end

function M.concat(input)
	-- Retrieve letters
	local ascii = {}
	local spaces = #input - 1
	input:gsub(".", function(c)
		table.insert(ascii, ASCII_SYM[c] or ASCII_SYM.ERROR)
		if spaces>0 then table.insert(ascii, ASCII_SYM[' ']); spaces = spaces - 1 end
	end)

	-- Concat ascii letters
	local ascii_art = {}
	for _, sym in ipairs(ascii) do
		local index = 1
		for line in sym:gmatch("[^\r\n]+") do
			-- print(line)
			ascii_art[index] = ( ascii_art[index] or '' ) .. line
			index = index + 1
		end
	end

	return ascii_art
end

return M 
