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

cCorporationRole_HRManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// hasPermissions 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:hasPermissions(uPlayer)
    if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(2)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// onPlayerGiveRole	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerGiveRole(uPlayer, uPlayer2, sRole)
    if(self:hasPermissions(uPlayer)) then
        if(getPlayerFromName(uPlayer2)) then
            uPlayer2 = getPlayerFromName(uPlayer2);
        else
            uPlayer2 = getOfflinePlayer(uPlayer2);
        end
        if(uPlayer2) then
            local roleID    = _Gsettings.corporation.findRolesFunction(sRole)
            if(roleID) then
                if not(uPlayer2:hasCorpRole(roleID)) then
                    if(uPlayer2:getCorporation()) and (uPlayer2:getCorporation():getID() == uPlayer:getCorporation():getID()) then
                        uPlayer2:addCorpRole(roleID);
                        uPlayer2:showInfoBox("sucess", "Dir wurde eine neue Corporationsrolle gegeben: "..sRole)
                        uPlayer2:save()
                        uPlayer:showInfoBox("sucess", "Du hast dem Spieler die Rolle: "..sRole.." gegeben!")
                        local iID = uPlayer:getCorporation():getID()

                        Corporations[iID]:refreshMembers()
                        triggerClientEvent(uPlayer, "onClientPlayerCorporationHRManagementGUIRefresh", uPlayer, Corporations[iID])

                        logger:OutputPlayerLog(uPlayer, "Gab Corporationsrolle", uPlayer:getCorporation():getName(), uPlayer2:getName(), sRole);

                    else
                        uPlayer:showInfoBox("error", "Der Spieler ist nicht in deiner Corporation!")
                    end
                else
                    uPlayer:showInfoBox("error", "Der Spieler hat bereits diese Rolle!")
                end
            else
                uPlayer:showInfoBox("error", "Unbekannte Rolle!")
            end
        else
            uPlayer:showInfoBox("error", "Spieler wurde nicht in der Datenbank gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerRemoveRole	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerRemoveRole(uPlayer, uPlayer2, sRole)
    if(self:hasPermissions(uPlayer)) then
        if(getPlayerFromName(uPlayer2)) then
            uPlayer2 = getPlayerFromName(uPlayer2);
        else
            uPlayer2 = getOfflinePlayer(uPlayer2);
        end
        if(uPlayer2) then
            local roleID    = _Gsettings.corporation.findRolesFunction(sRole)
            if(roleID) then
                if(uPlayer2:hasCorpRole(roleID)) then
                    if(uPlayer2:getCorporation()) and (uPlayer2:getCorporation():getID() == uPlayer:getCorporation():getID()) then
                        local sucess = false;

                        if(roleID == 0) then
                            sucess = false;
                        elseif(roleID == 1) then
                            if(uPlayer:hasDistinctCorpRole(0)) then
                                sucess = true;
                            else
                                sucess = false;
                            end
                        else
                            sucess = true;
                        end
                        if(sucess) then
                            uPlayer2:removeCorpRole(roleID);
                            uPlayer2:showInfoBox("info", "Dir wurde eine Corporationsrolle entfernt: "..sRole)
                            uPlayer2:save()
                            uPlayer:showInfoBox("sucess", "Du hast dem Spieler die Rolle: "..sRole.." entfernt!")

                            local iID = uPlayer:getCorporation():getID()

                            Corporations[iID]:refreshMembers()
                            triggerClientEvent(uPlayer, "onClientPlayerCorporationHRManagementGUIRefresh", uPlayer, Corporations[iID])

                            logger:OutputPlayerLog(uPlayer, "Entfernte Corporationsrolle", uPlayer:getCorporation():getName(), uPlayer2:getName(), sRole);

                        else
                            uPlayer:showInfoBox("error", "Du hast nicht die benoetigten Rechte, dem Spieler diese Rolle zu entfernen!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Der Spieler ist nicht in deiner Corporation!")
                    end
                else
                    uPlayer:showInfoBox("error", "Der Spieler besitzt diese Rolle nicht!")
                end
            else
                uPlayer:showInfoBox("error", "Unbekannte Rolle!")
            end
        else
            uPlayer:showInfoBox("error", "Spieler wurde nicht in der Datenbank gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerUserAdd	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerUserAdd(uPlayer, uPlayer2)
    if(self:hasPermissions(uPlayer)) then
        if(getPlayerFromName(uPlayer2)) then
            uPlayer2 = getPlayerFromName(uPlayer2);
            if(uPlayer2) then
                if(uPlayer:hasCorpRole(2)) then
                    if(uPlayer2:getCorporation() == 0) and (uPlayer2:getFaction():getID() == 0) then
                        uPlayer:showInfoBox("sucess", "Der Spieler hat eine Einladung erhalten!")
                        self.m_tblPlayerInvited[uPlayer2] = uPlayer:getCorporation():getID();
                        triggerClientEvent(uPlayer2, "onClientPlayerCorporationInviteRequest", uPlayer2, uPlayer:getCorporation().m_sFullName, uPlayer:getName())

                        logger:OutputPlayerLog(uPlayer, "Invitete Corporationsuser", uPlayer:getCorporation():getName(), uPlayer2:getName());

                    else
                        uPlayer:showInfoBox("error", "Der Spieler ist bereits in einer Corporation / Fraktion!")
                    end
                else
                    uPlayer:showInfoBox("error", "Du hast nicht die Rechte, diese Aktion auszufuehren!")
                end
            else
                uPlayer:showInfoBox("error", "Spieler wurde nicht in der Datenbank gefunden!")
            end
        else
            uPlayer:showInfoBox("error", "Der Spieler muss online sein!")
        end
    end
end

-- ///////////////////////////////
-- ///// onPlayerUserRemove	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerUserRemove(uPlayer, uPlayer2)
    if(self:hasPermissions(uPlayer)) then
        if(getPlayerFromName(uPlayer2)) then
            uPlayer2 = getPlayerFromName(uPlayer2);
        else
            uPlayer2 = getOfflinePlayer(uPlayer2);
        end
        if(uPlayer:hasCorpRole(2)) then
            if(uPlayer2:getCorporation()) and (uPlayer2:getCorporation():getID() == uPlayer:getCorporation():getID()) then
                local sucess = false;

                if(uPlayer2:hasDistinctCorpRole(0)) then
                    sucess = false;
                elseif(uPlayer2:hasDistinctCorpRole(1)) then
                    if(uPlayer:hasDistinctCorpRole(0)) then
                        sucess = true;
                    else
                        sucess = false;
                    end
                else
                    sucess = true;
                end
                if(sucess) then
                    uPlayer:showInfoBox("sucess", "Der Spieler wurde aus der Corporation entfernt.")
                    local id = uPlayer:getCorporation():getID()
                    Corporations[id]:sendFactionMessage("* "..uPlayer2:getName().." wurde aus der Corporation entfernt.", 0, 255, 255);

                    uPlayer2:setCorporation(0);
                    uPlayer2:resetCorpRoles();
                    uPlayer2:save()

                    Corporations[id]:refreshMembers()

                    logger:OutputPlayerLog(uPlayer, "Uninvitete Corporationsuser", uPlayer:getCorporation():getName(), uPlayer2:getName());

                else
                    uPlayer:showInfoBox("error", "Du hast keine Rechte, dieses Mitglied zu entfernen!")
                end
            else
                uPlayer:showInfoBox("error", "Der Spieler ist bereits in einer Corporation / Fraktion!")
            end
        else
            uPlayer:showInfoBox("error", "Du hast nicht die Rechte, diese Aktion auszufuehren!")
        end
    else
        uPlayer:showInfoBox("error", "Spieler wurde nicht in der Datenbank gefunden!")
    end
end

-- //////////////////////////////
-- /onPlayerCorporationInviteAccept
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerCorporationInviteAccept(uPlayer)
    if(self.m_tblPlayerInvited[uPlayer]) then
        if(uPlayer:getFaction():getID() == 0) and (uPlayer:getCorporation() == 0) then
            local id = self.m_tblPlayerInvited[uPlayer]
            if(Corporations[id]) then
                if(Corporations[id].m_iMembers < Corporations[id].m_iMaxMembers) then
                    uPlayer:setCorporation(id);
                    uPlayer:resetCorpRoles();

                    uPlayer:showInfoBox("sucess", "Du bist der Corporation beigetreten!");
                    Corporations[id]:sendFactionMessage("* "..getPlayerName(uPlayer).." ist der Corporation beigetreten.", 0, 255, 255);
                    uPlayer:save();

                    self.m_tblPlayerInvited[uPlayer] = nil;

                    Corporations[id]:refreshMembers()
                else
                    uPlayer:showInfoBox("error", "Diese Corporation ist voll!")
                end
            else
                uPlayer:showInfoBox("error", "Diese Corporation existiert nicht mehr!")
            end
        else
            uPlayer:showInfoBox("error", "Du bist schon in einer Fraktion / Corporation!")
        end
    else
        uPlayer:showInfoBox("error", "Du bist nirgendswo eingeladen!")
    end
end

-- ///////////////////////////////
-- //onPlayerPlayerSlotBuy 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:onPlayerPlayerSlotBuy(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local Corp      = Corporations[uPlayer:getCorporation():getID()]
        if(Corp) then
            local cost      = _Gsettings.corporation.playerSlotCost[Corp.m_iMaxMembers+1];
            if(cost) then
                if(uPlayer:getBankMoney() >= cost) then
                    uPlayer:addBankMoney(-cost);
                    Corp.m_iMaxMembers      = Corp.m_iMaxMembers+1;
                    Corp:save()
                    Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Spielerupgrade gekauft. Maximale Spieler: "..Corp.m_iMaxMembers, 0, 200, 200);
                    uPlayer:showInfoBox("sucess", "Erfolg!")
                    triggerClientEvent(uPlayer, "onClientPlayerCorporationHRManagementGUIRefresh", uPlayer, Corp)
                    logger:OutputPlayerLog(uPlayer, "Kaufte Spielerupgradeslot", uPlayer:getCorporation():getName());

                else
                    uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf dem Bankkonto!($"..cost.."");
                end
            else
                uPlayer:showInfoBox("error", "Maximale Anzahl an Mitgliedern erreicht!")
            end
        else
            uPlayer:showInfoBox("error", "Keine Corporation!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_HRManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onPlayerCoroprationsManagementHRUserGiveRole", true)
    addEvent("onPlayerCoroprationsManagementHRUserRemoveRole", true)
    addEvent("onPlayerCoroprationsManagementHRUserAdd", true)
    addEvent("onPlayerCoroprationsManagementHRUserRemove", true)
    addEvent("onPlayerCorporationInviteAccept", true)
    addEvent("onPlayerCoroprationsManagementHRSlotAdd", true)

    -- Funktionen --
    self.m_funcUserGiveRole                                 = function(...) self:onPlayerGiveRole(client, ...) end
    self.m_funcUserRemoveRole                               = function(...) self:onPlayerRemoveRole(client, ...) end
    self.m_funcOnUserUserAdd                                = function(...) self:onPlayerUserAdd(client, ...) end
    self.m_funcOnUserUserRemove                             = function(...) self:onPlayerUserRemove(client, ...) end
    self.m_funcOnPlayerCorporationInviteAccept              = function(...) self:onPlayerCorporationInviteAccept(client, ...) end
    self.m_funcOnPlayerSlotErweitern                        = function(...) self:onPlayerPlayerSlotBuy(client, ...) end

    self.m_tblPlayerInvited                 = {}

    -- Events --
    addEventHandler("onPlayerCoroprationsManagementHRUserGiveRole", getRootElement(), self.m_funcUserGiveRole)
    addEventHandler("onPlayerCoroprationsManagementHRUserRemoveRole", getRootElement(), self.m_funcUserRemoveRole)
    addEventHandler("onPlayerCoroprationsManagementHRUserAdd", getRootElement(), self.m_funcOnUserUserAdd)
    addEventHandler("onPlayerCoroprationsManagementHRUserRemove", getRootElement(), self.m_funcOnUserUserRemove)
    addEventHandler("onPlayerCorporationInviteAccept", getRootElement(), self.m_funcOnPlayerCorporationInviteAccept);
    addEventHandler("onPlayerCoroprationsManagementHRSlotAdd", getRootElement(), self.m_funcOnPlayerSlotErweitern)

end

-- EVENT HANDLER --
