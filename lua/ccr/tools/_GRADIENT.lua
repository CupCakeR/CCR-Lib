local mat_white = Material("vgui/white")

function draw.SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
  draw.LinearGradient(x, y, w, h, {
    {
      offset = 0, color = startColor}, {
      offset = 1, color = endColor}}, horizontal)
end





function draw.LinearGradient(x, y, w, h, stops, horizontal)
  if #stops == 0 then
    return
  elseif #stops == 1 then
    surface.SetDrawColor(stops[1].color)
    surface.DrawRect(x, y, w, h)
    return
  end

  table.SortByMember(stops, "offset", true)

  render.SetMaterial(mat_white)
  mesh.Begin(MATERIAL_QUADS, #stops - 1)
  for i = 1, #stops - 1 do
    local offset1 = math.Clamp(stops[i].offset, 0, 1)
    local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
    if offset1 == offset2 then continue end

    local deltaX1, deltaY1, deltaX2, deltaY2

    local color1 = stops[i].color
    local color2 = stops[i + 1].color

    local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
    local r2, g2, b2, a2
    local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
    local r4, g4, b4, a4

    if horizontal then
      r2, g2, b2, a2 = r3, g3, b3, a3
      r4, g4, b4, a4 = r1, g1, b1, a1
      deltaX1 = offset1 * w
      deltaY1 = 0
      deltaX2 = offset2 * w
      deltaY2 = h
    else
      r2, g2, b2, a2 = r1, g1, b1, a1
      r4, g4, b4, a4 = r3, g3, b3, a3
      deltaX1 = 0
      deltaY1 = offset1 * h
      deltaX2 = w
      deltaY2 = offset2 * h
    end

    mesh.Color(r1, g1, b1, a1)
    mesh.Position(Vector(x + deltaX1, y + deltaY1))
    mesh.AdvanceVertex()

    mesh.Color(r2, g2, b2, a2)
    mesh.Position(Vector(x + deltaX2, y + deltaY1))
    mesh.AdvanceVertex()

    mesh.Color(r3, g3, b3, a3)
    mesh.Position(Vector(x + deltaX2, y + deltaY2))
    mesh.AdvanceVertex()

    mesh.Color(r4, g4, b4, a4)
    mesh.Position(Vector(x + deltaX1, y + deltaY2))
    mesh.AdvanceVertex()
  end
  mesh.End()
end
