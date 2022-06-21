--
-- Project
-- Auto-cd to project-recognised folder
--
return { 'ahmedkhalf/project.nvim',
		disable = true,
		config = function()
			require('project_nvim').setup({
				update_cwd = false,
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".neoproj"},
			})
		end}
