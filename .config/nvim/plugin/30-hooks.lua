-------------------------------------
-- Custom late configuration       --
-------------------------------------
(function()
		--- Evaluate profile configuration
		for _, h in pairs(PREFERENCES.hooks) do h() end

		--- Add a custom event to capture key presses
		-- local KeyPress	= vim.schedule_wrap(function() vim.api.nvim_exec_autocmds("User", { pattern = "KeyPress" }) end)
		local KeyPress	= function()
			-- vim.api.nvim_exec_autocmds("User", { pattern = "KeyPress" })

			-- Force redraw status for events which requires so
			-- vim.cmd('redrawstatus')
		end

		local kpgroup		= vim.api.nvim_create_augroup('DefineKeyPress', { clear = true })
		vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'CmdlineChanged' },
			{ callback = KeyPress, group = kpgroup })
		vim.api.nvim_create_autocmd( 'User',
		 { pattern = { 'HydraOpen', 'TelescopeFindPre'}, callback = KeyPress, group = kpgroup })
	end)()
