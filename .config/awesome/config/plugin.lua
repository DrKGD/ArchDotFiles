--------------------------------------------
-- Imports                                --
--------------------------------------------
local aw = require('awful')
local gs = require('gears')
local fs = gs.filesystem
local notify		= require('naughty').notify

--------------------------------------------
-- Setup plugins functions                --
--------------------------------------------
local base_dir			= require('gears').filesystem.get_configuration_dir()
local plugin_folder = base_dir .. 'plugins/'
-- https://raw.githubusercontent.com/streetturtle/awesome-wm-widgets/master/todo-widget/todo.lua
fs.make_directories(plugin_folder)

local git_base	= 'https://github.com'
local git_raw				= function(repository, filepath, branch)
	local fmt			= 'https://raw.githubusercontent.com/%s/%s/%s'
	return fmt:format(repository, branch or 'master', filepath)
end

local process_plug	= function(plug)
	local url		= plug[1]
	local name	= plug.as or url:sub(url:find('/') + 1, -1)
	local dest	= string.format('%s/%s', plug.path or plugin_folder, name)

	return url, name, dest
end

local wget			= function(details)
	local url		= details[1]
	local name	= details.as or url:match('.*/(.*)')
	local dest	= base_dir .. name

	-- Check if folder already exists
	if fs.file_readable(dest) then
		return true end

	local cmd =
		string.format([[wget '%s' -O '%s']], url, dest)


	-- Run command async
	aw.spawn.easy_async_with_shell(cmd, function(_, stderr, _, exit_code)
			if exit_code ~=0 then
					notify {
						title = string.format('Error in wget on <%s>', name),
						text = string.format("Error was thrown for <%s>: %s", cmd, stderr) }

					return
			end

			notify {
				title = string.format('Success: file <%s> downloaded!', name),
				text = string.format("File <%s> was written successfully", dest) }
		end)
end

local git_clone = function(plug)
	local url, name, dest = process_plug(plug)

	-- Check if folder already exists
	if fs.dir_readable(dest) then
		return true end

	-- Prepare command
	local cmd =
		string.format([[git clone "%s/%s.git" "%s"]], git_base, url, dest)

	-- Run command async
	aw.spawn.easy_async_with_shell(cmd, function(_, stderr, _, exit_code)
			if exit_code ~=0 then
					notify {
						title = string.format('Error in git clone for <%s>', name),
						text = string.format("Error was thrown for <%s>: %s", cmd, stderr) }

					return
			end

			notify {
				title = string.format('Success: plug <%s> installed!', name),
				text = string.format("Plugin <%s> was installed successfully", name) }
		end)

	return false
end

-- TODO: Pull updates automatically
local git_check_updates = function(plug)
	local _, name, dest = process_plug(plug)

	if not fs.dir_readable(dest) then
		notify {
			title = string.format('Error while updating'),
			text = string.format('Could not update, reason: folder <%s> is missing!', dest) }

		return false
	end

	-- Check if there are updates
	local cmd =
		string.format([[cd "%s" && git status --porcelain --untracked-files no]], dest)

	aw.spawn.easy_async_with_shell(cmd, function(stdout, stderr, _, exit_code)
			if exit_code ~=0 then
					notify {
						title = string.format('Error in git status for <%s>', name),
						text = string.format("Error was thrown for <%s>: %s", cmd, stderr) }
					return
			end

			if stdout ~= '' then
				notify {
					title = string.format('There are updates for <%s>!'),
					text = string.format('Please, consider looking at the repository before applying any changes!', stdout) }
			end
		end)
end

--------------------------------------------
-- Required plugins                       --
--------------------------------------------
local plugs = {
	-- Layout and Utility 
	{ 'xinhaoyuan/layout-machi' },
	{ 'basaran/awesomewm-machina', as = 'machina' },
	{ 'lcpz/lain' },
	{ 'Elv13/collision' },

	-- Widgets
	{ 'streetturtle/awesome-wm-widgets', path = base_dir},

	-- Animations
	{ 'andOrlando/rubato' }
}

local files = {
	-- Json (file only)
	{ git_raw('rxi/json.lua', 'json.lua') }
}

for _, p in ipairs(plugs) do
	if git_clone(p) then
		git_check_updates(p)
	end
end

for _, f in ipairs(files) do
	wget(f)
end

-- N.B.: Double check if this is correct
package.path = package.path
	.. string.format(';%s?/init.lua', plugin_folder)
	.. string.format(';%s?.lua', plugin_folder)

-- TODO: Reload awesomewm on plugin installation (bootstrap)

