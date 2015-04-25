local SKIN = {}

local blur = Material("pp/blurscreen")
function SKIN:DrawBlur(p, amount, passes)
	local x, y = p:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	for i = 1, passes do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function SKIN:PaintFrameBackground(panel, w, h)
	self:DrawBlur(panel, 3, 6)

	surface.SetDrawColor(self.Color_FrameOutline)
	surface.DrawRect(0, 0, w, h)
end

nsgui.skin.Register("sleek_blur", SKIN, "sleek")