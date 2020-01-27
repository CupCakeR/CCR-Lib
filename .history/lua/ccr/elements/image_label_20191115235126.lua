
local PANEL = {}

AccessorFunc(PANEL, "force_active", "ForceActive")

AccessorFunc(PANEL, "icon_size", "IconSize")
AccessorFunc(PANEL, "icon_gap", "IconGap")
AccessorFunc(PANEL, "icon", "Icon")
AccessorFunc(PANEL, "text", "Text")
PANEL.SetText = function(s, text)
	s.label:SetText(text)
	s.text = text
end
AccessorFunc(PANEL, "font", "Font")
PANEL.SetFont = function(s, font)
	s.label:SetFont(font)
	s.font = font
end
AccessorFunc(PANEL, "color_text", "TextColor")
PANEL.SetTextColor = function(s, clr)
	s.label:SetTextColor(clr)
	s.color_text = clr
end
AccessorFunc(PANEL, "color_icon", "IconColor")

function PANEL:Init()
	self:SetText("Undefined")
	self:SetFont("CCR.17")

	self:SetTextColor(color_white)
	self:SetIconColor(self:GetTextColor())

	self.label = self:Add(CCR:NewElement("DLabel"))
	self.label:SetFont(self:GetFont())
	self.label:SetTextColor(self:GetTextColor())

	self.image = self:Add(CCR:NewElement("Panel"))
	self.image.Paint = function(s, w, h)
		surface.SetDrawColor(self:GetIconColor())
		surface.SetMaterial(self:GetIcon())
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

function PANEL:PerformLayout(w, h)
	if !self.can_layout then return end

	self.label:SizeToContents()
	self.image:SetSize(self:GetIconSize(), self:GetIconSize())

	self.image:SetPos(w / 2 - self.label:GetWide() / 2 - self:GetIconGap(), 0)
	self.image:CenterVertical()

	self.label:SetPos(w / 2 + self:GetIconGap() + self.label:GetWide() / 2, 0)
	self.label:CenterVertical()
end

function PANEL:PostInit()
	self.can_layout = true
end

CCR:RegisterElement("IconLabel", PANEL, "Panel")