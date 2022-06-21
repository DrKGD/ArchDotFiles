local M = {}

local function message(src, kind, msg, hi)
	if not msg then return end
  vim.cmd([[redraw]])
  vim.cmd(string.format('echohl %s', hi))
  vim.cmd(string.format([[echomsg '[%s]']], src))
  vim.cmd(string.format([[echomsg '%s: %s']], kind, msg))
  vim.cmd([[echohl None]])
end

function M.setup(src)
	if not src then return end
	local e = function(msg) message(src, 'Error', msg, 'KUTLuaError') end
	local s = function(msg) message(src, 'OK', msg, 'KUTLuaSuccess') end
	local a = function(msg) message(src, 'Abort', msg, 'KUTLuaAbort') end
	local w = function(msg) message(src, 'Warning', msg, 'KUTLuaWarning') end
	local i = function(msg) message(src, 'Info', msg, 'KUTLuaInfo') end
	return e,s,a,w,i
end


M.init = function(options)
	M.error, M.success, M.abort, M.warn, M.info
		= M.setup(options.unknown_src)

	vim.cmd(string.format([[augroup KUTColors
		autocmd!
		autocmd ColorScheme * highlight KUTLuaError		guifg=%s
		autocmd ColorScheme * highlight KUTLuaSuccess	guifg=%s
		autocmd ColorScheme * highlight KUTLuaInfo			guifg=%s
		autocmd ColorScheme * highlight KUTLuaAbort		guifg=%s
		autocmd ColorScheme * highlight KUTLuaConfirm	guifg=%s
		autocmd ColorScheme * highlight KUTLuaWarning	guifg=%s
	augroup END]],
		options.colors.error,
		options.colors.success,
		options.colors.info,
		options.colors.abort,
		options.colors.confirm,
		options.colors.warning
	))

	vim.cmd(string.format([[
		highlight KUTLuaError		guifg=%s
		highlight KUTLuaSuccess	guifg=%s
		highlight KUTLuaInfo			guifg=%s
		highlight KUTLuaAbort		guifg=%s
		highlight KUTLuaConfirm	guifg=%s
		highlight KUTLuaWarning	guifg=%s
	]],
		options.colors.error,
		options.colors.success,
		options.colors.info,
		options.colors.abort,
		options.colors.confirm,
		options.colors.warning
	))

	M.init = nil
end

--- Confirmation
function M.confirm(msg, confirm)
  vim.cmd([[redraw]])
  vim.cmd([[echohl KUTLuaConfirm]])
	local response = vim.fn.input(msg) == confirm
  vim.cmd([[echohl None]])
	return response
end

return M
