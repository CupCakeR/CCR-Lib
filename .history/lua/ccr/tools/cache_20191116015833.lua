
CCR_CACHE_TARGET = nil
function CCR:SetCacheTarget(tbl)
	if !tbl  then
		error("invalid args")
	end

	tbl.CCR_CACHE = tbl.CCR_CACHE or {}
	CCR_CACHE_TARGET = tbl
end

function CCR:AddToCache(id, value)

end

function CCR:ResetCacheTarget(tbl)
	tbl.CCR_CACHE = nil
end

function CCR:ClearCache()
	CCR_CACHE_TARGET = nil
end

function CCR:AddDrawCache(index, value)
	if CCR_CACHE_TARGET then
		CCR_CACHE_TARGET.CCR_CACHE[index] = value
	end
end

function CCR:GetDrawCached(index)
	return CCR_CACHE_TARGET && CCR_CACHE_TARGET.CCR_CACHE && CCR_CACHE_TARGET.CCR_CACHE[index]
end