----------------
-- Plugins    --
----------------
return (function()
	--- Packer location
	local packerpath = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	local bootstrap = false
	if vim.fn.empty(vim.fn.glob(packerpath)) > 0 then
		bootstrap = true end

	--- Bootstrap packer
	if bootstrap then
		vim.fn.system({'git','clone','--depth','1','https://github.com/wbthomason/packer.nvim', packerpath}) end

	-- TODO: Fix this
	local PKGS_PATH = 'setup/pkg'
	local function pkg(file)
		local f, e = loadfile(string.format('%s/%s/%s.lua', vim.fn.stdpath('config'), PKGS_PATH, file))

		-- Print error
		if e then print(vim.inspect(e)) return end
		if not f then print(string.format("%s was null!", file)) return end
		return f()
	end

	local packer = require('packer')
	packer.init({
		auto_reload_compiled = false,
		luarocks = { python_cmd = 'python3' },
		config = { profile = { enable = true }}
	})


	--- N.B.: use_rocks requires luarocks, check latest version here
	---		http://luarocks.github.io/luarocks/releases/
	--- Download & extract and configure
	---		wget https://luarocks.org/releases/luarocks-3.9.0.tar.gz
	---		tar zxpf luarocks-3.8.0.tar.gz
	---		./configure --lua-version=5.1 --versioned-rocks-dir
	---		make build
	---		sudo make install
	require('packer.luarocks').install_commands()
	packer.startup(function(use, use_rocks)
		local function usepkg(fn) use(pkg(fn)) end

		--- N.B.: nvim stands for nvim only plugins (exclusive)
		--- N.B.: vim stands for vim and nvim plugins
		--- N.B.: grp stands for group of plugins

		--- Local Packages ---
		usepkg('local-utils.nvim')

		--- Packer and Fundamental packages ---
		usepkg('packer.nvim')
		usepkg('fundamentals.grp')

		--- Colorschemes ---
		usepkg('colorschemes.grp')

		--- UI ---
		usepkg('feline.nvim')
		usepkg('gitsigns.nvim')
		usepkg('todo-comments.nvim')
		usepkg('nvim-transparent.nvim')
		usepkg('bufferline.nvim')
		usepkg('indent-blankline.nvim')

		--- Telescope ---
		usepkg('telescope.nvim')
		usepkg('nvim-neoclip.nvim')

		--- Functional ---
		usepkg('wilder.nvim')
		usepkg('focus.nvim')
		usepkg('nvim-window.nvim')
		usepkg('nvim-comment.nvim')
		usepkg('nvim-colorizer.nvim')
		usepkg('mini.nvim')
		usepkg('bufdelete.nvim')
		usepkg('harpoon.nvim')
		usepkg('which-key.nvim')
		usepkg('diffview.nvim')
		usepkg('knap.nvim')

		--- Projects ---
		usepkg('project.nvim')

		--- Treesitter ---
		usepkg('nvim-treesitter.nvim')

		--- LSP ---
		usepkg('nvim-autopairs.nvim')
		usepkg('lsp.grp')

		--- DAP ---
		usepkg('nvim-dap.nvim')


		if bootstrap then
			vim.cmd('autocmd User PackerCompileDone quitall')
			packer.sync()
		end
	end)

	--- End configuration prematurely if bootstrapping
	return bootstrap

	end)()
