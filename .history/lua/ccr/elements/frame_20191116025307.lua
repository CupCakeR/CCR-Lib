
//TODO Remove everything except header

local PANEL = {}

AccessorFunc(PANEL, "title", "Title", FORCE_STRING)

function PANEL:Init()
	self:SetTitle("No title")

	self.header = CCR:NewElement("DPanel", self)
	self.header:Dock(TOP)
	self.header:SetTall(40)
	self.header.Paint = function(s, w, h)
		CCR:SetCacheTarget(s, "bg")
		CCR:RoundedBox(0, 0, w, h, s:GetThemeColors().Highlight, true, true, false, false)
		CCR:DrawShadowText(1, self:GetTitle(), "CCR.24", 10, h / 2, color_white, "l", "c")
	end

		self.close = CCR:NewElement("DPanel", self.header)
		self.close:SetCursor("hand")
		self.close.color_bg = self:GetThemeColors().Highlight
		self.close.color_x = self:GetThemeColors().Red
		self.close.Paint = function(s, w, h)
			CCR:SetCacheTarget(s, "bg")
			CCR:RoundedBox(0, 0, w, h, s.color_bg)

			local sub = 6
			surface.SetDrawColor(s.color_x)
			surface.SetMaterial(s:GetThemeMaterials().close)
			surface.DrawTexturedRect(sub / 2, sub / 2, h - sub, h - sub)
		end
		self.close.OnCursorEntered = function(s)
			s:LerpColor("color_bg", self:GetThemeColors().Red)
			s:LerpColor("color_x", color_white)
		end
		self.close.OnCursorExited = function(s)
			s:LerpColor("color_bg", self:GetThemeColors().Highlight)
			s:LerpColor("color_x", self:GetThemeColors().Red)
		end
		self.close.OnMousePressed = function(s, key)
			if key == MOUSE_LEFT then
				self:Remove() // TODO Animation
			end
		end

	self.header.PerformLayout = function(s, w, h)
		self.close:SetSize(h - 8, h - 8)
		self.close:SetPos(w - self.close:GetWide() - 4, 4)
	end

	/*self.container = CCR:NewElement("Panel", self)
	self.container:Dock(FILL)

	self.target = CCR:NewElement("Panel", self.container)

	self.nav = CCR:NewElement("SideNav", self.container)*/
end

function PANEL:PerformLayout(w, h)
	/*self.nav:SetSize(50, h)
	self.target:SetSize(w - 50, h)
	self.target:SetPos(50, 0)*/
	CCR:ResetCacheTarget(self)
	print("call?")
end

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen()
	BSHADOWS.BeginShadow()
		CCR:SetCacheTarget(self, "bg")
		CCR:RoundedBox(x, y, w, h, self:GetThemeColors().Background)
	BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
end

CCR:RegisterElement("Frame", PANEL, "EditablePanel")