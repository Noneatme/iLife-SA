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

cMarketGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:show()
   if(localPlayer:getData("loggedIn")) then
      if(self.enabled) then
         self:hide()
      end
      if not(clientBusy) then
          self:createElements()
          self.enabled = true
      end
   end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        self.guiEle["window"]:destructor()
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
    end
end

-- ///////////////////////////////
-- ///// hideTemp          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:hideTemp()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide(true);
        showCursor(true)
    end
end
-- ///////////////////////////////
-- ///// showTemp          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:showTemp()
    if(self.guiEle["window"]) then
        clientBusy = false
        self.guiEle["window"]:show(false, true);
    end
end
-- ///////////////////////////////
-- ///// updateTime 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:updateTime()
    self.guiEle["label2"]:setText(self.Time);
end

-- ///////////////////////////////
-- ///// getLast7Days		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:getLast7Days()

    local timestamp = getRealTime().timestamp;
    local days      = {}

    for i = 1, 7, 1 do
        local time  = getRealTime(timestamp-((24*60*60)*(i-1)))
        local day   = time.monthday;
        local month = time.month+1;

        if(day < 10) then day = "0"..day end
        if(month < 10) then month = "0"..month end

        days[i]     = day.."."..month;
    end
    return days;
end

-- ///////////////////////////////
-- ///// drawRaten      	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:drawRaten()
    local rt = self.tabEle["tab_4"][2];

    rt:clear()

    rt:dxDrawLine(55, 35, 55, 300, tocolor(255, 255, 255, 200), 2)
    rt:dxDrawLine(55, 300, 530, 300, tocolor(255, 255, 255, 200), 2)

 --   rt:dxDrawLine(15, 5, 15, 340, tocolor(255, 255, 255, 200), 2)
    rt:dxDrawText("(y)Anzahl", 30, 15, 100, 20, tocolor(255, 255, 255, 200), 1, "default-bold")
    rt:dxDrawText("(x)Tag", 60, 305, 100, 20, tocolor(255, 255, 255, 200), 1, "default-bold")

    -- Stueckzahl --
    local increm = 35;
    for i = 0, 7, 1 do
        rt:dxDrawLine(35, 300-increm*i, 55, 300-increm*i, tocolor(255, 255, 255, 200), 2)
    end

    -- Tag --
    local increm = 60;
    rt:dxDrawLine(55, 300, 55, 320, tocolor(255, 255, 255, 200), 2)
    for i = 1, 7, 1 do
        rt:dxDrawLine(55+increm*i, 300, 55+increm*i, 320, tocolor(255, 255, 255, 200), 2)
    end

    -- Draw Tag --
    local days = self:getLast7Days()

    local increm = 60;
    for i = 7, 1, -1 do
        rt:dxDrawText(days[i], 40+(increm*i), 320, 80, 300, tocolor(255, 255, 255, 200), 1, "default-bold")
    end

    if(self.m_tblItemKaufpreis) then
        local function getMaxItemCount()
            local curheight = 0;
            for index, anz in pairs(self.m_tblItemKaufpreis) do
                if(anz > curheight) then
                    curheight = anz;
                end
            end
            return curheight;
        end

        local maxAnzahl = getMaxItemCount();

        local maxH      = 250;

        for i = 7, 1, -1 do
            local anzahl    = self.m_tblItemKaufpreis[i];

            local prozent   = (anzahl/maxAnzahl)*100;

            local curH      = maxH*(prozent/100);

            if(type(curH) == "number") and (type(prozent) == "number") and (anzahl ~= 0) then
                rt:dxDrawLine(55+increm*i, 300, 55+increm*i, 300-curH, tocolor(55, 255, 55, 200), 6)
                rt:dxDrawText(anzahl, 25+increm*i, 280-curH, 45+increm*i+40, 280-curH+20, tocolor(255, 255, 255, 200), 1, "default-bold", "center", "center")
            end
        end

        rt:dxDrawText("0", 10, 292, 100, 20, tocolor(255, 255, 255, 200), 1, "default-bold")
        rt:dxDrawText(math.floor(maxAnzahl/2), 10, 152, 100, 20, tocolor(255, 255, 255, 200), 1, "default-bold")
        rt:dxDrawText(maxAnzahl, 10, 25, 100, 20, tocolor(255, 255, 255, 200), 1, "default-bold")
    end
end

-- ///////////////////////////////
-- ///// openMarketWithItem	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:openMarketWithItem(iID)
    if(self.enabled) then
        local kat = self.m_tblItemsCategories[iID]

        if(kat) and (iID) then
            local katName   = self.m_tblItemCategorieNames[iID]
            local itemName  = self.m_tblCurSItems[iID].Name

            if(katName) and (itemName) then
                self:onKategorySelect(katName)
                self:onItemSelect(itemName)
            end
        end
    else
        self.onEnabledFunc  = function() self:openMarketWithItem(iID) end
        self:doToggle()
    end
end

-- ///////////////////////////////
-- ///// generateItemPages	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:generateItemPages()
    self.tabEle["tab_1"]    =
    {
        new(CDxImage, 15, -5, 128, 128, "res/images/items/unknown.png", tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                       --1
        new(CDxLabel, "Item auswaehlen", 165, -5, 328, 48, tocolor(255, 255, 255, 255), 2, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),           --2
        new(CDxLabel, "Beschreibung: ", 165, 40, 328, 68, tocolor(255, 255, 255, 255), 0.9, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),      --3
        new(CDxLabel, "Guenstigster Preis:", 165, 80, 228, 28, tocolor(255, 255, 255, 150), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),   --4
        new(CDxLabel, "$0", 165, 100, 80, 28, tocolor(255, 255, 255, 255), 1.3, CDxWindow.gFont, "center", "center", self.guiEle["tab_1"]),             --5
        new(CDxButton, "Kaufen", 350, 95, 120, 28, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                  --6

        new(CDxButton, "Nachfrage", 475, 95, 120, 28, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                               --7

        -- ANGEBOT UND NACHFRAGE --
        -- Spacer --
        new(CDxLabel, string.rep("_", 64), 15, 101, 590, 48, tocolor(0, 0, 0, 255), 2, "default-bold", "left", "top", self.guiEle["tab_1"]),            --8
        new(CDxLabel, string.rep("_", 64), 15, 100, 590, 48, tocolor(255, 255, 255, 150), 2, "default-bold", "left", "top", self.guiEle["tab_1"]),      --9

        --  --
        new(CDxLabel, "Angebot", 25, 137, 250, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),               --10
        new(CDxList, 15, 155, 580, 100, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                             --11

        new(CDxLabel, "Nachfrage", 25, 257, 250, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),             --12
        new(CDxList, 15, 275, 580, 100, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                             --13

    }

    self.tabEle["tab_2"]    =
    {
        new(CDxLabel, "Details zum Item:", 5, -5, 228, 48, tocolor(255, 255, 255, 255), 2, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),       --1
        new(CDxList, 5, 35, 590, 350, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                               --2
    }

    self.tabEle["tab_3"]    =
    {
        new(CDxLabel, "Eigene Angebote:", 5, -5, 228, 48, tocolor(255, 255, 255, 255), 2, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),       --1
        new(CDxList, 5, 35, 590, 320, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                              --2
        new(CDxButton, "Item Anbieten", 5, 360, 140, 28, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),                                                 --3
        new(CDxButton, "Angebot entfernen", 150, 360, 150, 28, tocolor(255, 255, 255, 255), self.guiEle["tab_1"]),
    }

    self.tabEle["tab_4"]    =
    {
        new(CDxLabel, "Aktionen der letzten 7 Tage:", 5, -5, 228, 48, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_1"]),       --1
        new(CDxRenderTarget, 5, 35, 590, 350, self.guiEle["tab_1"]),
    }

    self.tabEle["tab_1"][11]:addColumn("ID");
    self.tabEle["tab_1"][11]:addColumn("Anzahl");
    self.tabEle["tab_1"][11]:addColumn("Preis/Item");
    self.tabEle["tab_1"][11]:addColumn("Person");
    self.tabEle["tab_1"][11]:addColumn("Datum");

    self.tabEle["tab_1"][13]:addColumn("ID");
    self.tabEle["tab_1"][13]:addColumn("Anzahl");
    self.tabEle["tab_1"][13]:addColumn("Preis/Item");
    self.tabEle["tab_1"][13]:addColumn("Person");
    self.tabEle["tab_1"][13]:addColumn("Datum");

    self.tabEle["tab_2"][2]:addColumn("Detail")
    self.tabEle["tab_2"][2]:addColumn("Wert")

    self.tabEle["tab_3"][2]:addColumn("ID");
    self.tabEle["tab_3"][2]:addColumn("Typ");
    self.tabEle["tab_3"][2]:addColumn("Stueckzahl");
    self.tabEle["tab_3"][2]:addColumn("Preis");
    self.tabEle["tab_3"][2]:addColumn("Datum");

    self.tabEle["tab_3"][3]:addClickFunction(self.m_funcItemAnbietenClick)

    self.tabEle["tab_1"][6]:setDisabled(true)
    self.tabEle["tab_3"][4]:setDisabled(true)

    self.tabEle["tab_3"][4]:addClickFunction(self.m_funcItemEigenesAngebotEntfernen)
    self.tabEle["tab_3"][2]:addClickFunction(function() if(self.tabEle["tab_3"][2]:getRowData(1)) then self.tabEle["tab_3"][4]:setDisabled(false) else self.tabEle["tab_3"][4]:setDisabled(true) end end);

    self.tabEle["tab_1"][7]:addClickFunction(self.m_funcItemAnfrageClick)

    self.tabEle["tab_1"][7]:setDisabled(true)
    self.tabEle["tab_3"][4]:setDisabled(true)
    self.tabEle["tab_1"][6]:setDisabled(true)

    self.tabEle["tab_1"][11]:addClickFunction(self.m_funcItemListAngebotClick)
    self.tabEle["tab_1"][13]:addClickFunction(self.m_funcItemListNachfrageClick)
    self.tabEle["tab_1"][6]:addClickFunction(self.m_funcItemKaufenClick)

    self:drawRaten()
end

-- ///////////////////////////////
-- ///// useIntroPage		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:genIntroPage()
    self.guiEle["tablist_intro"]        = new(CDxTabbedPane, 190, 5, 605, 425, tocolor(255, 255, 255, 255), self.guiEle["window"])

    self.guiEle["tab_tablist_1"]        = new(CDxTab, "Startseite", self.guiEle["tablist_intro"]);
    self.guiEle["tab_tablist_2"]        = new(CDxTab, "Meine Angebote", self.guiEle["tablist_intro"]);
    self.guiEle["tab_tablist_3"]        = new(CDxTab, "Meine Nachfragen", self.guiEle["tablist_intro"]);
    self.guiEle["tab_tablist_4"]        = new(CDxTab, "Hilfe", self.guiEle["tablist_intro"]);

    self.tabEle2["tab_tablist_1"]               =
    {
        new(CDxLabel, "Willkommen im ".._Gsettings.serverName.." Market! \nHier kannst du Items anbieten, verkaufen oder den Wechselkurs betrachten.", 15, 1, 550, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_1"]),               --10
        new(CDxLabel, "Zurzeit befinden sich 0 Angebote und 0 Anfragen im Markt.", 15, 45, 550, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_1"]),               --10
        new(CDxLabel, "Neuste Angebote:", 15, 65, 550, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_1"]),
        new(CDxList, 15, 90, 575, 290, tocolor(255, 255, 255, 255), self.guiEle["tab_tablist_1"])
    }

    self.tabEle2["tab_tablist_2"]               =
    {
        new(CDxLabel, "Hier kannst du all deine zurzeitigen Angebote betrachten.", 15, 1, 550, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_2"]),               --10
        new(CDxList, 15, 30, 575, 350, tocolor(255, 255, 255, 255), self.guiEle["tab_tablist_2"])
    }
    self.tabEle2["tab_tablist_3"]               =
    {
        new(CDxLabel, "Hier kannst du all deine zurzeitigen Nachfragen betrachten.", 15, 1, 550, 50, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_2"]),               --10
        new(CDxList, 15, 30, 575, 350, tocolor(255, 255, 255, 255), self.guiEle["tab_tablist_3"])
    }
    self.tabEle2["tab_tablist_4"]               =
    {
        new(CDxLabel, "Der ".._Gsettings.serverName.." Market ist ein Virtueller Markt wo du Items anbieten und kaufen kannst.\n\nEr ist ausserdem der einzige Ort, wo du spezielle Items wie Scanner erwerben kannst.\n\nItem Verkaufen\nUm ein Item im Markt anzubieten, musst du erst ein Item deiner Wahl suchen. In dem Reiter 'Eigene Angebote' kannst du nun auf 'Item Anbieten' klicken. Bitte beachte das nicht jedes Item verkauft und gekauft werden kann, da es sich auch um Illegale Items handeln kann.\n\nNachfrage\nUm eine Nachfrage zu schreiben, klicke nachdem du ein Item angewaehlt hast auf den Knopf 'Nachfrage'. Du wirst im Vorraus den Preis fuer das Item bezahlen und es erhalten, sobald eine Person dein Angebot akzeptiert hat.\n\n\nSollte ein Fehler im System entstehen, kannst du dich an einem Administrator deiner Wahl wenden. Dir wird anschliessend dein Verlust erstattet.", 15, 1, 550, 350, tocolor(255, 255, 255, 255), 1, CDxWindow.gFont, "left", "top", self.guiEle["tab_tablist_1"]),               --10
    }

    self.tabEle2["tab_tablist_1"][4]:addDoubleClickFunction(function(dxList)
        local id        =   self.m_tblItemNames[dxList:getRowData(2)];
        self:openMarketWithItem(id)
    end)

    self.tabEle2["tab_tablist_2"][2]:addDoubleClickFunction(function(dxList)
        local id        =   self.m_tblItemNames[dxList:getRowData(2)];
        self:openMarketWithItem(id)
    end)
    self.tabEle2["tab_tablist_3"][2]:addDoubleClickFunction(function(dxList)
        local id        =   self.m_tblItemNames[dxList:getRowData(2)];
        self:openMarketWithItem(id)
    end)

    self.tabEle2["tab_tablist_1"][4]:addColumn("Icon", true)
    self.tabEle2["tab_tablist_1"][4]:addColumn("Itemname")
    self.tabEle2["tab_tablist_1"][4]:addColumn("Anzahl")
    self.tabEle2["tab_tablist_1"][4]:addColumn("Preis (insg.)")
    self.tabEle2["tab_tablist_1"][4]:addColumn("Datum")
    self.tabEle2["tab_tablist_1"][4]:addColumn("Spieler")
    self.tabEle2["tab_tablist_1"][4]:addColumn("ID")

    self.tabEle2["tab_tablist_2"][2]:addColumn("Icon", true)
    self.tabEle2["tab_tablist_2"][2]:addColumn("Itemname")
    self.tabEle2["tab_tablist_2"][2]:addColumn("Anzahl")
    self.tabEle2["tab_tablist_2"][2]:addColumn("Preis (insg.)")
    self.tabEle2["tab_tablist_2"][2]:addColumn("Datum")
    self.tabEle2["tab_tablist_2"][2]:addColumn("ID")

    self.tabEle2["tab_tablist_3"][2]:addColumn("Icon", true)
    self.tabEle2["tab_tablist_3"][2]:addColumn("Itemname")
    self.tabEle2["tab_tablist_3"][2]:addColumn("Anzahl")
    self.tabEle2["tab_tablist_3"][2]:addColumn("Preis (insg.)")
    self.tabEle2["tab_tablist_3"][2]:addColumn("Datum")
    self.tabEle2["tab_tablist_3"][2]:addColumn("ID")

    for tabname, tbl in pairs(self.tabEle2) do
        for index, ele in pairs(tbl) do
            self.guiEle[tabname]:add(ele)
        end
    end

    self.guiEle["tablist_intro"]:addTab(self.guiEle["tab_tablist_1"], {115, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist_intro"]:addTab(self.guiEle["tab_tablist_2"], {155, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist_intro"]:addTab(self.guiEle["tab_tablist_3"], {155, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist_intro"]:addTab(self.guiEle["tab_tablist_4"], {95, tocolor(125, 125, 125, 55)})

    self.guiEle["tablist_intro"]:setVisible(false)
end

-- ///////////////////////////////
-- ///// useItemPage		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:genItemPage()
    self.guiEle["tablist"]    = new(CDxTabbedPane, 190, 5, 605, 425, tocolor(255, 255, 255, 255), self.guiEle["window"])

    self.guiEle["tab_1"]      = new(CDxTab, "Angebot / Nachfrage", self.guiEle["tablist"]);
    self.guiEle["tab_2"]      = new(CDxTab, "Informationen", self.guiEle["tablist"]);
    self.guiEle["tab_3"]      = new(CDxTab, "Eigene Angebote", self.guiEle["tablist"]);
    self.guiEle["tab_4"]      = new(CDxTab, "Raten", self.guiEle["tablist"]);


    self.tabEle["tab_1"]      = {};
    self.tabEle["tab_2"]      = {};
    self.tabEle["tab_3"]      = {};
    self.tabEle["tab_4"]      = {};

    self:generateItemPages(iItemID, sItemName)

    self.guiEle["tablist"]:addTab(self.guiEle["tab_1"], {175, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist"]:addTab(self.guiEle["tab_2"], {125, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist"]:addTab(self.guiEle["tab_3"], {125, tocolor(125, 125, 125, 55)})
    self.guiEle["tablist"]:addTab(self.guiEle["tab_4"], {75, tocolor(125, 125, 125, 55)})

    for tabname, tbl in pairs(self.tabEle) do
        for index, ele in pairs(tbl) do
            self.guiEle[tabname]:add(ele)
        end
    end

    self.guiEle["tablist"]:setVisible(false)
end

-- ///////////////////////////////
-- ///// updateItemPages	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:updateItemPages(item, angebote, tblEigeneAngebote)
    local id        = tonumber(item['ID'])
    if(fileExists("res/images/items/"..id..".png")) then
        self.tabEle["tab_1"][1]:setImage("res/images/items/"..id..".png");
    else
        self.tabEle["tab_1"][1]:setImage("res/images/items/unknown.png");
    end
    self.tabEle["tab_1"][11]:clearRows()
    self.tabEle["tab_1"][13]:clearRows()

    self.tabEle["tab_2"][2]:clearRows();
    self.tabEle["tab_3"][2]:clearRows();

    self.tabEle["tab_1"][2]:setText(string.gsub(item['Name'], "\\", ""))
    self.tabEle["tab_1"][3]:setText("Beschreibung: "..item['Description']);

    self.guiEle["tablist"]:selectTab(1)

    self.tabEle["tab_2"][2]:addRow("Itemname|"..(item['Name'] or "Unbekannt"))
    self.tabEle["tab_2"][2]:addRow("Item ID|"..(item['ID'] or "Unbekannt"))

    local handelbar, benutzbar, konsumgueter, illegal, deletable     = "Nein", "Nein", "Nein", "Nein", "Nein";

    if(tonumber(item['Useable']) == 1) then
        benutzbar = "Ja"
    end
    if(tonumber(item['Consume']) == 1) then
        konsumgueter = "Ja"
    end
    if(tonumber(item['Tradeable']) == 1) then
        handelbar = "Ja"
    end
    if(tonumber(item['Deleteable']) == 1) then
        deletable = "Ja"
    end
    if(tonumber(item['Illegal']) == 1) then
        illegal = "Ja"
    end

    self.tabEle["tab_2"][2]:addRow("Standartkosten|$"..((item['Cost'] or "Unbekannt")))
    self.tabEle["tab_2"][2]:addRow("Max. Anzahl|"..((item['Stacksize'] or "Unbekannt")))

    self.tabEle["tab_2"][2]:addRow("Kann gehandelt werden|"..(handelbar))
    self.tabEle["tab_2"][2]:addRow("Kann benutzt werden|"..(benutzbar))
    self.tabEle["tab_2"][2]:addRow("Kann konsumiert werden|"..(konsumgueter))
    self.tabEle["tab_2"][2]:addRow("Kann geloescht werden|"..(deletable))
    self.tabEle["tab_2"][2]:addRow("Illegal|"..(illegal))
    self.tabEle["tab_2"][2]:addRow("Gewicht|"..((item['Gewicht'] or "Unbekannt")))


    -- ANGEBOTE --
    local minPreis = math.huge;
    if(angebote) then
        table.sort( angebote, function( a,b ) return tonumber(a['Preis']) < tonumber(b['Preis']) end )

        for index, tbl in pairs(angebote) do

            local id        = tbl['AngebotID'];
            local itemID    = tbl['ItemID'];
            local type      = tonumber(tbl['AngebotType']);
            local player    = tbl['Name'];
            local anzahl    = tbl['Anzahl'];
            local preis     = tbl['Preis'];
            local time      = tbl['StartTimestamp'];


            if(preis < minPreis) and (type == 1) then
                minPreis = preis
            end

            local list       = self.tabEle["tab_1"][11];
            if(type == 1) then      -- Angebot
                list = self.tabEle["tab_1"][11]
            elseif(type == 2) then  -- Nachfrage
                list = self.tabEle["tab_1"][13]
            end

            list:addRow(id.."|"..anzahl.."|$"..preis.."|"..player.."|"..formatTimestamp(time))
        end
    end

    if(tblEigeneAngebote) then
        for index, tbl in pairs(tblEigeneAngebote) do
            table.sort( tbl, function( a,b ) return tonumber(a['AngebotType']) < tonumber(b['AngebotType']) end )

            local id        = tbl['AngebotID'];
            local typ       = tbl['AngebotType']
            if(tonumber(typ == 1)) then typ = "Angebot" else typ = "Nachfrage" end
            local stck      = tbl['Anzahl']
            local preis     = "$"..tbl['Preis'];
            local datum     = getRealTime(tonumber(tbl['StartTimestamp']));

            local time      = datum.monthday.."."..(datum.month+1).."."..(datum.year+1900).." "..(datum.hour)..":"..datum.minute..":"..datum.second;

            self.tabEle["tab_3"][2]:addRow(id.."|"..typ.."|"..stck.."|"..preis.."|"..time)
        end
    end

    local bBool = false;

    if(tonumber(item['Tradeable']) == 0) or (tonumber(item['Illegal']) == 1) then
        bBool = true
    end
    self.tabEle['tab_1'][6]:setDisabled(bBool)
    self.tabEle['tab_1'][7]:setDisabled(bBool)

    self.tabEle['tab_3'][3]:setDisabled(bBool)
    self.tabEle['tab_3'][4]:setDisabled(bBool)

    if(minPreis == math.huge) then
        minPreis = "-"
    end
    self.tabEle["tab_1"][5]:setText(minPreis.."$")

    self:showTabPane("item")
end

-- ///////////////////////////////
-- ///// showTabPane		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:showTabPane(sPane)
    if(sPane == "startseite") then
        self.guiEle["tablist"]:setVisible(false)
        self.guiEle["tablist_intro"]:setVisible(true)
    else
        self.guiEle["tablist"]:setVisible(true)
        self.guiEle["tablist_intro"]:setVisible(false)
    end
end


-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:createElements()
    if not(self.guiEle["window"]) then
        self.guiEle["window"] 	            = new(CDxWindow, _Gsettings.serverName.." Market", 800, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), "res/images/dxGui/misc/icons/market.png", "Markt"}, "Hier kannst du alles Kaufen und Verkaufen was du möchtest.")
        self.guiEle["window"].xtraHide      = function(...) self:hide(...) end
        self.guiEle["kategorie_view"]       = new(CDxList, 5, 5, 180, 200, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["kategorie_view"]:addColumn("Kategorien")

        self.guiEle["kategorie_view"]:addClickFunction(self.m_funcClickKategory)

        self.guiEle["item_view"]            = new(CDxList, 5, 210, 180, 184, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["item_view"]:addColumn("Icon", true)
        self.guiEle["item_view"]:addColumn("Itemname")

        self.guiEle["item_view"]:addClickFunction(self.m_funcClickItem);

        self.guiEle["item_edit"]            = new(CDxEdit, "Suche...", 5, 400, 180, 25, "text", tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["item_edit"]:addEditFunction(self.m_funcSearchItem);
        self.guiEle["item_edit"]:addClickFunction(self.m_funcSearchItemClick);

        self:genItemPage()
        self:genIntroPage()

        self:showTabPane("startseite")

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end


        self.guiEle["window"]:show();

        self.guiEle["tablist"]:selectTab(4)

        self.enabled = true;

--[[
        if(self.m_tblCurSItems) then
            self:onItemsReceive(self.m_tblCurSItems, self.m_tblCurSCats)
        end]]
    end
end

-- ///////////////////////////////
-- ///// updateStartseitenItems 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:updateStartseitenItems(m_tblLastAngebote, m_tblCountAngebote, m_tblCountAnfragen, tbl_eigenAngebote)
    -- LABEL --

--[[
self.tabEle2["tab_tablist_1"][4]:addColumn("Icon", true)
self.tabEle2["tab_tablist_1"][4]:addColumn("Itemname")
self.tabEle2["tab_tablist_1"][4]:addColumn("Anzahl")
self.tabEle2["tab_tablist_1"][4]:addColumn("Preis")
self.tabEle2["tab_tablist_1"][4]:addColumn("Datum")
self.tabEle2["tab_tablist_1"][4]:addColumn("Spieler")
self.tabEle2["tab_tablist_1"][4]:addColumn("ID")
]]
    self.tabEle2["tab_tablist_1"][2]:setText("Zurzeit befinden sich "..m_tblCountAngebote[1]['C1'].." Angebote und "..m_tblCountAnfragen[1]['C1'].." Anfragen im Markt.")

    -- TAB 1--
    self.tabEle2["tab_tablist_1"][4]:clearRows()

    for index, row in pairs(m_tblLastAngebote) do
        local itemID    = tonumber(row['ItemID'])
        local name      = row['Name'];
        local itemSTR   = "res/images/none.png";
        local anzahl    = tonumber(row['Anzahl'])
        local preis     = anzahl*(tonumber(row['Preis']))
        local time      = row['StartTimestamp']
        local id        = row['AngebotID']

        if(fileExists("res/images/items/"..itemID..".png")) then
            itemSTR = "res/images/items/"..itemID..".png"
        end

        self.tabEle2["tab_tablist_1"][4]:addRow(itemSTR.."|"..self.m_tblCurSItems[itemID].Name.."|"..anzahl.."|$"..preis.."|"..formatTimestamp(time).."|"..name.."|"..id, 1)
    end

    -- TAB 2--
    for index, row in pairs(tbl_eigenAngebote) do
        local itemID    = tonumber(row['ItemID'])
        local name      = row['Name'];
        local itemSTR   = "res/images/none.png";
        local anzahl    = tonumber(row['Anzahl'])
        local preis     = anzahl*(tonumber(row['Preis']))
        local time      = row['StartTimestamp']
        local id        = row['AngebotID']

        if(fileExists("res/images/items/"..itemID..".png")) then
            itemSTR = "res/images/items/"..itemID..".png"
        end

        if(row['AngebotType'] == 1) then        -- Angebot
            self.tabEle2["tab_tablist_2"][2]:addRow(itemSTR.."|"..self.m_tblCurSItems[itemID].Name.."|"..anzahl.."|$"..preis.."|"..formatTimestamp(time).."|"..id, 1)
        else                                    -- Nachfrage
            self.tabEle2["tab_tablist_3"][2]:addRow(itemSTR.."|"..self.m_tblCurSItems[itemID].Name.."|"..anzahl.."|$"..preis.."|"..formatTimestamp(time).."|"..id, 1)
        end
    end

    -- TAB 3 --

end

-- ///////////////////////////////
-- ///// onItemsReceive 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemsReceive(tblItems, tblCategorys, ...)
    if not(self.enabled) then --m_tblLastAngebote, m_tblCountAngebote, m_tblCountAnfragen, tbl_eigenAngebote
        self:show()
    end
    self.m_bWaitForServer = false;
    loadingSprite:setEnabled(false)

    -- Clear Items and Categorys --
    self.guiEle["kategorie_view"]:clearRows();
    self.guiEle["item_view"]:clearRows();

    self.m_tblCatIDS        = {}
    self.m_tblCatItems      = {}
    self.m_tblCatNames      = {}
    self.m_tblItemsCategories = {}
    self.m_tblItemCategorieNames    = {}

    table.sort( tblCategorys, function( a,b ) return a['Name'] < b['Name'] end )

    for index, kat in pairs(tblCategorys) do
        self.m_tblCatIDS[kat['Name']] = tonumber(kat['ID'])
        self.guiEle["kategorie_view"]:addRow(kat['Name'])
        self.m_tblCatNames[kat['ID']] = kat['Name']
    end

    for index, item in pairs(tblItems) do
        local kat   = tonumber(item['Category']);
        if(kat) then

            if not(self.m_tblCatItems[kat]) then
                self.m_tblCatItems[kat] = {}
            end

            table.insert(self.m_tblCatItems[kat], item);
            table.sort( self.m_tblCatItems[kat], function( a, b ) return a['Name'] < b['Name'] end )

            self.m_tblItemsCategories[item.ID] = kat;
            self.m_tblItemCategorieNames[item.ID] = self.m_tblCatNames[kat];
        end

        self.m_tblItemNames[item.Name] = item.ID
    end

    self.m_tblCurSItems = tblItems;
    self.m_tblCurSCats  = tblCategorys

    -- STARTSEITE --
    self:updateStartseitenItems(...)

    if(self.onEnabledFunc) then
        self.onEnabledFunc()

        self.onEnabledFunc = false;
    end
end

-- ///////////////////////////////
-- ///// onItemsReceive 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemInformationReceive(iItemID, tblInformations)
    -- Clear Items and Categorys --
    self.tabEle["tab_2"][2]:clearRows();
end
-- ///////////////////////////////
-- ///// clearTabs   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:clearTabs()
    for tabname, tbl in pairs(self.tabEle) do
        for index, ele in pairs(tbl) do
            delete(ele);
        end
    end
end

-- ///////////////////////////////
-- ///// getItemFromName	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:getItemFromName(sName)
    for kat_id, items in pairs(self.m_tblCatItems) do
        if(items) then
            for index, item in pairs(items) do
                local name = item["Name"];
                if(name == sName) then
                    return item;
                end
            end
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// getItemImage   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:getItemImage(iID)
    local image = "res/images/none.png";
    if(fileExists("res/images/items/"..iID..".png")) then
        image = "res/images/items/"..iID..".png";
    end

    return image;
end

-- ///////////////////////////////
-- ///// onKategorySelect	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onKategorySelect(iCat)
    self.guiEle["item_view"]:clearRows();
    local data = self.guiEle["kategorie_view"]:getRowData(1);
    if(iCat) then
        data = iCat
    end
    if(data) and not(_Gsettings.persistentMarketCategories[data]) then
        local kat_id        = self.m_tblCatIDS[data];
        local items         = self.m_tblCatItems[kat_id]
        if(items) then
            for index, item in pairs(items) do


                self.guiEle["item_view"]:addRow(self:getItemImage(item.ID).."|"..item["Name"], 1);
            end
        end
    else
        if(data == "- Neuwagen") or (data == "- Gebrauchtwagen") then
            local vehicles = {}
            for i = 400, 611, 1 do
                if(getVehicleNameFromModel(i)) then
                    vehicles[i] = getVehicleNameFromModel(i);
                end
            end

            table.sort(vehicles, function( a,b ) return a < b end)

            for index, bla in pairs(vehicles) do
                if(bla) then
                    if(type(bla) == "string") and (string.len(bla) > 0) then
                        local image = "res/images/none.png";

                        self.guiEle["item_view"]:addRow(image.."|"..bla, 1);
                    end
                end
            end
        end
    end
end

-- ///////////////////////////////
-- ///// onItemSelect   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemSelect(iCat)
    local item_name = self.guiEle["item_view"]:getRowData(2);
    if(iCat) then
        item_name = iCat
    end
    local item      = self:getItemFromName(item_name);

    self.m_sCurrentItem = item;

    if not(self.m_bWaitForServer) then
        if(item) and (item['ID']) then
            triggerServerEvent("onPlayerMarketItemAngeboteReqeust", localPlayer, item['ID'])
            self.m_bWaitForServer = true;
            loadingSprite:setEnabled(true)
        end
    else
        showInfoBox("error", "Warten auf Server...")
    end
end

-- ///////////////////////////////
-- ///// onItemEditSearch	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemEditSearch()
    local text = self.guiEle["item_edit"]:getText()
    if(string.len(text) > 0) then
        self.guiEle["item_view"]:clearRows();
        local found_table   = {}
        -- Suche --

        for kat_id, items in pairs(self.m_tblCatItems) do
            if(items) then
                for index, item in pairs(items) do
                    local name = item["Name"];
                    if(string.find(string.lower(name), string.lower(text))) then
                        table.insert(found_table, item);
                    end
                end
            end
        end
        table.sort( found_table, function( a,b ) return a['Name'] < b['Name'] end )

        for index, item in pairs(found_table) do
            self.guiEle["item_view"]:addRow(self:getItemImage(item.ID).."|"..item["Name"], 1);
        end
    else
        self:onKategorySelect();
        self:showTabPane("startseite")
    end
end

-- ///////////////////////////////
-- ///// onItemEditClick	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemEditClick()
    local text = self.guiEle["item_edit"]:getText()
    if(text == "Suche...") then
        self.guiEle["item_edit"]:setText("");
    end
end

-- ///////////////////////////////
-- ///// toggle      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:doToggle()
    if(self.enabled) then
        self:hide();
        clientBusy = false;
    else
        if not(clientBusy) and not(self.m_bWaitForServer) then
            self.m_bWaitForServer = true;
            loadingSprite:setEnabled(true)
            triggerServerEvent("onPlayerMarketItemsReqeust", localPlayer)
        end
    end
end

-- ///////////////////////////////
-- ///// onItemAngeboteReceive////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemAngeboteReceive(tblAngebote, tblEigeneAngebote, tblMarketPurchases)
    if(self.m_bWaitForServer) then
        self.m_bWaitForServer = false;

        loadingSprite:setEnabled(false)
        self:updateItemPages(self.m_sCurrentItem, tblAngebote, tblEigeneAngebote);

        if(tblMarketPurchases) then
            self.m_tblItemKaufpreis = tblMarketPurchases;
        end
        self:drawRaten()
    end
end

-- ///////////////////////////////
-- ///// onAnfrageStart 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onAnfrageStart(...)
    if(self.m_sCurrentItem) then
        self:hideTemp()

        local function ja()
            local anzahl    = tonumber(confirmDialog.guiEle["edit"]:getText())
            if(anzahl) and (anzahl > 0) and (anzahl < 999999) then
                setTimer(function()
                    local function ja2()
                        local preis    = tonumber(confirmDialog.guiEle["edit"]:getText())
                        if(preis) and (preis > 0) and (preis < 99999999) then
                            setTimer(function()
                                local function nein3()
                                    self:showTemp()
                                end

                                local function ja3()
                                    triggerServerEvent("onPlayerMarketAngebotNachfrage", localPlayer, self.m_sCurrentItem['ID'], anzahl, preis);
                                    self:showTemp()
                                    self.m_bWaitForServer = true;
                                end

                                confirmDialog:showConfirmDialog("Diese Anfrage wird dich $"..preis*anzahl.." kosten. Wenn jemand deine Anfrage annimmt, erhaelst du das Item.\nDiese Anfrage kannst du jederzeit entfernen.", ja3, nein3, true, false)

                            end, 50, 1)
                        else
                            showInfoBox("error", "Ungueltige Anzahl!")
                            self:showTemp()
                        end
                    end

                    local function nein2()
                        self:showTemp()
                    end

                    confirmDialog:showConfirmDialog("Wieviel Geld (in $) moechtest du pro Item ausgeben?\nStandartpreis fuer dieses Item: $"..(self.m_sCurrentItem['Cost'] or 0), ja2, nein2, true, true)
                end, 50, 1)
            else
                showInfoBox("error", "Ungueltige Anzahl!")
                self:showTemp()
            end
        end

        local function nein()
            self:showTemp()
        end

        confirmDialog:showConfirmDialog("Du schreibst nun eine Anfrage. Wieviel von diesem Item moechtest du kaufen?", ja, nein, true, true);
    else
        showInfoBox("error", "Bitte waehle ein Item aus!")
    end
end

-- ///////////////////////////////
-- ///// onItemAnbietenClick//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemAnbietenClick()
    if(self.m_sCurrentItem) then
        self:hideTemp()

        local function ja()
            local anzahl    = tonumber(confirmDialog.guiEle["edit"]:getText())
            if(anzahl) and (anzahl > 0) and (anzahl < 999999) or (confirmDialog.guiEle["edit"]:getText() == "all") then
                if(confirmDialog.guiEle["edit"]:getText() == "all") then anzahl = "all" end
                setTimer(function()
                    local function ja2()
                        local preis    = tonumber(confirmDialog.guiEle["edit"]:getText())
                        if(preis) and (preis > 0) and (preis < 99999999) then

                            setTimer(function()
                                local function nein3()
                                    self:showTemp()
                                end

                                local function ja3()
                                    triggerServerEvent("onPlayerMarketAngebotAnbiete", localPlayer, self.m_sCurrentItem['ID'], anzahl, preis);
                                    self:showTemp()
                                    self.m_bWaitForServer = true;
                                end

                                confirmDialog:showConfirmDialog("Dieses Angebot wird dich "..anzahl.." "..self.m_sCurrentItem['Name'].." kosten.. Wenn jemand deine Angebot annimmt, erhaelst du das Geld.\nDieses Angebot kannst du jederzeit entfernen.", ja3, nein3, true, false)
                            end, 50, 1)

                        else
                            showInfoBox("error", "Ungueltige Anzahl!")
                            self:showTemp()
                        end
                    end

                    local function nein2()
                        self:showTemp()
                    end

                    confirmDialog:showConfirmDialog("Wieviel Geld (in $) moechtest du pro Item erhalten?\nStandartpreis fuer dieses Item: $"..(self.m_sCurrentItem['Cost'] or 0), ja2, nein2, true, true)
                end, 50, 1)
            else
                showInfoBox("error", "Ungueltige Anzahl!")
                self:showTemp()
            end
        end

        local function nein()
            self:showTemp()
        end

        confirmDialog:showConfirmDialog("Du schreibst nun ein Angebot. Wieviel von diesem Item moechtest du anbieten? Schreibe 'all' fuer alles.", ja, nein, true, true);
    else
        showInfoBox("error", "Bitte waehle ein Item aus!")
    end
end

-- ///////////////////////////////
-- /onEigenesAngebotEntfernenClick
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onEigenesAngebotEntfernenClick()
    local data = tonumber(self.tabEle["tab_3"][2]:getRowData(1))
    if(data) then
        self:hideTemp()
        local function ja()
            triggerServerEvent("onPlayerMarketVorhandenesAngebotRemove", localPlayer, data)
            self:showTemp()
            self.m_bWaitForServer = true;
        end

        local function nein()
            self:showTemp()
        end

        confirmDialog:showConfirmDialog("Dieses Angebot entfernen?\nDu erhaelst 75% des Uhrsprunges erstattet.", ja, nein, true, false)
    end
end

-- ///////////////////////////////
-- /onItemListAngebotClick
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemListAngebotClick()
    local list = self.tabEle["tab_1"][11]
    if(list:getRowData(1) ~= "nil") then
        self.tabEle["tab_1"][6]:setText("Kaufen")

        self.m_iSelectedItemBuyList = list;
    end
end

-- ///////////////////////////////
-- /onItemListNachfrageClick
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemListNachfrageClick()
    local list = self.tabEle["tab_1"][13]
    if(list:getRowData(1) ~= "nil") then
        self.tabEle["tab_1"][6]:setText("Verkaufen")

        self.m_iSelectedItemBuyList = list;
    end
end

-- ///////////////////////////////
-- //////onItemKaufClick    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:onItemKaufClick()
    if not(self.m_bWaitForServer) then
        local list = self.m_iSelectedItemBuyList;
        if(list) then
            local angebotID     = tonumber(list:getRowData(1))
            local anzahl        = tonumber(list:getRowData(2))
            if(angebotID) then
                self:hideTemp()
                local function ja()
                    self:showTemp()
                    loadingSprite:setEnabled(true)
                    self.m_bWaitForServer   = true;
                    triggerServerEvent("onPlayerMarketItemAngebotPurchase", localPlayer, angebotID, self.m_sCurrentItem['ID'], confirmDialog.guiEle["edit"]:getText());
                end

                local function nein()
                    self:showTemp()
                end
                confirmDialog:showConfirmDialog("Wieviel moechtest du von diesem Item moechtest du (ver)kaufen? Max: "..anzahl, ja, nein, true, true)
            else
                showInfoBox("error", "Du musst ein Item auswaehlen!")
            end
        else
            showInfoBox("error", "Du musst ein Item auswaehlen!")
        end
    else
        showInfoBox("error", "Warten auf Server...")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMarketGUI:constructor(...)

    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    self.tabEle         = {}
    self.tabEle2         = {}

    self.m_tblItems         = {}
    self.m_tblCategories    = {}
    self.m_tblCatIDS        = {}

    self.m_tblCurItems      = {}

    self.m_tblItemNames     = {}

    self.m_tblItemKaufpreis     =
    {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
    }

    -- Funktionen --
    self.m_funcClickKategory    = function() self:onKategorySelect() end
    self.m_funcClickItem        = function() self:onItemSelect() end
    self.m_funcSearchItem       = function(...) self:onItemEditSearch(...) end
    self.m_funcSearchItemClick  = function(...) self:onItemEditClick(...) end
    self.m_funcItemsReceive     = function(...) self:onItemsReceive(...) end
    self.m_funcGetItemAngebote  = function(...) self:onItemAngeboteReceive(...) end
    self.toggleFunc             = function(...) self:doToggle(...) end
    self.m_funcItemAnfrageClick = function(...) self:onAnfrageStart(...) end
    self.m_funcItemAnbietenClick = function(...) self:onItemAnbietenClick(...) end
    self.m_funcItemEigenesAngebotEntfernen = function(...) self:onEigenesAngebotEntfernenClick(...) end
    self.m_funcItemListAngebotClick = function(...) self:onItemListAngebotClick(...) end
    self.m_funcItemListNachfrageClick = function(...) self:onItemListNachfrageClick(...) end
    self.m_funcItemKaufenClick  = function(...) self:onItemKaufClick(...) end

    -- Events --
    addEvent("onClientPlayerMarketItemsReceive", true)
    addEvent("onClientPlayerMarketItemAngeboteReceive", true)

    addEventHandler("onClientPlayerMarketItemsReceive", getLocalPlayer(), self.m_funcItemsReceive)
    addEventHandler("onClientPlayerMarketItemAngeboteReceive", getLocalPlayer(), self.m_funcGetItemAngebote)

    bindKey(_Gsettings.keys.Market, "down", self.toggleFunc)
end

-- EVENT HANDLER --
