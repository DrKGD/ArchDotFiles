-------------------------------------
-- Orphan functionalities ()       --
-------------------------------------
local M = {}

-------------------------------------
-- Throw error using vim.notify    --
-------------------------------------
M.newError = function(label)
	return function(...)
		local args = { ... }
		vim.schedule(function()
			vim.notify(string.format(label, unpack(args)), "error", { render = "minimal" })
		end)
	end
end

-------------------------------------
-- Prompt for confirmation         --
-------------------------------------
M.confirm = function(dialog, ans)
	local response = vim.fn.input(dialog) == ans
	return response
end

-------------------------------------
-- Define command as string        --
-------------------------------------
M.cmd = function(command)
	return table.concat({ '<Cmd>', command, '<CR>' })
end

-------------------------------------
-- Wrap function consumer          --
-------------------------------------
M.fn	=	function(lambda)
	return function() lambda() end
end

-------------------------------------
-- Colorscheme replacement         --
-------------------------------------
M.hi = function(dict)
	for hi, tbl in pairs(dict or { }) do
		if type(tbl) == 'table' then
			vim.api.nvim_set_hl(0, hi, tbl)
		end
	end
end

-------------------------------------
-- Extract table from file         --
-------------------------------------
M.lodTable = function(p)
	if require('util.path').fileExists(p) then
		local tbl = loadfile(p)
		if tbl then return tbl() end
	end
end

-------------------------------------
-- UTF8 string length              --
-------------------------------------
M.len = function(str)
	local _, c = str:gsub("[^\128-\193]", "");
	return c
end

-------------------------------------
-- Retrive non-float wins in ctab	 --
-------------------------------------
M.wins = function()
	return vim.tbl_filter(function(win)
		local cfg = vim.api.nvim_win_get_config(win)
		return not (cfg.relative > "" or cfg.external)
	end, vim.api.nvim_tabpage_list_wins(0))
end

-------------------------------------
-- Clone object                    --
-------------------------------------
M.clone = function(o)
	local r = vim.fn.deepcopy(o)
	if type(r) == 'table' then
		setmetatable(r, getmetatable(o))
	end
	return r
end

-------------------------------------
-- Timer (repeating function)      --
-------------------------------------
M.timer	= function(fn)
	local function timed()
		local wait = fn()
		vim.defer_fn(timed, wait)
	end

	timed()
end

-- Register an autocmd repeating every (delay) once vim is ready to do so
-- + Lambda, function that execute every time
M.timed_autocmd = function(name, delay, lambda)
	vim.schedule(function()
		M.timer(function()
			vim.api.nvim_exec_autocmds("User", { pattern = name })
			if lambda then lambda() end
			return delay
		end)
	end)
end

-------------------------------------
-- Returns map of key if any       --
-------------------------------------
M.getmap = function(lhs, mode)
	-- return vim.api.nvim_get_keymap(mode)
	return vim.tbl_filter(function(x) return x.lhs == lhs end, vim.api.nvim_get_keymap(mode))
end

-------------------------------------
-- Returns list of colorschemes    --
-------------------------------------
M.colorschemes = function()
	return vim.fn.getcompletion("", "color")
end

return M
