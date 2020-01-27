
CCR.Resources:CL("cl_panelfuncs") // Load b4 tools
CCR.Resources:SH("sh_classmerges")

// Tools
CCR.Resources:SH("tools/class_funcs_merge")
CCR.Resources:SH("tools/color")
CCR.Resources:SH("tools/misc")
CCR.Resources:SH("tools/sh_playerfuncs")
CCR.Resources:CL("tools/_BSHADOWS")
CCR.Resources:CL("tools/vgui")
CCR.Resources:CL("tools/draw")
CCR.Resources:CL("tools/anim")
CCR.Resources:CL("tools/text")
CCR.Resources:CL("tools/hook")
CCR.Resources:CL("tools/cache")

CCR.Resources:CLASS("theme")
CCR.Resources:CL("cl_themes")

for k, v in pairs(file.Find("ccr/themes/*", "LUA")) do
	v = string.StripExtension(v)
	CCR.Resources:CL("themes/" .. v)
end

CCR.Resources:CL("cl_test")

// TODO: Automatically include this shit, order doesnt matter
CCR.Resources:ELEMENT("_defaults") // TODO: Remove, we can add "!" as class prefix to use non lib elements
CCR.Resources:ELEMENT("frame")
CCR.Resources:ELEMENT("button")
CCR.Resources:ELEMENT("sidenav")
CCR.Resources:ELEMENT("circle_avatar")
CCR.Resources:ELEMENT("scrollpanel")
CCR.Resources:ELEMENT("textentry")
CCR.Resources:ELEMENT("numslider")
CCR.Resources:ELEMENT("image_label")