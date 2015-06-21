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

cCorporationManagementGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManagementGUI:show()
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

function cCorporationManagementGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// onInformationsReceive////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManagementGUI:onInformationsReceive(tblInfos, curRoles)
    if(self.guiEle["window"]) then
        self:hide()
    else
        self.m_sCorporationName     = tblInfos.m_sFullName;
        self.m_uCurCorp             = tblInfos;
        self.m_uCurRoles            = curRoles;

        self:show()

        self:toggleRankButtons();
    end
end

-- ///////////////////////////////
-- ///// ToggleRankButtons  ////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManagementGUI:toggleRankButtons()
    for i = 1, 6, 1 do
        self.guiEle["button"..i]:setDisabled(true)
    end

    local buttonsEnabled    = {}


    for index, role in pairs(self.m_uCurRoles) do
        index = tonumber(index)
        if(toboolean(role) == true) then
            if(index == 0) or (index == 1) then
                for i = 1, 6, 1 do
                    buttonsEnabled[i] = true;
                end
            end
            if(index == 2) then
                buttonsEnabled[1] = true
            end
            if(index == 3) then
                buttonsEnabled[2] = true
            end
            if(index == 4) then
                buttonsEnabled[3] = true
            end
            if(index == 5) then
                buttonsEnabled[4] = true
            end
            if(index == 6) then
                buttonsEnabled[5] = true
            end
            buttonsEnabled[6] = true
        end
    end
    for i = 1, 6, 1 do
        if(buttonsEnabled[i]) then
            self.guiEle["button"..i]:setDisabled(false)
        end
    end

    self.guiEle["list1"]:clearRows();

    for _, name in pairs(self.m_uCurCorp.m_tblMembers) do
        local roles     = self.m_uCurCorp.m_tblMemberRoles[name];

        local imageString   = "";

        for index, role in pairs(roles) do
            imageString = "res/images/corporation/miniicons/"..index..".png,"..imageString;
        end

        self.guiEle["list1"]:addRow(name.."|"..imageString, 6);
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

--[[
--_Gsettings.corporation.roles                =
{
    [0]         = "CEO",
    [1]         = "Deputy CEO",
    [2]         = "HR manager",
    [3]         = "PR manager",
    [4]         = "Financial officier",
    [5]         = "Storage operator",
    [6]         = "Production manager",
}
 ]]

function cCorporationManagementGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_corporation_management_window_title"), 450, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, getLocalizationString("GUI_corporation_management_window_headertext")}, getLocalizationString("GUI_corporation_management_window_infotext"))
        self.guiEle["window"].xtraHide = function(...) self:hide(...) end


        self.guiEle["label1"]   = new(CDxLabel, "Corporation: "..self.m_sCorporationName, 5, 10, 320, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        self.guiEle["list1"]    = new(CDxList, 5, 40, 200, 260, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list1"]:addColumn("Spielername")
        self.guiEle["list1"]:addColumn("Rolle", true)

        self.guiEle["button1"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_hrmanagement"), 230, 40, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button2"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_prmanagement"), 230, 90, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button3"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_financemanagement"), 230, 140, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button4"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_storagemanagement"), 230, 190, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button5"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_productionmanagement"), 230, 240, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button6"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_leavecorp"), 230, 290, 200, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button7"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_corporfile"), 230, 360, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button8"]  = new(CDxButton, getLocalizationString("GUI_corporation_management_button_setskin"), 230, 315, 200, 40, tocolor(255, 255, 255, 255), self.guiEle["window"])


        local startY    = 305;
        local increm    = 18;
        for i = 0, #_Gsettings.corporation.roles, 1 do
            self.guiEle["image_icon_"..i]   = new(CDxImage, 5, startY, 16, 16, "res/images/corporation/miniicons/"..i..".png", tocolor(255, 255, 255, 255), self.guiEle["window"])
            self.guiEle["label_icon_"..i]   = new(CDxLabel, _Gsettings.corporation.roles[i], 25, startY, 200, 16, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

            startY = startY+increm
        end


        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        for i = 1, 5, 1 do
            self.guiEle["button"..i]:addClickFunction(function()
                triggerServerEvent("onCorporationManagementGUIOpenRequest", localPlayer, i);
                self:hide();
                loadingSprite:setEnabled(true)
            end)
        end

        self.guiEle["button8"]:addClickFunction(function()
            triggerServerEvent("onCorporationSetSkin", localPlayer);
        end)

        self.guiEle["button7"]:addClickFunction(function()
            triggerServerEvent("onCorporationViewOpenReqeust", localPlayer, self.m_uCurCorp.m_iID);
            self:hide();
            loadingSprite:setEnabled(true)
        end)

        self.guiEle["button6"]:addClickFunction(function()
            local function ja()
                triggerServerEvent("onPlayerCorporationLeave", localPlayer)
                self:hide()
            end

            local function nein()

            end

            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_management_confirm_leave_corp_text"), ja, nein, false, false, true);
        end)



        self.guiEle["window"]:show();

    end
end

-- ///////////////////////////////
-- ///// openSubMenus  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManagementGUI:openSubMenus(iID, ...)
    if(iID == 1) then
        cCorporationHRManagementGUI:getInstance():show(...)
    elseif(iID == 2) then
        cCorporationPRManagementGUI:getInstance():show(...)
        triggerServerEvent("onClientCorporationPRManagerOpen", localPlayer)
    elseif(iID == 3) then
        cCorporationFinanzManagementGUI:getInstance():show(...)
        triggerServerEvent("onClientCorporationFinanzManagerOpen", localPlayer)
    elseif(iID == 4) then
        cCorporationStorageManagementGUI:getInstance():show(...)
        triggerServerEvent("onClientCorporationStorageManagerOpen", localPlayer)
    elseif(iID == 5) then
        cCorporationProductionManagementGUI:getInstance():show(...)
        triggerServerEvent("onClientCorporationProductionManagerOpen", localPlayer)
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManagementGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onCorporationsMenuMangementOpen", true)
    addEvent("onCorporationManagementGUIOpenRequestSucess", true)

    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --

    self.m_funcOnOpen       = function(...) self:onInformationsReceive(...) end
    self.m_funcOpenSubMenus = function(...) self:openSubMenus(...) end

    -- Events --
    addEventHandler("onCorporationsMenuMangementOpen", getLocalPlayer(), self.m_funcOnOpen);
    addEventHandler("onCorporationManagementGUIOpenRequestSucess", getLocalPlayer(), self.m_funcOpenSubMenus)
end

-- EVENT HANDLER --
