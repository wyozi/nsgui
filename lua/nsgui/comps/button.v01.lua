local PANEL = {}

AccessorFunc(PANEL, "_text", "Text")
AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end

nsgui.trait.Import(PANEL, "mouseinput")
nsgui.skin.HookPaint(PANEL, "PaintButton")

nsgui.Register("NSButton", PANEL, "Panel")
