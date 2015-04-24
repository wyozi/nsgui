local TRAIT = {}

function TRAIT:Center()
	self:InvalidateLayout(true)
	self:SetPos(ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2)
end

nsgui.trait.Register("center", TRAIT)