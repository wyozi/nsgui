local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
end

function PANEL:PerformLayout()
	local y = 0
	for k,v in pairs(self:GetChildren()) do
		v:SetPos(0, y)
		v:SetWide(self:GetWide())

		y = y+v:GetTall()
	end

	self:GetTall(y)
end

function PANEL:AddTextNode(...)
	local node = self:Add("NSConsole_NodeText")

	node:SetContent(...)

	return node
end

nsgui.trait.Import(PANEL, "state")
nsgui.skin.HookPaint(PANEL, "PaintConsole")

nsgui.Register("NSConsole", PANEL, "Panel")

--[[
local NODE_TEXT = {}

function NODE_TEXT:Init()
end

function NODE_TEXT:SetContent(...)
	for i,v in pairs{...} do
		local lbl = self:Add("DTextEntry")
		lbl:SetText(tostring(v))
		lbl:SetAllowNonAsciiCharacters(false)
		lbl:SetEnabled(false)
		lbl:SizeToContents()
		lbl:SetTextColor(HSVToColor(i*90, 0.95, 0.5))

		function lbl:GetPreferredSize()
			surface.SetFont(self:GetFont())
			local w, h = surface.GetTextSize(self:GetText())
			return w + 5, h
		end

		function lbl:Paint()
			self:DrawTextEntryText(self:GetTextColor(), Color(255, 127, 0), Color(0, 0, 0))
		end
	end
end

function NODE_TEXT:PerformLayout()
	local x = 0
	for k,v in pairs(self:GetChildren()) do
		v:SetPos(x, 0)
		v:SetSize(v:GetPreferredSize(), self:GetTall())

		x = x+v:GetWide()
	end
end

function NODE_TEXT:Paint(w, h)
	surface.SetDrawColor(127, 127, 127)
	surface.DrawText(0, h, w, h)
end

nsgui.Register("NSConsole_NodeText", NODE_TEXT, "Panel")
]]

local NODE_TEXT = {}

function NODE_TEXT:Init()
	self:SetCursor("beam")
	self:SetMouseInputEnabled(true)
end

-- TextNode consists of nodes, where each node can be one of following
-- Node length is in parenthesis
--   * string (#str)
--   * color table (0)
--   * material (1)
--   * other object (#stringified)

function NODE_TEXT:SetContent(...)
	self.nodes = {...}

	self:ComputeNodeBounds()
end

function NODE_TEXT:ComputeNodeBounds()
	self.nodeBounds = {}

	local x, y = 2, 2
	for i,node in pairs(self.nodes) do
		local tw, th = surface.GetTextSize(node)
		self.nodeBounds[i] = {x=x, y=y, w=tw, h=th}

		x = x+tw+2
	end
end

function NODE_TEXT:NodeColumnSize(node)
	if type(node) == "string" then
		return #node
	end
	error("NodeColumnSize not implemented for " .. tostring(node))
end

function NODE_TEXT:XYToNodeI(x, y)
	for i, b in pairs(self.nodeBounds) do
		if b.x <= x and b.y <= y and (b.x+b.w) >= x and (b.y+b.h) >= y then return i, x-b.x+1, y-b.y+1 end
	end
end

function NODE_TEXT:XYToCol(x, y)
	local node, localX, localY = self:XYToNodeI(x, y)
	if not node then return end

	local c = 0
	for i=1,node-1 do
		c = c + self:NodeColumnSize(self.nodes[i])
	end

	-- If curNode is a string, find the col inside string
	local curNode = self.nodes[node]
	if type(curNode) == "string" then
		surface.SetFont("DermaDefault")
		local x = 0
		for i=1, #curNode do
			local char = curNode:sub(i, i)
			local cx = surface.GetTextSize(char)

			local mid = x + (cx/2)
			print(char, mid)
			if mid >= localX then
				break
			end
			c = c+1

			x = x+cx
		end
	end

	return c
end

function NODE_TEXT:Paint(w, h)
	surface.SetDrawColor(127, 127, 127)
	surface.DrawText(0, h, w, 0)

	for i,node in pairs(self.nodes) do
		local bounds = self.nodeBounds[i]

		surface.SetFont("DermaDefault")
		surface.SetTextPos(bounds.x, bounds.y)
		surface.SetTextColor(0, 0, 0)
		surface.DrawText(node)
	end

	local lx, ly = self:ScreenToLocal(gui.MousePos())
	local node, _lx, _ly = self:XYToNodeI(lx, ly)
	if node then
		local nodeb = self.nodeBounds[node]
		surface.SetDrawColor(255, 127, 0, 200)
		surface.DrawRect(nodeb.x, nodeb.y, nodeb.w, nodeb.h)

		print(self:XYToCol(lx, ly), _lx, _ly)
	end

	if self.Selection and self.Selection.start and self.Selection["end"] then
		surface.SetDrawColor(255, 127, 0, 200)

		local _sx = self:ColRowToXY(unpack(self.Selection.start))
		local _ex = self:ColRowToXY(unpack(self.Selection["end"]))
		surface.DrawRect(_sx, 2, _ex-_sx, 22)
	end
end

function NODE_TEXT:ColRowToXY(col, row)
	local subtxt = self.txt:sub(1, col)

	surface.SetFont("DermaDefault")
	return surface.GetTextSize(subtxt)
end

function NODE_TEXT:XYToColRow(x, y)
	surface.SetFont("DermaDefault")
	for i=0, #self.txt do
		local tx = surface.GetTextSize(self.txt:sub(1, i))
		if tx > x then
			return i, 1
		end
	end
end

function NODE_TEXT:OnMousePressed()
	self.Selection = {}

	local x, y = self:ScreenToLocal(gui.MousePos())
	self.Selection.start = {self:XYToColRow(x, y)}
end
function NODE_TEXT:OnCursorMoved(x, y)
	if not input.IsMouseDown(MOUSE_LEFT) then
		return
	end
	if not self.Selection then return end
	
	self.Selection["end"] = {self:XYToColRow(x, y)}
end

nsgui.Register("NSConsole_NodeText", NODE_TEXT, "Panel")