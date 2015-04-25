local function Add(f)
	if SERVER then AddCSLuaFile(f) end
	if CLIENT then include(f) end
end

local function AddLUA(fo)
	for _,f in pairs(file.Find(fo.."/*.lua", "LUA")) do
		Add(fo .. "/" .. f)
	end
end

Add("nsgui/nsgui.lua")
Add("nsgui/skinbase.lua")

AddLUA("nsgui/traits")
AddLUA("nsgui/skins")
AddLUA("nsgui/comps")

if SERVER then return end
-- include can't seem to find example.lua.

function nsgui.Example()
	local fr = vgui.Create("NSFrame")
	fr:SetSize(800, 400) -- 600 is way too tall for my resolution.
	fr:Center()
	fr:SetTitle("Hello world")

	local btn = fr:Add("NSButton", 25, 200, 200, 35)
	btn:SetText "Click me!"

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function()
	nsgui.Example()
end)