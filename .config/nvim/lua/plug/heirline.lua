-------------------------------------
-- Requiring necessary utilities   --
-------------------------------------
local utils			= require('heirline.utils')
local cond			=	require('heirline.conditions')
local transform = require('util.transform')
local ucolor		=	require('util.color')
local gen				= require('util.generic')
local align			= transform.align
local join			= transform.join
local navic			= require('nvim-navic')

-------------------------------------
-- Local color palette storage     --
-------------------------------------
local function pgen(foreground)
		return {
			foreground					= foreground,
			background					= ucolor.darken(foreground, 0.80),
			inactive						= ucolor.darken(foreground, 0.65),
			active							= ucolor.lighten(foreground, 0.30) }
	end

local c = {}
c.file				= pgen '#FD5D88'
c.help				= pgen '#F5BC00'
c.unknown 		= pgen '#A9A99E'
c.tree				= pgen '#40C982'
c.util				= pgen '#B17EC9'
c.statusline	= pgen '#D96045'
c.trouble			= pgen '#33AAFF'

local mode_colors = {
	c =				'#FD5D88',
	i = 			'#F5BC00',
	v = 			'#5299D3',
	V = 			'#5299D3',
	["\22"] = '#5299D3',
	n =				'#F5F5F5',
	s =  			'#09EC8A',
	S =  			'#09EC8A',
	["\19"] = '#09EC8A',
	t =				'#F5F5F5',
	["!"]		= '#F5F5F5',
	r =				'#FD5D88',
	R =				'#FD5D88',
}

-- Thanks, feline-nvim!
local mode_alias = {
	['n'] = 'NORMAL',
	['no'] = 'OP',
	['nov'] = 'OP',
	['noV'] = 'OP',
	['no'] = 'OP',
	['niI'] = 'NORMAL',
	['niR'] = 'NORMAL',
	['niV'] = 'NORMAL',
	['v'] = 'VISUAL',
	['vs'] = 'VISUAL',
	['V'] = 'LINES',
	['Vs'] = 'LINES',
	[''] = 'BLOCK',
	['s'] = 'BLOCK',
	['s'] = 'SELECT',
	['S'] = 'SELECT',
	[''] = 'BLOCK',
	['i'] = 'INSERT',
	['ic'] = 'INSERT',
	['ix'] = 'INSERT',
	['R'] = 'REPLACE',
	['Rc'] = 'REPLACE',
	['Rv'] = 'V-REPLACE',
	['Rx'] = 'REPLACE',
	['c'] = 'COMMAND',
	['cv'] = 'COMMAND',
	['ce'] = 'COMMAND',
	['r'] = 'ENTER',
	['rm'] = 'MORE',
	['r?'] = 'CONFIRM',
	['!'] = 'SHELL',
	['t'] = 'TERM',
	['nt'] = 'TERM',
	['null'] = 'NONE'
}

-------------------------------------
-- Building utilities              --
-------------------------------------
local build = function(tbl, palette)
	local built = vim.tbl_map(function(entry)
		if type(entry) == 'function' then
			return entry(palette)
		end

		return entry
	end, tbl)

	built.hl = { bg = palette.background, fg = palette.foreground }
	return built
end

local refresh = function()
	vim.cmd('redrawstatus!')
end

local vialias = function(mode)
	return mode_alias[mode or 'n']
end

local vicolor	= function(mode)
	return mode_colors[mode or 'n']
end

-------------------------------------
-- Building utility components     --
-------------------------------------
local ux		= {}
ux.align		= { provider = [[%=]]}
ux.half_sx	= { provider = [[▍]] }
ux.half_dx	= { provider = [[▐]] }
ux.full			= { provider = [[█]] }
ux.space		= { provider = [[ ]] }
ux.sep			= { provider = [[🮚]] }
ux.shade_li = { provider = [[░]] }
ux.shade_me = { provider = [[▒]] }
ux.shade_ha = { provider = [[▓]] }


-------------------------------------
-- Building meta components        --
-------------------------------------
local meta	= {}

meta.file = {												-- Reads filename on BufEnter only
	update = 'BufEnter',
	init	= function(self)
			-- Set path
			self.path = vim.api.nvim_buf_get_name(0)
		end }

meta.line	= {
	update = {'WinScrolled', 'CursorMoved', 'CursorMovedI'},
	init = function(self)
		self.curr_line = vim.api.nvim_win_get_cursor(0)[1]
		self.lines = vim.api.nvim_buf_line_count(0)
	end }

meta.vi 	= { init = function(self)
		self.mode = vim.fn.mode(1)
	end }

-------------------------------------
-- Building finite components      --
-------------------------------------
local U = {}
U.buffer = {
		event = { 'BufEnter', 'ModeChanged'},
		init	= false,

		-- Telescope
		{ condition = function()
					return vim.bo.filetype == 'TelescopePrompt'
				end,
			provider = function()
					return 'TELESCOPE'
				end },

		-- Jabs 
		{ condition = function()
					return vim.bo.filetype == 'JABSwindow'
				end,
			provider = function()
					return 'JABS'
				end },

		-- NvimTree 
		{ condition = function()
					return vim.bo.filetype == 'NvimTree'
				end,
			provider = function()
					return 'TREE'
				end },

		-- Normal file
		{ provider = function()
					return 'EDITOR'
				end	}
	}

U.earthquake = utils.insert(meta.vi, {
		static = {
			eq				= {' ','▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
			array			= {},
		},

		init = function(self)
			if not self.once then
					self.once = true
					self.quakesize = self.quakesize or 7
					self.decay	= self.decay or 50
					self.array 	= {}
					for _=1, self.quakesize do
						table.insert(self.array, 1)
					end

					gen.timed_autocmd([[EarthquakeDecay]], self.decay, refresh)
				end
		end,

		hl				= function(self)
			return { fg = mode_colors[self.mode] } end,

		-- Capture keypress event
		{ update = {'User', pattern = 'KeyPress'},
			init = function(self)
					for i=1, self.quakesize do
						self.array[i] = math.min(#self.eq, self.array[i] + math.random() + math.random(1, 2)) end
			end },

		-- Capture keypress event
		{ update = {'User', pattern = 'EarthquakeDecay'},
			init = function(self)
				for i=1, self.quakesize do
					self.array[i] = math.max(1, self.array[i] - math.random() - math.random(0, 1)) end
			end },

		-- Delimiter left
		{ provider = '🬞' },

		-- Indicator
		{	provider = function(self)
			local tbl = {}
			for i, k in ipairs(self.array) do
				tbl[i] = self.eq[math.floor(k)] end

			return join(tbl, '') end} ,

		-- Delimiter right
		{ provider = '🬏' }
	})

U.vi = utils.insert(meta.vi, {
	hl				= function(self)
		return { fg = '#000000', bg = vicolor(self.mode) } end,

	provider = function(self)
		return vialias(self.mode) end
})

U.treesitter = {
	condition	= function(self)
			return vim.lsp.buf.server_ready() and navic.is_available()
		end,

	static = {
		opts = { depth_limit = 3 }
	},

	init = function(self)
			self.context = navic.get_location(self.opts)
		end,

	hl = { fg = '#FFFFFF' },

	provider = function(self)
			return string.format(' %s ', self.context)
		end,
}

-------------------------------------
-- Building function components    --
-------------------------------------
local F = {}

-- Filename
F.file = function(p)
		return utils.insert(meta.file, {

		init = function(self)
				if self.path == '' then self.name = 'No Name'
				else self.name = vim.fn.fnamemodify(self.path, self.format or ':t') end
			end,

		hl = { fg = p.foreground },

		provider = function(self)
				return string.format("%s", self.name)
			end })
	end

F.buftype = function(p)
	return {
		update = 'BufEnter',
		init = function(self)
			self.buftype = vim.opt.buftype._value
		end,

		hl = { fg = p.foreground},

		provider = function(self)
				return string.format("%s", self.buftype)
			end
	}
end

-- Beautyfile
F.beautyfile = function(p)
		return utils.insert(meta.file, {

		init = function(self)
				if self.path == '' then self.name = 'No Name'
				else self.name = vim.fn.fnamemodify(self.path, self.format or ':.') end
			end,

		hl = { fg = p.foreground },

		provider = function(self)
				return self.name:gsub("[\\/]", self.path_separator or ' > ')
			end })
end

-- Filename specialied for file
F.help	= function(p)
		return utils.insert(meta.file, {

		init = function(self)
				self.name = vim.fn.fnamemodify(self.path, self.format or ':t:r'):gsub('help', '', 1)
			end,

		hl = { fg = p.foreground },

		provider = function(self)
				return string.format("%s", self.name)
			end })
	end

-- File extension
F.ext = function(p)
	return utils.insert(meta.file, {
		condition	= function(self)
				return vim.fn.fnamemodify(self.path, ':e') ~= ''
			end,

		init = function(self)
				self.ext = vim.fn.fnamemodify(self.path, ':e')
			end,

		hl = { bg = p.foreground, fg = p.background },

		provider = function(self)
				return string.format("%s", self.ext:upper())
			end })
	end


-- Fileicon
F.icon = function(p)
	return {
	event = 'BufEnter',

	init = function(self)
			local extension = vim.bo.filetype
			self.icon = require('nvim-web-devicons').get_icon(self.filename, extension) or self.unknown or ''
		end,

	hl = { bg = p.foreground, fg = p.background },

	provider = function(self)
			return string.format([[%s ]], self.icon)
		end }
	end

-- File was modified and requires save
F.modified = function(p)
	return {
		init = function(self)
				self.modified = vim.bo.modified
			end,

		hl	 = function(self)
			if self.modified then
				return { fg = p.active } end
			return { fg = p.inactive }
		end,

		provider	= ' ' }
end

-- File is readonly
F.readonly = function(p)
	return {
	init = function(self)
			self.readonly = not vim.bo.modifiable or vim.bo.readonly
		end,

	hl	 = function(self)
		if self.readonly then
			return { fg = p.active } end
		return { fg = p.inactive }
	end,

	provider	= ' '}
end

-- Location of the cursor in percentage
F.linepercentage = function(p)
	return utils.insert(meta.line, {
		hl = { bg = p.background, fg = p.foreground},

		provider = function(self)
				if self.curr_line == 1 then	return align('TOPﬢ ', 7, 'right') end
				if self.curr_line == self.lines then return align('EOFﬠ ', 7, 'right') end
				return align(string.format([[ %.2f]], self.curr_line / self.lines * 100) .. '%%', 7, 'right')
			end
	}) end


-- Location of the cursor using a visual indicator
F.linebar	= function(p)
	return utils.insert(meta.line, {
		static = {
			sbar = {"█","▇", "▆","▅", "▄", "▃", "▂","▁", " "},
		},

		hl = { bg = p.inactive, fg = p.active},

		provider = function(self)
				local i = math.floor((self.curr_line - 1) / self.lines * #self.sbar) + 1
				return string.rep(self.sbar[i], self.linebar_size or 2)
			end
	}) end

-- Location of the cursor using the classic curr_line on total_lines formula
F.lineratio = function(p)
	return utils.insert(meta.line, {
		hl = { bg = p.background, fg = p.foreground },

		provider = function(self)
				local amount = math.floor(((self.lineratio_size or 7) - 1)/ 2)
				local format = string.format([[%% %dd:%%-%dd]], amount, amount)
				return align(string.format(format, self.curr_line, self.lines), self.lineratio_size, self.align or 'right')
			end
	}) end

F.filesize = function(p)
	return {
		update = { 'BufEnter', 'BufWrite'},

		hl = { bg = p.background, fg = p.foreground},

		provider = function(self)
			local suffix = { 'B', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB' }
			local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
			fsize = (fsize < 0 and 0) or fsize
			if fsize < 1024 then
				return align(string.format([[%d%s]], fsize, suffix[1]), self.max_length, self.align):sub(1, self.max_length)
			end
			local i = math.floor((math.log(fsize) / math.log(1024)))
			return align(string.format([[%.2g%s]], fsize / math.pow(1024, i), suffix[i + 1]), self.max_length, self.align):sub(1, self.max_length)
		end }
end

F.kpm	= function(p)
	return {
		static = {
			data = {}
		},

		init = function(self)
			if not self.once then
					self.once = true
					self.data.keypress = 0
					self.data.elapsed = 0
					gen.timed_autocmd([[KPMIncreaseTime]], 1000)
					gen.timed_autocmd([[KPMResetTime]], self.reset_time or 1500)
				end
			end,

		-- Capture keypress event
		{ update = {'User', pattern = 'KeyPress'},
			init = function(self)
				self.data.keypress = self.data.keypress + 1
			end },

		-- Capture second
		{ update = {'User', pattern = 'KPMIncreaseTime'},
			init = function(self)
				self.data.elapsed = self.data.elapsed + 1
			end },

		-- Reset or not
		{ update = {'User', pattern = 'KPMResetTime'},
			init = function(self)
				if self.last_amount == self.data.keypress then
					self.data.keypress = 0
					self.data.elapsed = 0
					refresh()
				else self.last_amount = self.data.keypress end
			end },

		-- Indicator (WPS or WPM)
		hl = { fg = p.active, bg = p.inactive },

		{ init = false,
			update = {'User', pattern = 'KPMIncreaseTime'},

			-- Waiting
			{ condition = function(self) return self.data.elapsed == 0 or self.data.keypress == 0 end,
				hl = { fg = p.inactive, bg = p.background },
				provider	= function(self) return align('-.--', self.kpm_size, 'right') end},

			-- WPS
			{ condition = function(self) self.wps = true end,
				provider = function(self)
					return align(string.format([[%.2f]], self.data.keypress / 5 / self.data.elapsed), self.kpm_size, 'right')
				end },

			-- (default) WPM
			{ provider = function(self)
					return align(string.format([[%.2f]], self.data.keypress / 5 / (self.data.elapsed / 60)), self.kpm_size, 'right')
				end } }
	}
end

-------------------------------------
-- Building statusline             --
-------------------------------------
local st_default_components = { hl = { fg = c.statusline.foreground }, static = { kpm_size = 6 },
	ux.full, { hl = { fg = c.statusline.background, bg = c.statusline.foreground }, U.buffer}, ux.full,
		utils.surround({ ux.full.provider, ux.full.provider}, function() return vicolor(vim.fn.mode(1)) end,{U.vi}),
			{ ux.align,  hl = { bg = 'NONE' }, U.treesitter, ux.align }, { hl = { bg = 'NONE'}, ux.half_dx},
				{ hl = { fg = c.statusline.background, bg = c.statusline.foreground}, {provider = 'KPM'}, ux.half_dx}, F.kpm, ux.half_dx,
						{ hl = { fg = c.statusline.background, bg = c.statusline.foreground }, ux.half_sx, { provider =' '}, ux.half_dx},
							F.lineratio, ux.half_dx, F.linebar}

local statusline	= {
		build(st_default_components, c.statusline)
	}


-------------------------------------
-- Building window bars            --
-------------------------------------
local wb_nobuff_components = {
	ux.full, { hl = { fg = c.unknown.background, bg = c.unknown.foreground }, provider = ' '}, ux.full,
		ux.space, { hl = { fg = c.unknown.foreground , bg = c.unknown.background }, provider = 'No Name', ux.align}, ux.space, F.buftype }

local wb_tree_components = {
	ux.full, { hl = { fg = c.tree.background, bg = c.tree.foreground }, provider = 'פּ '}, ux.full,
		ux.space, { hl = { fg = c.tree.foreground , bg = c.tree.background }, provider = 'Tree Viewer', ux.align}, ux.space }

local wb_trouble_components = {
	ux.full, { hl = { fg = c.trouble.background, bg = c.trouble.foreground }, provider = '飯'}, ux.full,
		ux.space, { hl = { fg = c.trouble.foreground , bg = c.trouble.background }, provider = 'Trouble', ux.align}, ux.space }

 -- { hl = { fg = c.file.background, bg = c.file.foreground }, provider ='瑱'}, ux.half_sx,  F.filesize, ux.half_dx,
local wb_default_components = { ux.full, F.icon, ux.full, F.ext, ux.full,
	ux.space, F.beautyfile, ux.space, ux.align, F.readonly, F.modified, ux.space }

local wb_help_components		= { ux.full, { hl = { fg = c.help.background, bg = c.help.foreground }, provider = 'ﲉ '}, ux.full,
		{ hl = { fg = c.help.background, bg = c.help.foreground }, provider = 'HELP'}, ux.full,
				ux.space, F.file, ux.space, ux.align, F.readonly, ux.space}

local wb_util_components		= { ux.full, { hl = { fg = c.util.background, bg = c.util.foreground }, provider = ' '}, ux.full,
		{ hl = { fg = c.util.background, bg = c.util.foreground }, provider = 'UTIL'}, ux.full, F.ext, ux.full, ux.space, F.file, ux.space, ux.align, F.readonly, ux.space}

local winbar			= {
		init = false,


		-- Different style for these buffer filetypes
		{ condition = function() return vim.bo.filetype == 'help' end,
				build(wb_help_components, c.help) },

		{ condition = function() return vim.bo.filetype == 'NvimTree' end,
				build(wb_tree_components, c.tree) },

		{ condition = function() return vim.bo.filetype == 'Trouble' end,
				build(wb_trouble_components, c.trouble) },

		-- Utility buffers only
		{ condition = function()
					local b = vim.api.nvim_buf_get_option(0, 'buftype')
					local n = vim.api.nvim_buf_get_name(0)
					return b == 'nowrite' and (n:match('.*bufferize')
						or n:match('.*dd%.scratchpad%..*')
						or n:match('.*dd%.scratch%.out'))
				end,
			build(wb_util_components, c.util) },


		-- Disable winbar for these buffer types
		{ condition = function()
				return cond.buffer_matches({
					buftype = { "nofile", "prompt", "quickfix", "TelescopePrompt", "harpoon"}
				}) end,
			init = function() vim.opt_local.winbar = nil end },

		-- Buffers without a name 
		{ condition = function() return vim.api.nvim_buf_get_name(0) == '' end,
				build(wb_nobuff_components, c.unknown) },

		{ build(wb_default_components, c.file) },
	}

return { statusline, winbar }
