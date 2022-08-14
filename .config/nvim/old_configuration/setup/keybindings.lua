------------------
-- Define Keys  --
------------------

(function()
	local bind = require('utils.wrap').bind
	local unbind = require('utils.wrap').unbind

	-- Esc in Terminal
	bind(nil, 't', '<Esc>', '<C-\\><C-n>')

	-- Paste in Terminal, prevent autoex
	bind({ expr = true}, 't', '<C-v>',
		"v:lua.require('utils.macro').paste_terminal()")

	-- Disable man
	unbind('n', 'K')

	--- Command line
	-- Movement
	bind(nil, 'c', '<A-h>','<Left>')
	bind(nil, 'c', '<A-l>','<Right>')
	bind(nil, 'c', '<A-e>','<Home>')
	bind(nil, 'c', '<A-i>','<End>')

	--- Normal
	-- Shift and Movement
	bind(nil, 'n', '<C-e>', '5k')
	bind(nil, 'n', '<C-d>', '5j')

	-- Resize
	bind(nil, 'n', '<A-->', ':resize -3<CR>')
	bind(nil, 'n', '<A-=>', ':resize +3<CR>')
	bind(nil, 'n', '<A-,>', ':vertical resize -3<CR>')
	bind(nil, 'n', '<A-.>', ':vertical resize +3<CR>')

	-- Delete word background and forward (BS and DEL)
	bind(nil, 'i', '<C-H>', '<C-W>')
	bind(nil, 'i', '<C-Del>', '<C-o>diw')

	-- Insert tab character at position or shift the entire line
	bind(nil, 'n', '<Tab>', 'i<Tab><Esc>')
	bind(nil, 'n', '<S-Tab>', [[v:s/\%V\t//|norm!``<CR>]])

	--- Normal noremap
	-- Set path to current file
	bind({ noremap = true }, 'n', '<Leader>/', ':cd %:p:h<CR>')

	-- Cut, Copy, Paste
	bind({ noremap = true }, 'n', '<Leader>x','"+d')
	bind({ noremap = true }, 'n', '<Leader>c','"+y')
	bind({ noremap = true }, 'n', '<Leader>p','"+gP')

	-- Move around buffers
	bind({ noremap = true, silent = true }, 'n', '<A-[>', ":bprev<CR>")
	bind({ noremap = true, silent = true }, 'n', '<A-]>', ":bnext<CR>")

	-- File control
	bind({ noremap = true, silent = true }, 'n', '<C-s>', "lua require('utils.macro').save()<CR>")

	-- Movement
	bind({ noremap = true, silent = true }, 'n','j', 'gj')
	bind({ noremap = true, silent = true }, 'n','k', 'gk')
	bind({ noremap = true, silent = true }, 'n','<A-h>', 'b')
	bind({ noremap = true, silent = true }, 'n','<A-l>', 'e')

	-- Disable arrow keys (wezterm requirement)
	unbind('n', '<Up>')
	unbind('n', '<Down>')
	unbind('n', '<Left>')
	unbind('n', '<Right>')

	-- Move lines around
	bind({ noremap = true }, 'n', '<C-A-j>', ":move+1<CR>")
	bind({ noremap = true }, 'n', '<C-A-k>', ":move-2<CR>")

	-- Custom functions
	bind({ noremap = true }, 'n', '<Leader>fa', ":KUTNew<CR>")
	bind({ noremap = true }, 'n', '<Leader>fm', ":KUTMove<CR>")
	bind({ noremap = true }, 'n', '<Leader>fd', ":KUTRemove<CR>")
	bind({ noremap = true }, 'n', '<Leader>fr', ":KUTRename<CR>")
	bind({ noremap = true, silent = true }, 'n', '<Space><Space>r', ":KUTKeepSessionRestart<CR>")
	bind({ noremap = true }, 'n', '<C-s>', ":KUTSave<CR>")

	--- Visual
	-- Indent lines
	bind(nil, 'v', '<C-e>', '5k')
	bind(nil, 'v', '<C-d>', '5j')
	bind(nil, 'v', '<lt>', '<gv')
	bind(nil, 'v', '<', '<gv')
	bind(nil, 'v', '>', '>gv')

	-- Visual Noremap
	bind({ noremap = true }, 'v', 'j', 'gj')
	bind({ noremap = true }, 'v', 'k', 'gk')
	bind({ noremap = true }, 'v', '<C-A-j>', ":move'>+<CR>gv=gv")
	bind({ noremap = true }, 'v', '<C-Down>', ":move'>+<CR>gv=gv")
	bind({ noremap = true }, 'v', '<C-A-k>', ":move-2<CR>gv=gv")
	bind({ noremap = true }, 'v', '<C-Up>', ":move-2<CR>gv=gv")
	bind({ noremap = true }, 'v', '<Leader>x','"+d')
	bind({ noremap = true }, 'v', '<Leader>c','"+y')
	bind({ noremap = true }, 'v', '<Leader>p','"+gP')

	--- Insert Noremap
	bind({ noremap = true }, 'i', '<A-h>','<Left>')
	bind({ noremap = true }, 'i', '<A-l>','<Right>')
	bind({ noremap = true }, 'i', '<A-e>','<Home>')
	bind({ noremap = true }, 'i', '<A-i>','<End>')
	bind({ noremap = true, silent = true }, 'i', '<C-v>','<Esc>:set paste<CR>a<C-r>+<ESC>:set nopaste<CR>a')

	-- <F1> Toggle hidden characters
	bind({ noremap = true }, 'n', '<F1>', ':KUTToggleList<CR>')

	-- <Ctrl + F1> Toggle spell
	bind({ noremap = true }, 'n', '<F25>', ':KUTToggleSpell<CR>')
	bind({ noremap = true }, 'n', '<C-F1>',':KUTToggleSpell<CR>')

	-- <Ctrl + F2> Toggle highlight search
	bind({ noremap = true }, 'n', '<F26>', ':set hlsearch! hlsearch?<CR>')
	bind({ noremap = true }, 'n', '<C-F2>', ':set hlsearch! hlsearch?<CR>')

	-- <F5> Reload current file, without saving
	bind({ noremap = true }, 'n', '<F5>', ':KUTRefresh<CR>')

	-- Italian accents on Alt+Key combination
	bind({ noremap = true }, 'i', '<A-e>', 'è')
	bind({ noremap = true }, 'i', '<A-u>', 'ù')
	bind({ noremap = true }, 'i', '<A-i>', 'ì')
	bind({ noremap = true }, 'i', '<A-a>', 'à')
	bind({ noremap = true }, 'i', '<A-o>', 'ò')
	bind({ noremap = true }, 'i', '<A-E>', 'É')
	bind({ noremap = true }, 'i', '<A-U>', 'Ù')
	bind({ noremap = true }, 'i', '<A-I>', 'Ì')
	bind({ noremap = true }, 'i', '<A-A>', 'À')
	bind({ noremap = true }, 'i', '<A-O>', 'Ò')
	bind({ noremap = true }, 'i', '<A-d>', '°')
	bind({ noremap = true }, 'i', '<C-A-e>', '€')

	-- Page up/down
	-- bind({ noremap = true }, 'n', '<PageUp>', '5j')
	end)()

