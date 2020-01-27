
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

local function is_nil_null(value)
	return value == NULL || value == nil
end

function CCR:AccessorFunc(class, key, name, force_type, nil_null)
	// Setter
	/*if class["Set" .. name] then
		self:Debug("WARNING: Setter (" .. name .. ") already exists, overriding!")
	end*/
	class["Set" .. name] = function(s, value)
		if force_type then
			local check, type_name
			if force_type && isstring(force_type) then
				check = check_types[string.lower(force_type)]
				if !check then
					error("CCR: Type to check does not exist.")
				end
			elseif isfunction(force_type) then
				check = force_type
			else
				error("CCR: Invalid type to force.")
			end

			check, type_name = check(class, value)
			if !check && !(nil_null && is_nil_null(value)) then
				error("CCR: Invalid type, " .. (isstring(force_type) && force_type || type_name || "INVALID TYPE") .. " expected, got " .. type(value) .. "!")
			end
		end

		s[key] = value
		return s
	end

	// Getter
	/*if class["Get" .. name] then
		self:Debug("WARNING: Getter (" .. name .. ") already exists, overriding!")
	end*/
	class["Get" .. name] = function(s)
		return s[key]
	end

	//class[key] = nil //NOTE Clear in case of overriding
end