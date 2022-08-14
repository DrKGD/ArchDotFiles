if BOOTSTRAP_GUARD then
	return end

local b						= require('plug.hydra');
local cmd					= require('util.generic').cmd;

---------------------------------------
-- Arming Hydra(s)                   --
---------------------------------------
(function()
		b:new("SessionManager")
			:setHeader("SM!", [[SessionManager]], [[Manage current session]])
			:setNewline(false)
			:setBorder('solid')
			:addBind({ key = 'k', name = 'keep', desc = 'Restart nvim and keep session', cmd = cmd 'DDKeep'})
			:addBind({ key = 'r', name = 'restart', desc = 'Restart nvim', cmd = cmd 'DDRestart', })
			:register()
	end)();

(function()
		b:new("Telescope")
			:setHeader("TS!", [[Telescope]], [[Please, select a picker]])
			:setNewline(false)
			:addBind({ key = 'f', name = 'find', desc = 'Find files by name', cmd = cmd 'TSFindFiles'})
			:addBind({ key = 'g', name = 'grep', desc = 'Find files by content', cmd = cmd 'Telescope live_grep'})
			:addBind({ key = 'o', name = 'open buffers', desc = 'List of current buffers', cmd = cmd 'Telescope buffers'})
			:addBind({ key = 't', name = 'todo', desc = 'List of current project todos', cmd = cmd 'TodoTelescope', cond = require('util.ext').git })
			:register()
	end)();

(function()
		b:new("Packer")
			:setHeader("PKG!", [[Packer]], [[PKThunder! ]])
			:addBind({ key = 'u', name = 'update', desc = 'Update pkgs and restart', cmd = cmd 'DDPUpdate'})
			:addBind({ key = 'i', name = 'install', desc = 'Install pkgs and restart', cmd = cmd 'DDPInstall'})
			:addBind({ key = 'c', name = 'compile', desc = 'Compile pkgs and restart', cmd = cmd 'DDPCompile'})
			:addBind({ key = 's', name = 'status', desc = 'Check pkgs status', cmd = cmd 'PackerStatus'})
			:register()
	end)();

(function()
		b:new("Mason")
			:setHeader("MM!", [[Yet another]], [[Manager ]])
			:addBind({ key = 's', name = 'status', desc = 'List packages and their status', cmd = cmd 'Mason'})
			:addBind({ key = 'u', name = 'update', desc = 'Update tools', cmd = cmd 'MasonToolsUpdate'})
			:addBind({ key = 'i', name = 'install', desc = 'Install tools yet to be installed', cmd = cmd 'MasonToolsInstall'})
			:register()
	end)();

(function()
		local ddv								= require('dd.vim')
		local	ibtoggle					= function()
				-- Force enable
				local isLoaded = vim.g.indent_blankline_enabled

				-- Try load indent_blankline
				require('util.packer').loadPlugin('indent-blankline.nvim')

				-- Toggle its status
				-- BUG: Does not live-update state
				if not isLoaded then
					return require('indent_blankline.commands').enable(true) end
				require('indent_blankline.commands').toggle(true)
			end
		local hasib							= function() return require('util.packer').hasPlugin('indent-blankline.nvim').isAvailable end

		b:new("VimOptions")
			:setHeader("VIM!", [[You' the boss!]])
			:setNewline(false)
			:setColor('red')
			:addTracker('list',			function() return vim.opt.list._value end)
			:addTracker('spell',		function() return vim.opt.spell._value end)
			:addTracker('relative', function() return vim.opt.relativenumber._value end)
			:addTracker('hlsearch', function() return vim.opt.hlsearch._value end)
			:addTracker('wrap',			function() return vim.opt.wrap._value end)
			:addTracker('blank',		function() return vim.g.indent_blankline_enabled end)
			:addBind({ key = 'i', track = 'list', name = 'invisible characters', cmd = ddv.toggleList})
			:addBind({ key = 'c', track = 'spell', name = 'check spell', cmd = ddv.toggleSpell})
			:addBind({ key = 'n', track = 'relative', name = 'number relative', cmd = ddv.toggleRelative})
			:addBind({ key = 's', track = 'hlsearch', name = 'search highlight', cmd = ddv.toggleSearch })
			:addBind({ key = 'w', track = 'wrap', name = 'wrap lines', cmd = ddv.toggleWordWrap})
			:addBind({ key = 'l', track = 'blank', name = 'indent blankline', cmd = ibtoggle, cond = hasib})
			:register()
	end)();

(function()
		local namedbuffer = function() return vim.api.nvim_buf_get_name(0) ~= '' end
		b:new("FileSystem")
			:setNewline(false)
			:setHeader("FS!", [[File System]], [[Handle files with ease]])
			:addBind({ key = 'n', name = 'new', desc = 'writes new file (does not open it)', cmd = cmd 'DDNew' })
			:addBind({ key = 'c', name = 'copy', desc = 'copy <%{fname}> to..?', cmd = cmd 'DDCopy', cond = namedbuffer })
			:addBind({ key = 'm', name = 'move', desc = 'move <%{fname}> to..?', cmd = cmd 'DDMove', cond = namedbuffer })
			:addBind({ key = 's', name = 'save', desc = 'saves file', cmd = cmd 'DDSave' })
			:addBind({ key = 'd', name = 'delete', desc = 'removes a file', cmd = cmd 'DDDelete' })
			:register()
	end)();

(function()
	local splits = require('smart-splits')
	local lastWindow = function() return #require('util.generic').wins() == 1 end
	b:new("WindowManager")
		:hasFooter(false)
		:setPosition('bottom')
		:setColor('red')
		:addGroup(nil, {
			{ key = 'h', name = 'move left', cmd = splits.move_cursor_left},
			{ key = 's', name = 'split', cmd = cmd 'split'},
			{ key = 'H', name = 'resize left', cmd = splits.resize_left},
		})
		:addGroup(nil, {
			{ key = 'k', name = 'move up', cmd = splits.move_cursor_up},
			{ key = 'o', name = 'only', cmd = cmd 'wincmd o | HydWindowManager'},
			{ key = 'K', name = 'resize up', cmd = splits.resize_up},
		})
		:addGroup(nil, {
			{ key = 'l', name = 'move right', cmd = splits.move_cursor_right},
			{ key = 'v', name = 'vsplit', cmd = cmd 'vsplit'},
			{ key = 'L', name = 'resize right', cmd = splits.resize_right},
		})
		:addGroup(nil, {
			{ key = 'j', name = 'move down', cmd = splits.move_cursor_down},
			{ key = 'r', name = 'reverse', cmd = cmd 'wincmd r'},
			{ key = 'J', name = 'resize down', cmd = splits.resize_down},
		})
		:addGroup(nil, {
			{ key = '[', name = 'prev buffer', cmd = cmd 'bprev'},
			{ key = ']', name = 'next buffer', cmd = cmd 'bnext'}
		})
		:addGroup(nil, {
			{ key = 'q', name = 'close', cmd = function() if not lastWindow() then vim.cmd('close') end end},
		})
		:register()
	end)();

(function()
	local cwd = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end
	b:new("Interface")
		:setHeader('IF!', [[Interface]], [[Access to other hydras]])
		:setColor('red')
		:setNewline(false)
		:addBind({ key = 'p', name = 'packer', desc = 'packer manager', cmd = cmd 'HydPacker Interface'})
		:addBind({ key = 'm', name = 'mason', desc = 'mason manager', cmd = cmd 'HydMason Interface'})
		:addBind({ key = 't', name = 'telescope', desc = 'frequently asked pickers', cmd = cmd 'HydTelescope Interface'})
		:addBind({ key = 'o', name = 'options', desc = 'vim options toggler', cmd = cmd 'HydVimOptions Interface'})
		:addBind({ key = 'f', name = 'file system', desc = 'operation on files and directories', cmd = cmd 'HydFileSystem Interface'})
		:addBind({ key = 's', name = 'session manager', desc = 'handle current vim session', cmd = cmd 'HydSessionManager Interface'})
		:addBind({ key = '/', name = 'nvim tree', desc = 'toggles nvim-tree status', cmd = cmd 'NvimTreeToggle'})
		:register()
	end)();

-- DISABLED: I like the idea, but it is kind of hard to use it
vim.api.nvim_create_user_command('HydBuffers', function()
		-- Get buffers
		local keys	= PREFERENCES.hydra.keys or "wertyuiopasdfghjklzxcvnm"
		local cbuff = vim.fn.bufnr('%')
		local bufs  = vim.tbl_filter(function(buff)
				if buff ~= cbuff then return buff end
			end, require('util.buffers').getBuffers_mru())

		local extractName = function(id)
				local fp = vim.api.nvim_buf_get_name(id)
				local name = vim.fn.fnamemodify(fp, ":t")
				local dir	= vim.fn.fnamemodify(name, ':p:h:t')

				if name == '' then return "UNNAMED BUFFER" end
				return string.format("../%s/%s", dir, name)
			end

		if #bufs == 0 then
			vim.notify(string.format("Currently, '%s' is the only available buffer!", extractName(cbuff)), "info", { render = "minimal"}) return end

		if #bufs > #keys then
			vim.notify("Number of buffers exceed maximum allowed, please consider using telescope instead!",
				"warn", { render = "minimal"}) return end

		local bufferSelector = b:new("Buffers")
			:addLine('Select buffer')
			:hasFooter(false)
			:setNewline(false)
			:setPosition('middle')
			:setColor('amaranth')
			:addBind({ key = 'q', name = 'back to ' .. extractName(cbuff), cmd = cmd('b' .. cbuff), opts = { exit = true }})

		for _, buf in ipairs(bufs) do
			local selection = math.random(1, #keys)
			local key				= keys:sub(selection, selection)

			bufferSelector
				:addBind({ key = key, name = extractName(buf), cmd = cmd('b' .. buf)})

			keys = keys:gsub(key, '')
		end

		return bufferSelector
			:build()
			:activate()
end, {})


local Hydra = require("hydra")

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

Hydra({
   name = 'Options',
   hint = hint,
   config = {
      color = 'red',
      invoke_on_body = true,
      hint = {
         border = 'rounded',
         position = 'middle'
      },
			on_enter = function()
				print(vim.inspect(require('util.buffers').getHiddenBuffers()))
			end
   },
   mode = {'n','x'},
   body = '<leader>o',
   heads = {
      { 'n', function()
         if vim.o.number == true then
            vim.o.number = false
         else
            vim.o.number = true
         end
      end, { desc = 'number' } },
      { 'r', function()
         if vim.o.relativenumber == true then
            vim.o.relativenumber = false
         else
            vim.o.number = true
            vim.o.relativenumber = true
         end
      end, { desc = 'relativenumber' } },
      { 'v', function()
         if vim.o.virtualedit == 'all' then
            vim.o.virtualedit = 'block'
         else
            vim.o.virtualedit = 'all'
         end
      end, { desc = 'virtualedit' } },
      { 'i', function()
         if vim.o.list == true then
            vim.o.list = false
         else
            vim.o.list = true
         end
      end, { desc = 'show invisible' } },
      { 's', function()
         if vim.o.spell == true then
            vim.o.spell = false
         else
            vim.o.spell = true
         end
      end, { exit = true, desc = 'spell' } },
      { 'w', function()
         if vim.o.wrap ~= true then
            vim.o.wrap = true
            -- Dealing with word wrap:
            -- If cursor is inside very long line in the file than wraps
            -- around several rows on the screen, then 'j' key moves you to
            -- the next line in the file, but not to the next row on the
            -- screen under your previous position as in other editors. These
            -- bindings fixes this.
            vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
                                     { expr = true, desc = 'k or gk' })
            vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
                                     { expr = true, desc = 'j or gj' })
         else
            vim.o.wrap = false
            vim.keymap.del('n', 'k')
            vim.keymap.del('n', 'j')
         end
      end, { desc = 'wrap' } },
      { 'c', function()
         if vim.o.cursorline == true then
            vim.o.cursorline = false
         else
            vim.o.cursorline = true
         end
      end, { desc = 'cursor line' } },
      { '<Esc>', nil, { exit = true } }
   }
})
