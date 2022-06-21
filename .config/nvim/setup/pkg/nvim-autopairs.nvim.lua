--
-- Autopairs 
-- Help me closing and changing parenthesis, please!
--
return { 'windwp/nvim-autopairs',
	config = function()
		local p = require('nvim-autopairs')

		p.setup({
			disable_filetype = { "TelescopePrompt" , "vim" },
			map_bs = false,
			map_cr = false,
		})
	end }
