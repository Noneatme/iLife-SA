--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxProgressbar = inherit(CDxElement)

function CDxProgressbar:constructor(fProgress, left, top, width, height, color, Parent)
	self.Progress = fProgress or 0
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

function CDxProgressbar:render()
	cX,cY = getCursorPosition ()
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.tColor =  tocolor(0,0,0,255)
		self.fColor = tocolor(25,255,25,255)	
	else
		self.tColor = tocolor(0,0,0,180)
		self.fColor = tocolor(25,255,25,200)
	end
	
	dxDrawRectangle(self.X, self.Y, self.Width, self.Height, self.tColor, false)
	dxDrawRectangle(self.X+5, self.Y+5, (self.Width-10)*self.Progress, self.Height-10, self.fColor, false)
end