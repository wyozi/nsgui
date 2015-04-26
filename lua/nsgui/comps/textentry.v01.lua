local PANEL = {}

AccessorFunc(PANEL, "_text", "Text")
AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetKeyBoardInputEnabled(true)
	self:SetCursor("beam")
end

function PANEL:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

nsgui.skin.HookPaint(PANEL, "PaintTextEntry", true)

nsgui.Register("NSTextEntry", PANEL, "TextEntry")