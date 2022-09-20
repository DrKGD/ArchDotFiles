local won			= require('wezterm').on
local util		= require('util')

-- ENHANCE: External notification(s)
local emsg		= require('wezterm').log_error
local imsg		= require('wezterm').log_info
local wmsg		= require('wezterm').log_warning

won([[toggle-opacity]], function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		-- No opaque-ness
		overrides.window_background_opacity = 1.0
	else
		-- Restore set value
		overrides.window_background_opacity = nil
	end

	window:set_config_overrides(overrides)
end)

-- Clear input-area and input 'cd -'
won([[revert-cwd]], function(_, pane)
	if not util.run('\x15cd -\n', pane) then
		emsg("Selected pane is not a shell, could not perform revert cwd!") end
end)

-- Format
local fmtState = function(id)
	return string.format("%s/wezstate_%d",
		PROFILE.MOUNTPOINT, id)
end

-- Save cwd and make it loadable from another instance
local save_cwd = function(pane, id)
	if not PROFILE.MOUNTPOINT then
			emsg("MOUNTPOINT is not defined!")
		return end

	-- Get cwd
	local cwd = pane
		:get_current_working_dir()
		:gsub([[^file://[^/]*]], "")

	-- Write cwd to ram
	local fn = fmtState(id)
	local file = io.open(fn, 'w')
	if not file then emsg('File could not be written?') return end
	file:write(cwd .. '\n')
	file:close()
end

local load_cwd = function(pane, id)
	if not PROFILE.MOUNTPOINT then
			emsg("MOUNTPOINT is not defined!")
		return end

	-- Write cwd to ram
	local fn = fmtState(id)
	local file = io.open(fn, 'r')
	if not file then emsg('File could not be read?') return end
	local cwd = file:read()

	-- cd to the new path 
	if not util.run(string.format('\x15cd %s\n', cwd), pane) then
		emsg("Selected pane is not a shell, could not cd onto path!") end
end

-- Map save and load cwd(s)
(function()
		for i=1, PROFILE.STATES do
			won(string.format('save-cwd-%d', i), function(_, pane) save_cwd(pane, i) end)
			won(string.format('load-cwd-%d', i), function(_, pane) load_cwd(pane, i) end)
		end
	end)()

