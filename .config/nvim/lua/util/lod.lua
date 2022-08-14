-------------------------------------
-- Load functionalities            --
-------------------------------------
local M = {}

M.lod		= function(fn)
	if not require('util.path').fileExists(fn)
		then error(string.format("<%s> file does not exist!", fn), 0) return end

	local f, e = loadfile(fn)

	if e then error(string.format("<%s> ill-formed!", fn), 0) return end
	if not f then error(string.format("<%s> returned null!", fn), 0) return end
	return f()
end

return M
