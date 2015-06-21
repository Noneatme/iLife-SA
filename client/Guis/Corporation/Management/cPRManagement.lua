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

cCorporationPRManagementGUI = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationPRManagementGUI:show(...)
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

function cCorporationPRManagementGUI:hide()
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

function cCorporationPRManagementGUI:createTabElements(corp)
    self.m_tabEle         = {}

    local modt              = ""
    local bio               = ""
    if(corp) then
        modt = corp.m_sMotd
        bio = corp.m_sBio
    end

    self.m_tabEle["tab1"]   =
    {
        [1] = new(CDxLabel, "MODT: ", 10, 25, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),
        [2] = new(CDxEdit, modt, 50, 25, 200, 20, "text", tocolor(255, 255, 255, 255), self.guiEle["window"]),

        [3] = new(CDxLabel, "Bio: ", 10, 50, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"]),
        [4] = new(CDxMemo, bio, 5, 80, 535, 300, "text", tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [5] = new(CDxButton, "Speichern", 10, 390, 200, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),

    }

    self.m_tabEle["tab2"]   =
    {
        [1] = new(CDxList, 5, 25, 250, 400, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [2] = new(CDxButton, "Beziehung entfernen", 265, 25, 200, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [3] = new(CDxButton, "Neues Buendniss", 265, 65, 270, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),
        [4] = new(CDxButton, "Neues Feindschaft", 265, 100, 270, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]),

    }
    self.m_tabEle["tab2"][1]:addColumn("Corporation")
    self.m_tabEle["tab2"][1]:addColumn("Status", true)

--[[
    local connections   = corp.m_tblConnections;

    if(connections) then
        for index, row in pairs(connections) do
            local status    = tonumber(row['iStatus'])

            local name      = corp.m_tblConnectionNames[index];

            self.m_tabEle["tab2"][1]:addRow(name.."|res/images/corporation/miniicons/connections/"..status..".png,", 1)
        end
    end]]

    self.m_tabEle["tab1"][5]:addClickFunction(function()
        local modt      = self.m_tabEle["tab1"][2]:getText()
        local bio       = self.m_tabEle["tab1"][4]:getText();
        local function ja()
            triggerServerEvent("onPlayerPRManagementBioEdit", localPlayer, modt, bio)
        end

        local function nein()

        end
        confirmDialog:showConfirmDialog("Bist du dir sicher, dass du die Einstellungen ueberschreiben moechtest?", ja, nein, true, false, true)
    end)

    self.m_tabEle["tab2"][2]:addClickFunction(function()
        local corp      = self.m_tabEle["tab2"][1]:getRowData(1)
        if(corp ~= "nil") then
            local function ja()
                triggerServerEvent("onPlayerPRManagementBeziehungRemove", localPlayer, corp)
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog("Bist du dir sicher, dass du diese Beziehung entfernen moechtest?", ja, nein, true, false, true)
        else
            showInfoBox("error", "Du musst eine Beziehung auswaehlen!")
        end
    end)
    self.m_tabEle["tab2"][3]:addClickFunction(function()
        local function ja()
            triggerServerEvent("onPlayerPRManagementBuendnissAdd", localPlayer, confirmDialog.guiEle["edit"]:getText())
        end

        local function nein()

        end
        confirmDialog:showConfirmDialog("Bitte gebe den Namen der Corporation ein: (Buendniss)", ja, nein, true, true, true)
    end)
    self.m_tabEle["tab2"][4]:addClickFunction(function()
        local function ja()
            triggerServerEvent("onPlayerPRManagementFeindschaftAdd", localPlayer, confirmDialog.guiEle["edit"]:getText())
        end

        local function nein()

        end
        confirmDialog:showConfirmDialog("Bitte gebe den Namen der Corporation ein: (Feindschaft)", ja, nein, true, true, true)
    end)
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationPRManagementGUI:createElements(...)
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, "PR Management", 550, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "PR Management"}, "Hier kannst du die PR (Public Relations) verwalten.")
        self.guiEle["window"].xtraHide  = function(...) self:hide(...) end;
        self.guiEle["window"]:setCloseClass(cCorporationManagementGUI)

        self.guiEle["tabPanel"] = new(CDxTabbedPane, 0, 0, 545, 430, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["tab1"]     = new(CDxTab, "Corporation", self.guiEle["tabPanel"])
        self.guiEle["tab2"]     = new(CDxTab, "Beziehungen", self.guiEle["tabPanel"])

        self.guiEle["tabPanel"]:addTab(self.guiEle["tab1"], {150, tocolor(155, 255, 155, 55)})
        self.guiEle["tabPanel"]:addTab(self.guiEle["tab2"], {150, tocolor(155, 255, 155, 55)})

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

function cCorporationPRManagementGUI:onRefresh(result, ...)
    if not(self.enabled) then
        self:show(...)
    end
    if(self.m_tabEle) and (self.m_tabEle["tab2"]) then
        self.m_tabEle["tab2"][1]:clearRows();

        for i = 1, #result, 1 do
            if(result[i]) and (result[i][1]) and (result[i][2]) then
                local corp1         = result[i][1].m_sFullName
                local state         = result[i][2]

                self.m_tabEle["tab2"][1]:addRow(corp1.."|res/images/corporation/miniicons/connections/"..state..".png,", 1)
            end
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationPRManagementGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerCorporationPRManagementGUIRefresh", true)


    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
    self.m_funcOnRefresh    = function(...) self:onRefresh(...) end

    -- Events --
    addEventHandler("onClientPlayerCorporationPRManagementGUIRefresh", getLocalPlayer(), self.m_funcOnRefresh)
end

-- EVENT HANDLER --
