local M = {}

local wezterm = require('wezterm')

M.Mars = wezterm.color.get_builtin_schemes()['FunForrest']
M.Mars.selection_fg		= "none"
M.Mars.selection_bg		= "rgba(218, 62, 82, 35%)"
M.Mars.foreground			= "#F5D4CC"
M.Mars.cursor_border	= "#F5D4CC"
M.Mars.cursor_bg			= "#F5D4CC"

return M
