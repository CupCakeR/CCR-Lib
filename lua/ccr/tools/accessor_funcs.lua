
local check_types = {
	["table"] = function(_, val)
		return istable(val)
	end,
	["number"] = function(_, val)
		return isnumber(val)
	end,
	["integer"] = function(_, val)
		return isnumber(val) && (val == math.floor(val))
	end,
	["string"] = function(_, val)
		return isstring(val)
	end,
	["bool"] = function(_, val)
		return isbool(val)
	end,
	["entity"] = function(_, val)
		return isentity(val)
	end,
	["player"] = function(_, val)
		return isentity(val) && val:IsPlayer()
	end,
	["vector"] = function(_, val)
		return isvector(val)
	end,
	["angle"] = function(_, val)
		return isangle(val)
	end,
	["material"] = function(_, val)
		return type(val) == "IMaterial"
	end,
	["color"] = function(_, val)
		return IsColor(val)
	end,
	["panel"] = function(_, val)
		return ispanel(val)
	end,
	["function"] = function(_, val)
		return isfunction(val)
	end
}

local aliases = {
	["boolean"] = "bool"
}

local function is_nil_null(value)
	return value == NULL || value == nil
end

function CCR:AccessorFunc(class, key, name, force_type, nil_null, default)
	class["Set" .. name] = function(s, value)
		if force_type then
			local check, type_name
			if (force_type && isstring(force_type)) then
				local lower = force_type:lower()
				if (aliases[lower]) then
					lower = aliases[lower]
				end

				check = check_types[lower]
				if (!check) then
					error("CCR: Type to check does not exist.")
				end
			elseif (isfunction(force_type)) then
				check = force_type
			else
				error("CCR: Invalid type to force.")
			end

			check, type_name = check(class, value)
			if (!check && !(nil_null && is_nil_null(value))) then
				error("CCR: Invalid type, " .. (isstring(force_type) && force_type || type_name || "INVALID TYPE") .. " expected, got " .. type(value) .. "!")
			end
		end

		s[key] = value
		return s
	end

	class["Get" .. name] = function(s)
		return s[key]
	end

	if (!class[key] && default != nil) then
		class[key] = default
	end
end