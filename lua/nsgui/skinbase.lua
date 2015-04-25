nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

function nsgui.skin.Register(id, tbl)
	for _, trait in pairs ( nsgui.trait.Traits ) do
		if trait.AddToSkin then
			nsgui.trait.Import(SKIN, _)
		end
	end

	nsgui.skin.Skins[id] = tbl
	return tbl
end

function nsgui.skin.HookPaint(metapanel, funcname, ...)
	local args = {...}

	metapanel.Paint = function(panel, w, h)
		local skin = panel:GetSkin() or "sleek"
		local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins.sleek

		skinobj[funcname](skinobj, panel, w, h, unpack ( args ) )
	end
end