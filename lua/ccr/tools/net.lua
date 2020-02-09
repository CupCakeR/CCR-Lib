
function CCR:NetDebounceReceive(id, cb, dataFunc, debounceTime)
	assert(id, "No ID specified")
	assert(isfunction(cb), "No callback specified")

	dataFunc = dataFunc || function() end
	debounceTime = debounceTime || 0

	net.Receive(id, function(len, p)
		local data = {}
		dataFunc(data)

		CCR:Debounce("CCR.Net[" .. id .. "][" .. p:SteamID() .. "]", debounceTime, function()
			if (!IsValid(p)) then
				return
			end

			cb(p, data, len)
		end)
	end)
end

// TODO: Spam protected variant (stack? Call instantly if stack is empty)