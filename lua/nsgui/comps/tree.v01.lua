local PANEL = {}

nsgui.Accessor(PANEL, "_nodeHeight", "NodeHeight")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetNodeHeight(22)

	self.Root = self:Add("NSTreeNode")
	self.Root:SetText("Root")
end

function PANEL:PerformLayout()
	self.Root:SetPos(1, 1)
	self.Root:SetWide(self:GetWide() - 2)
end

nsgui.skin.HookPaint(PANEL, "PaintTree")
nsgui.trait.Import(PANEL, "state")

nsgui.Register("NSTree", PANEL, "Panel")

local NODE = {}

nsgui.Accessor(NODE, "_text", "Text")
nsgui.Accessor(NODE, "_expanded", "Expanded", FORCE_BOOL)

function NODE:Init()
	self:SetMouseInputEnabled(true)
end

function NODE:GetTree()
	local par = self:GetParent()
	if par:GetName() == "NSTree" then
		return par
	end

	-- TODO better impl. might be needed. What if there can be other things than NSTreeNode's in treepath?
	return par:GetTree()
end

function NODE:PerformLayout()
	local tree = self:GetTree()
	self:SetTall(tree:GetNodeHeight())

	-- TODO show or hide children based on expanded status
	if self:IsExpanded() then
		
	end
end

function NODE:DoClick()
	self:SetExpanded(not self:IsExpanded())
end

-- State depends on the tree state
function NODE:IsEnabled()
	return self:GetTree():IsEnabled()
end

nsgui.skin.HookPaint(NODE, "PaintTreeNode")
nsgui.trait.Import(PANEL, "mouseinput")

nsgui.Register("NSTreeNode", NODE, "Panel")