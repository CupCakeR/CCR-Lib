
local CLASS = {}

function CLASS:Download(cb)
	local url = self:GetURL()
	assert(url, "URL is not set")

	url = url .. self:GetLanguageID() .. ".json"

	http.Fetch(url, function(body, size, headers, code)
		if (body:sub(1, 15) == "<!DOCTYPE html>") then
			error("Language not found / invalid response")
		end

		local tbl = util.JSONToTable(body)
		assert(tbl, "Body is no valid JSON")

		hook.Run("CCR.OnLanguageDownloaded", self, tbl)

		cb(tbl)
	end)
end

function CLASS:PreparePhrases()
	local copy = table.Copy(self:GetRaw()["phrases"])
	local new = CCR:FlattenTable(copy, ".", true)

	self:SetPhrases(new)
end

function CLASS:Queue()
	self:AddHook("CCR.DoInitializeLanguage", function()
		self:Initialize()
	end)
end

function CLASS:Initialize(force)
	if (self:GetInitialized() && !force) then
		error("Tried to initialize language object but it was already initialized.")
	end

	if (!CCR.CanInitializeLanguage) then
		self:Queue()
		return
	end

	self:Download(function(tbl)
		self:SetRaw(tbl)
		self:PreparePhrases()
		self:SetInitialized(true)

		hook.Run("CCR.OnLanguageInitialized", self, tbl)
	end)
end

return CLASS