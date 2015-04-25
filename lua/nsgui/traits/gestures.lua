TRAIT = { }

TRAIT.Dependencies = { "drag" }

nsgui.Accessor(TRAIT, "_canfullscreen", "CanFullScreen", FORCE_BOOL)

function TRAIT:Init()
	self:SetCanFullScreen(true)
end

local GESTURE_UP

local alpha = 0
local speed = 500

hook.Add("HUDPaint", "gesture_draw",
	function()
		if(GESTURE_UP or GESTURE_RIGHT or GESTURE_LEFT) then
			alpha = math.Approach(alpha, 100, FrameTime() * speed)	
		else
			alpha = 0
		end

		if GESTURE_UP then
			surface.SetDrawColor(0, 0, 0, 75 * alpha / 100)
			surface.DrawRect(10, 10, ScrW() - 20, ScrH() - 20)

			surface.SetDrawColor(0, 0, 0, 175 * alpha / 100)
			surface.DrawOutlinedRect(10, 10, ScrW() - 20, ScrH() - 20)
		end

		if GESTURE_RIGHT then
			surface.SetDrawColor(0, 0, 0, 75 * alpha / 100)
			surface.DrawRect(ScrW() / 2 + 10, 10, ScrW() / 2 - 20, ScrH() - 20)

			surface.SetDrawColor(0, 0, 0, 175 * alpha / 100)
			surface.DrawOutlinedRect(ScrW() / 2 + 10, 10, ScrW() / 2 - 20, ScrH() - 20)
		end

		if GESTURE_LEFT then
			surface.SetDrawColor(0, 0, 0, 75 * alpha / 100)
			surface.DrawRect(10, 10, ScrW() / 2 - 20, ScrH() - 20)

			surface.SetDrawColor(0, 0, 0, 175 * alpha / 100)
			surface.DrawOutlinedRect(10, 10, ScrW() / 2 - 20, ScrH() - 20)
		end
	end
)

function TRAIT:Think()
	local mousex = math.Clamp(gui.MouseX(), 1, ScrW()-1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH()-1)

	if(self.Hovered && self:GetDraggable() && self:IsInBounds(mousex, mousey) &&(not self.oldb)) then
		if(gui.MouseX() >= ScrW()) then
			GESTURE_RIGHT = true
		elseif GESTURE_RIGHT then
			GESTURE_RIGHT = false
		end

		if(gui.MouseX() <= 0) then
			GESTURE_LEFT = true
		elseif GESTURE_LEFT then
			GESTURE_LEFT = false
		end

		if(gui.MouseY() <= 0) then
			surface.SetDrawColor(0, 0, 0, 210)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			GESTURE_UP = true
		elseif GESTURE_UP then
			GESTURE_UP = false
		end
	end

	if(self.Dragging and self.oldb) then
		self:SetSize(self.oldb.w, self.oldb.h)
		self:SetPos(self.oldb.x, 0)

		self.Abort = true
		self.oldb = nil

		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }

		timer.Simple(0, function() self.Abort = nil end)
	end
end

function TRAIT:OnMouseReleased()
	if GESTURE_LEFT then
		local x, y = self:GetPos()
		local w, h = self:GetSize()

		self.oldb = { x = x, y = y, w = w, h = h }

		self:SetPos(0, 0)
		self:SetSize(ScrW() / 2, ScrH())
	end
	
	if GESTURE_RIGHT then
		local x, y = self:GetPos()
		local w, h = self:GetSize()

		self.oldb = { x = x, y = y, w = w, h = h }

		self:SetPos(ScrW() / 2, 0)
		self:SetSize(ScrW() / 2, ScrH())
	end

	if GESTURE_UP then
		if(self:GetCanFullScreen()) then
			local x, y = self:GetPos()
			local w, h = self:GetSize()

			self.oldb = { x = x, y = y, w = w, h = h }

			self:SetPos(0, 0)
			self:SetSize(ScrW(), ScrH())
		else
			self:SetPos(self.x, 0)
		end
	end
end

nsgui.trait.Register("gestures", TRAIT)