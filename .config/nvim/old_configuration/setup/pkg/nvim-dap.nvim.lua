--
-- DAP
-- Debug Adapter Protocol
--
return { "mfussenegger/nvim-dap",
	requires = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text", },
	config = function()
		local dap = require('dap')
		local bind = require('utils.wrap').bind

		-- Registering adapter(s)
		dap.adapters.lldb = {
			type = 'executable',
			command = '/usr/bin/lldb-vscode',
			name = 'lldb'
		}

		dap.configurations.cpp = {{
			name = 'launch',
			type = 'lldb',
			request ='launch',
			program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
			cwd = '${workspaceFolder}',
			stopOnEntry = false,
			args = {},
		}}

		dap.configurations.c = dap.configurations.cpp

		-- Bindings
		bind({ noremap = true}, 'n', '<Leader>tt', ':lua require("dap").toggle_breakpoint()<CR>')
		bind({ noremap = true}, 'n', '<Leader>tn', ':lua require("dap").step_over()<CR>')
		bind({ noremap = true}, 'n', '<Leader>ti', ':lua require("dap").step_into()<CR>')
		bind({ noremap = true}, 'n', '<Leader>tc', ':lua require("dap").continue()<CR>')

		-- UI 
		require("nvim-dap-virtual-text").setup()
		require("dapui").setup()
		bind({ noremap = true}, 'n', '<Leader>dd', ':lua require("dapui").toggle()<CR>')
		bind({ noremap = true}, 'n', '<Leader>dt', ':lua require("dapui").float_element()<CR>')
		bind({ noremap = true}, 'n', '<Leader>de', ':lua require("dapui").eval()<CR>')
		bind({ noremap = true}, 'v', '<Leader>de', ':lua require("dapui").eval()<CR>')

		vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
	end
}
