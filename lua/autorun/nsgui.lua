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

function nsgui.TestComp(compName)
	local fr = vgui.Create("NSFrame")
	fr:SetSize(530, 500)
	fr:Center()
	fr:SetTitle("Component demonstration: " .. compName)

	local comp = fr:Add(compName)
	comp:Dock(FILL)

	fr:MakePopup()

	return comp
end

function nsgui.Example(skin)
	local fr = vgui.Create("NSFrame")
	fr:SetSize(530, 500)
	fr:Center()
	fr:SetTitle("Hello world")
	fr:SetIcon("icon16/bomb.png")

	if skin then fr:SetSkin(skin) end

	local tbl = fr:Add("NSTable")
	tbl:Dock(FILL)
	tbl:Top()

	local function createComp(cls, x, y, w, h, fn)
		local cell = tbl:Add(vgui.Create(cls)):SetExpandedX(true):Fill():SetHeight(h)
		fn(cell:GetComponent())

		if cell:GetComponent().SetEnabled then
			local disabledcell = tbl:Add(vgui.Create(cls)):SetExpandedX(true):Fill():SetHeight(h)
			disabledcell:GetComponent():SetEnabled(false)
			fn(disabledcell:GetComponent())
		else
			-- Add null cell
			tbl:Add(vgui.Create("DPanel"))
		end

		tbl:Row()
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

	fr:MakePopup()
end

concommand.Add("nsgui.Example", function(ply, cmd, args)
	nsgui.Example(args[1])
end)