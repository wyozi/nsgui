local TRAIT = {}

AccessorFunc(TRAIT, "_sizeable", "Sizeable", FORCE_BOOL )
AccessorFunc(TRAIT, "_minwidth", "MinWidth" )
AccessorFunc(TRAIT, "_minheight", "MinHeight" )

function TRAIT:MakeSizeable ( )
	self:SetSizeable ( true )

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	function self:Think()
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	    local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

		if ( self.Sizing ) then

			local x = mousex - self.Sizing[1]
			local y = mousey - self.Sizing[2]
			local px, py = self:GetPos()

			if ( x < self._minwidth ) then x = self._minwidth elseif ( x > ScrW() - px ) then x = ScrW() - px end
			if ( y < self._minheight ) then y = self._minheight elseif ( y > ScrH() - py ) then y = ScrH() - py end

			self:SetSize( x, y )
			self:SetCursor( "sizenwse" )
			return

		end

		if ( self.Hovered && self:GetSizeable ( ) &&
			 mousex > ( self.x + self:GetWide() - 20 ) &&
			 mousey > ( self.y + self:GetTall() - 20 ) ) then

			self:SetCursor( "sizenwse" )
			return

		end

		self:SetCursor( "arrow" )

	end

	function self:OnMousePressed()

		if ( self:GetSizeable ( ) ) then

			if ( gui.MouseX() > ( self.x + self:GetWide() - 20 ) &&
				gui.MouseY() > ( self.y + self:GetTall() - 20 ) ) then

				self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
				self:MouseCapture( true )
				return
			end

		end

	end

	function self:OnMouseReleased()

		if ( self:GetSizeable ( ) ) then
			self.Sizing = nil
			self:MouseCapture( false )
		end

	end
end

nsgui.trait.Register("resize", TRAIT)