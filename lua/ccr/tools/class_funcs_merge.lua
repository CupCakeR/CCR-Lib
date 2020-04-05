local CLASS = {}

CLASS._hooks = {}
CLASS._timers = {}

function CLASS:CCR_GetIdentifier()
  return "[CCR.(Hook/Timer)]:" .. self.CCR_CLASSNAME
end

function CLASS:AddHook(event, func)
  local id = self:CCR_GetIdentifier()
  hook.Add(event, id, function(...)
    return func(self, ...)end)
  self._hooks[event] = id
  return self
end

function CLASS:RemoveHook(event)
  if !self._hooks[event] then return end
  hook.Remove(event, self._hooks[event])
  return self
end

function CLASS:RemoveHooks()
  for event, id in pairs(self._hooks) do
    hook.Remove(k, id)
  end
  return self
end

function CLASS:AddTimer(id, delay, reps, func)
  local timer_id = self:CCR_GetIdentifier() .. "|" .. id
  self._timers[timer_id] = func
  timer.Create(timer_id, delay, reps, function()
    func(self)end)
  return self
end

function CLASS:RemoveTimer(id)
  local timer_id = self:CCR_GetIdentifier() .. "|" .. id
  timer.Remove(timer_id)
  return self
end

function CLASS:RemoveTimers()
  for timer_id, _ in pairs(self._timers) do
    timer.Remove(timer_id)
  end
  return self
end

CCR:AddClassFunction("Remove", function(s)
  s:RemoveHooks()
  s:RemoveTimers()

  if s.old_Remove then
    s.old_Remove(s)
  end

  return s
end)

return CLASS
