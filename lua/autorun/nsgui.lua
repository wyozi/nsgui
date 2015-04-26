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

function nsgui.Example(skin)
	local fr = vgui.Create("NSFrame")
	fr:SetSize(800, 400)
	fr:Center()
	fr:SetTitle("Hello world")
	fr:SetIcon("icon16/bomb.png")

	if skin then fr:SetSkin(skin) end

	local btn = fr:Add("NSButton")
	btn:Dock(TOP)
	btn:SetTall(30)
	btn:DockMargin(10,10,10,0)

	btn:SetText "Click me!"
	btn:SetFont("Roboto 16")

	function btn.DoClick()
		chat.AddText "You clicked me :D"
	end

	local textentry = fr:Add("NSTextEntry")
	textentry:Dock(TOP)
	textentry:SetTall(30)
	textentry:DockMargin(10,10,10,0)

	textentry:SetText("Hello")

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function(ply, cmd, args)
	nsgui.Example(args[1])
end)