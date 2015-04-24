local PANEL = {}
AccessorFunc(PANEL, "_title", "Title")
AccessorFunc(PANEL, "_skin", "Skin")

function PANEL:Init()
	self.CloseButton = vgui.Create("NSButton", self)
	self.CloseButton:SetText("Close")
	self.CloseButton.DoClick = function() self:Close() end
end

function PANEL:Close()
	self:Remove()
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()
	self.CloseButton:SetPos(w - 53, 3)
	self.CloseButton:SetSize(50, 20)
end
nsgui.skin.HookPaint(PANEL, "PaintFrame")
nsgui.trait.Import(PANEL, "center")

vgui.Register("NSFrame", PANEL, "EditablePanel")