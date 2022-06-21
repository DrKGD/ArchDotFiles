---------------------
-- Loadfile macro  --
---------------------
local SCRIPT_PATH = 'setup'
local function dofile(file)
	local f, e = loadfile(string.format('%s/%s/%s.lua', vim.fn.stdpath('config'), SCRIPT_PATH, file))

	-- Print error
	if e then print(vim.inspect(e)) return end
	return f()
end

-----------------------------
-- Plugins and bootstrap   --
-----------------------------
if dofile('pkgmanager') then return end

-----------------
-- Profile     --
-----------------
dofile('profile')

-----------------
-- Editor      --
-----------------
dofile('editor')

-----------------
-- Keybindings --
-----------------
dofile('keybindings')
