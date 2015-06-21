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
-- Date: 12.02.2015
-- Time: 14:32
-- To change this template use File | Settings | File Templates.
--

cMarketManager = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// updateItems         //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:updateItems()
    self.m_tblItems             = fromJSON(toJSON(CDatabase:getInstance():query("SELECT * FROM item;"), false), "\\", ""); -- Frag mich nicht
    self.m_tblCategories        = CDatabase:getInstance():query("SELECT * FROM item_category;");
    -- SELECT u.Name as Name, ma.* FROM market_angebote ma JOIN user u on ma.PlayerID = u.ID WHERE ma.ItemID = ?;
    self.m_tblLastAngebote      = CDatabase:getInstance():query("SELECT u.Name as Name, ma.* FROM market_angebote ma JOIN user u on PlayerID = u.ID WHERE ma.AngebotType = 1 ORDER BY StartTimestamp DESC LIMIT 25;")
    self.m_tblCountAngebote     = CDatabase:getInstance():query("SELECT COUNT(*) AS C1 FROM market_angebote WHERE AngebotType = 1;")
    self.m_tblCountAnfragen     = CDatabase:getInstance():query("SELECT COUNT(*) AS C1 FROM market_angebote WHERE AngebotType = 2;")

    self.m_iStartTick           = getTickCount();
    outputDebugString("Updated Market Items");
end

-- ///////////////////////////////
-- ///// onItemsRequest     //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onItemsRequest(uPlayer)
    if(getTickCount()-self.m_iStartTick > 60000) then
        self:updateItems()
    end

    local tbl_angebote          = CDatabase:getInstance():query("SELECT * FROM market_angebote WHERE PlayerID = ?;", uPlayer:getID())

    triggerLatentClientEvent(uPlayer, "onClientPlayerMarketItemsReceive", 500000, false, uPlayer,
    self.m_tblItems, self.m_tblCategories, self.m_tblLastAngebote, self.m_tblCountAngebote, self.m_tblCountAnfragen,
    tbl_angebote)
end

-- ///////////////////////////////
-- ///// onItemAngeboteRequest////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onItemAngeboteRequest(uPlayer, iItemID)
   -- local result                = CDatabase:getInstance():query("SELECT * FROM market_angebote WHERE ItemID = ?;", iItemID);
    local result                = CDatabase:getInstance():query("SELECT u.Name as Name, ma.* FROM market_angebote ma JOIN user u on ma.PlayerID = u.ID WHERE ma.ItemID = ?;", iItemID);
    local result2               = CDatabase:getInstance():query("SELECT ma.PlayerID as Name, ma.* FROM market_angebote ma WHERE ma.ItemID = ? AND ma.PlayerID = ?;", iItemID, uPlayer:getID());

    local countTBL              = {}
    for i = 1, 7, 1 do
        local startTime             = getRealTime().timestamp;
        local result3               = CDatabase:getInstance():query("SELECT * FROM market_purchases WHERE ItemID = ? AND StartTimestamp > ? AND StartTimestamp < ?;", iItemID, startTime-((86400)*i), startTime-((86400)*(i-1)));
    --    outputChatBox(startTime..", "..startTime-((84400)*i)..", "..startTime-((84400)*(i+1)))
        if not(countTBL[i]) then
            countTBL[i] = 0;
        end
        if(result3) then
            for row, tbl in pairs(result3) do
                countTBL[i] = countTBL[i]+tonumber(tbl['Count']);
     --           outputChatBox(tonumber(tbl['Count']))
            end
        end
    end


    triggerLatentClientEvent(uPlayer, "onClientPlayerMarketItemAngeboteReceive", 500000, false, uPlayer, result, result2, countTBL)
end

-- ///////////////////////////////
-- ///// AngebotNachfrage	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onPlayerAngebotNachfrage(uPlayer, iItemID, iAnzahl, iPreis)
    if(tonumber(iItemID)) and (tonumber(iAnzahl)) and (tonumber(iPreis)) then

        local mPreis            = iPreis
        local money             = uPlayer:getBankMoney()

        if(money >= mPreis*iAnzahl) then
            local result             = CDatabase:getInstance():query("INSERT INTO market_angebote (ItemID, AngebotType, PlayerID, Anzahl, Preis, StartTimestamp) VALUES (?, ?, ?, ?, ?, ?);", iItemID, 2, uPlayer:getID(), iAnzahl, mPreis, getRealTime().timestamp);

            if(result) then
                uPlayer:addBankMoney(-(mPreis*iAnzahl))
                uPlayer:showInfoBox("sucess", "Nachfrageangebot erfolgreich erstellt.\n-$"..mPreis);

                logger:OutputPlayerLog("Stellte Nachfrage in Markt", "Item: "..iItemID, "Anzahl: "..iAnzahl, "Preis:"..iPreis)
                uPlayer:incrementStatistics("Markt", "Nachfrageangebote erstellt", 1)
            else
                uPlayer:showInfoBox("error", "Fehler bei dem erstellen des Angebots! Datenbankfehler.")
            end
        else
            uPlayer:showInfoBox("error", "Du hast nicht genug Geld auf dem Konto! Du benoetigst $"..money-mPreis.." mehr!");
        end
    end
    self:onItemAngeboteRequest(uPlayer, iItemID);
end

-- ///////////////////////////////
-- ///// onPlayerAngebotRemove
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onPlayerAngebotRemove(uPlayer, iAngebotID)
    if(tonumber(iAngebotID)) then
        local result             = CDatabase:getInstance():query("SELECT * FROM market_angebote WHERE AngebotID = ?;", iAngebotID);

        if(result) and (#result > 0) then
            local playerID      = tonumber(result[1]['PlayerID'])
            if(playerID == uPlayer:getID()) then
                local result2   = CDatabase:getInstance():query("DELETE FROM market_angebote WHERE AngebotID = ?;", iAngebotID);
                if(result2) or true  then
                    local itemID    = tonumber(result[1]['ItemID']);
                    local anzahl    = tonumber(result[1]['Anzahl']);
                    local preis     = tonumber(result[1]['Preis'])
                    local type      = tonumber(result[1]['AngebotType'])

                    if(type == 1) then      -- Angebot
                        if(anzahl < 5) then
                            anzahl = anzahl
                        else
                            anzahl = math.floor(anzahl*self.m_iRueckgabeMultiplier);
                        end
                        uPlayer:getInventory():addItem(Items[itemID], anzahl, true)
                        uPlayer:showInfoBox("sucess", "Du hast "..anzahl.." von deinem Angebot erhalten!");
                    elseif(type == 2) then      -- Nachfrage
                        local rueckgabe = math.floor((preis*anzahl)*self.m_iRueckgabeMultiplier);
                        uPlayer:addBankMoney(rueckgabe)
                        uPlayer:showInfoBox("sucess", "Du hast $"..rueckgabe.." von deinem Angebot erhalten!");
                    end

                    logger:OutputPlayerLog(uPlayer, "Entfernte Nachfrage in Markt", "AngebotID: "..iAngebotID)
                    uPlayer:incrementStatistics("Markt", "Angebote entfernt", 1)
                end
            else
                uPlayer:showInfoBox("error", "Dieses Angebot gehoert dir nicht!")
            end
        else
            uPlayer:showInfoBox("error", "Dieses Angebot existiert nicht mehr!")
        end
    end
    self:onItemAngeboteRequest(uPlayer, itemID);
end

-- ///////////////////////////////
-- ///// AngebotErstelle	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onPlayerAngebotErstelle(uPlayer, iItemID, iAnzahl, iPreis)
    if(tonumber(iItemID)) and ((tonumber(iAnzahl)) or iAnzahl == "all") and (tonumber(iPreis)) then
        if(iAnzahl == "all") then
            iAnzahl = tonumber(uPlayer:getInventory():getCount(Items[tonumber(iItemID)]))
        end
        if(iAnzahl > 0) then
            local mPreis            = iPreis;
            local curHave           = uPlayer:getInventory():getCount(Items[tonumber(iItemID)])

            if(curHave >= iAnzahl) then
                local result             = CDatabase:getInstance():query("INSERT INTO market_angebote (ItemID, AngebotType, PlayerID, Anzahl, Preis, StartTimestamp) VALUES (?, ?, ?, ?, ?, ?);", iItemID, 1, uPlayer:getID(), iAnzahl, mPreis, getRealTime().timestamp);

                if(result) then
                    uPlayer:getInventory():removeItem(Items[tonumber(iItemID)], iAnzahl)
                    uPlayer:showInfoBox("sucess", "Angebot erfolgreich erstellt.");

                    uPlayer:incrementStatistics("Markt", "Angebote erstellt", 1)
                    logger:OutputPlayerLog(uPlayer, "Stellte Angebot in Markt", "Item: "..iItemID, "Anzahl: "..iAnzahl, "Preis:"..iPreis)


                    if(uPlayer:getStatistics("Markt", "Angebote erstellt") >= 1) then
                        Achievements[138]:playerAchieved(uPlayer)
                        if(uPlayer:getStatistics("Markt", "Angebote erstellt") >= 100) then
                            Achievements[140]:playerAchieved(uPlayer)
                        end
                    end
                else
                    uPlayer:showInfoBox("error", "Fehler bei dem erstellen des Angebots! Datenbankfehler.")
                end
            else
                uPlayer:showInfoBox("error", "Du hast nicht genug von diesem Item!");
            end
        else
            uPlayer:showInfoBox("error", "Du hast nicht genug von diesem Item!");
        end
    end
    self:onItemAngeboteRequest(uPlayer, iItemID);
end

-- ///////////////////////////////
-- ///// deleteAngebot       /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:deleteAngebot(iID)
    if(CDatabase:getInstance():query("DELETE FROM market_angebote WHERE AngebotID = ?", iID)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// updateAngebot       /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:updateAngebot(iID, iAnzahl)
    if(CDatabase:getInstance():query("UPDATE market_angebote SET Anzahl = ? WHERE AngebotID = ?", iAnzahl, iID)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// addVerkaufStats    /////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:addVerkaufStats(iItemID, iAnzahl, sPlayerName)
    if(CDatabase:getInstance():query("INSERT INTO market_purchases (ItemID, StartTimestamp, PurchasedBy, Count) VALUES (?, ?, ?, ?);", iItemID, getRealTime().timestamp, sPlayerName, iAnzahl)) then
        return true;
    else
        return false;
    end
end

-- ///////////////////////////////
-- ///// onPlayerItemPurcahse/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:onPlayerItemPurchase(uPlayer, iAngebotID, iItemID, iAnzahl)
    uPlayer:setLoading(false)
    iItemID     = tonumber(iItemID);
    iAngebotID  = tonumber(iAngebotID);
    iAnzahl     = tonumber(iAnzahl);

    if(iAnzahl) and (iAnzahl > 0) and (iAnzahl < 999999999) then

        if(iItemID) then
            local result    = CDatabase:getInstance():query("SELECT * FROM market_angebote WHERE AngebotID = ? AND ItemID = ?;", iAngebotID, iItemID);
            if(result) and (#result > 0) then
                local angebotType   = tonumber(result[1]['AngebotType'])
                local money         = tonumber(result[1]['Preis']);
                local anzahl        = tonumber(result[1]['Anzahl']);
                local iPlayerID2    = tonumber(result[1]['PlayerID']);

                if(iAnzahl > anzahl) then   -- Die Wunderzeile, oooOOooooOOooooOoo
                    iAnzahl = anzahl
                end

                local purchaseMoney       = math.floor((money*iAnzahl)*0.9);
                local money               = money*iAnzahl;

                if(angebotType == 1) then           -- Angebot
                    if(uPlayer:getBankMoney() >= money) then
                        local uPlayer2      = getOfflinePlayer(iPlayerID2)
                        if(uPlayer2) then
                            local uPlayer2Name  = uPlayer2.Name;
                            local all = true;
                            if(iAnzahl >= anzahl) then
                                self:deleteAngebot(iAngebotID);
                            else
                                self:updateAngebot(iAngebotID, anzahl-iAnzahl)
                                all = false;
                            end

                            uPlayer2:addBankMoney(purchaseMoney);
                            uPlayer2:save()

                            uPlayer:addBankMoney(-money);
                            uPlayer:getInventory():addItem(Items[iItemID], iAnzahl, true)
                            uPlayer:save();

                            uPlayer:showInfoBox("sucess", "Du hast diese Items erfolgreich gekauft!\n-$"..money);
                            uPlayer:incrementStatistics("Markt", "Items gekauft", iAnzahl)

                            if(uPlayer:getStatistics("Markt", "Items gekauft") >= 500) then
                                Achievements[139]:playerAchieved(uPlayer)
                            end
                            local string2 = "Jemand hat dein Angebot Nr. "..iAngebotID.." ("..Items[iItemID]:getName()..") angenommen!\n+$"..purchaseMoney..", Anzahl: "..anzahl;
                            if(uPlayer2) and (uPlayer2.Online) then
                                uPlayer2:showInfoBox("sucess", string2);
                                if(all == false) then
                                    outputChatBox("Statusbericht: In deinem Angebot ("..Items[iItemID]:getName()..") sind noch "..anzahl-iAnzahl.." Items vorhanden.", uPlayer2, 0, 200, 0);
                                end
                            else
                                offlineMSGManager:AddOfflineMSG(uPlayer2.Name, string2)
                            end

                            self:addVerkaufStats(iItemID, iAnzahl, uPlayer:getName());
                        else
                            uPlayer:showInfoBox("error", "Offline Spieler nicht gefunden, Datenbankfehler");
                        end
                    else
                        uPlayer:showInfoBox("error", "Du benoetigst mehr Geld auf der Bank!");
                    end

                --[[
                    if(uPlayer:getBankMoney() >= money) then
                        local uPlayer2      = getOfflinePlayer(iPlayerID2)
                        if(uPlayer2) then
                            self:deleteAngebot(iAngebotID);

                            uPlayer2:addBankMoney(purchaseMoney);
                            uPlayer2:save()

                            uPlayer:addBankMoney(-money);
                            uPlayer:getInventory():addItem(Items[iItemID], anzahl)
                            uPlayer:save();

                            uPlayer:showInfoBox("sucess", "Du hast das Angebot erfolgreich angenommen!\n-$"..money);
                            if(uPlayer2) and (uPlayer2.Online) then
                                uPlayer2:showInfoBox("sucess", "Jemand hat dein Angebot Nr. "..iAngebotID.." angenommen!\n+$"..purchaseMoney);
                            end
                        else
                            uPlayer:showInfoBox("error", "Offline Spieler nicht gefunden, Datenbankfehler");
                        end
                    else
                        uPlayer:showInfoBox("error", "Du benoetigst mehr Geld auf der Bank!");
                    end]]

                elseif(angebotType == 2) then       -- Nachfrage
                --[[
                    local sellCount = 0;
                    if(uPlayer:getInventory():getCount(Item[iItemID]) >= anzahl) then
                        sellCount = anzahl;
                    else
                        sellCount = uPlayer:getInventory():getCount(Item[iItemID]);
                    end]]

                    local vorhanden = uPlayer:getInventory():getCount(Items[iItemID]);
                    if(iAnzahl > vorhanden) then
                        iAnzahl = vorhanden;
                    end
                    if(iAnzahl > 0) then
                        local uPlayer2      = getOfflinePlayer(iPlayerID2)
                        if(uPlayer2) then
                            local uPlayer2Name  = uPlayer2.Name;
                            local all = true;
                            if(iAnzahl >= anzahl) then
                                self:deleteAngebot(iAngebotID);
                            else
                                self:updateAngebot(iAngebotID, anzahl-iAnzahl)
                                all = false;
                            end

                            uPlayer2:getInventory():addItem(Items[iItemID], iAnzahl, true)
                            uPlayer2:save()

                            uPlayer:addBankMoney(purchaseMoney);
                            uPlayer:getInventory():removeItem(Items[iItemID], iAnzahl)
                            uPlayer:save();

                            uPlayer:showInfoBox("sucess", "Du hast dieses Angebot angenommen.\n-$"..money);
                            uPlayer:incrementStatistics("Markt", "Items verkauft", iAnzahl)

                            local string2 = "Jemand hat dein Angebot Nr. "..iAngebotID.." angenommen!\n+ "..anzahl.." "..Items[iItemID]:getName()
                            if(uPlayer2) and (uPlayer2.Online) then
                                uPlayer2:showInfoBox("sucess", string2); if(all == false) then
                                    outputChatBox("Statusbericht: In deinem Angebot sind noch "..anzahl-iAnzahl.." Items vorhanden.", uPlayer2, 0, 200, 0);
                                end
                            else
                                offlineMSGManager:AddOfflineMSG(uPlayer2.Name, string2)
                            end


                        else
                            uPlayer:showInfoBox("error", "Offline Spieler nicht gefunden, Datenbankfehler");
                        end
                    else
                        uPlayer:showInfoBox("error", "Ungueltige Anzahl!");
                    end
                end
            else
                uPlayer:showInfoBox("error", "Dieses Angebot existiert nicht mehr. Eventuell wurde es schon abgeschlossen.");
            end
        else
            uPlayer:showInfoBox("error", "Item nicht gefunden.")
        end
    else
        uPlayer:showInfoBox("error", "Ungueltige Anzahl!");
    end

    self:onItemAngeboteRequest(uPlayer, iItemID);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onPlayerMarketItemsReqeust", true)
    addEvent("onPlayerMarketItemAngeboteReqeust", true)
    addEvent("onPlayerMarketAngebotNachfrage", true)
    addEvent("onPlayerMarketAngebotAnbiete", true)
    addEvent("onPlayerMarketVorhandenesAngebotRemove", true)
    addEvent("onPlayerMarketItemAngebotPurchase", true);

    self.m_iStartTick                   = 0;
    self.m_tblItems                     = {}
    self.m_tblCategories                = {}

    self.m_iRueckgabeMultiplier         = 0.75;         -- Rueckgabewert, 0 - 1

    -- Funktionen --
    self.m_funcRequestPlayerItems       = function(...) self:onItemsRequest(client, ...) end
    self.m_funcRequestItemAngebote      = function(...) self:onItemAngeboteRequest(client, ...) end
    self.m_funcAngebotNachfrageErstellen= function(...) self:onPlayerAngebotNachfrage(client, ...) end
    self.m_funcAngebotErstellen         = function(...) self:onPlayerAngebotErstelle(client, ...) end
    self.m_funcVorhandenesAngebotEntfernen  = function(...) self:onPlayerAngebotRemove(client, ...) end
    self.m_funcPlayerItemAngebotPurchase= function(...) self:onPlayerItemPurchase(client, ...) end
    -- Events --
    addEventHandler("onPlayerMarketItemsReqeust", getRootElement(), self.m_funcRequestPlayerItems)
    addEventHandler("onPlayerMarketItemAngeboteReqeust", getRootElement(), self.m_funcRequestItemAngebote)
    addEventHandler("onPlayerMarketAngebotNachfrage", getRootElement(), self.m_funcAngebotNachfrageErstellen)
    addEventHandler("onPlayerMarketAngebotAnbiete", getRootElement(), self.m_funcAngebotErstellen)
    addEventHandler("onPlayerMarketVorhandenesAngebotRemove", getRootElement(), self.m_funcVorhandenesAngebotEntfernen)
    addEventHandler("onPlayerMarketItemAngebotPurchase", getRootElement(), self.m_funcPlayerItemAngebotPurchase)
end

-- EVENT HANDLER --
