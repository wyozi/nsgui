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

function SKIN:PaintFrame(panel, w, h)
	self:DrawBlur(panel, 3, 6, 4, 4, w - 8, 32 )
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect ( 4, 4, w - 8, 32 )

	surface.SetDrawColor(255,255,255)
	surface.DrawRect(4, 32 + 4, w - 8, h - 32 - 8)
	surface.DrawShadow(4, 4, w - 8, h - 8, 4)
end

	--
	-- Main Frame Button
	--

local framebtnalpha = 0
function SKIN:PaintFrameCloseButton(panel, w, h)
	if panel.Hovered then
		framebtnalpha = math.Approach ( framebtnalpha, 200, FrameTime ( ) * 1100 )
	elseif framebtnalpha then
		framebtnalpha = math.Approach ( framebtnalpha, 0, FrameTime ( ) * 1100 )
	end

	surface.SetDrawColor(255,100,100,framebtnalpha)
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

local btnalpha = 200
function SKIN:PaintButton(panel, w, h)
	surface.SetDrawColor ( 0, 0, 0, 230 )
	surface.DrawThickOutlinedRect ( 0, 0, w, h, 2 )

	if panel.Hovered then
		if panel.Clicked then
			btnalpha = math.Approach ( btnalpha, 150, FrameTime ( ) * 250 )
		else
			btnalpha = math.Approach ( btnalpha, 175, FrameTime ( ) * 250 )
		end
	else
		btnalpha = math.Approach ( btnalpha, 200, FrameTime ( ) * 250 )
	end

	surface.SetDrawColor ( 100, btnalpha, 100 )
	surface.DrawRect ( 2, 2, w - 4, h - 4 )

	surface.SetTextColor ( 255, 255, 255 )
	surface.SetFont "Roboto 24"

	local textw, texth = surface.GetTextSize ( panel:GetText() )

	surface.SetTextPos ( w / 2 - textw / 2, h / 2 - texth / 2 + 2 )
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

nsgui.skin.Register("kool", SKIN)