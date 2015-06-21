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
-- ## Name: cTempomatManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cTempomatManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cTempomatManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// checkLimit 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:checkLimit()
    if(self.m_bEnabled) then
        if(isPedInVehicle(localPlayer)) then
            local uVehicle  = localPlayer:getOccupiedVehicle()
            if(uVehicle:getOccupant() == localPlayer) then
                if(self.m_iLimit ~= 0) then
                    if(uVehicle:isOnGround()) then
                        local speed = getElementRealSpeed(uVehicle, "kmh")
                --        outputChatBox(speed)
                        if(speed > self.m_iLimit) then
                            setElementRealSpeed(uVehicle, "kmh", self.m_iLimit);
                        end

                        if(self.m_bSpeedo == true) then
                            if(getControlState("accelerate") ~= true) then
                                setControlState("accelerate", true)
                            end
                        end
                    end
                end
            else
                self:disable()
            end
        else
            self:disable()
        end
    else
        self:disable()
    end
end

-- ///////////////////////////////
-- ///// enable      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:enable(iSpeed)
    if not(self.m_bEnabled) then
        self.m_bEnabled = true
        self.m_iLimit   = tonumber(iSpeed)
        addEventHandler("onClientPreRender", getRootElement(), self.m_funcOnRender)
    end
end

-- ///////////////////////////////
-- ///// disable      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:disable()
    if(self.m_bEnabled) then
        self.m_bEnabled = false
        self.m_bSpeedo  = false;
        self.m_iLimit   = 0;
        removeEventHandler("onClientPreRender", getRootElement(), self.m_funcOnRender)
    end
end

-- ///////////////////////////////
-- ///// toggle      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:toggle(cmd, iSpeed)
    if(tonumber(iSpeed)) and (tonumber(iSpeed) > 0) then
        if(self:canToggle(tonumber(iSpeed))) then
            if(self.m_bEnabled) then
                self:disable()
            end
            self.m_bSpeedo  = true;
            self.m_iLimit   = tonumber(iSpeed);
            self:enable(self.m_iLimit);
            showInfoBox("sucess", "Tempo wurde auf "..iSpeed.." KM/h gesetzt!");
        else
            showInfoBox("error", "Du faehrst zu schnell / bist in keinem Auto!");
        end
    else
        if(self.m_bEnabled) then
            self:disable()
            showInfoBox("info", "Tempomat deaktiviert!");
        else
            showInfoBox("info", "Benutze: /tempo <Limit in KM/h>");
        end
    end
end

-- ///////////////////////////////
-- ///// canToggle      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:canToggle(iTempo)
    if(localPlayer:getOccupiedVehicle()) and (getElementRealSpeed(localPlayer.vehicle, "kmh") <= iTempo) then
        return true;
    end
    return false;
end

-- ///////////////////////////////
-- ///// toggle      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:toggleLimit(cmd, iSpeed)
    if(tonumber(iSpeed)) then
        if(self:canToggle(tonumber(iSpeed))) then
            if(self.m_bEnabled) then
                self:disable()
            end
            self:enable(self.m_iLimit);
            self.m_bSpeedo      = false;
            self.m_iLimit       = tonumber(iSpeed)
            showInfoBox("sucess", "Limit wurde auf "..iSpeed.." KM/h gesetzt!");
        else
            showInfoBox("error", "Du faehrst du schnell / bist in keinem Auto!");
        end
    else
        showInfoBox("info", "Benutze: /limit <Limit in KM/h>");
    end
end

-- ///////////////////////////////
-- ///onSpeedoDisableCheck	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:onSpeedoDisableCheck(key)
    if(self.m_bSpeedo) then
        if(self.m_bEnabled) then
            self:disable()
            setControlState("accelerate", false)
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:constructor(...)
    -- Klassenvariablen --
    self.m_iLimit       = 0;
    self.m_bEnabled     = false;
    self.m_bSpeedo      = false;

    -- Funktionen --
    self.m_funcOnRender     = function(...) self:checkLimit(...) end
    self.m_funcToggle       = function(...) self:toggle(...) end
    self.m_funcToggleLimit  = function(...) self:toggleLimit(...) end
    self.m_funcDisableSpeedo= function(...) self:onSpeedoDisableCheck(...) end
    -- Events --
    addCommandHandler("tempo", self.m_funcToggle)
    addCommandHandler("limit", self.m_funcToggleLimit)

    bindKey("accelerate", "down", self.m_funcDisableSpeedo)
    bindKey("brake_reverse", "down", self.m_funcDisableSpeedo)
    bindKey("handbrake", "down", self.m_funcDisableSpeedo)

end

-- EVENT HANDLER --
