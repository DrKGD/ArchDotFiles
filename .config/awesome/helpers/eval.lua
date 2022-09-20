-- DEPRECATED: Please delete when you are sure to do so
--------------------------------------------
-- Global imports                         --
--------------------------------------------
local notify		= require('naughty').notify
local gears			= require('gears')
local util			= require('lua.util')
local defaults	= require('beautiful')
local discend		= util.discend
local findkey		= util.findkey
local keyset		= util.keyset

local M = {}


--------------------------------------------
-- Internal functions                     --
--------------------------------------------
local	percent_fields = {
	-- Scales with parent height
	height = {
		'height',
		'forced_height',
		'font_size',
	},

	-- Scales with parent width 
	width = {
		'width',
		'step_width',
		'step_spacing',
		'margin',
		'before',
		'after',
		'beforeafter',
		'forced_width',
	},
}

-- Scale component function
local scale		= function(cmp, path, relyon)
	-- Read value
	local current_value = discend(cmp, path)

	if type(current_value) == 'string' and
		current_value:sub(#current_value) == '%' then

		-- Convert value to float/decimal
		local amount = tonumber(current_value:sub(1, -2)) / 100
		if			amount > 1.0 then amount = 1.0
		elseif	amount < 0.0 then amount = 0.0 end

		-- Set value
		discend(cmp, path, amount * relyon)
	end
end

--------------------------------------------
-- Evaluate components in the ui          --
--------------------------------------------
return function(cmp, scr, ui)
		local n = function(text) notify { title = string.format("Widget evaluation '%s'", ui.name), text = text }  end

	--------------------
	-- Scaling fields -- 
	--------------------
	local requires_update = {}
	for factor, field in pairs(percent_fields) do
		for _, path in ipairs(keyset(cmp, field))	do
			table.insert(requires_update, { path = path, factor = factor })
		end
	end

	table.sort(requires_update, function(a,b)
		local _, counta = a.path:gsub('%.', " ")
		local _, countb = b.path:gsub('%.', " ")
		return counta < countb
	end)

	for _, entry in ipairs(requires_update) do
		local parent		= entry.path:match('(.*)%..*%..*') or ''
		local factor		= findkey(cmp, parent, entry.factor)
			or ui[entry.factor]

		scale(cmp, entry.path, factor)
	end

	--------------------
	-- Font config    --
	--------------------
	for _, path in ipairs(keyset(cmp, { 'font' })) do
		if discend(cmp, path) == true then
			local parent = path:match('(.*)%..*') or ''

			local font_size		= discend(cmp, parent .. '.font_size') or defaults.font_size
			local font_family = discend(cmp, parent .. '.font_family') or defaults.font_family
			local font				=	string.format('%s %2f', font_family, font_size)
			discend(cmp, parent .. '.font', font)
		end
	end

end
