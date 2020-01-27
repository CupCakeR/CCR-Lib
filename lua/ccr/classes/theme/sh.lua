
local CLASS = {}
CLASS.__index = CLASS

AccessorFunc(CLASS, "id", "ID", FORCE_STRING)
AccessorFunc(CLASS, "name", "Name", FORCE_STRING)
AccessorFunc(CLASS, "colors", "Colors")
AccessorFunc(CLASS, "materials", "Materials")

function CLASS.new(id)
	local _self = setmetatable({}, CLASS)

	_self.id = id

	hook.Run("CCR.NewTheme", _self)

	return _self
end

function CLASS:__tostring()
	return "CCR.Theme[" .. (self:GetID() or "Undefined id") .. "]"
end

function CLASS:Register()
	CCR:RegisterTheme(self)
end

function CCR:NewTheme(id)
	return CLASS.new(id)
end