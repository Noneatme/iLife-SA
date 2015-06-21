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

cCorporationRole_StorageManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// hasPermissions 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:hasPermissions(uPlayer)
    if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(5)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerGUIOpen(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local id            = uPlayer:getCorporation():getID();

        triggerClientEvent(uPlayer, "onClientPlayerCorporationStorageManagementGUIRefresh", uPlayer, uPlayer:getCorporation(), cCorporationManager:getInstance().m_iCurrentLagerUnitPrice, uPlayer:getCorporation():getLagereinheiten(), uPlayer:getCorporation():getVehicles(), uPlayer:getCorporation():getHouses(), uPlayer:getCorporation():getSkins())
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onItemsEinlagern	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onItemsEinlagern(uPlayer, ...)
    if(self:hasPermissions(uPlayer)) then
        triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(uPlayer.Inventory));
        triggerClientEvent(uPlayer, "onClientInventoryOpen", uPlayer, 1, "corporationstore", uPlayer:getCorporation():getID());
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onItemsAuslagern	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onItemsAuslagern(uPlayer, ...)
    if(self:hasPermissions(uPlayer)) then
        uPlayer:getCorporation():getInventory():refreshGewicht();

        triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(uPlayer:getCorporation():getInventory()));
        triggerClientEvent(uPlayer, "onClientInventoryOpen", uPlayer, 2, "corporationstore", uPlayer:getCorporation():getID());

    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end

end

-- ///////////////////////////////
-- ///// onItemEinlagerFinish//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onItemEinlagerFinish(uPlayer, iCorp, iID, iAnzahl)
    local iCorpID       = uPlayer:getCorporation():getID()
    if(self:hasPermissions(uPlayer)) then
        iID         = tonumber(iID)
        iAnzahl     = tonumber(iAnzahl)
        if(iID) and (iAnzahl) and (iAnzahl > 0) and (Items[iID]) then
            iAnzahl = math.floor(iAnzahl)
            item    = Items[iID]
            if(uPlayer:getInventory():hasItem(item, iAnzahl)) then
                local sucess = uPlayer:getCorporation():getInventory():addItem(item, iAnzahl, false, true);
                if(sucess) then
                    uPlayer:getInventory():removeItem(item, iAnzahl);
                    uPlayer:refreshInventory();

                    logger:OutputPlayerLog(uPlayer, "Lagerte Item in Corporationsinventar", uPlayer:getCorporation():getName(), iID, iAnzahl);
                else
                    uPlayer:showInfoBox("error", "Soviel kann das Inventar nicht mehr aufnehmen!")
                end
            else
                uPlayer:showInfoBox("error", "Soviel von diesem Item besitzt du nicht!")
            end
        else
            uPlayer:showInfoBox("error", "Ungueltige Anzahl!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
    uPlayer:setLoading(false)
end

-- ///////////////////////////////
-- ///// onItemAuslagerFinish//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onItemAuslagerFinish(uPlayer, iCorp, iID, iAnzahl)
    local iCorpID       = uPlayer:getCorporation():getID()
    if(self:hasPermissions(uPlayer)) then
        iID         = tonumber(iID)
        iAnzahl     = tonumber(iAnzahl)
        if(iID) and (iAnzahl) and (iAnzahl > 0) and (Items[iID]) then
            iAnzahl = math.floor(iAnzahl)
            item    = Items[iID]
            if(uPlayer:getCorporation():getInventory():hasItem(item, iAnzahl)) then
                local sucess = uPlayer:getInventory():addItem(item, iAnzahl, false, true);
                if(sucess) then
                    uPlayer:getCorporation():getInventory():removeItem(item, iAnzahl);
                    triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(uPlayer:getCorporation():getInventory()));

                    logger:OutputPlayerLog(uPlayer, "Entnahm Item vom Corporationsinventar", uPlayer:getCorporation():getName(), iID, iAnzahl);
                else
                    uPlayer:showInfoBox("error", "Soviel von diesem Item kannst du nicht mehr Tragen!")
                end
            else
                uPlayer:showInfoBox("error", "Soviel von diesem Item ist nicht vorhanden!")
            end
        else
            uPlayer:showInfoBox("error", "Ungueltige Anzahl!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
    uPlayer:setLoading(false)
end

-- ///////////////////////////////
-- //onPlayerLagerEinheitKauf	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerLagerEinheitKauf(uPlayer, iAnzahl)
    if(self:hasPermissions(uPlayer)) then
        if(iAnzahl) and (iAnzahl > 0) and (iAnzahl <= 1000) then
            local money = uPlayer:getMoney()

            if(money >= (iAnzahl*cCorporationManager:getInstance().m_iCurrentLagerUnitPrice)) then
                local cost = (iAnzahl*cCorporationManager:getInstance().m_iCurrentLagerUnitPrice)
                uPlayer:getCorporation():addLagereinheiten(iAnzahl)
                uPlayer:addMoney(-cost)
                uPlayer:showInfoBox("sucess", "Du hast erfolgreich "..iAnzahl.." Lagereinheiten erworben!")
                self:onPlayerGUIOpen(uPlayer)

                logger:OutputPlayerLog(uPlayer, "Kaufte Lagereinheiten", uPlayer:getCorporation():getName(), iAnzahl);
            end
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
    uPlayer:setLoading(false)
end

-- ///////////////////////////////
-- ///// onPlayerVehicleAdd	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerVehicleAdd(uPlayer, iID)
    if(self:hasPermissions(uPlayer)) then
        if(tonumber(iID)) then
            iID = tonumber(iID)
            local uVehicle      = UserVehicles[iID];
            if(uVehicle) then
                if(uVehicle:getOwnerID() == uPlayer:getID()) then
                    if(uVehicle:isOwnerReachable()) then
                        local sucess    = uPlayer:getCorporation():convertUserVehicleToCorpVehicle(uVehicle);
                        if(sucess) then
                            uPlayer:showInfoBox("sucess", "Corporationsfahrzeug hinzugefuegt!")
                            uPlayer:getCorporation():sendFactionMessage("* "..uPlayer:getName().." hat ein Corporationsfahrzeug hinzugefuegt.", 0, 200, 0)

                            logger:OutputPlayerLog(uPlayer, "Erworb Corporationsfahrzeug", uPlayer:getCorporation():getName(), iID);
                        else
                            uPlayer:showInfoBox("error", "Ein Fehler trat auf: "..tostring(sucess))
                        end
                    else
                        uPlayer:showInfoBox("error", "Du musst dich in der naehe deines Fahrzeuges befinden!")
                    end
                else
                    uPlayer:showInfoBox("error", "Dieses Fahrzeug gehoert dir nicht!")
                end
            else
                uPlayer:showInfoBox("error", "Privatfahrzeug konnte nicht gefunden werden!")
            end
        else
            uPlayer:showInfoBox("error", "Falsche ID!")
        end
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
    uPlayer:setLoading(false)
end

-- ///////////////////////////////
-- ///// onPlayerVehicleSlotAdd 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerVehicleSlotAdd(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local Corp      = Corporations[uPlayer:getCorporation():getID()]
        if(Corp) then
            local cost      = _Gsettings.corporation.vehicleSlotCost[Corp.m_iMaxVehicles+1];
            if(cost) then
                if(uPlayer:getBankMoney() >= cost) then
                    uPlayer:addBankMoney(-cost);
                    Corp.m_iMaxVehicles      = Corp.m_iMaxVehicles+1;
                    Corp:save()
                    Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Fahrzeugupgrade gekauft. Maximale Fahrzeuge: "..Corp.m_iMaxVehicles, 0, 200, 200);
                    uPlayer:showInfoBox("sucess", "Erfolg!")
                    self:onPlayerGUIOpen(uPlayer)
                    logger:OutputPlayerLog(uPlayer, "Erworb Corporationsfahrzeugupgrade", uPlayer:getCorporation():getName(), cost);
                else
                    uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf dem Bankkonto!($"..cost.."");
                end
            else
                uPlayer:showInfoBox("error", "Maximale Anzahl an Fahrzeugen erreicht!")
            end
        else
            uPlayer:showInfoBox("error", "Keine Corporation!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- //onPlayerVehicleRemove 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerVehicleRemove(uPlayer, ID)
    if(self:hasPermissions(uPlayer)) then
        local Corp      = Corporations[uPlayer:getCorporation():getID()]
        if(Corp) then
            if(ID) and (tonumber(ID)) then
                ID = tonumber(ID)
                local uVehicle  = Corp.m_tblVehiclesByID[ID]
                local model     = uVehicle:getModel()
                if(uVehicle) and (isElement(uVehicle)) then
                    local sucess = Corp:removeCorpVehicle(ID);
                    if(sucess) then
                        local preis = global_vehicle_preise[model]
                        if not(preis) then
                            preis = 0;
                        end

                        preis = math.floor(preis/100*50)

                        if(preis > 999999) then
                            preis = 0;
                        end

                        uPlayer:addMoney(preis);

                        uPlayer:showInfoBox("sucess", "Fahrzeug wurde erfolgreich entfernt! Geld erhalten: $"..preis)
                        self:onPlayerGUIOpen(uPlayer)

                        logger:OutputPlayerLog(uPlayer, "Entfernte Corporationsfahrzeugupgrade", uPlayer:getCorporation():getName(), ID);
                    else
                        uPlayer:showInfoBox("error", "Ein Fehler trat auf!")
                    end
                else
                    uPlayer:showInfoBox("error", "Dieses Fahrzeug existiert nicht mehr!")
                end
            else
                uPlayer:showInfoBox("error", "Unbekannte ID!")
            end
        else
            uPlayer:showInfoBox("error", "Keine Corporation!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- //onPlayerSkinChange 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerSkinChange(uPlayer, sRolle)
    if(self:hasPermissions(uPlayer)) then
        local iRole     = _Gsettings.corporation.findRolesFunction(sRolle)
        if(iRole) then
            local model = uPlayer:getModel()
            local corp  = uPlayer:getCorporation()
            corp:setSkin(iRole, model)
            uPlayer:showInfoBox("sucess", "Skin geaendert!")
            self:onPlayerGUIOpen(uPlayer)
            logger:OutputPlayerLog(uPlayer, "Setze Corporationsskin", uPlayer:getCorporation():getName(), iRole, model);
        else
            uPlayer:showInfoBox("error", "Rolle nicht gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- //onPlayerHouseAdd    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerHouseAdd(uPlayer, iHouse)
    if(self:hasPermissions(uPlayer)) then
        if(iHouse) and (tonumber(iHouse)) and (Houses[iHouse]) then
            local House     = Houses[iHouse]
            if(House:getOwnerID() == uPlayer:getID()) then
                if(uPlayer:getCorporation().m_iCurHouses < uPlayer:getCorporation().m_iMaxHouses) then
                    House:setOwnerID(0)
                    House:setCorporation(uPlayer:getCorporation():getID())
                    House:save()
                    local Corp = uPlayer:getCorporation()
                    uPlayer:showInfoBox("sucess", "Dieses Haus ist nun ein Corporationshaus!")
                    Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Corporationshaus hinzugefuegt.", 0, 200, 200);
                    Corp:updateHouses()
                    self:onPlayerGUIOpen(uPlayer)

                    logger:OutputPlayerLog(uPlayer, "Erworb Corporationshaus", uPlayer:getCorporation():getName(), iHouse);
                else
                    uPlayer:showInfoBox("error", "Keine verfuegbaren Haeuserslots mehr frei! Du benoetigst erst ein Upgrade.")
                end
            else
                uPlayer:showInfoBox("error", "Dies ist nicht dein Haus!")
            end
        else
            uPlayer:showInfoBox("error", "Das Haus wurde nicht gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end


-- ///////////////////////////////
-- //onPlayerHouseRemove    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerHouseRemove(uPlayer, iHouse)
    if(self:hasPermissions(uPlayer)) then
        if(iHouse) and (tonumber(iHouse)) and (Houses[tonumber(iHouse)]) then
            local House     = Houses[tonumber(iHouse)]
            if(House:getCorporation()) and (House:getCorporation():getID() == uPlayer:getCorporation():getID()) then
                House:setOwnerID(uPlayer:getID())
                House:setCorporation(0)
                House:save()
                uPlayer:showInfoBox("sucess", "Dieses Haus ist nun wieder ein Privathaus!")
                local Corp = uPlayer:getCorporation()
                Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Corporationshaus entfernt. ", 0, 200, 200);
                Corp:updateHouses()
                self:onPlayerGUIOpen(uPlayer)

                logger:OutputPlayerLog(uPlayer, "Entfertne Corporationshaus", uPlayer:getCorporation():getName(), iHouse);
            else
                uPlayer:showInfoBox("error", "Dies ist nicht dein Haus!")
            end
        else
            uPlayer:showInfoBox("error", "Das Haus wurde nicht gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- ///// onPlayerHouseSlotAdd 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_StorageManager:onPlayerHouseSlotAdd(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local Corp      = Corporations[uPlayer:getCorporation():getID()]
        if(Corp) then
            local cost      = _Gsettings.corporation.houseSlotCost[Corp.m_iMaxHouses+1];
            if(cost) then
                if(uPlayer:getBankMoney() >= cost) then
                    uPlayer:addBankMoney(-cost);
                    Corp.m_iMaxHouses     = Corp.m_iMaxHouses+1;
                    Corp:save()
                    Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Hausupgrade gekauft. Maximale Haeuser: "..Corp.m_iMaxHouses, 0, 200, 200);
                    uPlayer:showInfoBox("sucess", "Erfolg!")
                    self:onPlayerGUIOpen(uPlayer)

                    logger:OutputPlayerLog(uPlayer, "Erworb Corporationshausslot", uPlayer:getCorporation():getName(), cost);
                else
                    uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf dem Bankkonto!($"..cost.."");
                end
            else
                uPlayer:showInfoBox("error", "Maximale Anzahl an Haeuser erreicht!")
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

function cCorporationRole_StorageManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientCorporationStorageManagerOpen", true)
    addEvent("onClientCorporationStorageManagerItemsEinlagern", true)
    addEvent("onClientCorporationStorageManagerItemsAuslagern", true)
    addEvent("onPlayerCorporationLagerEinlager", true)
    addEvent("onPlayerCorporationLagerAuslager", true)
    addEvent("onPlayerCorporationLagerEinheitBuy", true)
    addEvent("onPlayerCorporationVehicleAdd", true)
    addEvent("onPlayerCoroprationsManagementStorageVehicleSlotAdd", true)
    addEvent("onPlayerCoroprationsManagementStorageVehicleRemove", true)
    addEvent("onPlayerCoroprationsManagementStorageSkinChange", true)
    addEvent("onPlayerCoroprationsManagementStorageHouseAdd", true)
    addEvent("onPlayerCoroprationsManagementStorageHouseRemove", true)
    addEvent("onPlayerCoroprationsManagementStorageHouseSlotAdd", true)

    -- Funktionen --
    self.m_funcOnPlayerGuiOpen      = function(...) self:onPlayerGUIOpen(client, ...) end
    self.m_funcOnItemsEinlagern     = function(...) self:onItemsEinlagern(client, ...) end
    self.m_funcOnItemsAuslagern     = function(...) self:onItemsAuslagern(client, ...) end
    self.m_funcOnItemEinlagerFinish = function(...) self:onItemEinlagerFinish(client, ...) end
    self.m_funcOnItemAuslagerFinish = function(...) self:onItemAuslagerFinish(client, ...) end
    self.m_funcOnLagerEinheitKauf   = function(...) self:onPlayerLagerEinheitKauf(client, ...) end
    self.m_funcOnVehicleAdd         = function(...) self:onPlayerVehicleAdd(client, ...) end
    self.m_funcOnVehicleSlotAdd     = function(...) self:onPlayerVehicleSlotAdd(client, ... ) end
    self.m_funcOnVehicleRemove      = function(...) self:onPlayerVehicleRemove(client, ...) end
    self.m_funcOnSkinChange         = function(...) self:onPlayerSkinChange(client, ...) end
    self.m_funcOnHouseAdd           = function(...) self:onPlayerHouseAdd(client, ...) end
    self.m_funcOnHouseRemove        = function(...) self:onPlayerHouseRemove(client, ...) end
    self.m_funcOnHouseSlotAdd       = function(...) self:onPlayerHouseSlotAdd(client, ...) end

    -- Events --
    addEventHandler("onClientCorporationStorageManagerOpen", getRootElement(), self.m_funcOnPlayerGuiOpen)
    addEventHandler("onClientCorporationStorageManagerItemsEinlagern", getRootElement(), self.m_funcOnItemsEinlagern)
    addEventHandler("onClientCorporationStorageManagerItemsAuslagern", getRootElement(), self.m_funcOnItemsAuslagern)
    addEventHandler("onPlayerCorporationLagerEinlager", getRootElement(), self.m_funcOnItemEinlagerFinish)
    addEventHandler("onPlayerCorporationLagerAuslager", getRootElement(), self.m_funcOnItemAuslagerFinish)
    addEventHandler("onPlayerCorporationLagerEinheitBuy", getRootElement(), self.m_funcOnLagerEinheitKauf)
    addEventHandler("onPlayerCorporationVehicleAdd", getRootElement(), self.m_funcOnVehicleAdd)
    addEventHandler("onPlayerCoroprationsManagementStorageVehicleSlotAdd", getRootElement(), self.m_funcOnVehicleSlotAdd)
    addEventHandler("onPlayerCoroprationsManagementStorageVehicleRemove", getRootElement(), self.m_funcOnVehicleRemove)
    addEventHandler("onPlayerCoroprationsManagementStorageSkinChange", getRootElement(), self.m_funcOnSkinChange)
    addEventHandler("onPlayerCoroprationsManagementStorageHouseAdd", getRootElement(), self.m_funcOnHouseAdd)
    addEventHandler("onPlayerCoroprationsManagementStorageHouseRemove", getRootElement(), self.m_funcOnHouseRemove)
    addEventHandler("onPlayerCoroprationsManagementStorageHouseSlotAdd", getRootElement(), self.m_funcOnHouseSlotAdd)

end

-- EVENT HANDLER --
