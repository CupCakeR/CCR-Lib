
CCR.NetSpam = CCR.NetSpam || {}

function CCR:NetReceiveDebounced(id, cb, dataFunc, options)
	assert(id, "No ID specified")
	assert(isfunction(cb), "No callback specified")

	options = options || {}
	options.debounceTime = options.debounceTime || 0
	options.spam = options.spam == nil && 10 || tonumber(options.spam)

	dataFunc = dataFunc || function() end

	net.Receive(id, function(len, p)
		self.NetSpam[p] = self.NetSpam[p] || {}
		self.NetSpam[p][id] = (self.NetSpam[p][id] || 0) + 1

		if (options.spam && options.spam >= self.NetSpam[p][id]) then
			if (options.spam == self.NetSpam[p][id]) then
				local str = ":nick (:sid) exceeded the spam limit of :limit of the net message \":id\". This could could be an ongoing attempt to crash the server."
				str = str:Replace(":nick", p:Nick())
				str = str:Replace(":sid", p:SteamID())
				str = str:Replace(":id", id)
				str = str:Replace(":limit", options.spam)

				error(str)
			end

			return
		end

		local data = {}
		dataFunc(data)

		CCR:Debounce("CCR.Net[" .. id .. "][" .. p:SteamID() .. "]", options.debounceTime, function()
			if (!IsValid(p)) then
				return
			end

			self.NetSpam[p][id] = nil

			cb(p, data, len)
		end)
	end)
end

// TODO: Spam protected variant (stack? Call instantly if stack is empty) 