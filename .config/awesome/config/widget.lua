--------------------------------------------
-- Imports                    						--
--------------------------------------------
local notify	= require('naughty').notify
local getWidget = function(n)
		local p = string.format('config.widget.%s', n)
		local E, W = pcall(require, p)
		if E then return W end
		notify { title = 'Missing widget', text = string.format('Widget <%s> is missing from path <%s>', n, p)}
	end

-- Which widgets shall I return
local list_o_widget = {
		'mode', 'workspace', 'tasklist', 'timedate', 'utility'
	}


return (function()
		local tbl = { }

		for _, name in ipairs(list_o_widget or { }) do
			local W = getWidget(name)
			if W then tbl[name] = W end
		end

		return tbl
	end)()

