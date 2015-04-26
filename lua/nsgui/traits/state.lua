local TRAIT = {}

nsgui.Accessor(TRAIT, "_enabled", "Enabled", FORCE_BOOL, true)

nsgui.trait.Register("state", TRAIT)