--
-- shade
-- Darken non-active windows
--
return { 'sunjon/Shade.nvim',
	disable = true,
	config = function()
		require('shade').setup({
			overlay_opacity = 30,
			opacity_step = 1,
		})
	end }
