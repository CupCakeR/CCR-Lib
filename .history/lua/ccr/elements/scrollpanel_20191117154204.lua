
local PANEL = {}

function PANEL:Init()
	local vbar = self:GetVBar()
	vbar:SetHideButtons(true)
	vbar:SetWide(10)

	vbar.Paint = function(s, w, h)
		//CCR:SetCacheTarget(self, "vbar")
		CCR:CustomRoundedBox(4, 0, 0, w, h, self:GetThemeColors().Navbar, true, true, true, true)
	end

	vbar.btnGrip.Paint = function(s, w, h)
		//CCR:SetCacheTarget(self, "grip")
		CCR:CustomRoundedBox(4, 0, 0, w, h, self:GetThemeColors().Highlight, true, true, true, true)
	end
end

CCR:RegisterElement("ScrollPanel", PANEL, "DScrollPanel")