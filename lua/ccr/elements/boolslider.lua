local PANEL = {}

AccessorFunc(PANEL, "text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "font", "Font", FORCE_STRING)
AccessorFunc(PANEL, "state", "State", FORCE_BOOL)
AccessorFunc(PANEL, "color_bg", "BackgroundColor")
AccessorFunc(PANEL, "color_text", "TextColor")
AccessorFunc(PANEL, "color_on", "OnColor")
AccessorFunc(PANEL, "color_off", "OffColor")

function PANEL:Init()
  self.text = "?"
  self.font = "CCR.16"
  self.state = false
  self.color_bg = self:GetThemeColors().PanelBackground
  self.color_text = grey(200)
  self.color_off, self.color_on = grey(75), grey(175)
end

function PANEL:PostInit()





  self.slider = CCR:NewElement("Panel", self)
  self.slider:SetCursor("hand")
  self.slider:SetSize(64, 24)
  self.slider.state = self:GetState() || false
  self.slider.lerp = self:GetState() && 1 || 0
  self.slider.Paint = function(s, w, h)
    CCR:RoundedBox(0, 0, w, h, self:GetBackgroundColor())

    local sliderColor = CCR:LerpColor(s.lerp, self:GetOffColor(), self:GetOnColor())

    local _w = w / 2 - (2 * 3)
    local x = Lerp(s.lerp, 3, w - _w - 3)
    CCR:RoundedBox(x, 3, _w, h - (2 * 3), sliderColor)
  end
  self.slider.OnMousePressed = function(s, key)
    if key == MOUSE_LEFT then
      s.state = !s.state
      s:Lerp("lerp", s.state && 1 || 0)

      self:OnStateChanged(s.state)
    end
  end

  self.can_layout = true
end

function PANEL:OnStateChanged(b) end

function PANEL:PerformLayout(w, h)
  if !self.can_layout then return end

  self.slider:SetPos(w - self.slider:GetWide())
  self.slider:CenterVertical()



end

function PANEL:Paint(w, h)
  CCR:DrawText(self:GetText(), self:GetFont(), 0, h / 2, self:GetTextColor(), "l", "c")
end

CCR:RegisterElement("BoolSlider", PANEL, "Panel")
