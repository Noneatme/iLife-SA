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
-- Time: 21:10
-- To change this template use File | Settings | File Templates.
--

cGamemodeManager = {};

--[[

    ]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
 -- ///////////////////////////////

function cGamemodeManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// getLobbys   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:getLobbys(iType)
    if not(iType) then
        return self.m_tblCurrentLobbys;
    else
        return (self.m_tblCurrentLobbys[iType] or {});
    end
end

-- ///////////////////////////////
-- ///// getLobbyByID   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:getLobbyByID(iID)
    return self.m_tblCurrentLobbyByID[iID];
end

-- ///////////////////////////////
-- ///// onPlayerLobbyCrate //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:onPlayerLobbyCreate(uPlayer, iGamemode, iMap, sLobbyName, iMaxPlayers, iMaxZeit, iEintritt, sFahrzeug, ...)
    iGamemode       = tonumber(iGamemode)
    iMap            = tonumber(iMap);
    iMaxPlayers     = (tonumber(iMaxPlayers) or 20);
    iMaxZeit        = (tonumber(iMaxZeit) or 100)
    iEintritt       = (tonumber(iEintritt) or 0);

    uPlayer:setLoading(false)

    if(_Gsettings.gameModeMaps[iGamemode]) and (iMap) then
        if(iEintritt >= 0) then
            local sucess = self:addLobby(iGamemode, iMap, sLobbyName, iMaxPlayers, iMaxZeit, iEintritt, sFahrzeug, ...)
            if(sucess) then
                uPlayer:showInfoBox("sucess", "Lobby erfolgreich erstellt!");
            else
                uPlayer:showInfoBox("error", "Fehler beim erstellen der Lobby!");
            end
        else
            uPlayer:showInfoBox("error", "Ungueltiger Eintritt!")
        end
    else
        uPlayer:showInfoBox("error", "Diese Map existiert nicht!")
    end
end


-- ///////////////////////////////
-- ///// addLobby   		//////
-- ///// Returns: void		//////
--///////////////////////////////

function cGamemodeManager:addLobby(iType, iMap, ...)
    if not(self.m_tblCurrentLobbys[iType]) then
        self.m_tblCurrentLobbys[iType] = {}
    end
--  outputChatBox(tostring(iMap))

    local lobby;
    local map;

    map = self.m_mapClasses[iMap]:new();

    if(iType == 1) then         -- DERBY
        lobby = cGamemode_Derby:new(map, ...)
    elseif(iType == 2) then     -- RACE
        lobby = cGamemode_Race:new(map, ...)
    elseif(iType == 3) then     -- DEATHMATCH
        lobby = cGamemode_Deathmatch:new(map, ...)
    elseif(iType == 4) then     -- CTF
        lobby = cGamemode_CTF:new(map, ...)
    end
--  local lobby             = cGamemode:new(iType, ...)

    self.m_tblCurrentLobbys[iType][lobby]   = lobby;
    self.m_tblCurrentLobbyByID[lobby.m_iID] = lobby;

    outputDebugString("Added new Lobby ["..iType.."]: "..tostring(lobby)..", ID: "..lobby.m_iID)
    return true;
end

-- ///////////////////////////////
-- ///// refreshLobbys     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:refreshLobbys(iID)
    local lobbys = self:getLobbys(iID)

    for index, value in pairs(lobbys) do
        if not(value) then
            self.m_tblCurrentLobbys[iID]    = table.removeindex(self.m_tblCurrentLobbys[iID], index);
        end
    end
end

-- ///////////////////////////////
-- ///// onPlayerRquestLobbys 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:onPlayerRqeustLobbys(uPlayer, iID)
    if(iID) then
        self:refreshLobbys(iID)
        local lobbys = self:getLobbys(iID)
        triggerClientEvent(uPlayer, "onClientPlayerReceiveGamemodeLobbys", uPlayer, lobbys)
    end
end

function cGamemodeManager:onPlayerLobbyBeitrete(uPlayer, iLobby, iZuschauer)
    uPlayer:setLoading(false)
    iZuschauer = tonumber(iZuschauer)
    if(iLobby) then
        if(uPlayer:getData("inlobby") ~= true) then
            local lobby = self:getLobbyByID(iLobby)
            if(lobby) then
                if(lobby:getStatusID() ~= 2) then
                    if((lobby.m_iCurPlayers < lobby.m_iMaxPlayers) or iZuschauer == 1) then
                        if not(lobby.m_bAllowOnPreparation) or ((lobby.m_bAllowOnPreparation) and ((lobby.m_sStatus == "Inaktiv") or (lobby.m_sStatus == "Vorbereitung"))) or (iZuschauer == 1) then

                            local enter = false;
                            if(iZuschauer == 1) then
                                if(lobby.m_bZuschauerAllowed) then
                                    enter = true;
                                else
                                    enter = false;
                                    uPlayer:showInfoBox("error", "Diese Lobby kann nicht als Zuschauer betreten werden!")
                                end
                            else
                                enter = true;
                            end

                            if not(lobby.m_bPersistentLobby) then
                                if(lobby:getStatusID() ~= 0) and (iZuschauer ~= 1) then
                                    enter = false;
                                    uPlayer:showInfoBox("error", "Diese Lobby kann jetzt nicht mehr betreten werden!")
                                end
                            end
                            if(iZuschauer ~= 1) then
                                if(lobby.m_iCost ~= 0) and (enter) then
                                    if(uPlayer:getMoney() <= lobby.m_iCost) then
                                        enter = false;
                                        uPlayer:showInfoBox("error", "Du benoetigst $"..lobby.m_iCost.." um diese Lobby zu betreten!");
                                    else
                                        lobby:addPricepoolMoney(uPlayer);
                                    end
                                end
                            end
                            if(enter) then
                                lobby:enterPlayer(uPlayer, iZuschauer)
                                self.m_tblPlayerLobby[uPlayer] = lobby;
                            end
                        else
                            uPlayer:showInfoBox("error", "Diese Lobby kann nicht mehr betreten werden!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Diese Lobby ist leider Voll!")
                    end
                else
                    uPlayer:showInfoBox("error", "Diese Lobby ist beendet!")
                end
            else
                uPlayer:showInfoBox("error", "Diese Lobby existiert nicht mehr!")
            end
        else
            uPlayer:showInfoBox("error", "Du bist bereits in einer Lobby!")
        end
    else
        uPlayer:showInfoBox("error", "Unbekannte Lobby!")
    end
end

-- ///////////////////////////////
-- ///// exitPlayer 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:exitPlayer(uPlayer)
    removePedFromVehicle(uPlayer);
    setElementDimension(uPlayer, 2)
    setElementInterior(uPlayer, 0);
    setElementPosition(uPlayer, unpack(_Gsettings.hallOfGamesSpawn))
    setElementFrozen(uPlayer, false)
    setCameraTarget(uPlayer, uPlayer);

    uPlayer:setData("inlobby", false)
end

-- ///////////////////////////////
-- ///// OnPlayerLobbyExit 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:onPlayerLobbyExit(uPlayer)
    if(self.m_tblPlayerLobby[uPlayer]) then
        local lobby = self.m_tblPlayerLobby[uPlayer];
        lobby:exitPlayer(uPlayer);
    end
end

-- ///////////////////////////////
-- ///// onLobbyDestroy		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:onLobbyDestroy(uLobby)
    local id = uLobby.m_iID

   -- refresh lobbys

    outputDebugString("Lobby with ID: "..id.." destroyed.")
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onPlayerGamemodeCreate", true)
    addEvent("onPlayerLobbybrowserGamemodesRequest", true);
    addEvent("onPlayerGamemodeLobbyBeitrete", true);
    addEvent("onPlayerGamemodeLobbyLeave", true);

    self.m_tblCurrentLobbys     = {};
    self.m_tblCurrentLobbyByID  = {}

    self.m_mapClasses       =
    {
        [11] = cGamemodeMap_Derby1,
        [12] = cGamemodeMap_Derby2,
        [13] = cGamemodeMap_Derby3,
    };

    self.m_tblPlayerLobby      = {}

    -- Funktionen --
    self.m_funcCreateLobby      = function(...) self:onPlayerLobbyCreate(client, ...) end
    self.m_funcRequestLobby     = function(...) self:onPlayerRqeustLobbys(client, ...) end
    self.m_funcLobbyBeitrete    = function(...) self:onPlayerLobbyBeitrete(client, ...) end
    self.m_funcLobbyExit        = function(...) self:onPlayerLobbyExit(client, ...) end


    -- Events --
    addEventHandler("onPlayerGamemodeCreate", getRootElement(), self.m_funcCreateLobby)
    addEventHandler("onPlayerLobbybrowserGamemodesRequest", getRootElement(), self.m_funcRequestLobby)
    addEventHandler("onPlayerGamemodeLobbyBeitrete", getRootElement(), self.m_funcLobbyBeitrete);
    addEventHandler("onPlayerGamemodeLobbyLeave", getRootElement(), self.m_funcLobbyExit)
end

-- EVENT HANDLER --
