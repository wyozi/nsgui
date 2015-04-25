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
	table.insert(metapanel._ImportedTraits, trait)

	local objtbl = {}

	for k, func in pairs ( traitobj ) do
		if isfunction ( func ) then
			if metapanel [ k ] then
				objtbl [ "_" .. k ] = func

				local oldf = metapanel [ k ]
				metapanel [ k ] = function ( ... )
					oldf ( ... )
					objtbl [ "_" .. k ] ( ... )
				end
			else
				objtbl [ k ] = func
			end
		else
			objtbl [ k ] = func
		end
	end

	if objtbl.Dependencies then
		for k, v in pairs ( objtbl.Dependencies ) do
			if ( not table.HasValue ( metapanel._ImportedTraits, v ) ) then
				error ( "The trait '" .. trait .. "' requires the trait '".. v .. "'' to function properly.", 2 )
			end
		end
	end
	
	table.Merge ( metapanel, objtbl )
end

function nsgui.Register(name, panel, inherit)
	panel.Name = name

	for k, trait in pairs(nsgui.trait.Traits) do
		if trait.Default then
			nsgui.trait.Import(panel, k)
		end
	end

	vgui.Register(name, panel, inherit)
end