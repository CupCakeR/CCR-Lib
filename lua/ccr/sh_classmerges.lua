
CCR.ClassFunctions = CCR.ClassFunctions or {}

function CCR:AddClassFunctions(class)
	if !class.CCR_CLASSNAME then
		error("CLASS HAS NO CCR_CLASSNAME")
	end

	local tbl = include("ccr/tools/class_funcs_merge.lua")
	table.Merge(class, tbl)
	self:ApplyClassFunctions(class)
	return class
end

function CCR:AddClassFunction(name, func)
	self.ClassFunctions[name] = func
end

function CCR:ApplyClassFunctions(class)
	for name, func in pairs(self.ClassFunctions) do
		local old = class[name]
		if old then
			class["old_" .. name] = old // save to allow detour
		end

		class[name] = func
	end
end