--
-- Mini
-- Some useful wrapped functions
--
return { 'echasnovski/mini.nvim',
	branch = 'stable',
	config = function()
		require('mini.cursorword').setup({ delay = 0 })
		require('mini.surround').setup({
			mappings = {
				add = '<Space>sa',           -- Add surrounding
				delete = '<Space>sd',        -- Delete surrounding
				find = '<Space>sf',          -- Find surrounding (to the right)
				find_left = '<Space>sF',     -- Find surrounding (to the left)
				highlight = '<Space>sh',     -- Highlight surrounding
				replace = '<Space>sr',       -- Replace surrounding
				update_n_lines = '<Space>sn' -- Update `n_lines`
			}
		})
	end }
