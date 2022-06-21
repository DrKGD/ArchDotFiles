--
-- Neoclip, telescope extension
-- Keeps track of pasted content
--
return { 'AckslD/nvim-neoclip.lua',
	requires = {
			{'tami5/sqlite.lua', module = 'sqlite'},
			{'nvim-telescope/telescope.nvim'},
		},
	after = { 'telescope.nvim' },
	config = function()
		require('neoclip').setup({
			history = 1000,
			enable_persistent_history = true,
			db_path = vim.fn.stdpath('data') .. '/neoclip.sqlite3',
		})

		require('telescope').load_extension('neoclip')
	end}

