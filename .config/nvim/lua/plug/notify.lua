local M = {}

-- Retrieve text from the buffer (and its first non-whiteline)
local function retrieve(buf)
	-- Retrieve source content in the notification
	local lines		= vim.api.nvim_buf_line_count(buf)
	local src			= require('util.transform')
		.join(vim.api.nvim_buf_get_lines(buf, 0, lines, false))		-- Join lines
		:gsub('\t', string.rep(' ', vim.o.tabstop))								-- Replace tabs with vim.o.tabstop spaces

	-- Count and Delete whitelines ('\n') before actual content in src, probably used for head
	local first_nonwhite = src:find("[^\n]")
	if first_nonwhite > 1 then
		src = src:sub(first_nonwhite) end

	return src, first_nonwhite
end

-- Resizes buffer
local resize = function(win, buf, src, first_nonwhite, width_ratio)
	-- Retrieve current window size
	local cols = vim.o.columns
	local width = math.floor(cols * width_ratio)
	vim.api.nvim_win_set_width(win, width)

	-- Split content using cols in formula
	local content =
		require('util.transform').split(src, width)
	local height = first_nonwhite - 1 + #content

	-- Finally set content and resize window in height
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, first_nonwhite - 1, height, false, content)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_win_set_height(win, height)
end

local notify_grp = vim.api.nvim_create_augroup('NvimNotificationResized', { clear = true })
M.on_enter = function(win)
	local width_ratio		= PREFERENCES.editor.notification_ratio
	local buf						= vim.api.nvim_win_get_buf(win)
	local src, fnw			= retrieve(buf)
	local wrap_resize		= vim.schedule_wrap(function() resize(win, buf, src, fnw, width_ratio) end)

	-- Setup resize event
	local id = vim.api.nvim_create_autocmd({'VimResized'},
		{ group = notify_grp, callback = wrap_resize })

	-- Delete when notification was undo'd
	vim.api.nvim_create_autocmd('WinClosed', { pattern = tostring(win), group = notify_grp, once = true,
			callback = function()
				vim.api.nvim_del_autocmd(id)
		end})

	-- Apply initial resize
	wrap_resize()
end

return M
