local TRAIT = {}

nsgui.Accessor(TRAIT, "_enabled", "Enabled", FORCE_BOOL, true)

function TRAIT:SetEnabled(b)
	if self._enabled == b then return end

	self._enabled = b
	self:CallHook("OnStateChanged", b)
end

nsgui.trait.Register("state", TRAIT)