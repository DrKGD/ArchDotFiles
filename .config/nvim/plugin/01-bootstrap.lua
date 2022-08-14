------------------------------------- 
-- Bootstrap on first run          --
-------------------------------------
-- Local                           --
-------------------------------------
local exists =
	require('util.path').fileExists

BOOTSTRAP_GUARD		= false
local bootstrap = function()
		vim.fn.system({'git','clone','--depth','1','https://github.com/wbthomason/packer.nvim', PREFERENCES.plugin.packerpath})
		vim.cmd [[packadd packer.nvim]]

		-- Clean previous compiled output from packer
		vim.fn.delete(PREFERENCES.plugin.compiled)

		-- Install post_update hook 
		vim.api.nvim_create_autocmd("User", { pattern = 'PackerCompileDone', command = string.format('%dcq!', os.getenv('SIGDISCARD') or 0) })
		vim.api.nvim_create_autocmd("VimEnter", { command = 'PackerSync' })

		-- Write post update hook
		vim.fn.writefile({}, PREFERENCES.plugin.updatehook)
		BOOTSTRAP_GUARD = true
	end

UPDATEHOOK_GUARD	= false
local updatehook = function()
		-- Clear updatehook
		vim.fn.delete(PREFERENCES.plugin.updatehook)

		-- Issue an update of the packages
		vim.api.nvim_create_autocmd("VimEnter", { command = 'PackerSync' })
		UPDATEHOOK_GUARD = true
	end


-------------------------------------
(function()
		if not exists(PREFERENCES.plugin.packerpath)
			then bootstrap()
		elseif exists(PREFERENCES.plugin.updatehook)
			then updatehook()
		end
	end)()
