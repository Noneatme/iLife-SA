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

cCorporationProductionManagementGUI = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationProductionManagementGUI:show(...)
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

function cCorporationProductionManagementGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// createTabElements	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationProductionManagementGUI:createTabElements()
    self.m_tabEle         = {}


    self.m_tabEle["tab1"]   =
    {
        [1] = new(CDxList, 5, 25, 350, 400, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [2] = new(CDxButton, "Hinzufuegen", 390, 35, 130, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [3] = new(CDxButton, "Entfernen", 390, 75, 130, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [4] = new(CDxButton, "Slots erhoehen", 380, 135, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),

    }

    self.m_tabEle["tab1"][1]:addColumn("ID");
    self.m_tabEle["tab1"][1]:addColumn("Businessname");
    self.m_tabEle["tab1"][1]:addColumn("Lagereinheiten");
    self.m_tabEle["tab1"][1]:addColumn("Standort");

    self.m_tabEle["tab1"][2]:addClickFunction(function()
        local function ja()
            local id        = tonumber(confirmDialog.guiEle["edit"]:getText())

            if(id) then
                local function ja2()
                    triggerServerEvent("onPlayerCoroprationsManagementProductionBusinessAdd", localPlayer, id)
                end

                local function nein2()

                end
                setTimer(function()

                    confirmDialog:showConfirmDialog("Bist du dir sicher, dass du das Business: "..id.." kaufen moechtest? Du musst dich um das Biz kuemmern, ansonsten wird es deiner Corporation enteignet!", ja2, nein2, true, false)
                end, 100, 1)
            else
                showInfoBox("error", "Ungueltige ID!")
            end
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog("Bitte gebe die ID des Businesses an, welches du zur Corporation hinzufuegen moechtest.", ja, nein, true, true, false)
    end)

    self.m_tabEle["tab1"][3]:addClickFunction(function()
        local id        = self.m_tabEle["tab1"][1]:getRowData(1)

        if(id ~= "nil") then
            local function ja()
                triggerServerEvent("onPlayerCoroprationsManagementProductionBusinessRemove", localPlayer, id)
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog("Bist du dir sicher, dass du das Business verkaufen moechtest? Du erhaelst die Lagereinheiten und 80% des Kaufpreises zurueck.", ja, nein, true, false, false)
        else
            showInfoBox("error", "Bitte waehle ein Busines aus!")
        end
    end)

    self.m_tabEle["tab1"][4]:addClickFunction(function()
        local function ja()
            triggerServerEvent("onPlayerCoroprationsManagementProductionBusinessSlotAdd", localPlayer)
        end

        local function nein()

        end
        local slots  = self.m_uCurCorp.m_iMaxHouses+1;
        confirmDialog:showConfirmDialog("Das Upgrade wird $".._Gsettings.corporation.businessSlotCost[slots].." kosten.\nBist du dir sicher?", ja, nein, true, false, false)

    end)
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationProductionManagementGUI:createElements(...)
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, "Production Management", 550, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Production Management"}, "Hier kannst du die Corporationsbusinesse verwalten.")
        self.guiEle["window"].xtraHide  = function(...) self:hide(...) end
        self.guiEle["window"]:setCloseClass(cCorporationManagementGUI)

        self.guiEle["tabPanel"] = new(CDxTabbedPane, 0, 0, 545, 430, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["tab1"]     = new(CDxTab, "Business", self.guiEle["tabPanel"])

        self.guiEle["tabPanel"]:addTab(self.guiEle["tab1"], {120, tocolor(155, 255, 155, 55)})

        self:createTabElements(...);

        for tabname, tbl in pairs(self.m_tabEle) do
            for index, ele in pairs(tbl) do
                self.guiEle[tabname]:add(ele)
            end
        end

       -- self.guiEle["label1"]   = new(CDxLabel, "")
        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["tabPanel"]:selectTab(1)
        self.guiEle["window"]:show();

    end
end

-- ///////////////////////////////
-- ///// onRefresh   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationProductionManagementGUI:onRefresh(corp, tblBizes)
    if not(self.enabled) then
        self:show()
    end
    if(self.m_tabEle) then
        self.m_uCurCorp = corp;

        self.m_tabEle["tab1"][1]:clearRows()

        if(tblBizes) then
            for id, biz in pairs(tblBizes) do
                local id        = biz.m_iID
                local name      = biz.m_sTitle;
                local x, y, z   = biz.m_uPickup:getPosition()
                local zone      = getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true);
                local eh        = biz.m_iLagerEinheiten;
                self.m_tabEle["tab1"][1]:addRow(tostring(id).."|"..tostring(name).."|"..tostring(eh).."|"..tostring(zone))
            end
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationProductionManagementGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerCorporationProductionManagementGUIRefresh", true)
    addEvent("onCorporationMarketLadeGUIOpen", true)
    addEvent("onCorporationMarketLadeGUIBusinessAbgebeOpen", true)

    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
    self.m_funcOnRefresh    = function(...) self:onRefresh(...) end
    self.m_funcOnMarkerAuflade = function(uCorp)
        local function ja()
            triggerServerEvent("onCorporationMarketLadeGUIOpenBack", localPlayer, tonumber(confirmDialog.guiEle["edit"]:getText()))
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog("Wieviele Lagereinheiten moechtest du aufladen?\nVerfuegbar: "..uCorp.m_iLagerEinheiten..", Max: 200", ja, nein, false, true)
    end
    self.m_funcOnMarkerAblade = function(uBiz)
        local function ja()
            triggerServerEvent("onCorporationMarketBusinessAblade", localPlayer, uBiz.m_iID)
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog("Moechtest du deine Ladung in diesem Business abladen? "..uBiz.m_sTitle..", ID: "..uBiz.m_iID, ja, nein, false, false)
    end
    -- Events --
    addEventHandler("onClientPlayerCorporationProductionManagementGUIRefresh", getLocalPlayer(), self.m_funcOnRefresh)
    addEventHandler("onCorporationMarketLadeGUIOpen", getLocalPlayer(), self.m_funcOnMarkerAuflade)
    addEventHandler("onCorporationMarketLadeGUIBusinessAbgebeOpen", getLocalPlayer(), self.m_funcOnMarkerAblade)


end

-- EVENT HANDLER --
