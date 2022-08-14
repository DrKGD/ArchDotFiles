local e,s,a,w,i = require('utils.message').setup('channels')

local M = {}

-- Last command
M.lastCommand = false

--- Get channels in order
function M.list()
	local terminalChannels = {}

	for _, chan in pairs(vim.api.nvim_list_chans()) do
			if chan.mode == 'terminal' and chan.pty then
				table.insert(terminalChannels, chan) end
	end

	table.sort(terminalChannels, function(lhs, rhs)
		return lhs['buffer'] < rhs['buffer']
	end)

	return terminalChannels
end

--- Check if at least one channel exists
function M.isAvailable()
	for _, chan in pairs(vim.api.nvim_list_chans()) do
		if chan.mode == 'terminal' and chan.pty then
			return true end
	end

	return false
end

--- Send to channel
function M.send(text, inx)
	local id = id or 1
	local list = M.list() or nil

	if next(list) == nil then e('No terminals were opened during the session...') return end
	vim.api.nvim_chan_send(M.list()[id]['id'], string.format('%s\n', text))
end

--- Open terminal in background
function M.open(terminal)
	-- BUG: Terminal is messed up until entering insert mode
	-- local bufnr = vim.fn.bufadd(string.format('term://%s', terminal or '/usr/bin/zsh'))
	-- vim.fn.bufload(bufnr)
	-- vim.fn.setbufvar(bufnr, "&buflisted", 1)
	-- M.send(util.lua.escape('i'))

	vim.cmd(string.format('e term://%s | e #', terminal or 'zsh'))
end

--- Wrap function to check for availability and open a term
function M.make()
	if not M.isAvailable() then
		M.open() end
end

return M
