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

cViewCorporationGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:show()
    if not(self.enabled) and (localPlayer:getData("loggedIn")) then
        self:createElements()
        self.enabled = true

        clientBusy = self.enabled;
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;

        clientBusy = self.enabled;
        self.m_bWaitForServer   = true;
    end
end

-- ///////////////////////////////
-- ///// drawLogo       	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:drawLogo(tblLogo)
    if(isElement(self.m_uCurTexture)) then
        destroyElement(self.m_uCurTexture)
    end

    local sx, sy = 128, 128
    if(toboolean(config:getConfig("lowrammode"))) then
        sx, sy = 64, 64
    end

    local rt        = dxCreateRenderTarget(sx, sy, true)

    dxSetRenderTarget(rt)

    for i = 1, #tblLogo, 1 do
        local tbl = tblLogo[i]

        local id            = tbl[1];
        local r, g, b, a    = getColorFromString(tbl[2])

        if(id ~= 0) then
            if(i == 1) then -- BACKGROUND --
                dxDrawImage(0, 0, sx, sy, "res/images/corporation/backgrounds/"..id..".png", 0, 0, 0, tocolor(r, g, b, a));
            else
                dxDrawImage(0, 0, sx, sy, "res/images/corporation/icons/"..id..".png", 0, 0, 0, tocolor(r, g, b, a));
            end
        end
    end
    dxSetRenderTarget();
    self.m_curTexture = rt;

    return rt;
end

-- ///////////////////////////////
-- ///// generateTabItems	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:generateTabItems()

    local r, g, b, a = getColorFromString(self.m_sCurColor)
    self.m_tabEle["tab1"]   =
    {
        [0] = new(CDxRenderTarget, 5, -10, 195, 480, self.guiEle["tab1"], false),
        [1] = new(CDxRenderTarget, 210, -5, 375, 100, self.guiEle["tab1"], false),
        [2] = new(CDxRenderTarget, 210, 110, 375, 360, self.guiEle["tab1"], false),

        [3] = new(CDxLabel, self.m_sCurCorpName, 5, -5, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", self.guiEle["tab1"]),
        [4] = new(CDxLine2D, 205, -5, 0, 470, tocolor(255, 255, 255, 155), 1, self.guiEle["tab1"]),
        [5] = new(CDxImage, 40, 20, 128, 128, self.m_curTexture, tocolor(255, 255, 255, 255), self.guiEle["tab1"]),
        [6] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab1_label_color"), 5, 155, 200, 50, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", self.guiEle["tab1"]),
        [7] = new(CDxLine2D, 55, 185, 100, 0, tocolor(r, g, b, a), 20, self.guiEle["tab1"]),
        [8] = new(CDxLine2D, 205, 100, 380, 0, tocolor(255, 255, 255, 155), 1, self.guiEle["tab1"]),
        [9] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab1_label_name", self.m_sCurCorpName), 220, 0, 380, 40, tocolor(255, 255, 255, 255), 1.5, "default-bold", "left", "top", self.guiEle["tab1"]),
        [10] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab1_label_tag", self.m_sCurCorpShortName), 220, 30, 380, 40, tocolor(255, 255, 255, 255), 1.5, "default-bold", "left", "top", self.guiEle["tab1"]),
        [11] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab1_label_founder", self.m_sFounderName), 220, 60, 380, 40, tocolor(255, 255, 255, 255), 1.5, "default-bold", "left", "top", self.guiEle["tab1"]),
        [12] = new(CDxList, 215, 115, 365, 125, tocolor(255, 255, 255, 255), self.guiEle["tab1"]),
        [13] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab1_label_bio"), 220, 250, 380, 40, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["tab1"]),
        [14] = new(CDxLabel, self.m_sBio, 220, 280, 360, 180, tocolor(255, 255, 255, 255), 0.7, "default-bold", "left", "top", self.guiEle["tab1"], true),

    }
    self.m_tabEle["tab2"]   =
    {
        [1] = new(CDxList, 5, -10, 585, 350, tocolor(255, 255, 255, 255), self.guiEle["tab1"]),
        [2] = new(CDxLabel, getLocalizationString("GUI_corporation_viewcorp_tab2_label_member").." "..self.m_uCurCorp.m_iMembers.." / "..self.m_uCurCorp.m_iMaxMembers, 220, 350, 200, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["tab1"], true),

    }
    self.m_tabEle["tab3"]   =
    {

    }
    self.m_tabEle["tab4"]   =
    {
        [1] = new(CDxList, 5, -10, 585, 380, tocolor(255, 255, 255, 255), self.guiEle["tab1"]),

    }

    self.m_tabEle["tab1"][12]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab1_list_attribute"));
    self.m_tabEle["tab1"][12]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab1_list_value"));

    self.m_tabEle["tab2"][1]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab2_list_playername"))
    self.m_tabEle["tab2"][1]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab2_list_roles"), true)

    self.m_tabEle["tab4"][1]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab3_list_corpname"))
    self.m_tabEle["tab4"][1]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab3_list_player"))
    self.m_tabEle["tab4"][1]:addColumn(getLocalizationString("GUI_corporation_viewcorp_tab3_list_state"), true)

    if(self.m_uCurCorp) then
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_ceo").."|"..self.m_uCurCorp.m_sFounderName)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_foundeddate").."|"..self.m_uCurCorp.m_sFounderDate)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_interest").."|"..self.m_uCurCorp.m_iTaxRate.."%")
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_payage").."|$"..self.m_uCurCorp.m_iLohn)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_state").."|"..self.m_uCurCorp.m_iState.."%")
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_members").."|"..self.m_uCurCorp.m_iMembers)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_max_members").."|"..self.m_uCurCorp.m_iMaxMembers)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_vehicles").."|"..self.m_uCurCorp.m_iCurCorpVehicle)
        self.m_tabEle["tab1"][12]:addRow(getLocalizationString("GUI_corporation_viewcorp_tab1_list1_max_vehicles").."|"..self.m_uCurCorp.m_iMaxVehicles)


        if(self.m_tblCurConnections) then
            self.m_tabEle["tab4"][1]:clearRows()
            for index, tbl in pairs(self.m_tblCurConnections) do
                if(self.m_tblCurConNames[index]) and (self.m_tblCurConNames[index].m_iMembers) then
                    local status    = tbl[2];
                    status          = "res/images/corporation/miniicons/connections/"..status..".png,"
                    self.m_tabEle["tab4"][1]:addRow(self.m_tblCurConNames[index].m_sFullName.."|"..self.m_tblCurConNames[index].m_iMembers.."|"..status, 1)
                end
            end
        end
    end


    local startY    = 380;
    local increm    = 18;
    for i = 0, #_Gsettings.corporation.roles, 1 do
        self.m_tabEle["tab2"]["image_icon_"..i]   = new(CDxImage, 15, startY, 16, 16, "res/images/corporation/miniicons/"..i..".png", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.m_tabEle["tab2"]["label_icon_"..i]   = new(CDxLabel, _Gsettings.corporation.roles[i], 35, startY, 200, 16, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        startY = startY+increm
    end

    for index, b in pairs(self.m_uCurCorp.m_tblMembers) do
        local rolesString   = "";
        --[[local roles         = self.m_uCurCorp.m_tblMemberRoles[index];
        for r, _ in pairs(roles) do
            r = tonumber(r)
            if(rolesString ~= "") then
                rolesString     = rolesString..", ".._Gsettings.corporation.rolesShort[r];
            else
                rolesString = _Gsettings.corporation.rolesShort[r];
            end
        end
        if not(rolesString) or (rolesString == "") then
            rolesString = "-"
        end]]
        local roles     = self.m_uCurCorp.m_tblMemberRoles[index];

        local imageString   = "";

        for index, role in pairs(roles) do
            imageString = "res/images/corporation/miniicons/"..index..".png,"..imageString;
        end


        self.m_tabEle["tab2"][1]:addRow(index.."|"..imageString, 6)
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_corporation_viewcorp_window_title"), 600, 530, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 155, 255), false, self.m_sCurCorpName}, "Dies ist eine Corporation. (Firma/Gang)")
        self.guiEle["window"].xtraHide  = function() self:hide() end

        self.guiEle["tabpane"]  = new(CDxTabbedPane, 2, 2, 592, 507, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["tab1"]     = new(CDxTab, getLocalizationString("GUI_corporation_viewcorp_tabpanel_tab_profil"), self.guiEle["tabpane"])
        self.guiEle["tab2"]     = new(CDxTab, getLocalizationString("GUI_corporation_viewcorp_tabpanel_tab_members"), self.guiEle["tabpane"])
        self.guiEle["tab3"]     = new(CDxTab, getLocalizationString("GUI_corporation_viewcorp_tabpanel_tab_eventlogs"), self.guiEle["tabpane"])
        self.guiEle["tab4"]     = new(CDxTab, getLocalizationString("GUI_corporation_viewcorp_tabpanel_tab_connections"), self.guiEle["tabpane"])

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self:generateTabItems()


        for tabname, tbl in pairs(self.m_tabEle) do
            for index, ele in pairs(tbl) do
                self.guiEle[tabname]:add(ele)
            end
        end

        self.guiEle["tabpane"]:addTab(self.guiEle["tab1"], {120, tocolor(155, 155, 255, 55)})
        self.guiEle["tabpane"]:addTab(self.guiEle["tab2"], {120, tocolor(155, 155, 255, 55)})
        self.guiEle["tabpane"]:addTab(self.guiEle["tab3"], {120, tocolor(155, 155, 255, 55)})
        self.guiEle["tabpane"]:addTab(self.guiEle["tab4"], {120, tocolor(155, 155, 255, 55)})

        self.guiEle["window"]:show();

    end
end
-- ///////////////////////////////
-- ///// onCorpInfosReceive //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:onCorpInfosReceive(tblCorp, con, names)
    if(self.m_bWaitForServer) then
        self.m_uCurCorp         = tblCorp;
        self.m_sCurCorpName     = tblCorp.m_sFullName;
        self.m_sCurColor        = tblCorp.m_sColor;
        self.m_sFounderName     = tblCorp.m_sFounderName;
        self.m_sCurCorpShortName= tblCorp.m_sShortName;
        self.m_sBio             = tblCorp.m_sBio;
        self.m_bWaitForServer   = false;
        self.m_tblCurIcon       = tblCorp.m_tblIcons;

        self.m_tblCurConnections = con;
        self.m_tblCurConNames   = names;

        self:drawLogo(self.m_tblCurIcon)
        self.m_bWaitForServer   = false;
        self:show();
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cViewCorporationGUI:constructor(...)
    addEvent("onClientCorporationViewGUIOpen", true)

    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    self.m_sCurCorpName = "-"
    self.m_uCurTexture  = false;

    self.m_tblCurIcon   =
    {
        [1] = {13, "#AAFFAA"},
        [2] = {51, "#FF0000"},
        [3] = {115, "#00FFAA"},

    }

    self.m_iMaxBioZeichen   = 1200;

    self.m_tabEle           = {}
    self.m_bWaitForServer   = true;

    -- Funktionen --
 --   self:onCorpInfosReceive(tblInfos);
    self.m_funcOpen = function(...) self:onCorpInfosReceive(...) end
    -- Events --
    addEventHandler("onClientCorporationViewGUIOpen", getLocalPlayer(), self.m_funcOpen)
end

-- EVENT HANDLER --
