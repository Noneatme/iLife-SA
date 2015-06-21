--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxTreeView = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxTreeView:constructor(left, top, width, height, color, Parent)

	self.Color = tocolor(0, 0, 0, 155)
	self.Parent = Parent or false
	
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end

	self.Items				= {}
	self.Rows 				= {}
	self.SelectedRow 		= 0
	self.Columns			= {}
	self.Scroll 			= 0
	self.BackgroundColor	= tocolor(100, 100, 100, 30);

	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
end

function CDxTreeView:destructor()

end

function CDxTreeView:addColumn(sName)
	table.insert(self.Columns, sName)
end

function CDxTreeView:addRow(sData)
	table.insert(self.Rows, sData)
end
--[[
function CDxTreeView:addCategory(iCategory, sCategory, iPreviousCategory)
	if not(self.Items[iCategory]) then
		self.Items[iCategory]		= {}
	end

	self.CategoryNames[iCategory]	= sCategory;
end

function CDxTreeView:addItem(sItem, iCategory)
	if not(self.Items[iCategory]) then
		self:addCategory(iCategory, "Unknown")
	end

	if not(self.ItemIndexes[iCategory]) then
		self.ItemIndexes[iCategory] = 1;
	end

	self.Items[iCategory][sItem] 	= self.ItemIndexes[iCategory];

	self.ItemIndexes[iCategory]		= self.ItemIndexes[iCategory]+1;
end
]]
function CDxTreeView:render()
	cX,cY		= getCursorPosition ()
	local color = self.BackgroundColor
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		color 	= tocolor(50, 50, 50, 155)
	end
	--[[
	--<23:02:50> "ReWrite": Node { nodes={}; value=... }
<23:03:22> "ReWrite": Node { parent=...; nodes={}; value=... }
	 ]]

	--[[
	dxDrawImage(self.X+1, self.Y, 15, self.Height, "res/images/dxGui/dxButtonLeft.png", 0, 0, 0, self.tColor)
	dxDrawImage(self.X+self.Width-16, self.Y, 15, self.Height, "res/images/dxGui/dxButtonRight.png", 0, 0, 0, self.tColor)
	dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxButtonMid.png", 0, 0, 0, self.tColor)
	]]

	dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/guibg.png", 0, 0, 0, color)
	dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/dxGui/background-alpha.png", 0, 0, 0, tocolor(255, 255, 255, 155))

	-- Lines --
	-- BLACK
	dxDrawLine(self.X, self.Y, self.X+self.Width, self.Y, tocolor(0, 0, 0, 255));		-- Oben
	dxDrawLine(self.X, self.Y+self.Height, self.X+self.Width, self.Y+self.Height, tocolor(0, 0, 0, 255)); -- unten
	dxDrawLine(self.X, self.Y, self.X, self.Y+self.Height, tocolor(0, 0, 0, 255));		-- Links
	dxDrawLine(self.X+self.Width, self.Y, self.X+self.Width, self.Y+self.Height, tocolor(0, 0, 0, 255));		-- Rechts

	-- WHITE
	dxDrawLine(self.X+1, self.Y+1, self.X+self.Width-1, self.Y+1, tocolor(255, 255, 255, 25));		-- Oben
	dxDrawLine(self.X+1, self.Y+self.Height-1, self.X+self.Width-1, self.Y+self.Height-1, tocolor(255, 255, 255, 25)); -- unten
	dxDrawLine(self.X+1, self.Y+1, self.X+1, self.Y+self.Height-1, tocolor(255, 255, 255, 25));		-- Links
	dxDrawLine(self.X+self.Width-1, self.Y+1, self.X+self.Width-1, self.Y+self.Height-1, tocolor(255, 255, 255, 25));		-- Rechts

	local columnWidth = self.Width
	local absHeight = 0;
	for i,v in ipairs(self.Columns) do
		if(fileExists(tostring(v))) then
			dxDrawImage(self.X+((i-1)*columnWidth)+5, self.Y, (self.X+(i*columnWidth))-1, self.Y+20, tostring(v), 0, 0, 0, tocolor(255,255,255,255))

		else
			dxDrawText(tostring(v), self.X+((i-1)*columnWidth)+5, self.Y, (self.X+(i*columnWidth))-1, self.Y+20, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
		end
	end

	local absHeight = 20
	dxDrawLine(self.X+2, self.Y+absHeight-1, self.X+self.Width-4, self.Y+absHeight-1, tocolor(255, 255, 255,255), 1)

	for i, v in ipairs(self.Rows) do
		local curHeight = 20
		for i2, v2 in ipairs(self.Columns) do
			if ((dxGetTextWidth(gettok(v, i2, "|"))/columnWidth) > 1) and ((math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20 > curHeight) then
				curHeight = (math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20
			end
		end
		if (isPointInRectangle(self.X+5, (self.Y+absHeight+curHeight-1)-self.Scroll, self.X, self.Y+curHeight-1, self.Width, self.Height-curHeight+1)) then
			cX,cY = getCursorPosition ()
			if (isCursorOverRectangle(cX, cY, self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight)) then
				dxDrawRectangle(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, tocolor(50,50,50,125))
			end
			if (self.SelectedRow == i) then
				dxDrawRectangle(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, tocolor(50,50,50, 125))
			end

			local ix, iy, iw, ih = self.X, (self.Y+absHeight)-self.Scroll+curHeight, self.X+self.Width, ((self.Y+absHeight)-self.Scroll)+curHeight

			dxDrawImage(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, tocolor(50, 150, 250, 50))

			dxDrawLine(ix+3, iy+1, iw, ih+1, tocolor(0, 0, 0, 125), 1)
			dxDrawLine(ix+3, iy, iw, ih, tocolor(255, 255, 255, 25), 1)

			for i2, v2 in ipairs(self.Columns) do
				dxDrawText(gettok(v, i2, "|"), self.X+((i2-1)*columnWidth)+5, (self.Y+absHeight)-self.Scroll, self.X+i2*columnWidth, (self.Y+absHeight+curHeight)-self.Scroll, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
			end
		end
		absHeight = absHeight+curHeight
	end

	if (absHeight > self.Height-20) then
		local pos = (self.Scroll/absHeight)*(self.Height-20)
		dxDrawLine(self.X+self.Width-2, self.Y+20+pos, self.X+self.Width-2, (self.Y+20+(self.Height-20)-(((absHeight-self.Scroll-(self.Height-20))/absHeight)*(self.Height-20)))+(self.Height%20), tocolor(200, 200, 200,255), 2)
	else
		dxDrawLine(self.X+self.Width-2, self.Y+20, self.X+self.Width-2, self.Y+self.Height, tocolor(200, 200, 200,255), 2)
	end

	--	dxDrawText(tostring(v), self.X+((i-1)*columnWidth)+5, self.Y, (self.X+(i*columnWidth))-1, self.Y+20, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
end
