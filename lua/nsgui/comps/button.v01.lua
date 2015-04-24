local PANEL = {}
AccessorFunc(PANEL, "_text", "Text")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end

function PANEL:OnMousePressed(mousecode)
	print("PRESSED")
end
nsgui.skin.HookPaint(PANEL, "PaintButton")

vgui.Register("NSButton", PANEL, "Panel")