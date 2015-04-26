local SKIN = {}

surface.CreateFont("Roboto 16", {
	size = 16,
	font = "Roboto",
})

SKIN.FrameHeaderFont = "Roboto 16"
SKIN.Font = "Roboto 16"

SKIN.Color_FrameBackground = Color(255, 255, 255)
SKIN.Color_FrameOutline = Color(0, 0, 0, 100)
SKIN.Color_FrameHeaderBackground = Color(32, 32, 32)
SKIN.Color_FrameHeaderForeground = Color(255, 255, 255)

function SKIN:PaintFrameBackground(panel, w, h)
	surface.SetDrawColor(self.Color_FrameBackground)
	surface.DrawRect(0, 0, w, h)
end
function SKIN:PaintFrameOutline(panel, w, h)
	surface.SetDrawColor(self.Color_FrameOutline)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(self.Color_FrameHeaderBackground)
	surface.DrawRect(0, 0, w, 25)

	draw.SimpleText(panel:GetTitle(), self.FrameHeaderFont, 5, 25/2, self.Color_FrameHeaderForeground, nil, TEXT_ALIGN_CENTER)
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameBackground(panel, w, h)
	self:PaintFrameOutline(panel, w, h)
	self:PaintFrameHeader(panel, w, h)
end

SKIN.Color_ButtonBackground = Color(236, 236, 236)
SKIN.Color_ButtonOutline = Color(0, 0, 0, 100)
SKIN.Color_ButtonForeground = Color(51, 51, 51)

function SKIN:PaintButton(panel, w, h)
	local bgclr = panel:GetColor() or self.Color_ButtonBackground

	if panel:GetHovered() then
		local h, s, v = ColorToHSV(bgclr)
		local bgclr1 = bgclr
		bgclr = HSVToColor(h, s, math.Clamp(v + 0.15, 0, 1))
	end

	surface.SetDrawColor(bgclr)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.Color_ButtonOutline)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), panel:GetFont() or self.Font, w/2, h/2, panel:GetTextColor() or self.Color_ButtonForeground, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SKIN:PaintFrameCloseButton(panel, w, h)
	self:PaintButton(panel, w, h)
end

nsgui.skin.Register("default", SKIN)