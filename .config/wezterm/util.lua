local M = {}

M.ispath			= function(p) return p:match"/" end
M.tail				= function(p) return p:match"[^\\/]*$" end
M.basename		= function(n) return string.gsub(n or '?', "(.*[/\\])(.*)", "%2") end
M.getProcess	= function(pane) return M.basename(pane:get_foreground_process_name()) end
M.dir					= function(p)  return string.match(p,"(.*[/\\])") end

local function deepmerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                deepmerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

M.merge = function(lhs, ...)
	for _, rhs in ipairs({...}) do
		deepmerge(lhs, rhs)
	end

	return lhs
end

-- TODO: Extend to other shell(s)?
M.isShell			= function(process)
	if not process then return false end
	if process ~= 'zsh' then return false end

	return true
end

-- Run only if terminal shell
local fmtCommand	=
	function(cmd, pid) return string.format([[echo -en '%s' | wezterm cli send-text --pane-id %d --no-paste &]], cmd, pid) end
M.run					= function(cmd, pane)
	local p = M.getProcess(pane)
	if not M.isShell(p)
		then return false end

	os.execute(fmtCommand(cmd, pane:pane_id()))
	return true
end

-- Get directories in path 
M.scandir = function(directory, absolute)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -A "'..directory..'"')
		if not pfile then return {} end
    for filename in pfile:lines() do
        i = i + 1
        t[i] = directory .. filename
    end
    pfile:close()
    return t
end


return M
