local M = {}

--- Boolean-ize 0 and 1 for ease of use
-- THANKS: https://www.reddit.com/r/neovim/comments/j2udsu/how_to_deal_with_vim_function_returning_1_or_0_in
-- THANKS: https://github.com/Iron-E/nvim-libmodal/blob/master/lua/libmodal/src/globals.lua
local _VIM_FALSE	= 0
local _VIM_TRUE		= 1

function M.is_false(val)
	return val == false or val == _VIM_FALSE
end

function M.is_true(val)
	return val == true or val == _VIM_TRUE
end

--- Completition shenanigans for autopairs
local _, npairs = pcall(require, 'nvim-autopairs')

M.CR = function()
	if vim.fn.pumvisible() ~= 0 then
		if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
			return npairs.esc('<c-y>')
		else
			return npairs.esc('<c-e>') .. npairs.autopairs_cr()
		end
	else
		return npairs.autopairs_cr()
	end
end

M.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end


return M
