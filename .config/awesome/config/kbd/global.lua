---@diagnostic disable: undefined-global

--------------------------------------------
-- Imports                                --
--------------------------------------------
local awful			= require('awful')
local awhelp		= require('awful.hotkeys_popup').show_help
local notify		= require('naughty').notify
local gears			= require('gears')
local ruled			= require('ruled')
local util			= require('lua.util')
local helper		= require('helpers.kbd')
	local mod				= helper.MODIFIERS
	local bind			= helper.bind
	local spawn			= helper.spawn
	local spshell		= helper.spshell
	local mode			= helper.mode


--------------------------------------------
-- Always enabled, no matter what         --
--------------------------------------------
return require('gears').table.join(
	---------------
	--  Awesome  --
	---------------
	bind { lhs = [[`]],
		mod		= mod.META_CTRL,			-- Quit to sddm
		on		= awesome.quit,
		desc	= 'Reload AwesomeWM'
	},

	bind { lhs = [[r]],						-- Reload configuration
		mod		= mod.META_CTRL,
		on		= awesome.restart,
		desc	= 'Reload AwesomeWM'
	},

	bind { lhs = [[r]],						-- Reload configuration, 'foreal
		mod		= mod.META_SHIFT,
		on		= function()
			if not util.set_norestore() then
					notify { text = 'Could not setup norestore token!' }
					return
				end
			awesome.restart()
		end,
		desc	= 'Reload AwesomeWM, but harder'
	},

	bind { lhs = [[/]],						-- Help tooltip
		mod		= mod.META_CTRL,
		on		= awhelp,
		desc	= 'Please, help!'
	},

	bind { lhs = [[/]],						-- Help tooltip
		mod		= mod.META,
		on		= spawn('rofi -modi drun,run -show drun'),
		desc	= 'Run program using Rofi'
	},

	---------------
	-- Audio     --
	---------------
	bind { lhs = [[XF86AudioRaiseVolume]],
		on		= spshell('volume_sanification.sh @DEFAULT_SINK@ +5'),
		group = 'Audio',
		desc	= 'Volume up'
	},

	bind { lhs = [[XF86AudioLowerVolume]],
		on		= spshell('volume_sanification.sh @DEFAULT_SINK@ -5'),
		group = 'Audio',
		desc	= 'Volume down'
	},

	bind { lhs = [[XF86AudioMute]],
		on		= spshell('pactl set-sink-mute @DEFAULT_SINK@ toggle'),
		group = 'Audio',
		desc	= 'Volume Mute'
	},

	bind { lhs = [[equal]],
		mod		= mod.META,
		on		= spshell('volume_sanification.sh @DEFAULT_SINK@ +5'),
		group = 'Audio',
		desc	= 'Volume up'
	},

	bind { lhs = [[minus]],
		mod		= mod.META,
		on		= spshell('volume_sanification.sh @DEFAULT_SINK@ -5'),
		group = 'Audio',
		desc	= 'Volume down'
	},

	---------------
	-- PrintScr  --
	---------------
	bind { lhs = [[Print]],				-- Screenshot whole desktop 
		on		= spshell('maim -B | xclip -selection clipboard -t image/png'),
		group = 'Screenshots',
		desc	= 'Take a screenshot 🧀'
	},

	bind { lhs = [[Print]],				-- Screenshot a rectangular area (or selected)
		mod		= mod.CTRL,
		on		= spshell('maim -sB | xclip -selection clipboard -t image/png'),
		group = 'Screenshots',
		desc	= 'Take screenshot of selection (window or rectangle)'
	},

	bind { lhs = [[Print]],				-- Screenshot of current selected window
		mod		= mod.ALT,
		on		= spshell('maim -Bi $(xdotool getactivewindow) | xclip -selection clipboard -t image/png'),
		group = 'Screenshots',
		desc	= 'Take screenshot of selected window'
	},

	---------------
	--    Run    --
	---------------
	mode({ lhs = [[r]], mod = mod.META, name = 'run', binds = {
		-- Terminal(s)
		{ lhs = [[Return]], on = spawn('wezterm'), desc = 'Spawn terminal emulator' },
		{ lhs = [[Return]], mod = mod.CTRL, on = spawn('xterm'), desc = 'Spawn terminal emergence-only terminal' },

		-- File explorer
		{ lhs = [[e]], on = spawn('thunar'), desc = 'Spawn file explorer' },

		-- Browser(s)
		{ lhs = [[b]], on = spawn('firefox'), desc = 'Spawn firefox'},
		{ lhs = [[b]], mod = mod.SHIFT, on = spawn('firefox --private-window'), desc = 'Spawn firefox in private, hehe naughty 😘'},
		{ lhs = [[b]], mod = mod.CTRL, on = spawn('firefox-developer-edition'), desc = 'Spawn firefox developer'}
	}}),

	---------------
	-- Workspace --
	---------------
	bind { lhs = "Tab",
		mod		= mod.ALT,
		on		= function()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise() end
		end,
		group = 'Workspace(s)',
		desc	= 'Cycle to prev client for this screen'
	},

	bind { lhs = "Tab",
		mod		= mod.ALT_SHIFT,
		on		= function()
			awful.client.focus.byidx(1)
			if client.focus then
				client.focus:raise() end
		end,
		group = 'Workspace(s)',
		desc	= 'Cycle to next client for this screen'
	},

	bind { lhs = "]",
		mod		= mod.META,
		on		= awful.tag.viewnext,
		group = 'Workspace(s)',
		desc	= 'Cycle to next tag for this screen'
	},

	bind { lhs = "[",
		mod		= mod.META,
		on		= awful.tag.viewprev,
		group = 'Workspace(s)',
		desc	= 'Cycle to previous tag for this screen'
	},

	mode({ lhs = [[w]], mod = mod.META, name = 'toggle', binds = (function()
		local _tags		= require('config.tags').TOGGLE
		local binds		= { }
		local lookup	= { }

		local assign	= {
				rule_any = { class = { } },
				callback = function(c)
					local cl = c.class
					local cn = c.name

					-- Find by <name>
					local find = function()
						for _, n in pairs(lookup) do
							if n.class == cl and ((not n.id or c.startup_id == n.id) or cn == n.name)
								then return n end
						end

						return false
					end

					local info = find()
					if info then
						c:move_to_tag(info.tag)
						awful.client.setmaster(c)

						-- Ensure clients of the tag are not getting moved around
						-- c.first_tag:connect_signal('untagged', function(_)
						-- 	c:move_to_tag(info.tag)
						-- end)
					end
				end
			}

		-- Run program
		local run = function(id, cmd)
			if id then id = string.format([[DESKTOP_STARTUP_ID='%s' ]], id) end
			cmd = string.format([[%s%s]], id or '', cmd)
			spshell(cmd)()
		end

		-- Rename
		local rename = function(name)
			return string.format('%s', name)
		end

		-- DISABLED: Debug use only 
		-- table.insert(binds, { lhs = '/', on = function()
		-- 	local scr = awful.screen.focused()
		--
		-- 	local ltags = { }
		-- 	for _, t in ipairs(scr.tags) do
		-- 		table.insert(ltags, string.format('index %2d: %s',  t.index, t.name))
		-- 		for _, c in ipairs(t:clients()) do
		-- 			table.insert(ltags, string.format('  %s', c.class))
		-- 		end
		-- 	end
		--
		-- 	notify { title = string.format('Available tags on current output [%d]', scr.index),
		-- 		text = table.concat(ltags, '\n') }
		-- end})


		-- Spawn tag(s) on screen[1], thus it will always be available
		-- Offset index	by 10 thus won't clash with "real" workspaces
		local index = 10
		for ws, info in pairs(_tags) do
			-- Skip invalid toggle-workspaces
			if (not info.client and not info[1]) or not info.class or not info.lhs then
					notify {
						title = string.format('Invalid workspace definition <%s>', ws),
						text	= 'Workspace is missing one or more required parameters [client, class, key]!'
					}
					goto continue
				end

			index = index + 1

			-- Which name will the workspace use
			local wsname = rename(info.name or ws)

		local tag = awful.tag.add(wsname, {
				screen		= 1,
				icon			= info.icon,
				layout		= info.layout or awful.layout.suit.tile,
				layouts		= { (info.layout or awful.layout.suit.tile) },
				index			= index,
				toggle		= true,
				keep			= info.keep
			})

			table.insert(lookup,								{ class = info.class, tag = tag, name = info.name, id = info.id})
			table.insert(assign.rule_any.class,	info.class)

			local lambda = function()
				-- Get current screen 
				local scr			= awful.screen.focused()
				local clients	= tag:clients()

				-- Get current focus (if any)
				local currFocus = client.focus

				-- Spawn client if missing 
				if #clients < 1 then
						-- TODO: Upgrade client to list of clients
						run(info.id, info.client or info[1])
					end

				-- Move tag to current screen
				if tag.screen.index ~= scr.index then
					tag.screen		= scr
					tag.selected	= true
				else
					tag.selected  = not tag.selected
				end

				-- If tag was activated   
				if tag.selected then
					tag._previous_client = client.focus

					-- Swap out (remove) all other selected tags on the current screen 
					for _n, _t in pairs(_tags) do
						local find = rename(_t.visual or _n)
						if find ~= wsname then
							local p = awful.tag.find_by_name(scr, find)
							if p then
									-- If current workspace was just swapped, keep the previous client
									if p._previous_client then
											tag._previous_client = p._previous_client
										end

									p.selected = false
								end
						end
					end

					-- Focus the client
					if clients[1] then
						client.focus = clients[1]
						clients[1]:raise()
					end
				end
			end

			table.insert(binds, { lhs = info.lhs, mod = info.mod, on = lambda })
			::continue::
		end

		ruled.client.connect_signal('request::rules', function()
			ruled.client.append_rule(assign)
		end)

		return binds
	end)()})
)


