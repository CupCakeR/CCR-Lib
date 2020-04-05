local CLASS = {}
CLASS.__index = CLASS

CCR:AccessorFunc(CLASS, "addonId", "AddonID", "String")
CCR:AccessorFunc(CLASS, "languageId", "LanguageID", "String")
CCR:AccessorFunc(CLASS, "url", "URL", "String")
CCR:AccessorFunc(CLASS, "raw", "Raw", "Table")
CCR:AccessorFunc(CLASS, "phrases", "Phrases", "Table")
CCR:AccessorFunc(CLASS, "initialized", "Initialized", "Boolean")

CCR:ExtendClass(CLASS, "sh_prepare")
CCR:ExtendClass(CLASS, "sh_translate")

function CLASS.new(addonId, languageId)
  local _self = setmetatable({}, CLASS)

  _self.addonId = addonId
  _self.languageId = languageId
  _self.url = "https://gitlab.com/CupCakeR/ccr-languages/raw/master/" .. _self.addonId .. "/"
  _self.raw = {}
  _self.Initialized = false

  CLASS.CCR_CLASSNAME = "CCR.Language[" .. (addonId || "Undefined addon id") .. "][" .. (languageId || "Undefined language id") .. "]"
  CCR:AddClassFunctions(_self)

  hook.Run("CCR.NewLanguage", _self)

  return _self
end

function CLASS:__tostring()
  return CLASS.CCR_CLASSNAME
end

function CLASS:Register() end

function CCR:NewAddonLanguage(addonId, languageId)
  return CLASS.new(addonId, languageId)
end
