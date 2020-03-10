
// TODO: Add BSHADOWS support

CreateClientConVar("ccr_panel_scale", .5, true, false, "Base scale for all scalable panels")

local PANEL = {}

CCR:AccessorFunc(PANEL, "scale", "Scale", "Number")
CCR:AccessorFunc(PANEL, "use_client_scale", "UseClientScale", "Boolean")

function PANEL:Init()
	self.scale = 1
	self.use_client_scale = true

	self.__target_pos_x = 0
	self.__target_pos_y = 0

	self.old_SetPos = self.SetPos
	function self:SetPos(x, y)
		self.__target_pos_x = x
		self.__target_pos_y = y

		return self
	end

	// TODO: GetScaledPos instead
	self.old_GetPos = self.GetPos
	function self:GetPos()
		return self.__target_pos_x, self.__target_pos_y
	end

	self.old_Center = self.Center
	function self:Center()
		local w, h = self:GetScaledSize()
		self:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)
		print(self:GetPos())
	end

	function self:GetScaledSize()
		local scale = self:CalculateScale()
		return self:GetWide() * scale, self:GetTall() * scale
	end

	function self:GetScaledWidth()
		return select(1, self:GetScaledSize())
end

	function self:GetScaledHeight()
		return select(2, self:GetScaledSize())
	end
end

function PANEL:CalculateScale()
	return self:GetScale() * (self:GetUseClientScale() && GetConVar("ccr_panel_scale"):GetFloat() || 1)
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

		print(x, y)

		local mat = Matrix()
		mat:Translate(Vector(x, y))
		mat:Scale(Vector(scale, scale))
		mat:Translate(-Vector(0, 0))

		render.PushFilterMag(TEXFILTER.ANISOTROPIC)
		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
			cam.PushModelMatrix(mat)
				/*BSHADOWS.BeginShadow()
					CCR:CustomRoundedBox(12 * (1 + scale), x, y, width, height, color_white, true, true, true, true)
				BSHADOWS.EndShadow(2, 2, 2, 255, 0, 0, true)*/
				s:PaintAt(0, 0)
			cam.PopModelMatrix()
		render.PopFilterMag()
		render.PopFilterMin()

		local cx, cy = input.GetCursorPos()
		if (cx >= x && cx <= (x + width) && cy >= y && cy <= (y + height)) then
			local x_pct = (cx - x) / width
			local y_pct = (cy - y) / height

			local wPct, hPct = s:GetWide() * x_pct, s:GetTall() * y_pct
			wPct = math.ceil(wPct)
			hPct = math.ceil(hPct)

			s:old_SetPos(cx - wPct, cy - hPct)
		else
			s:old_SetPos(-s:GetWide(), -s:GetTall())
		end
	end)
end

CCR:RegisterElement("ScalablePanel", PANEL, "EditablePanel")

function CCR:ScalablePanelTest()
	if (self.ScalablePanel) then
		self.ScalablePanel:Remove()
	end

	local pnl = self:NewElement("ScalablePanel")

	timer.Simple(1, function()
		if IsValid(pnl) then pnl:Remove() end
	end)

	pnl:SetSize(1000, 700)
	pnl:SetScale(1.5)
	pnl:Center()
	pnl:Register()

	self.ScalablePanel = pnl
end