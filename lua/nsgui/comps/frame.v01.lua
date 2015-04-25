local PANEL = {}

nsgui.Accessor(PANEL, "_title", "Title")
nsgui.Accessor(PANEL, "_skin", "Skin")

function PANEL:Init()
	self.CloseButton = vgui.Create("NSButton", self)
	self.CloseButton:SetText("X")
	self.CloseButton:SetTextColor(Color(255, 255, 255))

	self.CloseButton.DoClick = function() self:Close() end

	self.CloseButton:SetColor(Color(210, 77, 87))

	self:SetDraggable(true)
	self:SetSizeable(true)
end

function PANEL:Close()
	self:Remove()
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()
	self.CloseButton:SetPos(w - 43, 3)
	self.CloseButton:SetSize(40, 20)

	-- TODO make overriding this possible in a skin
	self:SetDragBounds(0, 0, w, 25)
end

nsgui.skin.HookPaint(PANEL, "PaintFrame")

nsgui.trait.Import(PANEL, "center")
nsgui.trait.Import(PANEL, "drag")
nsgui.trait.Import(PANEL, "resize")
nsgui.trait.Import(PANEL, "gestures")

nsgui.Register("NSFrame", PANEL, "EditablePanel")