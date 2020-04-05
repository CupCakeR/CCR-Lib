function CCR:Test()
  if IsValid(self.TestFrame) then
    self.TestFrame:Remove()
  end

  self.TestFrame = CCR:NewElement("Frame")
  self.TestFrame:SetSize(500, 400)
  self.TestFrame:Center()
  self.TestFrame:MakePopup()
end
