
CCR:AddPanelFunction("Lerp", function(s, key, to, dur, cb)
	local anim = s:NewAnimation(dur or .1)
	anim.from = s[key]
	anim.to = to
	anim.Think = function(_s, pnl, frac)
		pnl[key] = Lerp(Lerp(frac, 0, 1), _s.from, _s.to)
	end
	anim.OnEnd = function(_s)
		if (cb) then
			cb(s)
		end
	end

	return anim
end)

CCR:AddPanelFunction("LerpColor", function(s, key, to, dur, callback)
	local anim = s:NewAnimation(dur or .1)
	anim.from = s[key]
	anim.to = to
	anim.Think = function(_s, pnl, frac)
		pnl[key] = CCR:LerpColor(Lerp(frac, 0, 1), _s.from, _s.to)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end

	return anim
end)

CCR:AddPanelFunction("LerpSize", function(s, w, h, dur, callback)
	local anim = s:NewAnimation(dur or .1)
	anim.from_w = s:GetWide()
	anim.from_h = s:GetTall()
	anim.to_w = w
	anim.to_h = h
	anim.Think = function(_s, pnl, frac)
		local new_frac = Lerp(frac, 0, 1)
		local _w = Lerp(new_frac, _s.from_w, _s.to_w)
		local _h = Lerp(new_frac, _s.from_h, _s.to_h)

		pnl:SetSize(_w, _h)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end

	return anim
end)

CCR:AddPanelFunction("LerpPos", function(s, x, y, dur, callback)
	local anim = s:NewAnimation(dur or .1)
	anim.from_x, anim.from_y = s:GetPos()
	anim.to_x = x
	anim.to_y = y
	anim.Think = function(_s, pnl, frac)
		local new_frac = Lerp(frac, 0, 1)
		local _x = Lerp(new_frac, _s.from_x, _s.to_x)
		local _y = Lerp(new_frac, _s.from_y, _s.to_y)

		pnl:SetPos(_x, _y)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end

	return anim
end)

/*CCR:AddPanelFunction("LerpAlpha", function(s, to, dur, callback)
	local anim = s:NewAnimation(dur or .1)
	anim.from = s:GetAlpha()
	anim.to = to
	anim.Think = function(_s, pnl, frac)
		s:SetAlpha(Lerp(frac, 0, 1), _s.from, _s.to)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end
end)*/