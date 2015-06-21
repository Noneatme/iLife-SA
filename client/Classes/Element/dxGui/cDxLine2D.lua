--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 10.02.2015
-- Time: 21:12
-- To change this template use File | Settings | File Templates.
--

CDxLine2D = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxLine2D:constructor(iStartX, iStartY, iEndX, iEndY, Color, iThick, uParent)
    self.Color = tocolor(0, 0, 0, 155)

    self.Parent = uParent

    self.StartX, self.StartY    = self.Parent:getStartPosition()
    self.StartX, self.StartY    = self.StartX+iStartX, self.StartY+iStartY
    self.Width, self.Height     = iEndX, iEndY

    self.Color              = Color;
    self.iThick             = iThick or 2
    self.Elements           = {}

    CDxElement.constructor(self, self.StartX, self.StartY, self.Width, self.Height)
end


function CDxLine2D:setVisible(bBool)
   self.Visible = bBool
end

function CDxLine2D:render(l)
   if(self.Visible) then
       dxDrawLine(self.StartX, self.StartY, self.StartX+self.Width, self.StartY+self.Height, self.Color, self.iThick, true);
   end
end

function CDxLine2D:destructor()

end
