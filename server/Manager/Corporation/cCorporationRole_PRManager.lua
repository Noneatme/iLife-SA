--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by Noneatme
-- User: Noneatme
-- Date: 24.02.2015
-- Time: 15:42
-- Copyright(c) 2015 - iLife Team and Developers
--

cCorporationRole_PRManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// hasPermissions 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:hasPermissions(uPlayer)
    if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(3)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerGUIOpen(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local id            = uPlayer:getCorporation():getID();

        triggerClientEvent(uPlayer, "onClientPlayerCorporationPRManagementGUIRefresh", uPlayer, uPlayer:getCorporation():getConnections(), uPlayer:getCorporation())
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerBioEdit		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerBioEdit(uPlayer, sMOTD, sBIO)
    if(self:hasPermissions(uPlayer)) then
        local corp      = uPlayer:getCorporation()
        corp:setMOTD(escapeString(sMOTD));
        corp:setBio(escapeString(sBIO));
        logger:OutputPlayerLog(uPlayer, "Aenderte Corporationsbiographie", uPlayer:getCorporation():getName());

        corp:sendFactionMessage("* "..uPlayer:getName().." hat die Biographie / MotD geaendert!", 0, 200, 200)
        corp:save();
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- /deleteAllCorpConnections	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:deleteAllCorpConnections(iID)
    local result    = CDatabase:getInstance():query("DELETE FROM corporation_connections WHERE ID1 = ? OR ID2 = ?;", iID, iID);
    return result;
end

-- ///////////////////////////////
-- /deleteCorpConnection	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:deleteCorpConnection(iCorp1, iCorp2)
    local result    = CDatabase:getInstance():query("DELETE FROM corporation_connections WHERE (ID1 = ? AND ID2 = ?) OR (ID2 = ? AND ID1 = ?);", iCorp1, iCorp2, iCorp1, iCorp2);
    return result;
end


-- ///////////////////////////////
-- //DoesConnectionExists 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:doesConnectionExists(iID1, iID2)
    local result    = CDatabase:getInstance():query("SELECT * FROM corporation_connections WHERE (ID1 = ? AND ID2 = ?) OR (ID2 = ? AND ID1 = ?);", iID1, iID2, iID1, iID2);
    if(result) and (#result > 0) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// onBeziehungRemove	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerBeziehungRemove(uPlayer, sCorp)
    if(self:hasPermissions(uPlayer)) then
        local iCorp = tonumber(cCorporationManager:getInstance():doesCorpExists(sCorp))
        if(iCorp) then
            local CorpID1         = uPlayer:getCorporation():getID()
            local CorporationID   = tonumber(Corporations[iCorp].m_iID);

            self:deleteCorpConnection(CorpID1, CorporationID);
            uPlayer:showInfoBox("sucess", "Beziehung zu der Corporation wurde entfernt!")

            uPlayer:getCorporation():sendFactionMessage("** "..getPlayerName(uPlayer).." hat eine Beziehung mit der Corporation "..Corporations[iCorp]:getName().." beendet.", 0, 200, 200)
            Corporations[iCorp]:sendFactionMessage("** "..getPlayerName(uPlayer).." hat eine Beziehung mit dieser Corporation beendet. ("..uPlayer:getCorporation():getName()..")", 0, 200, 200)

            logger:OutputPlayerLog(uPlayer, "Entfernte Corporationsbeziehung", uPlayer:getCorporation():getName(), Corporations[iCorp]:getName());

            self:onPlayerGUIOpen(uPlayer)
        else
            uPlayer:showInfoBox("error", "Diese Corporation existiert nicht mehr!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- //canCreateAnfrage    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:canCreateAnfrage(iCorp)
    if not(self.m_tblMaxAnfragen[iCorp]) then
        self.m_tblMaxAnfragen[iCorp] = 0;
    end
    if(self.m_tblMaxAnfragen[iCorp] < self.m_iMaxAnfragenProTag) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- //onPlayerBuendnissAdd 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerBuendnissAdd(uPlayer, sCorporationName)
    if(self:hasPermissions(uPlayer)) then
        local iCorp = tonumber(cCorporationManager:getInstance():doesCorpExists(sCorporationName))
        if(iCorp) then
            local iCorp2    = uPlayer:getCorporation():getID()
            local corp1     = uPlayer:getCorporation();
            if not(self:doesConnectionExists(tonumber(iCorp), tonumber(iCorp2))) then
                if(self:canCreateAnfrage(corp1)) then
                    if(iCorp2 ~= iCorp) then
                        local corp = Corporations[tonumber(cCorporationManager:getInstance():doesCorpExists(sCorporationName))];
                        self.m_tblAnfragen[iCorp2]    = {iCorp, 0};

                        corp:sendRoleMessage("* Die Corporation: "..corp1:getName().." moechte ein Buendnis mit deiner Corporation eingehen. Benutze /connectcorp "..iCorp2.." um zu akzeptieren!", 3, 0, 255, 0)
                        uPlayer:showInfoBox("sucess", "Anfrage gesendet! Ein PR Manager muss diese Anfrage akzeptieren.")

                        self.m_tblMaxAnfragen[corp1] = self.m_tblMaxAnfragen[corp1]+1;

                    else
                        uPlayer:showInfoBox("error", "Diese Corporation keine Beziehung mit deiner Corporation herstellen!")
                    end
                else
                    uPlayer:showInfoBox("error", "Deine Corporation hat die Max. Anfragen pro Tag erreicht! ("..self.m_iMaxAnfragenProTag..")")
                end
            else
                uPlayer:showInfoBox("error", "Es existiert bereits eine Verbindung zwischen diesen Corporationen!")
            end
        else
            uPlayer:showInfoBox("error", "Diese Corporation existiert nicht!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- //onPlayerFeindschaftAdd 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerFeindschaftAdd(uPlayer, sCorporationName)
    if(self:hasPermissions(uPlayer)) then
        local iCorp = tonumber(cCorporationManager:getInstance():doesCorpExists(sCorporationName))
        if(iCorp) then
            local iCorp2    = uPlayer:getCorporation():getID()
            local corp1     = uPlayer:getCorporation();
            if not(self:doesConnectionExists(tonumber(iCorp), tonumber(iCorp2))) then
                if(self:canCreateAnfrage(corp1)) then
                    if(iCorp2 ~= iCorp) then
                        local corp = Corporations[tonumber(cCorporationManager:getInstance():doesCorpExists(sCorporationName))];
                        self.m_tblAnfragen[iCorp2]    = {iCorp, 1};

                        corp:sendRoleMessage("* Die Corporation: "..corp1:getName().." moechte eine Feinschaft mit deiner Corporation eingehen. Benutze /connectcorp "..iCorp2.." um zu akzeptieren!", 3, 255, 0, 0)
                        uPlayer:showInfoBox("sucess", "Anfrage gesendet! Ein PR Manager muss diese Anfrage akzeptieren.")

                        self.m_tblMaxAnfragen[corp1] = self.m_tblMaxAnfragen[corp1]+1;
                    else
                        uPlayer:showInfoBox("error", "Diese Corporation keine Beziehung mit deiner Corporation herstellen!")
                    end
                else
                    uPlayer:showInfoBox("error", "Deine Corporation hat die Max. Anfragen pro Tag erreicht! ("..self.m_iMaxAnfragenProTag..")")
                end
            else
                uPlayer:showInfoBox("error", "Es existiert bereits eine Verbindung zwischen diesen Corporationen!")
            end
        else
            uPlayer:showInfoBox("error", "Diese Corporation existiert nicht!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// addNewConnection   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:addNewConnection(iID1, iID2, iState)
    local result    = CDatabase:getInstance():query("INSERT INTO corporation_connections(ID1, ID2, iState) VALUES (?, ?, ?);", iID1, iID2, iState)
    return true;
end

-- ///////////////////////////////
-- ///// onPlayerCorpConnectCommand//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:onPlayerCorpConnectCommand(uPlayer, cmd, iID)
    if(uPlayer:getCorporation() ~= 0) then
        if(self:hasPermissions(uPlayer)) then
            local iID   = tonumber(iID);
            if(iID) and (self.m_tblAnfragen[iID]) then
                local anfrage   = self.m_tblAnfragen[iID]

                local iCorpID   = anfrage[1]
                local iCorpID2  = uPlayer:getCorporation():getID()
                local corp2     = Corporations[iID];
                if(uPlayer:getCorporation():getID() == iCorpID) then
                    if not(self:doesConnectionExists(iCorpID, iCorpID2)) then
                        -- Annehmen
                        local result = self:addNewConnection(iID, iCorpID2, anfrage[2]);
                        if(result) then
                            uPlayer:showInfoBox("sucess", "Beziehung erfolgreich erstellt!")
                            uPlayer:getCorporation():sendFactionMessage("* Eine Beziehung wurde mit der Corporation: "..corp2:getName().." erstellt!", 0, 255, 255)
                            corp2:sendFactionMessage("* Eine Beziehung wurde mit der Corporation: "..uPlayer:getCorporation():getName().." erstellt!", 0, 255, 255)
                            self.m_tblAnfragen[iID] = nil;
                            logger:OutputPlayerLog(uPlayer, "Akzeptierte Corporationsbeziehung", uPlayer:getCorporation():getName(), corp2:getName());

                            if(tonumber(anfrage[2]) == 0) then
                                corp2:addStatus(1);              -- Freundschaft
                            elseif(tonumber(anfrage[2]) == 1) then
                                corp2:addStatus(-1);             -- Feindschaft
                            end
                        else
                            uPlayer:showInfoBox("error", "Fehler beim erstellen der Verbindung!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Es existiert bereits eine Verbindung zwischen den 2 Corporationen!")
                    end
                else
                    uPlayer:showInfoBox("error", "Diese Anfrage ist nicht fuer deine Corporation!")
                end
            else
                uPlayer:showInfoBox("error", "Diese Anfrage existiert nicht!")
            end
        else
            uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_PRManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientCorporationPRManagerOpen", true)
    addEvent("onPlayerPRManagementBioEdit", true)
    addEvent("onPlayerPRManagementBeziehungRemove", true)
    addEvent("onPlayerPRManagementBuendnissAdd", true)
    addEvent("onPlayerPRManagementFeindschaftAdd", true)

    self.m_tblAnfragen              = {}
    self.m_tblMaxAnfragen           = {}

    self.m_iMaxAnfragenProTag       = 3;

    -- Funktionen --
    self.m_funcOnPlayerGuiOpen      = function(...) self:onPlayerGUIOpen(client, ...) end
    self.m_funcOnManagementEdit     = function(...) self:onPlayerBioEdit(client, ...) end
    self.m_funcOnBeziehungRemove    = function(...) self:onPlayerBeziehungRemove(client, ...) end
    self.m_funcOnBuendnissAdd       = function(...) self:onPlayerBuendnissAdd(client, ...) end
    self.m_funcOnFeindschaftAdd     = function(...) self:onPlayerFeindschaftAdd(client, ...) end
    self.m_funcConnectCorpCommand   = function(...) self:onPlayerCorpConnectCommand(...) end
    -- Events --
    addEventHandler("onClientCorporationPRManagerOpen", getRootElement(), self.m_funcOnPlayerGuiOpen)
    addEventHandler("onPlayerPRManagementBioEdit", getRootElement(), self.m_funcOnManagementEdit)
    addEventHandler("onPlayerPRManagementBeziehungRemove", getRootElement(), self.m_funcOnBeziehungRemove)
    addEventHandler("onPlayerPRManagementBuendnissAdd", getRootElement(), self.m_funcOnBuendnissAdd)
    addEventHandler("onPlayerPRManagementFeindschaftAdd", getRootElement(), self.m_funcOnFeindschaftAdd)


    addCommandHandler("connectcorp", self.m_funcConnectCorpCommand)

end

-- EVENT HANDLER --
