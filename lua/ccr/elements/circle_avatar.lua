
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
	CCR:Mask(function()
		self:DrawMask(w, h)
	end, function()
		self.avatar:SetPaintedManually(false)
		self.avatar:PaintManual()
		self.avatar:SetPaintedManually(true)
	end)
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