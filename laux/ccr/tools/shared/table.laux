
local function makeNonNestedRecursive(tblOut, key, tblIn, delimiter)
	delimiter = delimiter || "."
	for k, v in pairs(tblIn) do
		if (istable(v)) then
			local _delimiter = (key != "" && delimiter || "")
			makeNonNestedRecursive(tblOut, key .. _delimiter .. k, v)
		else
			tblOut[key .. "." .. k] = v
		end
	end
end

function CCR:FlattenTable(tbl, delimiter)
	local new = {}
	makeNonNestedRecursive(new, "", tbl, delimiter || ".")
	return new
end