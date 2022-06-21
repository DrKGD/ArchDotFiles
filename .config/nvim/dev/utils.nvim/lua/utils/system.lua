local M = {}

M.separator = (function()
	if vim.fn.has('win32') == 1 then return '\\' end
	if vim.fn.has('unix') == 1 then return '/' end
	if vim.fn.has('mac') == 1 then return '/' end
	return nil
end)()

M.is_wsl = (function()
	local output = vim.fn.systemlist "uname -r"
	return not not string.find(output[1] or "", "WSL")
end)()

M.os = (function()
	if vim.fn.has('win32') == 1 then return 'win32' end
	if vim.fn.has('unix') == 1 then return 'unix' end
	if vim.fn.has('mac') == 1 then return 'mac' end

	return nil
end)()

-- TODO: Implement
M.wm = (function()
	-- if vim.fn.has('AwesomeWM') == 1 then return 'win32' end
	return nil
end)()

return M
