TRAIT = { }

TRAIT.Default = true

function TRAIT:Add ( comp, x, y, w, h )
	if ( self:IsValid ( ) ) then
		local panel = vgui.Create ( comp, self )

		if ( not panel ) then
			error ( "attempt to add comp '".. comp ..' (does not exist)' )
		end

		if ( x and y ) then
			panel:SetPos ( x, y )
		end

		if ( w and h ) then
			panel:SetSize ( w, h )
		end

		return panel
	end
end

nsgui.trait.Register ( "add", TRAIT )