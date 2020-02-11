
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
		//timer.Remove(id)
	end

	timer.Create(id, sec, 1, function()
		func()
		timer.Remove(id)
	end)
end

local function uniqueRandomIntegersRecursive(amt, from, to, target)
	assert(istable(target), "Target is not a table")

	local rand = math.random(from, to)
	if (!target[rand]) then
		target[rand] = true
		target["__count"] = (target["__count"] || 0) + 1
	end

	if (target["__count"] < amt) then
		uniqueRandomIntegersRecursive(amt, from, to, target)
	end
end

function CCR:UniqueRandomIntegers(amt, from, to)
	if (amt > (to - from)) then
		error("Amount is bigger than possible numbers")
	end

	local new = {}
	uniqueRandomIntegersRecursive(amt, from, to, new)

	new["__count"] = nil

	local toReturn = {}
	for i, _ in pairs(new) do
		table.insert(toReturn, i)
	end

	return toReturn
end