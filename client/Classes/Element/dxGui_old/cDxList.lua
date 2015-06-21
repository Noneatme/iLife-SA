--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxList = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxList:constructor(left, top, width, height, color, Parent, focusScroll)

	self.Color = tocolor(0, 0, 0, 155)
	self.Parent = Parent or false
	
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end
	
	self.Columns = {}
	self.Rows = {}
	self.SelectedRow = 0
	self.Scroll = 0
	self.focusScroll = focusScroll
	
	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
	
	self.fSelect = bind(self.select, self)
	addEventHandler("onClientClick", getRootElement(),self.fSelect)
	
	self.bScrollUp = bind(self.scrollUp, self)
	self.bScrollDown = bind(self.scrollDown, self)
	bindKey("mouse_wheel_up", "down", self.bScrollUp)
	bindKey("mouse_wheel_down", "down", self.bScrollDown)
end

function CDxList:destructor()
	unbindKey("mouse_wheel_up", "down", self.bScrollUp)
	unbindKey("mouse_wheel_down", "down", self.bScrollDown)
end

function CDxList:render()

	cX,cY = getCursorPosition ()
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.tColor = tocolor(0, 0, 0,200)
	else
		self.tColor = self.Color
	end
	
	--[[
	dxDrawImage(self.X+1, self.Y, 15, self.Height, "res/images/dxGui/dxButtonLeft.png", 0, 0, 0, self.tColor)
	dxDrawImage(self.X+self.Width-16, self.Y, 15, self.Height, "res/images/dxGui/dxButtonRight.png", 0, 0, 0, self.tColor)
	dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxButtonMid.png", 0, 0, 0, self.tColor)
	]]

	dxDrawRectangle(self.X, self.Y, self.Width, self.Height, self.tColor)
	
	local columnWidth = self.Width/#self.Columns
	
	for i,v in ipairs(self.Columns) do
		dxDrawText(tostring(v), self.X+((i-1)*columnWidth)+5, self.Y, (self.X+(i*columnWidth))-1, self.Y+20, tocolor(255,255,255,255), 1, "default-bold", "left", "center", true, true)
	end
	
	local absHeight = 20
	dxDrawLine(self.X, self.Y+absHeight-1, self.X+self.Width-4, self.Y+absHeight-1, tocolor(255, 255, 255,255), 2)	
		
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
				dxDrawRectangle(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, tocolor(25,255,25,200))
			end
			for i2, v2 in ipairs(self.Columns) do
				dxDrawText(gettok(v, i2, "|"), self.X+((i2-1)*columnWidth)+5, (self.Y+absHeight)-self.Scroll, self.X+i2*columnWidth, (self.Y+absHeight+curHeight)-self.Scroll, tocolor(255,255,255,255), 1, "default", "left", "center", true, true)
			end
		end
		absHeight = absHeight+curHeight
	end
	
	if (absHeight > self.Height-20) then	
		local pos = (self.Scroll/absHeight)*(self.Height-20)
		dxDrawLine(self.X+self.Width-2, self.Y+20+pos, self.X+self.Width-2, (self.Y+20+(self.Height-20)-(((absHeight-self.Scroll-(self.Height-20))/absHeight)*(self.Height-20)))+(self.Height%20), tocolor(200, 200, 200,255), 4)
	else
		dxDrawLine(self.X+self.Width-2, self.Y+20, self.X+self.Width-2, self.Y+self.Height, tocolor(200, 200, 200,255), 4)
	end
	
end

function CDxList:select(key, state)
	if (key == "left") and (state == "down") and (not (self:getDisabled())) then
		cX,cY = getCursorPosition ()
		if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		
		local columnWidth = self.Width/#self.Columns
		local absHeight = 20
		
			for i,v in ipairs(self.Rows) do
			
				local curHeight = 20
				for i2, v2 in ipairs(self.Columns) do
					if ((dxGetTextWidth(gettok(v, i2, "|"))/columnWidth) > 1) and ((math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20 > curHeight) then
						curHeight = (math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20
					end
				end
				
				if ( isCursorOverRectangle(cX, cY, self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight)) then
					self.SelectedRow = i
					return
				end
				absHeight = absHeight+curHeight
			end
		end
	end
end

function CDxList:addColumn(sName)
	table.insert(self.Columns, sName)
end

function CDxList:addRow(sData)
	table.insert(self.Rows, sData)
end

function CDxList:getSelectedRow()
	return self.SelectedRow
end

function CDxList:getRowCount()
	return #self.Rows
end


function CDxList:setSelectedRow(iRow)
	if (iRow <= #self.Rows) then
		self.SelectedRow = iRow
	end
end

function CDxList:getRowData(iColumn)
	if (self.SelectedRow ~= 0) then
		return gettok(self.Rows[self.SelectedRow], iColumn, "|")
	else
		return "nil"
	end
end

function CDxList:scrollUp()
	cX,cY = getCursorPosition ()
	if (isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height))  or self.focusScroll then
		local rowHeight = {}
		local absHeight = 20
		local columnWidth = self.Width/#self.Columns
		for i, v in ipairs(self.Rows) do
			local curHeight = 20
			for i2, v2 in ipairs(self.Columns) do
				if ((dxGetTextWidth(gettok(v, i2, "|"))/columnWidth) > 1) and ((math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20 > curHeight) then
					curHeight = (math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20
				end
			end
			rowHeight[i] = curHeight
			absHeight = absHeight + curHeight
		end
		if (absHeight > self.Height) then
			local pHeight = 0
			for k,v in ipairs(rowHeight) do
				if (pHeight+v >= self.Scroll) then
					self.Scroll = pHeight
					break;
				else
					pHeight = pHeight+v
				end
			end
		end
	end
end

function CDxList:scrollDown()
	cX,cY = getCursorPosition ()
	if (isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height))  or self.focusScroll then
		local rowHeight = {}
		local absHeight = 20
		local columnWidth = self.Width/#self.Columns
		for i, v in ipairs(self.Rows) do
			local curHeight = 20
			for i2, v2 in ipairs(self.Columns) do
				if ((dxGetTextWidth(gettok(v, i2, "|"))/columnWidth) > 1) and ((math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20 > curHeight) then
					curHeight = (math.floor(dxGetTextWidth(gettok(v, i2, "|"))/columnWidth)+1)*20
				end
			end
			rowHeight[i] = curHeight
			absHeight = absHeight + curHeight
		end
		if (absHeight > self.Height) then
			local pHeight = 20
			for k,v in ipairs(rowHeight) do
				if ((absHeight-self.Scroll) > self.Height) then
					self.Scroll = self.Scroll+v
					break;
				end
			end
		end
	end
end

function CDxList:clearRows()
	self.Rows = {}
	self.SelectedRow = 0
	self.Scroll = 0
end