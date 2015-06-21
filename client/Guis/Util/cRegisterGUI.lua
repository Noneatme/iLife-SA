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

cRegisterWindowGUI = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRegisterWindowGUI:show()
    if not(self.enabled) and not(clientBusy) then
        self:createElements()
        self.enabled = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRegisterWindowGUI:hide()
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

function cRegisterWindowGUI:createElements()
    if not(self.guiEle["window"]) then

        local X, Y = 450, 400
        self.guiEle["window"] 	= new(CDxWindow, getLocalizationString("GUI_registerpanel_window_title"), X, Y, true, true, "Center|Middle", 0, 0, {tocolor(155, 255, 155, 255), false, getLocalizationString("GUI_registerpanel_window_title_header")})
        self.guiEle["label1"]   = new(CDxLabel, getLocalizationString("GUI_registerpanel_label1_text"), 10, 10, 450, 50, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        local y2 = 0;
        local addy = 25;

        local editX = 200;

        local helpButtonX = 48;

        y2 = y2+addy
        y2 = y2+addy

        local i = 1;
                -- USERNAME
        self.guiEle["reglabel"..i]      = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit1_text"), 10, 40, 250, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["regedit"..i]       = new(CDxEdit, localPlayer:getName(), 190, 40, editX, 20, "string", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["helpbutton"..i]    = new(CDxButton, "?", 190+editX+5, 40, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])

        i = i+1;        -- 2    PASSWORD
        self.guiEle["reglabel"..i]   = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit2_text"), 10, 40+y2, editX/2, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["regedit"..i]    = new(CDxEdit, "", 190, 40+y2, editX, 20, "Masked", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["helpbutton"..i]    = new(CDxButton, "?", 190+editX+5, 40+y2, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])

        i = i+1;        -- 3    PASSWORD 2x
        y2 = y2+addy
        self.guiEle["reglabel"..i]      = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit3_text"), 10, 40+y2, editX/2, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["regedit"..i]       = new(CDxEdit, "", 190, 40+y2, editX, 20, "Masked", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["helpbutton"..i]    = new(CDxButton, "?", 190+editX+5, 40+y2, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["checkbox"..i]      = new(CDxCheckbox, "Use Salt", 190, 40+y2+addy, helpButtonX, 20, tocolor(255, 255, 255, 255), true, self.guiEle["window"])
        self.guiEle["checkbox"..i]:setDisabled(true)

        i = i+1;        -- 4 EMAIL
        y2 = y2+addy+addy/2
        y2 = y2+addy
        self.guiEle["reglabel"..i]   = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit4_text"), 10, 40+y2, editX/2, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["regedit"..i]    = new(CDxEdit, "", 190, 40+y2, editX, 20, "string", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["helpbutton"..i]    = new(CDxButton, "?", 190+editX+5, 40+y2, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])

        i = i+1;        -- 5 DATE OF BRITH
        y2 = y2+addy
        self.guiEle["reglabel"..i]          = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit5_text"), 10, 40+y2, editX/2, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["helpbutton"..i]        = new(CDxButton, "?", 190+editX+5, 40+y2, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["regeditbirthday1"]     = new(CDxEdit, "", 190, 40+y2, 40, 20, "Number", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["regeditbirthday2"]     = new(CDxEdit, "", 240, 40+y2, 40, 20, "Number", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["regeditbirthday3"]     = new(CDxEdit, "", 290, 40+y2, 100, 20, "Number", tocolor(255, 255, 255, 255), self.guiEle["window"])

        i = i+1;        -- 6 RECUIRTED
        y2 = y2+addy
        y2 = y2+addy
        self.guiEle["reglabel"..i]      = new(CDxLabel, getLocalizationString("GUI_registerpanel_edit6_text"), 10, 40+y2, editX/2, 30, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["regedit"..i]       = new(CDxEdit, "", 190, 40+y2, editX, 20, "string", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["helpbutton"..i]    = new(CDxButton, "?", 190+editX+5, 40+y2, helpButtonX, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["labelagb"]         = new(CDxLabel, getLocalizationString("GUI_registerpanel_label_terms_text"), 10, 280, X-30, 230, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        self.guiEle["agbbutton"]                = new(CDxButton, getLocalizationString("GUI_registerpanel_button_view_terms"), 15, 310, 200, 20, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["registerbutton"]           = new(CDxButton, getLocalizationString("GUI_registerpanel_button_register"), 15, 340, 200, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        -- BUTTONS --
        -- REGISTER BUTTON CLICK --

        self.guiEle["registerbutton"]:addClickFunction(function()
            local sUsername         = self.guiEle["regedit1"]:getText();
            local sPassword1        = self.guiEle["regedit2"]:getText();
            local sPassword2        = self.guiEle["regedit3"]:getText();

            local sEmail            = self.guiEle["regedit4"]:getText();
            local iDay              = self.guiEle["regeditbirthday1"]:getText():tonumber();
            local iMonth            = self.guiEle["regeditbirthday2"]:getText():tonumber();
            local iYear             = self.guiEle["regeditbirthday3"]:getText():tonumber();

            local sRecrut           = self.guiEle["regedit6"]:getText();

            if(self.m_bCanRegisterAgain) then
                if(sUsername:lenght() > 3) and (sUsername:lenght() < 22) then
                    if(sPassword1:lenght() > 5) then
                        if(sPassword1 == sPassword2) then
                            if(isEmailCorrect(sEmail)) then
                                if(iDay) and (iDay > 0) and (iDay <= 31) and (iMonth) and (iMonth > 0) and (iMonth <= 12) and (iYear) and (iYear > 1900) and (iYear < 2500) then
                                    if(sRecrut:lenght() <= 3) then
                                        sRecrut = "-";
                                    end

                                    local date = "";

                                    if(iDay < 10) then
                                        iDay = "0"..iDay;
                                    end

                                    if(iMonth < 10) then
                                        iMonth = "0"..iMonth;
                                    end

                                    date = iYear.."-"..iMonth.."-"..iDay

                                    triggerServerEvent("onPlayerRegister", localPlayer, sUsername, sEmail, sPassword1, date, 1)
                                    self.m_bCanRegisterAgain    = false;

                                    cLoadingSprite:getInstance():setEnabled(true);
                                else
                                    showInfoBox("error", getLocalizationString("GUI_registerpanel_error_invalid_date"))
                                end
                            else
                                showInfoBox("error", getLocalizationString("GUI_registerpanel_error_invalid_email"))
                            end
                        else
                            showInfoBox("error", getLocalizationString("GUI_registerpanel_error_password_mismatch"))
                        end
                    else
                        showInfoBox("error", getLocalizationString("GUI_registerpanel_error_invalid_passwordlenght"))
                    end
                else
                    showInfoBox("error", getLocalizationString("GUI_registerpanel_error_invalid_username"))
                end
            else
                showInfoBox("error", getLocalizationString("GUI_registerpanel_error_please_wait"))
            end
        end)

        self.guiEle["window"]:show();
    end
end

-- ///////////////////////////////
-- ///// showRegister 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRegisterWindowGUI:showRegister(...)
    self:hide();
    if not(self.enabled) then
        self:show();
    end

    self.m_bCanRegisterAgain    = true;

end

-- ///////////////////////////////
-- ///// showRegister 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRegisterWindowGUI:onOpenAgain(...)
    self.m_bCanRegisterAgain    = true;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRegisterWindowGUI:constructor(...)

    addEvent("onClientRegisterWindowGUIOpenAgain", true)

    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --
    self.m_funcOnRegisterWindowGUIOpenAgainFunc     = function(...) self:onOpenAgain(...) end

    -- Events --
    addEventHandler("onClientRegisterWindowGUIOpenAgain", getLocalPlayer(), self.m_funcOnRegisterWindowGUIOpenAgainFunc)
end

-- EVENT HANDLER --
