local PANEL = {}

AccessorFunc(PANEL, "_font", "Font")
AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")

function PANEL:Init()
	self:SetKeyBoardInputEnabled(true)
	self:SetCursor("beam")
end

function PANEL:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

nsgui.skin.HookPaint(PANEL, "PaintTextEntry", true)

nsgui.Register("NSTextEntry", PANEL, "TextEntry")