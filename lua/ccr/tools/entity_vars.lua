
CCR.EntityVars = CCR.EntityVars || {}

if (SERVER) then
	util.AddNetworkString("CCR.EntityVar")
	util.AddNetworkString("CCR.EntityVar.FullSync")

	hook.Add("CCR.OnPlayerFullyLoaded", "CCR.EntityVars", function(p)
		net.Start("CCR.EntityVar.FullSync")
			net.WriteTable(CCR.EntityVars)
		net.Send(p)
	end)
end

function CCR:SetEntityVar(ent, key, var)
	assert(ent, "!ent")
	assert(key, "!key")

	self.EntityVars[ent] = self.EntityVars[ent] || {}

	if (self.EntityVars[ent][key] == var) then
		return
	end

	self.EntityVars[ent][key] = var

	hook.Run("CCR.OnEntityVarSet", ent, key, var)

	if (SERVER) then
		net.Start("CCR.EntityVar")
			net.WriteEntity(ent)
			net.WriteString(key)
			net.WriteType(var)
		net.Broadcast()
	end
end

function CCR:GetEntityVar(ent, key, fallback)
	assert(ent, "!ent")
	assert(key, "!key")

	self.EntityVars[ent] = self.EntityVars[ent] || {}

	local var = self.EntityVars[ent][key]

	if (var != nil) then
		return var
	end

	return fallback
end

if (CLIENT) then
	net.Receive("CCR.EntityVar.FullSync", function()
		CCR.EntityVars = net.ReadTable()
	end)

	net.Receive("CCR.EntityVar", function()
		local ent = net.ReadEntity()
		local key = net.ReadString()
		local var = net.ReadType()

		CCR:SetEntityVar(ent, key, var)
	end)
end