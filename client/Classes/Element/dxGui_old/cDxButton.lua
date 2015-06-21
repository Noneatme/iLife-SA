--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxButton = inherit(CDxElement)


addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			btnl = dxCreateTexture("res/images/dxGui/dxButtonLeft.png", "argb", true, "clamp")
			btnr = dxCreateTexture("res/images/dxGui/dxButtonRight.png", "argb", true, "clamp")
		end
	end
)

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

function CDxButton:destructor()

end

function CDxButton:setText(sText)
	self.Title = sText;
end

function CDxButton:render()
	cX,cY = getCursorPosition ()
	if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
		self.tColor = tocolor(255,255,255,150)
	else
		self.tColor = tocolor(255,255,255,255)
	end
	
	if(self.Disabled == true) then
		self.tColor = tocolor(50, 50, 50, 255);
	end
	dxDrawRectangle(self.X+1, self.Y, self.Width, self.Height, tocolor(0,0,0,179), false)
	dxDrawText(self.Title, self.X, self.Y, self.X+self.Width, self.Y+self.Height, self.tColor, 1, "default-bold", "center", "center")
end