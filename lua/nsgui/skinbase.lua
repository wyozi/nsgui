nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

function nsgui.skin.Register(id, tbl, parent)
	-- Every skin (except default) must be inherited from default
	if id ~= "default" and not parent then
		parent = "default"
	end

	if parent then
		local parentobj = nsgui.skin.Skins[parent]
		if not parentobj then
			error("Trying to register skin '" .. id .. "' with invalid parent skin '" .. parent .. "'")
		end

		setmetatable(tbl, {__index = parentobj})
	end

	nsgui.skin.Skins[id] = tbl
	return tbl
end

local DEFAULT_SKIN = "default"

function nsgui.skin.HookPaint(metapanel, funcname, returnValue)
	metapanel.Paint = function(panel, w, h)
		local skin = panel:GetSkin() or DEFAULT_SKIN
		local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins[DEFAULT_SKIN]

		skinobj[funcname](skinobj, panel, w, h)

		return returnValue
	end
end

function nsgui.skin.HookCall(metapanel, funcname)
	local skin = metapanel:GetSkin() or DEFAULT_SKIN
	local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins[DEFAULT_SKIN]
	local w, h = metapanel:GetSize()

	if skinobj[funcname] then
		return skinobj[funcname](metapanel, metapanel, w, h)
	end
	
	return false
end