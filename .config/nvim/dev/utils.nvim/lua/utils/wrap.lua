local M = {}
	M.bind = function(flags, modes, key, op)
		vim.keymap.set(modes, key, op, flags or {}) end

	M.bind_to = function(bufnr, flags, modes, key, op)
		vim.keymap.set(modes, key, op, vim.tbl_deep_extend("force", flags, { buffer = bufnr })) end

	M.unbind = function(modes, key, flags)
		vim.keymap.set(modes, key, '<Nop>', flags or {}) end
return M
