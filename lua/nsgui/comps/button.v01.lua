local PANEL = {}

AccessorFunc(PANEL, "_text", "Text")
AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self:SetColor(Color(255, 255, 255))
	self:SetTextColor(Color(51, 51, 51))
	self:SetFont("Roboto 16")
end

function PANEL:OnMousePressed(mousecode)
	-- TODO think this through
	if self.DoClick then self:DoClick() end 
end

nsgui.skin.HookPaint(PANEL, "PaintButton")

nsgui.Register("NSButton", PANEL, "Panel")
