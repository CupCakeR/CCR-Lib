CCR.ImgurImages = CCR.ImgurImages || {}

local path = "ccr/imgur_images/"
local matError = Material("error")
local matLoading = Material("xenin/loading.png", "smooth")

local function dl(imageData)
  assert(imageData, "Invalid image data")

  imageData.type = imageData.type || "png"
  imageData.params = imageData.params || "smooth"

  local p = CCR:NewPromise()

  local img = file.Read(path .. imageData.id .. "." .. imageData.type, "DATA")
  if img then
    p:resolve(Material("../data/" .. path .. imageData.id .. "." .. imageData.type, imageData.params || "smooth"))
    return p
  end

  http.Fetch("https://i.imgur.com/" .. imageData.id .. "." .. imageData.type, function(body)
    file.CreateDir(path)
    file.Write(path .. imageData.id .. "." .. imageData.type, body)

    local mat = file.Read(path .. imageData.id .. "." .. imageData.type)
    if (!mat) then
      p:reject()
      return
    end

    CCR:Debug("Successfully downloaded Imgur image (" .. tostring(imageData.id) .. ")")

    p:resolve(Material("../data/" .. path .. imageData.id .. "." .. imageData.type, imageData.params))
  end, function()
    p:reject()
  end)

  return p
end

function CCR:GetImgurImage(imageId, imageData)
  if self.ImgurImages[imageId] then
    if istable(self.ImgurImages[imageId]) then
      return matLoading
    end

    return self.ImgurImages[imageId]
  end


  if (!imageData) then
    return matError
  end

  if isstring(imageData) then
    imageData = {
      id = imageData,
      type = "png"
    }
  end

  self.ImgurImages[imageId] = p

  dl(imageData):next(function(img)
    self.ImgurImages[imageId] = img
  end, function()
    CCR.PromiseError("Failed to download image - Name: " .. tostring(imageId} - ID: ${imageData.id))
  end)

  return matLoading
end
CCR.PrepareImgurImage = CCR.GetImgurImage


function CCR:DrawImgurImage(id, x, y, w, h, clr)
  if clr == nil then clr = color_white
  end
  local img = self:GetImgurImage(id)
  if (img == matLoading) then
    self:DrawLoading(x + w / 2, y + h / 2, math.max(math.min(w, h) / 2, 32), color_white)
    return
  elseif (!img) then
    return
  end

  surface.SetMaterial(img)
  surface.SetDrawColor(clr)
  surface.DrawTexturedRect(x, y, w, h)
end
