-- Global default configuration
local DEFAULT = {
	FONT = {
		MAX				= 18.0,
		MIN				= 12.0,
		SET				= 14.0,
		STEP			= 1
	},

	MOUNTPOINT	= os.getenv("MOUNTPOINT"),
	STATES			= 5,
	CONFIG_PATH	= require('util').dir(require('wezterm').config_file)
}

-- Platform-specific configuration
local PROFILES		= {}

PROFILES.DESKTOP	= {
	FONT = {
		MAX				= 18.0,
		MIN				= 10.0,
		SET				= 10.0,
		STEP			= 2
	}
}

PROFILES.LAPTOP		= {}

return (function()
	local merge		= require('util').merge

	local lup = {
		['DESKTOP-DRKGD'] = 'DESKTOP',
		['LAPTOP-DRKGD'] = 'LAPTOP'
	}

	local handle = io.popen("cat /etc/hostname | tr -d '\n'")
	if not handle then return end
	local result = handle:read("*a")
	handle:close()

	if lup[result] then
		return merge(DEFAULT, PROFILES[lup[result]]) end
	return DEFAULT
end)()
