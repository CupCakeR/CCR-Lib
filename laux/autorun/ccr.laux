
-- TODO Our lib doesnt need this trash, find some other way

--
local addon = "CCR"
local dir = "ccr"
--

local tbl = {
	Resources = {
		dir = dir .. "/"
	}
}
dir = dir .. "/"

--

function tbl.Resources:SV( f )
	if SERVER then
		return include( self.dir .. f .. ".lua" )
	end
end

function tbl.Resources:CL( f )
	if SERVER then
		AddCSLuaFile( self.dir .. f .. ".lua" )
	else
		return include( self.dir .. f .. ".lua" )
	end
end

function tbl.Resources:ELEMENT( f )
	if SERVER then
		AddCSLuaFile( self.dir .. "elements/" .. f .. ".lua" )
	else
		return include( self.dir .. "elements/" .. f .. ".lua" )
	end
end

function tbl.Resources:SH( f )
	if SERVER then
		AddCSLuaFile( self.dir .. f .. ".lua" )
	end

	return include( self.dir .. f .. ".lua" )
end

function tbl.Resources:CLASS( f, file )
	if SERVER then
		AddCSLuaFile( self.dir .. "classes/" .. f .. "/" .. (file or "sh") .. ".lua" )
	end

	return include( self.dir .. "classes/" .. f .. "/" .. (file or "sh") .. ".lua" )
end

_G[addon] = tbl
_G[addon].Debug = function(self, str)
	MsgC(Color(0, 191, 255), "<" .. addon .. "> ", color_white, str, "\n")
end
_G[addon].Resources:SH("sh_init")
_G[addon]:Debug("Initialized addon.")