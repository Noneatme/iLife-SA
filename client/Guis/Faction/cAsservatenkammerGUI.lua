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
-- Date: 05.02.2015
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cAsservatenkammerGUI = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammerGUI:show(...)
    if not(self.enabled) and not(clientBusy) then
        self:createElements(...)
        self.enabled = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammerGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammerGUI:createElements(tblItems, Items)
    if not(self.guiEle["window"]) then

        local X, Y = 350, 350
        self.guiEle["window"] 	= new(CDxWindow, "Asservatenkammer", X, Y, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Asservatenkammer"})
        self.guiEle["window"].xtraHide = function() self:hide() end
        self.guiEle["window"].ReadOnly = true;

        self.guiEle["list1"]     = new(CDxList, 5, 5, 330, 320, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["list1"]:addColumn("Icon", true)
        self.guiEle["list1"]:addColumn("Item")
        self.guiEle["list1"]:addColumn("Anzahl")

        for itemID, anzahl in pairs(tblItems) do
            local itemSTR = "res/images/items/unknown.png";
            if(fileExists("res/images/items/"..itemID..".png")) then
               itemSTR = "res/images/items/"..itemID..".png"
            end
            self.guiEle["list1"]:addRow(itemSTR.."|"..cItemManager:getInstance():getItems()[itemID].Name.."|"..anzahl, 1)
        end

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAsservatenkammerGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerAsservatenKammerInfoGet", true)
    addEvent("onClientPlayerAsservatenKammerInfoRemove", true)

    self.guiEle         = {}
    self.enabled        = false;
    self.m_funcOnOpen   = function(...) self:show(...) end;
    self.m_funcOnClose   = function(...) self:hide(...) end;

    -- Funktionen --
    addEventHandler("onClientPlayerAsservatenKammerInfoGet", getLocalPlayer(), self.m_funcOnOpen)
    addEventHandler("onClientPlayerAsservatenKammerInfoRemove", getLocalPlayer(), self.m_funcOnClose)

    -- Events --
end

-- EVENT HANDLER --
