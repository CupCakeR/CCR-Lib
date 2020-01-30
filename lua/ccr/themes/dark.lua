
// https://www.materialui.co/flatuicolors

local theme = CCR:NewTheme("material_dark")
theme:SetName("Material dark")
theme:SetColors({
	Primary			= rgb(50, 50, 50),
	Secondary		= rgb(60, 60, 60),
	Background		= rgb(30, 30, 30),
	PanelBackground = rgb(40, 40, 40),
	Highlight		= rgb(70, 70, 70),
	Navbar			= rgb(35, 35, 35),

	["Green"]		= hex("2ecc71"),
	["Red"]			= hex("c0392b"),
	["Yellow"]		= hex("f1c40f"),
	["LightBlue"]	= hex("2980b9"):Lighten(20),
	["Blue"]		= hex("3498db"),
})
theme:SetMaterials({
	close = Material("ccr_lib/close_x.png", "smooth")
})
theme:SetBoxRoundness(7)
theme:Register()