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

cCorporationGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:show()
    if not(self.enabled) and not(clientBusy) and (localPlayer:getData("loggedIn")) then
        self:createElements()
        self.enabled = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:hide()
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

function cCorporationGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_corporation_main_window_title"), 450, 400, true, true, "Center|Middle", 0, 0, {tocolor(225, 125, 155, 255), false, "Corporations"}, "Hier kannst du eigene Firmen und Gangs gruenden.")
        self.guiEle["list1"]	= new(CDxList, 5, 5, 250, 370, tocolor(255,255,255,255), self.guiEle["window"])

        self.guiEle["window"].xtraHide = function() self:hide() end
        self.guiEle["list1"]:addColumn(getLocalizationString("GUI_corporation_main_list1_id"))
        self.guiEle["list1"]:addColumn(getLocalizationString("GUI_corporation_main_list1_name"))
        self.guiEle["list1"]:addColumn(getLocalizationString("GUI_corporation_main_list1_members"))

        self.guiEle["button1"]	= new(CDxButton, getLocalizationString("GUI_corporation_main_button_viewcorp"), 280, 20, 139, 29, tocolor(255,255,255,255), self.guiEle["window"])
        self.guiEle["button2"]	= new(CDxButton, getLocalizationString("GUI_corporation_main_button_createcorp"), 280, 60, 139, 29, tocolor(255,255,255,255), self.guiEle["window"])

        self.guiEle["button1"]:setDisabled(true)

        self.guiEle["button1"]:addClickFunction(function()
            self:hide();
            triggerServerEvent("onCorporationViewOpenReqeust", localPlayer, self.guiEle["list1"]:getRowData(1))
            loadingSprite:setEnabled(true)
        end)

        self.guiEle["button2"]:addClickFunction(function()
            self:hide();
            triggerServerEvent("onCorporationCreateOpenReqeust", localPlayer)
            loadingSprite:setEnabled(true)
        end)


        for id, corp in pairs(self.m_tblCorps) do
            self.guiEle["list1"]:addRow(corp.m_iID.."|"..corp.m_sFullName.."|"..corp.m_iMembers);
        end

        self.guiEle["list1"]:addClickFunction(function()
            if(tonumber(self.guiEle["list1"]:getRowData(1))) then
                self.m_iSelectedID = tonumber(self.guiEle["list1"]:getRowData(1))
                self.guiEle["button1"]:setDisabled(false)
            else
                self.guiEle["button1"]:setDisabled(true)
            end
        end)

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();

    end
end

-- ///////////////////////////////
-- ///// onCorpsReceive		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:onCorpsReceive(tblCorps)
    if(self.guiEle["window"]) then
        self.guiEle["list1"]:clearRows();

        for index, row in pairs(tblCorps) do
            -- EINFUEGEN
        end
    end
end

-- ///////////////////////////////
-- ///// receiveCorps 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:receiveCorps(tblCorps)
    if(self.m_bWaitForServer) then
        self.m_bWaitForServer = false;
        self.m_tblCorps = tblCorps;
        self:show();
    end
end

-- ///////////////////////////////
-- ///// onToggle    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:onToggle()
    if not(self.m_bWaitForServer) then
        if(self.enabled) then
            self:hide()
        else
            loadingSprite:setEnabled(true)
            triggerServerEvent("onPlayerCorporationsRequest", localPlayer)
            self.m_bWaitForServer = true;
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerCorporationsReceive", true)
    addEvent("onClientPlayerCorporationInviteRequest", true)


    self.guiEle         = {}
    self.enabled        = false;

    self.m_bWaitForServer = false;

    -- Funktionen --
    self.m_funcReceiveCorps     = function(...) self:receiveCorps(...) end
    self.m_funcToggleGui        = function(...) self:onToggle(...) end

    -- Events --

    bindKey(_Gsettings.keys.Corps, "down", self.m_funcToggleGui)

    addEventHandler("onClientPlayerCorporationsReceive", getLocalPlayer(), self.m_funcReceiveCorps);
    addEventHandler("onClientPlayerCorporationInviteRequest", getLocalPlayer(), function(sName, sName2)
        local function ja()
            triggerServerEvent("onPlayerCorporationInviteAccept", localPlayer)
        end

        local function nein()

        end

        confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_main_confirm_invite", sName2, sName), ja, nein, false, false)
    end)
end

-- EVENT HANDLER --
