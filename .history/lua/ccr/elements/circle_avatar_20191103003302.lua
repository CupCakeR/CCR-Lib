
//COPYRIGHT https://github.com/Threebow/tdlib/blob/master/tdlib.lua

local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create("AvatarImage", self)
	self.avatar:Dock(FILL)
	self.avatar:SetPaintedManually(true)

	self.SetPlayer = function(s, ply, size) s.avatar:SetPlayer(ply, size) end
	self.SetSteamID = function(s, id, size) s.avatar:SetSteamID(id, size) end

	self.poly = false
end

function PANEL:Paint(w, h)
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

	self:DrawMask(w, h)

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	self.avatar:SetPaintedManually(false)
	self.avatar:PaintManual()
	self.avatar:SetPaintedManually(true)

	render.SetStencilEnable(false)
	render.ClearStencil()
end

function PANEL:DrawMask(w, h)
	if !self.poly then
		//self.poly = CCR:DrawCircle(w / 2, h / 2, w / 2, color_white)
		self.poly = CCR:DrawArc(w / 2, h / 2, 0, 360, w / 2, color_white, 25)
	else
		surface.DrawPoly(self.poly)
	end
end

CCR:RegisterElement("CircleAvatar", PANEL, "Panel")