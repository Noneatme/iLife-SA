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

cCorporationStorageManagementGUI = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationStorageManagementGUI:show(...)
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

function cCorporationStorageManagementGUI:hide()
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

function cCorporationStorageManagementGUI:createTabElements()
    self.m_tabEle         = {}

    self.m_tabEle["tab1"]   =
    {
        [1] = new(CDxLabel, "Inventar:", 10, 25, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),
        [2] = new(CDxButton, "Items einlagern", 10, 55, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [3] = new(CDxButton, "Items auslagern", 170, 55, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [4] = new(CDxLabel, "Lagereinheiten (LU):", 10, 95, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),
        [5] = new(CDxLabel, "Momentan vorhanden: 0", 10, 115, 350, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),
        [6] = new(CDxButton, "Lagereinheiten erwerben", 10, 145, 200, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [7] = new(CDxLabel, "Lagereinheiten werden verwendet, um das Lager von Laeden und Businesse zu fuellen. Der Preis variiert dabei von Stunde zu Stunde.", 10, 195, 400, 200, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),

    }

    self.m_tabEle["tab2"]   =
    {
        [1] = new(CDxList, 5, 25, 350, 400, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [2] = new(CDxButton, "Hinzufuegen", 390, 35, 130, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [3] = new(CDxButton, "Entfernen", 390, 75, 130, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [4] = new(CDxButton, "Slots erhoehen", 380, 135, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),

    }

    self.m_tabEle["tab2"][1]:addColumn("FahrzeugID");
    self.m_tabEle["tab2"][1]:addColumn("Modellname");
    self.m_tabEle["tab2"][1]:addColumn("Standort");

    self.m_tabEle["tab3"]   =
    {
        [1] = new(CDxList, 5, 25, 250, 400, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [2] = new(CDxButton, "Haus hinzufuegen", 290, 35, 230, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [3] = new(CDxButton, "Haus entfernen", 290, 75, 230, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [4] = new(CDxButton, "Hausslots erweitern", 280, 135, 250, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),

    }

    self.m_tabEle["tab3"][1]:addColumn("HausID");
    self.m_tabEle["tab3"][1]:addColumn("Standort");

    self.m_tabEle["tab4"]   =
    {
        [1] = new(CDxList, 5, 25, 250, 400, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [2] = new(CDxButton, "Skin Modifizieren", 290, 35, 230, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
    }
    self.m_tabEle["tab4"][1]:addColumn("Bild", true);
    self.m_tabEle["tab4"][1]:addColumn("Rolle");
    self.m_tabEle["tab4"][1]:addColumn("SkinID");

    -- TAB 4 --
    self.m_tabEle["tab4"][2]:addClickFunction(function()
        local id        = self.m_tabEle["tab4"][1]:getRowData(2)

        if(id ~= "nil") then
            local function ja()
                triggerServerEvent("onPlayerCoroprationsManagementStorageSkinChange", localPlayer, id)
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog("Dein zurzeitiger Skin wird der Hauptskin dieser Rolle. Weiter?", ja, nein, true, false, false)
        else
            showInfoBox("error", "Bitte waehle eine Rolle aus!")
        end
    end)

    -- TAB 3--

    self.m_tabEle["tab3"][2]:addClickFunction(function()
        local function ja()
            local id        = tonumber(confirmDialog.guiEle["edit"]:getText())

            if(id) then
                local function ja2()
                    triggerServerEvent("onPlayerCoroprationsManagementStorageHouseAdd", localPlayer, id)
                end

                local function nein2()

                end
                setTimer(function()

                    confirmDialog:showConfirmDialog("Bist du dir sicher, dass du dein Haus: "..id.." in ein Corporationshaus verwandeln moechtest?", ja2, nein2, true, false)
                end, 100, 1)
            else
                showInfoBox("error", "Ungueltige ID!")
            end
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog("Bitte gebe die Haus-ID deines Hauses an, welches du zur Corporation hinzufuegen moechtest.", ja, nein, true, true, false)

    end)

    self.m_tabEle["tab3"][3]:addClickFunction(function()
        local id        = self.m_tabEle["tab3"][1]:getRowData(1)

        if(id ~= "nil") then
            local function ja()
                triggerServerEvent("onPlayerCoroprationsManagementStorageHouseRemove", localPlayer, id)
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog("Bist du dir sicher, dass du das Haus wieder in ein normales Haus verwandeln moechtest?", ja, nein, true, false, false)
        else
            showInfoBox("error", "Bitte waehle ein Haus aus!")
        end
    end)
    self.m_tabEle["tab3"][4]:addClickFunction(function()
        local function ja()
            triggerServerEvent("onPlayerCoroprationsManagementStorageHouseSlotAdd", localPlayer)
        end

        local function nein()

        end
        local slots  = self.m_uCurCorp.m_iMaxHouses+1;
        confirmDialog:showConfirmDialog("Das Upgrade wird $".._Gsettings.corporation.houseSlotCost[slots].." kosten.\nBist du dir sicher?", ja, nein, true, false, false)
    end)
    -- TAB 2 --

    self.m_tabEle["tab2"][4]:addClickFunction(function()
        local function ja()
            triggerServerEvent("onPlayerCoroprationsManagementStorageVehicleSlotAdd", localPlayer)
        end

        local function nein()

        end
        local slots  = self.m_uCurCorp.m_iMaxVehicles+1;
        confirmDialog:showConfirmDialog("Das Upgrade wird $".._Gsettings.corporation.vehicleSlotCost[slots].." kosten.\nBist du dir sicher?", ja, nein, true, false, false)
    end)

    self.m_tabEle["tab2"][3]:addClickFunction(function()
        local id        = tonumber(self.m_tabEle["tab2"][1]:getRowData(1))

        if(id ~= "nil") then
            local function ja()
                triggerServerEvent("onPlayerCoroprationsManagementStorageVehicleRemove", localPlayer, id)
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog("Bist du dir sicher? Du wirst eventuell das Geld des Fahrzeuges erhalten, wenn man es in einem Laden kaufen konnte.", ja, nein, true, false, false)
        else
            showInfoBox("error", "Bitte waehle ein Fahrzeug aus!")
        end
    end)

    self.m_tabEle["tab2"][2]:addClickFunction(function()
        local function ja()
            local id        = tonumber(confirmDialog.guiEle["edit"]:getText())

            if(id) then
                local function ja2()
                    triggerServerEvent("onPlayerCorporationVehicleAdd", localPlayer, id)
                end

                local function nein2()

                end
                setTimer(function()

                    confirmDialog:showConfirmDialog("Bist du dir sicher, dass du dein Prviatfahrzeug: "..id.." in ein Corporationsfahrzeug verwandeln moechtest? Dein Privatfahrzeug + Tunings werden bei diesem Prozess zerstoert.", ja2, nein2, true, false)
                end, 100, 1)
            else
                showInfoBox("error", "Ungueltige ID!")
            end
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog("Bitte gebe die Privat-ID deines Fahrzeuges an, welches du zur Corporation hinzufuegen moechtest. Die Fahrzeug ID Findest du auf ".._Gsettings.keys.Vehicles..".", ja, nein, true, true, false)
    end)

    -- TAB 1 --
    self.m_tabEle["tab1"][6]:addClickFunction(function()
        local function ja()
            local val       = tonumber(confirmDialog.guiEle["edit"]:getText())
            if(val) and (val > 0) and (val <= 1000) then
                setTimer(function()
                    local function ja2()
                        triggerServerEvent("onPlayerCorporationLagerEinheitBuy", localPlayer, val)
                    end

                    local function nein2()

                    end
                    confirmDialog:showConfirmDialog("Das wird dich $"..val*self.m_iLagerEinheitPreis.." kosten. Bist du sicher?", ja2, nein2, true, false, false);
                end, 100, 1)
            else
                showInfoBox("error", "Ungueltige Eingabe!")
            end
        end
        local function nein()

        end
        confirmDialog:showConfirmDialog("Wieviele Einheiten moechtest du erwerben? \n(Max. 1000)", ja, nein, true, true)
    end)

    self.m_tabEle["tab1"][2]:addClickFunction(function()
        self:hide()
        triggerServerEvent("onClientCorporationStorageManagerItemsEinlagern", localPlayer)
    end)
    self.m_tabEle["tab1"][3]:addClickFunction(function()
        self:hide()
        triggerServerEvent("onClientCorporationStorageManagerItemsAuslagern", localPlayer)
    end)



end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationStorageManagementGUI:createElements(...)
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, "Storage Management", 550, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Storage Management"}, "Hier kannst du das Corporationsinventar verwalten.")
        self.guiEle["window"].xtraHide  = function(...) self:hide(...) end
        self.guiEle["window"]:setCloseClass(cCorporationManagementGUI)

        self.guiEle["tabPanel"] = new(CDxTabbedPane, 0, 0, 545, 430, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["tab1"]     = new(CDxTab, "Inventar", self.guiEle["tabPanel"])
        self.guiEle["tab2"]     = new(CDxTab, "Fahrzeuge", self.guiEle["tabPanel"])
        self.guiEle["tab3"]     = new(CDxTab, "Haeuser", self.guiEle["tabPanel"])
        self.guiEle["tab4"]     = new(CDxTab, "Skins", self.guiEle["tabPanel"])

        self.guiEle["tabPanel"]:addTab(self.guiEle["tab1"], {120, tocolor(155, 255, 155, 55)})
        self.guiEle["tabPanel"]:addTab(self.guiEle["tab2"], {120, tocolor(155, 255, 155, 55)})
        self.guiEle["tabPanel"]:addTab(self.guiEle["tab3"], {120, tocolor(155, 255, 155, 55)})
        self.guiEle["tabPanel"]:addTab(self.guiEle["tab4"], {120, tocolor(155, 255, 155, 55)})

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

function cCorporationStorageManagementGUI:onRefresh(corp, iPrice, iVorhanden, tblVehicles, tblHouses, tblSkins)
    if not(self.enabled) then
        self:show()
    end
    if(self.m_tabEle) then
        self.m_uCurCorp = corp;

        self.m_iLagerEinheitPreis       = iPrice;
        self.m_tabEle["tab1"][5]:setText("Momentan vorhanden: "..iVorhanden.." [Aktueller Preis: $"..iPrice.." / Einheit]");

        self.m_tabEle["tab2"][1]:clearRows()
        for index, veh in pairs(tblVehicles) do
            if(veh) then
                local name      = getVehicleNameFromModel(veh:getModel());
                local x, y, z   = veh:getPosition()
                local zone      = getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true)

                self.m_tabEle["tab2"][1]:addRow(getElementData(veh, "ID").."|"..tostring(name).."|"..tostring(zone))
            end
        end
        -- HOUSES --

        self.m_tabEle["tab3"][1]:clearRows()

        if(tblHouses) then
            for id, house in pairs(tblHouses) do
                local id        = getElementData(house, "h:iID")
                local x, y, z  = getElementPosition(house)
                local zone      = getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true);
                self.m_tabEle["tab3"][1]:addRow(tostring(id).."|"..tostring(zone))
            end
        end
        -- SKINS --
        self.m_tabEle["tab4"][1]:clearRows()

        for i = 0, #_Gsettings.corporation.roles, 1 do
            self.m_tabEle["tab4"][1]:addRow("res/images/corporation/miniicons/"..i..".png".."|".._Gsettings.corporation.roles[i].."|"..(tblSkins[i] or "-"), 1);
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationStorageManagementGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerCorporationStorageManagementGUIRefresh", true)

    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
    self.m_funcOnRefresh    = function(...) self:onRefresh(...) end

    -- Events --
    addEventHandler("onClientPlayerCorporationStorageManagementGUIRefresh", getLocalPlayer(), self.m_funcOnRefresh)
end

-- EVENT HANDLER --
