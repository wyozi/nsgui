nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

function nsgui.skin.Register(id, tbl, parent)
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

function nsgui.skin.HookPaint(metapanel, funcname)
	metapanel.Paint = function(panel, w, h)
		local skin = panel:GetSkin() or "sleek"
		local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins.sleek

		skinobj[funcname](skinobj, panel, w, h)
	end
end
