--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: CO_Radarfalle.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CO_Radarfalle = {};
CO_Radarfalle.__index = CO_Radarfalle;

Radarfallen     = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Radarfalle:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// CheckRadar 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radarfalle:checkRadar(uElement, dim)
    if(dim) then
        if(getElementType(uElement) == "vehicle") and (uElement:getOccupant()) then
            local uPlayer = uElement:getOccupant();

            if(tonumber(uPlayer:getFaction():getType()) ~= 1) then
                local speed = self:getSpeed(uElement)*0.75;

                if(speed-11 > self.m_iAllowedSpeed) then
                    local ueberschreitung       = (speed-11)-self.m_iAllowedSpeed;
                    local iGeld                 = math.floor(ueberschreitung*11);

                    if(uPlayer:getBankMoney() >= iGeld) then
                        uPlayer:setBankMoney(uPlayer:getBankMoney()-iGeld);
                        Factions[1]:addDepotMoney(iGeld);
                    else
                        uPlayer:setWanteds(uPlayer:getWanteds()+1);
                        uPlayer:showInfoBox("info", "Du hast ein Wanted bekommen, weil du dein Bussgeld($"..iGeld..") nicht bezahlen konntest!");
                    end

                    triggerClientEvent("onRadarfalleGeblitzt", uPlayer, self.uObject, speed, self.m_iAllowedSpeed, ueberschreitung, iGeld)
                    logger:OutputPlayerLog(uPlayer, "Wurde geblitzt", "KMH: "..speed..", Erlaubt: "..self.m_iAllowedSpeed, "$"..iGeld);
                    uPlayer:incrementStatistics("Fahrzeug", "Geblitzt", 1)
                    uPlayer:incrementStatistics("Fahrzeug", "Blitzerstrafe", iGeld)
                    Achievements[131]:playerAchieved(uPlayer)

                    if(tonumber(uPlayer:getStatistics("Fahrzeug", "Geblitzt")) >= 100) then
                        Achievements[132]:playerAchieved(uPlayer)
                    end

                    if(speed > 180) then
                        Achievements[133]:playerAchieved(uPlayer)
                    end
                end
            end
        end
    end
end

-- ///////////////////////////////
-- ///// GetSpeed   		//////
-- ///// Returns:  void		//////
-- ///////////////////////////////

function CO_Radarfalle:getSpeed(...)
    return getElementRealSpeed(...)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radarfalle:constructor(uObject, iSpeed)
    -- Klassenvariablen --

    self.uObject            = uObject;
    self.m_iAllowedSpeed    = (iSpeed or math.huge);

    local x, y, z       = getElementPosition(uObject);
    self.m_Col          = createColSphere(x, y, z, 10);

    attachElements(self.m_Col, self.uObject, 0, 10, 0, 0, 0, 0);

    setElementData(self.uObject, "blitzer:blitzer", true);
    setElementData(self.uObject, "blitzer:col", self.m_Col);

    -- Methoden --
    self.m_checkRadarFunc       = function(...) self:checkRadar(...) end

    -- Events --

    addEventHandler("onColShapeHit",self.m_Col, self.m_checkRadarFunc)

    Radarfallen[uObject] = self;
    --logger:OutputInfo("[CALLING] CO_Radarfalle: Constructor");
end

-- ///////////////////////////////
-- ///// destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Radarfalle:destructor()
    Radarfallen[self.uObject] = nil;
    destroyElement(self.m_Col);
    self                = nil;
end
-- EVENT HANDLER --

addEvent("onRadarfalleBearbeite", true)
addEvent("onBlitzerfotoSend", true);

addEventHandler("onRadarfalleBearbeite", getRootElement(), function(uElement, iSpeed)
    local playerName        = client:getName();

    if(tonumber(client:getFaction():getType()) == 1) then

        Radarfallen[uElement].m_iAllowedSpeed = iSpeed;
        Radarfallen[uElement].uObject:SetWAData("maxKMH", iSpeed)
        Radarfallen[uElement].uObject:SetWAData("lastEdited", playerName)
        client:showInfoBox("info", "Geschwindigkeit erfolgreich gesetzt!");
    end
end)

addEventHandler("onBlitzerfotoSend", getRootElement(), function(uFoto)
    local function getDate()
        local time = getRealTime()
        local day = time.monthday
        local month = time.month+1
        local year = time.year+1900
        local hour = time.hour
        local minute = time.minute
        local second = time.second;

        if(hour < 10) then
            hour = "0"..hour;
        end

        if(minute < 10) then
            minute = "0"..minute;
        end

        if(second < 10) then
            second = "0"..second;
        end
        return day.."-"..month.."-"..year.."_"..hour.."-"..minute.."-"..second;
    end

    local sString   = getPlayerName(client).."_"..getDate();

    local file		= fileCreate("blitzerfotos/"..sString..".jpg");

    if(file) then
        fileWrite(file, uFoto);
        fileFlush(file);
        fileClose(file);

        outputDebugString("Recieved Blitzerfoto from "..getPlayerName(client)..", "..sString);
    end
end)
