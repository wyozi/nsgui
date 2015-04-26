local PANEL = {}

AccessorFunc(PANEL, "_text", "Text")
AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end

nsgui.skin.HookPaint(PANEL, "PaintButton")

nsgui.trait.Import(PANEL, "mouseinput")
nsgui.trait.Import(PANEL, "state")

nsgui.Register("NSButton", PANEL, "Panel")
