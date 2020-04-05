local PANEL = {}

CCR:AccessorFunc(PANEL, "infinite_loading", "InfiniteLoading", "Boolean")

function PANEL:Init()
  local vbar = self:GetVBar()
  vbar:SetHideButtons(true)
  vbar:SetWide(10)


  vbar.Paint = function(s, w, h)

    CCR:CustomRoundedBox(4, 0, 0, w, h, self:GetThemeColors().Navbar, true, true, true, true)
  end

  vbar.btnGrip.Paint = function(s, w, h)

    CCR:CustomRoundedBox(4, 0, 0, w, h, self:GetThemeColors().Highlight, true, true, true, true)
  end





  self.old_OnMouseWheeled = self.OnMouseWheeled
  self.OnMouseWheeled = function(s, delta)
    self.old_OnMouseWheeled(s, delta)
    self:CheckInfiniteLoading()
  end
end

function PANEL:CheckInfiniteLoading()
  local bar = self:GetVBar()
  self:GetCanvas():DockPadding(0, 0, 8 + (bar:IsVisible() && 0 || 10), 0)

  if self:GetInfiniteLoading() then
    local cur = bar:GetScroll()
    local max = bar.CanvasSize

    if (cur >= max && !self.loading && self:CanLoadRequest()) then
      self.loadingIndicator = CCR:NewElement("DPanel", self)
      self.loadingIndicator:Dock(TOP)
      self.loadingIndicator:SetTall(64)
      self.loadingIndicator.Paint = function(s, w, h)
        CCR:DrawLoading(w / 2, h / 2, 50, color_white)
      end

      self:DoLoadRequest()

      self.loading = true
    end
  end
end

function PANEL:CanLoadRequest()
  return true
end

function PANEL:DoLoadRequest() end

function PANEL:OnLoaded()
  if (!self.loading) then return end

  self.loadingIndicator:Remove()
  self.loading = false

  self:InvalidateLayout(true)
end

function PANEL:Paint(w, h)
  local x, y = self:GetVBar():GetPos()
  local _w, _h = self:GetVBar():GetSize()
  CCR:CustomRoundedBox(4, x, y, _w, _h, self:GetThemeColors().Navbar, true, true, true, true)
end

CCR:RegisterElement("ScrollPanel", PANEL, "DScrollPanel")
