---@diagnostic disable: undefined-global
--------------------------------------------
-- Imports                                --
--------------------------------------------
local unique = require('lua.util').daemon
local awful		= require('awful')
local gears		= require('gears')
local notify = require('naughty').notify
local util		= require('lua.util')
	local store			= util.store
	local restore		= util.restore
	local csvtable	= util.csvtable
	local consume		= util.consume_norestore


--------------------------------------------
-- Start the following application				--
--------------------------------------------
local on_start = {
	-- Compositor
	"picom -b --backend glx --experimental-backends",

	-- Enables automount onto thunar
	"thunar --daemon"
}

for _, app in ipairs(on_start) do
	unique(app)
end


--------------------------------------------
-- Restore-on-Restart                     --
--------------------------------------------
local mountpoint = os.getenv('MOUNTPOINT') .. '/awesomewm'
	local rworkspace	= string.format('%s/%s', mountpoint, 'workspace')
	local rwid				= string.format('%s/%s', mountpoint, 'wid')

awesome.connect_signal('exit', function(reason_restart)
	if not reason_restart then return end

	-- Store workspace settings
	-- + name::_hasToggle::master_width_factor::selected
	-- + name: which tag 
	-- + _hasToggle: if it has a toggle companion 
	-- + master_width_factor: welp, its master_width_factor, if it was changed
	-- + selected: if it was the selected tag for the screen
	store (rworkspace, function()
		local content = { }

		local function toggleName(tag)
			-- Has toggle name
			if tag._hasToggle then return tag._hasToggle.name
			elseif tag.selected and tag.screen.selected_tags[2] then return
				tag.screen.selected_tags[2].name
			else return 'nil' end
		end

		for _, tag in ipairs(root.tags()) do
			if not tag.toggle then

				local entry = string.format('%s::%s::%f::%s',
					tag.name, toggleName(tag), tag.master_width_factor, tostring(tag.selected))
				table.insert(content, entry)
			end
		end

		return content
	end)

	-- Store last active window id
	store(rwid, client.focus.window)
end)

awesome.connect_signal('awesomewm::configuration_done', function()
	if consume() then return end

	-- Restore workspace configuration on startup
	restore(rworkspace, function(content)
		for _, entry in ipairs(content) do
			local csv = csvtable(entry, [[::]])
				local ctag		= awful.tag.find_by_name(nil, csv[1])
				local ctoggle
				if csv[2] ~= 'nil' then
					ctoggle = awful.tag.find_by_name(nil, csv[2]) end
				local mwf			= tonumber(csv[3])
				local active	= csv[4] == 'true'

				ctag.master_width_factor	= mwf
				ctag._hasToggle						= ctoggle

				-- If selected, display toggle-tag 
				if active then
						ctag:view_only()
						if ctag._hasToggle then
								ctag._hasToggle.selected	= true
								ctag._hasToggle.screen		= ctag.screen
							end
					end
		end
	end)

	-- Restore client on startup
	restore(rwid, function(content)
		-- Retrieve process wid from table
		local wid = tonumber(content[1])

		gears.timer.delayed_call(function()
			for _, c in ipairs(client.get()) do
				if c.window == wid then
					client.focus = c
					c:raise()
				end
			end
		end)
	end)
end)


