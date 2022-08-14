--
-- Sniprun
--  Code runner in neovim using rust 
--
return { "michaelb/sniprun",
	run = 'bash ./install.sh',
	cmd = 'SnipRun',
	config = function()
		require('sniprun').setup({
			display = {
				"VirtualTextOk",
				"Api",
			},

			display_options = {
				notification_timeout = 3
			},

			show_no_output = {
				"NvimNotify",
			}
		})

	end }
