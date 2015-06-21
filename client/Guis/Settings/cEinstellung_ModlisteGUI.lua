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

cEinstellung_ModlisteGUI = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:show()
    if not(self.enabled) then
        self:createElements()
        self.enabled = true
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy = false;
    end
end


-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:createElements()
    if(self.guiEle["window"]) then
        self:hide()
        self.guiEle["window"] = nil
    end
    if not(self.guiEle["window"]) then
        clientBusy = false;
        self.guiEle["window"] 	    = new(CDxWindow, "Modliste", 470, 315, true, true, "Center|Middle", 0, 0, false, "Hier kannst du Mods deaktivieren / aktivieren.")
        self.guiEle["window"]:setHideFunction(function() self:hide() end)

        self.guiEle["list"]         = new(CDxList, 5, 5, 300, 285, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list"]:addColumn("ID")
        self.guiEle["list"]:addColumn("Name")
        self.guiEle["list"]:addColumn("Standart")
        self.guiEle["list"]:addColumn("Aktiviert")

        local mods      = modellImporter:getAllMods()

        local curIndex          = 1;
        local sortedTable       = {};

        for index, bla in pairs(mods) do
            sortedTable[curIndex] = bla;
            sortedTable[curIndex][0] = index;
            curIndex = curIndex+1;
        end

        table.sort( sortedTable, function( a,b ) return a[3] < b[3] end )

        for index, tbl in ipairs(sortedTable) do
            local id            = tbl[0]
            local standart      = "Ja"
            local name          = tbl[3];
            local ak            = "Nein"
            if(tbl[4] == false) then
                standart = "Nein"
            end

            if(modellImporter:isModActivated(id)) then
                ak = "Ja"
            end

            self.guiEle["list"]:addRow(id.."|"..name.."|"..standart.."|"..ak)
        end

        self.guiEle["button1"]      = new(CDxButton, "Mod Aktivieren", 310, 25, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button2"]      = new(CDxButton, "Author", 310, 65, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button1"]:setDisabled(true)
        self.guiEle["button2"]:setDisabled(true)



        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["list"]:addClickFunction(self.m_funcListClick)
        self.guiEle["button1"]:addClickFunction(self.m_funcModActivate)
        self.guiEle["button2"]:addClickFunction(self.m_funcModInfoActivate)
        self.guiEle["window"]:show();


    end
end

-- ///////////////////////////////
-- ///// onListClick 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:onListClick(...)
    if(self.guiEle["list"]:getRowData(1) ~= "nil") then
        self.guiEle["button1"]:setDisabled(false)
        self.guiEle["button2"]:setDisabled(false)

        self.m_iCurMod      = tonumber(self.guiEle["list"]:getRowData(1))

        if(self.guiEle["list"]:getRowData(4) == "Ja") then
            self.guiEle["button1"]:setText("Deaktivieren")
        else
            self.guiEle["button1"]:setText("Aktivieren")
        end

        if not(modellImporter:canModBeDeactivated(self.m_iCurMod)) then
            self.guiEle["button1"]:setDisabled(true)
        end
    else
        self.guiEle["button1"]:setDisabled(true)
        self.guiEle["button2"]:setDisabled(true)
    end
end

-- ///////////////////////////////
-- ///// onModAcClick 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:onModAcClick(iID, ...)
    if(self.m_iCurMod) then
        if(iID == 1) then
            self:hide();
            local info      = "Unbekannt"

            if(modellImporter.modelAuthors[self.m_iCurMod]) then
                info =   modellImporter.modelAuthors[self.m_iCurMod];
            end
            confirmDialog:showConfirmDialog("Diese Mod wurde erstellt von:\n"..info, function() self:show() end, function() self:show() end, true, false);
        else
            if(modellImporter:canModBeDeactivated(self.m_iCurMod)) then
                if(modellImporter:isModActivated(self.m_iCurMod)) then
                    modellImporter:deactivateMod(self.m_iCurMod, true)
                else
                    modellImporter:activateMod(self.m_iCurMod, true)
                end

                self:hide()
                self:show()
            end
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellung_ModlisteGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Events --
    self.m_funcListClick        = function(...) self:onListClick(...) end
    self.m_funcModActivate      = function(...) self:onModAcClick(...) end
    self.m_funcModInfoActivate  = function(...) self:onModAcClick(1, ...) end


end

-- EVENT HANDLER --
