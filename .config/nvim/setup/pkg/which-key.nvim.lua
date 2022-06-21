return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {
			marks = false,
			registers = false,

			window = {
				border = "none", -- none, single, double, shadow
				position = "top", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0
			},

			layout = {
				spacing = 2,
				align = "left",
				width = { min = 10, max = 50 },
				height = { min = 2, max = 20 }
			},

			popup_mappings = {
				scroll_up = "<PageUp>",
				scroll_down = "<PageDown>",
			},
    }
  end
}
