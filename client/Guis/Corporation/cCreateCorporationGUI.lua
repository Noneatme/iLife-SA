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

cCreateCorporationGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:show()
    if not(self.enabled) and not(clientBusy) and (localPlayer:getData("loggedIn")) then
        self:createElements()
        self.enabled    = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:hide()
    if(self.guiEle["window"])  then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// redrawIcon 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:redrawIcon()
    if(isElement(self.m_uCurTexture)) then
        destroyElement(self.m_uCurTexture)
    end
    self.m_uCurTexture      = cViewCorporationGUI:drawLogo(self.m_tblCurIcon)

    self.guiEle["image1"]:setImage(self.m_uCurTexture);
end


-- ///////////////////////////////
-- ///// selectNextIcon		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:selectNextIcon(iIconID)
    local curIconID = self.m_tblCurIcon[iIconID][1];

    local max = self.m_iMaxIcons;
    if(iIconID == 1) then
        max = self.m_iMaxBackgrounds;
    end

    if(curIconID >= max) then
        curIconID = 0
    else
        curIconID = curIconID+1;
    end
    self.m_tblCurIcon[iIconID][1] = curIconID;
    self:redrawIcon();
end

-- ///////////////////////////////
-- ///// selectPrevIcon		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:selectPrevIcon(iIconID)
    local curIconID = self.m_tblCurIcon[iIconID][1];

    local max = self.m_iMaxIcons;
    if(iIconID == 1) then
        max = self.m_iMaxBackgrounds;
    end


    if(curIconID < 1) then
        curIconID = max;
    else
        curIconID = curIconID-1;
    end
    self.m_tblCurIcon[iIconID][1] = curIconID;
    self:redrawIcon();
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	        = new(CDxWindow, getLocalizationString("GUI_corporation_createcorp_window_title"), 350, 410, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 155, 255), false, getLocalizationString("GUI_corporation_createcorp_header")}, getLocalizationString("GUI_corporation_createcorp_infotext"))
        self.guiEle["window"].xtraHide  = function() self:hide() end

        self.guiEle["window"]:addRenderFunction(self.m_funcRender)

        self.guiEle["label1"]           = new(CDxLabel, getLocalizationString("GUI_corporation_createcorp_label_name"), 5, 10, 150, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["label2"]           = new(CDxLabel, getLocalizationString("GUI_corporation_createcorp_label_shortcut"), 5, 40, 150, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
        self.guiEle["label3"]           = new(CDxLabel, getLocalizationString("GUI_corporation_createcorp_label_basecolor"), 5, 70, 150, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])
   --     self.guiEle["label4"]   = new(CDxLabel, "Icon: ", 5, 50, 340, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", self.guiEle["window"])

        self.guiEle["image1"]           = new(CDxImage, 140-32, 130-32, 128, 128, self.m_uCurTexture, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["edit1"]            = new(CDxEdit, "", 155, 5, 170, 25, "text", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["edit2"]            = new(CDxEdit, "", 155, 35, 170, 25, "text", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["btnfarbe"]         = new(CDxButton, getLocalizationString("GUI_corporation_createcorp_button_select"), 155, 65, 170, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["edit_1_btn1"]      = new(CDxButton, "<< ", 5, 115, 90, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["edit_1_btn2"]      = new(CDxButton, ">> ", 245, 115, 60, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["edit_2_btn1"]      = new(CDxButton, "<< ", 5, 145, 90, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["edit_2_btn2"]      = new(CDxButton, ">> ", 245, 145, 60, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["edit_3_btn1"]      = new(CDxButton, "<< ", 5, 175, 90, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["edit_3_btn2"]      = new(CDxButton, ">> ", 245, 175, 60, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])


        self.guiEle["btn_c1"]           = new(CDxButton, "C", 310, 115, 30, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["btn_c2"]           = new(CDxButton, "C", 310, 145, 30, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["btn_c3"]           = new(CDxButton, "C", 310, 175, 30, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        -- "Eine Corporation kostet $"..self.m_iCurrentPrice..". Bitte stelle sicher, dass du das Geld auf deinem Bankkonto hast. Bedenke: Diese Einstellungen koennen nicht mehr geaendert werden!\n\nEine Corporation kann eine Gang, Verein, Organisation oder ein Unternehmen sein."
        self.guiEle["label_info"]       = new(CDxLabel, getLocalizationString("GUI_corporation_createcorp_label_info", self.m_iCurrentPrice), 5, 240, 350, 120, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"], true)
        self.guiEle["btn_submit"]       = new(CDxButton, getLocalizationString("GUI_corporation_createcorp_btn_submit"), 85, 355, 170, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["btn_submit"]:addClickFunction(function()
            self.m_sCurCorpNameFull     = self.guiEle["edit1"]:getText()
            self.m_sCurCorpNameShort    = self.guiEle["edit2"]:getText()

            if(string.len(self.m_sCurCorpNameFull) > 2) and (string.len(self.m_sCurCorpNameShort) <= 5) then
                local function ja()
                    self:hide();
                    triggerServerEvent("onPlayerCorporationCreate", localPlayer, self.m_sCurCorpNameFull, self.m_sCurCorpNameShort, self.m_sCurrentColor, self.m_tblCurIcon)
                end

                local function nein()

                end

                confirmDialog:showConfirmDialog(getLocalizationString("GUI_corporation_createcorp_confirm_areyousure"), ja, nein, false, false, true);
            else
                showInfoBox("error", getLocalizationString("GUI_corporation_createcorp_confirm_error_tooshortname"));
            end
        end)

        self.guiEle["btnfarbe"]:addClickFunction(function()
            self.m_bSelectColor     = true;
            self.m_iSelectedColor   = false;
            local r, g, b, a = getColorFromString(self.m_sCurrentColor);
            if(colorPicker) then
                colorPicker.openSelect(r, g, b, a)
            end
        end)

        for i = 1, 3, 1 do
            self.guiEle["edit_"..i.."_btn2"]:addClickFunction(function()
                self:selectNextIcon(i);
            end)
            self.guiEle["edit_"..i.."_btn1"]:addClickFunction(function()
                self:selectPrevIcon(i);
            end)

            self.guiEle["btn_c"..i]:addClickFunction(function()
                -- COLORPICKER --
                self.m_bSelectColor     = false;
                self.m_iSelectedColor   = i;

                local r, g, b, a = getColorFromString(self.m_tblCurIcon[self.m_iSelectedColor][2]);
                if(colorPicker) then
                    colorPicker.closeSelect();
                    colorPicker.openSelect(r, g, b, a)
                end
            end)
        end

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();

        self:redrawIcon()
    end
end

-- ///////////////////////////////
-- ///// onRender    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:onRender()
    if(self.m_bSelectColor) then
        if(colorPicker) then
            local r, g, b, a = colorPicker.updateTempColors()

            self.m_sCurrentColor = RGBToHex(r, g, b, a)
            self.guiEle["label3"]:setColor(tocolor(r, g, b, a))
        end
    end
    if(self.m_iSelectedColor) then
        if(colorPicker) then
            local r, g, b, a = colorPicker.updateTempColors()
            self.m_tblCurIcon[self.m_iSelectedColor][2] = RGBToHex(r, g, b, a)
            self:redrawIcon()
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCreateCorporationGUI:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientCorporationCreateGUIOpen", true)

    self.guiEle         = {}
    self.enabled        = false;

    self.m_tabEle           = {}
    self.m_bWaitForServer   = false;

    self.m_sCurrentColor    = "#FFFFFF";

    self.m_tblCurIcon   =
    {
        [1] = {2, "#FFFFFF"},
        [2] = {1, "#000000"},
        [3] = {0, "#FF0000"},
    }


    self.m_iMaxIcons        = _Gsettings.corporation.iMaxIcons;
    self.m_iMaxBackgrounds  = _Gsettings.corporation.iMaxBackgrounds;


    self.m_iCurrentPrice    = _Gsettings.corporation.iPriceToCreate;

    -- Funktionen --

    self.m_funcRender       = function(...) self:onRender(...) end
    self.m_funcOpen         = function(...) loadingSprite:setEnabled(false) self:show(...) end

    -- Events --
    addEventHandler("onClientCorporationCreateGUIOpen", getLocalPlayer(), self.m_funcOpen)
end

-- EVENT HANDLER --
