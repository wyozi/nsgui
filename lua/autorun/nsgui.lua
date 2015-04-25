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

function nsgui.Example()
	local fr = vgui.Create("NSFrame")
	fr:SetSize(800, 400)
	fr:Center()
	fr:SetTitle("Hello world")
	fr:SetSkin("sleek_blur")

	local btn = fr:Add("NSButton")
	btn:SetPos(5, 30)
	btn:SetSize(150, 30)
	btn:SetText "Click me!"

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function()
	nsgui.Example()
end)