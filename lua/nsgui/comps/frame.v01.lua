local PANEL = {}

nsgui.Accessor(PANEL, "_title", "Title")
nsgui.Accessor(PANEL, "_skin", "Skin")
nsgui.Accessor(PANEL, "_icon", "Icon")

function PANEL:Init()
	self.CloseButton = vgui.Create("NSButton", self)
	self.CloseButton:SetText("x")
	self.CloseButton:SetTextColor(Color(255, 255, 255))

	nsgui.skin.HookPaint(self.CloseButton, "PaintFrameCloseButton")

	self.CloseButton.DoClick = function() self:Close() end
	self.CloseButton:SetColor(Color(210, 77, 87))

	self:SetDraggable(true)
	self:SetSizeable(true)
end

function PANEL:SetIcon ( str )
	if str then
		self._icon = Material(str)
	end
end

function PANEL:Close()
	self:Remove()
end

function PANEL:PerformLayout()
	local _w, _h = self:GetSize()

	if nsgui.skin.HookCall(self, "FrameCloseButtonBounds") then
		local x, y, w, h = nsgui.skin.HookCall(self, "FrameCloseButtonBounds")

		self.CloseButton:SetPos(x, y)
		self.CloseButton:SetSize(w, h)
	else
		self.CloseButton:SetPos(_w - 43, 3)
		self.CloseButton:SetSize(40, 20)
	end

	if nsgui.skin.HookCall(self, "FrameDragBounds") then
		self:SetDragBounds(nsgui.skin.HookCall(self, "FrameDragBounds"))
	else
		self:SetDragBounds(0, 0, _w, 25)
	end

	if nsgui.skin.HookCall(self, "FrameDockPadding") then
		self:DockPadding(nsgui.skin.HookCall(self, "FrameDockPadding"))
	else
		self:DockPadding(0, 25, 0, 0)
	end
end

nsgui.skin.HookPaint(PANEL, "PaintFrame")

nsgui.trait.Import(PANEL, "center")
nsgui.trait.Import(PANEL, "drag")
nsgui.trait.Import(PANEL, "resize")
nsgui.trait.Import(PANEL, "gestures")

nsgui.Register("NSFrame", PANEL, "EditablePanel")