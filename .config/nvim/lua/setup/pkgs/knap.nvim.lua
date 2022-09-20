return { "frabjous/knap",													-- HTML, Markdown and Latex live previewer
		config = function()

			vim.g.knap_settings = {
				-- Auto-update delay
				delay = 200,

				-- Use a live server for html, requires nodejs-live-server
				htmltohtmlviewerlaunch =
					"live-server --port=8800 --quiet --browser=firefox-developer-edition --open=%outputfile% --watch=%outputfile% --wait=200",
				htmltohtmlviewerrefresh = "none",

				-- Use pandoc to convert gfm (github-flavored markdown) documents into html and live-server, requires pandoc and nodejs-live-server
				--  + uses /tmp/ as root
				--  + reads from stdin, thus no multiple writes 
				--  + writes output to tmp 
				--  + live-server takes care of updates, so it is disabled
				mdtohtml =
					[[pandoc --standalone --metadata title="Generated from %outputfile%" --from=gfm --to=html5 --output="/tmp/%outputfile%"]],
				mdtohtmlviewerlaunch =
					[[cd /tmp/ && live-server --port=8800 --quiet --browser=firefox-developer-edition --open="%outputfile%" --watch="/tmp/%outputfile%" --wait=200]],
				mdtohtmlviewerrefresh = "none",
				mdtohtmlbufferasstdin = true,

				-- Use lualatex as engine, requires texlive-most
				texoutputext = "pdf",
				textopdf = "lualatex --synctex=1 --halt-on-error --interaction=batchmode %docroot%",
			}

			-- Automatically kill all instances of nodejs-live-server on buffer close
			vim.api.nvim_create_autocmd({ 'BufDelete' },{ pattern = {'*.md', '*.html'}, callback = function(event)
				local relativeName = vim.fn.fnamemodify(event.match, ':.')

				local tbl = vim.b[event.buf]
				if tbl.knap_viewerpid then
					os.execute(string.format('pkill -P %s', tbl.knap_viewerpid))
					vim.notify(string.format("Live-Server for %s was closed!", relativeName), "info", { render = "minimal" })
				end
			end})

			-- Ensure all nvim-related nodejs-live-server(s) are killed upon exiting
			vim.api.nvim_create_autocmd({ 'VimLeave' },{ callback = function()
				local bufs = require('util.buffers').getBuffers()
				for _, b in ipairs(bufs) do
					if vim.b[b].knap_viewerpid then
						os.execute(string.format('pkill -P %s', vim.b[b].knap_viewerpid))
					end
				end
			end})
		end }
