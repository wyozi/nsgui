local SKIN = {}

--
-- Koolest skin there is.
-- By Author.
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
surface.CreateFont("Open Sans 24", {
	size = 24,
	font = "Open Sans",
})

SKIN.FrameHeaderFont = "Roboto 16"
SKIN.Font = "Roboto 16"

--
-- Helper functions
--

local gup = Material("vgui/gradient_up")
local gdown = Material("vgui/gradient_down")

local blur = Material("pp/blurscreen")
function SKIN:DrawBlur(p, amount, passes, X, Y, w, h)
	local x, y = p:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(blur)

	render.SetScissorRect(x+4,y+4,x+w,y+(h*2),true)
		for i = 1, passes do
			blur:SetFloat("$blur",(i / 3) *(amount or 6))
			blur:Recompute()

			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
		end
	render.SetScissorRect(0,0,ScrW(),ScrH(),false)
end

function surface.DrawShadow ( x, y, w, h, layer, alpha )
	if alpha then
		surface.SetDrawColor ( 0, 0, 0, alpha )
	else
		surface.SetDrawColor ( 0, 0, 0, 95 )
	end
	
	surface.SetMaterial ( gup )
	surface.DrawTexturedRect ( x, y - layer, w, layer )

	surface.SetMaterial ( gdown )
	surface.DrawTexturedRect ( x, y + h, w, layer )

	surface.SetMaterial ( gup )
	surface.DrawTexturedRectRotated ( x - ( layer / 2 ), y + ( h / 2 ), h, layer, 90 )

	surface.SetMaterial ( gup )
	surface.DrawTexturedRectRotated ( x + w + ( layer / 2 ), y + ( h / 2 ), h, layer, -90 )
end

--
-- Main Frame
--

function SKIN:FrameDockPadding(panel, w, h)
	return 4, 36, 4, 4
end

function SKIN:FrameDragBounds(panel, w, h)
	return 0, 0, w, 36
end

function SKIN:FrameCloseButtonBounds(panel, w, h)
	return w - ( 32 + 4 ), 4, 32, 32
end

function SKIN:PaintFrameHeader(panel, w, h)
	self:DrawBlur(panel, 3, 6, 4, 4, w - 8, 32 )
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect ( 4, 4, w - 8, 32 )

	surface.SetFont"Roboto 16"
	surface.SetTextColor(255, 255, 255)
	local textw, texth = surface.GetTextSize(panel:GetTitle())

	if panel:GetIcon() then
		surface.SetMaterial(panel:GetIcon())
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(4+36/2-16/2, 36/2-16/2, 16, 16)

		surface.SetTextPos(16+((2+36/2-16/2)*2), 36/2-texth/2)
	else
		surface.SetTextPos((4+36/2-16/2), 36/2-texth/2)
	end
	
	surface.DrawText(panel:GetTitle())
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameHeader(panel, w, h )

	surface.SetDrawColor(255,255,255)
	surface.DrawRect(4, 32 + 4, w - 8, h - 32 - 8)
	surface.DrawShadow(4, 4, w - 8, h - 8, 4)

	self:PaintFrameSizableHandle(panel, w-4, h-4)
end

	--
	-- Main Frame Button
	--

function SKIN:PaintFrameCloseButton(panel, w, h)
	if ( not panel.closealpha ) then
		panel.closealpha = 0
	end

	if panel.Hovered then
		panel.closealpha = math.Approach ( panel.closealpha, 200, FrameTime ( ) * 1100 )
	elseif panel.closealpha then
		panel.closealpha = math.Approach ( panel.closealpha, 0, FrameTime ( ) * 1100 )
	end

	surface.SetDrawColor(255,100,100,panel.closealpha)
	surface.DrawRect(0,0,w,h)
	
	surface.SetTextColor ( 255, 255, 255 )
	surface.SetFont "Open Sans 24"
	local textw, texth = surface.GetTextSize ( panel:GetText ( ) )

	surface.SetTextPos ( w / 2 - textw / 2, h / 2 - texth / 2 - 2 )
	surface.DrawText ( panel:GetText ( ) )
end

--
-- Button
--

function surface.DrawThickOutlinedRect ( x, y, w, h, thickness )
	if ( not ( thickness and x and y and w and h ) ) then return end
	for i = 1, thickness do
		surface.DrawOutlinedRect ( x + i, y + i, w - ( i * 2 ), h - ( i * 2 ) )
	end
end

function SKIN:PaintButton(panel, w, h)
	if ( not panel.btnalpha ) then
		panel.btnalpha = 200
	end

	surface.SetDrawColor ( 64, 64, 64 )
	surface.DrawThickOutlinedRect ( 0, 0, w, h, 2 )

	if (panel.Hovered and panel:GetEnabled()) then
		if panel.Clicked then
			panel.btnalpha = math.Approach ( panel.btnalpha, 150, FrameTime ( ) * 250 )
		else
			panel.btnalpha = math.Approach ( panel.btnalpha, 175, FrameTime ( ) * 250 )
		end
		surface.SetDrawColor ( 100, panel.btnalpha, 100 )
	elseif (not panel:GetEnabled()) then
		surface.SetDrawColor ( 160, 160, 160 )
	else
		panel.btnalpha = math.Approach ( panel.btnalpha, 200, FrameTime ( ) * 250 )
		surface.SetDrawColor ( 100, panel.btnalpha, 100 )
	end

	surface.DrawRect ( 2, 2, w - 4, h - 4 )

	surface.SetTextColor ( 255, 255, 255 )
	surface.SetFont(panel:GetFont() or "Roboto 24")

	local textw, texth = surface.GetTextSize ( panel:GetText() )

	surface.SetTextPos ( w / 2 - textw / 2, h / 2 - texth / 2 )
	surface.DrawText ( panel:GetText() )
end

--
-- Checkbox
--

function SKIN:PaintCheckbox(panel, w, h)
	local ticked = panel:GetState ( )

	surface.SetDrawColor ( 255, 255, 255 )

	surface.DrawRect ( 0, 0, w, h )
	surface.DrawShadow ( 0, 0, w, h, 50 )
end

nsgui.skin.Register("swift", SKIN)