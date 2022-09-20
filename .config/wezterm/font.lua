local M = {}

local wezterm = require('wezterm')

M.font_fb = function(font)
	-- Main font
	-- Symbols font
	-- Secondary Symbols font
	-- Emoji Font

	local selected_fonts = {
		font,
		-- Do not use Mono, they do not behave like you'd expect
		{ family = "Noto Color Emoji", weight="Regular", stretch="Normal", style="Normal"},
		{ family = "Symbols Nerd Font", weight="Regular", stretch="Normal", style="Normal"},
		-- { family = "Nerd Emoji", weight="Regular", stretch="Normal", style="Normal"}
	}

	return wezterm.font_with_fallback(selected_fonts)
end

-- Increase font size 
wezterm.on([[increase-font-size]], function(window, _)
	local overrides = window:get_config_overrides() or {}

	if not overrides.font_size then
		overrides.font_size = PROFILE.FONT.SET + PROFILE.FONT.STEP
	else
		overrides.font_size = overrides.font_size + PROFILE.FONT.STEP
	end

	if overrides.font_size > PROFILE.FONT.MAX then
			overrides.font_size = PROFILE.FONT.MAX
		end

	window:set_config_overrides(overrides)
end)

-- Decrease font size 
wezterm.on([[decrease-font-size]], function(window, _)
	local overrides = window:get_config_overrides() or {}

	if not overrides.font_size then
		overrides.font_size = PROFILE.FONT.SET - PROFILE.FONT.STEP
	else
		overrides.font_size = overrides.font_size - PROFILE.FONT.STEP
	end

	if overrides.font_size < PROFILE.FONT.MIN then
			overrides.font_size = PROFILE.FONT.MIN
		end

	window:set_config_overrides(overrides)
end)

-- Reset font size to its default value (PROFILE.FONT.SET)
wezterm.on([[reset-font-size]], function(window, _)
	local overrides = window:get_config_overrides() or {}

	if overrides.font_size then
			overrides.font_size = nil
			window:set_config_overrides(overrides)
		end
end)


return M
