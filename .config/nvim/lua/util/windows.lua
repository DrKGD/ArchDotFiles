-------------------------------------
-- Window specific functions       --
-------------------------------------
local M = {}

-- Return all windows in all tabpages
M.getWins = function()
	local tbl = {}

	local tabpages = vim.api.nvim_list_tabpages()
	for _, tab in ipairs(tabpages) do
		vim.list_extend(tbl, vim.api.nvim_tabpage_list_wins(tab))
	end

	return tbl
end

-- Wrapper, sets options onto the buffer 
M.setupWindow = function(win_id, options)
	for i, k in pairs(options) do
		vim.api.nvim_win_set_option(win_id, i, k)
	end
end

-- Return a list of tuples Win - Buffer 
M.getWindowsDisplayingBuffers = function(bufs)
	if type(bufs) == 'number' then bufs = { bufs } end
	local wins = M.getWins()

	local tbl = {}
	for _, w in ipairs(wins) do
		local bid = vim.api.nvim_win_get_buf(w)
		if vim.tbl_contains(bufs, bid) then
			tbl[w] = bid end
	end


	return tbl
end

return M

