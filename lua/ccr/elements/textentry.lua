local PANEL = {}

AccessorFunc(PANEL, "font", "Font")
AccessorFunc(PANEL, "placeholder", "Placeholder")
AccessorFunc(PANEL, "clr_text", "TextColor")
AccessorFunc(PANEL, "clr_placeholder", "PlaceholderColor")
AccessorFunc(PANEL, "clr_bg", "BackgroundColor")

function PANEL:Init()
  self:SetTextColor(rgb(200, 200, 200))
  self:SetPlaceholder("?")
  self:SetPlaceholderColor(Color(125, 125, 125))
  self:SetBackgroundColor(self:GetThemeColors().Primary)
  self:SetFont("CCR.13")

  self.textentry = self:Add("DTextEntry")
  self.textentry:Dock(FILL)
  self.textentry:DockMargin(8, 8, 8, 8)
  self.textentry:SetFont(self:GetFont())
  self.textentry:SetDrawLanguageID(false)
  self.textentry.placeholder = self:GetPlaceholder()
  self.textentry.color = self:GetTextColor()
  self.textentry.Paint = function(s, w, h)
    s:DrawTextEntryText(s.color, s.color, s.color)

    if (s:GetText() == "") and !s:HasFocus() then
      draw.SimpleText(s.placeholder, s:GetFont(), w / 2, h / 2, self:GetPlaceholderColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
  end
end

function PANEL:SetPlaceholder(txt)
  self.placeholder = txt

  if IsValid(self.textentry) then
    self.textentry.placeholder = txt
  end
end

function PANEL:SetTextColor(clr)
  self.clr_text = clr

  if IsValid(self.textentry) then
    self.textentry:SetTextColor(clr)
  end
end

function PANEL:SetFont(font)
  self.font = font

  if IsValid(self.textentry) then
    self.textentry:SetFont(font)
  end
end

function PANEL:GetTextEntry()
  return self.textentry
end

function PANEL:GetText()
  return self.textentry:GetText()
end

function PANEL:OnMousePressed()
  self.textentry:RequestFocus()
end

function PANEL:Paint(w, h)
  CCR:SetCacheTarget(self, "bg")
  CCR:RoundedBox(0, 0, w, h, self:GetBackgroundColor())
end

CCR:RegisterElement("TextEntry", PANEL, "EditablePanel")
