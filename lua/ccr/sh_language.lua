
CCR.AddonLanguages = CCR.AddonLanguages || {}

function CCR:GetAddonLanguage(addonId, languageId)
	self.AddonLanguages[addonId] = self.AddonLanguages[addonId] || {}

	local addonTbl = self.AddonLanguages[addonId]
	if (addonTbl && addonTbl[languageId]) then
		return addonTbl[languageId]
	end

	local object = self:NewAddonLanguage(addonId, languageId)
	object:Initialize()

	self.AddonLanguages[addonId][languageId] = object

	return object
end

CCR.CanInitializeLanguage = CCR.CanInitializeLanguage || false
hook.Add("InitPostEntity", "CCR.DoInitializeLanguage", function()
	timer.Simple(3, function()
		CCR.CanInitializeLanguage = true
		hook.Run("CCR.DoInitializeLanguage")
	end)
end)

// TODO: Allow addon to register here somehow
// TODO: Write better fucking comments so I know what I fucking mean the next time I look at it