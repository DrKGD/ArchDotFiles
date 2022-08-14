-------------------------------------
-- Custom filetype definitions     --
-------------------------------------
(function()
		local ITypesGroup = vim.api.nvim_create_augroup("IndexTypes", { clear = true })
		local fts					= {
			['*.cls']				= 'tex',
			['*.i3.inc']		= 'i3config',
			['.neoproj']	= 'lua'
		}

		for custom, ft in pairs(fts) do
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufReadPost"}, {
					group = ITypesGroup,
					pattern = custom,
					command = 'set ft=' .. ft
				})
		end
	end)()
