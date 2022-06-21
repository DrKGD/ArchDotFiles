--
-- nvim-comment
-- Nerdcommenter
--
return { 'terrortylor/nvim-comment',
	config = function()
		require('nvim_comment').setup({
			comment_empty = true,
			create_mappings = false,
		})

		--- Mappings
		require('utils.wrap').bind({ noremap = true}, 'n', 'gcc', ":CommentToggle<CR>")
		require('utils.wrap').bind({ noremap = true}, 'v', 'gcc', ":CommentToggle<CR>")
	end}
