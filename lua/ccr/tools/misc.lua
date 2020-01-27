
function CCR:RandomString(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

if CLIENT then
	hook.Add("EntityRemoved", "CCR.PlayerDisconnect", function(ent)
		if (ent:IsPlayer() && ent.CCR_FullyLoaded) then
			hook.Run("CCR.PlayerDisconnected", ent)
		end
	end)
else
	hook.Add("PlayerDisconnected", "CCR.PlayerDisconnect", function(p)
		hook.Run("CCR.PlayerDisconnected", p)
	end)
end

function CCR:Debounce(id, sec, func)
	id = "CCR.Debounce." .. id
	if (timer.Exists(id)) then
		timer.Remove(id)
	end

	timer.Create(id, sec, 1, function()
		func()
		timer.Remove(id)
	end)
end