
CCR.Themes = CCR.Themes or {}

local current_id = "material_dark"

function CCR:RegisterTheme(obj)
	self.Themes[obj:GetID()] = obj
	self:Debug("Registered theme \"" .. obj:GetName() .. "\"")
end

function CCR:GetTheme()
	return self:GetThemeByID(current_id)
end

function CCR:GetThemeByID(id)
	return self.Themes[id]
end

function CCR:PreparePanelTheme(pnl)
	AccessorFunc(pnl, "theme", "Theme")
	pnl:SetTheme(self:GetTheme())

	function pnl:GetThemeColors()
		return self:GetTheme():GetColors()
	end

	function pnl:GetThemeMaterials()
		return self:GetTheme():GetMaterials()
	end
end