------------------------------------- 
-- Plugin Manager                  --
-------------------------------------
-- Local                           --
-------------------------------------
local path = function(fn)
	return string.format('%s/lua/setup/pkgs/%s.lua', vim.fn.stdpath('config'), fn) end

local arm				= function()
	local packer = require('packer')

	packer.init({
		auto_reload_compiled = false,
		luarocks = { python_cmd = 'python3' },
		config = { profile = { enable = false }},
		compile_path = PREFERENCES.plugin.compiled
	})

	require('packer.luarocks').install_commands()
	packer.startup(function(use)
		local function usepkg(file)
				local SUCCESS, RESULT = pcall(require('util.lod').lod, path(file))
				if not SUCCESS then
					vim.schedule(function() vim.notify(string.format("Could not arm %s", RESULT), "error", { title = "Packer" }) end) return end

				use(RESULT)
			end

		usepkg([[fundamentals.grp]])
		usepkg([[colorschemes.grp]])
		usepkg([[eyecandy.grp]])
		usepkg([[telescope.grp]])
		usepkg([[nvim-treesitter.grp]])
		usepkg([[todo-comments.nvim]])
		usepkg([[lsp.grp]])
		usepkg([[wilder.nvim]])
		usepkg([[sniprun.nvim]])
		usepkg([[knap.nvim]])
	end)
end

-------------------------------------
(function()
		-- Load packages 
		arm()

		-- Load custom packages
		if not BOOTSTRAP_GUARD then
			require('dd') end
	end)()
