
CCR_CACHE_TARGET = nil
function CCR:SetCacheTarget(tbl, id)
	tbl.CCR_CACHE = tbl.CCR_CACHE or {}
	CCR_CACHE_TARGET = tbl
end

function CCR:ResetCacheTarget(tbl)
	tbl.CCR_CACHE = nil
end