CreateClientConVar("ccr_panel_scale", .5, true, false, "Base scale for all scalable panels")
cvars.AddChangeCallback("ccr_panel_scale", function(name, old, new)
  hook.Run("CCR.OnClientScaleChanged", new, old)
end)

local PANEL = {}

CCR:AccessorFunc(PANEL, "scale", "Scale", "Number")
CCR:AccessorFunc(PANEL, "use_client_scale", "UseClientScale", "Boolean")

function PANEL:Init()
  self.scale = 1
  self.use_client_scale = true

  self.__target_pos_x = 0
  self.__target_pos_y = 0





end

local cvar = GetConVar("ccr_panel_scale")
function PANEL:CalculateScale()
  return self:GetScale() * (self:GetUseClientScale() && cvar:GetFloat() || 1)
end

function PANEL:Paint(w, h)
  CCR:RoundedBox(0, 0, w, h, CCR:ThemeColors().Red)
  CCR:DrawText("Fucking paint me", "CCR.50.BOLD", w / 2, h / 2, color_white, "c", "c")
end

function PANEL:Register()
  self:SetPaintedManually(true)
  self:AddHook("PostDrawHUD", "CCR.DrawScalablePanel", function(s)
    local scale = s:CalculateScale()

    local x, y = s:GetPos()
    local width = s:GetWide() * scale
    local height = s:GetTall() * scale

    local mat = Matrix()
    mat:Translate(Vector(x, y))
    mat:Scale(Vector(scale, scale))
    mat:Translate(-Vector(0, 0))

    render.PushFilterMag(TEXFILTER.ANISOTROPIC)
    render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    cam.PushModelMatrix(mat)





    s:PaintAt(0, 0)
    cam.PopModelMatrix()
    render.PopFilterMag()
    render.PopFilterMin()

    local cx, cy = input.GetCursorPos()
    if (!gui.IsGameUIVisible() && cx >= x && cx <= (x + width) && cy >= y && cy <= (y + height)) then
      local x_pct = (cx - x) / width
      local y_pct = (cy - y) / height

      local wPct, hPct = s:GetWide() * x_pct, s:GetTall() * y_pct
      wPct = math.floor(wPct)
      hPct = math.floor(hPct)

      s:old_SetPos(cx - wPct, cy - hPct)
    else
      s:old_SetPos(-s:GetWide(), -s:GetTall())
    end
  end)
end

CCR:RegisterElement("ScalablePanel", PANEL, "EditablePanel")

function CCR:DetourHoverFunctionsForScalablePanel(pnl, parent)
  if (!IsValid(pnl)) then return end

  local old_OnCursorEntered = pnl.OnCursorEntered || function() end
  local old_OnCursorExited = pnl.OnCursorExited || function() end
  local old_Think = pnl.Think || function() end

  local expect = false
  function pnl:OnCursorEntered()
    if expect then
      old_OnCursorEntered(self)
    end
  end

  function pnl:OnCursorExited()
    if expect then
      old_OnCursorExited(self)
    end
  end

  local cur = 0
  function pnl:Think()
    if (self:IsHovered() && cur == 0) then
      expect = true
      self:OnCursorEntered()
      expect = false
      cur = 1
    elseif (!self:IsHovered() && cur == 1) then
      expect = true
      self:OnCursorExited()
      expect = false
      cur = 0
    end

    return old_Think(self)
  end
end



hook.Add("CCR.OnElementCreated", "CCR.ScalablePanelCompatibility", function(pnl, parent)
  timer.Simple(0, function()
    CCR:DetourHoverFunctionsForScalablePanel(pnl, parent)
  end)

  return s
end)

function CCR:ScalablePanelTest()
  if self.ScalablePanel then
    self.ScalablePanel:Remove()
  end

  local pnl = self:NewElement("ScalableFrame")
  pnl:SetSize(1500, 900 + 64)
  pnl:SetScale(1)
  pnl:Register()
  pnl:Center()
  pnl:MakePopup()

  local scroll = CCR:NewElement("ScrollPanel", pnl)
  scroll:Dock(FILL)
  scroll:DockMargin(0, 8, 8, 8)
  scroll:SetPaintChildrenManually(true)

  for i = 1, 100 do
    local gay = scroll:Add("Panel")
    gay:Dock(TOP)
    gay:DockMargin(0, 8, 0, 0)
    gay:SetPaintedManually(true)
    gay.Paint = function(s, w, h)
      draw.RoundedBox(0, 0, 0, w, h, color_white)
    end
  end

  pnl:AddHook("CCR.OnClientScaleChanged", "CCR.ScalableFrame", function(s)
    s:Center()
  end)

  self.ScalablePanel = pnl
end
