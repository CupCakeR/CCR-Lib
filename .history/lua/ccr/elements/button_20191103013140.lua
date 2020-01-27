
local PANEL = {}

AccessorFunc(PANEL, "force_active", "ForceActive")

AccessorFunc(PANEL, "icon", "Icon")
AccessorFunc(PANEL, "icon_size", "IconSize")
AccessorFunc(PANEL, "icon_gap", "IconGap")
AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "font", "Font")

AccessorFunc(PANEL, "hover_alpha", "HoverAlpha")
AccessorFunc(PANEL, "outline", "Outline")
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "color_bg", "BackgroundColor")

function PANEL:Init()
	self:SetCursor("hand")
	self:SetText("Undefined")
	self:SetFont("CCR.17")

	self:SetOutline(1)
	self:SetBackgroundColor(self:GetThemeColors().Background)
	self:SetHoverAlpha(25)
end

function PANEL:PostInit()
	self.cur_alphahover = 0
	self.cur_colortext = self:GetColor()

	self.CanLayout = true
end

function PANEL:SetForceActive(b)
	self.force_active = b

	if b then
		self:OnCursorEntered()
	else
		self:OnCursorExited()
	end
end

function PANEL:OnCursorEntered()
	self:Lerp("cur_alphahover", 1)
	self:LerpColor("cur_colortext", color_white)
end

function PANEL:OnCursorExited()
	if self:GetForceActive() == true then return end

	self:Lerp("cur_alphahover", 0)
	self:LerpColor("cur_colortext", self:GetColor())
end

function PANEL:OnMousePressed(key)
	if key == MOUSE_LEFT then
		self:DoClick()
	end
end

function PANEL:DoClick() end

function PANEL:Paint(w, h)
	if !self.CanLayout then return end

	CCR:RoundedBox(0, 0, w, h, self:GetColor())
	CCR:RoundedBox(self:GetOutline(), self:GetOutline(), w - self:GetOutline() * 2, h - self:GetOutline() * 2, self:GetBackgroundColor())
	CCR:RoundedBox(self:GetOutline(), self:GetOutline(), w - self:GetOutline() * 2, h - self:GetOutline() * 2, ColorAlpha(self:GetColor(), self:GetHoverAlpha() * self.cur_alphahover ))

	local text, font = self:GetText(), self:GetFont()
	local x_add = 0
	if self:GetIcon() then
		surface.SetFont(font)
		local tw, _ = surface.GetTextSize(text)

		surface.SetDrawColor(self.cur_colortext)
		surface.SetMaterial(self:GetIcon())

		local size = self:GetIconSize() or h - 16
		local gap = self:GetIconGap() or 2
		surface.DrawTexturedRect(w / 2 - tw / 2 - size / 2 - gap, h / 2 - size / 2, size, size)
		x_add = size / 2 + gap
	end

	CCR:DrawText(text, font, w / 2 + x_add, h / 2, self.cur_colortext, "c", "c")
end

CCR:RegisterElement("Button", PANEL, "Panel")