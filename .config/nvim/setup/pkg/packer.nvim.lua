--
-- Packer
-- The packet manager itself
--
return { 'wbthomason/packer.nvim',
	config = function()
		local bind = require('utils.wrap').bind
		bind({ noremap = true }, 'n', '<Space><Space>pi', ':PackerInstall<CR>')
		bind({ noremap = true }, 'n', '<Space><Space>pu', ':PackerUpdate<CR>')
		bind({ noremap = true }, 'n', '<Space><Space>pc', ':KUTCompileRestart<CR>')
	end }
