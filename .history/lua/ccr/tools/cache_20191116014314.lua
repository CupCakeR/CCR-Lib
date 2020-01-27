
CCR_CACHE_TARGET = nil
function CCR:SetCacheTarget(tbl, id)
	CCR_CACHE_TARGET = tbl
end

function CCR:ResetCacheTarget(tbl)
	tbl.CCR_CACHE = nil
end