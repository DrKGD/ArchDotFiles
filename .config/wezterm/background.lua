local rand = require('random')
local util = require('util')

local M = {}

local planets = {
		items = util.scandir(string.format('%s/space/planets/', PROFILE.CONFIG_PATH)),
		size		= { min = 0.10, max = 0.40 },
		offset	= 0.35,
		brightness = { min = 0.05, max = 0.30 },
		hue = { min = 0.0, max = 1.0 }
	}


-- Far away objects, such as black holes, nebulosa
local faraway = {
		items = util.scandir(string.format('%s/space/faraway/', PROFILE.CONFIG_PATH)),
		size		= { min = 0.15, max = 0.30 },
		offset	= 0.25,
		brightness = { min = 0.25, max = 0.75 },
		hue = { min = 0.0, max = 1.0 },
	}

local generate_spaceobj = function(category, surface, grid, noise)
	-- Static parameters
	local spaceobj = {
		repeat_x					= 'NoRepeat',
		repeat_y					= 'NoRepeat',
		vertical_align		= 'Top',
		horizontal_align	= 'Left',
	}

	-- Retrieve a random object from the selected category 
	spaceobj.source = { File = category.items[rand.i32(1, #category.items)]}

	-- Resize to a random value (in px)
	--  the bigger, the stronger the parallax effect (1:1 to size)
	local mpx = math.min(surface.pixel_width, surface.pixel_height)
	local rnd_size = rand.f32(category.size.min, category.size.max)
	local sz = math.floor(rnd_size * mpx)
	spaceobj.width = sz; spaceobj.height = sz
	spaceobj.attachment = { Parallax = rnd_size }

	-- Offset position 
	local pg = rand.i32(1, #grid)															-- Grid position
	local nx = rand.f32(-noise, noise) * surface.pixel_width/2	-- Noise in x
	local ny = rand.f32(-noise, noise) * surface.pixel_height/2	-- Noise in y
	spaceobj.horizontal_offset = grid[pg].x - sz/2 + nx
	spaceobj.vertical_offset = grid[pg].y - sz/2 + ny

	-- Remove position from grid
	grid[pg] = grid[#grid]
	grid[#grid] = nil

	-- HSB Value(s)
	spaceobj.hsb = {}
	if category.brightness then
		spaceobj.hsb.brightness = rand.f32(category.brightness.min, category.brightness.max) end
	if category.hue	then
		spaceobj.hsb.hue = rand.f32(category.hue.min, category.hue.max) end
	if category.saturation then
		spaceobj.hsb.saturation = rand.f32(category.saturation.min, category.saturation.max) end

	return spaceobj
end


-- Background
local deep_dark				= {
	source = { Color = "rgba(0% 0% 0% 85%)" },
	repeat_x = "NoRepeat", repeat_y = "NoRepeat",
	height = "100%", width = "100%",
}

-- Position elements on the grid
local make_grid = function(surface, points, deadarea)
	-- Excluded area
	local ex = math.floor(surface.pixel_width * deadarea)
	local ey = math.floor(surface.pixel_height * deadarea)

	-- Step
	local sx = (surface.pixel_width - ex) / points
	local sy = (surface.pixel_height - ey) / points

	-- Make grid
	local grid = {}
	for r=0,points - 1 do
		for c=0, points - 1 do
			table.insert(grid, { x = sx * r + sx/2 + ex/2, y = sy * c + sy/2 + ey/2})
		end
	end

	-- Shuffle
	local shuffle = {}
	for _, v in ipairs(grid) do
		local pos = math.random(1, #shuffle + 1)
		table.insert(shuffle, pos, v)
	end

	return shuffle
end

local placeholder = function(position, sz)
	return {
		source						= { File = planets.items[1] },
		repeat_x					= 'NoRepeat',
		repeat_y					= 'NoRepeat',
		vertical_align		= 'Top',
		horizontal_align	= 'Left',
		width							= sz,
		height						= sz,
		horizontal_offset = position.x - sz/2,
		vertical_offset		= position.y - sz/2,
	}
end

local imsg		= require('wezterm').log_info
local generate_galaxy = function(surface)
	local gx = { deep_dark }

	local celestial_bodies_grid = make_grid(surface, 8, 0.35)

	-- Spawn planets
	for _=1, rand.i32(1, 3) do
		table.insert(gx, generate_spaceobj(planets, surface, celestial_bodies_grid, 0.15))
	end

	-- Primary objects (planets, stars)
	for _, p in ipairs(celestial_bodies_grid) do
		table.insert(gx, placeholder(p, 10))
	end

	return gx
end

-- M.setup = function()
-- 	require('wezterm').on('galaxy-please', function(window, _)
-- 		window:set_config_overrides({ background = generate_galaxy(window:get_dimensions()) })
-- 	end)
-- 	-- require('wezterm').on('window-config-reloaded', function(window, _)
-- 	-- 	window:set_config_overrides({ background = galaxy(window:get_dimensions()) })
-- 	-- end)
-- end

return M
