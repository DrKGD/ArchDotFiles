-------------------------------------
-- Buffer specific functions       --
-------------------------------------
local M = {}

-- Return valid buffers
M.getBuffers = function()
		return vim.tbl_filter(function(buf)
			return vim.api.nvim_buf_is_valid(buf)
						and vim.api.nvim_buf_get_option(buf, 'buflisted')
		end, vim.api.nvim_list_bufs())
	end

-- Return only hidden buffers
M.getHiddenBuffers = function()
	return vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf)
					and not vim.api.nvim_buf_get_option(buf, 'buflisted')
	end, vim.api.nvim_list_bufs())
end

-- Return valid buffers in chronological order of use
M.getBuffers_mru = function()
		local bufids = M.getBuffers()
		table.sort(bufids, function(ba, bb)
			return vim.fn.getbufinfo(ba)[1].lastused > vim.fn.getbufinfo(bb)[1].lastused
		end)

		return bufids
	end

-- Return an array like table id-path tuples 
M.getNamedBuffers = function()
	local bufids = vim.api.nvim_list_bufs()
	
	local tbl = {}
	vim.tbl_map(function(entry)
		table.insert(tbl, { id = entry, path = vim.api.nvim_buf_get_name(entry)} )
	end, bufids)

	return tbl
end

-- Returns named buffers which matches the regex(s)
M.matchBuffers = function(rgx)
	if type(rgx) == 'string' then rgx = { rgx } end

	return vim.tbl_filter(function(e)
		for _, r in ipairs(rgx) do
			if e.path:match(r) then
				return e end
		end
	end, M.getNamedBuffers())
end


-- Wrapper, sets options onto the buffer 
M.setupBuffer = function(buf_id, options)
	for i, k in pairs(options) do
		vim.api.nvim_buf_set_option(buf_id, i, k)
	end
end

-- Creates a buffer and set these options 
-- e.g.
-- { buftype = 'nowrite', swapfile = false, bufhidden = 'unload' ... }
M.newBuffer = function(name, options)
	local buf_id = vim.api.nvim_create_buf(true, false)

	-- Name is handled differently
	if name and type(name) == 'string' then
		vim.api.nvim_buf_set_name(buf_id, name) end

	-- If no more options to be processed, then return
	if options and type(options) == 'table' then
		M.setupBuffer(buf_id, options) end

	return buf_id
end

return M
