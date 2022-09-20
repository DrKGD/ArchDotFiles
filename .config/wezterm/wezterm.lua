PROFILE = require('profile')
require('event') -- Behavioral settings of the terminal 
local terminal = {
	max_fps										= 144,
	check_for_updates					= true,
	warn_about_missing_glyphs = false,
	front_end									= "OpenGL",
	exit_behavior							= "Close",
	adjust_window_size_when_changing_font_size = false,

	-- Input
	scrollback_lines					= 10000,
	scroll_to_bottom_on_input	= true
}

-- Theme, background and aesthetics
local theme = {
	color_schemes							= require('theme'),

	-- Colorscheme and opacity
	color_scheme							= "Mars",
	window_background_opacity = 0.85,

	-- Window 
	window_decorations				= "RESIZE",
	window_padding = {
			left = 10,
			right = 0,
			top = 10,
			bottom = 10
		},

	-- Tab(s) (disabled)
	enable_tab_bar						= false,
	use_fancy_tab_bar					= true,
	tab_bar_at_bottom					= true,
	tab_and_split_indices_are_zero_based = false,
	show_tab_index_in_tab_bar = false,

	-- Scrollbar
	enable_scroll_bar					= false,

	-- Background
	background = {
		{ source = { File = PROFILE.CONFIG_PATH .. 'tile.png' }, attachment = { Parallax = 0.25 }, opacity = 0.35, hsb = { saturation = 0.5, brightness = 0.75 }},
		{ source = { Color = "#330606"}, repeat_x = "NoRepeat", repeat_y = "NoRepeat", height = "100%", width = "100%", opacity = 0.65},
	}
}

-- Font configuration
local font	= {
	font											= require('font').font_fb({family= 'scientifica', weight="Bold"}),
	font_size									= PROFILE.FONT.SET,

	-- Behavior()
	use_resize_increments			= true,
	harfbuzz_features					= {"calt=0", "clig=0", "liga=0"},
  freetype_load_flags				= "NO_HINTING",
	freetype_load_target			= "HorizontalLcd",
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	unicode_version						= 14,

	-- Spacing (restrict)
	line_height								= 0.85,
	cell_width								= 0.85,
}

-- Cursor
local cursor = {
  default_cursor_style			= 'BlinkingBlock',
	animation_fps							= 10,
	cursor_blink_rate					= 1250,
}

-- Keybindings
local wa = require('wezterm').action
local kbd		= {
	disable_default_key_bindings	= true,
	canonicalize_pasted_newlines 	= "None",
	debug_key_events							= false,
	use_dead_keys									= false,

	leader												= { key = "Insert", timeout_milliseconds = 1000 },
	keys													= {
		-- Handle font
		{ key = '=', mods = "CTRL", action = wa { EmitEvent = [[increase-font-size]]}},
		{ key = '-', mods = "CTRL", action = wa { EmitEvent = [[decrease-font-size]]}},
		{ key = '`', mods = "CTRL", action = wa { EmitEvent = [[reset-font-size]]}},

		-- Copy paste
		{ key = "c", mods = "CTRL|SHIFT", action = wa { CopyTo="Clipboard"}},
		{ key = "v", mods = "CTRL|SHIFT", action = wa { PasteFrom="Clipboard" }},

		-- Debug overlay
    { key="Escape", mods="CTRL|SHIFT", action="ShowDebugOverlay" },

		-- Fix Ctrl-Backspace and Ctrl-enter (F36)
		{	key = 'Backspace', mods="CTRL", action = wa { SendKey = { key = "W", mods = "CTRL" }}},
		{	key = 'Enter', mods="CTRL", action = wa { SendKey= { key="F12", mods="CTRL" }}},

		-- Toggle Opacity
		{key = "t", mods = "LEADER", action = wa { EmitEvent = [[toggle-opacity]] }},
		{key = "`", mods = "LEADER", action = wa { EmitEvent = [[revert-cwd]] }},

		-- Save-states (cwds)
		{ key = 'phys:1', mods = "LEADER|SHIFT", action = wa { EmitEvent = "save-cwd-1"}},
		{ key = 'phys:2', mods = "LEADER|SHIFT", action = wa { EmitEvent = "save-cwd-2"}},
		{ key = 'phys:3', mods = "LEADER|SHIFT", action = wa { EmitEvent = "save-cwd-3"}},
		{ key = 'phys:4', mods = "LEADER|SHIFT", action = wa { EmitEvent = "save-cwd-4"}},
		{ key = 'phys:5', mods = "LEADER|SHIFT", action = wa { EmitEvent = "save-cwd-5"}},

		{ key = 'phys:1', mods = "LEADER", action = wa { EmitEvent = "load-cwd-1"}},
		{ key = 'phys:2', mods = "LEADER", action = wa { EmitEvent = "load-cwd-2"}},
		{ key = 'phys:3', mods = "LEADER", action = wa { EmitEvent = "load-cwd-3"}},
		{ key = 'phys:4', mods = "LEADER", action = wa { EmitEvent = "load-cwd-4"}},
		{ key = 'phys:5', mods = "LEADER", action = wa { EmitEvent = "load-cwd-5"}},

	}
}

return require('util')
	.merge(terminal, theme, font, cursor, kbd)
