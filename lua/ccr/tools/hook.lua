
//FIXME CLASS FUNC MERGES???????????

CCR:AddPanelFunction("Remove", function(s)
	local old = s.old_Remove

	for k, v in pairs(s._hooks or {}) do
		hook.Remove(v.name, k)
	end

	for k, v in pairs(s._timers or {}) do
		timer.Remove(k)
	end

	old(s)

	return s
end)

CCR:AddPanelFunction("AddHook", function(s, name, id, func)
	id = "[" .. s.panel_id .. "]" .. id

	s._hooks = s._hooks or {}
	s._hooks[id] = {
		name = name,
		func = function(...)
			if IsValid(s) then
				return func(s, ...)
			end
		end
	}

	hook.Add(name, id, s._hooks[id].func)

	return s
end)

CCR:AddPanelFunction("AddTimer", function(s, id, delay, rep, func)
	id = "[" .. s.panel_id .. "]" .. id

	s._timers = s._timers or {}
	s._timers[id] = true

	timer.Create(id, delay, rep, function(...)
		if IsValid(s) then
			func(s, ...)
		end
	end )

	return s
end)