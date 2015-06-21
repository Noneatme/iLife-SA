--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDxList = inherit(CDxElement)

sx,sy = guiGetScreenSize()

function CDxList:constructor(left, top, width, height, color, Parent, focusScroll)

    self.Color = tocolor(0, 0, 0, 155)
    self.Parent = Parent or false

    if (self.Parent) then
        self.StartX, self.StartY = self.Parent:getStartPosition()
    else
        self.StartX = 0
        self.StartY = 0
    end

    self.Columns 			= {}
    self.Rows 				= {}
    self.SelectedRow 		= 0
    self.Scroll 			= 0
    self.focusScroll 		= focusScroll
    self.BackgroundColor	= tocolor(100, 100, 100, 30);
    self.m_tblImageColumns  = {}

    self.m_iCurColumnAdded      = 1
    self.m_tblImageColumnIds    = {}

    CDxElement.constructor(self, self.StartX+left or 50, self.StartY+top or 50, width or 150, height or 30)

    self.fSelect = bind(self.select, self)
    addEventHandler("onClientClick", getRootElement(),self.fSelect)

    self.bScrollUp = bind(self.scrollUp, self)
    self.bScrollDown = bind(self.scrollDown, self)
    bindKey("mouse_wheel_up", "down", self.bScrollUp)
    bindKey("mouse_wheel_down", "down", self.bScrollDown)
end

function CDxList:destructor()
    self.doubleClickFunctions       = {}
    self.Visible                    = false;
end

function CDxList:render()

    cX,cY		= getCursorPosition ()
    local color = self.BackgroundColor
    if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then
        color = tocolor(50, 50, 50, 155)
    end

    --[[
    dxDrawImage(self.X+1, self.Y, 15, self.Height, "res/images/dxGui/dxButtonLeft.png", 0, 0, 0, self.tColor)
    dxDrawImage(self.X+self.Width-16, self.Y, 15, self.Height, "res/images/dxGui/dxButtonRight.png", 0, 0, 0, self.tColor)
    dxDrawImage(self.X+15, self.Y, self.Width-30, self.Height, "res/images/dxGui/dxButtonMid.png", 0, 0, 0, self.tColor)
    ]]

    dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/guibg.png", 0, 0, 0, color)
    dxDrawImage(self.X, self.Y, self.Width, self.Height, "/res/images/dxGui/background-alpha.png", 0, 0, 0, tocolor(255, 255, 255, 155))

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

    local columnWidth = self.Width/#self.Columns

    local curColumnAddX = 0;
    local curAddFinalX = 0;

    local nextColumn = false;
    --[[

        for i,v in ipairs(self.Columns) do
            if(fileExists(tostring(v))) then

                local sizeX = columnWidth-16;
                if(i ~= 1) then
                    curColumnAddX = curColumnAddX + sizeX
                end
                curAddFinalX = curAddFinalX + sizeX
                dxDrawImage(self.X+(curColumnAddX)+5, self.Y, 16, 16, tostring(v), 0, 0, 0, tocolor(255,255,255,255))
            else
                if(i ~= 1) then
                    curColumnAddX = curColumnAddX + columnWidth
                end
                if(curAddFinalX ~= 0) then
                    if not(nextColumn) then
                        nextColumn = true
                        curColumnAddX = curColumnAddX-curAddFinalX
                    else
                        curColumnAddX = curColumnAddX + curAddFinalX
                        curAddFinalX = 0;
                        nextColumn = false;
                    end
                end
                dxDrawText(tostring(v), self.X+(curColumnAddX)+5, self.Y, (self.X+(curColumnAddX+dxGetTextWidth(tostring(v))*2))-1, self.Y+20, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
            end
        end
    ]]
    for i,v in ipairs(self.Columns) do
        if(fileExists(tostring(v))) then

            local sizeX = columnWidth-24;
            if(i ~= 1) then
                curColumnAddX = curColumnAddX + sizeX+24
            end
            curAddFinalX = curAddFinalX + sizeX
            dxDrawImage(self.X+(curColumnAddX)+5, self.Y, 16, 16, tostring(v), 0, 0, 0, tocolor(255,255,255,255))
        else
            if(i ~= 1) then
                curColumnAddX = curColumnAddX + columnWidth
            end
            if(curAddFinalX ~= 0) then
                if not(nextColumn) then
                    nextColumn = true
                    curColumnAddX = curColumnAddX-curAddFinalX
                else
                    curColumnAddX = curColumnAddX + curAddFinalX
                    curAddFinalX = 0;
                    nextColumn = false;
                end
            end
            dxDrawText(tostring(v), self.X+(curColumnAddX)+5, self.Y, (self.X+(curColumnAddX+self:dxGetTextWidth(tostring(v))*2))-1, self.Y+20, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
        end
    end

    local absHeight = 20
    dxDrawLine(self.X+2, self.Y+absHeight-1, self.X+self.Width-4, self.Y+absHeight-1, tocolor(255, 255, 255,255), 1)

    for i, v in ipairs(self.Rows) do

        --[[
        local curHeight = 20
        for i2, v2 in ipairs(self.Columns) do
            if not(self.m_tblImageColumns[v2]) then
                if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                    if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40 > curHeight) then
                        curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40
                    end
                end
            end
        end
        ]]
        local curHeight = 20
        for i2, v2 in ipairs(self.Columns) do
            if not(self.m_tblImageColumns[v2]) then
                if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                    local wd = columnWidth
                    if(self.m_tblImageColumnIds[i2-1]) then
                        wd = wd+columnWidth-18
                    end
                    if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40 > curHeight) then
                        curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40
                    end
                end
            end
        end
        if (isPointInRectangle(self.X+5, (self.Y+absHeight+curHeight-1)-self.Scroll, self.X, self.Y+curHeight-1, self.Width, self.Height-curHeight+1)) then
            cX,cY = getCursorPosition ()
            if (isCursorOverRectangle(cX, cY, self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight)) then
                dxDrawRectangle(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, tocolor(50,50,50,125))
            end
            if (self.SelectedRow == i) then
                dxDrawRectangle(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, tocolor(50,50,50, 125))
            end

            local ix, iy, iw, ih = self.X, (self.Y+absHeight)-self.Scroll+curHeight, self.X+self.Width, ((self.Y+absHeight)-self.Scroll)+curHeight

            dxDrawImage(self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight, "res/images/dxGui/dxWindowHeadBackground.png", 0, 0, 0, tocolor(50, 150, 250, 50))

            dxDrawLine(ix+3, iy+1, iw, ih+1, tocolor(0, 0, 0, 125), 1)
            dxDrawLine(ix+3, iy, iw, ih, tocolor(255, 255, 255, 25), 1)

            --[[

                for i,v in ipairs(self.Columns) do
                    if(fileExists(tostring(v))) then

                        local sizeX = columnWidth-16;
                        if(i ~= 1) then
                            curColumnAddX = curColumnAddX + sizeX
                        end
                        curAddFinalX = curAddFinalX + sizeX
                        dxDrawImage(self.X+(curColumnAddX)+5, self.Y, 16, 16, tostring(v), 0, 0, 0, tocolor(255,255,255,255))
                    else
                        if(i ~= 1) then
                            curColumnAddX = curColumnAddX + columnWidth
                        end
                        if(curAddFinalX ~= 0) then
                            if not(nextColumn) then
                                nextColumn = true
                                curColumnAddX = curColumnAddX-curAddFinalX
                            else
                                curColumnAddX = curColumnAddX + curAddFinalX
                                curAddFinalX = 0;
                                nextColumn = false;
                            end
                        end
                        dxDrawText(tostring(v), self.X+(curColumnAddX)+5, self.Y, (self.X+(curColumnAddX+dxGetTextWidth(tostring(v))*2))-1, self.Y+20, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
                    end
                end
            ]]
            local curColumnAddX = 0;
            local curAddFinalX = 0;

            local nextColumn = false;

            for i2, v2 in ipairs(self.Columns) do
                if(self.m_tblImageColumns[v2]) then
                    local url = gettok(v, i2, "|")
                    local iMax = 1
                    if(self.m_tblImageNumbersRow[v]) then
                        iMax = self.m_tblImageNumbersRow[v]
                    end
                    local curAddX   = 0;
                    local addX      = 17;
                    local done      = false;

                    for i = 1, iMax, 1 do
                        if(url) and (string.len(url) > 3) and (gettok(url, i, ","))  then
                            local curUrl = gettok(url, i, ",");
                            if(curUrl) and (fileExists(curUrl)) then
                                if not(done) then
                                    local sizeX = columnWidth-24;
                                    if(i2 ~= 1) then
                                        curColumnAddX = curColumnAddX + sizeX+24
                                    end
                                    curAddFinalX = curAddFinalX + sizeX
                                    done = true
                                end
                                dxDrawImage(self.X+(curColumnAddX)+5+curAddX, (self.Y+(absHeight)+((curHeight-20)/2))-self.Scroll+2, 16, 16, curUrl, 0, 0, 0, tocolor(255,255,255,255));
                                curAddX = curAddX+addX
                            end
                        end
                    end
                else
                    -- Arschkrebs hoch 13
                    if(i2 ~= 1) then
                        curColumnAddX = curColumnAddX + columnWidth
                    end
                    if(curAddFinalX ~= 0) then
                        if not(nextColumn) then
                            nextColumn = true
                            curColumnAddX = curColumnAddX-curAddFinalX
                        else
                            curColumnAddX = curColumnAddX + curAddFinalX
                            curAddFinalX = 0;
                            nextColumn = false;
                        end
                    end

                    local x, y, w, h = self.X+(curColumnAddX)+5, (self.Y+absHeight)-self.Scroll, self.X+curColumnAddX+self:dxGetTextWidth(tostring(gettok(v, i2, "|"))), (self.Y+absHeight+curHeight)-self.Scroll

                    if(w > self.X+self.Width) then
                        w = self.X+self.Width
                    end
                    if(self.m_tblImageColumnIds and self.m_tblImageColumnIds[i2-1]) then
                        if(w > (self.X+curColumnAddX+columnWidth*2)-16) then
                            w = (self.X+curColumnAddX+columnWidth*2)-16
                        end
                    else
                        if(w > self.X+curColumnAddX+columnWidth) then
                            w = self.X+curColumnAddX+columnWidth
                        end
                    end
                    dxDrawText(tostring(gettok(v, i2, "|")), x, y, w, h, tocolor(255,255,255,255), 0.5, CDxWindow.gTFont, "left", "center", true, true)
                    if(self.m_bDrawBoundingBox) then
                        dxDrawRectangle(x, y, -(x-w), -(y-h), tocolor(255, 255, 255, 30))
                    end
                end

            end
        end
        absHeight = absHeight+curHeight
    end

    if (absHeight > self.Height-20) then
        local pos = (self.Scroll/absHeight)*(self.Height-20)
        dxDrawLine(self.X+self.Width-2, self.Y+20+pos, self.X+self.Width-2, (self.Y+20+(self.Height-20)-(((absHeight-self.Scroll-(self.Height-20))/absHeight)*(self.Height-20)))+(self.Height%20), tocolor(200, 200, 200,255), 2)
    else
        dxDrawLine(self.X+self.Width-2, self.Y+20, self.X+self.Width-2, self.Y+self.Height, tocolor(200, 200, 200,255), 2)
    end

end

function CDxList:dxGetTextWidth(sText)
    local oneChar   = dxGetTextWidth(tostring("A"), 0.5, CDxWindow.gTFont)
    return dxGetTextWidth(sText, 0.5, CDxWindow.gTFont)+oneChar*2
end

function CDxList:addDoubleClickFunction(uFunc)
    if not(self.doubleClickFunctions) then
        self.doubleClickFunctions = {}
    end
    if not(self.doubleClickFunctions[uFunc]) then
        table.insert(self.doubleClickFunctions, uFunc)
    end
end


function CDxList:select(key, state)
    if (key == "left") and (state == "down") and not (self:getDisabled()) and (self.Visible) then
        cX,cY = getCursorPosition ()
        if ( isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height)) then

            if not(self.m_iStartTickClick) then
                self.m_iStartTickClick  = getTickCount()
            end

            if(getTickCount()-self.m_iStartTickClick < 200) then
                if(self.m_bclickedOnce) then
                    if(self.doubleClickFunctions) then
                        for _, func in pairs(self.doubleClickFunctions) do
                            if(func) then func(self) end
                        end
                    end
                end
            else
                self.m_iStartTickClick  = getTickCount()
            end

            self.m_bclickedOnce   = true;

            local columnWidth = self.Width/#self.Columns
            local absHeight = 20

            for i,v in ipairs(self.Rows) do

                local curHeight = 20
                for i2, v2 in ipairs(self.Columns) do
                    if not(self.m_tblImageColumns[v2]) then
                        if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                            local wd = columnWidth
                            if(self.m_tblImageColumnIds[i2-1]) then
                                wd = wd+columnWidth-18
                            end
                            if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40 > curHeight) then
                                curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40
                            end
                        end
                    end
                end

                if ( isCursorOverRectangle(cX, cY, self.X, (self.Y+absHeight)-self.Scroll, self.Width, curHeight)) then
                    self.SelectedRow = i
                    return
                end
                absHeight = absHeight+curHeight
            end
        end
    end
end


function CDxList:addColumn(sName, bImage)
    table.insert(self.Columns, sName)
    if(bImage) then
        self.m_tblImageColumns[sName] = true;
        self.m_tblImageColumnIds[self.m_iCurColumnAdded] = true;
        self.m_iCurColumnAdded = self.m_iCurColumnAdded+1
    end
end

function CDxList:addRow(sData, imageColumns)
    sData = tostring(sData)
    table.insert(self.Rows, sData)
    if(imageColumns) then
        if not(self.m_tblImageNumbersRow) then
            self.m_tblImageNumbersRow = {}
        end
        self.m_tblImageNumbersRow[sData] = imageColumns;
    end
end

function CDxList:getSelectedRow()
    return self.SelectedRow
end

function CDxList:getRowCount()
    return #self.Rows
end


function CDxList:setSelectedRow(iRow)
    if (iRow <= #self.Rows) then
        self.SelectedRow = iRow
    end
end

function CDxList:getRowData(iColumn)
    if (self.SelectedRow ~= 0) then
        return gettok(self.Rows[self.SelectedRow], iColumn, "|")
    else
        return "nil"
    end
end

function CDxList:getItemCountOnLine()
    self.m_iItemCountOnLine = 5;
    --[[
    local absHeight = 20
    local columnWidth = self.Width/#self.Columns
    for i, v in ipairs(self.Rows) do
        local curHeight = 20
        for i2, v2 in ipairs(self.Columns) do
            if not(self.m_tblImageColumns[v2]) then
                if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                    if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40 > curHeight) then
                        curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40
                    end
                end
            end
        end
        if(isPointInRectangle(self.X+5, (self.Y+absHeight+curHeight-1)-self.Scroll, self.X, self.Y+curHeight-1, self.Width, self.Height-curHeight+1)) then
            self.m_iItemCountOnLine = self.m_iItemCountOnLine+1;
        end
    end

    local columnWidth = self.Width/#self.Columns
    local absHeight = 20
    for i, v in ipairs(self.Rows) do
        local curHeight = 20
        for i2, v2 in ipairs(self.Columns) do
            if not(self.m_tblImageColumns[v2]) then
                if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                    if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40 > curHeight) then
                        curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/columnWidth))*40
                    end
                end
            end
        end
        if (isPointInRectangle(self.X+5, (self.Y+absHeight+curHeight-1)-self.Scroll, self.X, self.Y+curHeight-1, self.Width, self.Height-curHeight+1)) then
            self.m_iItemCountOnLine = self.m_iItemCountOnLine+1;
        end
    end
    outputChatBox(self.m_iItemCountOnLine)
    ]]
    return self.m_iItemCountOnLine;
end

function CDxList:scrollUp()
    cX,cY = getCursorPosition ()
    local scrollCount = 1
    if(getKeyState("lshift")) then
        scrollCount = math.floor(self:getItemCountOnLine())
    end
    for _ = 1, scrollCount, 1 do
        if (isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height))  or self.focusScroll then
            local rowHeight = {}
            local absHeight = 20
            local columnWidth = self.Width/#self.Columns

            for i, v in ipairs(self.Rows) do
                local curHeight = 20
                for i2, v2 in ipairs(self.Columns) do
                    if not(self.m_tblImageColumns[v2]) then
                        if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                            local wd = columnWidth
                            if(self.m_tblImageColumnIds[i2-1]) then
                                wd = wd+columnWidth-18
                            end
                            if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40 > curHeight) then
                                curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40
                            end
                        end
                    end
                end
                rowHeight[i] = curHeight
                absHeight = absHeight + curHeight
            end
            if (absHeight > self.Height) then
                local pHeight = 0
                for k,v in ipairs(rowHeight) do
                    if (pHeight+v >= self.Scroll) then
                        self.Scroll = pHeight
                        break;
                    else
                        pHeight = pHeight+v
                    end
                end
            end
        end
    end
end

function CDxList:scrollDown()
    cX,cY = getCursorPosition ()
    local scrollCount = 1
    if(getKeyState("lshift")) then
        scrollCount = math.floor(self:getItemCountOnLine())
    end
    for _ = 1, scrollCount, 1 do
        if (isCursorOverRectangle(cX,cY, self.X, self.Y, self.Width, self.Height))  or self.focusScroll then
            local rowHeight = {}
            local absHeight = 20
            local columnWidth = self.Width/#self.Columns
            for i, v in ipairs(self.Rows) do
                local curHeight = 20
                for i2, v2 in ipairs(self.Columns) do
                    if not(self.m_tblImageColumns[v2]) then
                        if(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))) then
                            local wd = columnWidth
                            if(self.m_tblImageColumnIds[i2-1]) then
                                wd = wd+columnWidth-18
                            end
                            if ((math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40 > curHeight) then
                                curHeight = (math.floor(self:dxGetTextWidth(tostring(gettok(v, i2, "|")))/wd))*40
                            end
                        end
                    end
                end
                rowHeight[i] = curHeight
                absHeight = absHeight + curHeight
            end
            if (absHeight > self.Height) then
                local pHeight = 20
                for k,v in ipairs(rowHeight) do
                    if ((absHeight-self.Scroll) > self.Height) then
                        self.Scroll = self.Scroll+v
                        break;
                    end
                end
            end
        end
    end
end

function CDxList:clearRows()
    self.Rows = {}
    self.SelectedRow = 0
    self.Scroll = 0
end
