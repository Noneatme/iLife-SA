--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxButton = inherit(CDxElement)

function CDxButton:constructor(sTitle, left, top, width, height, color, Parent)
	self.Title = sTitle or "Button"
	self.Color = color
	self.Parent = Parent or false

	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end

	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
end

function CDxButton:setText(sText)
	self.Title = sText;
end
function CDxButton:getText()
	return self.Title
end
function CDxButton:render()
	cX,cY = getCursorPosition ()
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

	dxDrawImage(self.X, self.Y, self.Width, self.Height, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, btnColor)

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

--	dxDrawRectangle(self.X+1, self.Y, self.Width, self.Height, tocolor(0,0,0,179), false)

	dxDrawText(self.Title, self.X, self.Y, self.X+self.Width, self.Y+self.Height, self.tColor, 0.25, CDxWindow.gFont, "center", "center")
end
