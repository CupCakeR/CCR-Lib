local CLASS = {}
CLASS.__index = CLASS

CCR:AccessorFunc(CLASS, "id", "ID", "String")

function CLASS.new(id)
  local _self = setmetatable({}, CLASS)
  _self.id = id
  return _self
end

function CLASS:__tostring()
  return "CCR.Config[" .. (self:GetID() or "Undefined") .. "]"
end

function CCR:NewConfig(id)
  return CLASS.new(id)
end
