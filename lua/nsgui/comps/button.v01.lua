local PANEL = {}
AccessorFunc(PANEL, "_text", "Text")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end

function PANEL:OnMousePressed(mousecode)
	-- TODO think this through
	if self.DoClick then self:DoClick() end 
end
nsgui.skin.HookPaint(PANEL, "PaintButton")

nsgui.Register("NSButton", PANEL, "Panel")