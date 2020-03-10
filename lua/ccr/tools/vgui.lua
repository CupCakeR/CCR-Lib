
function CCR:NewElement(class, parent, name)
	//class = string.StartWith(class, "!") and (class) or ("CCR." .. class)

	if string.StartWith(class, "!") then
		class = class:Right(#class - 1)
	else
		class = "CCR." .. class
	end

	local pnl = vgui.Create(class, parent, name)
	CCR:AddPanelID(pnl)

	hook.Run("CCR.OnElementCreated", pnl, parent, class, name)

	return pnl
end

function CCR:RegisterElement(class, tbl, base)
	self:Debug("Registered element \"" .. "CCR." .. class .. "\"" )

	CCR:PreparePanelTheme(tbl)
	CCR:PreparePanelFunctions(tbl)

	return vgui.Register("CCR." .. class, tbl, base)
end

function CCR:GetFullElementName(class)
	return "CCR." .. class
end

function CCR:CopyAndPrepareDefaultElement(class)
	self:RegisterElement(class, {}, class)
end