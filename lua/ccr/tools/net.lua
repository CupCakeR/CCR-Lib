
CCR.NetSpam = CCR.NetSpam || {}

function CCR:NetSafeReceive(id, cb, dataFunc, options)
	assert(id, "No ID specified")
	assert(isfunction(cb), "No callback specified")

	options = options || {}
	options.debounceTime = options.debounceTime || 0
	options.limitPerTick = options.limitPerTick == nil && 1 || tonumber(options.limitPerTick)
	options.doError = options.doError == nil && true || options.doError

	dataFunc = dataFunc || function() end

	net.Receive(id, function(len, p)
		self.NetSpam[p] = self.NetSpam[p] || {} // Just in case
		self.NetSpam[p][id] = (self.NetSpam[p][id] || 0) + 1

		if (self.NetSpam[p][id] > 100) then
			return
		end

		local data = {}
		dataFunc(data)

		if (options.limitPerTick && options.limitPerTick <= (self.NetSpam[p][id] - 1)) then
			CCR:Debounce("CCR.Net[" .. id .. "][" .. p:SteamID() .. "]", options.debounceTime, function()
				if (!IsValid(p)) then
					return
				end

				cb(p, data, len)
			end)

			if (options.doError && options.limitPerTick == self.NetSpam[p][id] - 1) then
				local str = "[CCR] WARNING: :nick (:sid) exceeded the spam limit (:limit/tick) of net message \":id\". This could be an ongoing attempt to crash the server.\n"
				str = str:Replace(":nick", p:Nick())
				str = str:Replace(":sid", p:SteamID())
				str = str:Replace(":id", id)
				str = str:Replace(":limit", options.limitPerTick)

				Error(str)
			end

			return
		end

		cb(p, data, len)
	end)
end

hook.Add("Tick", "CCR.NetSafeReceive", function()
	// Why the fuck would I need to loop through all players
	/*for i, p in ipairs(player.GetAll()) do
		CCR.NetSpam[p] = {}
	end*/

	// Clear spam table
	CCR.NetSpam = {}
end)