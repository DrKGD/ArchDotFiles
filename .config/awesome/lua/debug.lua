--------------------------------------------
-- Imports                                --
--------------------------------------------
local gears		= require('gears')
local _dump		= gears.debug.dump_return
local notify	= require('naughty').notify


local dest		= require('gears').filesystem.get_configuration_dir() .. 'debug.log'
--------------------------------------------
-- Utility funcitons                      --
--------------------------------------------

local M = {}

M.clear = function()
	io.open(dest , "w"):close()
end

M.dump = function(content)
	local fi = io.open(dest , "a")

	-- Could not open the file
	if not fi then
		notify { text = string.format('Could not log onto %s!', dest )}
		return
	end

	-- Write to file
	local info			= debug.getinfo(2)
	local datetime	= string.format('%s', os.date([[%Y/%m/%d %H:%M:%S]]))
	local fileinfo	= string.format([[from file: <%s>, at line: %d]],
		info.source, info.currentline)
	fi:write(datetime, '\n', fileinfo, '\n')

	-- Write debug content
	if type(content) == 'string' then
		fi:write(content)
	elseif type(content) == 'table' then
		fi:write(_dump(content))
	else
		fi:write(tostring(content))
	end

	fi:write('\n\n')
	fi:close()
end

return M
