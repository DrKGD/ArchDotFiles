local M = {}

function M.directoryExists(path)	return vim.fn.isdirectory(path) ~= 0 end
function M.isDirectory(path)			local last = path:sub(-1) return last == '\\' or last == '/' end
function M.fileExists(path)				return not M.isDirectory(path) and vim.fn.empty(vim.fn.glob(path)) == 0 end
function M.fileReadable(path)			return vim.fn.filereadable(path) == 1 end
function M.fileWritable(path)			return vim.fn.filewritable(path) == 1 end
function M.getFilesExt(path, ext)	return vim.fn.expand(string.format('%s*.%s', path, ext), false, true) end
function M.getFiles(path)					return vim.fn.expand(string.format('%s*', path), false, true) end

return M

