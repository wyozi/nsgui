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
	fr:SetSize(530, 500)
	fr:Center()
	fr:SetTitle("Hello world")
	fr:SetIcon("icon16/bomb.png")

	if skin then fr:SetSkin(skin) end

	local function createComp(cls, x, y, w, h, fn)
		local comp = fr:Add(cls)
		comp:SetPos(x, y)
		comp:SetSize(w, h)
		fn(comp)

		-- Can't be disabled, abort
		if not comp.SetEnabled then return end

		local disabledcomp = fr:Add(cls)
		disabledcomp:SetPos(x + w + 10, y)
		disabledcomp:SetSize(w, h)
		disabledcomp:SetEnabled(false)
		fn(disabledcomp)
	end

	createComp("NSButton", 10, 40, 250, 30, function(comp)
		comp:SetText("Click me!")
		comp.DoClick = function() chat.AddText("Clicked!") end
	end)

	createComp("NSTextEntry", 10, 80, 250, 30, function(comp)
		comp:SetText("Hello world")
	end)

	createComp("NSTextArea", 10, 120, 250, 90, function(comp)
		comp:SetText("Lorem\nIpsum")
	end)

	createComp("NSConsole", 10, 220, 250, 90, function(comp)
		local text = ("Hello world. I am a simple node")
		local t = {}
		for w in string.gmatch(text, "(%w+)") do t[#t+1] = w end

		for i=1, 1 do
			comp:AddTextNode(unpack(t))
		end
	end)

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function(ply, cmd, args)
	nsgui.Example(args[1])
end)