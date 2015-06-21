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

CDxTab = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxTab:constructor(sText, uParent)
    self.Color = tocolor(0, 0, 0, 155)

    self.Parent = uParent

    self.StartX, self.StartY    = self.Parent:getStartPosition()
    self.StartX, self.StartY    = self.StartX, self.StartY+uParent.TabSizeY;
    self.Width, self.Height     = self.Parent:getSize();

    self.Elements           = {}
    self.Text               = sText;
    self.BackgroundColor	= tocolor(100, 100, 100, 30);

    CDxElement.constructor(self, self.StartX, self.StartY, self.Width , self.Height)
end

function CDxTab:add(theElement)
    table.insert(self.Elements, theElement)
    if(theElement) then
        theElement:addClickHandlers()
    end
end

function CDxTab:setVisible(bBool)
    for index, ele in pairs(self.Elements) do
        if(ele:getVisible() ~= bBool) then
            if(bBool) then
                ele:setVisible(bBool)
                ele:addClickHandlers(index)
            else
                ele:setVisible(bBool)
                ele:removeClickHandlers(index)
            end
        end
    end
end

function CDxTab:getText()
    return self.Text
end

function CDxTab:destructor()

end
