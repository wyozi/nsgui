nsgui = nsgui or {}

nsgui.trait = nsgui.trait or {}
nsgui.trait.Traits = nsgui.trait.Traits or {}
function nsgui.trait.Register(id, tbl)
	nsgui.trait.Traits[id] = tbl
	return tbl
end

function nsgui.trait.Import(metapanel, trait)
	local traitobj = nsgui.trait.Traits[trait]
	if not traitobj then error("Trying to import nonexistent trait " .. trait) end

	metapanel._ImportedTraits = metapanel._ImportedTraits or {}
	table.insert ( metapanel._ImportedTraits, trait )

	table.Merge(metapanel, traitobj)
end

function nsgui.Register ( name, panel, inherit )
	
	for k, trait in pairs(nsgui.trait.Traits) do
		if trait.Default then
			nsgui.trait.Import ( panel, k )
		end
	end
	
	vgui.Register ( name, panel, inherit )
end