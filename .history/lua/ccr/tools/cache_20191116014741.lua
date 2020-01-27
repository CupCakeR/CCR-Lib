
CCR_CACHE_TARGET = nil
function CCR:SetCacheTarget(tbl, id)
	if !tbl or !id then
		error("invalid args")
	end

	tbl.CCR_CACHE = tbl.CCR_CACHE or {}
	CCR_CACHE_TARGET = tbl
	CCR_CACHE_ID = id
end

function CCR:ResetCacheTarget(tbl)
	tbl.CCR_CACHE = nil
	CCR_CACHE_ID = id
end