--
-- Knap
-- Live document preview
--
return { 'frabjous/knap',
	config = function()
		local bind = require('utils.wrap').bind

		bind({ noremap = true}, 'n', '<F7>', function() require("knap").process_once() end)
		bind({ noremap = true}, 'n', '<C-F7>', function() require("knap").close_viewer() end)
		bind({ noremap = true}, 'n', '<F8>', function() require("knap").toggle_autopreviewing() end)

		vim.g.knap_settings = {
			-- Delay in ms for recompiling
			delay = 200,

			-- Latex compilation parameters
			texoutputext = "pdf",
			textopdf = "lualatex --synctex=1 --halt-on-error --interaction=batchmode %docroot%",

			-- Viewer
			-- textopdfviewerlaunch = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-instance %outputfile%",
			-- textopdfviewerrefresh = "none",
			-- textopdfforwardjump = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-instance --forward-search-file %srcfile% --forward-search-line %line% %outputfile%",
			-- textopdfshorterror = "A=%outputfile% ; LOGFILE=\"${A%.pdf}.log\" ; rubber-info \"$LOGFILE\" 2>&1 | head -n 1",
		}
	end }
