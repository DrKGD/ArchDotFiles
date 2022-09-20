
---@diagnostic disable: need-check-nil
--------------------------------------------
-- Imports                    						--
--------------------------------------------
-- local notify		= require('naughty').notify
-- local define		= require('helpers.ui').wibox
-- local wibox			= require('wibox')
-- local widget		= wibox.widget
-- local layout		= wibox.layout
-- local container = wibox.container
-- local c					= require('config.widget.template')
-- local t					= require('beautiful')

--------------------------------------------
-- Registered wibars                      --
--------------------------------------------
local M = {}

-- ENHANCE: Scientifica ain't that good for the scope?
-- M.clock = define({ name = 'clock', orientation = 'vertical', width = '15%', height = '12%', bg = t.clock.bg}, {
	-- { widget = container.place,
	-- 	height = '50%',
	-- 	{ layout = layout.fixed.horizontal,
	-- 		c.time { [[%H]], font_size = '100%', fg = t.clock.hours,	valign = 'top'},
	-- 		c.time { [[%M]], font_size = '80%', fg = t.clock.minutes, valign = 'top'},
	-- 		c.time { [[%S]], font_size = '35%', fg = t.clock.seconds, valign = 'top' } } },
	--
	-- { widget = container.place,
	-- 	{ layout = layout.fixed.horizontal,
	-- 		height = '30%',
	-- 		c.label { 'deatharte', font_size = '100%', fg = t.clock.seconds, valign = 'top' } } },
	--
	-- { widget = container.place,
	-- 	{ layout = layout.fixed.horizontal,
	-- 		c.time { [[%H]], font_size = '100%', fg = t.clock.hours,	valign = 'top'},
	-- 		c.time { [[%M]], font_size = '80%', fg = t.clock.minutes, valign = 'top'},
	-- 		c.time { [[%S]], font_size = '35%', fg = t.clock.seconds, valign = 'top'} } },
-- })

-- M.rect = define({ name = 'debug', orientation = 'vertical', width = 500, height = 500, bg = '#f0f'},{
-- 	{ widget = container.place,
-- 		{ layout = layout.fixed.horizontal,
-- 			{ widget = container.background,
-- 				bg = '#FF0000',
-- 				height = '50%',
-- 				forced_height = '50%',
-- 				forced_width = '50%',
-- 				{ layout = layout.fixed.vertical,
-- 					{ widget = container.background,
-- 						height = '60%',
-- 						forced_height = '60%',
-- 						bg = '#FFFF00',
-- 						{ widget = widget.textbox, markup = [[<span line_height='0.627'>A</span>]], font_size = '100%', font = true}},
-- 					{ widget = container.background,
-- 						height = '40%',
-- 						forced_height = '40%',
-- 						bg = '#FF0000',
-- 						{ widget = widget.textbox, markup = [[<span line_height='0.627'>A</span>]], font_size = '100%', font = true}}}}}}
-- })

return M
