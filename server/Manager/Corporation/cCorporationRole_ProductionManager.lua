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

cCorporationRole_ProductionManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// hasPermissions 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:hasPermissions(uPlayer)
    if(uPlayer:getCorporation() ~= 0) and (uPlayer:hasCorpRole(6)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:onPlayerGUIOpen(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local id            = uPlayer:getCorporation():getID();
        uPlayer:getCorporation():updateBizes();
        triggerClientEvent(uPlayer, "onClientPlayerCorporationProductionManagementGUIRefresh", uPlayer, uPlayer:getCorporation(), uPlayer:getCorporation():getBizes())
    else
        uPlayer:showInfoBox("error", "Dir fehlen die benoetigten Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:onPlayerBizAdd(uPlayer, iBizID)
    iBizID = tonumber(iBizID)
    if(self:hasPermissions(uPlayer)) and (uPlayer:hasCorpRole(1)) then
        if(iBizID) and (tonumber(iBizID)) and (cBusinessManager:getInstance().m_uBusiness[iBizID]) then
            local biz     = cBusinessManager:getInstance().m_uBusiness[iBizID]
            if(biz:getOwnerID() == 0) then
                if(uPlayer:getCorporation().m_iCurBizes < uPlayer:getCorporation().m_iMaxBizes) then
                    if(uPlayer:getBankMoney() >= biz.m_iCost) then
                        if(biz.m_iLocked ~= 1) then
                            biz:setOwner(uPlayer:getCorporation():getID())
                            biz:setLagereinheiten(0)
                            biz:save()
                            local Corp = uPlayer:getCorporation()
                            uPlayer:showInfoBox("sucess", "Business erworben! Achte darauf, dass sich immer genug Lagereinheiten im Bestand befinden.")
                            Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Business hinzugefuegt.", 0, 200, 200);
                            Corp:updateBizes()
                            self:onPlayerGUIOpen(uPlayer)

                            uPlayer:addBankMoney(-biz.m_iCost)

                            logger:OutputPlayerLog(uPlayer, "Kaufte Business", uPlayer:getCorporation():getName(), biz.m_iID, "$"..biz.m_iCost);

                            Corp:addStatus(5);
                        else
                            uPlayer:showInfoBox("error", "Dieses Business kannst du nicht kaufen!")
                        end
                    else
                        uPlayer:showInfoBox("error", "Soviel Geld besitzt du nicht auf der Bank!")
                    end
                else
                    uPlayer:showInfoBox("error", "Keine verfuegbaren Businessslots mehr frei! Du benoetigst erst ein Upgrade.")
                end
            else
                uPlayer:showInfoBox("error", "Dieses Business wurde bereits erworben!")
            end
        else
            uPlayer:showInfoBox("error", "Das Business wurde nicht gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Keine Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:onPlayerBizRemove(uPlayer, iBizID)
    iBizID = tonumber(iBizID)
    if(self:hasPermissions(uPlayer)) and (uPlayer:hasCorpRole(1)) then
        if(iBizID) and (tonumber(iBizID)) and (cBusinessManager:getInstance().m_uBusiness[iBizID]) then
            local biz     = cBusinessManager:getInstance().m_uBusiness[iBizID]
            if(biz:getOwnerID() == uPlayer:getCorporation():getID()) then

                local geld      = math.floor(biz.m_iCost)*0.80;
                uPlayer:addBankMoney(geld);

                biz:setOwner(0)
                biz:save()
                local Corp = uPlayer:getCorporation()
                uPlayer:showInfoBox("sucess", "Business verkauft. Du hast $"..geld.." erhalten!")
                Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Business entfernt.", 0, 200, 200);
                Corp:updateBizes()
                self:onPlayerGUIOpen(uPlayer)

                logger:OutputPlayerLog(uPlayer, "Verkaufte Business", uPlayer:getCorporation():getName(), biz.m_iID, "$"..geld);
                Corp:addStatus(-2);
            else
                uPlayer:showInfoBox("error", "Dieses Business gehoert nicht deiner Corporation!")
            end
        else
            uPlayer:showInfoBox("error", "Das Business wurde nicht gefunden!")
        end
    else
        uPlayer:showInfoBox("error", "Du hast keine Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:onPlayerBizSlotAdd(uPlayer)
    if(self:hasPermissions(uPlayer)) then
        local Corp      = Corporations[uPlayer:getCorporation():getID()]
        if(Corp) then
            local cost      = _Gsettings.corporation.businessSlotCost[Corp.m_iMaxBizes+1];
            if(cost) then
                if(uPlayer:getBankMoney() >= cost) then
                    uPlayer:addBankMoney(-cost);
                    Corp.m_iMaxBizes     = Corp.m_iMaxBizes+1;
                    Corp:save()
                    Corp:sendFactionMessage("* "..uPlayer:getName().." hat ein Businessupgrade gekauft. Maximale Bizes: "..Corp.m_iMaxBizes, 0, 200, 200);
                    uPlayer:showInfoBox("sucess", "Erfolg!")
                    self:onPlayerGUIOpen(uPlayer)
                    logger:OutputPlayerLog(uPlayer, "Kaufte Businessupgrade", uPlayer:getCorporation():getName());
                else
                    uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf dem Bankkonto!($"..cost.."");
                end
            else
                uPlayer:showInfoBox("error", "Maximale Anzahl an Bizes erreicht!")
            end
        else
            uPlayer:showInfoBox("error", "Keine Corporation!")
        end
    else
        uPlayer:showInfoBox("error", "Du hast keine Rechte!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cCorporationRole_ProductionManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onClientCorporationProductionManagerOpen", true)
    addEvent("onPlayerCoroprationsManagementProductionBusinessAdd", true)
    addEvent("onPlayerCoroprationsManagementProductionBusinessRemove", true)
    addEvent("onPlayerCoroprationsManagementProductionBusinessSlotAdd", true)

    -- Funktionen --
    self.m_funcOnPlayerGuiOpen      = function(...) self:onPlayerGUIOpen(client, ...) end
    self.m_funcOnPlayerBizAdd       = function(...) self:onPlayerBizAdd(client, ...) end
    self.m_funcOnPlayerBizRemove    = function(...) self:onPlayerBizRemove(client, ...) end
    self.m_funcOnPlayerBizSlotAdd   = function(...) self:onPlayerBizSlotAdd(client, ...) end

    -- Events --
    addEventHandler("onClientCorporationProductionManagerOpen", getRootElement(), self.m_funcOnPlayerGuiOpen)
    addEventHandler("onPlayerCoroprationsManagementProductionBusinessAdd", getRootElement(), self.m_funcOnPlayerBizAdd)
    addEventHandler("onPlayerCoroprationsManagementProductionBusinessRemove", getRootElement(), self.m_funcOnPlayerBizRemove)
    addEventHandler("onPlayerCoroprationsManagementProductionBusinessSlotAdd", getRootElement(), self.m_funcOnPlayerBizSlotAdd)

end

-- EVENT HANDLER --
