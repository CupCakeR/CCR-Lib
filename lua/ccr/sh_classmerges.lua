
CCR.ClassFunctions = CCR.ClassFunctions || {}

function CCR:AddClassFunctions(class)
	if (!class.CCR_CLASSNAME) then
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

local realms = {
	["sv"] = true,
	["cl"] = true,
	["sh"] = true
}
local function _include(file)
	local toReturn = include(file)
	assert(toReturn || istable(toReturn), "Nothing to merge")
	return toReturn
end
function CCR:ExtendClass(class, fileName, realmOverride)
	assert(class, "Invalid class")
	assert(fileName, "Invalid fileName")

	local realm
	if (!realmOverride) then
		realm = fileName:sub(1, 2)
	else
		assert(isstring(realmOverride), "realmOverride argument given but it's an invalid realm (!isstring)")
		realm = realmOverride:lower()
	end

	assert(realms[realm || ""], "Invalid realm")

	if (!fileName:EndsWith(".lua")) then
		fileName = fileName .. ".lua"
	end

	local trace = debug.getinfo(2, "S")
	local fileSource = trace["short_src"]
	local fileToMerge = fileSource:GetPathFromFilename()
	fileToMerge = fileToMerge .. fileName
	fileToMerge = fileToMerge:Split("/lua/")

	assert(fileToMerge[2], "Failed to get path from file name")
	fileToMerge = fileToMerge[2]

	if (SERVER && (realm == "sh" || realm == "cl")) then
		AddCSLuaFile(fileToMerge)
	end

	local tableToMerge
	if (CLIENT && (realm == "sh" || realm == "cl") || SERVER && (realm == "sh" || realm == "sv")) then
		tableToMerge = include(fileToMerge)

		assert(tableToMerge, "Nothing to merge")
		assert(istable(tableToMerge), "Returned value is not a table, can't merge")

		table.Merge(class, tableToMerge)
	end
end