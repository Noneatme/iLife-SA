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
-- Date: 07.02.2015
-- Time: 21:11
-- To change this template use File | Settings | File Templates.
--

cGamemode = {};

local lobby_id = 1;

--[[

]]

-- ///////////////////////////////
-- ///generateSpawnpointVehicle//
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:generateSpawnpointVehicle(uPlayer, bStart)
    local index         = self.m_uMap:getFreeSpawnpoint();
    local spawnpoint    = self.m_uMap:getSpawnpoints()[index];

    local x, y, z, rx, ry, rz = unpack(spawnpoint);

    local id = self.m_uMap.m_iStandartVehicle
    if(getVehicleModelFromName(self.m_sVehicle)) then
        id = getVehicleModelFromName(self.m_sVehicle);
    else
        if(self.m_sVehicle == "Zufall") then
            id = getRandomVehicleModel("automobile");
        end
    end
    local vehicle       = createVehicle(id, x, y, z, rx, ry, rz);
    setVehicleHandling(vehicle, "collisionDamageMultiplier", 1)
 --   setElementFrozen(vehicle, true);

    addEventHandler("onVehicleStartEnter", vehicle, function() cancelEvent() end)
    addEventHandler("onVehicleStartExit", vehicle, function() cancelEvent() end)
    addEventHandler("onVehicleExplode", vehicle, function()

    end);

    self.m_uMap:setElementInMap(vehicle);
    self:addElement(vehicle);
    self.m_uMap:setSpawnpointUsed(index, uPlayer);

    setElementFrozen(vehicle, true)
    if not(bStart) then
        setTimer(setElementFrozen, 1500, 1, vehicle, false);
        setVehicleDamageProof(vehicle, true)
    end
    return vehicle;
end

-- ///////////////////////////////
-- ///// spawnPlayerVehicle	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:spawnPlayerVehicle(uPlayer, bStart)
    local vehicle = self:generateSpawnpointVehicle(uPlayer, bStart);
    self.m_uMap:setElementInMap(uPlayer);
    self:addPlayerElement(vehicle, uPlayer)

    self:addElement(vehicle)

    local x, y, z = getElementPosition(vehicle)
    setElementPosition(uPlayer, x, y, z)
    warpPedIntoVehicle(uPlayer, vehicle);
    vehicle:setEngineState(true);
end

-- ///////////////////////////////
-- ///// enterPlayer 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:enterPlayer(uPlayer, iZuschauer)
    takeAllWeapons(uPlayer)
    if(iZuschauer == 1) then
        uPlayer:setData("inlobby", true)
        uPlayer:setData("zuschauer", true)
        self:addElement(uPlayer)

        local x, y, z = unpack(self.m_uMap.m_tblGuestPosition)
        setElementPosition(uPlayer, x, y, z)
        self.m_uMap:setElementInMap(uPlayer);

        self:sendLobbyMessage(getPlayerName(uPlayer).." hat die Lobby betreten. [Zuschauer]", self.COLOR_ORANGE);
    else
        if(self.m_uMap.m_sSpawnType == "vehicle") then
            self:spawnPlayerVehicle(uPlayer)
        end

        uPlayer:setData("inlobby", true)
        self:addElement(uPlayer)
        self.m_iCurPlayers  = self.m_iCurPlayers+1;
        self:sendLobbyMessage(getPlayerName(uPlayer).." hat die Lobby betreten. "..self:getAvailablePlayersString(), self.COLOR_ORANGE);


        if(self.m_sStatus == "Inaktiv") then
            self:prepare();
        end
    end

    if(self.enterCustom) then
        self:enterCustom(uPlayer, iZuschauer)
    end
    addEventHandler("onPlayerQuit", uPlayer, self.m_funcPlayerQuit);
    addEventHandler("onPlayerWasted", uPlayer, self.m_funcPlayerWasted);

    triggerClientEvent(uPlayer, "onClientGamemodeEnter", uPlayer, self)

    if(self:isVorbereitung()) then
        uPlayer:showInfoBox("info", "Dieses Match hat noch nicht begonnen.");
    end
end

-- ///////////////////////////////
-- ///// exitPlayer 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:exitPlayer(uPlayer, type)
    local typestring = ""
    if(type) then typestring = "["..type.."]"; end

    local zuschauer = false;
    if(uPlayer:getData("zuschauer")) then
        self:sendLobbyMessage(getPlayerName(uPlayer).." hat die Lobby verlassen. [Zuschauer]", self.COLOR_ORANGE);
        zuschauer = true;
    else
        self.m_iCurPlayers  = self.m_iCurPlayers-1;
        self.m_uMap:setSpawnpointFree(self.m_uMap:getPlayerSpawnpoint(uPlayer), uPlayer);
        self:sendLobbyMessage(getPlayerName(uPlayer).." hat die Lobby verlassen. "..typestring.." "..self:getAvailablePlayersString(), self.COLOR_ORANGE);

    end
    if(self.exitCustom) then
        self:exitCustom(uPlayer, type)
    end

    self:clearPlayerElements(uPlayer)
    self:removeElement(uPlayer)

    uPlayer:setData("inlobby", false)
    uPlayer:setData("zuschauer", false)

    removeEventHandler("onPlayerQuit", uPlayer, self.m_funcPlayerQuit);
    removeEventHandler("onPlayerWasted", uPlayer, self.m_funcPlayerWasted);

    triggerClientEvent(uPlayer, "onClientGamemodeExit", uPlayer)

    gamemodeManager:exitPlayer(uPlayer)

    if not(zuschauer) then
        self:checkAliveElements()
    end
end

-- ///////////////////////////////
-- ///// checkAliveElements	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:checkAliveElements()
    if(self:getPlayingPlayers() == 1) then
        if(self:getStatusID() ~= 2) then
            self:finish(self:getLastPlayerElement());
        end
    else
        if(self:getPlayingPlayers() < 1) then
            if(self:getStatusID() ~= 2) then
                self:finish();
            end
        end
    end
end

-- ///////////////////////////////
-- ///// start 		        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:start()
    self.m_sStatus = "Laufend"
    self:sendLobbyMessage("Spiel startet!", self.COLOR_GREEN);
    self:resetAllPlayers()

    for index, car in pairs(self:getElements("vehicle")) do
        setElementFrozen(car, true)
    end

    setTimer(function() self:doCountDown(3) end, 1000, 1)
    setTimer(function() self:doCountDown(2) end, 2000, 1)
    setTimer(function() self:doCountDown(1) end, 3000, 1)
    setTimer(function() self:doCountDown(0) end, 4000, 1)
end

-- ///////////////////////////////
-- ///// doCountDown        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:doCountDown(iCount)
    self:triggerLobbyEvent("onGamemodeCountdownCount", iCount)

    if(iCount == 0) then
        for index, car in pairs(self:getElements("vehicle")) do
            setElementFrozen(car, false)
        end

        if(self.onStart) then
            self:onStart()
        end
    end
end

-- ///////////////////////////////
-- ///// prepare 		    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:prepare()
    self.m_sStatus = "Vorbereitung"

    self:sendLobbyMessage("Vorbereitung gestartet! Zeit: "..math.floor(self.m_iPreparationTime/1000).." Sekunden", self.COLOR_GREEN);

    self.m_tblTimer["start_timer"]  = setTimer(self.m_funcStartGamemode, self.m_iPreparationTime, 1)
end

-- ///////////////////////////////
-- ///// finish 		    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:finish(uGewinner)
    self.m_sStatus = "Beendet"

    if(uGewinner) then
        self:sendLobbyMessage("Spiel wurde beendet! Gewinner: "..getPlayerName(uGewinner)..", Preisgeld: $"..self.m_iCurrentPricePool, self.COLOR_GREEN);
        uGewinner:addMoney(self.m_iCurrentPricePool);
        uGewinner:showInfoBox("sucess", "Du hast $"..self.m_iCurrentPricePool.." erhalten!");
    else
        self:sendLobbyMessage("Spiel wurde beendet! Gewinner: Niemand", self.COLOR_GREEN);
    end
    self.m_iCurrentPricePool = 0;
    self:destroyAllTimers();
    self.m_tblTimer["destructor_timer"] = setTimer(self.m_funcStopGamemode, self.m_iDestructorTime, 1);

    self:sendLobbySound("lobby_finish.ogg")
end

-- ///////////////////////////////
-- ///// onFinish 		    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:onFinish()
    for index, player in pairs(self:getPlayerElements()) do
        self:exitPlayer(player, "Lobby beendet");
    end

    if(self.m_bPersistentLobby) then
        self:reset();

        for index, player in pairs(self:getElements("player")) do
            self:exitPlayer(player)
        end
    else
        self:destructor();
    end
end

-- ///////////////////////////////
-- ///// sendLobbyMessage 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:sendLobbyMessage(sString, sString2)
    if not(sString2) or (type(sString2) == "table") then   -- Chatbox
        for index, player in pairs(self:getElements("player")) do
            outputChatBox("[ARENA] "..sString, player, unpack((sString2)));
        end
    else
        for index, player in pairs(self:getElements("player")) do
            player:showInfoBox(sString, sString2)
        end
    end
end

-- ///////////////////////////////
-- ///// sendLobbySound 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:sendLobbySound(sSound)
    for index, player in pairs(self:getElements("player")) do
        triggerClientEvent(player, "onGamemodeLobbySoundPlay", player, sSound)
    end
end

-- ///////////////////////////////
-- ///// triggerLobbyEvent 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:triggerLobbyEvent(sEvent, ...)
    for index, player in pairs(self:getElements("player")) do
        triggerClientEvent(player, sEvent, player, ...)
    end
end


-- ///////////////////////////////
-- ///// addElement 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:addElement(uElement)
    if(isElement(uElement)) then
        local type = getElementType(uElement)
        if not(self.m_tblMapElements[type]) then
            self.m_tblMapElements[type] = {}
        end

        self.m_tblMapElements[type][uElement] = uElement;
    end
end

-- ///////////////////////////////
-- ///// removeElement 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:removeElement(uElement)
    if(isElement(uElement)) then
        local type = getElementType(uElement)
        if not(self.m_tblMapElements[type]) then
            self.m_tblMapElements[type] = {}
        end

        self.m_tblMapElements[type][uElement] = nil;
    end
end

-- ///////////////////////////////
-- ///// getElements 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getElements(type)
    if(type) and (self.m_tblMapElements[type]) then
        return self.m_tblMapElements[type];
    end
    return self.m_tblMapElements;
end

-- ///////////////////////////////
-- ///// getElementCount	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getElementCount(type)
    if(type) and (self.m_tblMapElements[type]) then
        local i = 0;
        for index, ele in pairs(self:getElements(type)) do
            i = i+1
        end
        return i;
    end
    return 0;
end

-- ///////////////////////////////
-- ///// addPlayerElement 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:addPlayerElement(uElement, uPlayer)
    if not(self.m_tblPlayerElements[uPlayer]) then
        self.m_tblPlayerElements[uPlayer] = {}
    end
    self.m_tblPlayerElements[uPlayer][uElement] = uElement;
end

-- ///////////////////////////////
-- ///// getPlayerElements 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getPlayerElements(uPlayer)
    if not(self.m_tblPlayerElements[uPlayer]) then
        return {}
    end
    return self.m_tblPlayerElements[uPlayer];
end

-- ///////////////////////////////
-- ///// getPlayingPlayers 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getPlayingPlayers()
    local elements      = self:getElements("player")
    local count         = 0;
    for index, ele in pairs(elements) do
        if not(ele:getData("zuschauer")) then
            count = count+1
        end
    end
    return count;
end

-- ///////////////////////////////
-- ///// isPlayerInGamemode 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:isPlayerInGamemode(uPlayer)
    if(self.m_tblPlayerElements[uPlayer]) then  -- Bla bla
        return true
    else
        return false
    end
end

-- ///////////////////////////////
-- ///// getPlayingPlayersAsTable
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getPlayingPlayersAsTable()
    local elements      = self:getElements("player")
    local count         = {}
    for index, ele in pairs(elements) do
        if not(ele:getData("zuschauer")) then
            count[ele] = ele;
        end
    end
    return count;
end

-- ///////////////////////////////
-- /////getLastPlayerElement//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getLastPlayerElement()
    local elements = self:getElements("player")
    for index, player in pairs(elements) do
        if not(player:getData("zuschauer")) then
            return player;
        end
    end
end

-- ///////////////////////////////
-- ///// clearPlayerElements//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:clearPlayerElements(uPlayer)
    for index, element in pairs(self:getPlayerElements(uPlayer)) do
        if(isElement(element)) then
            self:removeElement(element)
            destroyElement(element);
        end
    end
end

-- ///////////////////////////////
-- ///// getMap      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getMap()
    return self.m_uMap;
end

-- ///////////////////////////////
-- ///// getMapID      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getMapID()
    return self.m_uMap:getID();
end

-- ///////////////////////////////
-- ///// getMapName      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getMapName()
    return self.m_uMap:getName();
end

-- ///////////////////////////////
-- ///// getStatusID      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getStatusID()
    if(self:isVorbereitung()) then
        return 0;                   -- Vorbereitung
    end
    if(self.m_sStatus == "Laufend") then
        return 1;                   -- Laufend
    end
    if(self.m_sStatus == "Beendet") then
        return 2;                   -- Beendet
    end
    return -1
end
-- ///////////////////////////////
-- /getAvailablePlayerString /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:getAvailablePlayersString()
    return "["..self.m_iCurPlayers.." / "..self.m_iMaxPlayers.."]"
end

-- ///////////////////////////////
-- ///// updatePlayers      //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:updatePlayers()
    local iPlayers = 0;
    for index, player in pairs(self.m_tblMapElements["player"]) do
        if(player) and (isElement(player)) then
            iPlayers = iPlayers+1;
        end
    end
    self.m_iCurPlayers  = iPlayers;
    return iPlayers;
end

-- ///////////////////////////////
-- ///// resetAllPlayers    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:resetAllPlayers()
    for index, uPlayer in pairs(self:getPlayingPlayersAsTable()) do

        self.m_uMap:setSpawnpointFree(self.m_uMap:getPlayerSpawnpoint(uPlayer), uPlayer);
        self:clearPlayerElements(uPlayer)
        self:spawnPlayerVehicle(uPlayer, true)
    end
end

-- ///////////////////////////////
-- ///// isVorbereitung      //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:isVorbereitung()
    if(self.m_sStatus == "Inaktiv") or (self.m_sStatus == "Vorbereitung") then
        return true;
    end
    return false;
end

-- ///////////////////////////////
-- ///// destroyAllTimers	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:destroyAllTimers()
    for index, timer in pairs(self.m_tblTimer) do
        if(isTimer(timer)) then
            killTimer(timer)
        end
    end
    return true;
end

-- ///////////////////////////////
-- ///// addPricepoolMoney	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:addPricepoolMoney(uPlayer)
    uPlayer:addMoney(-self.m_iCost)
    self.m_iCurrentPricePool        = self.m_iCurrentPricePool+self.m_iCost;

    return true;
end

-- ///////////////////////////////
-- ///// reset      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:reset()
    for index, tbl in pairs(self:getElements()) do
        if(index == "player") then
            for _, player in pairs(tbl) do
                self:clearPlayerElements(player)
            end
        else
            for _, ob in pairs(tbl) do
                self:removeElement(ob)
                destroyElement(ob);
            end
        end
    end

    self:destroyAllTimers();

    self.m_sStatus      = "Inaktiv"
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:constructor(iGamemodeType, uMap, sName, iMaxPlayers, iMinutes, iCost, sVehicle, iPreparationTime, bAllowWatchers, bPersistent)

    -- Klassenvariablen --
    self.m_iID              = lobby_id;
    self.m_iType            = iGamemodeType;
    self.m_uMap             = uMap;
    self.m_sName            = sName;
    self.m_iMaxPlayers      = iMaxPlayers;
    self.m_iMinutes         = iMinutes;
    self.m_iPreparationTime = (iPreparationTime or 60000)
    self.m_iDestructorTime  = 15000;

    if(bAllowWatchers == nil) then
        bAllowWatchers = true;
    end

    self.m_bZuschauerAllowed = bAllowWatchers;


    self.m_iCost            = iCost;
    self.m_sVehicle         = sVehicle;
    self.m_sStatus          = "Inaktiv"

    self.m_iCurrentPricePool    = 0;

    self.m_iCurPlayers          = 0;
    self.m_tblMapElements       =
    {
        ["player"]  = {},
        ["vehicle"] = {},
        ["object"]  = {},
    }

    self.m_iUsedSpawnPositions  = {}
    self.m_tblPlayerElements    = {}
    self.m_tblTimer             = {}

    if(bPersistent == nil) then
        bPersistent = false;
    end

    self.m_bPersistentLobby     = bPersistent;


    self.m_iMap                 = self:getMapID();

    self.COLOR_ORANGE           = {255, 179, 0 }
    self.COLOR_GREEN            = {0, 255, 0}

    -- Funktionen --
    self.m_funcPlayerExit       = function(...) self:exitPlayer(...) end

    if(self.m_uMap:getMaxPlayers() < self.m_iMaxPlayers) then
        self.m_iMaxPlayers = self.m_uMap:getMaxPlayers();
    end

    self.m_funcPlayerQuit       = function(type) self:exitPlayer(source, type) end
    self.m_funcPlayerWasted     = function(...) self:exitPlayer(source) source:setData("inlobby", true) end
    self.m_funcStartGamemode    = function(...) self:start(...) end
    self.m_funcStopGamemode     = function(...) self:onFinish(...) end

    -- Events --

    lobby_id = lobby_id+1;

    self:updatePlayers();
end

-- ///////////////////////////////
-- ///// destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode:destructor()
    self:destroyAllTimers();

    for index, tbl in pairs(self:getElements()) do
        if(index == "player") then
            for _, player in pairs(tbl) do
                self:clearPlayerElements(player)
                self:exitPlayer(player)
            end
        else
            for _, ob in pairs(tbl) do
                self:removeElement(ob)
                destroyElement(ob);
            end
        end
    end

    gamemodeManager:onLobbyDestroy(self)


    self = nil;
end
-- EVENT HANDLER --
