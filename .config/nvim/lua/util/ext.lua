-------------------------------------
-- Run external command            --
-------------------------------------
local M = {}

-- Run an external command and return its result, as a string or as a table
M.run =	function(cmd)
	-- Run command and capture input
	local handle = io.popen(cmd)
	if not handle then
		vim.notify([[<%s> has an error!]], cmd) return end
	local read	= handle:read("*all")
	handle:close()

	-- Add result to table
	local result = {}
	for line in read:gmatch("[^\r\n]+") do
		table.insert(result, line) end

	-- Return string (if single liner) or table
	if #result == 1 then return result[1] end
	return result
end

-- Check if currently in a git repository
M.git	= function()
	local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

-- Returns files and directories
--  Does not use ls under the hood!
local find = [[\find %s -mindepth 1 -maxdepth 1 -type d -printf "%%P/\n" -o -printf "%%P\n"]]

M.ls = function(d)
	local ret = { files = {}, dirs = {} }

	local result = M.run(string.format(find, d or vim.fn.getcwd()))
	if not result then return ret end
	if type(result) == 'string' then result = { result } end

	-- Ignore folders (/), exectuables (*), symbolic links (@), sockets (=), fifos (|), whiteouts (%)
	ret.files = vim.tbl_filter(function(entry)
		return entry:match(".*[^/*=%|@]$")
	end, result)

	-- Returns dirs (basenames)
	ret.dirs = vim.tbl_map(function(entry)
			return entry:sub(1, -2)
		end, vim.tbl_filter(function(entry)
			return entry:match(".*/$")
		end, result))

	return ret
end

return M
