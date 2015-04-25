local TRAIT = {}

-- Panels have Hovered property by default, we create an accessor for that
-- because accessors > public fields
nsgui.Accessor(TRAIT, "Hovered", "Hovered")

function TRAIT:OnMousePressed(mousecode)
	if mousecode == MOUSE_LEFT and self.DoClick then self:DoClick() end 
	if mousecode == MOUSE_RIGHT and self.DoRightClick then self:DoRightClick() end 
end

nsgui.trait.Register("mouseinput", TRAIT)