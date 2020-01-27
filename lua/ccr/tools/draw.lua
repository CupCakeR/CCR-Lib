
function CCR:Mask(funcCut, funcDraw)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	draw.NoTexture()
	surface.SetDrawColor(255, 255, 255, 255)

	funcCut()

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	funcDraw()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function CCR:MaskInverse(funcCut, funcDraw)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.DepthRange(0, 1)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	funcCut()

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(0)

	funcDraw()

	render.DepthRange(0, 1)
	render.SetStencilEnable(false)
	render.ClearStencil()

end

// TDLib https://github.com/Threebow/tdlib/blob/master/tdlib.lua
function CCR:DrawCircle(x, y, r, col)
	local poly = {}

	for i = 1, 360 do
		poly[i] = {}
		poly[i].x = x + math.cos(math.rad(i * 360) / 360) * r
		poly[i].y = y + math.sin(math.rad(i * 360) / 360) * r
	end

	surface.SetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly(poly)

	return poly
end

function CCR:DrawArc(x, y, ang, p, rad, clr, seg)
	seg = seg || 80
	ang = (-ang) + 180
	local poly = {}

	table.insert(poly, {x = x, y = y})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(poly, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
	end

	surface.SetDrawColor(clr)
	draw.NoTexture()
	surface.DrawPoly(poly)

	return poly
end

function CCR:DrawCachedArc(poly, clr)
	surface.SetDrawColor(clr)
	draw.NoTexture()
	surface.DrawPoly(poly)
end

function CCR:CustomRoundedBox(rad, x, y, w, h, clr, tl, tr, bl, br)
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	rad = math.Clamp(math.floor(rad), 0, math.min(h / 2, w / 2))

	if (rad == 0) then
		surface.SetDrawColor(clr)
		surface.DrawRect(x, y, w, h)

		return
	end

	surface.SetDrawColor(clr)
	surface.DrawRect(x + rad, y, w - rad * 2, rad)
	surface.DrawRect(x, y + rad, w, h - rad * 2)
	surface.DrawRect(x + rad, y + h - rad, w - rad * 2, rad)

	if (tl) then
		local index = "roundedbox.tl"
		local cache = self:GetDrawCache(index)
		if cache then
			self:DrawCachedArc(cache, clr)
		else
			self:AddDrawCache(index, CCR:DrawArc(x + rad, y + rad, 270, 90, rad, clr, rad))
		end
	else
		surface.SetDrawColor(clr)
		surface.DrawRect(x, y, rad, rad)
	end

	if (tr) then
		local index = "roundedbox.tr"
		local cache = self:GetDrawCache(index)
		if cache then
			self:DrawCachedArc(cache, clr)
		else
			self:AddDrawCache(index, CCR:DrawArc(x + w - rad, y + rad, 0, 90, rad, clr, rad))
		end
	else
		surface.SetDrawColor(clr)
		surface.DrawRect(x + w - rad, y, rad, rad)
	end

	if (bl) then
		local index = "roundedbox.bl"
		local cache = self:GetDrawCache(index)
		if cache then
			self:DrawCachedArc(cache, clr)
		else
			self:AddDrawCache(index, CCR:DrawArc(x + rad, y + h - rad, 180, 90, rad, clr, rad))
		end
	else
		surface.SetDrawColor(clr)
		surface.DrawRect(x, y + h - rad, rad, rad)
	end

	if (br) then
		local index = "roundedbox.br"
		local cache = self:GetDrawCache(index)
		if cache then
			self:DrawCachedArc(cache, clr)
		else
			self:AddDrawCache(index, CCR:DrawArc(x + w - rad, y + h - rad, 90, 90, rad, clr, rad))
		end
	else
		surface.SetDrawColor(clr)
		surface.DrawRect(x + w - rad, y + h - rad, rad, rad)
	end

	self:ClearCacheTarget()
end

hook.Add("CCR.NewTheme", "AddOption:BoxRoundness", function(theme)
	AccessorFunc(theme, "box_roundness", "BoxRoundness", FORCE_NUMBER)
	theme:SetBoxRoundness(6)
end)

function CCR:RoundedBox(x, y, w, h, clr, tl, tr, bl, br)
	if tl != nil or tr != nil or bl != nil or br != nil then
		self:CustomRoundedBox(self:GetTheme():GetBoxRoundness(), x, y, w, h, clr, tl, tr, bl, br)
	else
		self:CustomRoundedBox(self:GetTheme():GetBoxRoundness(), x, y, w, h, clr, true, true, true, true)
	end
end

// TODO: Add xenin mat to our lib
local matLoading = Material("xenin/loading.png", "smooth")
function CCR:DrawLoading(x, y, size, col)
	surface.SetMaterial(matLoading)
	surface.SetDrawColor(col)
	surface.DrawTexturedRectRotated(x, y, size, size, ((CurTime()) % 360) * -100)
end

local blur = Material("pp/blurscreen")
function CCR:DrawPanelBlur(pnl, amt, add)
	local x, y = pnl:LocalToScreen(0, 0)
	local w, h = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amt || 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, w, h)
	end
end