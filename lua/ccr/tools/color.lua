
// NOTE globals because i have to get used to it anyway
rgb = Color
rgba = Color
grey = function(n, a)
	return rgb(n, n, n, a or 255)
end
gray = grey

// COPYRIGHT https://gist.github.com/jasonbradley/4357406#file-gistfile1-lua
function hex(hex)
	hex = hex:gsub("#", "")
	return rgb(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)))
end

// COPYRIGHT https://github.com/minism/leaf/blob/master/color.lua
local COLOR = FindMetaTable("Color")

//if COLOR.ToHSL then // NOTE: Available in the next update (?)
	function COLOR:ToHSL()
		local r, g, b = self.r/255, self.g/255, self.b/255
		local min, max = math.min(r, g, b), math.max(r, g, b)
		local h, s, l = 0, 0, (max + min) / 2
		if max ~= min then
			local d = max - min
			s = l > 0.5 and d / (2 - max - min) or d / (max + min)
			if max == r then
				local mod = 6
				if g > b then mod = 0 end
				h = (g - b) / d + mod
			elseif max == g then
				h = (b - r) / d + 2
			else
				h = (r - g) / d + 4
			end
		end
		h = h / 6
		return h * 255, s * 255, l * 255, self.a
	end
//end

//if HSLToColor then
	// WARNING: Won't have the a param next update
	function HSLToColor(h, s, l, a)
		if s <= 0 then return l, l, l, a end

		h, s, l = h / 256 * 6, s / 255, l / 255
		local c = (1 - math.abs(2 * l - 1)) * s
		local x = (1 - math.abs(h % 2 - 1)) * c
		local m,r,g,b = (l - .5 * c), 0, 0, 0

		if h < 1 then
			r,g,b = c,x,0
		elseif h < 2 then
			r,g,b = x,c,0
		elseif h < 3 then
			r,g,b = 0,c,x
		elseif h < 4 then
			r,g,b = 0,x,c
		elseif h < 5 then
			r,g,b = x,0,c
		else
			r,g,b = c,0,x
		end

		return rgba((r + m) * 255, (g + m) * 255, (b + m) * 255, a)
	end
//end

function COLOR:Shift(delta)
	local a = self.a
	if !delta then a, delta = delta, a end
	local h, s, l = self:ToHSL()
	return HSLToColor((h + delta) % 255, s, l, a)
end

function COLOR:Lighten(delta)
	local h, s, l = self:ToHSL()
	return HSLToColor(h, s, math.Clamp(l + delta, 0, 255), self.a)
end

function COLOR:Darken(delta)
	local a = self.a
	if !delta then a, delta = delta, a end
	return self:Lighten(-delta)
end

function COLOR:Saturate(delta)
	local a = self.a
	if !delta then a, delta = delta, a end
	local h, s, l = self:ToHSL()
	return HSLToColor(h, math.Clamp(s + delta, 0, 255), l, a)
end

function COLOR:Desaturate(delta)
	local a = self.a
	if !delta then a, delta = delta, a end
	return self:Saturate(-delta)
end

function CCR:LerpColor(frac, from, to)
	local clr = rgba(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)

	return clr
end

function CCR:GetColorDistance(a, b)
	return math.sqrt((b.r - a.r) ^ 2 + (b.g - a.g) ^ 2 + (b.b - a.b) ^ 2)
end