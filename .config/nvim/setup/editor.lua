(function() 
	--- Disable netwr (file-tree explorer)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-----------------
	-- Appearance  --
	-----------------
	-- Indentation --
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.softtabstop = 2
	vim.opt.expandtab = false
	vim.opt.smarttab = false
	vim.opt.shiftround = true
	vim.opt.autoindent = true
	vim.opt.smartindent = false

	vim.opt.cmdheight = 3
	vim.opt.cmdwinheight = 10

	vim.opt.cursorline = false
	vim.cmd([[set guicursor=]])

	vim.opt.wrap = true
	vim.opt.textwidth = 0
	vim.opt.wrapmargin = 0

	vim.opt.number = false
	vim.opt.relativenumber = true
	vim.opt.numberwidth = 4
	vim.opt.signcolumn = "yes:2"

	-- Use gui colors instead
	vim.opt.termguicolors = true

	-- Single statusline (thanks Famiu)
	vim.opt.laststatus = 3

	-----------------
	-- Behaviour   --
	-----------------
	-- Input
	vim.opt.backspace = 'indent,eol,start'
	vim.opt.mouse = 'a'

	--- No autocomment
	vim.opt.formatoptions:remove({'c','r','o'})
	vim.cmd([[augroup FormatOptions
					autocmd!
					autocmd BufEnter * set formatoptions-=cro
	augroup END]])

	--- Timeouts
	vim.opt.timeoutlen = 500
	vim.opt.ttimeoutlen = 0

	--- Lazy redraw
	vim.opt.lazyredraw = true
	vim.opt.ttyfast = true

	--- Scroll
	vim.opt.scrolloff = 5

	--- No start of line
	vim.opt.startofline = false

	--- Visual Selection
	vim.opt.virtualedit = 'block'

	--- Buffers and Tabs
	vim.opt.hidden = true
	vim.opt.tabpagemax = 10

	--- Automatically handlefd folding
	vim.opt.foldlevel = 0
	vim.opt.foldlevelstart = 99
	vim.cmd([[augroup RememberFolds
		autocmd!
		au BufWinLeave ?* mkview 1
		au BufWinEnter ?* silent! loadview 1
	augroup END]])

	-- vim.opt.foldmethod = 'indent'
	-- vim.opt.foldenable = false
	-- vim.opt.foldtext = '{...}'
	-- vim.opt.foldignore = ''

	--- Filetype but no indentation
	vim.cmd([[filetype plugin on]])
	vim.cmd([[filetype indent off]])

	vim.opt.sessionoptions = 'buffers,curdir,tabpages,resize,winsize,winpos,terminal,help'

	vim.opt.hlsearch = false
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.incsearch = true

	vim.opt.autoread = true
	vim.opt.autowrite = false
	vim.opt.encoding = 'utf-8'
	vim.opt.fileencoding = 'utf-8'

	--- Hidden characters
	vim.opt.list = false
	vim.o.showbreak = PREFERENCES.misc.showbreak
	vim.opt.listchars = PREFERENCES.misc.listchars
	vim.opt.fillchars = { eob = ' ' }

	-----------------
	-- Other       --
	-----------------
	--- Completition
	vim.opt.completeopt = 'menuone,noinsert'
	vim.opt.showmode = false

	--- Spell
	vim.g.mapleader = ','
	vim.opt.spelllang = 'it,en_us'
	vim.opt.spellsuggest = 'fast, 20'

	--- Set Leader
	vim.g.mapleader = ','

	--- Evaluate profile configuration
	for _, h in pairs(PREFERENCES.hooks) do h() end

	-----------------
	-- Directories --
	-----------------
	vim.opt.swapfile = true
	vim.opt.writebackup = true
	vim.opt.backup = true
	vim.opt.undofile = true
	vim.opt.autoread = true
	vim.opt.undolevels = 500
	vim.opt.shortmess = 'AS'
	vim.opt.directory = PREFERENCES.dirs.swap
	vim.opt.backupdir = PREFERENCES.dirs.back
	vim.opt.undodir   = PREFERENCES.dirs.undo

	local _ = (function()
		local isdir	= require('utils.path').directoryExists
		local mkdir = require('utils.file').mkdir

		if not isdir(PREFERENCES.dirs.swap) then
			mkdir(vim.fn.fnamemodify(PREFERENCES.dirs.swap,':p:h')) end
		if not isdir(PREFERENCES.dirs.back) then
			mkdir(vim.fn.fnamemodify(PREFERENCES.dirs.back,':p:h')) end
		if not isdir(PREFERENCES.dirs.undo) then
			mkdir(vim.fn.fnamemodify(PREFERENCES.dirs.undo,':p:h')) end
	end)()


	-----------------
	-- Languages --
	-----------------
	vim.g['tex_flavor'] = "latex"

	vim.cmd([[augroup IndexTypes 
		autocmd!
		autocmd BufRead,BufNewFile,BufReadPost *.cls		set ft=tex
		autocmd BufRead,BufNewFile,BufReadPost *.i3.inc	set ft=i3config
		autocmd BufRead,BufNewFile,BufReadPost .neoproj set ft=lua 
	augroup END]])

	end)()
