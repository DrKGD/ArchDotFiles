# Deatharte's Neovim configuration 

## Priorities
- Speed, has to behave like vanilla nvim while writing.
- Accustomed to my preferences.
- Lots of plugins, lazily-loaded for greater startup speed.
- Easy 'profile-based' customizability via the ./lua/setup/profile.lua file
	- Plugins are the same, configuration may differ!
- `Plug and Edit`: installation should be as easy as cloning this repo.
- Reload-ready: bind `launch.sh` to system aliases, edit configuration, reload nvim with `:DDRestart` or `:DDKeep`
- i3 centric configuration, thus meaning the configuration was written with tiling window managers in mind.

## Overview of plugins
### Colorschemes
Located at `./lua/setup/pkgs/colorschemes.grp.lua`, they are not loaded on startup, as
there is a hook which takes advantage of packer loader. 

### LSP
Language Server Protocol configuration is not complete yet, but:
- I do not use external linters.
- I do not really need any formatter.

Next, the lsp plugin list and a small description attached to them.
- nvim-lspconfig, LSP capabilities configurer for nvim.
- mason, mason-lspconfig, mason-tool-installer: GUI which lists and installs LSP, Linters, Formatters
and tools related to the LSP eco-system.
- nvim-cmp, as the completion engine, which is superloaded with its own family of plugins and its own architecture, check it out! If I were to suggest an alternative, I'd suggest COQ, which is more like a bundle working out of the box (with the premise of being faster and the requirement of pre-compiling languages beforehand). 
- LuaSnip, for snippets (integrated with nvim-cmp).
- nvim-lint, for external linters which are not LSP-ready: shellcheck (for bash scripting) is one of them, for example.
- Lspsaga, deep into the code.

WIP: these are not configured yet, thus are set optional.
- nvim-dap, for Debug Adapter(s). Tried to use it in the past, did not quite succeed. Will give it another run
asap.
- formatter, for formatters. I actually prefer to indent the code myself.

### GUIs
Lots of GUIs plugins were added, here's a quick overview.
- harpoon, to move between a subset of tracked (called harpooned) buffers.
- nvim-notify, popup notification instead of cmdline notifications! 
- dressing, like nvim-notify, extends input and select with ui instead! 
- icon-picker, to pick from a list of icons, emoji, symbols definitions.
- trouble, quick and painless list of Diagnostics and LSP definitions.
- Telescope, mostly to find files via name or content, even thought its use case is not limited to this.
- wilder, which gives command mode a good make-up.
- heirline, yet another statusline plugin. This time, it is an API for both statusline and winbar(s)!
- gitsigns, preview added/deleted/changed lines in a git codebase.
- indent-blankline, a non-intrusive tracker for indentation. 
- nvim-highlight-colors, highlight hexrgb colors directly in nvim. 
- nvim-tree, successor of NERDTree, does exactly the same thing but the API is entirely written in lua!
- JABS, exactly <ls!> piped to a buffer, thus allowing switching to a buffer by its name.
- todo-comments, define and use labels through to code as a reminder (mostly)
- Hydra, menu with bindings, a good replacement when whichkey is not enough.
- Treesitter, essentially what makes nvim so great, thus adding a virtual tree of scopes. Enhances everything, from functionalities (e.g. rainbow parenthesis), to colorschemes.

### Fundamentals
- Packer, package manager written in lua that enables lazyload.
- Mapx, integrates with whichkey, helper in keybinding definition
- Comment, NERDCommenter but up-to-date with nvim.
- Lightspeed, jump from line to line within (milli)seconds!
- Nvim-surround, add/change/delete surrounds in a flash. 
