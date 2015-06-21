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
-- Date: 05.02.2015
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cInventoryGUI = inherit(cSingleton);

--[[

]]

InventoryData = {}

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:show(...)
    if not(self.enabled) and not(clientBusy) then
        self:createElements(...)
        self.enabled = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:createElements(iFaction, sType, iID)
    if not(self.guiEle["window"]) then

        local X, Y = 600, 415

        self.m_sInventoryType       = "player"
        self.m_iFactionID           = false;
        self.m_iCurrentUservehicle  = false;

        if(tonumber(iFaction)) then
            self.m_iFactionID       = iFaction;
            self.m_sInventoryType   = sType
        end
        local validTypes    = {["player"] = true, ["uservehicle"] = true, ["corporationstore"] = true, ["corporationvehicle"] = true}
        if(sType) and (validTypes[sType]) then
            self.m_sInventoryType = sType;

            if(sType == "uservehicle") or (sType == "corporationstore") or (sType == "corporationvehicle") then
    			self.m_iCurrentUservehicle = (iID);
    		end
        end

        self.guiEle["window"] 	             = new(CDxWindow, "Inventar", X, Y, true, true, "Center|Middle", 0, 0, {tocolor(155, 25, 155, 255), "res/images/dxGui/misc/icons/inventory.png", "Inventar"})
        self.guiEle["window"].xtraHide          = function(...)
            self:hide(...)
            if(self.m_sInventoryType == "uservehicle") or (self.m_sInventoryType == "corporationvehicle") then
                triggerServerEvent("onPlayerKofferaumFinished", localPlayer, self.m_iCurrentUservehicle, self.m_sInventoryType)
            end
        end
        self.guiEle["label1"]                = new(CDxLabel, "Dies ist ein Inventar. Hier kannst du vorhandenen Items verwalten.", 5, 5, 400, 20, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        self.guiEle["edit_suche"]           = new(CDxEdit, "Suche...", 5, 370, 170, 20, "text", tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["progressbar"]          = new(CDxProgressbar, 0.0, 420, 5, 170, 20, tocolor(255, 255, 255, 255), self.guiEle["window"], "0 / 0 kg")

        self.guiEle["list1"]                = new(CDxList, 5, 5+30, 170, 280+50, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list1"]:addColumn("Kategorie")

        self.guiEle["list2"]                = new(CDxList, 180, 5+30, 410, 180, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list2"]:addColumn("Icon", true)
        self.guiEle["list2"]:addColumn("Item", false)
        self.guiEle["list2"]:addColumn("Anzahl", false)
        self.guiEle["list2"]:addColumn("Gewicht", false)


        self.guiEle["list2"]:addClickFunction(function()
            local sString       = self.guiEle["list2"]:getRowData(2);
            if(sString ~= "nil") then
                self:updateClickedItemValues(sString)
            end
        end)


        self.guiEle["edit_suche"]:addClickFunction(function()
            if(self.guiEle["edit_suche"]:getText() == "Suche...") then
                self.guiEle["edit_suche"]:setText("")
            end

        end)


        self.guiEle["edit_suche"]:addEditFunction(function()
            self:doEditSearchFunction()
        end)

        self.guiEle["image1"]               = new(CDxImage, 190, 200+25, 64+32, 64+32, "res/images/none.png", tocolor(255, 255, 255, 255), self.guiEle["window"]);

        self.guiEle["label_desc"]           = new(CDxLabel, "Sample Text 420 Blaze It", 305, 225, 290, 130, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        self.guiEle["button1"]              = new(CDxButton, "Benutzen", 185, 335, 120, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]);
        self.guiEle["button2"]              = new(CDxButton, "Wegwerfen", 155+160, 335, 120, 30, tocolor(255, 255, 255, 255), self.guiEle["window"]);
        self.guiEle["button3"]              = new(CDxButton, "Im Markt anzeigen", 210, 368, 200, 25, tocolor(255, 255, 255, 255), self.guiEle["window"]);

        if(self.m_iFactionID == 1) then
            self.guiEle["button1"]:setText("Einlagern")
        elseif(self.m_iFactionID == 2) then
            self.guiEle["button1"]:setText("Herausholen")
        end

        self.guiEle["button1"]:addClickFunction(function()
            self:doButtonUse()
        end)

        self.guiEle["button2"]:addClickFunction(function()
            self:doButtonThrowAway()
        end)

        self.guiEle["button3"]:addClickFunction(function()
            self:doButtonWatchInMarket()
        end)

        self.guiEle["button1"]:setDisabled(true)
        self.guiEle["button2"]:setDisabled(true)
        self.guiEle["button3"]:setDisabled(true)

        self.guiEle["list1"]:addClickFunction(function()
            local kat       = self.guiEle["list1"]:getRowData(1)

            if(kat ~= "nil") then
                self:refreshClickedItems(kat)
            end
        end)
        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();
    end
end
-- ///////////////////////////////
-- /////deactivateForInput        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:deactivateForInput()
    self.guiEle["list1"]:setDisabled(true)
    self.guiEle["list2"]:setDisabled(true)
end

-- ///////////////////////////////
-- /////activateForInput        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:activateForInput()
    self.guiEle["list1"]:setDisabled(false)
    self.guiEle["list2"]:setDisabled(false)
end


-- ///////////////////////////////
-- /////doButtonUse        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:doButtonUse()
    local itemName  = self.guiEle["list2"]:getRowData(2)
    if(itemName == "nil") then itemName = self.m_sCurrentSelectedItem or "nil" end
    local maxCount     = tonumber(self.guiEle["list2"]:getRowData(3))
    if(itemName ~= "nil") then
        local iID = self.m_tblItemNames[itemName];
        if(self.m_sInventoryType == "player") then
            triggerServerEvent("onPlayerUseItem", localPlayer, self.m_tblItemNames[itemName])
        else
            self:deactivateForInput()

            local function ja()
                self:activateForInput()
                local iCount    = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(iCount) and (iCount > 0) and (iCount <= maxCount) then
                    if(self.m_sInventoryType == "uservehicle") or (self.m_sInventoryType == "corporationvehicle") then
                        if(self.m_iFactionID == 1) then
                            triggerServerEvent("onPlayerKofferaumDepositItem", getLocalPlayer(), self.m_iCurrentUservehicle, self.m_tblItemNames[itemName], iCount, self.m_sInventoryType)
                        elseif(self.m_iFactionID == 2) then
                            triggerServerEvent("onPlayerKofferaumWithdrawItem", getLocalPlayer(), self.m_iCurrentUservehicle, self.m_tblItemNames[itemName], iCount, self.m_sInventoryType)
                        end

                    elseif(self.m_sInventoryType == "corporationstore") then
                        if(self.m_iFactionID == 1) then
                            triggerServerEvent("onPlayerCorporationLagerEinlager", getLocalPlayer(), self.m_iCurrentUservehicle, self.m_tblItemNames[itemName], iCount)
                        elseif(self.m_iFactionID == 2) then
                            triggerServerEvent("onPlayerCorporationLagerAuslager", getLocalPlayer(), self.m_iCurrentUservehicle, self.m_tblItemNames[itemName], iCount)
                        end

                    else
                        if(self.m_iFactionID == 1) then
                            triggerServerEvent("onPlayerFactionDepositItem", getLocalPlayer(), self.m_tblItemNames[itemName], iCount)
                        elseif(self.m_iFactionID == 2) then
                            triggerServerEvent("onPlayerFactionWithdrawItem", getLocalPlayer(), self.m_tblItemNames[itemName], iCount)
                        end
                    end
                else
                    showInfoBox("error", "Ungueltige Anzahl!")
                end

            end

            local function nein()
                self:activateForInput()
            end

            confirmDialog:showConfirmDialog("Wieviel von diesem Item moechtest du "..self.guiEle["button1"]:getText():lower().."?", ja, nein, true, true, false)
        end
    else
        showInfoBox("error", "Du musst ein Item auwaehlen!")
    end
end


-- ///////////////////////////////
-- /////doButtonThrowAway        //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:doButtonThrowAway()
    local itemName      = self.guiEle["list2"]:getRowData(2)
    local maxCount     = tonumber(self.guiEle["list2"]:getRowData(3))
    if(itemName == "nil") then itemName = self.m_sCurrentSelectedItem or "nil" end
    if(itemName ~= "nil") then
        if(self.m_sInventoryType == "player") then
            self:deactivateForInput()
            local function ja()
                self:activateForInput()
                local iCount    = tonumber(confirmDialog.guiEle["edit"]:getText())
                if(iCount) and (iCount > 0) and (iCount <= maxCount) then
                    triggerServerEvent("onPlayerDeleteItem", localPlayer, self.m_tblItemNames[itemName], iCount)
                else
                    showInfoBox("error", "Ungueltige Anzahl!")
                end
            end

            local function nein()
                self:activateForInput()
            end
            confirmDialog:showConfirmDialog("Wieviel von diesem Item moechtest du Wegwerfen? Maximal: "..(maxCount or 0), ja, nein, true, true, false)
        end
    else
        showInfoBox("error", "Du musst ein Item auwaehlen!")
    end
end

-- ///////////////////////////////
-- /////doButtonWatchInMarket //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:doButtonWatchInMarket()
    local itemName  = self.guiEle["list2"]:getRowData(2)
    if(itemName ~= "nil") then
        self:hide()
        marketGUI:openMarketWithItem(self.m_tblItemsInList[itemName].ID)
    else
        showInfoBox("error", "Du musst ein Item auwaehlen!")
    end
end

-- ///////////////////////////////
-- /////resetClickedItemValues   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:resetClickedItemValues()
    self.guiEle["image1"]:setImage("res/images/none.png")
    self.guiEle["label_desc"]:setText("Bitte waehle ein Item aus.");

    self.guiEle["button1"]:setDisabled(true)
    self.guiEle["button2"]:setDisabled(true)
    self.guiEle["button3"]:setDisabled(true)
end

-- ///////////////////////////////
-- /////updateClickedItemValues   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:updateClickedItemValues(sString)
    local item = self.m_tblItemsInList[sString]
    if(item) then
        local image     = "res/images/none.png";
        if(fileExists("res/images/items/"..item.ID..".png")) then
            image = "res/images/items/"..item.ID..".png"
        end

        self.guiEle["image1"]:setImage(image)

        if(item.Description) then
            self.guiEle["label_desc"]:setText(item.Description)
        end

        self.guiEle["button1"]:setDisabled(false)
        self.guiEle["button2"]:setDisabled(false)
        self.guiEle["button3"]:setDisabled(false)

        if(self.m_sInventoryType ~= "player") then
            self.guiEle["button2"]:setDisabled(true)
        end

        self.m_sCurrentSelectedItem = sString;
    end
end

-- ///////////////////////////////
-- /////insertItemTableToList2 //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:insertItemTableToList2(count, items, itemCount)
    self.guiEle["list2"]:clearRows();
    if not(self.m_tblItemNames) then self.m_tblItemNames = {} end

    table.sort(items, function(a, b) return a.Name < b.Name end)

    for id, item in pairs(items) do
        if(item) and (item.Name) and (item.Gewicht) and (id) then
            local gewicht   = (item.Gewicht or 0);
            local count     = (itemCount[item.ID] or 0);
            if(count > 0) then
                gewicht = gewicht*count
                if(gewicht > 1000) then
                    gewicht = (gewicht/1000).."kg"
                else
                    gewicht = gewicht.."g"
                end

                local image     = "res/images/items/unknown.png"

                if(fileExists("res/images/items/"..item.ID..".png")) then
                    image = "res/images/items/"..item.ID..".png"
                end

                self.guiEle["list2"]:addRow(image.."|"..item.Name.."|"..count.."|"..gewicht, 1)
                self.m_tblItemsInList[item.Name] = item;

                self.m_tblItemNames[item.Name] = tonumber(item.ID)
            end
        end
    end
end

-- ///////////////////////////////
-- /////refreshClickedItems   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:refreshClickedItems(sCat)
    self.guiEle["list2"]:clearRows();
    self.m_tblItemsInList = {}
    if(self.m_tblCatNames[sCat]) then
        local iCat              = tonumber(self.m_tblCatNames[sCat]);

        local count, items, itemCount     = self:getItemsInCategory(iCat);

        self:insertItemTableToList2(count, items, itemCount)

        self.m_sCurCategory     = sCat;
    end
end

-- ///////////////////////////////
-- ///// getItemsInCategory   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:getItemsInCategory(iCat)
    local count = 0;

    local items         = self.m_tblInventory
    local itemTable     = {}

    local itemCount     = {};

    for id, c in pairs(items.Items) do  -- Meine Fresse
        id = tonumber(id)
        if(self.m_tblItems[id]) and (self.m_tblItems[id].iCategory) and (tonumber(self.m_tblItems[id].iCategory) == tonumber(iCat)) then
            count = count+1
            --itemTable[count] = self.m_tblItems[id]
            table.insert(itemTable, self.m_tblItems[id])
            if not(itemCount[self.m_tblItems[id].ID]) then
                itemCount[self.m_tblItems[id].ID] = c;
            end
        end
    end

    return count, itemTable, itemCount;
end

-- ///////////////////////////////
-- /////doEditSearchFunction //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:doEditSearchFunction()
    local curString = self.guiEle["edit_suche"]:getText()

    if(string.len(curString) < 1) then
        self.m_sCurCategory = false;
        self:refreshInventory();
    else
        local tblItems  = {}
        local itemTable     = {}

        local itemCount     = {};

        local maxCount      = 0;
        for id, count in pairs(self.m_tblInventory.Items) do
            local item = self.m_tblItems[tonumber(id)]
            if(item.Name) then
                if(item.Name:lower():find(curString:lower())) then
                    table.insert(itemTable, self.m_tblItems[tonumber(id)])
                    if not(itemCount[self.m_tblItems[tonumber(id)].ID]) then
                        itemCount[self.m_tblItems[tonumber(id)].ID] = count;
                    end
                    maxCount = maxCount+1
                end
            end
        end

        self:insertItemTableToList2(maxCount, itemTable, itemCount)
    end
end

-- ///////////////////////////////
-- ///// refreshInventory    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:refreshInventory()
    local cats  = self.m_tblCategories or {};

    self.m_tblCatNames  = {}

    self.guiEle["list1"]:clearRows();

    for id, cat in ipairs(cats) do
        local catName = "("..self:getItemsInCategory(tonumber(id))..") "..cat.Name or "Unbekannt"
        self.m_tblCatNames[catName] = tonumber(id);

        if(self:getItemsInCategory(tonumber(id)) > 0) then
            self.guiEle["list1"]:addRow(catName)
        end
    end


    local itemTable     = {}
    local itemCount     = {};
    local insgCount     = 0;

    for id, count in pairs(self.m_tblInventory.Items) do
        table.insert(itemTable, self.m_tblItems[tonumber(id)])
        if not(itemCount[self.m_tblItems[tonumber(id)].ID]) then
            itemCount[self.m_tblItems[tonumber(id)].ID] = count;
        end
        insgCount = insgCount+1;
    end

    if not(self.m_sCurCategory) then
        self:insertItemTableToList2(insgCount, itemTable, itemCount)
    else
        self:refreshClickedItems(self.m_sCurCategory)
    end

    if(self.m_sCurrentSelectedItem) then
        self:updateClickedItemValues(self.m_sCurrentSelectedItem)
    end

    -- Gewicht --

    local maxGewicht        = self.m_tblInventory.iMaxGewicht

    local curGewicht        = self.m_tblInventory.iGewicht

    if(curGewicht > maxGewicht) then
        curGewicht = maxGewicht
    end

    self.guiEle["progressbar"]:setText(math.floor(curGewicht/1000).." / "..math.floor(maxGewicht/1000).."kg");
    self.guiEle["progressbar"]:setProgress(curGewicht / maxGewicht)

end

-- ///////////////////////////////
-- ///// onInventoryReceive //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:onInventoryReceive(tblInventory, tblItems, tblCategories)
    self.m_tblInventory     = fromJSON(tblInventory);

    if not(self.m_tblInventory) then
        outputConsole("Inventory not found")
        self.m_tblInventory = {}
    end

    if(tblItems) then
        self.m_tblItems         = (tblItems or {});
    end
    if(tblCategories) then
        self.m_tblCategories = tblCategories;
    end

    InventoryData = self.m_tblInventory

    if(self.m_bWaitForServer) then
        self.m_bWaitForServer = false;
        self:show();
        loadingSprite:setEnabled(false)
    end
    if(self.enabled) then
        self:refreshInventory()
    end
end

-- ///////////////////////////////
-- ///// onToggle    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:onToggle(id, ...)
    if not(clientBusy) and not(self.m_bWaitForServer) or (self.enabled) then
        if(self.enabled) then
            self:hide(id, ...);
        else
            if not(id) then
                loadingSprite:setEnabled(true)
                triggerServerEvent("onPlayerRefreshInventory", localPlayer)
                self.m_bWaitForServer = true;
                self.m_sInventoryType   = "player"
            else
                self:show(id, ...)
                self:refreshInventory()
            end
        end
    end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cInventoryGUI:constructor(...)
    addEvent("onClientInventoryRecieve", true)
    addEvent("onClientInventoryOpen", true)

    -- Klassenvariablen --
    self.guiEle             = {}
    self.enabled            = false;

    self.m_bWaitForServer   = false;

    self.m_tblItemsInList   = {}
    self.m_tblItems         = {}

    self.m_sInventoryType   = "player"

    -- Funktionen --
    self.m_funcOnToggle             = function(var1, var2, var3, ...)
        if(var1 ~= _Gsettings.keys.Inventory) then
            self:onToggle(var1, var2, var3, ...)
        else
            self:onToggle()
        end
    end
    self.m_funcOnItemsReceive       = function(...) self:onInventoryReceive(...) end

    -- Events --

    bindKey(_Gsettings.keys.Inventory, "down", self.m_funcOnToggle)
    addEventHandler("onClientInventoryRecieve", getLocalPlayer(), self.m_funcOnItemsReceive)
    addEventHandler("onClientInventoryOpen", getLocalPlayer(), function(...)
        self.m_sCurCategory = false;
        self:hide(...)
        self:show(...)
        self:refreshInventory()
    end)

    addEvent("toggleInventoryGui", true)
    addEventHandler("toggleInventoryGui", getLocalPlayer(), function(id, ...)
        if not(getElementData(localPlayer, "inlobby")) or (getElementData(localPlayer, "zuschauer")) then
            self:onToggle(id, ...)
        end
    end)


    addEvent("hideInventoryGui", true)
    addEventHandler("hideInventoryGui", getRootElement(), function()
        self:hide()
    end)
end

-- Statischer Scheiss von Frueher
hideInventoryGui    = function()
    cInventoryGUI:getInstance():hide()
end

-- EVENT HANDLER --
