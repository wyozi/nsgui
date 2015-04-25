TRAIT = { }

TRAIT.Dependencies = { "drag" }

nsgui.Accessor(TRAIT, "_canfullscreen", "CanFullScreen", FORCE_BOOL)

function TRAIT:Init()
	self:SetCanFullScreen(true)

	self:AddHook("Think", "GestureThink", function() self:GestureThink() end)
	self:AddHook("OnMousePressed", "GestureOnMousePressed", function() self:GestureOnMousePressed() end)
end

function TRAIT:GestureThink()
	if self.Dragging then
		local x, y = self:GetParent():ScreenToLocal(gui.MousePos())

		if y < 10 and not self._NormalBounds then
			self._NormalBounds = {
				pos = {self.x, 0},
				size = {self:GetSize()}
			}
			
			local parent = self:GetParent()
			local w, h
			if IsValid(parent) then
				w, h = parent:GetSize()
			else
				w, h = ScrW(), ScrH()
			end
			self:SetPos(0, 0)
			self:SetSize(w, h)

			self._OverrideDragPos = true
		elseif y > 10 and self._NormalBounds then
			self:SetPos(unpack(self._NormalBounds.pos))
			self:SetSize(unpack(self._NormalBounds.size))
			self._NormalBounds = nil

			self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }

			self._OverrideDragPos = false
		end
	end
end

nsgui.trait.Register("gestures", TRAIT)