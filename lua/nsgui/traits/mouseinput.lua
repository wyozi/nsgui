local TRAIT = {}

-- Panels have Hovered property by default, we create an accessor for that
-- because accessors > public fields
nsgui.Accessor(TRAIT, "Hovered", "Hovered")
nsgui.Accessor(TRAIT, "Clicked", "Clicked")

function TRAIT:OnMousePressed(mousecode)
	self.Clicked = true
end

function TRAIT:OnMouseReleased(mousecode)
	if ( self.Hovered and self.Clicked ) then
		if mousecode == MOUSE_LEFT and self.DoClick then self:DoClick() end 
		if mousecode == MOUSE_RIGHT and self.DoRightClick then self:DoRightClick() end

		self.Clicked = false
	end
end

nsgui.trait.Register("mouseinput", TRAIT)