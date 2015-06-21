--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cRadioManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cRadioManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// loadDefaultRadios	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:reloadRadios()
    --[[
    local radioFile         = File("res/radios.txt");

    if(radioFile) then
        self.m_tblRadios = {}

        local rows      = split(radioFile:read(radioFile:getSize()), "\n");
        for index, row in ipairs(rows) do
            if(gettok(row, 1, ",")) and (gettok(row, 2, ",")) then
                self.m_tblRadios[self.m_iCurrentRadioIndex] = {gettok(row, 1, ","), gettok(row, 2, ",")}

                self.m_iCurrentRadioIndex = self.m_iCurrentRadioIndex+1
            end
        end

        outputConsole("Found "..self.m_iCurrentRadioIndex.." Radio Channels")
    end]]

    self.m_tblCurRadios                 = cConfig_RadioConfig:getInstance():getAllConfig()
    self.m_iCurrentRadioIndex           = 1;
    self.m_tblRadios                    = {}


    for index, tokens in pairs(self.m_tblCurRadios) do
        if(gettok(index, 1, "radio_")) then

            if(gettok(tokens, 1, "|")) and (gettok(tokens, 2, "|")) then
                self.m_tblRadios[self.m_iCurrentRadioIndex] = {gettok(tokens, 1, "|"), gettok(tokens, 2, "|")}
                self.m_iCurrentRadioIndex = self.m_iCurrentRadioIndex+1;
            end
        end
    end
end

-- ///////////////////////////////
-- ///// addRadio    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:addRadio(sURL, sName)
    cConfig_RadioConfig:getInstance():setConfig("radio_"..self.m_iCurrentRadioIndex, sName.."|"..sURL)
    self.m_iCurrentRadioIndex = self.m_iCurrentRadioIndex+1
    showInfoBox("sucess", "Radio: "..sName.." hinzugefuegt!")
    self:reloadRadios()
end

-- ///////////////////////////////
-- ///// removeRadio    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:removeRadio(sName)
    local rads = cConfig_RadioConfig:getInstance():getAllConfig()
    local id    = false;
    for index, val in pairs(rads) do
        if(gettok(val, 1, "|")) then
            if(gettok(val, 1, "|"):lower() == sName:lower()) then
                id = tonumber(gettok(index, 1, "radio_"))
            end
        end
    end

    local sucess = (id and cConfig_RadioConfig:getInstance():removeConfig("radio_"..id))
    if(sucess) then
        showInfoBox("sucess", "Radio: "..sName.." entfernt!")
        self:reloadRadios()
    else
        showInfoBox("error", "Radio wurde nicht gefunden.")
    end
end

-- ///////////////////////////////
-- ///// generateCommands	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:generateCommands()
    addCommandHandler("addradio", function(cmd, sRadioURL, ...)
        if(sRadioURL) and(...) then
            self:addRadio(sRadioURL, table.concat({...}, " "));

        else
            showInfoBox("info", "Benutze: /addradio <RadioURL> <RadioName>")
        end
    end)

    addCommandHandler("removeradio", function(cmd, ...)
        if(...) then
            self:removeRadio(table.concat({...}, " "));
        else
            showInfoBox("info", "Benutze: /removeradio <RadioName>")
        end
    end)

    addCommandHandler("listradios", function(cmd)
        for i, tbl in pairs(self.m_tblRadios) do
            outputConsole("Radio "..i..": "..tbl[1].." | "..tbl[2])
        end
    end)
end

-- ///////////////////////////////
-- ///// onVehicleEnter 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:onVehicleEnter(uVehicle, iSeat)
    if not(self.m_bEnabled) then
        setRadioChannel(0);

        if(iSeat == 0) then
            bindKey("mouse_wheel_down", "down", self.m_funcSwitchDown)
            bindKey("mouse_wheel_up", "down", self.m_funcSwitchUp)
        end

        self.m_bEnabled     = true;

        local url       = uVehicle:getData("radio:URL")

        if(url) then
            self.m_sCurRadioURL     = url;
            self.m_sCurRadioName    = uVehicle:getData("radio:NAME")
            self:startRadio();
        end

        addEventHandler("onClientRender", getRootElement(), self.m_funcOnRender)
    end
end

-- ///////////////////////////////
-- ///// onVehicleExit   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:onVehicleExit(uVehicle, iSeat)
    if(self.m_bEnabled) then
        if(iSeat) and (iSeat == 0) then
            unbindKey("mouse_wheel_down", "down", self.m_funcSwitchDown)
            unbindKey("mouse_wheel_up", "down", self.m_funcSwitchUp)
        end

        self:stopRadio();
        self.m_bEnabled     = false;

        removeEventHandler("onClientRender", getRootElement(), self.m_funcOnRender)
    end
end

-- ///////////////////////////////
-- ///// setRadioSwitchTimer //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:setRadioSwitchTimer()
    if(isTimer(self.m_uSwitchTimer)) then
        killTimer(self.m_uSwitchTimer);
    end

    self.m_iStartTick       = getTickCount()

    local radioID       = self.m_iCurChannel;
    local sRadioURL
    local sRadioName    = "Radio Aus"

    if(radioID ~= 0) then
        sRadioURL       = self.m_tblRadios[radioID][2]
        sRadioName      = self.m_tblRadios[radioID][1]
    else
        sRadioURL       = 0
    end

    self.m_sCurRadioName = sRadioName;

    self.m_uSwitchTimer     = setTimer(self.m_funcFinalRadioSwitch, 1000, 1, sRadioURL, sRadioName)
end

-- ///////////////////////////////
-- ///// switchDown 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:switchDown()
    if(self.m_bEnabled) and not(clientBusy) then
        if(self.m_iCurChannel == 0) then
            self.m_iCurChannel = #self.m_tblRadios
        else
            self.m_iCurChannel = self.m_iCurChannel-1;
        end

        self:setRadioSwitchTimer()
    end
end

-- ///////////////////////////////
-- ///// switchUp    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:switchUp()
    if(self.m_bEnabled) and not(clientBusy) then
        if(self.m_iCurChannel == #self.m_tblRadios) then
            self.m_iCurChannel = 0
        else
            self.m_iCurChannel = self.m_iCurChannel+1;
        end

        self:setRadioSwitchTimer()
    end
end

-- ///////////////////////////////
-- ///// onFinalRadioSwitch	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:onFinalRadioSwitch(sRadioURL, sRadioName)
    if(localPlayer:getOccupiedVehicle()) then
        if(localPlayer:getOccupiedVehicle():getOccupant() == localPlayer) then
            localPlayer:getOccupiedVehicle():setData("radio:URL", sRadioURL)
            localPlayer:getOccupiedVehicle():setData("radio:NAME", sRadioName)
        end
    end
end

-- ///////////////////////////////
-- ///// onElementDataChange//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:onElementDataChange(uElement, sData, sOldValue)
    if(uElement) and (getElementType(uElement) == "vehicle") and (isElementStreamedIn(uElement)) then
        if(sData == "radio:URL") or (sData == "radio:NAME") then
            if(localPlayer:getOccupiedVehicle() == uElement) then
                local sURL      = uElement:getData("radio:URL")
                local sName     = uElement:getData("radio:NAME")
                self.m_sCurRadioURL = sURL;

                if(self.m_bEnabled) and (self.m_sCurRadioURL) then
                    self.m_sCurRadioName = sName;
                end

                self:startRadio()
            end
        end
    end
end

-- ///////////////////////////////
-- ///// startRadio  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:startRadio()
    if(self.m_bEnabled) then
        if(self.m_sCurRadioURL) then
            if(isElement(self.m_uSound)) then
                destroyElement(self.m_uSound);
            end

            if(tonumber(self.m_sCurRadioURL) ~= 0) then
                self.m_uSound   = playSound(self.m_sCurRadioURL, true);

                addEventHandler("onClientSoundChangedMeta", self.m_uSound, function(sTitle)
                    showInfoBox("radio", sTitle, 5000, "none")
                end)

                addEventHandler("onClientSoundStream", self.m_uSound ,function(suc,length,streamN)
                    if not (suc) then
                        showInfoBox("error", "Radio Stream URL nicht gueltig! "..(streamN or "-"))
                    end
                end)
            end

            self.m_iStartTick = getTickCount()
        end
    end
end

-- ///////////////////////////////
-- ///// stopRadio  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:stopRadio()
    if(isElement(self.m_uSound)) then
        destroyElement(self.m_uSound);
    end
end

-- ///////////////////////////////
-- ///// render 	       	//////
-- ///// Returns: void 		//////
-- ///////////////////////////////

function cRadioManager:render()
    if(getTickCount()-self.m_iStartTick < 3000) then

        local sx, sy = guiGetScreenSize()

        local radioName = self.m_sCurRadioName;
        if not(radioName) then
            radioName = "Unbekannt"
        end

        local color     = tocolor(55, 200, 55, 255)

        if(radioName == "Radio Aus") or (radioName == "Unbekannt") then
            color       = tocolor(200, 55, 55, 255)
        end

        dxDrawText(radioName, 0, 0, sx, sy, color, 1, fontManager.m_FONT_DSDIGI, "center", "top")

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadioManager:constructor(...)
    -- Klassenvariablen --
    self.m_iCurrentRadioIndex           = 1;
    self.m_bEnabled                     = false;

    self.m_iCurChannel                  = 0;
    self.m_sCurRadioURL                 = false;

    self.m_uSound                       = false;

    self.m_iStartTick                   = getTickCount()

    -- Funktionen --
    self.m_funcOnVehicleEnter           = function(...) self:onVehicleEnter(...) end
    self.m_funcOnVehicleExit            = function(...) self:onVehicleExit(...) end

    self.m_funcSwitchDown               = function(...) self:switchDown(...) end
    self.m_funcSwitchUp                 = function(...) self:switchUp(...) end

    self.m_funcFinalRadioSwitch         = function(...) self:onFinalRadioSwitch(...) end
    self.m_funcCheckElementChange       = function(...) self:onElementDataChange(source, ...) end

    self.m_funcOnRender                 = function(...) self:render(...) end

    -- Events --
    self:generateCommands();
    self:reloadRadios();


    addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), self.m_funcOnVehicleEnter)
    addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), self.m_funcOnVehicleExit)
    addEventHandler("onClientVehicleStartExit", getRootElement(), function(uPlayer, ...)
        if(uPlayer == localPlayer) then
            self:onVehicleExit(source, ...)
        end
    end)
    addEventHandler("onClientPlayerWasted", getLocalPlayer(), self.m_funcOnVehicleExit)

    setRadioChannel(0);
    addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), function()
        cancelEvent()
    end)

    addEventHandler("onClientElementDataChange", getRootElement(), self.m_funcCheckElementChange)

end

-- EVENT HANDLER --
