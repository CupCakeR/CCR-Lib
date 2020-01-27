
function CCR:RandomString(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

if CLIENT then
	hook.Add("EntityRemoved", "CCR.PlayerDisconnect", function(ent)
		if ent:IsPlayer() then
			hook.Run("PlayerDisconnected", ent)
		end
	end)
end