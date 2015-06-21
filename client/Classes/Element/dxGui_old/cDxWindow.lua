--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

screenX, screenY = guiGetScreenSize ()
clientBusy = false
CDxWindow = inherit(CDxElement)


beforeOpenState = false
--[[
	CDxWindow(sTitle, iWidth, iHeight, sPosition[, iX, iY])
	
		sTitle 	= Title of the window
		iWidth 	= Width in pixels
		iHeight	= Height in pixels
		sPos 	= Position ("Absolute" or "Align|vAlign")
					Align =   "Left, Center, Right"
					vAlign =  "Top , Middle, Bottom"
		iX, iY 	= If position is "Absolute" then position in pixels
]]

function CDxWindow:constructor(sTitle, iWidth, iHeight, bHeader, bCancable, sPosition, iX, iY)
	self.Title 		= sTitle or "Title"
	self.Width 		= iWidth or "300"
	self.Height 	= iHeight or "500"
	self.Position 	= sPosition or "Center|Middle"
	self.Cancable 	= bCancable or false
	self.Header 	= bHeader or true
	self.ReadOnly 	= false

	local tempX, tempY
	
	if (self.Position == "Absolute") then
		tempX= iX
		tempY = iY
	else
		self.Align = gettok(self.Position, 1, "|")
		self.vAlign = gettok(self.Position, 2, "|")
		-- Align
		if(self.Align == "Left") then
			tempX = 1
		else
			if (self.Align == "Center") then
				tempX = (screenX/2)-(self.Width/2) 
			else
				tempX = screenX-self.Width
			end
		end
		-- vAlign
		if (self.vAlign == "Top") then
			tempY = 1
		else
			if (self.vAlign == "Middle") then
				tempY = (screenY/2)-(self.Height/2) 
			else
				tempY = screenY-self.Height
			end
		end
	end
	
	CDxElement.constructor(self, tempX or 50, tempY or 50, iWidth or 250, iHeight or 500)
	
	self.StartX = self.X+2
	self.StartY = self.Y+29
	
	self.Elements = {}
	self.guiElements = {
		["edit"]={},
		["memo"]={}
	}
	
	self.eOnRender = bind(self.onRender, self)
	self.eOnCloseButtonClick = bind(self.onCloseButtonClick, self)
end

function CDxWindow:destructor()
	for key, theElement in pairs(self.Elements) do
		delete(theElement)
		theElement = nil
	end
	
	for key, value in pairs(self.guiElements) do
		for k,v in ipairs(value) do
			destroyElement(v)
		end
	end
end

function CDxWindow:setReadOnly(bReadOnly)
	self.ReadOnly = bReadOnly
end

function CDxWindow:setTitle(sTitle)
	self.Title = sTitle
end

function CDxWindow:show()
	if ((clientBusy) and not(self.ReadOnly)) then
		return false
	end
	playSound("res/sounds/poke.wav", false)
	addEventHandler("onClientRender", getRootElement(), self.eOnRender)
	self:addClickHandlers(0)
	for key, value in ipairs(self.Elements) do
		value:addClickHandlers(key)
	end
	
	for key, value in pairs(self.guiElements) do
		for k,v in ipairs(value) do
			guiSetVisible(v, true)
		end
	end
	
	if ( not(self.ReadOnly) ) then
		if not(getElementData(localPlayer, "inSpecial")) then
			toggleAllControls(false)
		else
			beforeOpenState = isControlEnabled("forwards")
		end
		showCursor(true, true)
		cursorOverride = true
		clientBusy = true
	else
	
	end
end

function CDxWindow:hide()
	removeEventHandler("onClientRender", getRootElement(), self.eOnRender)
	self:removeClickHandlers()
	for key, value in ipairs(self.Elements) do
		value:removeClickHandlers()
	end
	
	for key, value in pairs(self.guiElements) do
		for k,v in ipairs(value) do
			guiSetVisible(v, false)
		end
	end
	
	if ( not(self.ReadOnly) ) then
		showCursor(false)
		if not(getElementData(localPlayer, "inSpecial")) then
			toggleAllControls(true)
		else
			toggleAllControls(beforeOpenState)
		end
		cursorOverride = false
		clientBusy = false
	else
	
	end
end

function CDxWindow:onRender()
	dxDrawLine ( self.X, self.Y+28, self.X, self.Y+self.Height, tocolor(0,0,0), 2)
	dxDrawLine ( self.X+self.Width, self.Y+28, self.X+self.Width, self.Y+self.Height, tocolor(0,0,0), 2)
	dxDrawLine ( self.X, self.Y+self.Height, self.X+self.Width, self.Y+self.Height, tocolor(0,0,0), 2)
	dxDrawLine ( self.X, self.Y+28, self.X+self.Width, self.Y+28, tocolor(0,0,0), 2)

	dxDrawImage( self.StartX-1, self.StartY, self.Width-1, self.Height-29, "/res/images/guibg.png")	
	
	for key, theElement in pairs(self.Elements) do
		if (theElement:getVisible()) then
			theElement:render()
		end
	end
	
	if (self.Header) then
		dxDrawImage( self.X+1, self.Y+1, self.Width-1, 27, "res/images/dxGui/dxWindowHeadBackground.png")
		dxDrawLine ( self.X, self.Y, self.X+self.Width, self.Y, tocolor(0,0,0), 2)
		dxDrawLine ( self.X, self.Y, self.X, self.Y+28, tocolor(0,0,0), 2)
		dxDrawLine ( self.X+self.Width, self.Y, self.X+self.Width, self.Y+28, tocolor(0,0,0), 2)
		if (self.Cancable) then
			if (isCursorShowing()) then
				cX,cY = getCursorPosition ()
				if ( isCursorOverRectangle(cX,cY,self.X+self.Width-28, self.Y+4, 22, 22) ) then
					color = tocolor(255,255,255,255)
				else
					color = tocolor(125,125,125,255)
				end
			else
				color = tocolor(125,125,125,255)
			end
			dxDrawImage( self.X+self.Width-28, self.Y+4, 22, 22, "res/images/dxGui/dxWindowHeadClose.png", 0, 0, 0, color)
			dxDrawText ( self.Title, self.X+2, self.Y+2 , self.X+self.Width-30, self.Y+27, tocolor(255,255,255,255), 1.3, "default", "center", "center",true, false, false)
		else
			dxDrawText ( self.Title, self.X+2, self.Y+2 , self.X+self.Width-2, self.Y+27, tocolor(255,255,255,255), 1.3, "default", "center", "center",true, false, false)
		end
	end
end

function CDxWindow:getStartPosition()
	return self.StartX,self.StartY
end

function CDxWindow:add(theElement)
	table.insert(self.Elements,theElement)
end

function CDxWindow:addGE(theGuiElement)
	guiSetVisible(theGuiElement, false)
	local x,y = guiGetPosition(theGuiElement, false)
	guiSetPosition(theGuiElement, self.StartX+x, self.StartY+y, false)

	if (getElementType(theGuiElement) == "gui-edit") then
		table.insert(self.guiElements["edit"], theGuiElement)
	end
	if (getElementType(theGuiElement) == "gui-memo") then
		table.insert(self.guiElements["memo"], theGuiElement)
	end
end


function CDxWindow:addClickHandlers()
	if(self.Cancable) then
		addEventHandler ( "onClientClick", getRootElement(), self.eOnCloseButtonClick)
	end
end

function CDxWindow:onCloseButtonClick(button, state)
	if (button == "left") and (state == "down") then
		cX,cY = getCursorPosition ()
		if (isCursorOverRectangle(cX,cY,self.X+self.Width-28, self.Y+4, 22, 22)) then
			if (self.xtraHide) then
				self.xtraHide()
			end
			self:hide()
		end
	end
end

function CDxWindow:setHideFunction(func)
	self.xtraHide = func
end

function CDxWindow:removeClickHandlers()
	if (self.Cancable) then
		removeEventHandler ( "onClientClick", getRootElement(), self.eOnCloseButtonClick)
	end
end

function CDxWindow:exist()
	return true
end