-------------------------------------
-- Neovim global configuraiton     --
-------------------------------------
(function()
	--- Disable netwr (file-tree explorer)
	-- vim.g.netrw_silent = 1
	-- vim.g.loaded_netrw = 1
	-- vim.g.loaded_netrwPlugin = 1
	-- vim.g.did_load_filetypes = 0
	-- vim.g.do_filetype_lua = 1

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

	vim.opt.cmdheight			= 1
	vim.opt.cmdwinheight	= 5
	-- vim.opt.report				= 10
	-- vim.opt.shortmess			= 'astWAIcTF'

	-- Disable global cursor line
	vim.opt.cursorline = false
	vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'BufWinEnter'},
		{ callback = function() vim.opt_local.cursorline = true end})
	vim.api.nvim_create_autocmd({'WinLeave'},
		{ callback = function() vim.opt_local.cursorline = true end})

	-- Always textwrap
	vim.opt.wrap				= true
	vim.opt.textwidth		= 0

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

	-- Shell
	vim.opt.shell	= '/bin/bash'

	--- Override formatoptions
	-- default formatoptions were 'tcqj' FYI
	local fmtop = ''
	vim.api.nvim_create_autocmd({'BufEnter'}, {callback = function() vim.opt.formatoptions = fmtop end})

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
	-- vim.opt.foldlevel = 0
	-- vim.opt.foldlevelstart = 99
	-- vim.cmd([[augroup RememberFolds
	-- 	autocmd!
	-- 	au BufWinLeave ?* mkview 1
	-- 	au BufWinEnter ?* silent! loadview 1
	-- augroup END]])

	-- vim.opt.foldmethod = 'indent'
	-- vim.opt.foldenable = false
	-- vim.opt.foldtext = '{...}'
	-- vim.opt.foldignore = ''

	--- Filetype but no indentation
	vim.cmd([[filetype plugin on]])
	vim.cmd([[filetype indent off]])

	vim.opt.sessionoptions = 'buffers,localoptions,buffers,curdir,tabpages,resize,winsize,winpos,terminal,help'

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
	vim.o.showbreak		= PREFERENCES.misc.showbreak
	vim.opt.listchars = PREFERENCES.misc.listchars
	vim.opt.fillchars = { eob = ' ' }

	-----------------
	-- Other       --
	-----------------
	-- Setup completion engine 
	vim.opt.completeopt = 'menu,menuone,noselect'
	vim.opt.showmode		= true
	vim.opt.pumheight		= 20
	vim.opt.pumblend		= 10

	--- Spell
	vim.opt.spelllang = 'en,cjk,it'
	vim.opt.spellsuggest = 'fast, 20'

	--- Set Leader
	vim.g.mapleader = ','

	--- Seed math.randomseed
	math.randomseed(os.time())

	-----------------
	-- Directories --
	-----------------
	vim.opt.swapfile = true
	vim.opt.writebackup = true
	vim.opt.backup = true
	vim.opt.undofile = true
	vim.opt.autoread = true
	vim.opt.undolevels = 500
	vim.opt.directory = PREFERENCES.dirs.swap
	vim.opt.backupdir = PREFERENCES.dirs.back
	vim.opt.undodir   = PREFERENCES.dirs.undo

	vim.fn.mkdir(PREFERENCES.dirs.swap, "p")
	vim.fn.mkdir(PREFERENCES.dirs.back, "p")
	vim.fn.mkdir(PREFERENCES.dirs.undo, "p")

	-----------------
	-- Languages --
	-----------------
	-- vim.g['tex_flavor'] = "latex"
	--
	-- vim.cmd([[augroup IndexTypes 
	-- 	autocmd!
	-- 	autocmd BufRead,BufNewFile,BufReadPost *.cls		set ft=tex
	-- 	autocmd BufRead,BufNewFile,BufReadPost *.i3.inc	set ft=i3config
	-- 	autocmd BufRead,BufNewFile,BufReadPost .neoproj set ft=lua 
	-- augroup END]])
end)()
