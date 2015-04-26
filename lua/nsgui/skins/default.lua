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
SKIN.Color_FrameSizableHandle = Color(127, 127, 127)

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

function SKIN:PaintFrameCloseButton(panel, w, h)
	self:PaintButton(panel, w, h)
end

function SKIN:PaintFrameSizableHandle(panel, w, h)
	surface.SetDrawColor(self.Color_FrameSizableHandle)

	local padding = 3
	surface.DrawLine(w-padding, h-6, w-6, h-padding)
	surface.DrawLine(w-padding, h-10, w-10, h-padding)
	surface.DrawLine(w-padding, h-14, w-14, h-padding)
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameBackground(panel, w, h)
	self:PaintFrameOutline(panel, w, h)
	self:PaintFrameHeader(panel, w, h)

	if panel:IsSizable() then
		self:PaintFrameSizableHandle(panel, w, h)
	end
end

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
	elseif panel:IsClicked() then
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

SKIN.Color_TextEntryBackground = Color(236, 236, 236)
SKIN.Color_TextEntryOutline = Color(0, 0, 0, 100)
SKIN.Color_TextEntryForeground = Color(51, 51, 51)
SKIN.Color_TextEntryForegroundDisabled = Color(191, 191, 191)
SKIN.Color_TextEntryForegroundHighlighted = Color(107, 185, 240)
SKIN.Font_TextEntry = SKIN.Font

function SKIN:PaintTextEntryBackground(panel, w, h)
	surface.SetDrawColor(self.Color_TextEntryBackground)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.Color_TextEntryOutline)
	surface.DrawOutlinedRect(0, 0, w, h)
end
function SKIN:PaintTextEntry(panel, w, h)
	self:PaintTextEntryBackground(panel, w, h)

	-- We use Source function to draw text, so we need to do this to set
	-- the font to the one we want. Set/GetFont is overridden in textentry.lua
	-- so this is okay
	panel:SetFontInternal(panel:GetFont() or self.Font_TextEntry)

	local color = panel:GetTextColor() or self.Color_TextEntryForeground

	if not panel:IsEnabled() then
		color = self.Color_TextEntryForegroundDisabled
	end

	panel:DrawTextEntryText(color, self.Color_TextEntryForegroundHighlighted, color)
end

nsgui.skin.Register("default", SKIN)