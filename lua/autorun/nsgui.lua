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
	btn:SetPos(10, 40)
	btn:SetSize(250, 30)
	btn:SetText("Click me!")
	btn:SetFont("Roboto 16")
	btn.DoClick = function() chat.AddText("Clicked!") end

	local disabledbtn = fr:Add("NSButton")
	disabledbtn:SetPos(270, 40)
	disabledbtn:SetSize(250, 30)
	disabledbtn:SetText("I'm disabled")
	disabledbtn:SetFont("Roboto 16")
	disabledbtn:SetEnabled(false)
	disabledbtn.DoClick = function() chat.AddText("Clicked!") end

	local textentry = fr:Add("NSTextEntry")
	textentry:SetPos(10, 80)
	textentry:SetSize(250, 30)
	textentry:SetText("Hello")

	local textarea = fr:Add("NSTextArea")
	textarea:SetPos(10, 120)
	textarea:SetSize(250, 90)
	textarea:SetText("Lorem\nIpsum")

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function(ply, cmd, args)
	nsgui.Example(args[1])
end)