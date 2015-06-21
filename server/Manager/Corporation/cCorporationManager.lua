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
-- Date: 21.02.2015
-- Time: 17:39
-- To change this template use File | Settings | File Templates.
--

cCorporationManager = inherit(cSingleton)

--[[

]]

-- ///////////////////////////////
-- ///// createCorpFromID	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:createCorpFromRow(row)
    self.m_tblCorporations[tonumber(row['iID'])] = cCorporation:new(row['iID'], row['FullName'], row['ShortName'], row['Color'], row['IconID'], row['FounderName'], row['FoundedDate'], row['Bio'], row['TaxRate'], row['State'], row['MaxMembers'], row['MaxVehicles'], row['MaxHouses'], row['MaxSkins'], row['MaxBizes'], row['Skins'], row['MiscSettings']);

    local corp  = self.m_tblCorporations[tonumber(row['iID'])]

    return self.m_tblCorporations[tonumber(row['iID'])]
end

-- ///////////////////////////////
-- ///// loadCorps   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:loadCorps()
    local result        = CDatabase:getInstance():query("SELECT * FROM corporations;");

    self.m_iAmmount             = 0;
    self.m_iStartTick           = getTickCount();
    self.m_tblCorporations      = {}

    if(result) and (#result > 0) then
        for index, row in pairs(result) do
            local id = tonumber(row['iID'])
            if not(Corporations[id]) then
                self:createCorpFromRow(row);
                self.m_iAmmount = self.m_iAmmount+1;
            end
            coroutine.yield();
        end
    end

    self.m_bEverythingLoaded = true;
    outputDebugString("Found "..self.m_iAmmount.." Corporations in "..math.floor((getTickCount()-self.m_iStartTick)/1000).." s")
end

-- ///////////////////////////////
-- ///// onPlayerRequestCorps/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerRequestCorps(uPlayer, ...)
    local corps = self.m_tblCorporations
    uPlayer:setLoading(false)
    triggerClientEvent(uPlayer, "onClientPlayerCorporationsReceive", uPlayer, corps);
end

-- ///////////////////////////////
-- /onPlayerRequestCorpCreateGUI//
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerRequestCorpCreateGUI(uPlayer, ...)
    uPlayer:setLoading(false)
    if(uPlayer:getBankMoney() >= _Gsettings.corporation.iPriceToCreate) then
        if(uPlayer:getFaction():getID() == 0) then
            if(uPlayer:getCorporation() == 0) then
                triggerClientEvent(uPlayer, "onClientCorporationCreateGUIOpen", uPlayer)
            else
                uPlayer:showInfoBox("error", "Du bist bereits in einer Corporation!");
            end
        else
            uPlayer:showInfoBox("error", "Du bist in einer Fraktion!");
        end
    else
        uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf der Bank! ($".._Gsettings.corporation.iPriceToCreate..")");
    end
end

-- ///////////////////////////////
-- /doesCorpExists          //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:doesCorpExists(sFullName, sShortName)
    local result;
    if(sShortName) then
        result        = CDatabase:getInstance():query("SELECT * FROM corporations WHERE FullName = ? OR ShortName = ?;", sFullName, sShortName)
    else
        result        = CDatabase:getInstance():query("SELECT * FROM corporations WHERE FullName = ?;", sFullName)
    end
    if(result) and (#result > 0) then
        return result[1]['iID'];
    else
        return false;
    end
end

-- ///////////////////////////////
-- /onPlayerCreateCorporation//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerCreateCorporation(uPlayer, sLongName, sShortName, sColor, tblIcon)
    if(uPlayer:getFaction():getID() == 0) then
        if(uPlayer:getCorporation() == 0) then
            if(string.len(sLongName) > 2) and (string.len(sShortName) <= 5) then
                if(sColor) and (tblIcon) then
                    if not(self:doesCorpExists(sLongName, sShortName)) then
                        local result = CDatabase:getInstance():query("INSERT INTO corporations (FullName, ShortName, Color, IconID, FounderName, FoundedDate) VALUES (?, ?, ?, ?, ?, CURDATE());", sLongName, sShortName, sColor, toJSON(tblIcon), uPlayer:getName());
                        if(result) or (true)  then
                            if(uPlayer:getBankMoney() >= _Gsettings.corporation.iPriceToCreate) then
                                local resultSet = CDatabase:getInstance():query("SELECT * FROM corporations WHERE iID = (SELECT LAST_INSERT_ID() FROM corporations LIMIT 1);");
                                if(resultSet) then
                                    uPlayer:addBankMoney(-_Gsettings.corporation.iPriceToCreate)
                                    local corp = self:createCorpFromRow(resultSet[1]);
                                    outputDebugString("Corporation: "..resultSet[1]["iID"].." created! User: "..getPlayerName(uPlayer));
                                    uPlayer:setCorporation(tonumber(resultSet[1]["iID"]));
                                    uPlayer:addCorpRole(0);

                                    corp:refreshMembers()
                                    uPlayer:showInfoBox("sucess", "Corporation gegruendet!")

                                    logger:OutputPlayerLog(uPlayer, "Erstellte Corporation", sLongName);
                                else
                                    uPlayer:showInfoBox("error", "Datensatz konnte nicht gefunden werden!")
                                end
                            else
                                uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf der Bank!")
                            end
                        else
                            uPlayer:showInfoBox("error", "Datensatz konnte nicht gespeichert werden!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Dieser Name / Abkuerung existiert bereits! Bitte waehle einen anderen Namen.")
                    end
                else
                    uPlayer:showInfoBox("error", "Bitte Icon und Farbe auswaehlen!")
                end
            else
                uPlayer:showInfoBox("error", "Falscher Name!")
            end
        else
            uPlayer:showInfoBox("error", "Du bist bereits in einer Corporation!");
        end
    else
        uPlayer:showInfoBox("error", "Du bist in einer Fraktion!");
    end
    uPlayer:setLoading(false)
end

-- ///////////////////////////////
-- /onPlayerRequestViewCorp //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerRequestViewCorp(uPlayer, iID)
    uPlayer:setLoading(false)
    iID = tonumber(iID);

    if(Corporations[iID]) then
        local con, names = Corporations[iID]:getConnections();

        triggerClientEvent(uPlayer, "onClientCorporationViewGUIOpen", uPlayer, Corporations[iID], con, names)
    else
        uPlayer:showInfoBox("error", "Corporation wurde nicht gefunden.")
    end
end

-- ///////////////////////////////
--  onPlayerCorporationLeave//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerCorporationLeave(uPlayer)
    if(uPlayer:getCorporation() ~= 0) then
        local name = uPlayer:getCorporation():getName()

        if(uPlayer:getName() == uPlayer:getCorporation():getCEO()) then
            if(uPlayer:getCorporation():getMemberCount() < 2) then
                self:deleteCorp(uPlayer:getCorporation():getID())
                -- Leaven
                uPlayer:setCorporation(0)
                uPlayer:resetCorpRoles();

                uPlayer:showInfoBox("sucess", "Du hast die Corporation verlassen.");
                logger:OutputPlayerLog(uPlayer, "Verliess Corporation (CEO)", name);
            else
                uPlayer:showInfoBox("error", "Es befinden sich noch Spieler in der Corporation!");
            end
        else
            -- Leaven
            uPlayer:setCorporation(0)
            uPlayer:resetCorpRoles();

            uPlayer:showInfoBox("sucess", "Du hast die Corporation verlassen.");
            logger:OutputPlayerLog(uPlayer, "Verliess Corporation", name);
        end
    else
        uPlayer:showInfoBox("error", "Du bist in keiner Corporation!")
    end
end

-- ///////////////////////////////
-- ///// deleteCorp  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:deleteCorp(iID)
    local corp = Corporations[iID];

    -- Corporation entfernen --
    corp:destructor();
    Corporations[iID]           = nil;
    self.m_tblCorporations[iID] = nil;
end

-- ///////////////////////////////
-- onPlayerCorporationManagementOpenGUIRequest
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerCorporationManagementOpenGUIRequest(uPlayer, iID)
    local sucess = false;
    if(iID == 1) then
        if(uPlayer:hasCorpRole(2)) then
            sucess = true
        end
    elseif(iID == 2) then
        if(uPlayer:hasCorpRole(3)) then
            sucess = true
        end
    elseif(iID == 3) then
        if(uPlayer:hasCorpRole(4)) then
            sucess = true
        end
    elseif(iID == 4) then
        if(uPlayer:hasCorpRole(5)) then
            sucess = true
        end
    elseif(iID == 5) then
        if(uPlayer:hasCorpRole(6)) then
            sucess = true
        end
    end


    if(sucess) then
        triggerClientEvent(uPlayer, "onCorporationManagementGUIOpenRequestSucess", uPlayer, iID, uPlayer:getCorporation())
    else
        uPlayer:showInfoBox("error", "Du hast keine Rechte diese Kategorie anzeigen zu lassen!")
    end

    uPlayer:setLoading(false)
end


-- //////////////////////////////
-- ///// changeLagerUnitPreis/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:changeLagerUnitPrice()
    self.m_iCurrentLagerUnitPrice   = math.random(250, 500);

    if(cBasicFunctions:calculateProbability(5)) then
        self.m_iCurrentLagerUnitPrice   = math.random(150, 750);
    end
end

-- //////////////////////////////
-- ///// onPlayerSkinSet	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:onPlayerSkinSet(uPlayer)
    if not(self.m_tblPlayerSkins[uPlayer]) then
        self.m_tblPlayerSkins[uPlayer] = 0
    end

    if(self.m_tblPlayerSkins[uPlayer] == #_Gsettings.corporation.roles) then
        self.m_tblPlayerSkins[uPlayer] = 0;
    else
        self.m_tblPlayerSkins[uPlayer] = self.m_tblPlayerSkins[uPlayer]+1;
    end

    if(uPlayer:hasCorpRole(self.m_tblPlayerSkins[uPlayer])) then
        if(tonumber(uPlayer:getCorporation():getSkins()[self.m_tblPlayerSkins[uPlayer]])) then
            uPlayer:setSkin(uPlayer:getCorporation():getSkins()[self.m_tblPlayerSkins[uPlayer]]);
            uPlayer:showInfoBox("info", "Skin: ".._Gsettings.corporation.roles[self.m_tblPlayerSkins[uPlayer]])
        else
            uPlayer:showInfoBox("error", "Skin: ".._Gsettings.corporation.roles[self.m_tblPlayerSkins[uPlayer]].." nicht festgelegt!")
        end
    else
        uPlayer:showInfoBox("error", "Skin: ".._Gsettings.corporation.roles[self.m_tblPlayerSkins[uPlayer]].." nicht verfuegbar")
    end

end

-- //////////////////////////////
-- ///// doBizPayday 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:doBizPayday()
    local totalPayday   = 0;
    local corps         = 0;
    for id, corp in pairs(self.m_tblCorporations) do
        if(corp) then
            corp:refreshOnlineMembers();
        end
        if(corp) and (corp:getOnlinePlayers() >= 0) then
            local income        = corp:getBizIncome();

            corp:addSaldo(income)
            corps               = corps+1;
            totalPayday         = totalPayday+income;

            corp:sendFactionMessage("[PAYDAY] Die Corporation hat $"..income.." durch Businesse erhalten.", 0, 255, 0);
        end
    end

    outputDebugString("Business Payday, Total: $"..totalPayday.." at "..corps.." Corporations")
end

-- //////////////////////////////
-- ///// generateTrailers	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:generateTrailers()
    addEvent("onCorporationMarketLadeGUIOpenBack", true)
    addEvent("onCorporationMarketBusinessAblade", true)

    if not(self.m_tblTrailerVehs) then
        self.m_tblTrailerVehs = {}
    end
    for index, veh in pairs(self.m_tblTrailerVehs) do
        if(isElement(veh)) then
            destroyElement(veh)
        end
    end

    self.m_tblTrailerVehs   = {}

    local models    =
    {
        [1] = 584,
        [2] = 435,
        [3] = 591,
        [4] = 450,

    }

    for i = 1, #self.m_tblTrailerSpawns, 1 do
        if(math.random(1, 3) == 1) then

            local trailer       = Vehicle(models[math.random(1, #models)], unpack(self.m_tblTrailerSpawns[i]));
            trailer:setColor(255, 255, 255, 255, 255, 255);
            trailer:setFrozen(true);
            trailer:setDamageProof(true)

            addEventHandler("onTrailerAttach", trailer, function(theTruck)
                if(isTimer(source.detachTimer)) then
                    killTimer(source.detachTimer)
                end
                source:setFrozen(false)

                if(theTruck:getOccupant()) then
                    theTruck:getOccupant():showInfoBox("info", "Diesen Anhaenger kannst du auch zum Transportieren benutzen. Er Respawnt nach 1. Minute Inaktivitaet!")
                end
            end)
            addEventHandler("onTrailerDetach", trailer, function(theTruck)
                if(isTimer(source.detachTimer)) then
                    killTimer(source.detachTimer)
                end
                local v = source
                source.detachTimer = setTimer(function() v:respawn() v:setFrozen(true) end, 60000, 1)
                if(theTruck:getOccupant()) then
                    theTruck:getOccupant():showInfoBox("info", "Du hast den Anhaenger abgekuppelt. Er respawnt nach 60 Sekunden inaktivitaet!")
                end
            end)

            self.m_tblTrailerVehs[trailer]  = trailer;
        end
    end

    self.m_uMarketMarkerTrailer  =
    {
        createMarker(-31.365921020508, -297.0569152832, 7.4296875, "arrow", 3.0, 0, 255, 0),
        createMarker(-30.342691421509, -286.94943237305, 7.4296875, "arrow", 3.0, 0, 255, 0),
        createMarker(-30.324687957764, -277.0241394043, 7.4296875, "arrow", 3.0, 0, 255, 0),
    }

    for index, marker in pairs(self.m_uMarketMarkerTrailer) do
        addEventHandler("onMarkerHit", marker, function(uVehicle)
            if(uVehicle) and (getElementType(uVehicle) == "vehicle") then
                if not(uVehicle:getOccupant()) and not(uVehicle.JobTruck) then
                    local uTruck    = uVehicle:getTowingVehicle()
                    if(uTruck:getOccupant()) and not(uTruck.JobTruck) then
                        local uPlayer = uTruck:getOccupant()
                        if(uPlayer:getCorporation() ~= 0) then

                            if(uPlayer:hasCorpRole(6)) then
                                setElementRealSpeed(uTruck, 0)
                                triggerClientEvent(uPlayer, "onCorporationMarketLadeGUIOpen", uPlayer, uPlayer:getCorporation())
                            else
                                uPlayer:showInfoBox("error", "Du benoetigst die PR Manager Rolle!")
                            end
                        else
                            uPlayer:showInfoBox("error", "Nur fuer Unternehmen!")
                        end
                    end
                end
            end
        end)
    end

    addEventHandler("onCorporationMarketLadeGUIOpenBack", getRootElement(), function(iAnzahl)
        local uPlayer = client;
        if(iAnzahl) and (iAnzahl > 0) then
            iAnzahl = math.floor(iAnzahl)

            if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(6)) then
                if(uPlayer:getCorporation():getLagereinheiten() >= iAnzahl) then
                    if(iAnzahl <= 200) and (iAnzahl > 0) then
                        local truck = uPlayer:getOccupiedVehicle()

                        local trailer = truck:getTowedByVehicle()

                        if(truck) and (trailer) then
                            if not(trailer.Lagereinheiten) then
                                trailer:setFrozen(true)
                                uPlayer:getCorporation():addLagereinheiten(-iAnzahl)
                                setTimer(function()
                                    uPlayer:showInfoBox("sucess", "Anhaenger Beladen! Du kannst nun zu einem Business deiner Wahl fahren.")
                                    trailer.Lagereinheiten = iAnzahl;
                                    trailer:setFrozen(false)
                                end, 5000, 1)
                            else
                                uPlayer:showInfoBox("error", "Dieser Anhaenger wurde schon beladen!")
                            end
                        else
                            uPlayer:showInfoBox("error", "Kein Anhaenger vorhanden!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Ungueltige Anzahl!")
                    end
                else
                    uPlayer:showInfoBox("error", "Soviele Lagereinheiten sind nicht mehr vorhanden!")
                end
            end
        end
    end)

    addEventHandler("onCorporationMarketBusinessAblade", getRootElement(), function(iBiz)
        local uPlayer = client;
        if(cBusinessManager:getInstance().m_uBusiness[iBiz]) then
            local biz = cBusinessManager:getInstance().m_uBusiness[iBiz];
            local truck = uPlayer:getOccupiedVehicle()
            local trailer = truck:getTowedByVehicle()

            if(truck) and (trailer) then
                if (trailer.Lagereinheiten) then
                    trailer:setFrozen(true)
                    biz:addLagereinheiten(trailer.Lagereinheiten)

                    setTimer(function()
                        uPlayer:showInfoBox("sucess", "Anhaenger Abgeladen!")
                        trailer.Lagereinheiten = false;
                        trailer:setFrozen(false)
                    end, 5000, 1)
                else
                    uPlayer:showInfoBox("error", "Dieser Anhanger ist nicht voll!")
                end
            else
                uPlayer:showInfoBox("error", "Du hast keinen Anhaenger dabei!")
            end
        else
            uPlayer:showInfoBox("error", "Dieses Business existiert nicht!")
        end
    end)
end

-- //////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationManager:constructor(...)
    -- Klassenvariablen --
    self.loadFunc		= function() self:loadCorps() end
    self.thread			= cThread:new("Corporation_Loading_Thread", self.loadFunc, 5)

    addEvent("onPlayerCorporationsRequest", true)
    addEvent("onCorporationCreateOpenReqeust", true)
    addEvent("onPlayerCorporationCreate", true)
    addEvent("onCorporationViewOpenReqeust", true)
    addEvent("onPlayerCorporationLeave", true)
    addEvent("onCorporationManagementGUIOpenRequest", true)
    addEvent("onCorporationSetSkin", true)


    self.m_tblPlayerSkins   = {}

    self:changeLagerUnitPrice()

    self.m_uChangeLUPTimer  = setTimer(function() self:changeLagerUnitPrice() end, 60*60*1000, -1);

    self.m_tblManager       =
    {
        cCorporationRole_HRManager:new(),
        cCorporationRole_PRManager:new(),
        cCorporationRole_FinanzManager:new(),
        cCorporationRole_StorageManager:new(),
        cCorporationRole_ProductionManager:new(),
    }

    self.m_tblDefaultSkins  = {}


    for i = 1, _Gsettings.corporation.iMaxIcons, 1 do
        downloadManager:AddFile("res/images/corporation/icons/"..i..".png")
    end
    for i = 1, _Gsettings.corporation.iMaxBackgrounds, 1 do
        downloadManager:AddFile("res/images/corporation/backgrounds/"..i..".png")
    end

    for i = 0, #_Gsettings.corporation.roles, 1 do
        downloadManager:AddFile("res/images/corporation/miniicons/"..i..".png")
    end

    for i = 0, 2, 1 do
        downloadManager:AddFile("res/images/corporation/miniicons/connections/"..i..".png")
    end

    self.m_funcOnBizPayday  = function(...) self:doBizPayday(...) end

    self.m_paydayTimer  = setTimer(self.m_funcOnBizPayday, 60*60*1000, -1);

--[[
    addCommandHandler("corppayday", function(uPlayer)
        if(DEFINE_DEBUG) then
            self:doBizPayday()
        end
    end)]]


    --[[


--]]

    self.m_tblTrailerSpawns =
    {
        {-0.2000000,-301.0000000,6.1000000,0, 0, 90},
        {-0.3000000,-304.6000100,6.1000000,0, 0, 90},
        {-0.3000000,-311.7999900,6.1000000,0, 0, 90},
        {-0.4003900,-308.0996100,6.1000000,0, 0, 90},
        {0.0000000,-315.3999900,6.1000000,0, 0, 90},
        {0.1000000,-318.7000100,6.1000000,0, 0, 90},
        {-0.1000000,-322.2999900,6.1000000,0, 0, 90},
        {0.0000000,-325.7000100,6.1000000,0, 0, 90},
        {0.0000000,-329.2999900,6.1000000,0, 0, 90},
        {0.0000000,-332.7000100,6.1000000,0, 0, 90},
        {0.0996100,-336.4003900,6.1000000,0, 0, 90},
        {0.1000000,-340.2000100,6.1000000,0, 0, 90},
        {0.1000000,-343.5000000,6.1000000,0, 0, 90},
        {0.1000000,-347.0000000,6.1000000,0, 0, 90},
        {0.1000000,-350.2000100,6.1000000,0, 0, 90},
        {0.2000000,-354.0000000,6.1000000,0, 0, 90},
        {0.2000000,-357.6000100,6.1000000,0, 0, 90},
        {0.1000000,-360.8999900,6.1000000,0, 0, 90},
        {0.1000000,-364.5000000,6.1000000,0, 0, 90},
        {0.1000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-3.0000000,-378.1000100,6.1000000,0.0000000,0, 0},
        {-6.4000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-9.8000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-13.0000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-19.7000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-16.4000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-23.0000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-26.3000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-29.6000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-36.3000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-33.0000000,-377.7999900,6.1000000,0.0000000,0, 0},
        {-39.7000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-43.0000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-46.4000000,-378.1000100,6.1000000,0.0000000,0, 0},
        {-49.8000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-53.1000000,-377.7999900,6.1000000,0.0000000,0, 0},
        {-56.8000000,-377.8999900,6.1000000,0.0000000,0, 0},
        {-60.0000000,-377.7999900,6.1000000,0.0000000,0, 0},
        {-63.2000000,-377.7000100,6.1000000,0.0000000,0, 0},
        {-66.3000000,-377.7999900,6.1000000,0.0000000,0, 0},
        {-73.1000000,-378.0000000,6.1000000,0.0000000,0, 0},
        {-69.5000000,-378.0000000,6.1000000,0.0000000,0, 0},
    }
    self:generateTrailers();

    -- Funktionen --
    self.thread:start(50);
    self.m_funcPlayerRequestCorps                           = function(...) self:onPlayerRequestCorps(client, ...) end
    self.m_funcRequestCorporationCreate                     = function(...) self:onPlayerRequestCorpCreateGUI(client, ...) end
    self.m_funcOnPlayerCreateCorp                           = function(...) self:onPlayerCreateCorporation(client, ...) end
    self.m_funcOnPlayerCorpViewRequest                      = function(...) self:onPlayerRequestViewCorp(client, ...) end
    self.m_funcOnPlayerCorporationLeaveRequest              = function(...) self:onPlayerCorporationLeave(client, ...) end
    self.m_funcOnPlayerCorporationManagementGUIRequest      = function(...) self:onPlayerCorporationManagementOpenGUIRequest(client, ...) end
    self.m_funcOnSkinSet                                    = function(...) self:onPlayerSkinSet(client, ...) end
    -- Events --

    -- MAIN EVENTS --
    addEventHandler("onPlayerCorporationsRequest", getRootElement(), self.m_funcPlayerRequestCorps)
    addEventHandler("onCorporationCreateOpenReqeust", getRootElement(), self.m_funcRequestCorporationCreate);
    addEventHandler("onPlayerCorporationCreate", getRootElement(), self.m_funcOnPlayerCreateCorp)
    addEventHandler("onCorporationViewOpenReqeust", getRootElement(), self.m_funcOnPlayerCorpViewRequest)
    addEventHandler("onPlayerCorporationLeave", getRootElement(), self.m_funcOnPlayerCorporationLeaveRequest)
    addEventHandler("onCorporationManagementGUIOpenRequest", getRootElement(), self.m_funcOnPlayerCorporationManagementGUIRequest);
    addEventHandler("onCorporationSetSkin", getRootElement(), self.m_funcOnSkinSet)

end

-- EVENT HANDLER --
