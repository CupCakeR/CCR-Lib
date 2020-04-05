local PANEL = {}

AccessorFunc(PANEL, "force_active", "ForceActive")

AccessorFunc(PANEL, "loading", "Loading", FORCE_BOOL)
AccessorFunc(PANEL, "blocked", "Blocked", FORCE_BOOL)

AccessorFunc(PANEL, "icon", "Icon")
AccessorFunc(PANEL, "icon_size", "IconSize")
AccessorFunc(PANEL, "icon_gap", "IconGap")
AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "font", "Font")

AccessorFunc(PANEL, "hover_alpha", "HoverAlpha")
AccessorFunc(PANEL, "outline", "Outline")
AccessorFunc(PANEL, "color", "Color")
AccessorFunc(PANEL, "colorBackground", "BackgroundColor")

function PANEL:Init()
  self:SetCursor("hand")
  self:SetText("Undefined")
  self:SetFont("CCR.17")

  self:SetOutline(1)
  self:SetBackgroundColor(self:GetThemeColors().PanelBackground)
  self:SetHoverAlpha(25)
end

function PANEL:SetBlocked(b)
  self:SetCursor(b and "no" or "hand")
  self.blocked = b
end

function PANEL:PostInit()
  self.curAlphaHover = 0
  self.curColorText = self:GetColor()

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
  if self:GetBlocked() then return end
  self:Lerp("curAlphaHover", 1)
  self:LerpColor("curColorText", color_white)
end

function PANEL:OnCursorExited()
  if self:GetForceActive() == true then return end
  self:Lerp("curAlphaHover", 0)
  self:LerpColor("curColorText", self:GetColor())
end

function PANEL:OnMousePressed(key)
  if key == MOUSE_LEFT and !self:GetBlocked() then
    self:DoClick()
  end
end

function PANEL:DoClick() end

function PANEL:Paint(w, h)
  if !self.CanLayout then return end

  CCR:SetCacheTarget(self, "bg")
  CCR:RoundedBox(0, 0, w, h, self:GetColor())

  CCR:SetCacheTarget(self, "outline")
  CCR:RoundedBox(self:GetOutline(), self:GetOutline(), w - self:GetOutline() * 2, h - self:GetOutline() * 2, self:GetBackgroundColor())

  CCR:SetCacheTarget(self, "hover")
  CCR:RoundedBox(self:GetOutline(), self:GetOutline(), w - self:GetOutline() * 2, h - self:GetOutline() * 2, ColorAlpha(self:GetColor(), self:GetHoverAlpha() * self.curAlphaHover))

  local text, font = self:GetText(), self:GetFont()
  local x_add = 0
  if self:GetIcon() and !self:GetLoading() then
    surface.SetFont(font)
    local tw, _ = surface.GetTextSize(text)

    surface.SetDrawColor(self.curColorText)
    surface.SetMaterial(self:GetIcon())

    local size = self:GetIconSize() or h - 16
    local gap = self:GetIconGap() or 2
    surface.DrawTexturedRect(w / 2 - tw / 2 - size / 2 - gap, h / 2 - size / 2, size, size)
    x_add = size / 2 + gap
  end

  if self:GetLoading() then
    CCR:DrawLoading(w / 2, h / 2, h / 2, self.curColorText)
  else
    CCR:DrawText(text, font, w / 2 + x_add, h / 2, self.curColorText, "c", "c")
  end
end


function PANEL:SizeToText(xGap, yGap)
  xGap = xGap or 16
  yGap = yGap or 8
  surface.SetFont(self:GetFont())
  local tw, th = surface.GetTextSize(self:GetText())
  self:SetSize(tw + xGap * 2, th + yGap * 2)
end

CCR:RegisterElement("Button", PANEL, "Panel")
