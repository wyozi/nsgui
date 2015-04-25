local SKIN = {}

surface.CreateFont ( "Roboto 16", {
	size = 16,
	font = "Roboto",
})

local blur = Material("pp/blurscreen")

function SKIN:DrawBlur ( p, amount, heavyness )
	local x, y = p:localToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	for i = 1, heavyness do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function SKIN:PaintFrameBackground( panel, w, h )
	self:DrawBlur ( panel, 3, 6 )

	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawRect ( 0, 0, w, h )

	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(32, 32, 32)
	surface.DrawRect(0, 0, w, 25)

	draw.SimpleText(panel:GetTitle(), "Roboto 16", 5, 25/2, Color(255, 255, 255), nil, TEXT_ALIGN_CENTER)
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameBackground(panel, w, h)
	self:PaintFrameHeader(panel, w, h)
end

function SKIN:PaintButton(panel, w, h)
	surface.SetDrawColor( panel:GetColor ( ) )
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), panel:GetFont ( ), w/2, h/2, panel:GetTextColor ( ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

nsgui.skin.Register("sleek", SKIN)