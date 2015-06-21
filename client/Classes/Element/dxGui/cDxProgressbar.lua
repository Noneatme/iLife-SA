--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxProgressbar = inherit(CDxElement)

function CDxProgressbar:constructor(fProgress, left, top, width, height, color, Parent, sText)
	self.Progress 	= fProgress or 0
	self.Color 		= color
	self.Parent 	= Parent or false
	self.Text		= sText or false;

	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end

	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)

end

function CDxProgressbar:destructor()

end

function CDxProgressbar:getProgress()
	return self.Progress
end

function CDxProgressbar:setProgress(fProgress)
	if (fProgress > 1) then
		self.Progress = 1
	else
		if (fProgress < 0) then
			self.Progress = 0
		else
			self.Progress = fProgress
		end
	end
end

function CDxProgressbar:setText(sText)
	self.Text = sText
	return self.Text
end

function CDxProgressbar:getText(sText)
	return (self.Text);
end


function CDxProgressbar:render()
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

	dxDrawImage(self.X, self.Y, self.Width, self.Height, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, btnColor)

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

	local function renderProgress()

		-- LINES --
		-- BLACK
		local outline = 5;

		local x1, y1, w1, h1 = self.X+5, self.Y+5, (self.Width-10)*self.Progress, self.Height-10

		dxDrawImage(self.X+5, self.Y+5, (self.Width-10)*self.Progress, self.Height-10, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, tocolor(125, 255, 125, 155))

		-- BLACK
		dxDrawLine(x1-1, y1, self.X+w1+outline, self.Y+outline, tocolor(0, 0, 0, 255), 1);		-- Oben
		dxDrawLine(x1-1, y1+self.Height-outline-5, self.X+w1+outline, self.Y+self.Height-outline, tocolor(0, 0, 0, 255),1); -- unten

		dxDrawLine(x1-1, y1, x1-1, y1+self.Height-outline-5, tocolor(0, 0, 0, 255), 1);		-- Links
		dxDrawLine(self.X+w1+outline, y1, self.X+w1+outline, y1+self.Height-outline-5, tocolor(0, 0, 0, 255), 1);		-- Rechts

		-- WHITE
		dxDrawLine(x1, y1+1, self.X+w1+outline-1, self.Y+outline+1, tocolor(255, 255, 255, 25), 1);		-- Oben

		dxDrawLine(x1, y1+self.Height-outline-6, self.X+w1+outline-1, self.Y+self.Height-outline-1, tocolor(255, 255, 255, 25),1); -- unten

		dxDrawLine(x1, y1+1, x1, y1+self.Height-outline-6, tocolor(255, 255, 255, 25), 1);		-- Links
		dxDrawLine(self.X+w1+outline-1, y1+1, self.X+w1+outline-1, y1+self.Height-outline-6, tocolor(255, 255, 255, 25), 1);		-- Rechts

		-- Text --
		if(self.Text) then
			dxDrawText(self.Text, self.X, self.Y, self.X+self.Width, self.Y+self.Height, tocolor(255, 255, 255, 150), 0.5, CDxWindow.gTFont, "center", "center")
		end
	end

	renderProgress();


end
