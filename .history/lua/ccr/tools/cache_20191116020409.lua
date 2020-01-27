
CCR_CACHE_TARGET = nil
function CCR:SetCacheTarget(tbl, key)
	if !tbl or !key then
		error("invalid args")
	end

	tbl.CCR_CACHE = tbl.CCR_CACHE or {}
	CCR_CACHE_TARGET = {
		tbl = tbl,
		key = key
	}
end

function CCR:AddToCache(id, value)

end

function CCR:ResetCacheTarget(tbl, key)
	if tbl && key && tbl.CCR_CACHE then
		tbl.CCR_CACHE[key] = nil
		return
	end

	tbl.CCR_CACHE = nil
end

function CCR:ClearCache()
	CCR_CACHE_TARGET = nil
end

function CCR:AddDrawCache(index, value)
	local cur = CCR_CACHE_TARGET
	if cur then
		cur.tbl.CCR_CACHE[cur.key][index] = value
	end
end

function CCR:GetDrawCache(index)
	local cur = CCR_CACHE_TARGET
	if !cur then return end
	return cur.tbl.CCR_CACHE[cur.key][index]
end