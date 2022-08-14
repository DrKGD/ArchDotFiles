--
-- bufdelete
-- Delete buffer from memory without closing window
--
return { 'famiu/bufdelete.nvim',
	config = function()
		-- Delete buffer
		require('utils.wrap').bind({ noremap = true}, 'n', '<Leader>q', ':Bdelete!<CR>')
	end}
