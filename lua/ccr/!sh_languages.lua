-- NOTE https://gitlab.com/sleeppyy/xeninui/blob/master/lua/xeninui/libs/languages.lua 

CCR.Languages = CCR.Languages or {}

if (!file.IsDir("ccr/languages", "DATA")) then
	file.CreateDir("ccr/languages")
end

local LANG = {}
LANG.Languages = {}

AccessorFunc(LANG, "m_url", "URL")
AccessorFunc(LANG, "m_folder", "Folder")
AccessorFunc(LANG, "m_activeLanguage", "ActiveLanguage")
AccessorFunc(LANG, "m_branch", "Branch")

function LANG:SetID(id)
	self.ID = id

	if (!file.IsDir("ccr/languages/" .. id, "DATA")) then
		file.CreateDir("ccr/languages/" .. id)
	end
end

function LANG:GetID()
	return self.ID
end

function LANG:GetFilePath(lang)
	return "ccr/languages/" .. self:GetID() .. "/" .. lang .. ".json"
end

function LANG:Exists(lang)
	return file.Exists(self:GetFilePath(lang), "DATA")
end

function LANG:SetLocalLanguage(lang, tbl)
	local _tbl = {}
	_tbl.cachedPhrases = {}
	table.Merge(_tbl, util.JSONToTable(tbl))

	self.Languages[lang] = _tbl
end

function LANG:Download(lang, overwrite)
	local p = CCR.Promises.new()
	if (self:GetLanguage(lang) and !overwrite) then
		return p:resolve(self:GetLanguage(lang))
	end

	local branch = self:GetBranch() or "master"
	local url = self:GetURL() .. "/raw/" .. branch .. "/" .. self:GetFolder() .. "/" .. lang .. ".json"

	http.Fetch(url, function(body, size, headers, code)
		if (body:sub(1, 15) == "<!DOCTYPE html>") then
			return p:reject(lang .. " language not found")
		end

		local tbl = util.JSONToTable(body)
		if (!tbl) then
			return p:reject("Unable to decode JSON")
		end

		file.Write(self:GetFilePath(lang), body)

		local _tbl = {}
		_tbl.cachedPhrases = {}
		table.Merge(_tbl, tbl)
		self.Languages[lang] = _tbl

		p:resolve(tbl, body, headers)
	end, function(err)
		p:reject(err)
	end)

	return p
end

function LANG:GetLanguage(lang)
	return self.Languages[lang]
end

function LANG:GetCachedPhrase(lang, phrase)
	local tbl = self:GetLanguage(lang)
	local str

	if (!tbl.cachedPhrases[phrase]) then
		local split = string.Explode(".", phrase)
		local outputPhrase = tbl.phrases
		for i, v in ipairs(split) do
			if (!outputPhrase[v]) then
				outputPhrase = nil

				break
			end

			outputPhrase = outputPhrase[v]
		end

		str = outputPhrase
		tbl.cachedPhrases[phrase] = outputPhrase
	else
		str = tbl.cachedPhrases[phrase]
	end

	return str
end

function LANG:GetPhrase(phrase, replacement)
	local activeLang = self:GetActiveLanguage()
	local str = self:GetCachedPhrase(activeLang, phrase)
	if (!str and activeLang != "english") then
		str = self:GetCachedPhrase("english", phrase)

		if (!str) then
			str = phrase
		end
	end

	if (replacement) then
		for i, v in pairs(replacement) do
			str = str:Replace(":" .. i .. ":", v)
		end
	end

	return str
end

function CCR:Language(id)
	if (self.Languages[id]) then
		return self.Languages[id]
	end

	local tbl = table.Copy(LANG)
	tbl:SetID(id)

	self.Languages[id] = tbl

	return tbl
end
