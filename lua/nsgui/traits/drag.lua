local TRAIT = {}

AccessorFunc(TRAIT, "_draggable", "Draggable", FORCE_BOOL )

function TRAIT:Init ( )
	self:SetDragBounds ( 0, 0, self:GetWide ( ), self:GetTall ( ) )
end

function TRAIT:SetDragBounds ( x, y, w, h )
	self._DragBounds = { x = x, y = y, w = w, h = h }
end

function TRAIT:GetDragBounds ( )
	local d = self._DragBounds

	return d.x, d.y, d.w, d.h
end

function TRAIT:IsInBounds ( x, y )
	local bx, by, bw, bh = self:GetDragBounds ( )

	return ( ( x > ( self.x + bx ) ) and ( y > ( self.y + by ) ) and ( x < ( self.x + bx + bw ) ) and ( y < ( self.y + by + bh ) ) )
end

	function TRAIT:Think()
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
		local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

		if ( self.Dragging ) then

			local x = mousex - self.Dragging[1]
			local y = mousey - self.Dragging[2]

			self:SetPos( x, y )

		end

		if ( self.Hovered && self:GetDraggable() && self:IsInBounds ( mousex, mousey ) ) then
			self:SetCursor( "sizeall" )
			self._Cursor = "sizeall"
			return
		end

		if ( self._Cursor != "arrow" and ( self._Cursor == "sizeall" ) ) then
			self:SetCursor "arrow"
			self._Cursor = "arrow"
		end

		if ( self.y < 0 ) then
			self:SetPos( self.x, 0 )
		end

	end

	function TRAIT:OnMousePressed()

		if ( self:GetDraggable() && self:IsInBounds ( gui.MouseX ( ), gui.MouseY ( ) ) ) then
			self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
			self:MouseCapture( true )

			return
		end

	end

	function TRAIT:OnMouseReleased()

		if self:GetDraggable ( ) then
			self.Dragging = nil
			self:MouseCapture( false )
		end

	end

nsgui.trait.Register("drag", TRAIT)