--
-- nvim-colorizer
-- Highlight and display colors by their hex/rgb/css code
--
return { 'norcalli/nvim-colorizer.lua',
	config = function()
		local perLanguage = {}
		local global			= {}
			global.mode			= 'background'
			global.RGB			= true
			global.RRGGBB		= true
			global.RRGGBBAA = true
			global.names		= false
			global.css			= false
			global.css_fn		= false
			global.rgb_fn		= false

		-- What color is this #179AFF ?
		require('colorizer').setup(perLanguage,global)
		require('utils.wrap').bind({ noremap = true}, 'n', '<F2>', ':ColorizerToggle<CR>')
	end}
