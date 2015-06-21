--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxCheckbox = inherit(CDxElement)

function CDxCheckbox:constructor(sTitle, left, top, width, height, color, bState,Parent)
	self.Title = sTitle or "CheckBox"
	self.Color = color 
	self.State = bState or false
	self.Parent = Parent or false
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end
	
	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
	
	self:addClickFunction(
		function()
			self.State = not(self.State)
		end
	)
end

function CDxCheckbox:destructor()

end

function CDxCheckbox:getState()
	return self.State
end

function CDxCheckbox:render()
	cX,cY = getCursorPosition ()
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.tColor = tocolor(125,125,125,255)
	else
		self.tColor = self.Color
	end
	
	local image
	
	if (self.State == true) then
		image="dxCheckboxChecked"
	else
		image="dxCheckboxUnchecked"
	end
	dxDrawImage(self.X, self.Y, self.Height, self.Height, "res/images/dxGui/"..image..".png", 0, 0, 0, self.tColor)
	dxDrawText(self.Title, self.X+self.Height+5, self.Y, self.X+self.Width, self.Y+self.Height, self.tColor, 1, "default", "left", "center")
end