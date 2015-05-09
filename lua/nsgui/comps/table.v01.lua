-- Extremely small OOP library
local function Class(name, parent)
	local t = {}

	local meta = {}
	meta.__call = function(_, ...)
		local inst = setmetatable({}, {__index = t})
		if inst.initialize then inst:initialize(...) end
		return inst
	end
	if parent then meta.__index = parent end

	setmetatable(t, meta)

	return t
end

local Unit = Class("Unit")
local FixedUnit = Class("FixedUnit", Unit)
function FixedUnit:initialize(size)
	self.size = size
end
function FixedUnit:getSize(containerSize)
	return self.size
end

local PercUnit = Class("PercUnit", Unit)
function PercUnit:initialize(perc)
	self.perc = perc
end
function FixedUnit:getSize(containerSize)
	return self.perc * containerSize
end

local GridDim = Class("GridDim")
nsgui.Accessor(GridDim, "_size", "Size")
nsgui.Accessor(GridDim, "_expanded", "Expanded")
function GridDim:Reset()
	self:SetSize(0)
	self:SetExpanded(false)
end

local Row = Class("Row", GridDim)
local Column = Class("Column", GridDim)

local A_TOP =    bit.lshift(1, 1)
local A_BOTTOM = bit.lshift(1, 2)
local A_LEFT =   bit.lshift(1, 3)
local A_RIGHT =  bit.lshift(1, 4)

local Cell = Class("Cell")
nsgui.Accessor(Cell, "_align", "Alignment")
nsgui.Accessor(Cell, "_expandedX", "ExpandedX")
nsgui.Accessor(Cell, "_expandedY", "ExpandedY")
nsgui.Accessor(Cell, "_filledX", "FilledX")
nsgui.Accessor(Cell, "_filledY", "FilledY")
nsgui.Accessor(Cell, "_width", "Width")
nsgui.Accessor(Cell, "_height", "Height")
nsgui.Accessor(Cell, "_paddingL", "PaddingLeft")
nsgui.Accessor(Cell, "_paddingT", "PaddingTop")
nsgui.Accessor(Cell, "_paddingR", "PaddingRight")
nsgui.Accessor(Cell, "_paddingB", "PaddingBottom")
function Cell:initialize(comp)
	self.comp = comp
	self:Center()
end
function Cell:GetComponent() return self.comp end
--- Returns the size the cell wants to be. ((specifiedSize or comp.size) + margins + paddings)
function Cell:GetPreferredCellSize()
	local w, h = self:GetWidth() or self:GetComponent():GetWide(), self:GetHeight() or self:GetComponent():GetTall()
	w = w + (self:GetPaddingLeft() or 0) + (self:GetPaddingRight() or 0)
	h = h + (self:GetPaddingTop() or 0) + (self:GetPaddingBottom() or 0)
	return w, h
end
function Cell:SetPadding(x)
	self:SetPaddingLeft(x) self:SetPaddingTop(x) self:SetPaddingRight(x) self:SetPaddingBottom(x) return self
end
function Cell:Expand()
	self:SetExpandedX(true) self:SetExpandedY(true) return self
end
function Cell:Fill()
	self:SetFilledX(true) self:SetFilledY(true) return self
end
function Cell:_SetAlignment(x, contradicting)
	local a = self:GetAlignment()
	a = bit.bor(a, x)
	a = bit.band(a, bit.bnot(contradicting))
	self:SetAlignment(a)
	return self
end
function Cell:Top()
	return self:_SetAlignment(A_TOP, A_BOTTOM)
end
function Cell:Bottom()
	return self:_SetAlignment(A_BOTTOM, A_TOP)
end
function Cell:Right()
	return self:_SetAlignment(A_RIGHT, A_LEFT)
end
function Cell:Left()
	return self:_SetAlignment(A_LEFT, A_RIGHT)
end
function Cell:Center()
	-- Garry, add lua operators please
	self:SetAlignment(A_TOP + A_BOTTOM + A_LEFT + A_RIGHT) return self
end

function Cell:GetAlignmentFractions()
	local alignment = self:GetAlignment()

	local alignx, aligny = 0.5, 0.5

	if bit.band(alignment, A_LEFT) ~= 0 and bit.band(alignment, A_RIGHT) == 0 then
		alignx = 0
	end
	if bit.band(alignment, A_RIGHT) ~= 0 and bit.band(alignment, A_LEFT) == 0 then
		alignx = 1
	end

	if bit.band(alignment, A_TOP) ~= 0 and bit.band(alignment, A_BOTTOM) == 0 then
		aligny = 0
	end
	if bit.band(alignment, A_BOTTOM) ~= 0 and bit.band(alignment, A_TOP) == 0 then
		aligny = 1
	end

	return alignx, aligny
end

local PANEL = {}

nsgui.Accessor(PANEL, "_debugMode", "DebugMode", FORCE_BOOL)

function PANEL:Init()
	self:SetMouseInputEnabled(false)

	-- Internal cell is used for doing stuff with the logical table
	-- It should not be accessed directly, but through exposed methods
	self._internalCell = Cell(self)

	-- Grid[RowIndex][ColumnIndex] = Cell
	self._grid = {}

	self._rows = {}
	self._cols = {}

	self:Row() -- Start first row
end

function PANEL:Top()
	self._internalCell:Top() return self
end
function PANEL:Bottom()
	self._internalCell:Bottom() return self
end
function PANEL:Right()
	self._internalCell:Right() return self
end
function PANEL:Left()
	self._internalCell:Left() return self
end
function PANEL:Center()
	self._internalCell:Center() return self
end

function PANEL:GetRow(i)
	return self._rows[i]
end
function PANEL:GetCol(i)
	return self._cols[i]
end

function PANEL:Row()
	local rowId = #self._rows + 1
	self._grid[rowId] = {}

	local row = Row()
	self._rows[rowId] = row

	return row
end
function PANEL:RowId()
	return #self._rows
end

function PANEL:RowCount()
	return #self._rows
end
function PANEL:ColCount()
	return #self._cols
end

function PANEL:GridRow()
	return self._grid[#self._grid]
end

function PANEL:Add(comp)
	local row = self:GridRow()

	local rowi, coli = self:RowId(), #row+1

	-- Create Column object if it does not exist
	if not self._cols[coli] then
		self._cols[coli] = Column()
	end

	local _cell = Cell(comp)
	comp:SetParent(self)

	_cell.rowi = rowi
	_cell.coli = coli

	_cell.row = self._rows[rowi]
	_cell.col = self._cols[coli]

	table.insert(row, _cell)

	return _cell
end

-- This computes each row and column object's size.
-- This method should be called if any components or the table changes size
function PANEL:ComputeSizes()
	local w, h = self:GetWide(), self:GetTall()

	-- First compute non-expanded sizes and store expanded statuses
	for c=1, self:ColCount() do
		local col = self._cols[c]
		col:Reset()
	end

	for r=1, self:RowCount() do
		local row = self._rows[r]
		row:Reset()

		for c=1, self:ColCount() do
			local col = self._cols[c]

			local cell = self._grid[r][c]
			if cell:GetExpandedX() then
				col:SetExpanded(true)
			end
			if cell:GetExpandedY() then
				row:SetExpanded(true)
			end

			local cw, ch = cell:GetPreferredCellSize()
			col:SetSize(math.max(col:GetSize(), cw))
			row:SetSize(math.max(row:GetSize(), ch))
		end
	end

	-- Then compute equal shares for expanded cols/rows

	local expandSpaceX, expandSpaceY = w, h -- the space available for expanding
	local expandNumX, expandNumY = 0, 0 -- the number of expanders per dimension

	for c=1, self:ColCount() do
		local col = self._cols[c]

		if col:GetExpanded() then
			expandNumX = expandNumX + 1
		else
			expandSpaceX = expandSpaceX - col:GetSize()
		end
	end
	for r=1, self:RowCount() do
		local row = self._rows[r]

		if row:GetExpanded() then
			expandNumY = expandNumY + 1
		else
			expandSpaceY = expandSpaceY - row:GetSize()
		end
	end

	if expandNumX > 0 then
		local expandSpacePer = expandSpaceX / expandNumX

		for c=1, self:ColCount() do
			local col = self._cols[c]

			if col:GetExpanded() then
				col:SetSize(expandSpacePer)
			end
		end
	end
	if expandNumY > 0 then
		local expandSpacePer = expandSpaceY / expandNumY

		for r=1, self:RowCount() do
			local row = self._rows[r]

			if row:GetExpanded() then
				row:SetSize(expandSpacePer)
			end
		end
	end
end

function PANEL:ComputeLogicalSize()
	local logicalWidth, logicalHeight = 0, 0
	for c=1, self:ColCount() do
		logicalWidth = logicalWidth + self:GetCol(c):GetSize()
	end
	for r=1, self:RowCount() do
		logicalHeight = logicalHeight + self:GetRow(r):GetSize()
	end
	return logicalWidth, logicalHeight
end

function PANEL:ComputeLogicalXY()
	local w, h = self:GetWide(), self:GetTall()
	local logicalWidth, logicalHeight = self:ComputeLogicalSize()

	local logicalAlignX, logicalAlignY = self._internalCell:GetAlignmentFractions()
	local logicalMidX, logicalMidY = Lerp(logicalAlignX, 0, w), Lerp(logicalAlignY, 0, h)
	local xStart, yStart = math.Clamp(logicalMidX-logicalWidth/2, 0, w-logicalWidth),
						   math.Clamp(logicalMidY-logicalHeight/2, 0, h-logicalHeight)

	return xStart, yStart
end

function PANEL:PerformLayout()
	self:ComputeSizes()

	local w, h = self:GetWide(), self:GetTall()
	local logicalWidth, logicalHeight = self:ComputeLogicalSize()
	local xStart, yStart = self:ComputeLogicalXY()

	local y = 0
	for r=1, self:RowCount() do
		local row = self._rows[r]
		local rowSize = row:GetSize()

		local x = 0
		for c=1, self:ColCount() do
			local col = self._cols[c]
			local colSize = col:GetSize()

			local cell = self._grid[r][c]
			local comp = cell:GetComponent()

			-- The absolute cell corner values
			local cellx, celly, cellw, cellh = xStart + x, yStart + y, colSize, rowSize

			-- The internal (affected by padding) cell values
			local icellx1, icelly1 = cellx + (cell:GetPaddingLeft() or 0), celly + (cell:GetPaddingTop() or 0)
			local icellx2, icelly2 = cellx + cellw - (cell:GetPaddingRight() or 0), celly + cellh - (cell:GetPaddingBottom() or 0)

			if cell:GetFilledX() then
				comp:SetWide(icellx2 - icellx1)
			end
			if cell:GetFilledY() then
				comp:SetTall(icelly2 - icelly1)
			end

			local compw, comph = comp:GetWide(), comp:GetTall()

			-- Map normalized alignment values to internal cell's coordinates
			local alignx, aligny = cell:GetAlignmentFractions()
			local midX, midY = Lerp(alignx, icellx1, icellx2), Lerp(aligny, icelly1, icelly2)

			-- Clamp mid values.
			-- If this part is skipped, components will "overflow" by 50%, because alignx/aligny
			-- are normalized scalar values for comp's middle position, not edge position
			local compx, compy = math.Clamp(midX-compw/2, icellx1, icellx2-compw), math.Clamp(midY-comph/2, icelly1, icelly2-comph)

			comp:SetPos(compx, compy)

			x = x + colSize
		end

		y = y + rowSize
	end
end

function PANEL:PaintOver()
	if not self:IsDebugMode() then return end

	local w, h = self:GetWide(), self:GetTall()

	local logicalWidth, logicalHeight = self:ComputeLogicalSize()
	local xStart, yStart = self:ComputeLogicalXY()

	local y = 0
	for r=1, self:RowCount() do
		local row = self._rows[r]
		local rowSize = row:GetSize()

		local x = 0
		for c=1, self:ColCount() do
			local col = self._cols[c]
			local colSize = col:GetSize()

			local cell = self._grid[r][c]
			local comp = cell:GetComponent()

			local cellx, celly, cellw, cellh = xStart + x, yStart + y, colSize, rowSize
			local icellx1, icelly1 = cellx + (cell:GetPaddingLeft() or 0), celly + (cell:GetPaddingTop() or 0)
			local icellx2, icelly2 = cellx + cellw - (cell:GetPaddingRight() or 0), celly + cellh - (cell:GetPaddingBottom() or 0)
			local compw, comph = comp:GetWide(), comp:GetTall()

			local alignx, aligny = cell:GetAlignmentFractions()
			local midX, midY = Lerp(alignx, icellx1, icellx2), Lerp(aligny, icelly1, icelly2)

			local compx, compy = math.Clamp(midX-compw/2, icellx1, icellx2-compw), math.Clamp(midY-comph/2, icelly1, icelly2-comph)

			-- Draw component
			surface.SetDrawColor(0, 255, 0)
			surface.DrawOutlinedRect(compx, compy, compw, comph)

			-- Draw inner cell
			surface.SetDrawColor(0, 0, 255)
			surface.DrawOutlinedRect(icellx1, icelly1, icellx2-icellx1, icelly2-icelly1)

			-- Draw cell
			surface.SetDrawColor(255, 0, 0)
			surface.DrawOutlinedRect(cellx, celly, cellw, cellh)

			x = x + colSize
		end

		y = y + rowSize
	end

	-- Draw logical table
	surface.SetDrawColor(255, 127, 0)
	surface.DrawOutlinedRect(xStart, yStart, logicalWidth, logicalHeight)
end

nsgui.Register("NSTable", PANEL, "Panel")

concommand.Add("nsgui.TestTable", function()
	local comp = nsgui.TestComp("NSTable")

	local function Label(txt)
		local l = vgui.Create("DLabel")
		l:SetText(txt)
		l:SizeToContents()
		l:SetTextColor(Color(0, 0, 0))
		return l
	end

	comp:Bottom():Right()

	comp:Add(Label("Hello")):Right():Bottom()
	comp:Add(Label("World")):SetPadding(5):Left()
	comp:Row()

	comp:Add(Label("What's")):Fill():SetPadding(10)
	comp:Add(Label(string.rep("swag", 3))):SetPadding(5):Top()

	comp:SetDebugMode(true)
end)