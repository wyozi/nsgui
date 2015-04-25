TRAIT = { }

TRAIT.Default = true
TRAIT.AddToSkin = true

function TRAIT:GetRelativePos(x, y)
	local sx, sy = self:GetPos()
	return sx + x, sy + y
end

nsgui.trait.Register("util", TRAIT)