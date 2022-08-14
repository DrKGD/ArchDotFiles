--
-- bufferline
-- Changes tabline to bufferline
--
return { 'akinsho/bufferline.nvim',
	requires = 'kyazdani42/nvim-web-devicons',
	config = function()
		local hidden_buffers = {}
		local noop = function() end

		require('bufferline').setup({
			options = {
				view = "multiwindow",
				numbers = "ordinal",
				max_prefix_length = 5,
				max_name_length = 30,
				tab_size = 23,
				close_command = noop,
				right_mouse_command = noop,
				left_mouse_command = noop,
				middle_mouse_command = noop,

				name_formatter = function(buf)
					-- print(vim.inspect(buf))
					local cwd = vim.fn.fnamemodify(buf.path, ':p:h:t')
					-- print(vim.fn.getcwd(buf.bufnr))
					-- local cwd = vim.fn.fnamemodify(buf, ':p')
					return string.format('[%s] %s', cwd, buf.name)
				end,

				custom_filter = function(buf_number)
					if hidden_buffers[vim.fn.bufname(buf_number)] then
						return false
					end

					return true
				end,

				-- Simple
				show_close_icon = false,
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_tab_indicators = true,
				separator_style = "thin",
				-- enforce_regular_tabs = true,
				always_show_bufferline = true,
			},

		})
	end }
