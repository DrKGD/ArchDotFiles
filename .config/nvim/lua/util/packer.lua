-------------------------------------
-- Check if packer is installed    --
-------------------------------------
local HAS_PACKER, packer_config = (function()
		local flag, packer = pcall(require, 'packer')
		if not flag then return false end
		return flag, packer.config
	end)()

if not HAS_PACKER then
		vim.schedule(function() vim.inspect('Packer is not installed!') end)
		return
	end

-- List of pacakges in packers folders
local lspackages =
	require('util.ext').ls(packer_config.package_root .. '/packer/*/').dirs

-------------------------------------
-- Packer functionalities ()       --
-------------------------------------
local M = {}

-- Checks plugin state
-- + isAvailable	(plugin is available for loading)
-- + isLoaded			(plugin is up and running)
-- + isInstalled	(plugin folder was found, but plugin is not available)
local isAvailable = function(n)
		if _G.packer_plugins and _G.packer_plugins[n] then return true end
	end

local isLoaded = function(n)
		if isAvailable(n) then return _G.packer_plugins[n].loaded end
	end

local isInstalled = function(n)
		-- name often does not correspond to the plugin name, thus we remove known keywords
		n = n:gsub("%S+", {
				['.nvim'] = '',
				['.lua'] = '',
				['.vim'] = ''
			})

		local rgx = string.format('.*%s.*', n)
		for _, entry in ipairs(lspackages) do
			if entry:match(rgx) then return true end
		end

		return false
	end

M.hasPlugin = function(name)
	if isLoaded(name) then
		return { isLoaded = true, isAvailable = true, isInstalled = true } end

	if isAvailable(name) then
		return { isAvailable = true, isInstalled = true } end

	if isInstalled(name) then
		return { isInstalled = true } end

	return {}
end

-- Load plugin if exists and returns either true or false
--  n.b. name is the plugin name (e.g. telescope.nvim)
M.loadPlugin = function(name)
	local p = M.hasPlugin(name)

	-- No action if plugin is already loaded
	if p.isLoaded then
		return true end

	-- Load plugin if plugin available
	if p.isAvailable then
		require('packer').loader(name) return true end

	-- Notify for a PackerClean in case package exists but not available
	--  no further action
	if p.isInstalled then
		vim.schedule(function() vim.notify(string.format('loadPlugin: package <%s> was found but it is not available for packer. Please, run [[:PackerClean]]!', name), "warn", { render = "minimal"}) end) end

	return false
end

return M
