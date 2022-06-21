local M = {}

local activeTimers = {}

--- Adds a loop timer (repeats itself, lambda has to return a delay)
local function loopTimer(lambda)
	local function timedFunction()
		local wait = lambda()
		vim.defer_fn(timedFunction, wait)
	end

	timedFunction()
end

--- A value-oriented timer
-- lambdaValue (how to update the value)
-- lambdaDelay (how to calculate the delay)
-- lambdaReturn (what to return)
function M.make(name, initial_value, lambdaValue, lambdaDelay, lambdaReturn)
	activeTimers[name] = { value = initial_value }

	loopTimer(function()
		local prev = activeTimers[name].value
		activeTimers[name].value = lambdaValue(prev)
		return lambdaDelay(prev, activeTimers[name].value)
	end)

	return function(p) return lambdaReturn(activeTimers[name].value, p) end
end

--- Attach to a pre-esisting timer value
function M.attach(name, lambdaReturn)
	return function(p) return lambdaReturn(activeTimers[name].value, p) end
end

--- Check if timer is Running
function M.isRunning(name)
	return activeTimers[name]
end

return M

