--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxLabel = inherit(CDxElement)

function CDxLabel:constructor(sText, left, top, width, height, color, scale, font, align, vAlign, Parent, clip, wordBreak)

	self.Text = sText or "none"
	self.Color = color or tocolor(255,255,255,255)
	self.Scale = scale or 1
	self.Font = font or "default-bold"
	self.Align = align or "left"
	self.VAlign = vAlign or "center"
	self.Parent = Parent or false
	if (self.Parent) then
		self.StartX, self.StartY = self.Parent:getStartPosition()
	else
		self.StartX = 0
		self.StartY = 0
	end
	self.Clip = clip or true
	self.WordBreak = wordBreak or true
	
	self.ColorCoded = false
	
	CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)
end

function CDxLabel:destructor()

end

function CDxLabel:render()
	dxDrawText(self.Text, self.X, self.Y, self.X+self.Width, self.Y+self.Height, self.Color, self.Scale, self.Font, self.Align, self.VAlign, self.Clip, self.WordBreak, false, self.ColorCoded, false)
end

function CDxLabel:setText(sText)
	self.Text = sText
end

function CDxLabel:setColor(Color)
	self.Color = Color
end

function CDxLabel:setColorCoded(toggle)
	self.ColorCoded = toggle
end