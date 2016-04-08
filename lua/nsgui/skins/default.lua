local SKIN = {}

--
-- Made by Author.
--

--
-- Fonts
--

surface.CreateFont("Roboto 16", {
	size = 16,
	font = "Roboto",
})
surface.CreateFont("Roboto 24", {
	size = 24,
	font = "Roboto",
})

SKIN.FrameHeaderFont = "Roboto 16"
SKIN.Font = "Roboto 16"

--
-- Main Frame
--

function SKIN:FrameDockPadding(panel, w, h)
	return 0, 32, 0, 0
end

function SKIN:FrameDragBounds(panel, w, h)
	return 0, 0, w, 32
end

function SKIN:FrameCloseButtonBounds(panel, w, h)
	return w - 48, 0, 48, 32
end

function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect ( 0, 0, w, 32 )

	surface.SetFont"Roboto 16"
	surface.SetTextColor(255, 255, 255)
	local textw, texth = surface.GetTextSize(panel:GetTitle())

	if panel:GetIcon() then
		surface.SetMaterial(panel:GetIcon())
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(0+32/2-16/2, 32/2-16/2, 16, 16)

		surface.SetTextPos(16+((2+32/2-16/2)*2), 32/2-texth/2)
	else
		surface.SetTextPos((0+32/2-16/2), 32/2-texth/2)
	end
	
	surface.DrawText(panel:GetTitle())
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameHeader(panel, w, h )

	surface.SetDrawColor(255,255,255)
	surface.DrawRect(0, 32 + 0, w, h - 32)

	self:PaintFrameSizableHandle(panel, w-0, h-0)
end

	--
	-- Main Frame Button
	--

function SKIN:PaintFrameCloseButton(panel, w, h)
	surface.SetDrawColor(255,100,100, panel.Hovered and 255 or 0)
	surface.DrawRect(0,0,w,h)
	
	surface.SetTextColor ( 255, 255, 255 )
	surface.SetFont "Roboto 16"
	local textw, texth = surface.GetTextSize ( panel:GetText ( ) )

	surface.SetTextPos ( w / 2 - textw / 2, h / 2 - texth / 2 - 2 )
	surface.DrawText ( panel:GetText ( ) )
end

--
-- Button
--

SKIN.Color_ButtonBackground = Color(236, 236, 236)
SKIN.Color_ButtonBackgroundDisabled = Color(236, 236, 236)
SKIN.Color_ButtonOutline = Color(0, 0, 0, 100)
SKIN.Color_ButtonForeground = Color(51, 51, 51)
SKIN.Color_ButtonForegroundDisabled = Color(191, 191, 191)

function SKIN:PaintButton(panel, w, h)
	local bgclr = panel:GetColor() or self.Color_ButtonBackground
	local fgclr = panel:GetTextColor() or self.Color_ButtonForeground

	if not panel:IsEnabled() then
		bgclr = self.Color_ButtonBackgroundDisabled
		fgclr = self.Color_ButtonForegroundDisabled
	elseif panel:IsDepressed() then
		local h, s, v = ColorToHSV(bgclr)
		bgclr = HSVToColor(h, s, math.Clamp(v - 0.1, 0, 1))
	elseif panel:GetHovered() then
		local h, s, v = ColorToHSV(bgclr)
		bgclr = HSVToColor(h, s, math.Clamp(v - 0.05, 0, 1))
	end

	surface.SetDrawColor(bgclr)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.Color_ButtonOutline)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), panel:GetFont() or self.Font, w/2, h/2, fgclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--
-- Checkbox
--

function SKIN:PaintCheckbox(panel, w, h)
	local ticked = panel:GetState ( )

	surface.SetDrawColor ( 255, 255, 255 )

	surface.DrawRect ( 0, 0, w, h )
end

nsgui.skin.Register("default", SKIN)