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


CDxWindow.gFont		= dxCreateFont("res/fonts/xolonium-regular.ttf", 32)
CDxWindow.gFont2		= dxCreateFont("res/fonts/xolonium-regular.ttf", 64)
CDxWindow.gTFont	= dxCreateFont("res/fonts/OSP-DIN.ttf", 20)
CDxWindow.gBFont	= dxCreateFont("res/fonts/uni05_53.ttf", 16)

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

function CDxWindow:constructor(sTitle, iWidth, iHeight, bHeader, bCancable, sPosition, iX, iY, tblInfo, helpText)
	self.Title 		= sTitle or "Title"
	self.Width 		= iWidth or "300"
	self.Height 	= iHeight or "500"
	self.Position 	= sPosition or "Center|Middle"
	self.Cancable 	= bCancable or false
	self.Header 	= bHeader or true
	self.ReadOnly 	= false

	self.BackgroundColor	= tocolor(45, 63, 64, 155);
	self.UseCustomHeader	= false;

	self.HelpShowing	= false;

	if(tblInfo) then
		self.UseCustomHeader 	= true;
		self.CustomHeaderColor	= tblInfo[1] or (tocolor(255, 255, 255, 155));
		self.HeaderIcon			= tblInfo[2] or ("res/images/dxGui/misc/icons/info.png");
		self.HeaderText			= tblInfo[3] or ("Information")
	end

	self.HelpText			= (helpText or false)


	self.iHeaderSize	= 17;

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

	self.StartX 		= self.X+2

	self.StartY 		= self.Y+self.iHeaderSize
	self.CustomHeaderY 	= 0;
	if(self.UseCustomHeader) then
		self.StartY 		= self.StartY+40;
		self.CustomHeaderY 	= self.CustomHeaderY+40;
		self.Height			= self.Height+40;
	end

	self.Elements = {}
	self.guiElements = {
		["edit"]={},
		["memo"]={}
	}

	self.eOnRender 		= bind(self.onRender, self)
	self.eOnPreRender	= bind(self.onPreRender, self);

	self.eOnCloseButtonClick = bind(self.onCloseButtonClick, self)
end

function CDxWindow:destructor()

	local function deleteElements(tblElements)
		if(tblElements.Elements) then
			for key, theElement in pairs(tblElements.Elements) do
				deleteElements(theElement)
			end
		end
		if(tblElements.destructor) then
			tblElements:destructor()
		end
		delete(tblElements)
		tblElements = nil;
	end

	for key, theElement in pairs(self.Elements) do
		deleteElements(theElement)
		theElement = nil
	end

	for key, value in pairs(self.guiElements) do
		for k,v in ipairs(value) do
			destroyElement(v)
		end
	end
end

function CDxWindow:setCloseClass(uClass)
	self.m_uCloseClass	= uClass;
end

function CDxWindow:setReadOnly(bReadOnly)
	self.ReadOnly = bReadOnly
end

function CDxWindow:setTitle(sTitle)
	self.Title = sTitle
end

function CDxWindow:show(sSound, bNotFull)
	if ((clientBusy) and not(self.ReadOnly)) then
		return false
    end
    if (sSound) then
        playSound(sSound, false)
    else
	    if(config) then
            playSound(config:getConfig("popsound"), false)
        end
    end
	addEventHandler("onClientRender", getRootElement(), self.eOnRender)
	self:addClickHandlers(0)
    if not(bNotFull) then
        for key, value in pairs(self.Elements) do
            value:addClickHandlers(key)
        end
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

function CDxWindow:hide(bNotFull)
	removeEventHandler("onClientRender", getRootElement(), self.eOnRender)
	self:removeClickHandlers()

    local function removeRecursiveHandlers(uElement)
        if(type(uElement) == "table") then
            if(uElement.ClickFunction) then
                uElement:removeClickHandlers()
            end
            if(uElement.Elements) then
                for index, ele in pairs(uElement.Elements) do
                    removeRecursiveHandlers(ele)
                end
                removeRecursiveHandlers(uElement.Elements)
            end
        end
    end

    --[[
    --if(value.Elements) then
            for _, v in pairs(value.Elements) do
                if(v) then
                    value:removeClickHandlers()
                    if(v.Elements) then
                        for _, v2 in pairs(v.Elements) do
                            if(type(v2) == "table") and (v2.removeClickHandlers) then
                                v2:removeClickHandlers()

                            end
                        end
                    end
                end
            end

     ]]
    if not(bNotFull) then
        for key, value in pairs(self.Elements) do
            removeRecursiveHandlers(value);
        end
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

function CDxWindow:onPreRender()

	for key, theElement in pairs(self.Elements) do

		if(theElement.preRender) then
			theElement:preRender()
		end
	end
end

function CDxWindow:onRender()

	local borderY = 1
	dxDrawLine ( self.X, self.Y+self.iHeaderSize, self.X, self.Y+self.Height, tocolor(0,0,0), 1)
	dxDrawLine ( self.X+self.Width, self.Y+self.iHeaderSize, self.X+self.Width, self.Y+self.Height, tocolor(0,0,0), 1)
	dxDrawLine ( self.X, self.Y+self.Height, self.X+self.Width, self.Y+self.Height, tocolor(0,0,0), 1)
	dxDrawLine ( self.X, self.Y+self.iHeaderSize, self.X+self.Width, self.Y+self.iHeaderSize, tocolor(0,0,0), 1)

	dxDrawLine ( self.X+borderY, self.Y+self.iHeaderSize, self.X+borderY, self.Y+self.Height, tocolor(255, 255, 255, 50), 1)
	dxDrawLine ( self.X+self.Width-borderY, self.Y+self.iHeaderSize, self.X+self.Width-borderY, self.Y+self.Height, tocolor(255, 255, 255, 50), 1)
	dxDrawLine ( self.X+borderY, self.Y+self.Height-borderY, self.X+self.Width-borderY, self.Y+self.Height-borderY, tocolor(255, 255, 255, 50), 1)

	-- Custom Header
	if(self.UseCustomHeader) then
		dxDrawImage( self.StartX-1, self.StartY-self.CustomHeaderY, self.Width-1, self.CustomHeaderY, "/res/images/dxGui/window_infoheader.png", 0, 0, 0, self.CustomHeaderColor)

		dxDrawLine ( self.StartX, self.StartY, self.StartX-1+self.Width, self.StartY-self.CustomHeaderY+self.CustomHeaderY, tocolor(0, 0, 0, 2550), 1)
		dxDrawLine ( self.StartX, self.StartY-1, self.StartX-1+self.Width, self.StartY-self.CustomHeaderY+self.CustomHeaderY-1, tocolor(255, 255, 255, 50), 1)

		-- Icon --
		if(self.HeaderIcon) then
			dxDrawImage(self.StartX+15, self.StartY-48, 55, 55, self.HeaderIcon)
		end

		if(self.HeaderText) then
			dxDrawText ( string.upper(self.HeaderText),  self.StartX+85-2, self.StartY-self.CustomHeaderY+10, self.Width-3, self.CustomHeaderY, tocolor(0, 0, 0, 55), 0.3, CDxWindow.gFont, "left", "top")
			dxDrawText ( string.upper(self.HeaderText),  self.StartX+85, self.StartY-self.CustomHeaderY+10, self.Width-1, self.CustomHeaderY, tocolor(255,255,255,255), 0.3, CDxWindow.gFont, "left", "top")

		end
	end

	dxDrawImage( self.StartX-1, self.StartY, self.Width-1, self.Height-self.iHeaderSize-self.CustomHeaderY, "/res/images/guibg.png", 0, 0, 0, self.BackgroundColor)
	dxDrawImage( self.StartX-1, self.StartY, self.Width-1, self.Height-self.iHeaderSize-self.CustomHeaderY, "/res/images/dxGui/background-alpha.png", 0, 0, 0, tocolor(255, 255, 255, 155))



	for key, theElement in ipairs(self.Elements) do
		if (theElement:getVisible()) and (theElement.render) then
			theElement:render()
		end
	end

	if(self.renderFuncs) then
		for func, _ in pairs(self.renderFuncs) do
			if(func) then
				func()
			end
		end
	end

	if (self.Header) then
		dxDrawImage( self.X+1, self.Y+1, self.Width-1, self.iHeaderSize, "res/images/dxGui/dxWindowHeadBackground.png")
		dxDrawLine ( self.X, self.Y, self.X+self.Width, self.Y, tocolor(0,0,0), 1)
		dxDrawLine ( self.X, self.Y, self.X, self.Y+25, tocolor(0,0,0), 1)

		dxDrawLine ( self.X+self.Width, self.Y, self.X+self.Width, self.Y+25, tocolor(0,0,0), 1)

		--dxDrawLine ( self.X+self.Width, self.Y, self.X+self.Width, self.Y+15, tocolor(0,0,0), 1)
		local color1, color2, color3;
		if (self.Cancable) then
			if (isCursorShowing()) then
				cX,cY = getCursorPosition ()
				if ( isCursorOverRectangle(cX,cY,self.X+self.Width-16, self.Y+2, 16, 13) ) then
					color1 = tocolor(255,255,255,255)
				else
					color1 = tocolor(125,125,125,255)
				end

				if ( isCursorOverRectangle(cX,cY, self.X+self.Width-33, self.Y+2, 16, 13) ) then
					color2 = tocolor(255,255,255,255)
				else
					color2 = tocolor(125,125,125,255)
				end

				if ( isCursorOverRectangle(cX,cY, self.X+self.Width-52, self.Y+2, 16, 13) ) then
					color3 = tocolor(255,255,255,255)
				else
					color3 = tocolor(125,125,125,255)
				end
			else
				color = tocolor(125,125,125,255)
			end
			dxDrawImage( self.X+self.Width-65, self.Y+2, 65, 12, "res/images/dxGui/dxWindowHeadClose.png", 0, 0, 0, tocolor(125, 125, 125, 255))
			dxDrawImage( self.X+self.Width-16, self.Y+2, 16, 12, "res/images/dxGui/misc/button_close.png", 0, 0, 0, color1)
			dxDrawImage( self.X+self.Width-33, self.Y+2, 16, 12, "res/images/dxGui/misc/button_minimize.png", 0, 0, 0, color2)
			dxDrawImage( self.X+self.Width-52, self.Y+2, 16, 12, "res/images/dxGui/misc/button_help.png", 0, 0, 0, color3)

		end
		dxDrawText ( string.upper(self.Title), self.X+20, self.Y , self.X+self.Width, self.Y+15, tocolor(255,255,255,255), 0.6, CDxWindow.gBFont, "left", "top",true, false, false)
	end
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

function CDxWindow:addRenderFunction(func)
	if not(self.renderFuncs) then
		self.renderFuncs = {}
	end

	self.renderFuncs[func] = func;
end
function CDxWindow:onCloseButtonClick(button, state)
	if (button == "left") and (state == "down") then
		cX,cY = getCursorPosition ()
		if (isCursorOverRectangle(cX,cY,self.X+self.Width-32, self.Y+2, 32, 13)) then
			if (self.xtraHide) then
				self.xtraHide()
			end
			self:hide()
			helpDialog:hide();

			if(self.m_uCloseClass) then
				if(self.m_uCloseClass.getInstance) then
					self.m_uCloseClass:getInstance():show()	
				end
			end
		else
			if (isCursorOverRectangle(cX,cY,self.X+self.Width-52, self.Y+2, 16, 13)) then
				if(self.HelpText) then
					helpDialog:hide()
					helpDialog:show(self.HelpText, true);

				else
					showInfoBox("info", "Dieses Fenster besitzt leider keine Hilfe.")
				end
			end
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

screenX,screenY = guiGetScreenSize()

function isCursorOverRectangle(cX,cY,rX,rY,width,height)
	if isCursorShowing() then
		return ((cX*screenX > rX) and (cX*screenX < rX+width)) and ( (cY*screenY > rY) and (cY*screenY < rY+height))
	else
		return false
	end
end

function isPointInRectangle(cX,cY,rX,rY,width,height)
	return ((cX > rX) and (cX < rX+width)) and ( (cY > rY) and (cY < rY+height))
end
