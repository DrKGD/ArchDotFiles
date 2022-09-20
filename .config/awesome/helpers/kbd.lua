---@diagnostic disable: undefined-global

--------------------------------------------
-- Imports                                --
--------------------------------------------
local notify		= require('naughty').notify
local gs				= require('gears')
local aw				= require('awful')

--------------------------------------------
-- Modifiers table                       --
--------------------------------------------
local M = {}

M.MODIFIERS = {
	-- Windows/Meta Key
	META							= { "Mod4" },
	META_SHIFT				= { "Mod4", "Shift" },
	META_CTRL					= { "Mod4", "Control" },
	META_ALT					= { "Mod4", "Mod1" },
	META_CTRL_SHIFT		= { "Mod4", "Control", "Shift" },

	-- Alt key
	ALT					= { "Mod1" },
	ALT_SHIFT 	= { "Mod1", "Shift" },
	ALT_CTRL		= { "Mod1", "Control" },

	-- Control key
	CTRL				= { "Control" },
	CTRL_SHIFT 	= { "Control", "Shift"},

	-- Shift
	SHIFT				= { "Shift"},

	-- NONE
	NONE				= { }
}

M.MOUSE			= {
		LEFT		= 1,
		MIDDLE	= 2,
		RIGHT		= 3,
		UP			= 4,
		DOWN		= 5,
	}

--------------------------------------------
-- Utility function                       --
--------------------------------------------
-- Spawn application
-- Raise error if fails 
function M.spawn(spwn)
	return function()
		local pid = aw.spawn(spwn)
		if type(pid) == 'string' then
			notify {
				title = string.format('Error while spawning <%s>', spwn),
				text = string.format("%s", pid) }
		end
	end
end

-- Spawn application w/ shell
-- Raise error if any of its command fails
function M.spshell(spwn)
	return function()
		aw.spawn.easy_async_with_shell(string.format('set -o pipefail; %s', spwn), function(_, stderr, _, exit_code)
			if exit_code ~=0 then
					notify {
						title = string.format('Error while spawning <%s>', spwn),
						text = string.format("%s", stderr) }
			end
		end)
	end
end

-- Default non-action
local missing_action = function(m, key)
	if m then m = table.concat(m, '+') .. '+' end
	return function()
			notify {
				tile = 'Missing binding',
				text = string.format('Key [%s%s] is binded but has no action defined!', m or '', key)
			}
		end
	end


--------------------------------------------
-- Binder helper                         --
--------------------------------------------
function M.bind(tbl)
	local warn = function()
		local info = debug.getinfo(3)
		notify { title = 'Key biniding',
			text = string.format('Could not bind action: it is missing required parameter [lhs]!\nLine [%d] in file <%s>', info.currentline, info.source)}
	end

	-- if not tbl.lhs then notify { title ='Key binding', text = 'Could not bind action: its missing a key!' } return end
	if not tbl.lhs then warn() end
	return aw.key(tbl.mod or M.MODIFIERS.NONE, tbl.lhs, tbl.on or missing_action(tbl.mod, tbl.lhs), {description = tbl.desc, group = tbl.group or 'Global(s)' })
end

--------------------------------------------
-- Define a new mode                      --
--------------------------------------------
-- + ret			: back to before the mode
-- + mode			: mode definition
-- { mode.binds = {...}, lhs = ..., mod = ..., name = ...}
-- raw			: if true, returns the on_enter function and the help tooltip instead
function M.mode(mode, raw)
	-- Dynamic!
	local wrap = function()
		local back	= root.keys()

		-- Run command and exit 
		local ex		= function(cmd)
			return function()
				if cmd then cmd() end
				root.keys(back)
				awesome.emit_signal('mode::leave', { mode = mode.name })
			end
		end

		-- Build commands dynamically
		local binds = {}
		for _, b in ipairs(mode[1] or mode.binds or { }) do
			-- Should exit after executing this function
			local on = b.on or function() notify { text = string.format('Missing binding for %s [mode %s]', b.lhs, mode.name)} end
			if not (b.no_exit == true) then
				on = ex(on)
			end

			-- Add bind to the list
			local entries = M.bind { lhs = b.lhs, mod = b.mod, on = on, group = mode.name, description = b.desc }
			for _, entry in ipairs(entries) do
				table.insert(binds, entry)
			end

		end

		return gs.table.join(
			-- Defined bindings for the mode
			binds,

			-- Back to ret mode
			M.bind { lhs = [[Escape]], on = ex() },

			-- Help menu
			M.bind { lhs = [[/]], mod = M.MODIFIERS.META_CTRL, on = require('awful.hotkeys_popup').show_help }
		)
	end

	-- Prepare help
	local help_tooltip = string.format("%s", mode.name)
	local help = { [help_tooltip] = { } }
	for i, b in ipairs(mode[1] or mode.binds or { }) do
		help[help_tooltip][i] = { modifiers = b.mod or { }, keys = { [b.lhs] = b.desc }}
	end

	-- Prepare enter function
	local enter = function()
			awesome.emit_signal('mode::enter', { mode = mode.name })
			root.keys(wrap())
		end

	-- Return mode, modehelp if raw 
	if raw == true then
		return enter, help

	-- Return keybinding if not (and apply help)
	else
		require('awful.hotkeys_popup.widget')
			.add_hotkeys(help)

		return aw.key(mode.mod,
			mode.lhs,
			enter,
			{ group = "Enter mode(s)",
				description = string.format("enter [%s]", mode.name) }
		)
	end
end

return M
