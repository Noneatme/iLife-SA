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

cCorporationRole_FinanzManager = inherit(cSingleton);

--[[

]]
-- ///////////////////////////////
-- ///// hasPermissions 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:hasPermissions(uPlayer)
    if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(4)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerGUIOpen(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local id            = uPlayer:getCorporation():getID();

        triggerClientEvent(uPlayer, "onClientPlayerCorporationFinanzManagementGUIRefresh", uPlayer, uPlayer:getCorporation():getConnections(), uPlayer:getCorporation():getSaldo())
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onGeldEinzahle 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerGeldEinzahle(uPlayer, iGeld)
    if(self:hasPermissions(uPlayer)) then
        local corp      = uPlayer:getCorporation();
        iGeld           = math.floor(iGeld)
        if(iGeld > 0) then
            if(uPlayer:getMoney() >= iGeld) then
                uPlayer:addMoney(-iGeld)
                corp:addSaldo(iGeld)
                uPlayer:showInfoBox("sucess", "Du hast erfolgreich $"..iGeld.." eingezahlt!")
                corp:sendRoleMessage("* "..uPlayer:getName().." hat $"..iGeld.." in die Corporationskasse eingezahlt.", 4, 0, 200, 0)
                logger:OutputPlayerLog(uPlayer, "Lagerte Geld in Corporationkasse", uPlayer:getCorporation():getName(), iGeld);

                self:onPlayerGUIOpen(uPlayer)
            else
                uPlayer:showInfoBox("error", "Soviel Geld besitzt du nicht auf der Hand!")
            end
        else
            uPlayer:showInfoBox("error", "Inkorrekte Geldanzahl!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onGeldEinzahle 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerGeldAuszahle(uPlayer, iGeld)
    if(self:hasPermissions(uPlayer)) then
        iGeld           = math.floor(iGeld)
        if(iGeld > 0) then
            local corp      = uPlayer:getCorporation();
            if(corp:getSaldo() >= iGeld) then
                uPlayer:addMoney(iGeld)
                corp:addSaldo(-iGeld)
                uPlayer:showInfoBox("sucess", "Du hast erfolgreich $"..iGeld.." ausgezahlt!")
                corp:sendRoleMessage("* "..uPlayer:getName().." hat $"..iGeld.." aus die Corporationskasse entnommen.", 4, 0, 200, 0)
                logger:OutputPlayerLog(uPlayer, "Nahm Geld aus Corporationkasse", uPlayer:getCorporation():getName(), iGeld);

                self:onPlayerGUIOpen(uPlayer)
            else
                uPlayer:showInfoBox("error", "Soviel Geld existiert nicht!")
            end
        else
            uPlayer:showInfoBox("error", "Inkorrekte Geldanzahl!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerGeldSende 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerGeldSende(uPlayer, sCorp, iGeld)
    if(self:hasPermissions(uPlayer)) then
        local iID       = cCorporationManager:getInstance():doesCorpExists(sCorp)
        iGeld           = math.floor(iGeld)
        if(iGeld) and (iGeld > 0) then
            if(iID) and (Corporations[iID]) then
                local corp1     = Corporations[iID];
                local corp2     = uPlayer:getCorporation();
                if(corp1:getID() ~= corp2:getID()) then             -- ACHTUNG HIER ~ AENDERN
                    if(corp1:getSaldo() >= iGeld) then
                        corp1:addSaldo(-iGeld)
                        corp2:addSaldo(iGeld);

                        corp1:sendRoleMessage("* Die Corporation: "..corp1:getName().." hat euch $"..iGeld.." gesendet! ("..uPlayer:getName()..")", 4, 0, 200, 0)
                        corp2:sendRoleMessage("* "..uPlayer:getName().." hat $"..iGeld.." an die Corporation: "..corp1:getName().." gesendet!", 4, 0, 200, 0)
                        logger:OutputPlayerLog(uPlayer, "Sendete Corporationsgeld an andere Corporation", uPlayer:getCorporation():getName(), corp1:getName(), iGeld);

                        uPlayer:showInfoBox("sucess", "Du hast erfolgreich $"..iGeld.." an die Corporation: "..sCorp.." gesendet!")
                    else
                        uPlayer:showInfoBox("error", "Soviel Geld besitzt deine Corporation nicht!")
                    end
                else
                    uPlayer:showInfoBox("error", "Du kannst kein Geld an deine Corporation senden!")
                end
            else
                uPlayer:showInfoBox("error", "Diese Corporation wurde nicht gefunden!")
            end
        else
            uPlayer:showInfoBox("error", "Ungueltiger Betrag!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onZinssatzAneder 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerZinssatzAendere(uPlayer, iZinssatz)
    if(self:hasPermissions(uPlayer)) then
        iZinssatz       = tonumber(iZinssatz) or 5
        iZinssatz       = math.floor(iZinssatz)
        if(iZinssatz) and (iZinssatz >= 0) and (iZinssatz <= 100) then
            local corp  = uPlayer:getCorporation();
            corp:setTaxRate(iZinssatz);
            corp:sendFactionMessage("* "..uPlayer:getName().." hat den Zinssatz der Corporation auf "..iZinssatz.."% gesetzt.", 0, 200, 0)
            uPlayer:showInfoBox("sucess", "Zinssatz erfolgreich geaendert!")
            logger:OutputPlayerLog(uPlayer, "Aenderte den Zinssatz seiner Corporation", uPlayer:getCorporation():getName(), iZinssatz);

        else
            uPlayer:showInfoBox("error", "Ungueltiger Zinssatz!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerLohnAneder 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:onPlayerLohnAendere(uPlayer, iZinssatz)
    if(self:hasPermissions(uPlayer)) then
        iZinssatz       = tonumber(iZinssatz) or 0
        iZinssatz       = math.floor(iZinssatz)
        if(iZinssatz) and (iZinssatz >= 0) and (iZinssatz <= 5000) then
            local corp  = uPlayer:getCorporation();
            corp:setLohn(iZinssatz);
            corp:sendFactionMessage("* "..uPlayer:getName().." hat den Lohn der Corporation auf $"..iZinssatz.." gesetzt.", 0, 200, 0)
            uPlayer:showInfoBox("sucess", "Lohn erfolgreich geaendert!")

            logger:OutputPlayerLog(uPlayer, "Aenderte den Lohn seiner Corporation", uPlayer:getCorporation():getName(), iZinssatz);

        else
            uPlayer:showInfoBox("error", "Ungueltiger Lohn!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_FinanzManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientCorporationFinanzManagerOpen", true)
    addEvent("onClientCorporationFinanzManagerGeldEinzahlen", true)
    addEvent("onClientCorporationFinanzManagerGeldAuszahlen", true)
    addEvent("onClientCorporationFinanzManagerGeldSende", true)
    addEvent("onClientCorporationFinanzManagerZinssatzAendere", true)
    addEvent("onClientCorporationFinanzManagerLohnAendere", true)


    -- Funktionen --
    self.m_funcOnPlayerGuiOpen      = function(...) self:onPlayerGUIOpen(client, ...) end
    self.m_funcOnGeldEinzahle       = function(...) self:onPlayerGeldEinzahle(client, ...) end
    self.m_funcOnGeldAuszahle       = function(...) self:onPlayerGeldAuszahle(client, ...) end
    self.m_funcOnGeldSende          = function(...) self:onPlayerGeldSende(client, ...) end
    self.m_funcOnZinssatzAendere    = function(...) self:onPlayerZinssatzAendere(client, ...) end
    self.m_funcOnLohnAendere        = function(...) self:onPlayerLohnAendere(client, ...) end

    -- Events --
    addEventHandler("onClientCorporationFinanzManagerOpen", getRootElement(), self.m_funcOnPlayerGuiOpen)
    addEventHandler("onClientCorporationFinanzManagerGeldEinzahlen", getRootElement(), self.m_funcOnGeldEinzahle)
    addEventHandler("onClientCorporationFinanzManagerGeldAuszahlen", getRootElement(), self.m_funcOnGeldAuszahle)
    addEventHandler("onClientCorporationFinanzManagerGeldSende", getRootElement(), self.m_funcOnGeldSende)
    addEventHandler("onClientCorporationFinanzManagerZinssatzAendere", getRootElement(), self.m_funcOnZinssatzAendere)
    addEventHandler("onClientCorporationFinanzManagerLohnAendere", getRootElement(), self.m_funcOnLohnAendere)

end

-- EVENT HANDLER --
