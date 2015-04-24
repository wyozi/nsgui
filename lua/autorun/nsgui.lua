local function Add(f)
	if SERVER then AddCSLuaFile(f) end
	if CLIENT then include(f) end
end

Add("nsgui/nsgui.lua")
Add("nsgui/skinbase.lua")

Add("nsgui/traits/center.lua")
Add("nsgui/skins/sleek.lua")
Add("nsgui/comps/frame.v01.lua")