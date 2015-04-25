nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

function nsgui.skin.Register(id, tbl)
	if ( nsgui.trait ) then
		for _, trait in pairs ( nsgui.trait.Traits ) do
			if trait.AddToSkin then
				nsgui.trait.Import(tbl, _)
			end
		end
	end
	
	nsgui.skin.Skins[id] = tbl
	return tbl
end

function nsgui.skin.HookPaint(metapanel, funcname)
	metapanel.Paint = function(panel, w, h)
		local skin = panel:GetSkin() or "sleek"
		local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins.sleek

		skinobj[funcname](skinobj, panel, w, h )
	end
end
