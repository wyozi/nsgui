nsgui = nsgui or {}

nsgui.trait = nsgui.trait or {}
nsgui.trait.Traits = nsgui.trait.Traits or {}
function nsgui.trait.Register(id, tbl)
	nsgui.trait.Traits[id] = tbl
	return tbl
end

-- These keys won't be imported
local importBlackList = {"InitTrait", "Default"}
function nsgui.trait.Import(metapanel, trait)
	local traitobj = nsgui.trait.Traits[trait]
	if not traitobj then error("Trying to import nonexistent trait " .. trait) end

	metapanel._ImportedTraits = metapanel._ImportedTraits or {}
	table.insert(metapanel._ImportedTraits, trait)

	-- Add non-blacklisted keys from trait to metapanel
	for k,v in pairs(traitobj) do
		if not table.HasValue(importBlackList, k) then
			if metapanel[k] ~= nil then
				error("Attempted to import '" .. trait .. "' to '" .. metapanel.Name .. "', which failed because key '" .. k .. "' exists already")
			end
			metapanel[k] = v
		end
	end
end

function nsgui.Register(name, panel, inherit)
	panel.Name = name

	-- Import default traits
	for k, trait in pairs(nsgui.trait.Traits) do
		if trait.Default then
			nsgui.trait.Import(panel, k)
		end
	end
	
	vgui.Register(name, panel, inherit)

	-- Detour panel:Init() to call trait:InitTrait()
	local oldInit = panel.Init
	function panel:Init()
		if oldInit then oldInit(self) end

		for _,itrait in pairs(self._ImportedTraits) do
			local traitobj = nsgui.trait.Traits[itrait]
			if traitobj.InitTrait then
				traitobj.InitTrait(self)
			end
		end
	end
end