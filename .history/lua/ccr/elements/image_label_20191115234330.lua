
local PANEL = {}

AccessorFunc(PANEL, "force_active", "ForceActive")

AccessorFunc(PANEL, "icon_size", "IconSize")
AccessorFunc(PANEL, "icon_gap", "IconGap")
AccessorFunc(PANEL, "icon", "Icon")
PANEL.SetIcon = function(s, icon)
	s.image.Material = icon
	s.icon = icon
end

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
AccessorFunc(PANEL, "color_icon", "IconColor")

function PANEL:Init()
	self:SetText("Undefined")
	self:SetFont("CCR.17")

	self:SetTextColor(color_white)
	self:SetIconColor(self:GetTextColor())

	self.label = self:Add(CCR:NewElement("DLabel"))
	self.label:SetFont(self:GetFont())
	self.label:SetTextColor(self:GetTextColor())

	self.image = self:Add("DImage")
	self.image.AutoSize = false
end

function PANEL:PerformLayout(w, h)

end

function PANEL:PostInit()
	self.CanLayout = true
end

CCR:RegisterElement("IconLabel", PANEL, "Panel")