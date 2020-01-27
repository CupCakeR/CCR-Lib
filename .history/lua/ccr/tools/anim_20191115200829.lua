
CCR:AddPanelFunction("Lerp", function(s, key, to, dur, cb)
	local anim = s:NewAnimation(dur or .1)
	anim.from = s[key]
	anim.to = to
	anim.Think = function(_s, pnl, frac)
		s[key] = Lerp(Lerp(frac, 0, 1), _s.from, _s.to)
	end
	anim.OnEnd = function(_s)
		if (cb) then
			cb(s)
		end
	end
end)

CCR:AddPanelFunction("LerpColor", function(s, key, to, dur, callback)
	local anim = s:NewAnimation(dur or .1)
	anim.from = s[key]
	anim.to = to
	anim.Think = function(_s, pnl, frac)
		s[key] = CCR:LerpColor(Lerp(frac, 0, 1), _s.from, _s.to)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end
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

		s:SetSize(_w, _h)
	end
	anim.OnEnd = function(_s)
		if (callback) then
			callback(s)
		end
	end
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