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

cCorporationHRManagementGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationHRManagementGUI:show(...)
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

function cCorporationHRManagementGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// refreshUsers		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationHRManagementGUI:refreshUsers(uCorp)
    if(self.guiEle["list1"]) then
        self.m_uCurCorp = uCorp;
        self.guiEle["list1"]:clearRows();
        for _, name in pairs(uCorp.m_tblMembers) do
            local roles     = uCorp.m_tblMemberRoles[name];

            local imageString   = "";

            for index, role in pairs(roles) do
                imageString = "res/images/corporation/miniicons/"..index..".png,"..imageString;
            end

            self.guiEle["list1"]:addRow(name.."|"..imageString, 6);
        end
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationHRManagementGUI:createElements(uCorp)
    if(uCorp) then
        self.uCorp = uCorp
    end
    if not(uCorp) then
        uCorp = self.uCorp;
    end
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_corporation_hrmanagement_window_title"), 550, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, getLocalizationString("GUI_corporation_hrmanagement_window_header")}, getLocalizationString("GUI_corporation_hrmanagement_window_helptext"))
        self.guiEle["window"].xtraHide = function() self:hide() end
        self.guiEle["window"]:setCloseClass(cCorporationManagementGUI)

        self.guiEle["list1"]    = new(CDxList, 5, 5, 250, 420, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["list1"]:addColumn("Mitglied")
        self.guiEle["list1"]:addColumn("Rollen", true)

        self.guiEle["list2"]    = new(CDxList, 260, 5, 280, 220, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list2"]:addColumn("Rolle")
        self.guiEle["list2"]:addColumn("Icon", true)

        for i = 0, #_Gsettings.corporation.roles, 1 do
            self.guiEle["list2"]:addRow(_Gsettings.corporation.roles[i].."|res/images/corporation/miniicons/"..i..".png", 1);
        end

        self.guiEle["button_1"] = new(CDxButton, getLocalizationString("GUI_corporation_hrmanagement_button_giverole"), 260, 230, 135, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button_2"] = new(CDxButton, getLocalizationString("GUI_corporation_hrmanagement_button_removerole"), 405, 230, 135, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button_3"] = new(CDxButton, getLocalizationString("GUI_corporation_hrmanagement_button_uninvite"), 260, 260, 135, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button_4"] = new(CDxButton, getLocalizationString("GUI_corporation_hrmanagement_button_invite"), 405, 260, 135, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button_5"] = new(CDxButton, getLocalizationString("GUI_corporation_hrmanagement_button_upgrade_max_slots"), 260, 300, 280, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self:refreshUsers(uCorp)


        self.guiEle["button_1"]:addClickFunction(function()
            local user = self.guiEle["list1"]:getRowData(1);
            if(user ~= "nil") then
                local rolle = self.guiEle["list2"]:getRowData(1);
                if(rolle ~= "nil") then
                    triggerServerEvent("onPlayerCoroprationsManagementHRUserGiveRole", localPlayer, user, rolle)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_hrmanagement_confirm_please_select_a_role"))
                end
            else
                showInfoBox("error", getLocalizationString("GUI_corporation_hrmanagement_confirm_please_select_a_user"))
            end
        end)

        self.guiEle["button_2"]:addClickFunction(function()
            local user = self.guiEle["list1"]:getRowData(1);
            if(user ~= "nil") then
                local rolle = self.guiEle["list2"]:getRowData(1);
                if(rolle ~= "nil") then
                    triggerServerEvent("onPlayerCoroprationsManagementHRUserRemoveRole", localPlayer, user, rolle)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_hrmanagement_confirm_please_select_a_role"))
                end
            else
                showInfoBox("error", getLocalizationString("GUI_corporation_hrmanagement_confirm_please_select_a_user"))
            end
        end)
        self.guiEle["button_3"]:addClickFunction(function()
            local user = self.guiEle["list1"]:getRowData(1);
            if(user ~= "nil") then
                local function ja()
                    triggerServerEvent("onPlayerCoroprationsManagementHRUserRemove", localPlayer, user)
                end

                local function nein()

                end
                confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_hrmanagement_confirm_uninvite_user_text"), ja, nein, true, false, false)
            else
                showInfoBox("error", getLocalizationString("GUI_corporation_hrmanagement_confirm_please_select_a_user"))
            end
        end)
        self.guiEle["button_4"]:addClickFunction(function()
            local function ja()
               triggerServerEvent("onPlayerCoroprationsManagementHRUserAdd", localPlayer, confirmDialog.guiEle["edit"]:getText())
            end

            local function nein()

            end
            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_hrmanagement_confirm_please_provide_username"), ja, nein, true, true, false)
        end)
        self.guiEle["button_5"]:addClickFunction(function()
            local function ja()
                triggerServerEvent("onPlayerCoroprationsManagementHRSlotAdd", localPlayer)
            end

            local function nein()

            end
            local slots  = self.m_uCurCorp.m_iMaxMembers+1;
            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_hrmanagement_confirm_update_slots", _Gsettings.corporation.playerSlotCost[slots]), ja, nein, true, false, false)
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
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationHRManagementGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientPlayerCorporationHRManagementGUIRefresh", true)

    self.guiEle         = {}
    self.enabled        = false;


    -- Funktionen --
    self.m_funcUpdateDatas      = function(...) self:refreshUsers(...) end


    -- Events --
    addEventHandler("onClientPlayerCorporationHRManagementGUIRefresh", getLocalPlayer(), self.m_funcUpdateDatas)

end

-- EVENT HANDLER --
