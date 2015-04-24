local SKIN = {}

function SKIN:DrawLabel(x, y, w, h)

end

function SKIN:PaintFrameBackground(panel, w, h)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(0, 0, 0)
	surface.DrawOutlinedRect(0, 0, w, h)
end
function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(100, 100, 100)
	surface.DrawRect(1, 1, w-2, 25)

	draw.SimpleText(panel:GetTitle(), "DermaDefaultBold", 10, 7)
end
function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameBackground(panel, w, h)
	self:PaintFrameHeader(panel, w, h)
end

function SKIN:PaintButton(panel, w, h)
	surface.SetDrawColor(255, 0, 0)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(0, 0, 0)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), "DermaDefaultBold", w/2, h/2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

nsgui.skin.Register("sleek", SKIN)