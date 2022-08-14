-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/deatharte/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/deatharte/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/deatharte/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/deatharte/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/deatharte/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  ["JABS.nvim"] = {
    commands = { "JABSOpen" },
    config = { "\27LJ\2\n‰\2\0\0\4\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\fsymbols\1\0\t\rterminal\tÓûï \aro\tÔúá \vedited\tÔ£™ \vlocked\tÔ†Ω \vhidden\tÔ¨ò \14alternate\tÔùÜ \fcurrent\tÔòΩ \nsplit\tÔÉõ \17default_file\tÔÖõ \14highlight\1\0\4\vhidden\15JabsHidden\fcurrent\15JabsNormal\nsplit\14JabsSplit\14alternate\18JabsAlternate\vkeymap\1\0\2\tjump\t<CR>\nclose\6q\1\0\3\vheight\3\15\nwidth\3P\vborder\vsingle\nsetup\tjabs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/JABS.nvim",
    url = "https://github.com/matbme/JABS.nvim"
  },
  LuaSnip = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bufdelete.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/bufdelete.nvim",
    url = "https://github.com/famiu/bufdelete.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  ["cmp-treesitter"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp-treesitter",
    url = "https://github.com/ray-x/cmp-treesitter"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["colorscheme.monokai"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/colorscheme.monokai",
    url = "https://github.com/tanvirtin/monokai.nvim"
  },
  ["colorscheme.oxocarbon-lua"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/colorscheme.oxocarbon-lua",
    url = "https://github.com/B4mbus/oxocarbon-lua.nvim"
  },
  ["colorscheme.rvcs"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/colorscheme.rvcs",
    url = "https://github.com/shaeinst/roshnivim-cs"
  },
  ["colorscheme.tokyodark"] = {
    config = { "\27LJ\2\n≈\1\0\0\2\0\a\0\0176\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\3\0006\0\0\0009\0\1\0+\1\1\0=\1\4\0006\0\0\0009\0\1\0'\1\6\0=\1\5\0K\0\1\0\t0.85\26tokyodark_color_gamma\28tokyodark_enable_italic$tokyodark_enable_italic_comment%tokyodark_transparent_background\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/colorscheme.tokyodark",
    url = "https://github.com/tiagovla/tokyodark.nvim"
  },
  ["cool-substitute.nvim"] = {
    config = { "\27LJ\2\nW\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\22setup_keybindings\2\nsetup\20cool-substitute\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/cool-substitute.nvim",
    url = "https://github.com/otavioschwanck/cool-substitute.nvim"
  },
  ["dressing.nvim"] = {
    config = { "\27LJ\2\n_\0\1\4\1\4\0\n-\1\0\0\14\0\1\0X\1\6Ä6\1\0\0'\3\1\0B\1\2\0029\1\2\1'\3\3\0B\1\2\1K\0\1\0\0¿\19telescope.nvim\15loadPlugin\16util.packer\frequireÎ\1\1\0\6\0\14\0\19+\0\1\0006\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\0035\4\v\0003\5\n\0=\5\f\4=\4\r\3B\1\2\0012\0\0ÄK\0\1\0\vselect\15get_config\1\0\0\0\ninput\1\0\0\14max_width\1\3\0\0\3(\4ö≥ÊÃ\tô≥Ê˛\3\14min_width\1\3\0\0\3(\4ö≥ÊÃ\tô≥Ê˛\3\1\0\3\rwinblend\3\30\vborder\vsingle\rrelative\veditor\nsetup\rdressing\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\n£\1\0\0\b\0\t\0\0166\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\a\0005\3\5\0004\4\3\0006\5\0\0'\a\3\0B\5\2\0029\5\4\5>\5\1\4=\4\6\3=\3\b\2B\0\2\1K\0\1\0\rfiletype\1\0\0\6*\1\0\0\31remove_trailing_whitespace\28formatter.filetypes.any\nsetup\14formatter\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["fzy-lua-native"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/fzy-lua-native",
    url = "https://github.com/romgrk/fzy-lua-native"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nå\5\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0035\4\t\0=\4\n\0035\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\fkeymaps\1\0\2\vbuffer\1\fnoremap\1\nsigns\17changedelete\1\0\4\ahl\19GitSignsChange\vlinehl\21GitSignsChangeLn\ttext\b‚ñí\nnumhl\21GitSignsChangeNr\14topdelete\1\0\4\ahl\19GitSignsDelete\vlinehl\21GitSignsDeleteLn\ttext\b‚ñí\nnumhl\21GitSignsDeleteNr\vdelete\1\0\4\ahl\19GitSignsDelete\vlinehl\21GitSignsDeleteLn\ttext\b‚ñí\nnumhl\21GitSignsDeleteNr\vchange\1\0\4\ahl\16GitSignsAdd\vlinehl\21GitSignsChangeLn\ttext\b‚ñí\nnumhl\21GitSignsChangeNr\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\vlinehl\18GitSignsAddLn\ttext\b‚ñí\nnumhl\18GitSignsAddNr\1\0\6\vlinehl\2\24attach_to_untracked\2\nnumhl\1\18sign_priority\3\6\15signcolumn\2\23current_line_blame\1\nsetup\rgitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  harpoon = {
    config = { "\27LJ\2\n|\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\23excluded_filetypes\1\0\0\1\4\0\0\fharpoon\rNvimTree\20TelescopePrompt\nsetup\fharpoon\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  ["heirline.nvim"] = {
    config = { "\27LJ\2\n_\0\0\a\0\5\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\2\3\0006\4\0\0'\6\4\0B\4\2\0A\2\0\0A\0\0\1K\0\1\0\18plug.heirline\vunpack\nsetup\rheirline\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/heirline.nvim",
    url = "https://github.com/rebelot/heirline.nvim"
  },
  ["hydra.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/hydra.nvim",
    url = "https://github.com/anuvyklack/hydra.nvim"
  },
  ["icon-picker.nvim"] = {
    config = { "\27LJ\2\nY\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\28disable_legacy_commands\2\nsetup\16icon-picker\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/icon-picker.nvim",
    url = "https://github.com/ziontee113/icon-picker.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n§\2\0\0\19\0\f\3,6\0\0\0'\2\1\0B\0\2\0024\1\0\0009\2\2\0009\4\3\0006\6\4\0009\6\5\0069\6\6\0069\6\a\6*\a\0\0B\4\3\0A\2\0\2)\3\n\0009\4\b\0\18\6\2\0*\a\1\0B\4\3\0026\5\0\0'\a\1\0B\5\2\0029\5\t\5\30\6\2\3)\a\1\0\23\b\2\3)\t\1\0M\a\vÄ6\v\n\0009\v\v\v\18\r\1\0\18\14\5\0\18\16\4\0\18\17\2\0\23\18\2\n\"\18\18\6B\14\4\0A\v\1\1O\aı\1276\a\n\0009\a\v\a\18\t\1\0\18\n\4\0B\a\3\1L\1\2\0\vinsert\ntable\bmix\vdarken\vurgent\ai3\fpalette\16PREFERENCES\flighten\vinvert\15util.color\frequireõ≥ÊÃ\25ÃôÛ˛\3Õô≥Ê\fÊÃôˇ\3\2M\0\0\6\2\5\0\n6\0\0\0009\0\1\0009\0\2\0)\2\0\0-\3\0\0005\4\3\0-\5\1\0=\5\4\4B\0\4\1K\0\1\0\a¿\6¿\afg\1\0\0\16nvim_set_hl\bapi\bvimÀ\1\0\0\t\0\r\1\0196\0\0\0009\0\1\0009\0\2\0)\2\0\0'\3\3\0005\4\v\0006\5\4\0'\a\5\0B\5\2\0029\5\6\0056\a\a\0009\a\b\a9\a\t\a9\a\n\a*\b\0\0B\5\3\2=\5\f\4B\0\4\1K\0\1\0\afg\1\0\0\vurgent\ai3\fpalette\16PREFERENCES\flighten\15util.color\frequire\31IndentBlanklineContextChar\16nvim_set_hl\bapi\bvimÕô≥Ê\fÊÃŸ˛\3ı\2\1\0\f\0\16\0%3\0\0\0B\0\1\0024\1\0\0006\2\1\0\18\4\0\0B\2\2\4X\5\16Ä6\a\2\0009\a\3\a'\t\4\0\18\n\5\0B\a\3\0026\b\5\0009\b\6\b\18\n\1\0\18\v\a\0B\b\3\0016\b\a\0009\b\b\b3\n\t\0B\b\2\0012\a\0Ä2\5\0ÄE\5\3\3R\5Ó\1276\2\a\0009\2\b\0023\4\n\0B\2\2\0016\2\v\0'\4\f\0B\2\2\0029\2\r\0025\4\14\0=\1\15\4B\2\2\1K\0\1\0\24char_highlight_list\1\0\5\tchar\b‚ñë\31show_current_context_start\1\25show_current_context\2\18show_foldtext\1\17context_char\b‚ñí\nsetup\21indent_blankline\frequire\0\0\rschedule\bvim\vinsert\ntable\27IndentBlanklineColor%d\vformat\vstring\vipairs\0\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lightspeed.nvim"] = {
    config = { "\27LJ\2\ni\0\0\4\0\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0004\3\0\0=\3\4\2B\0\2\1K\0\1\0\16safe_labels\1\0\1\25jump_to_unique_chars\1\nsetup\15lightspeed\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["mapx.nvim"] = {
    config = { "\27LJ\2\nÑ\1\0\0\6\0\b\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\3'\5\5\0B\3\2\2=\3\a\2B\0\2\1K\0\1\0\rwhichkey\1\0\0\19which-key.nvim\15loadPlugin\16util.packer\nsetup\tmapx\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/mapx.nvim",
    url = "https://github.com/b0o/mapx.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason-tool-installer.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/mason-tool-installer.nvim",
    url = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\2\nj\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\20show_cursorline\1\21centered_peeking\2\17show_numbers\2\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\næ\3\0\0\a\0\14\0\0206\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\1\3\1'\3\4\0B\1\2\0029\2\5\0005\4\6\0=\1\a\0045\5\b\0=\5\t\0045\5\n\0005\6\v\0=\6\f\5=\5\r\4B\2\2\1K\0\1\0\14fast_wrap\nchars\1\6\0\0\6{\6[\6(\6\"\6'\1\0\a\tkeys\31qwertyuiopzxcvbnmasdfghjkl\fend_key\6$\16check_comma\2\bmap\n<A-d>\14highlight\vSearch\19highlight_grey\fComment\fpattern\23[%'%\"%)%>%]%)%}%,]\21disable_filetype\1\3\0\0\20TelescopePrompt\rNvimTree\rcheck_ts\1\0\4\22ignored_next_char\v[%w%.]\30enable_check_bracket_line\2\vmap_cr\1\vmap_bs\1\nsetup\20nvim-treesitter\15loadPlugin\16util.packer\19nvim-autopairs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\nÀ\4\0\0\4\0\r\0\0316\0\0\0009\0\1\0009\0\2\0'\2\3\0005\3\4\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\5\0005\3\6\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0005\3\b\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\t\0005\3\n\0B\0\3\0016\0\0\0009\0\1\0009\0\2\0'\2\v\0005\3\f\0B\0\3\1K\0\1\0\1\0\4\ttext\bÔÖÑ\vlinehl\15DapStopped\vtexthl\15DapStopped\nnumhl\15DapStopped\15DapStopped\1\0\4\ttext\bÔÅö\vlinehl\16DapLogPoint\vtexthl\16DapLogPoint\nnumhl\16DapLogPoint\16DapLogPoint\1\0\4\ttext\bÔÅ™\vlinehl\18DapBreakpoint\vtexthl\18DapBreakpoint\nnumhl\18DapBreakpoint\26DapBreakpointRejected\1\0\4\ttext\bÔ≥Å\vlinehl\18DapBreakpoint\vtexthl\18DapBreakpoint\nnumhl\18DapBreakpoint\27DapBreakpointCondition\1\0\4\ttext\bÔòÆ\vlinehl\18DapBreakpoint\vtexthl\18DapBreakpoint\nnumhl\18DapBreakpoint\18DapBreakpoint\16sign_define\afn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-gomove"] = {
    config = { "\27LJ\2\np\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\17map_defaults\1\rundojoin\2\rreindent\1\22move_past_end_col\2\nsetup\vgomove\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-gomove",
    url = "https://github.com/booperlv/nvim-gomove"
  },
  ["nvim-highlight-colors"] = {
    config = { "\27LJ\2\n\\\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\vrender\15background\nsetup\26nvim-highlight-colors\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-highlight-colors",
    url = "https://github.com/brenoprata10/nvim-highlight-colors"
  },
  ["nvim-lint"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\rtry_lint\tlint\frequire±\1\1\0\5\0\r\0\0166\0\0\0'\2\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0005\2\t\0005\3\v\0003\4\n\0=\4\f\3B\0\3\1K\0\1\0\rcallback\1\0\0\0\1\2\0\0\17BufWritePost\24nvim_create_autocmd\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-lint",
    url = "https://github.com/mfussenegger/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0v\1\2\b\2\a\0\14'\2\0\0-\3\0\0009\3\1\3'\5\2\0005\6\3\0=\1\4\0063\a\5\0B\3\4\1-\3\1\0009\3\6\3\18\5\0\0\18\6\1\0B\3\3\1K\0\1\0\3¿\0¿\vattach\0\vbuffer\1\0\0\vsilent\ngroup\24 this is a string:?–\1\0\0\b\0\b\2!6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2Ã\1\0\0\b\0\b\2 6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\t\1\0\0X\2\21Ä6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2X\3\3Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2C\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequire¶\3\0\2\n\0\18\0#6\2\0\0'\4\1\0B\2\2\0029\2\2\0025\4\3\0B\2\2\2\18\4\0\0\18\5\1\0B\2\3\0026\3\4\0009\3\5\0039\5\6\2'\6\a\0005\a\b\0B\3\4\0025\4\t\0009\5\n\0009\5\v\0058\4\5\0046\5\f\0009\5\r\5'\a\14\0:\b\1\3B\5\3\2=\5\6\0026\5\f\0009\5\r\5'\a\16\0\f\b\4\0X\b\1Ä'\b\17\0:\t\2\3B\5\4\2=\5\15\2L\2\2\0\15NOT LISTED\t%s%s\tmenu\n %s  \vformat\vstring\tname\vsource\1\0\t\vbuffer\v  BUF \fluasnip\v SNIP \rnvim_lsp\v  LSP \tpath\v PATH \15treesitter\v TREE \rnvim_lua\v  LUA \nspell\v  CHK \nemoji\v EMOJ \tcalc\v CALC \1\0\1\14trimempty\2\a%s\tkind\nsplit\bvim\1\0\2\rmaxwidth\3\30\tmode\16symbol_text\15cmp_format\flspkind\frequire–\1\0\1\5\2\b\0\26-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\tÄ-\1\0\0009\1\1\0015\3\4\0-\4\0\0009\4\2\0049\4\3\4=\4\5\3B\1\2\1X\1\vÄ-\1\1\0009\1\6\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\a\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\a¿\b¿\19expand_or_jump\23expand_or_jumpable\rbehavior\1\0\0\vInsert\19SelectBehavior\21select_next_item\fvisibleƒ\1\0\1\5\2\b\0\28-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\tÄ-\1\0\0009\1\1\0015\3\4\0-\4\0\0009\4\2\0049\4\3\4=\4\5\3B\1\2\1X\1\rÄ-\1\1\0009\1\6\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\a\1)\3ˇˇB\1\2\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\a¿\b¿\tjump\rjumpable\rbehavior\1\0\0\vInsert\19SelectBehavior\21select_prev_item\fvisible›\1\0\0\4\0\v\0\0266\0\0\0009\0\1\0009\0\2\0B\0\1\0029\0\3\0\a\0\4\0X\0\2Ä+\0\1\0L\0\2\0006\0\5\0'\2\6\0B\0\2\0029\1\a\0'\3\b\0B\1\2\2\14\0\1\0X\2\5Ä9\1\t\0'\3\n\0B\1\2\2\15\0\1\0X\2\2Ä+\1\1\0L\1\2\0+\1\2\0L\1\2\0\fComment\20in_syntax_group\fcomment\26in_treesitter_capture\23cmp.config.context\frequire\6c\tmode\18nvim_get_mode\bapi\bvimÖ\1\0\1\6\2\6\0\0186\1\0\0009\1\1\1'\3\2\0-\4\0\0-\5\1\0008\5\0\5\14\0\5\0X\6\1Ä4\5\0\0B\1\4\0026\2\3\0'\4\4\0B\2\2\0028\2\0\0029\2\5\2\18\4\1\0B\2\2\1K\0\1\0\f¿\2¿\nsetup\14lspconfig\frequire\nforce\20tbl_deep_extend\bvim◊\19\1\0\19\0s\0œ\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\6\0006\3\4\0009\3\1\0039\3\5\3=\3\a\2B\0\2\0016\0\0\0'\2\b\0B\0\2\0029\0\2\0005\2\n\0006\3\4\0009\3\1\0039\3\t\3=\3\a\2B\0\2\0016\0\v\0\15\0\0\0X\1\4Ä6\0\f\0009\0\r\0'\2\14\0B\0\2\0016\0\0\0'\2\15\0B\0\2\0029\1\2\0005\3\17\0005\4\16\0=\4\18\3B\1\2\0016\1\f\0009\1\19\0016\3\20\0009\3\21\3'\4\22\0B\1\3\0026\2\23\0009\2\24\2\18\4\1\0'\5\25\0B\2\3\0016\2\23\0009\2\24\2\18\4\1\0'\5\26\0B\2\3\0015\2.\0005\3,\0005\4*\0005\5\28\0005\6\27\0=\1\21\6=\6\29\0055\6\31\0005\a\30\0=\a \6=\6!\0055\6%\0006\a\f\0009\a\"\a9\a#\a'\t$\0+\n\2\0B\a\3\2=\a&\6=\6'\0055\6(\0=\6)\5=\5+\4=\4-\3=\3/\0026\3\0\0'\0050\0B\3\2\0026\4\0\0'\0061\0B\4\2\0029\0042\0046\5\0\0'\a1\0B\5\2\0029\5\r\0053\0063\0006\a\0\0'\t4\0B\a\2\0026\b\0\0'\n5\0B\b\2\0023\t6\0003\n7\0009\v\2\a5\r8\0005\14:\0003\0159\0=\15;\14=\14<\r5\14>\0005\15=\0=\15?\0143\15@\0=\15A\14=\14B\r5\14D\0005\15C\0=\15E\14=\14F\r5\14J\0009\15G\a3\17H\0005\18I\0B\15\3\2=\15K\0149\15G\a3\17L\0005\18M\0B\15\3\2=\15N\0149\15G\a9\15O\0155\17R\0009\18P\a9\18Q\18=\18S\17B\15\2\2=\15T\14=\14G\r3\14U\0=\14V\r9\14W\a9\14X\0144\16\5\0005\17Y\0>\17\1\0165\17Z\0>\17\2\0165\17[\0>\17\3\0165\17\\\0>\17\4\0164\17\3\0005\18]\0>\18\1\0175\18^\0>\18\2\17B\14\3\2=\14X\rB\v\2\0016\v\0\0'\r_\0B\v\2\0029\v`\v6\r\f\0009\r\5\r9\ra\r9\rb\rB\r\1\0A\v\0\0025\fc\0=\6d\f5\re\0=\rf\f=\vg\f6\r\0\0'\15\3\0B\r\2\0029\rh\r4\15\3\0003\16i\0>\16\1\15B\r\2\0016\r\f\0009\r2\r9\rj\r'\15k\0005\16l\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15m\0005\16n\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15o\0005\16p\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15q\0005\16r\0B\r\3\0012\0\0ÄK\0\1\0\1\0\2\ttext\tÔÑß \vtexthl\23DiagnosticSignHint\23DiagnosticSignHint\1\0\2\ttext\tÔÑ© \vtexthl\23DiagnosticSignInfo\23DiagnosticSignInfo\1\0\2\ttext\tÔÅ± \vtexthl\23DiagnosticSignWarn\23DiagnosticSignWarn\1\0\2\ttext\tÔ≤Ö \vtexthl\24DiagnosticSignError\24DiagnosticSignError\16sign_define\0\19setup_handlers\17capabilities\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\29make_client_capabilities\rprotocol\24update_capabilities\17cmp_nvim_lsp\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\2\tname\nspell\rpriority\3a\1\0\2\tname\28nvim_lsp_signature_help\rpriority\3b\1\0\2\tname\rnvim_lsp\rpriority\3c\1\0\2\tname\fluasnip\rpriority\3d\fsources\vconfig\fenabled\0\14<C-Space>\rbehavior\1\0\1\vselect\2\vInsert\20ConfirmBehavior\fconfirm\f<S-Tab>\1\4\0\0\6i\6s\6c\0\n<Tab>\1\0\0\1\4\0\0\6i\6s\6c\0\fmapping\vwindow\15completion\1\0\0\1\0\3\17side_padding\3\0\17winhighlight/Normal:Pmenu,FloatBorder:Pmenu,Search:None\15col_offset\3\0\15formatting\vformat\0\vfields\1\0\0\1\4\0\0\tkind\tabbr\tmenu\fsnippet\vexpand\1\0\0\0\1\0\1\15min_length\3\1\0\0\fluasnip\bcmp\0\afn\17util.generic\tmapx\16sumneko_lua\1\0\0\rsettings\1\0\0\bLua\1\0\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\0\1\2\0\0\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\19lua/?/init.lua\14lua/?.lua\vinsert\ntable\6;\tpath\fpackage\nsplit\nicons\1\0\1\14highlight\1\1\0\26\tFile\nÔúò  \vMethod\nÔö¶  \nClass\nÔ†ñ  \fPackage\nÓò§  \fBoolean\n‚ó©  \nEvent\nÔÉß  \vNumber\nÔ¢ü  \14Namespace\nÔ†ñ  \vString\nÔî´  \vModule\nÓò§  \rConstant\nÔ£æ  \rVariable\nÔö¶  \15EnumMember\nÔÖù  \rFunction\nÔûî  \vStruct\nÔ†ñ  \14Interface\tÔ©ó \nArray\nÔô©  \tNull\nÔ≥†  \rOperator\nÔöî  \tEnum\tÔ©ó \16Constructor\nÔê•  \vObject\nÔô®  \nField\nÓúñ  \bKey\nÔ†ä  \rProperty\nÓûõ  \18TypeParameter\nÔûÉ  \15nvim-navic\21MasonToolsUpdate\bcmd\bvim\21UPDATEHOOK_GUARD\1\0\2\17run_on_start\1\16auto_update\1\ntools\25mason-tool-installer\21ensure_installed\1\0\0\blsp\16PREFERENCES\20mason-lspconfig\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nò\1\0\1\5\0\b\0\r6\1\0\0009\1\1\0019\1\2\1'\3\3\0005\4\4\0B\1\3\0016\1\5\0'\3\6\0B\1\2\0029\1\a\1\18\3\0\0B\1\2\1K\0\1\0\ron_enter\16plug.notify\frequire\1\0\1\fpattern\25NvimNotificationOpen\tUser\23nvim_exec_autocmds\bapi\bvimd\0\1\5\0\5\0\a6\1\0\0009\1\1\0019\1\2\1'\3\3\0005\4\4\0B\1\3\1K\0\1\0\1\0\1\fpattern\26NvimNotificationClose\tUser\23nvim_exec_autocmds\bapi\bvim¢\1\1\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0003\4\4\0=\4\5\0033\4\6\0=\4\a\3B\1\2\0016\1\b\0=\0\1\1K\0\1\0\bvim\ron_close\0\fon_open\0\1\0\4\vstages\tfade\bfps\3ê\1\22background_colour\f#000000\ftimeout\3ƒ\19\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nÄ\a\0\0\b\0&\0;6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\5\0005\5\4\0=\5\6\4=\4\a\0035\4\b\0005\5\t\0004\6\18\0005\a\n\0>\a\1\0065\a\v\0>\a\2\0065\a\f\0>\a\3\0065\a\r\0>\a\4\0065\a\14\0>\a\5\0065\a\15\0>\a\6\0065\a\16\0>\a\a\0065\a\17\0>\a\b\0065\a\18\0>\a\t\0065\a\19\0>\a\n\0065\a\20\0>\a\v\0065\a\21\0>\a\f\0065\a\22\0>\a\r\0065\a\23\0>\a\14\0065\a\24\0>\a\15\0065\a\25\0>\a\16\0065\a\26\0>\a\17\6=\6\27\5=\5\28\4=\4\29\0035\4#\0005\5\30\0005\6 \0005\a\31\0=\a!\6=\6\"\5=\5$\4=\4%\3B\1\2\1K\0\1\0\rrenderer\nicons\1\0\0\vglyphs\vfolder\1\0\0\1\0\2\fdefault\bÔÅª\topen\bÔÑî\1\0\2\18webdev_colors\1\fpadding\a  \tview\rmappings\tlist\1\0\2\bkey\6Y\vaction\14copy_path\1\0\2\bkey\6y\vaction\14copy_name\1\0\2\bkey\6$\vaction\17last_sibling\1\0\2\bkey\0061\vaction\18first_sibling\1\0\2\bkey\6o\vaction\tedit\1\0\2\bkey\6p\vaction\fpreview\1\0\2\bkey\6R\vaction\frefresh\1\0\2\bkey\6C\vaction\15expand_all\1\0\2\bkey\6c\vaction\17collapse_all\1\0\2\bkey\6q\vaction\nclose\1\0\2\bkey\6n\vaction\vcreate\1\0\2\bkey\add\vaction\vremove\1\0\2\bkey\6r\vaction\vrename\1\0\2\bkey\6<\vaction\vdir_up\1\0\2\bkey\6>\vaction\acd\1\0\2\bkey\6l\vaction\tedit\1\0\2\bkey\6h\vaction\15close_node\1\0\1\16custom_only\1\1\0\3\15signcolumn\ano\18adaptive_size\1\nwidth\3(\ffilters\vcustom\1\0\0\1\2\0\0\v^.git$\1\0\1\19remove_keymaps\2\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nË\1\0\0\18\0\n\1&4\0\0\0006\1\0\0009\1\1\0019\1\2\0019\1\3\0016\2\4\0'\4\5\0B\2\2\0029\2\6\2\18\4\1\0B\2\2\2)\3\a\0006\4\4\0'\6\5\0B\4\2\0029\4\a\4\30\5\0\3)\6\1\0\23\a\0\3)\b\1\0M\6\vÄ6\n\b\0009\n\t\n\18\f\0\0\18\r\4\0\18\15\2\0\18\16\1\0\23\17\0\t\"\17\17\5B\r\4\0A\n\1\1O\6ı\1276\6\b\0009\6\t\6\18\b\0\0\18\t\2\0B\6\3\1L\0\2\0\vinsert\ntable\bmix\vinvert\15util.color\frequire\nfocus\ai3\fpalette\16PREFERENCES\2‘\2\1\0\5\0\17\0\0256\0\0\0\15\0\0\0X\1\1Ä2\0\20Ä3\0\1\0B\0\1\0026\1\2\0'\3\3\0B\1\2\0029\1\4\0015\3\6\0005\4\5\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\0\r\4=\4\14\0035\4\15\0=\4\16\3B\1\2\1K\0\1\0K\0\1\0\fmatchup\1\0\1\venable\2\frainbow\vcolors\1\0\3\18extended_mode\2\19max_file_lines\3Ë\a\venable\2\vindent\1\0\1\venable\1\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\b\0\0\6c\blua\tjson\thtml\vpython\fc_sharp\nlatex\nsetup\28nvim-treesitter.configs\frequire\0\20BOOTSTRAP_GUARD\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["readline.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/readline.nvim",
    url = "https://github.com/linty-org/readline.nvim"
  },
  ["smart-splits.nvim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/smart-splits.nvim",
    url = "https://github.com/mrjones2014/smart-splits.nvim"
  },
  sniprun = {
    commands = { "SnipRun" },
    config = { "\27LJ\2\n∫\1\0\0\4\0\n\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\2B\0\2\1K\0\1\0\19show_no_output\1\2\0\0\15NvimNotify\20display_options\1\0\1\25notification_timeout\3\3\fdisplay\1\0\0\1\3\0\0\18VirtualTextOk\bApi\nsetup\fsniprun\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/sniprun",
    url = "https://github.com/michaelb/sniprun"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["suda.vim"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/suda.vim",
    url = "https://github.com/lambdalisue/suda.vim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim"
  },
  ["telescope-software-licenses.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/telescope-software-licenses.nvim",
    url = "https://github.com/chip/telescope-software-licenses.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    commands = { "Telescope", "TSFindFiles" },
    config = { "\27LJ\2\ny\0\0\6\1\a\0\v6\0\0\0009\0\1\0006\2\2\0009\2\3\2'\4\4\0-\5\0\0B\2\3\2'\3\5\0005\4\6\0B\0\4\1K\0\1\0\0¿\1\0\1\vrender\fminimal\twarn\24Key %s is disabled!\vformat\vstring\vnotify\bvim\20\1\1\2\0\1\0\0033\1\0\0002\0\0ÄL\1\2\0\0z\0\0\b\2\6\0\r-\0\0\0'\2\0\0'\3\1\0-\4\1\0006\6\2\0009\6\3\0069\6\4\6B\6\1\2'\a\5\0&\6\a\6B\4\2\0A\0\2\1K\0\1\0\n¿\t¿\20/.telescope.lua\vgetcwd\afn\bvim\15find_files\22telescope.builtin˙\23\1\0\17\0}\1Ù\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0\18\1\0\0'\3\3\0B\1\2\1\18\1\0\0'\3\4\0B\1\2\1\18\1\0\0'\3\5\0B\1\2\0016\1\0\0'\3\6\0B\1\2\0026\2\0\0'\4\a\0B\2\2\0023\3\b\0006\4\0\0'\6\t\0B\4\2\0025\5/\0005\6\v\0009\a\n\2=\a\f\0069\a\r\2=\a\14\0069\a\15\2=\a\16\0069\a\17\2=\a\18\0069\a\19\2=\a\20\0069\a\21\2=\a\22\0069\a\23\2=\a\24\0069\a\25\2=\a\26\0069\a\27\2=\a\28\0069\a\15\2=\a\29\6\18\a\3\0'\t\30\0B\a\2\2=\a\30\6\18\a\3\0'\t\31\0B\a\2\2=\a\31\6\18\a\3\0'\t \0B\a\2\2=\a \6\18\a\3\0'\t!\0B\a\2\2=\a!\6\18\a\3\0'\t\"\0B\a\2\2=\a\"\6\18\a\3\0'\t#\0B\a\2\2=\a#\6\18\a\3\0'\t$\0B\a\2\2=\a$\6\18\a\3\0'\t%\0B\a\2\2=\a%\0069\a&\4=\a'\0069\a(\4=\a)\0069\a*\4=\a+\0069\a,\4=\a-\6\18\a\3\0'\t$\0B\a\2\2=\a.\6=\0060\0055\0061\0009\a\n\2=\a2\0069\a\r\2=\a3\0069\a\15\2=\a\16\0069\a\15\2=\a\20\0069\a\19\2=\a4\0069\a\21\2=\a5\0069\a\23\2=\a\24\0069\a\25\2=\a\26\0069\a\23\2=\a\30\0069\a\25\2=\a\31\0069\a\23\2=\a \0069\a\25\2=\a!\0069\a\27\2=\a6\0069\a\27\2=\a\28\6\18\a\3\0'\t#\0B\a\2\2=\a#\6\18\a\3\0'\t$\0B\a\2\2=\a$\6\18\a\3\0'\t%\0B\a\2\2=\a%\6\18\a\3\0'\t7\0B\a\2\2=\a7\6\18\a\3\0'\t8\0B\a\2\2=\a8\6\18\a\3\0'\t9\0B\a\2\2=\a9\6\18\a\3\0'\t+\0B\a\2\2=\a+\6\18\a\3\0'\t-\0B\a\2\2=\a-\6=\6:\0055\6;\0005\a<\0005\b=\0009\t>\0015\vM\0005\f@\0005\r?\0=\rA\f5\rB\0=\rC\f5\rE\0005\14D\0=\14F\r5\14G\0=\14H\r5\14I\0=\14J\r=\rK\f=\5L\f=\fN\v5\fP\0005\rO\0=\rQ\f5\rR\0=\bS\r=\aT\r=\rU\f5\rV\0=\bS\r=\6W\r=\rX\f5\rY\0=\rZ\f5\r[\0005\14\\\0=\14K\r=\r]\f5\r^\0=\5L\r=\r_\f=\f`\v6\f\0\0'\14a\0B\f\2\0029\fb\f=\fc\v5\fe\0005\rd\0=\rf\f4\r\3\0006\14\0\0'\16g\0B\14\2\0029\14h\0144\16\0\0B\14\2\0?\14\0\0=\ri\f5\rk\0005\14j\0=\14l\r=\rm\f5\rn\0=\bo\r=\rp\f=\fq\vB\t\2\0016\tr\0009\vs\1'\ff\0B\t\3\0016\tr\0009\vs\1'\fi\0B\t\3\0016\t\0\0'\vt\0B\t\2\0029\tu\t6\n\0\0'\fv\0B\n\2\0029\nw\n6\vx\0009\vy\v9\vz\v'\r{\0003\14|\0004\15\0\0B\v\4\0012\0\0ÄK\0\1\0\0\16TSFindFiles\29nvim_create_user_command\bapi\bvim\16reconfigure\19plug.telescope\rlodTable\17util.generic\19load_extension\npcall\15extensions\rfrecency\20ignore_patterns\1\0\2\19show_unindexed\2\16show_scores\2\16media_files\14filetypes\1\0\1\rfind_cmd\arg\1\b\0\0\bpng\twebp\bjpg\tjpeg\bpdf\bmp4\bttf\14ui-select\17get_dropdown\21telescope.themes\15fzy_native\1\0\0\1\0\2\25override_file_sorter\2\28override_generic_sorter\2\16file_sorter\19get_fuzzy_file\22telescope.sorters\fpickers\17file_browser\1\0\0\fbuiltin\1\0\1\nwidth\4\0ÄÄ¿˛\3\1\0\3\23include_extensions\2\14previewer\1\20layout_strategy\rvertical\30current_buffer_fuzzy_find\1\0\1\14previewer\1\14live_grep\22vimgrep_arguments\1\0\0\15find_files\17find_command\25file_ignore_patterns\1\0\0\fbuffers\1\0\0\1\0\1\18sort_lastused\2\rdefaults\1\0\0\rmappings\18layout_config\tflex\1\0\1\17flip_columns\3å\1\rvertical\1\0\2\nwidth\4ö≥ÊÃ\tô≥¶ˇ\3\vheight\4ÊÃô≥\6ÊÃπˇ\3\15horizontal\1\0\0\1\0\4\20prompt_position\vbottom\vheight\4≥ÊÃô\3≥Ê¨ˇ\3\nwidth\4≥ÊÃô\3≥Ê¨ˇ\3\18preview_width\4Õô≥Ê\fÃôìˇ\3\fset_env\1\0\1\14COLORTERM\14truecolor\16borderchars\1\0\5\20layout_strategy\tflex\20scroll_strategy\ncycle\17entry_prefix\a  \20selection_caret\n ÔÅî \18prompt_prefix\tÔê¢ \1\t\0\0\b‚îÄ\b‚îÇ\b‚îÄ\b‚îÇ\b‚ï≠\b‚ïÆ\b‚ïØ\b‚ï∞\nsetup\1&\0\0\n.git$\r.git[/\\]\fexe[/\\]\14build[/\\]\fbin[/\\]\fobj[/\\]\14rocks[/\\]\flib[/\\]\14fonts[/\\]\14share[/\\]\14spell[/\\]\r.bak[/\\]\14.swap[/\\]\22nlsp-settings[/\\]\24packer_compiled.lua\n.pdf$\v.docx$\n.xls$\n.zip$\n.rar$\n.tar$\b.o$\b.d$\f.class$\r.secret$\n.exe$\n.png$\n.jpg$\v.jpeg$\n.gif$\v.webp$\n.mp3$\n.wav$\v.flac$\n.mp4$\n.vlc$\n.mkv$\1\a\0\0\afd\r--hidden\16--no-ignore\v--type\6f\23--strip-cwd-prefix\1\v\0\0\arg\18--color=never\r--hidden\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\19--unrestricted\19--unrestricted\6n\b<L>\b<M>\b<H>\n<ESC>\6j\6k\6G\agg\1\0\0\6i\1\0\0\n<C-V>\f<S-Tab>\22beginning_of_line\n<Tab>\16end_of_line\n<C-l>\14kill_line\n<C-u>\23backward_kill_line\n<C-t>\n<C-v>\n<C-x>\n<C-n>\v<Down>\t<Up>\n<A-j>\n<A-k>\n<C-a>\n<C-q>\nclose\15<PageDown>\27preview_scrolling_down\r<PageUp>\25preview_scrolling_up\n<C-d>\24move_selection_next\n<C-e>\28move_selection_previous\t<CR>\19select_default\n<A-e>\14file_edit\f<C-S-g>\19move_to_bottom\n<C-g>\1\0\0\16move_to_top\rreadline\0\22telescope.actions\14telescope\29telescope-ui-select.nvim\30telescope-fzy-native.nvim%telescope-software-licenses.nvim\15loadPlugin\16util.packer\frequire\3ÄÄ¿ô\4\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nÎ\5\0\0\6\0\"\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2 \0005\3\6\0005\4\3\0005\5\4\0=\5\5\4=\4\a\0035\4\b\0005\5\t\0=\5\5\4=\4\n\0035\4\v\0005\5\f\0=\5\5\4=\4\r\0035\4\14\0005\5\15\0=\5\5\4=\4\16\0035\4\17\0005\5\18\0=\5\5\4=\4\19\0035\4\20\0005\5\21\0=\5\5\4=\4\22\0035\4\23\0005\5\24\0=\5\5\4=\4\25\0035\4\26\0005\5\27\0=\5\5\4=\4\28\0035\4\29\0005\5\30\0=\5\5\4=\4\31\3=\3!\2B\0\2\1K\0\1\0\rkeywords\1\0\0\vTHANKS\1\3\0\0\bTHX\bREF\1\0\2\ticon\tÔäµ \ncolor\f#FD5DBB\tTEST\1\2\0\0\rTESTCASE\1\0\2\ticon\tÔö¶ \ncolor\f#DBED00\tNOTE\1\4\0\0\tINFO\17EXPERIMENTAL\tN.B.\1\0\2\ticon\tÔÅ© \ncolor\f#FFFFFF\rOPTIMIZE\1\a\0\0\bAPI\fENHANCE\bOPT\nSPEED\16PERFORMANCE\vEXTEND\1\0\2\ticon\tÔê∫ \ncolor\f#179AFF\rDISABLED\1\4\0\0\tEXCL\nABORT\tTRAP\1\0\2\ticon\tÔÄç \ncolor\f#FD5D88\fWARNING\1\3\0\0\tWARN\nERROR\1\0\2\ticon\tÔÅ± \ncolor\f#DBED00\tHACK\1\2\0\0\bHAX\1\0\2\ticon\tÔÆè \ncolor\f#17FF7c\tTODO\1\4\0\0\20NOT_IMPLEMENTED\bWIP\21WORK_IN_PROGRESS\1\0\2\ticon\tÔ†î \ncolor\f#FFDF64\bFIX\1\0\0\balt\1\6\0\0\nFIXED\bBUG\nISSUE\nFIXME\nTOFIX\1\0\2\ticon\tÔÇ≠ \ncolor\f#FF9507\nsetup\18todo-comments\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "Trouble", "TroubleToggle" },
    config = { "\27LJ\2\nh\0\0\n\1\5\0\0146\0\0\0-\2\0\0B\0\2\4H\3\aÄ6\5\1\0009\5\2\0059\5\3\5\18\a\3\0'\b\4\0+\t\2\0B\5\4\1F\3\3\3R\3˜\127K\0\1\0\1¿\twrap\24nvim_win_set_option\bapi\bvim\npairs~\1\1\5\0\a\0\r6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\0026\2\4\0009\2\5\0023\4\6\0B\2\2\1+\2\2\0002\0\0ÄL\2\2\0\0\rschedule\bvim\bbuf getWindowsDisplayingBuffers\17util.windows\frequire¨\1\1\0\5\0\v\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\4\0009\0\5\0009\0\6\0005\2\a\0005\3\t\0003\4\b\0=\4\n\3B\0\3\1K\0\1\0\rcallback\1\0\0\0\1\2\0\0\16BufWinEnter\24nvim_create_autocmd\bapi\bvim\1\0\2\nwidth\3(\rposition\nright\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n„\2\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\3=\3\t\0025\3\n\0005\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\19popup_mappings\1\0\2\14scroll_up\r<PageUp>\16scroll_down\15<PageDown>\vlayout\vheight\1\0\2\bmax\3\20\bmin\3\2\nwidth\1\0\2\bmax\0032\bmin\3\n\1\0\2\fspacing\3\2\nalign\tleft\vwindow\fpadding\1\5\0\0\3\2\3\2\3\2\3\2\vmargin\1\5\0\0\3\1\3\0\3\1\3\0\1\0\3\rwinblend\3\0\rposition\btop\vborder\tnone\1\0\2\14registers\1\nmarks\1\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["wilder.nvim"] = {
    config = { "\27LJ\2\n¡\5\0\0\v\0\29\00206\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\4\0005\4\3\0=\4\5\3B\1\2\0014\1\3\0009\2\6\0B\2\1\2>\2\1\0019\2\a\0B\2\1\0?\2\0\0005\2\b\0009\3\t\0009\5\n\0005\a\v\0=\1\f\a=\2\r\a5\b\15\0009\t\14\0B\t\1\2>\t\1\b=\b\16\a4\b\3\0009\t\17\0B\t\1\0?\t\1\0=\b\18\aB\5\2\0A\3\0\0029\4\19\0005\6\20\0=\1\f\6B\4\2\0029\5\21\0'\a\22\0009\b\23\0005\n\24\0=\3\25\n=\4\26\n=\4\27\n=\4\28\nB\b\2\0A\5\1\1K\0\1\0\15substitute\6?\6/\6:\1\0\0\17renderer_mux\rrenderer\15set_option\1\0\0\22wildmenu_renderer\nright\24popupmenu_scrollbar\tleft\1\3\0\0\0\a  \23popupmenu_devicons\15highlights\16highlighter\1\0\4\15min_height\b30%\15max_height\b30%\20prompt_position\btop\vborder\vsingle\28popupmenu_palette_theme\23popupmenu_renderer\1\0\6\rselected\19WilderSelected\nerror\16WilderEmpty\18empty_message\16WilderEmpty\20selected_accent\25WilderSelectedAccent\vaccent\17WilderAccent\fdefault\15WilderMenu\24lua_fzy_highlighter\26lua_pcre2_highlighter\nmodes\1\0\0\1\4\0\0\6/\6?\6:\nsetup\vwilder\frequire\5ÄÄ¿ô\4\3ÄÄ¿ô\4\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/deatharte/.local/share/nvim/site/pack/packer/opt/wilder.nvim",
    url = "https://github.com/gelguy/wilder.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: heirline.nvim
time([[Config for heirline.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\a\0\5\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0006\2\3\0006\4\0\0'\6\4\0B\4\2\0A\2\0\0A\0\0\1K\0\1\0\18plug.heirline\vunpack\nsetup\rheirline\frequire\0", "config", "heirline.nvim")
time([[Config for heirline.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\n„\2\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\0035\4\a\0=\4\b\3=\3\t\0025\3\n\0005\4\v\0=\4\f\0035\4\r\0=\4\14\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\19popup_mappings\1\0\2\14scroll_up\r<PageUp>\16scroll_down\15<PageDown>\vlayout\vheight\1\0\2\bmax\3\20\bmin\3\2\nwidth\1\0\2\bmax\0032\bmin\3\n\1\0\2\fspacing\3\2\nalign\tleft\vwindow\fpadding\1\5\0\0\3\2\3\2\3\2\3\2\vmargin\1\5\0\0\3\1\3\0\3\1\3\0\1\0\3\rwinblend\3\0\rposition\btop\vborder\tnone\1\0\2\14registers\1\nmarks\1\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: nvim-lint
time([[Config for nvim-lint]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\rtry_lint\tlint\frequire±\1\1\0\5\0\r\0\0166\0\0\0'\2\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0005\2\t\0005\3\v\0003\4\n\0=\4\f\3B\0\3\1K\0\1\0\rcallback\1\0\0\0\1\2\0\0\17BufWritePost\24nvim_create_autocmd\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0", "config", "nvim-lint")
time([[Config for nvim-lint]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nò\1\0\1\5\0\b\0\r6\1\0\0009\1\1\0019\1\2\1'\3\3\0005\4\4\0B\1\3\0016\1\5\0'\3\6\0B\1\2\0029\1\a\1\18\3\0\0B\1\2\1K\0\1\0\ron_enter\16plug.notify\frequire\1\0\1\fpattern\25NvimNotificationOpen\tUser\23nvim_exec_autocmds\bapi\bvimd\0\1\5\0\5\0\a6\1\0\0009\1\1\0019\1\2\1'\3\3\0005\4\4\0B\1\3\1K\0\1\0\1\0\1\fpattern\26NvimNotificationClose\tUser\23nvim_exec_autocmds\bapi\bvim¢\1\1\0\5\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0003\4\4\0=\4\5\0033\4\6\0=\4\a\3B\1\2\0016\1\b\0=\0\1\1K\0\1\0\bvim\ron_close\0\fon_open\0\1\0\4\vstages\tfade\bfps\3ê\1\22background_colour\f#000000\ftimeout\3ƒ\19\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: nvim-gomove
time([[Config for nvim-gomove]], true)
try_loadstring("\27LJ\2\np\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\4\17map_defaults\1\rundojoin\2\rreindent\1\22move_past_end_col\2\nsetup\vgomove\frequire\0", "config", "nvim-gomove")
time([[Config for nvim-gomove]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\2\nj\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\20show_cursorline\1\21centered_peeking\2\17show_numbers\2\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: icon-picker.nvim
time([[Config for icon-picker.nvim]], true)
try_loadstring("\27LJ\2\nY\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\28disable_legacy_commands\2\nsetup\16icon-picker\frequire\0", "config", "icon-picker.nvim")
time([[Config for icon-picker.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0v\1\2\b\2\a\0\14'\2\0\0-\3\0\0009\3\1\3'\5\2\0005\6\3\0=\1\4\0063\a\5\0B\3\4\1-\3\1\0009\3\6\3\18\5\0\0\18\6\1\0B\3\3\1K\0\1\0\3¿\0¿\vattach\0\vbuffer\1\0\0\vsilent\ngroup\24 this is a string:?–\1\0\0\b\0\b\2!6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2Ã\1\0\0\b\0\b\2 6\0\0\0006\2\1\0009\2\2\0029\2\3\2)\4\0\0B\2\2\0A\0\0\3\t\1\0\0X\2\21Ä6\2\1\0009\2\2\0029\2\4\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\5\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\6\2'\5\a\0B\2\3\2X\3\3Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\vunpack\0\2C\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequire¶\3\0\2\n\0\18\0#6\2\0\0'\4\1\0B\2\2\0029\2\2\0025\4\3\0B\2\2\2\18\4\0\0\18\5\1\0B\2\3\0026\3\4\0009\3\5\0039\5\6\2'\6\a\0005\a\b\0B\3\4\0025\4\t\0009\5\n\0009\5\v\0058\4\5\0046\5\f\0009\5\r\5'\a\14\0:\b\1\3B\5\3\2=\5\6\0026\5\f\0009\5\r\5'\a\16\0\f\b\4\0X\b\1Ä'\b\17\0:\t\2\3B\5\4\2=\5\15\2L\2\2\0\15NOT LISTED\t%s%s\tmenu\n %s  \vformat\vstring\tname\vsource\1\0\t\vbuffer\v  BUF \fluasnip\v SNIP \rnvim_lsp\v  LSP \tpath\v PATH \15treesitter\v TREE \rnvim_lua\v  LUA \nspell\v  CHK \nemoji\v EMOJ \tcalc\v CALC \1\0\1\14trimempty\2\a%s\tkind\nsplit\bvim\1\0\2\rmaxwidth\3\30\tmode\16symbol_text\15cmp_format\flspkind\frequire–\1\0\1\5\2\b\0\26-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\tÄ-\1\0\0009\1\1\0015\3\4\0-\4\0\0009\4\2\0049\4\3\4=\4\5\3B\1\2\1X\1\vÄ-\1\1\0009\1\6\1B\1\1\2\15\0\1\0X\2\4Ä-\1\1\0009\1\a\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\a¿\b¿\19expand_or_jump\23expand_or_jumpable\rbehavior\1\0\0\vInsert\19SelectBehavior\21select_next_item\fvisibleƒ\1\0\1\5\2\b\0\28-\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\tÄ-\1\0\0009\1\1\0015\3\4\0-\4\0\0009\4\2\0049\4\3\4=\4\5\3B\1\2\1X\1\rÄ-\1\1\0009\1\6\1)\3ˇˇB\1\2\2\15\0\1\0X\2\5Ä-\1\1\0009\1\a\1)\3ˇˇB\1\2\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\a¿\b¿\tjump\rjumpable\rbehavior\1\0\0\vInsert\19SelectBehavior\21select_prev_item\fvisible›\1\0\0\4\0\v\0\0266\0\0\0009\0\1\0009\0\2\0B\0\1\0029\0\3\0\a\0\4\0X\0\2Ä+\0\1\0L\0\2\0006\0\5\0'\2\6\0B\0\2\0029\1\a\0'\3\b\0B\1\2\2\14\0\1\0X\2\5Ä9\1\t\0'\3\n\0B\1\2\2\15\0\1\0X\2\2Ä+\1\1\0L\1\2\0+\1\2\0L\1\2\0\fComment\20in_syntax_group\fcomment\26in_treesitter_capture\23cmp.config.context\frequire\6c\tmode\18nvim_get_mode\bapi\bvimÖ\1\0\1\6\2\6\0\0186\1\0\0009\1\1\1'\3\2\0-\4\0\0-\5\1\0008\5\0\5\14\0\5\0X\6\1Ä4\5\0\0B\1\4\0026\2\3\0'\4\4\0B\2\2\0028\2\0\0029\2\5\2\18\4\1\0B\2\2\1K\0\1\0\f¿\2¿\nsetup\14lspconfig\frequire\nforce\20tbl_deep_extend\bvim◊\19\1\0\19\0s\0œ\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0005\2\6\0006\3\4\0009\3\1\0039\3\5\3=\3\a\2B\0\2\0016\0\0\0'\2\b\0B\0\2\0029\0\2\0005\2\n\0006\3\4\0009\3\1\0039\3\t\3=\3\a\2B\0\2\0016\0\v\0\15\0\0\0X\1\4Ä6\0\f\0009\0\r\0'\2\14\0B\0\2\0016\0\0\0'\2\15\0B\0\2\0029\1\2\0005\3\17\0005\4\16\0=\4\18\3B\1\2\0016\1\f\0009\1\19\0016\3\20\0009\3\21\3'\4\22\0B\1\3\0026\2\23\0009\2\24\2\18\4\1\0'\5\25\0B\2\3\0016\2\23\0009\2\24\2\18\4\1\0'\5\26\0B\2\3\0015\2.\0005\3,\0005\4*\0005\5\28\0005\6\27\0=\1\21\6=\6\29\0055\6\31\0005\a\30\0=\a \6=\6!\0055\6%\0006\a\f\0009\a\"\a9\a#\a'\t$\0+\n\2\0B\a\3\2=\a&\6=\6'\0055\6(\0=\6)\5=\5+\4=\4-\3=\3/\0026\3\0\0'\0050\0B\3\2\0026\4\0\0'\0061\0B\4\2\0029\0042\0046\5\0\0'\a1\0B\5\2\0029\5\r\0053\0063\0006\a\0\0'\t4\0B\a\2\0026\b\0\0'\n5\0B\b\2\0023\t6\0003\n7\0009\v\2\a5\r8\0005\14:\0003\0159\0=\15;\14=\14<\r5\14>\0005\15=\0=\15?\0143\15@\0=\15A\14=\14B\r5\14D\0005\15C\0=\15E\14=\14F\r5\14J\0009\15G\a3\17H\0005\18I\0B\15\3\2=\15K\0149\15G\a3\17L\0005\18M\0B\15\3\2=\15N\0149\15G\a9\15O\0155\17R\0009\18P\a9\18Q\18=\18S\17B\15\2\2=\15T\14=\14G\r3\14U\0=\14V\r9\14W\a9\14X\0144\16\5\0005\17Y\0>\17\1\0165\17Z\0>\17\2\0165\17[\0>\17\3\0165\17\\\0>\17\4\0164\17\3\0005\18]\0>\18\1\0175\18^\0>\18\2\17B\14\3\2=\14X\rB\v\2\0016\v\0\0'\r_\0B\v\2\0029\v`\v6\r\f\0009\r\5\r9\ra\r9\rb\rB\r\1\0A\v\0\0025\fc\0=\6d\f5\re\0=\rf\f=\vg\f6\r\0\0'\15\3\0B\r\2\0029\rh\r4\15\3\0003\16i\0>\16\1\15B\r\2\0016\r\f\0009\r2\r9\rj\r'\15k\0005\16l\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15m\0005\16n\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15o\0005\16p\0B\r\3\0016\r\f\0009\r2\r9\rj\r'\15q\0005\16r\0B\r\3\0012\0\0ÄK\0\1\0\1\0\2\ttext\tÔÑß \vtexthl\23DiagnosticSignHint\23DiagnosticSignHint\1\0\2\ttext\tÔÑ© \vtexthl\23DiagnosticSignInfo\23DiagnosticSignInfo\1\0\2\ttext\tÔÅ± \vtexthl\23DiagnosticSignWarn\23DiagnosticSignWarn\1\0\2\ttext\tÔ≤Ö \vtexthl\24DiagnosticSignError\24DiagnosticSignError\16sign_define\0\19setup_handlers\17capabilities\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\29make_client_capabilities\rprotocol\24update_capabilities\17cmp_nvim_lsp\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\2\tname\nspell\rpriority\3a\1\0\2\tname\28nvim_lsp_signature_help\rpriority\3b\1\0\2\tname\rnvim_lsp\rpriority\3c\1\0\2\tname\fluasnip\rpriority\3d\fsources\vconfig\fenabled\0\14<C-Space>\rbehavior\1\0\1\vselect\2\vInsert\20ConfirmBehavior\fconfirm\f<S-Tab>\1\4\0\0\6i\6s\6c\0\n<Tab>\1\0\0\1\4\0\0\6i\6s\6c\0\fmapping\vwindow\15completion\1\0\0\1\0\3\17side_padding\3\0\17winhighlight/Normal:Pmenu,FloatBorder:Pmenu,Search:None\15col_offset\3\0\15formatting\vformat\0\vfields\1\0\0\1\4\0\0\tkind\tabbr\tmenu\fsnippet\vexpand\1\0\0\0\1\0\1\15min_length\3\1\0\0\fluasnip\bcmp\0\afn\17util.generic\tmapx\16sumneko_lua\1\0\0\rsettings\1\0\0\bLua\1\0\0\14telemetry\1\0\1\venable\1\14workspace\flibrary\1\0\0\5\26nvim_get_runtime_file\bapi\16diagnostics\fglobals\1\0\0\1\2\0\0\bvim\fruntime\1\0\0\1\0\1\fversion\vLuaJIT\19lua/?/init.lua\14lua/?.lua\vinsert\ntable\6;\tpath\fpackage\nsplit\nicons\1\0\1\14highlight\1\1\0\26\tFile\nÔúò  \vMethod\nÔö¶  \nClass\nÔ†ñ  \fPackage\nÓò§  \fBoolean\n‚ó©  \nEvent\nÔÉß  \vNumber\nÔ¢ü  \14Namespace\nÔ†ñ  \vString\nÔî´  \vModule\nÓò§  \rConstant\nÔ£æ  \rVariable\nÔö¶  \15EnumMember\nÔÖù  \rFunction\nÔûî  \vStruct\nÔ†ñ  \14Interface\tÔ©ó \nArray\nÔô©  \tNull\nÔ≥†  \rOperator\nÔöî  \tEnum\tÔ©ó \16Constructor\nÔê•  \vObject\nÔô®  \nField\nÓúñ  \bKey\nÔ†ä  \rProperty\nÓûõ  \18TypeParameter\nÔûÉ  \15nvim-navic\21MasonToolsUpdate\bcmd\bvim\21UPDATEHOOK_GUARD\1\0\2\17run_on_start\1\16auto_update\1\ntools\25mason-tool-installer\21ensure_installed\1\0\0\blsp\16PREFERENCES\20mason-lspconfig\nsetup\nmason\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: mapx.nvim
time([[Config for mapx.nvim]], true)
try_loadstring("\27LJ\2\nÑ\1\0\0\6\0\b\0\0146\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0006\3\0\0'\5\3\0B\3\2\0029\3\4\3'\5\5\0B\3\2\2=\3\a\2B\0\2\1K\0\1\0\rwhichkey\1\0\0\19which-key.nvim\15loadPlugin\16util.packer\nsetup\tmapx\frequire\0", "config", "mapx.nvim")
time([[Config for mapx.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: nvim-highlight-colors
time([[Config for nvim-highlight-colors]], true)
try_loadstring("\27LJ\2\n\\\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\vrender\15background\nsetup\26nvim-highlight-colors\frequire\0", "config", "nvim-highlight-colors")
time([[Config for nvim-highlight-colors]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\nÄ\a\0\0\b\0&\0;6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\3\0005\4\5\0005\5\4\0=\5\6\4=\4\a\0035\4\b\0005\5\t\0004\6\18\0005\a\n\0>\a\1\0065\a\v\0>\a\2\0065\a\f\0>\a\3\0065\a\r\0>\a\4\0065\a\14\0>\a\5\0065\a\15\0>\a\6\0065\a\16\0>\a\a\0065\a\17\0>\a\b\0065\a\18\0>\a\t\0065\a\19\0>\a\n\0065\a\20\0>\a\v\0065\a\21\0>\a\f\0065\a\22\0>\a\r\0065\a\23\0>\a\14\0065\a\24\0>\a\15\0065\a\25\0>\a\16\0065\a\26\0>\a\17\6=\6\27\5=\5\28\4=\4\29\0035\4#\0005\5\30\0005\6 \0005\a\31\0=\a!\6=\6\"\5=\5$\4=\4%\3B\1\2\1K\0\1\0\rrenderer\nicons\1\0\0\vglyphs\vfolder\1\0\0\1\0\2\fdefault\bÔÅª\topen\bÔÑî\1\0\2\18webdev_colors\1\fpadding\a  \tview\rmappings\tlist\1\0\2\bkey\6Y\vaction\14copy_path\1\0\2\bkey\6y\vaction\14copy_name\1\0\2\bkey\6$\vaction\17last_sibling\1\0\2\bkey\0061\vaction\18first_sibling\1\0\2\bkey\6o\vaction\tedit\1\0\2\bkey\6p\vaction\fpreview\1\0\2\bkey\6R\vaction\frefresh\1\0\2\bkey\6C\vaction\15expand_all\1\0\2\bkey\6c\vaction\17collapse_all\1\0\2\bkey\6q\vaction\nclose\1\0\2\bkey\6n\vaction\vcreate\1\0\2\bkey\add\vaction\vremove\1\0\2\bkey\6r\vaction\vrename\1\0\2\bkey\6<\vaction\vdir_up\1\0\2\bkey\6>\vaction\acd\1\0\2\bkey\6l\vaction\tedit\1\0\2\bkey\6h\vaction\15close_node\1\0\1\16custom_only\1\1\0\3\15signcolumn\ano\18adaptive_size\1\nwidth\3(\ffilters\vcustom\1\0\0\1\2\0\0\v^.git$\1\0\1\19remove_keymaps\2\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
try_loadstring("\27LJ\2\n_\0\1\4\1\4\0\n-\1\0\0\14\0\1\0X\1\6Ä6\1\0\0'\3\1\0B\1\2\0029\1\2\1'\3\3\0B\1\2\1K\0\1\0\0¿\19telescope.nvim\15loadPlugin\16util.packer\frequireÎ\1\1\0\6\0\14\0\19+\0\1\0006\1\0\0'\3\1\0B\1\2\0029\1\2\0015\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\0035\4\v\0003\5\n\0=\5\f\4=\4\r\3B\1\2\0012\0\0ÄK\0\1\0\vselect\15get_config\1\0\0\0\ninput\1\0\0\14max_width\1\3\0\0\3(\4ö≥ÊÃ\tô≥Ê˛\3\14min_width\1\3\0\0\3(\4ö≥ÊÃ\tô≥Ê˛\3\1\0\3\rwinblend\3\30\vborder\vsingle\rrelative\veditor\nsetup\rdressing\frequire\0", "config", "dressing.nvim")
time([[Config for dressing.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nË\1\0\0\18\0\n\1&4\0\0\0006\1\0\0009\1\1\0019\1\2\0019\1\3\0016\2\4\0'\4\5\0B\2\2\0029\2\6\2\18\4\1\0B\2\2\2)\3\a\0006\4\4\0'\6\5\0B\4\2\0029\4\a\4\30\5\0\3)\6\1\0\23\a\0\3)\b\1\0M\6\vÄ6\n\b\0009\n\t\n\18\f\0\0\18\r\4\0\18\15\2\0\18\16\1\0\23\17\0\t\"\17\17\5B\r\4\0A\n\1\1O\6ı\1276\6\b\0009\6\t\6\18\b\0\0\18\t\2\0B\6\3\1L\0\2\0\vinsert\ntable\bmix\vinvert\15util.color\frequire\nfocus\ai3\fpalette\16PREFERENCES\2‘\2\1\0\5\0\17\0\0256\0\0\0\15\0\0\0X\1\1Ä2\0\20Ä3\0\1\0B\0\1\0026\1\2\0'\3\3\0B\1\2\0029\1\4\0015\3\6\0005\4\5\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\0\r\4=\4\14\0035\4\15\0=\4\16\3B\1\2\1K\0\1\0K\0\1\0\fmatchup\1\0\1\venable\2\frainbow\vcolors\1\0\3\18extended_mode\2\19max_file_lines\3Ë\a\venable\2\vindent\1\0\1\venable\1\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\b\0\0\6c\blua\tjson\thtml\vpython\fc_sharp\nlatex\nsetup\28nvim-treesitter.configs\frequire\0\20BOOTSTRAP_GUARD\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file JABSOpen lua require("packer.load")({'JABS.nvim'}, { cmd = "JABSOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSFindFiles lua require("packer.load")({'telescope.nvim'}, { cmd = "TSFindFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TroubleToggle lua require("packer.load")({'trouble.nvim'}, { cmd = "TroubleToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SnipRun lua require("packer.load")({'sniprun'}, { cmd = "SnipRun", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufRead * ++once lua require("packer.load")({'lightspeed.nvim', 'todo-comments.nvim'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au BufWritePre * ++once lua require("packer.load")({'formatter.nvim'}, { event = "BufWritePre *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'gitsigns.nvim', 'harpoon', 'indent-blankline.nvim', 'nvim-autopairs', 'Comment.nvim', 'cool-substitute.nvim', 'nvim-surround'}, { event = "BufEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CmdlineEnter * ++once lua require("packer.load")({'wilder.nvim'}, { event = "CmdlineEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
