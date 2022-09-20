--------------------------------------------
-- Imports                    						--
--------------------------------------------
local gears			= require('gears')
	local _s				= gears.shape

--------------------------------------------
-- Custom shape definitions	     					--
--------------------------------------------
local K = { }

K.pline = function(cr, width, height)
	return _s.transform(_s.powerline) (cr, width, height, -15) end

K.rline	= function(cr, width, height)
	return _s.transform(_s.powerline)
		: rotate_at(width/2, height/2, math.pi)
		(cr, width, height, -15) end

K.lfork = function(cr, width, height)
	return _s.transform(_s.rectangular_tag) (cr, width, height, -15) end

K.rfork = function(cr, width, height)
	return _s.transform(_s.rectangular_tag)
		: rotate_at(width/2, height/2, math.pi)
		(cr, width, height, -15) end

K.ptag = function(cr, width, height)
	return _s.transform(_s.rectangular_tag) (cr, width, height, 15) end

K.rtag = function(cr, width, height)
	return _s.transform(_s.rectangular_tag)
		: rotate_at(width/2, height/2, math.pi)
		(cr, width, height, 15) end

K.blround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, true, false, false, false, 12) end

K.brround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, false, true, false, false, 12) end

K.lround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, true, false, false, true, 12) end

K.rround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, false, true, true, false, 12) end

K.bround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, true, true, true, false, 20) end

K.fround = function(cr, width, height)
	return _s.transform(_s.partially_rounded_rect)
		(cr, width, height, true, true, false, false, 12) end

return K
