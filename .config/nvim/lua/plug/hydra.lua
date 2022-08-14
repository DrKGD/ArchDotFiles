-------------------------------------
-- Requiring necessary utilities   --
-------------------------------------
local transform = require('util.transform')
local join			= transform.join
local joinin		= transform.join_interleaved
local align			= transform.align
local ascii			= require('util.tables').getASCII
local asciilen	= require('util.tables').getIphoteticalSize
local count			= transform.count_string
local clone			= require('util.generic').clone
local cmd				=	require('util.generic').cmd

-------------------------------------
-- Base configuration              --
-------------------------------------
local total		 = 40
local amargin	 = 1
local aindent	 = 2
local position = 'top-right'
local border	 = 'solid'
local color		 = 'teal'

-------------------------------------
-- Applying PREFERENCES onto Hydra --
-------------------------------------
if PREFERENCES and PREFERENCES.hydra then
	total		 = PREFERENCES.hydra.total or total
	amargin	 = PREFERENCES.hydra.margin or amargin
	aindent	 = PREFERENCES.hydra.indent or aindent
	position = PREFERENCES.hydra.position or position
	border	 = PREFERENCES.hydra.border or border
	color		 = PREFERENCES.hydra.color	or color
end

-------------------------------------
-- Some other definitions          --
-------------------------------------
local	margin	 = string.rep(' ', amargin)
local indent	 = string.rep(' ', aindent)

-------------------------------------
-- Base class definition:Construct --
-------------------------------------
local eformat			= require('util.generic').newError([[Hydra, error in '%s' definition: <%s>]])
local throwError	= function(msg) eformat(debug.getinfo(2).name, msg) end


-- Default functions
local onEnter = function() vim.api.nvim_exec_autocmds("User", { pattern = "HydraOpen" }) end
local onExit	= function() vim.api.nvim_exec_autocmds("User", { pattern = "HydraClose" }) end

local default_build_config = {
	color = color,
	hint = {
		border = border,
		position = position,
		offset	= 0,
		funcs = {
			-- Return file name of the lastly active buffer
			fname = function()
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t') end
		},
	},

	on_enter	= onEnter,
	on_exit		= onExit
}

-- Object builder
local builder			= {}

function builder:new(name)
	-- Name is required
	if not name then throwError("missing name for the hydra, will be using NoName!") end

	local o = {}
	setmetatable(o, {__index = self})
	o.name				= name													-- Name of the hydra
	o.header			= nil														-- Header (visual only)
	o.legend			= { visual = {}, heads = {} }		-- Registered keys
	o.condlist		= {}														-- Enable/Disable keys based off conditions
	o.footer			= true													-- Footer
	o.config			= clone(default_build_config)		-- Configuration, use setters below
	o.newline			= true													-- Should add a newline for each entry in the legend
	o.quit_key		= 'q'														-- Which key to use to quit the hydra (other than <Esc>)
	o.back_key		= 'b'														-- Which key to use to go back to the previous hydra (if present)
	o.in_use_keys = { ['<Esc>'] = true }					-- Maps already in use

	return o
end

-------------------------------------
-- Utility functions               --
-------------------------------------
-- Make key
local function make_key(key, name)
		-- If name contains (key) in the first character, then merge for looks
		name = name or ''
		if name:sub(1, 1) == key then
			name = name:sub(2)
		elseif #name>0 then name = ' ' .. name end

		return string.format("_%s_%s", key, name)
	end

-- Return true length total (following the inseration of underscores in the name)
local function true_total(str)
	return total + count(str, '%_') end

-- Return user-defined illegal_keys
local function illegal_keys(b, legal_keys)
	local tbl = {}
	for i, _ in pairs(b) do
		if not legal_keys[i] then
				table.insert(tbl, i)
			end
	end

	return tbl
end

-------------------------------------
-- Fast settings setters           --
-------------------------------------
function builder:addTracker(name, func)	-- Register a function that returns a checkbox based off the function state
	if not name
		then throwError('no name was given!') return self end

	if not func
		then throwError('no function was defined!') return self end

	if self.config.hint.funcs[name]
		then throwError('function was already defined: no further action was taken!') return self end

	self.config.hint.funcs[name] = function()
		if func() then
      return ' ' end
		return ' '
	end

	return self
end

function builder:addLookup(name, func)	-- Register a function that returns something which is updated
	if not name
		then throwError('no name was given!') return self end

	if not func
		then throwError('no function was defined!') return self end

	if self.config.hint.funcs[name]
		then throwError('function was already defined: no further action was taken!') return self end

	self.config.hint.funcs[name] = func
	return self
end

function builder:setNewline(state)			-- Should add newline at the ending of every definition
	if state == false then
		self.newline = false
	else self.newline = true end

	return self
end

function builder:onEnter(lambda)				-- Run something else on enter
	if not lambda then return end
	self.config.onEnter = function()
			onEnter(); lambda();
		end

	return self
end


function builder:hasFooter(state)				-- Should be processing footer
	if state == false then
		self.footer = false
	else self.footer = true end

	return self
end

function builder:onExit(lambda)					-- Run something else on exit
	if not lambda then return self end
	self.config.onExit = function()
			onExit(); lambda();
		end

	return self
end

function builder:setBackKey(key)
	if not position then throwError('no back key was given!') return self end
	self.back_key = key
	return self
end

function builder:setQuitKey(key)
	if not position then throwError('no quit key was given!') return self end
	self.quit_key = key
	return self
end

local availablePositions =
	{ ['top-left'] = true,		['top'] = true,			['top-right'] = true,
		['middle-left'] = true, ['middle'] = true,	['middle-right'] = true,
		['bottom-left'] = true, ['bottom'] = true, 	['bottom-right'] = true }

function builder:setPosition(position)	-- Change position
	if not position then throwError('no position was given!') return self end
	if type(position) ~= 'string' then throwError('position must be a string!') return self end
	if not availablePositions[position] then throwError('specified hydra position does not exist: setPosition ignored!') return self end

	self.config.hint.position = position
	return self
end

function builder:setBorder(b)
	if not b then throwError('no border was given!') return self end
	if type(b) ~= 'string' and type(b) ~= 'table'
		then throwError('border is expected to be either a string or a table') return self end
	self.config.hint.border = b
	return self
end

local availableColors =
	{ ['amaranth'] = true, ['teal'] = true, ['pink'] = true, ['red'] = true, ['blue'] = true }

function builder:setColor(c)
	if not c then throwError('no color was given!') return self end
	if type(c) ~= 'string' then throwError('color must be a string!') return self end
	if not availableColors[c] then throwError('specified hydra color does not exist: setColor ignored!') return self end

	self.config.color = c
	return self
end
-------------------------------------
-- Building blocks                 --
-------------------------------------
--- header comprehensive of name, description, initials
---  ideal for main menus with complicate options
function builder:setHeader(art, title, description)
		art		= art or self.name:sub(1, 3)
		local ascii_art = ascii(art)
		local ascii_len = asciilen(art)

		-- Fit description to the screen
		if description then
			description = transform.split(description, total - ascii_len - amargin) end

		local txt = joinin({{'', title or '', unpack(description or {})}, unpack(ascii_art)})
		self.header = align(txt, total, 'center') .. '\n'

		return self
	end

-- footer, provides quit and back (if required) bindings
local function makeFooter(previousMenu, quit_key, back_key)
		local direction = 'right'
		local binds			= {{ quit_key, nil, { exit = true }}}
		local line = make_key(quit_key, 'quit')
		if previousMenu then
			direction = 'justified'
			table.insert(binds, { back_key, cmd('Hyd' .. previousMenu), { exit = true }})
			line = line .. '\0' .. make_key(back_key, 'back to ' .. previousMenu:match("(%w+)")) end

		line = margin .. line .. margin
		-- return maps here
		return '\n' .. align(line, true_total(line), direction), binds
	end

-- as the name suggests, add whiteslines to the legend
function builder:addWhiteLines(amount)
		amount = amount or 1
		table.insert(self.legend.visual, string.rep('\n', amount))
		return self
	end

-- add anything you want to add
-- + text whatever you want to add
-- + alignment (left, center, right, justified)
--  tbh justified does not make much sense, but its up to you
-- + margin, distance from either 'side wall'
function builder:addLine(lines, direction, setmargin)
	if not lines then throwError('no text was given!') return self end
	setmargin = setmargin or amargin
	direction = direction or 'center'

	-- Rebuild lines by joining and splitting them again with the correct sizing
	local imargin = string.rep(' ', setmargin)
	lines = transform.split(join(lines), total - setmargin * 2)

	for _, line in ipairs(lines) do
		table.insert(self.legend.visual, imargin .. align(line, total - setmargin * 2, direction) .. imargin) end

	return self
end

-- add a single map-line, also used internally
-- key and lambda fields are required
-- available fields:
--  + key: on which key bind the hydra
--  + name: same line description
--  + track: add a state tracker
--  + desc: next line description (same alignment as the above)
--  + cmd: function or command to run (handled by hydra plugin)
--  + align: which alignment (left/center/right), by default is set to left
--  + opts: hydra-defined options, overrides defaults
--  + sep: false -> no newline, true -> forced newline
--  + cond: makes the binding conditional, thus hide it if condition is not met (= false)
--     can be either a function or an evaluated condition (= true/false)
--
-- e.g.
-- { key = 't', name = 'test', desc = 'prints <test>', align = 'left', cmd = function() print 'test' end}
local allowedBindKeys =
	{ key = true, name = true, desc = true, cmd = true, align = true, opts = true, cond = true, sep = true, track = true}

function builder:addBind(b)
	if not b then
		throwError("no binding was given!") return end

	if type(b) ~= 'table' then
		throwError("binding definition requires a descriptive table!") return self end

	if not b.key then
		throwError("no key was defined for bind!") return self end

	if self.in_use_keys[b.key] or (self.footer and (b.key == self.back_key or b.key == self.quit_key)) then
		throwError(string.format("key <%s> was already defined!", b.key)) return self end

	if not b.cmd then
		throwError(string.format("no cmd was defined for key <%s>!", b.key)) return self end

	local ik = illegal_keys(b, allowedBindKeys)
	if #ik > 0 then
		throwError(string.format("illegal fields (%s) found in the declaration of <%s>", join(ik, ','), b.key)) return self end

	-- justified is 'centered'
	if b.align == 'justified' then b.align = 'center' end

	-- Make lines
	local lines = {}

	-- Key - Name pair
	if b.track then b.track = string.format('%%{%s} ', b.track) end
	local fline = align((b.track or '') .. make_key(b.key, b.name), total, b.align or 'left')
	table.insert(lines, margin .. fline .. margin)

	-- Desc (multiline-alowed)
	if b.desc then
			local desc_split = transform.split(join(b.desc), total - amargin * 2 - aindent * 2)
			for _, line in ipairs(desc_split) do
					line = align(line, total - amargin * 2 - aindent * 2, b.align or 'left')
					table.insert(lines, margin .. indent .. line .. indent .. margin)
				end
		end

	-- Add newline if set so
	if b.sep or (type(b.sep) == 'nil' and self.newline) then
		table.insert(lines, string.rep(' ', total)) end

	-- Add keys to the list
	table.insert(self.legend.heads, { b.key, b.cmd, b.opts or {} })
	table.insert(self.legend.visual, join(lines))
	self.in_use_keys[b.key] = true

	-- If it is a conditional binding then add it to the list
	if type(b.cond) ~= 'nil' then
		table.insert(self.condlist, { cond = b.cond, visual = { #self.legend.visual }, heads = { #self.legend.heads }}) end

	return self
end

-- add inlined group of bindings
-- key and lambda fields are required
-- available fields for single element:
--  + key: on which key bind the hydra
--  + name: same line description
--  + cmd: function or command to run (handled by hydra plugin)
--  + opt: hydra-defined options, overrides group
-- available fields for the group:
--  + title: prev line description ()
--  + align: title alignment, by default 'center'
--  + opt: hydra-defined group options, overrides default
--  + cond: makes the group conditional, thus hide it if condition is not met (= false)
--     can be either a function or an evaluated condition (= true/false)
local allowedBindGroupKeys =
	{ key = true, name = true, cmd = true, opts = true }
local allowedBindGroup			=
	{ title = true, align = true, opts = true, cond = true }

function builder:addGroup(tgrp, bgrp)
	-- Allow empty tgrp
	tgrp = tgrp or {}

	if type(tgrp) ~= 'table' then
		throwError("group settings is not a table!") return self end

	if not bgrp or #bgrp == 0 then
		throwError("no bindings were given!") return self end

	local ik = illegal_keys(tgrp, allowedBindGroup)
	if #ik > 0 then
		throwError(string.format("illegal fields (%s) found in the declaration of <%s>", join(ik, ','), tgrp.title or 'group')) return self end

	local heads = {}
	local usekeys = {}
	local fline = ''
	for i, b in ipairs(bgrp) do
			if type(b) ~= 'table' then
				throwError("binding definition requires a descriptive table!") return self end

			if not b.key then
				throwError("no key was defined for bind!") return self end

			if self.in_use_keys[b.key] or (self.footer and (b.key == self.back_key or b.key == self.quit_key)) then
				throwError(string.format("key <%s> was already defined!", b.key)) return self end

			if not b.cmd then
				throwError(string.format("no cmd was defined for key <%s>!", b.key)) return self end

			local ikb = illegal_keys(b, allowedBindGroupKeys)
			if #ikb > 0 then
				throwError(string.format("illegal fields (%s) found in the declaration of <%s>", join(ikb, ','), b.key)) return self end
			table.insert(self.legend.heads, { b.key, b.cmd, vim.tbl_deep_extend("force", tgrp.opts or {}, b.opts or {})})
			table.insert(heads, #self.legend.heads)

			-- Add key
			fline = fline .. make_key(b.key, b.name)
			if i < #bgrp then fline = fline .. '\0' end
			usekeys[b.key] = true
		end


	local lines = {}

	-- Title (multiline-allowed, thought i'd vow against)
	if tgrp.title then
			local desc_split = transform.split(join(tgrp.title), total - amargin * 2 - aindent * 2)
			for _, line in ipairs(desc_split) do
					line = align(line, total - amargin * 2 - aindent * 2, tgrp.align or 'center')
					table.insert(lines, margin .. indent .. line .. indent .. margin)
				end
		end

	local keyalignment = 'justified'
	if #bgrp == 1 then keyalignment = 'center' end

	table.insert(lines, margin .. align(fline, true_total(fline) - 2 * amargin, keyalignment) .. margin)
	table.insert(self.legend.visual, join(lines))
	vim.tbl_extend("error", self.in_use_keys, usekeys)

	-- If it is a conditional binding then add it to the list
	if type(tgrp.cond) ~= 'nil' then
		table.insert(self.condlist, { cond = tgrp.cond, visual = { #self.legend.visual }, heads = heads }) end

	return self
end

-------------------------------------
-- Deliver the final object:Build  --
-------------------------------------
local function prepare(obj, previousMenu)
	-- If footer is required
	local footer, footer_maps = '', {}
	if obj.footer then
		footer, footer_maps = makeFooter(previousMenu, obj.quit_key, obj.back_key) end


	local legend_clone = clone(obj.legend)
	for _, entry in ipairs(footer_maps) do
		if obj.in_use_keys[entry[1]] then
			throwError(string.format("Could not map footer key <%s>, already in use!")) return end

		table.insert(legend_clone.heads, entry)
	end

	-- Add <Esc> manually to hide hint
	table.insert(legend_clone.heads, { '<Esc>', nil, { exit = true, desc = false}})

	for _, entry in ipairs(obj.condlist) do
		local evalcond
		if type(entry.cond) == 'boolean' then evalcond = entry.cond
		elseif type(entry.cond) == 'function' then evalcond = entry.cond(obj)
		end

		if not evalcond then
				for _, e in ipairs(entry.visual) do
						legend_clone.visual[e] = false
						-- table.remove(legend_clone.visual, e)
					end

				for _, e in ipairs(entry.heads) do
						legend_clone.heads[e] = false
					end
			end
		end

	-- Filter invalid legend entries
	local fil = function(t) return vim.tbl_filter(function(e) if e ~= false then return e end end, t) end
	legend_clone.visual = fil(legend_clone.visual)
	legend_clone.heads = fil(legend_clone.heads)

	return { name = obj.name, hint = (obj.header or '') .. join(legend_clone.visual) .. footer, heads = legend_clone.heads, config = obj.config }
end

local function build(obj, previousMenu)
	local p = prepare(obj, previousMenu)
	return require('hydra')(p)
end

-- Register function globally
local function register(obj)
	vim.api.nvim_create_user_command(string.format('Hyd%s', obj.name), function(previousMenu)
		if previousMenu.args ~= '' then
			return build(obj, previousMenu.args):activate() end
		return build(obj):activate()
	end, { nargs = '?' })
end

-- Builds the final object
-- + Returns the ready-to-use object
function builder:build()
	return build(self)
end

-- Registers the object, does not build it
function builder:register()
	register(self)
	return self
end

-------------------------------------
-- Preview the final object        --
-------------------------------------
function builder:preview()
	local p = prepare(self)

	for line in p.hint:gmatch('([^\n]*)\n?') do
		if line == '' then
			line = string.rep(' ', total) end

		print('|' .. line:gsub('%_', '') .. '|')
	end

	return self
end


return builder
