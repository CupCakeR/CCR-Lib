
// TODO: Fully port to CCR

local PANEL = {}

AccessorFunc(PANEL, "_text", "Text", FORCE_STRING)
AccessorFunc(PANEL, "_font", "Font", FORCE_STRING)
AccessorFunc(PANEL, "_value", "Value", FORCE_NUMBER)
AccessorFunc(PANEL, "_min", "Min", FORCE_NUMBER)
AccessorFunc(PANEL, "_max", "Max", FORCE_NUMBER)
AccessorFunc(PANEL, "_decimals", "Decimals", FORCE_NUMBER)
AccessorFunc(PANEL, "_slider_color", "SliderColor")

function PANEL:Init()
	self._text = "?"
	self._value = 0
	self._min = 0
	self._max = 10
	self._decimals = 0
	self._slider_color = color_white
end

function PANEL:PostInit()
	self.text = self:Add("DLabel")
	self.text:SetText(self:GetText())
	self.text:SetFont(self:GetFont() or "CCR.12")
	self.text:SetColor(color_white)
	self.text:SetAlpha(255)
	self.text:Dock(LEFT)
	self.text:SizeToContents()

	self.display = self:Add("DLabel")
	self.display:SetText(self:GetValue())
	self.display:SetTextColor(rgb(200, 200, 200))
	self.display:SetFont("CCR.18")
	self.display.Paint = function(s, w, h)
		surface.DisableClipping(true)
			draw.RoundedBox(6, -4, -2, w + 8, h + 4, self:GetThemeColors().Background)
		surface.DisableClipping(false)
	end

	local mat = Material("nicksys/circle.png", "smooth")
	self.slider = self:Add("DPanel")
	self.slider:SetCursor("hand")
	self.slider:SetSize(100, 24)
	self.slider.min = self:GetMin()
	self.slider.max = self:GetMax()
	self.slider.decimals = self:GetDecimals()
	self.slider.Paint = function(s, w, h)
		surface.SetDrawColor(self:GetThemeColors().Primary)
		surface.DrawLine(h / 2, h / 2, w - (h / 2), h / 2)

		local frac = math.Clamp((self:GetValue() - self:GetMin()) / (self:GetMax() - self:GetMin()), 0, 1)
		local pos = Lerp(frac, 0, w - h)
		surface.SetDrawColor(self._slider_color)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(pos, 0, h, h)

		if s.focus then
			if !input.IsButtonDown(MOUSE_LEFT) then
				s.focus = false
				return
			end

			local mx, _ = s:CursorPos()
			mx = math.Clamp(mx, 0, w)
			self:SetValue(Lerp(mx / w, self:GetMin(), self:GetMax()))
		end
	end
	self.slider.OnMousePressed = function(s, key)
		s.focus = true
	end

	self.can_layout = true
end

function PANEL:SetValue(val, prevent)
	val = math.Round(val, self:GetDecimals())
	val = math.Clamp(val, self:GetMin(), self:GetMax())

	self._value = val

	if IsValid(self.display) then
		self.display:SetText(self:GetValue())
		self.display:SizeToContents()
	end

	if !prevent then
		self:OnValueChanged(val)
	end
end

function PANEL:SetMin(min)
	self._min = min

	if min > self:GetValue() then
		self:SetValue(min)
	end
end

function PANEL:SetMax(max)
	self._max = max

	if max < self:GetValue() then
		self:SetValue(max)
	end
end

function PANEL:OnValueChanged(val) end

function PANEL:PerformLayout(w, h)
	if !self.can_layout then return end

	self.slider:SetPos(w - self.slider:GetWide())
	self.slider:CenterVertical()

	self.display:SizeToContents()
	self.display:CenterVertical()
	self.display:MoveLeftOf(self.slider, 8)

	self.text:CenterVertical()

	self:SetSize(w, math.max(self.text:GetTall(), self.slider:GetTall()))
end

function PANEL:Paint(w, h)
end

CCR:RegisterElement("NumSlider", PANEL, "Panel")