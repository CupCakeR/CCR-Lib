
// TODO: Move to a proper file

function CCR:BotSteamID64(name)
	if !string.StartWith(name, "Bot") then
		return 0
	end

	local num = string.Split(name, "t")[2]
	if string.StartWith(num, "0") then
		num = string.gsub(num, "0", "", 1)
	end

	num = tonumber(num)

	local base = "90071996842377"
	local mod = 215

	return base .. (mod + num)
end

if (CLIENT) then
	local toValidate = false

	net.Receive("CCR.FCI.FullList", function()
		toValidate = net.ReadTable()
	end)

	net.Receive("CCR.FCI.UpdateList", function()
		if (!toValidate) then
			return
		end

		local add = net.ReadBool()
		local steamId = net.ReadString()

		if (add) then
			table.insert(toValidate, steamId)
		else
			table.RemoveByValue(toValidate, steamId)
		end
	end)

	net.Receive("CCR.FCI.Ready", function()
		local p = net.ReadEntity()

		if (!IsValid(p)) then
			return
		end

		p.CCR_FullyLoaded = true

		hook.Run("CCR.OnPlayerFullyLoaded", p)
	end)

	hook.Add("Tick", "CCR.FCI.Check", function()
		if (!toValidate) then return end

		for steamId, validated in pairs(toValidate) do
			if (player.GetBySteamID(steamId)) then
				toValidate[steamId] = nil
			end
		end

		if (table.Count(toValidate) == 0) then
			net.Start("CCR.FCI.Ready")
			net.SendToServer()

			hook.Run("CCR.OnPlayerFullyLoaded", LocalPlayer())
			hook.Remove("Tick", "CCR.FCI.Check")
		end
	end)
else
	util.AddNetworkString("CCR.FCI.FullList")
	util.AddNetworkString("CCR.FCI.UpdateList")
	util.AddNetworkString("CCR.FCI.Ready")

	local toBeValidated = {}
	net.Receive("CCR.FCI.Ready", function(_, p)
		if (!toBeValidated[p]) then
			return
		end

		p.CCR_FullyLoaded = true

		hook.Run("CCR.OnPlayerFullyLoaded", p)

		net.Start("CCR.FCI.Ready")
			net.WriteEntity(p)
		net.SendOmit(p)

		toBeValidated[p] = nil
	end)

	hook.Add("PlayerInitialSpawn", "CCR.FCI.Sync", function(p)
		local steamId = p:SteamID()

		if (p:IsBot()) then
			steamId = CCR:BotSteamID64(p:Nick())
		end

		local send = {}
		for _p, _ in pairs(toBeValidated) do
			table.insert(send, _p)
		end

		if (#send > 0) then
			net.Start("CCR.FCI.UpdateList")
				net.WriteBool(true)
				net.WriteString(steamId)
			net.Send(send)
		end

		local players = {}
		for i, _p in ipairs(player.GetAll()) do
			players[steamId] = false
		end

		toBeValidated[p] = true
		net.Start("CCR.FCI.FullList")
			net.WriteTable(players)
		net.Send(p)
	end)

	hook.Add("PlayerDisconnected", "CCR.FCI.Sync", function(p)
		local send = {}
		for _p, _ in pairs(toBeValidated) do
			table.insert(send, _p)
		end

		if (#send == 0) then return end

		local steamId = p:IsBot() && BotSteamID64(p:Nick()) || p:SteamID()
		net.Start("CCR.FCI.UpdateList")
			net.WriteBool(false)
			net.WriteString(steamId)
		net.Send(send)
	end)
end

function CCR:GetFullyInitializedPlayers()
	local players = {}
	for i, p in ipairs(player.GetAll()) do
		if (p.CCR_FullyLoaded) then
			table.insert(players, p)
		end
	end

	return players
end

function CCR:PlayerHasFullyInitialized(p)
	assert(p, "Player is not valid")
	return p.CCR_FullyLoaded || false
end

local pmeta = FindMetaTable("Player")
if !pmeta.CCR_old_SteamID64 then
	pmeta.CCR_old_SteamID64 = pmeta.SteamID64
	function pmeta:SteamID64()
		if IsValid(self) and self:IsBot() then
			return CCR:BotSteamID64(self.RealName and self:RealName() or self.RealNick and self:RealNick() or self:Nick())
		end

		return self.CCR_old_SteamID64(self)
	end
end
