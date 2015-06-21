--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxImage = inherit(CDxElement)

function CDxImage:constructor(left, top, width, height, sUrl, color, Parent)
	self.Url = sUrl or "/res/images/none.png"
	self.Color = color or tocolor(255,255,255,255)
	self.Parent = Parent or false
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end
	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
end

function CDxImage:destructor()

end

function CDxImage:render()
	dxDrawImage(self.X, self.Y, self.Width, self.Height, self.Url, 0, 0, 0, self.Color)
end

function CDxImage:loadImage(sUrl)
	self.Url = sUrl
end

function CDxImage:setImage(sUrl)
	self.Url = sUrl
end