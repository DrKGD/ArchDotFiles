-------------------------------------
-- Carousel utility                --
-------------------------------------
local throwError =
	require('util.generic').newError([[Carousel, error in definition: <%s>]])

Carousel = {
	selection		= 0,
	dictiionary	= {}
}

function Carousel:new(dictionary, selection)
	if not dictionary or #dictionary == 0 then throwError("expecting non-empty string/dictionary!") return end

	local o = {}
	setmetatable(o, {__index = self})

	-- If string, split to a dictionary
	if type(dictionary) == "string" then
		o.dictionary = {}; dictionary:gsub(".", function(c) table.insert(o.dictionary, c) end)
	elseif type(dictionary) == "table"	then
		o.dictionary = dictionary
	else
		throwError("unsupported type for dictionary, as it is a " .. type(dictionary))
	end

	-- Defaults to first character
	o.selection = selection or 1
	return o
end

local gNext = function(curr, max)
		curr = math.fmod(curr + 1, max + 1)
		if curr == 0 then curr = 1 end
		return curr
	end

local gPrev = function(curr, max)
		curr = curr - 1
		if curr == 0 then curr = max end
		return curr
	end

function Carousel:next()
		self.selection = gNext(self.selection, #self.dictionary)
		return self
	end

function Carousel:prev()
		self.selection = gPrev(self.selection, #self.dictionary)
		return self
	end

function Carousel:getPrev()
	return self.dictionary[gPrev(self.selection, #self.dictionary)] end

function Carousel:getNext()
	return self.dictionary[gNext(self.selection, #self.dictionary)] end

function Carousel:get()
	return self.dictionary[self.selection] end

return Carousel
