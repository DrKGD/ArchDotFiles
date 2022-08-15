if BOOTSTRAP_GUARD then
	return end

-------------------------------------
-- Arming keybidings               --
-------------------------------------
(function()
	local m						= require('mapx')
	local cmd					= require('util.generic').cmd
	local readline		= require('readline')
	local hasPlugin		= require('util.packer').hasPlugin

	-- Control Movement in Command line
	m.cnoremap("<C-X>",			readline.kill_word)
	m.cnoremap("<C-H>", 		readline.backward_kill_word)
	m.cnoremap("<C-U>", 		readline.backward_kill_line)
	m.cnoremap("<C-L>", 		readline.kill_line)
	m.cnoremap("<C-G>", 		readline.beginning_of_line)
	m.cnoremap("<C-E>", 		readline.end_of_line)
	m.cnoremap("<C-Left>",	readline.backward_word)
	m.cnoremap("<C-Right>", readline.forward_word)

	-- Delete buffer from memory without hesitation
	m.noremap('<leader>q', cmd 'Bwipeout')

	-- Control Movement in Insert mode
	m.inoremap("<C-X>",			readline.kill_word)
	m.inoremap("<C-U>", 		readline.backward_kill_line)
	m.inoremap("<C-G>", 		readline.beginning_of_line)
	m.inoremap("<C-E>", 		readline.end_of_line)
	m.inoremap("<C-L>", 		readline.kill_line)
	m.inoremap("<C-Del>",		readline.kill_word)
	m.inoremap("<C-H>", 		readline.backward_kill_word)
	m.inoremap("<C-BS>", 		readline.backward_kill_word)

	-- 3Dmensional movement
	m.noremap("j", function() return vim.v.count > 0 and "j" or "gj" end, "silent", "expr")
	m.noremap("k", function() return vim.v.count > 0 and "k" or "gk" end, "silent", "expr")
	m.noremap("<C-e>", "5k")
	m.noremap("<C-d>", "5j");

	-- Harpoon
	m.noremap("{", function() require('harpoon.ui').nav_prev() end)
	m.noremap("<M-a>", function()
		require('harpoon.mark').add_file()
		vim.notify(string.format("<%s> harpooned!", vim.api.nvim_buf_get_name(0)), 'info', { render = 'minimal' })

	end) 
	m.noremap("\\", function() require('harpoon.ui').toggle_quick_menu() end)
	m.noremap("}", function() require('harpoon.ui').nav_next() end)

	-- Move between splits with arrows
	m.noremap("<Left>", cmd 'wincmd h')
	m.noremap("<Down>", cmd 'wincmd j')
	m.noremap("<Up>", cmd 'wincmd k')
	m.noremap("<Right>", cmd 'wincmd l');

	-- Same but with C-hjkl 
	m.noremap("<C-h>", cmd 'wincmd h')
	m.noremap("<C-j>", cmd 'wincmd j')
	m.noremap("<C-k>", cmd 'wincmd k')
	m.noremap("<C-l>", cmd 'wincmd l');

	-- Move lines around
	(function()
			if hasPlugin('nvim-gomove') then
				-- Can be repeated ntimes
				m.nmap("<M-j>", '<Plug>GoNSMDown')
				m.nmap("<M-k>", '<Plug>GoNSMUp')
				m.xmap("<M-j>", '<Plug>GoVSMDown')
				m.xmap("<M-k>", '<Plug>GoVSMUp')
			else
				-- Cannot be repeated
				m.noremap("<M-j>", ':move .+1<CR>==', "silent")
				m.noremap("<M-k>", ':move .-2<CR>==', "silent")
				m.vnoremap("<M-j>", ":move '>+1<CR>gv=gv", "silent")
				m.vnoremap("<M-k>", ":move '<-2<CR>gv=gv", "silent")
			end
		end)();


	-- Indent
	m.vmap("<lt>", "<gv")
	m.vmap("<", "<gv")
	m.vmap(">", ">gv")
	m.vmap("<M-h>", "<gv")
	m.vmap("<M-l>", ">gv")
	m.noremap('<Tab>', 'i<Tab><Esc>', "silent")
	m.noremap('<S-Tab>', [[v:s/\%V\t//|norm!``<CR>]], "silent")

	-- Move around buffers
	m.noremap('<A-[>', ":bprev<CR>", "silent")
	m.noremap('<A-]>', ":bnext<CR>", "silent")

	-- Save/Reload file
	m.nnoremap('<C-s>', cmd 'DDSave', "silent")
	m.nnoremap('<F5>', cmd 'DDReloadDocument', "silent")

	-- Italian accents on Alt+Key combination
	m.inoremap('<A-e>', 'è')
	m.inoremap('<A-u>', 'ù')
	m.inoremap('<A-i>', 'ì')
	m.inoremap('<A-a>', 'à')
	m.inoremap('<A-o>', 'ò')
	m.inoremap('<A-E>', 'É')
	m.inoremap('<A-U>', 'Ù')
	m.inoremap('<A-I>', 'Ì')
	m.inoremap('<A-A>', 'À')
	m.inoremap('<A-O>', 'Ò')
	m.inoremap('<A-d>', '°')
	m.inoremap('<C-A-e>', '€')

	-- Hydra(s), now in which-key!
	m.noremap("<Enter>", cmd "HydInterface", "silent")
	m.noremap("<leader><Tab>", cmd "JABSOpen", "silent")
	m.noremap("<Space><Space>p", cmd "HydPacker", "silent")
	m.noremap("<leader>f", cmd "HydFileSystem", "silent")
	m.noremap("<C-w>", cmd "HydWindowManager", "silent")

	-- Telescope fast bindings
	m.noremap("<leader>t", cmd 'HydTelescope')
	m.noremap("<leader>.", cmd 'TSFindFiles')
	m.noremap("<leader>g", cmd 'Telescope live_grep')

	-- Cut, Copy, Paste
	m.noremap('<Leader>x','"+d')
	m.noremap('<Leader>c','"+y')
	m.noremap('<Leader>p', cmd 'Paste +')

	-- Icon Picker
	m.inoremap('<A-n>', cmd 'IconPickerInsert nerd_font')
	m.inoremap('<A-m>', cmd 'IconPickerInsert emoji')

	-- vim.paste = (function(lines, phase)
	-- 	print('pasted!')
 --    vim.api.nvim_put(lines, 'c', true, true)
	-- end)

	-- Trouble
	m.noremap('<Space><Space>t', cmd 'TroubleToggle')

	-- Nvim-Tree
	m.noremap("//", cmd 'NvimTreeToggle')

	-- Enhance escape command
	m.nnoremap("<Esc>", function()
		-- Dismiss any notificaiton
		local HAS_NVIM_NOTIFY, n = pcall(require, "notify")
		if HAS_NVIM_NOTIFY then
			n.dismiss({ pending = true, silent = true}) end

		return "<Esc>"
	end)
end)()
