
local PANEL = {}

CCR:AccessorFunc(PANEL, "target", "Target")
CCR:AccessorFunc(PANEL, "disable_shadow", "DisableShadow", "Boolean")

function PANEL:Init()
	self:SetSize(1, 1)
	self:DockPadding(0, 4, 0, 4)

	self:SetPos(input.GetCursorPos())

	self.lastPanel = nil
end

function PANEL:PostInit()
	local target = self:GetTarget()
	assert(ispanel(target), "Target is invalid")

	self:RemoveUnusedSpacers()

	self:SetPos(input.GetCursorPos())

	self:InvalidateLayout(true)
	self:MakePopup()
	self:MoveToFront()

	return self
end

function PANEL:RemoveUnusedSpacers()
	for i, pnl in ipairs(self:GetChildren()) do
		if (pnl.isSpacer) then
			local left = #self:GetChildren() - i
			if (left == 0) then
				pnl:Remove()
				break
			end

			local f = 0
			for index = 1, left do
				local _pnl = self:GetChildren()[index + i]
				if (!_pnl.removed) then
					f = f + 1
				end
			end

			if (f == 0) then
				pnl:Remove()
			end
		end
	end
end

function PANEL:Spacer()
	local pnl = CCR:NewElement("Panel", self)
	pnl:DockMargin(0, 4, 0, 0)
	pnl:Dock(TOP)
	pnl:SetTall(1)
	pnl.Paint = function(s, w, h)
		surface.SetDrawColor(grey(50))
		surface.DrawRect(0, 0, w, h)
	end
	pnl.isSpacer = true

	return self
end

function PANEL:Option()
	local pnl = CCR:NewElement("ContextMenu.Entry", self)
	pnl:Dock(TOP)

	if (self.lastPanel != nil) then
		pnl:DockMargin(0, 4, 0, 0)
	end

	self.lastPanel = pnl

	return pnl
end

function PANEL:OnFocusChanged(b)
	if (!b) then
		self:Remove()
	end
end

function PANEL:PerformLayout(w, h)
	local _w, _h = 128, 0
	for i, pnl in ipairs(self:GetChildren()) do
		_w = math.max(_w, pnl.width || 0)
		_h = _h + pnl:GetTall() + 4
	end

	_h = _h + 4

	self:SetSize(_w, _h)
end

function PANEL:Think()
	if (!IsValid(self:GetTarget())) then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	if (self:GetDisableShadow()) then
		CCR:RoundedBox(0, 0, w, h, self:GetThemeColors().PanelBackground)
		return
	end

	local x, y = self:LocalToScreen()
	BSHADOWS.BeginShadow()
		CCR:RoundedBox(x, y, w, h, self:GetThemeColors().PanelBackground)
	BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
end

CCR:RegisterElement("ContextMenu", PANEL, "DPanel")



PANEL = {}

CCR:AccessorFunc(PANEL, "text", "Text", "String")
CCR:AccessorFunc(PANEL, "font", "Font", "String")
CCR:AccessorFunc(PANEL, "color", "Color", "Color")
CCR:AccessorFunc(PANEL, "icon", "Icon", "Material")
CCR:AccessorFunc(PANEL, "condition_func", "ConditionFunction", "Function")
CCR:AccessorFunc(PANEL, "func", "Function", "Function")

function PANEL:Init()
	self.text = "Undefined"
	self.font = "CCR.17.BOLD"
	self.color = grey(255)
	self.icon = nil

	self:SetCursor("hand")

	self.lerpVal = 0

	self.width = 0
end

function PANEL:OnCursorEntered()
	self:Lerp("lerpVal", 1)
end

function PANEL:OnCursorExited()
	self:Lerp("lerpVal", 0)
end

function PANEL:OnMousePressed(key)
	if (key == MOUSE_LEFT) then
		if (self:GetFunction()) then
			self:GetFunction()()
		end

		self:GetParent():Remove()
	end
end

function PANEL:PerformLayout(w, h)
	local tw, th = CCR:GetTextSize(self:GetText(), self:GetFont())
	self.width = 8 + tw + 8
	self:SetTall(4 + th + 4)
end

function PANEL:Finish()
	if (self:GetConditionFunction() && !self:GetConditionFunction()()) then
		self.removed = true
		self:Remove()
	end

	self:InvalidateLayout(true)

	return self:GetParent()
end

function PANEL:Paint(w, h)
	local textColor = CCR:LerpColor(self.lerpVal, ColorAlpha(self:GetColor(), 255 / 3), self:GetColor())
	CCR:DrawText(self:GetText(), self:GetFont(), 8, h / 2, textColor, "l", "c")
end

CCR:RegisterElement("ContextMenu.Entry", PANEL, "EditablePanel")



function CCR:NewContextMenu(target)
	local pnl = self:NewElement("ContextMenu")
	pnl:SetTarget(target)
	return pnl
end