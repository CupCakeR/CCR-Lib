
//TODO Remove everything except header

local PANEL = {}

CCR:AccessorFunc(PANEL, "title", "Title", "String")
CCR:AccessorFunc(PANEL, "matBranding", "BrandingMaterial", "Material")

function PANEL:Init()
	self:SetTitle("No title")

	self.header = CCR:NewElement("DPanel", self)
	self.header:Dock(TOP)
	self.header:SetTall(40)
	self.header.Paint = function(s, w, h)
		CCR:SetCacheTarget(s, "header")
		CCR:RoundedBox(0, 0, w, h, s:GetThemeColors().Highlight, true, true, false, false)

		local xOff = 0
		if (self:GetBrandingMaterial()) then
			local size = 32
			surface.SetDrawColor(color_white)
			surface.SetMaterial(self:GetBrandingMaterial())
			surface.DrawTexturedRect(h / 2 - size / 2, h / 2 - size / 2, size, size)

			xOff = h / 2 + size / 2 - 4
		end
		CCR:DrawShadowText(1, self:GetTitle(), "CCR.24", xOff + 10, h / 2, color_white, "l", "c")
	end

		self.close = CCR:NewElement("DPanel", self.header)
		self.close:SetCursor("hand")
		self.close:Dock(RIGHT)
		self.close:DockMargin(4, 4, 4, 4)
		self.close.colorBackground = self:GetThemeColors().Highlight
		self.close.colorMaterial = self:GetThemeColors().Red
		self.close.Paint = function(s, w, h)
			CCR:SetCacheTarget(s, "bg")
			CCR:RoundedBox(0, 0, w, h, s.colorBackground)

			local sub = 6
			surface.SetDrawColor(s.colorMaterial)
			surface.SetMaterial(s:GetThemeMaterials().close)
			surface.DrawTexturedRect(sub / 2, sub / 2, h - sub, h - sub)
		end
		self.close.OnCursorEntered = function(s)
			s:LerpColor("colorBackground", self:GetThemeColors().Red)
			s:LerpColor("colorMaterial", color_white)
		end
		self.close.OnCursorExited = function(s)
			s:LerpColor("colorBackground", self:GetThemeColors().Highlight)
			s:LerpColor("colorMaterial", self:GetThemeColors().Red)
		end
		self.close.OnMousePressed = function(s, key)
			if key == MOUSE_LEFT then
				self:Remove() // TODO Animation
			end
		end

	self.header.PerformLayout = function(s, w, h)
		self.close:SetWide(self.close:GetTall())
	end
end

function PANEL:PerformLayout(w, h)
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen()
	BSHADOWS.BeginShadow()
		CCR:SetCacheTarget(self, "bg")
		CCR:RoundedBox(x, y, w, h, self:GetThemeColors().Background)
	BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
end

CCR:RegisterElement("Frame", PANEL, "EditablePanel")