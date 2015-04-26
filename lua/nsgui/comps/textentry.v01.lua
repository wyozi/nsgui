local PANEL = {}

AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")

-- We override TextEntry's Font accessors. "Default" font is set in skins
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetCursor("beam")
	self:SetAllowNonAsciiCharacters(true)
end

function PANEL:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

function PANEL:SetMultiline(b)
	error("Error: trying to set 'NSTextEntry' multilined. Use 'NSTextArea' instead, which is multiline by default.")
end

nsgui.skin.HookPaint(PANEL, "PaintTextEntry", true)

nsgui.Register("NSTextEntry", PANEL, "TextEntry")