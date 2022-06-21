local e,s,a,w,i = require('utils.message').setup('utils.jobs.lua')

local M = {}

local activeJobs = {}

-- Check if command is available
function M.exists(name)
	if vim.fn.system(string.format('command -v %s', name)) ~= '' then
		return true end
	return false
end

-- Make a background shell job
function M.make(name, commandname, cmd, initial_value, lambdaValue, lambdaReturn)
	if not M.exists(commandname) then
		e(string.format('Command %s does not exist!', commandname)) return end

	activeJobs[name] = { cmd = cmd, value = initial_value }

	activeJobs[name].chan_id =
		vim.fn.jobstart(cmd, {
			pty = true,

			on_stdout = function(chan_id, data, other)
				activeJobs[name].value = lambdaValue(data)
			end,

			-- WIP: Hopefully this will not crash shit :/
			on_exit		= function()
				activeJobs[name] = nil
			end
		})

	return function(p) return lambdaReturn(activeJobs[name].value, p) end
end

-- Clear job stdout mess with awk
-- function util.job.clear_awk(command)
-- 	return command .. "| awk -v ORS='/' '{if ($0) print}'"
-- end

return M
