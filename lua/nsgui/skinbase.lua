nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

function nsgui.skin.Create(id)
	local t = {}
	t.Id = id
	nsgui.skin.Skins[id] = t
	return t
end

function nsgui.skin.HookPaint(metapanel, funcname)
	metapanel.Paint = function(panel, w, h)
		local skin = panel:GetSkin() or "sleek"
		local skinobj = nsgui.skin.Skins[skin] or nsgui.skin.Skins.sleek

		skinobj[funcname](skinobj, panel, w, h)
	end
end