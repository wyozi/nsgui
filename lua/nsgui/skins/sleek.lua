local SKIN = {}

surface.CreateFont("Roboto 16", {
	size = 16,
	font = "Roboto",
})

function SKIN:PaintFrameBackground(panel, w, h)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(0, 0, w, h)
end
function SKIN:PaintFrameOutline(panel, w, h)
	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(32, 32, 32)
	surface.DrawRect(0, 0, w, 25)

	draw.SimpleText(panel:GetTitle(), "Roboto 16", 5, 25/2, Color(255, 255, 255), nil, TEXT_ALIGN_CENTER)
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameBackground(panel, w, h)
	self:PaintFrameOutline(panel, w, h)
	self:PaintFrameHeader(panel, w, h)
end

function SKIN:PaintButton(panel, w, h)
	surface.SetDrawColor(panel:GetColor())
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(0, 0, 0, 100)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), panel:GetFont(), w/2, h/2, panel:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

nsgui.skin.Register("sleek", SKIN)