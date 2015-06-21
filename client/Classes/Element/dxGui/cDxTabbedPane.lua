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

CDxTabbedPane = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxTabbedPane:constructor(left, top, width, height, color, Parent, focusScroll)
    self.Color = tocolor(0, 0, 0, 155)
    self.Parent = Parent or false

    if (self.Parent) then
        self.StartX, self.StartY = self.Parent:getStartPosition()
    else
        self.StartX = 0
        self.StartY = 0
    end

    self.focusScroll 		= focusScroll
    self.BackgroundColor	= tocolor(10, 10, 10, 10);
    self.Tabs               = {}
    self.SelectedTab        = 0;
    self.TabSettings        = {}
    self.TabSizeY           = 16;

    self.TabIndex           = 1;

    self.m_funcClick        = function(...) self:onClick(...) end

    CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)

    self.Elements           = {}
    self:addClickFunction(self.m_funcClick)

end

function CDxTabbedPane:destructor()

end

function CDxTabbedPane:getStartPosition()
    return self.X, self.Y+self.TabSizeY
end

function CDxTabbedPane:onClick(btn, state)
    if(btn == "left") and (state == "down") and (self.Visible) and not(self.Disabled) then

        local curAddX   = 0;

        for k, v in ipairs(self.Tabs) do
            local settings  = self.TabSettings[k];
            local cX,cY		= getCursorPosition();
            local sizeX     = settings[1] or 25;

            if(isCursorOverRectangle(cX, cY, self.X+curAddX, self.Y, sizeX, self.TabSizeY)) then
                self:selectTab(k);
                break;
            end
            curAddX = curAddX+sizeX+1;
        end
    end
end

function CDxTabbedPane:addTab(uTab, tblSettings)
    self.Elements[uTab] = uTab;
    table.insert(self.Tabs, self.TabIndex, uTab);
    self.TabSettings[self.TabIndex] = ((tblSettings or {}));

    self:selectTab(1);
    self.TabIndex       = self.TabIndex+1;
end

function CDxTabbedPane:setSelectedTab(iIndex)
    self.SelectedTab    = iIndex;
end

function CDxTabbedPane:selectTab(iIndex)
    self.SelectedTab    = iIndex;

    for index, tabs in pairs(self.Tabs) do
        if(index == iIndex) then
            tabs:setVisible(true);
        else
            tabs:setVisible(false);
        end
    end
end

function CDxTabbedPane:setVisible(bBool)
    if not(bBool) then
        for index, tabs in pairs(self.Tabs) do
            tabs:setVisible(bBool);
        end
    else
        self:selectTab(self.SelectedTab)
    end

    self.Visible = bBool;
end

function CDxTabbedPane:render()

    cX,cY		= getCursorPosition ()
    local color = self.BackgroundColor


    --[[
        dxDrawImage(self.X+1, self.Y, 15, self.Height, "res/images/dxGui/dxButtonLeft.png", 0, 0, 0, self.tColor)
        dxDrawImage(self.X+self.Width-16, self.Y, 15, self.Height, "res/images/dxGui/dxButtonRight.png", 0, 0, 0, self.tColor)
        dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxButtonMid.png", 0, 0, 0, self.tColor)
    ]]

    dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/guibg.png", 0, 0, 0, color)
    dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/dxGui/background-alpha.png", 0, 0, 0, tocolor(255, 255, 255, 55))

    local tabSizeY  = self.TabSizeY;

    -- Lines --
    -- IMAGE --
    dxDrawImage(self.X, self.Y, self.Width, tabSizeY, "res/images/dxGui/tabMenuHeader.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    -- BLACK
    dxDrawLine(self.X+2, self.Y+tabSizeY, self.X+self.Width-2, self.Y+tabSizeY, tocolor(0, 0, 0, 200));		-- Oben

    -- WHITE
    dxDrawLine(self.X+1, self.Y+1+tabSizeY, self.X+self.Width-2, self.Y+1+tabSizeY, tocolor(255, 255, 255, 25));		-- Oben

    local curAddX   = 0;
    for k, v in ipairs(self.Tabs) do
        local settings  = self.TabSettings[k];
        local name      = v:getText();
        local sizeX     = settings[1] or 25;
        local color     = settings[2] or (tocolor(255, 255, 255, 200))

        if(isCursorOverRectangle(cX, cY, self.X+curAddX, self.Y, sizeX, tabSizeY)) or (self.SelectedTab == k) then
            dxDrawRectangle(self.X+curAddX, self.Y, sizeX, tabSizeY, tocolor(0, 0, 0, 150))
        end

        dxDrawRectangle(self.X+curAddX, self.Y, sizeX, tabSizeY, color)
        dxDrawText(name, self.X+curAddX, self.Y, self.X+sizeX+curAddX, self.Y+tabSizeY, tocolor(255, 255, 255, 200), 0.22, CDxWindow.gFont, "center", "center")
        curAddX = curAddX+sizeX+1;

        for index, theElement in pairs(v.Elements) do
            if (theElement:getVisible()) and (theElement.render) then
                theElement:render()
            end
        end
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


end
