
local CLASS = {}

function CLASS:GetPhrase(phrase, replacements)
	assert(phrase, "No phrase to translate")

	local str = self:GetPhrases()[phrase]
	if (!str && self:GetLanguageID() != "english") then
		// Get english language and fallback
	end

	if (!str) then
		return "UNKNOWN: " .. phrase
	end

	if (replacements) then
		for i, v in pairs(replacements) do
			str = str:Replace(":" .. i .. ":", v)
		end
	end

	return str
end

return CLASS