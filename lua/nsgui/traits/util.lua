TRAIT = { }

TRAIT.Default = true
TRAIT.AddToSkin = true

function TRAIT:localToScreen ( x, y )
	local a, b = self:GetPos ( )

	return a + x, b + y
end

nsgui.trait.Register("util", TRAIT)