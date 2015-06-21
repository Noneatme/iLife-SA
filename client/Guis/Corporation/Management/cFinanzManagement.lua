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

cCorporationFinanzManagementGUI = inherit(cSingleton);

--[[

]]



-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationFinanzManagementGUI:show(...)
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

function cCorporationFinanzManagementGUI:hide()
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

function cCorporationFinanzManagementGUI:createElements(uCorp)
    if(uCorp) then
        self.uCorp = uCorp
    end
    if not(uCorp) then
        uCorp = self.uCorp;
    end
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_corporation_financemanagement_window_title"), 500, 350, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Finanzmanagement"}, "Hier kannst du die Finanzen deiner Corporation verwalten.")
        self.guiEle["window"].xtraHide = function(...) self:hide(...) end
        self.guiEle["window"]:setCloseClass(cCorporationManagementGUI)

        self.guiEle["list1"]   = new(CDxList, 3, 5, 200, 320, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["list1"]:addColumn(getLocalizationString("GUI_corporation_financemanagement_list1_name"))
        self.guiEle["list1"]:addColumn(getLocalizationString("GUI_corporation_financemanagement_list1_state"), true)

        self.guiEle["label1"]   = new(CDxLabel, getLocalizationString("GUI_corporation_financemanagement_label1_saldo").." $"..uCorp.m_iSaldo, 200, 10, 300, 20, tocolor(255, 255, 255, 255), 1.25, "default-bold", "center", "top", self.guiEle["window"])

        self.guiEle["button1"]  = new(CDxButton, getLocalizationString("GUI_corporation_financemanagement_button_deposit"), 210, 50, 135, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button2"]  = new(CDxButton, getLocalizationString("GUI_corporation_financemanagement_button_withdraw"), 350, 50, 135, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button3"]  = new(CDxButton, getLocalizationString("GUI_corporation_financemanagement_button_sendmoney"), 210, 90, 135, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button4"]  = new(CDxButton, getLocalizationString("GUI_corporation_financemanagement_button_change_interest"), 210, 170, 135, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button5"]  = new(CDxButton, getLocalizationString("GUI_corporation_financemanagement_button_change_payout"), 350, 170, 135, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button1"]:addClickFunction(function()
            local function ja()
                local value     = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(value) and (value > 0) then
                    triggerServerEvent("onClientCorporationFinanzManagerGeldEinzahlen", localPlayer, value)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_input"))
                end
            end

            local function nein()

            end

            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_financemanagement_confirm_text_howmuchmoney_deposit"), ja, nein, true, true, false)
        end)

        self.guiEle["button2"]:addClickFunction(function()
            local function ja()
                local value     = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(value) and (value > 0) then
                    triggerServerEvent("onClientCorporationFinanzManagerGeldAuszahlen", localPlayer, value)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_input"))
                end
            end

            local function nein()

            end

            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_financemanagement_confirm_text_howmuchmoney_withdraw"), ja, nein, true, true, false)
        end)

        self.guiEle["button3"]:addClickFunction(function()
            local corp          = self.guiEle["list1"]:getRowData(1)
            if(corp ~= "nil") then
                local function ja()
                    local value     = tonumber(confirmDialog.guiEle["edit"]:getText())
                    if(value) and (value > 0) then
                        triggerServerEvent("onClientCorporationFinanzManagerGeldSende", localPlayer, corp, value)
                    else
                        showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_input"))
                    end
                end

                local function nein()

                end

                confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_financemanagement_confirm_text_howmuchmoney_send"), ja, nein, true, true, false)
            else
                showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_corporation"))
            end
        end)

        self.guiEle["button4"]:addClickFunction(function()
            local function ja()
                local value     = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(value) and (value >= 0) and (value <= 100) then
                    triggerServerEvent("onClientCorporationFinanzManagerZinssatzAendere", localPlayer, value)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_input"))
                end
            end

            local function nein()

            end

            confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_financemanagement_confirm_text_select_interest"), ja, nein, true, true, false)
        end)

        self.guiEle["button5"]:addClickFunction(function()
            local function ja()
                local value     = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(value) and (value >= 0) and (value <= 5000) then
                    triggerServerEvent("onClientCorporationFinanzManagerLohnAendere", localPlayer, value)
                else
                    showInfoBox("error", getLocalizationString("GUI_corporation_financemanagement_confirm_text_bad_input"))
                end
            end

            local function nein()

            end

            confirmDialog:showConfirmDialog("Bitte gebe einen Lohn ein (0-5000$), welcher jedem Spieler bei Payday gezahlt wird! (Wenn genug Geld vorhanden ist.)", ja, nein, true, true, false)
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
-- ///// onGuiRefresh 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationFinanzManagementGUI:onGuiRefresh(connections, iSaldo)
    if(self.enabled) then
        self.guiEle["list1"]:clearRows()
        self.guiEle["label1"]:setText(getLocalizationString("GUI_corporation_financemanagement_label1_saldo").." $"..iSaldo)
        for i = 1, #connections, 1 do
            if(connections[i]) and (connections[i][1]) and (connections[i][2]) then
                local corp1         = connections[i][1].m_sFullName
                local state         = connections[i][2]

                self.guiEle["list1"]:addRow(corp1.."|res/images/corporation/miniicons/connections/"..state..".png,", 1)
            end
        end
    end

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationFinanzManagementGUI:constructor(...)
    -- Klassenvariablen --

    addEvent("onClientPlayerCorporationFinanzManagementGUIRefresh", true)

    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
    self.m_funcOnRefresh        = function(...) self:onGuiRefresh(...) end

    -- Events --
    addEventHandler("onClientPlayerCorporationFinanzManagementGUIRefresh", getLocalPlayer(), self.m_funcOnRefresh)
end

-- EVENT HANDLER --
