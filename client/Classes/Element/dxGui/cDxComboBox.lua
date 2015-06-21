--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxComboBox = inherit(CDxElement)

function CDxComboBox:constructor(sText, left, top, width, height, iMaxH, color, tblItems, Parent)
	self.Progress 	= sText or ""
	self.Color 		= color
	self.Parent 	= Parent or false
	self.tblItems	= tblItems or {};
	self.SelectedIndex	= (sText) or 0;
	self.Clicked	= false;
	self.iMaxH		= iMaxH

	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end

	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)

	self:addClickFunction(
		function()
			self.Clicked			= not(self.Clicked);
		end
	)

	self.m_funcFocusLostCheck		= function(...) self:checkFocusLost(...) end
	addEventHandler("onClientClick", getRootElement(), self.m_funcFocusLostCheck)
end

function CDxComboBox:checkFocusLost()
	local cX, cY = getCursorPosition()
	if (not (isCursorOverRectangle(cX,cY,self.X,self.Y,self.Width,self.Height))) then
		removeEventHandler("onClientKey", getRootElement(), self.m_funcFocusLostCheck)
		self.Clicked 		= false
	end
end


function CDxComboBox:destructor()

end

function CDxComboBox:setText(sText)
	self.Text = sText
	return self.Text
end

function CDxComboBox:getText(sText)
	return (self.Text);
end

function CDxComboBox:getSelectedItem()
	if(self.tblItems[self.SelectedIndex]) then
		return self.tblItems[self.SelectedIndex];
	else
		return false
	end
end

function CDxComboBox:setSelected(iIndex)
	if(self.tblItems[self.Selected]) or (iIndex == 0) then
		self.Selected = iIndex;
	else
		return false;
	end
end

function CDxComboBox:getSelectedIndex()
	return self.tblItems[self.SelectedIndex]
end

function CDxComboBox:render()
	local cX,cY = getCursorPosition ()

	local btnColor	= tocolor(50, 150, 250, 50)
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.tColor = tocolor(255,255,255,150)
		btnColor 	= tocolor(150, 150, 150, 50)
	else
		self.tColor = tocolor(255,255,255,255)
	end

	if(self.Disabled == true) then
		self.tColor = tocolor(50, 50, 50, 255);
		btnColor 	= tocolor(0, 0, 0, 50)
	end

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

	--dxDrawImage(self.X, self.Y, 16, self.Height, editl, 0, 0, 0, self.rColor)
	--dxDrawImage(self.X+self.Width-16, self.Y, 16, self.Height, editr, 0, 0, 0, self.rColor)
	--dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxEditMid.png", 0, 0, 0, self.rColor)
	--
	dxDrawRectangle(self.X, self.Y, self.Width, self.Height, tocolor(0,0,0,100), false)

	dxDrawImage(self.X, self.Y+2, self.Width, self.Height-2, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, btnColor)

	-- Arrow --

	dxDrawImage(self.X+self.Width-self.Height+2.5, self.Y+2.5, self.Height-5, self.Height-5, "res/images/left.png", -90, 0, 0, tocolor(255, 255, 255, 255))

	local function render()
		-- Text --
		if(self.SelectedIndex) then
			dxDrawText(self.tblItems[self.SelectedIndex], self.X, self.Y+2, self.X+self.Width, self.Y+self.Height, tocolor(255, 255, 255, 150), 0.6, CDxWindow.gTFont, "center", "center")
		end
	end

	render();

	local function renderSachen()
		local addY 		= self.Height;
		local curAdd 	= 0;
		for index, item in ipairs(self.tblItems) do
			curAdd = curAdd+addY;
			-- BLACK
			dxDrawLine(self.X, self.Y+curAdd, self.X+self.Width, self.Y+curAdd, tocolor(0, 0, 0, 255));		-- Oben
			dxDrawLine(self.X, self.Y+self.Height+curAdd, self.X+self.Width, self.Y+self.Height+curAdd, tocolor(0, 0, 0, 255)); -- unten
			dxDrawLine(self.X, self.Y+curAdd, self.X, self.Y+self.Height+curAdd, tocolor(0, 0, 0, 255));		-- Links
			dxDrawLine(self.X+self.Width, self.Y+curAdd, self.X+self.Width, self.Y+self.Height+curAdd, tocolor(0, 0, 0, 255));		-- Rechts

			-- WHITE
			dxDrawLine(self.X+1, self.Y+1+curAdd, self.X+self.Width-1, self.Y+1+curAdd, tocolor(255, 255, 255, 25));		-- Oben
			dxDrawLine(self.X+1, self.Y+self.Height-1+curAdd, self.X+self.Width-1, self.Y+self.Height-1+curAdd, tocolor(255, 255, 255, 25)); -- unten

			dxDrawLine(self.X+1, self.Y+1+curAdd, self.X+1, self.Y+self.Height-1+curAdd, tocolor(255, 255, 255, 25));		-- Links

			dxDrawLine(self.X+self.Width-1, self.Y+1+curAdd, self.X+self.Width-1, self.Y+self.Height-1+curAdd, tocolor(255, 255, 255, 25));		-- Rechts

			--dxDrawImage(self.X, self.Y, 16, self.Height, editl, 0, 0, 0, self.rColor)
			--dxDrawImage(self.X+self.Width-16, self.Y, 16, self.Height, editr, 0, 0, 0, self.rColor)
			--dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxEditMid.png", 0, 0, 0, self.rColor)
			--
			dxDrawRectangle(self.X, self.Y+curAdd, self.Width, self.Height, tocolor(0,0,0,100), false)

			local col = tocolor(50, 150, 250, 50)
			if ( isCursorOverRectangle(cX,cY, self.X, self.Y+2+curAdd, self.Width, self.Height-2)) then
				col =  tocolor(150, 150, 150, 50);
				self.SelectedIndex	= index;
			else
				col = tocolor(50, 150, 250, 50)
			end

			dxDrawImage(self.X, self.Y+2+curAdd, self.Width, self.Height-2, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, col)
			dxDrawText(item, self.X, self.Y+curAdd, self.X+self.Width, self.Y+self.Height+curAdd, self.tColor, 0.25, CDxWindow.gFont, "center", "center")

		end
		comboBoxOpened = self;
	end

	comboBoxOpened = false;

	if(self.Clicked) then
		renderSachen()
	end

end