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

cGamemodeGUI = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cGamemodeGUI:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:show()
    if (self.enabled) then
        self:hide()
    end
    self:createElements()
    self.enabled = true

    clientBusy = true;
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"]   = false;
        self.enabled            = false;
        clientBusy              = false;
    end
end

-- ///////////////////////////////
-- ///// updateTime 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:updateTime()
    self.guiEle["label2"]:setText(self.Time);
end


-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	    = new(CDxWindow, "iLife Eventauswahl", 800, 450, true, true, "Center|Middle", 0, 0, {tocolor(125, 225, 155, 255), false, "Hall of Games"}, "Weahle ein Gamemode aus und die dazugehoerige Map, um eine Lobby zu erstellen.")
        self.guiEle["window"]:setHideFunction(self.hidedat);

        self.guiEle["label1"]       = new(CDxLabel, "Hier kannst du ein Event oder Arenakampf starten.", 15, 10, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["label2"]       = new(CDxLabel, "Gamemode:", 100, 40, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["label3"]       = new(CDxLabel, "Map:", 370, 40, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["image"]        = new(CDxImage, 520, 20, 250, 141, "res/images/gamemodes/maps/0.jpg", tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["grid1"]        = new(CDxList, 10, 60, 230, 360, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["grid1"]:addColumn("Event");
        self.guiEle["grid1"]:addColumn("ID");
        -- GRID 1 --
        for index, name in pairs(self.m_defaultModes) do
            self.guiEle["grid1"]:addRow(name.."|"..index)
        end

        self.guiEle["grid2"]        = new(CDxList, 270, 60, 230, 360, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["grid2"]:addColumn("Map");
        self.guiEle["grid2"]:addColumn("ID");

        self.guiEle["grid1"]:addClickFunction(self.m_clickGrid1)
        self.guiEle["grid2"]:addClickFunction(self.m_clickGrid2)

        self.guiEle["label4"]           = new(CDxLabel, "Lobbyname: ", 520, 175, 150, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["edit_lobbyname"]   = new(CDxEdit, "-", 590, 170, 180, 30, "text", tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["label_spieler"]      = new(CDxLabel, "Spieler: ", 520, 213, 150, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["combo_spieler"]      = new(CDxComboBox, 1, 590, 210, 180, 25, 50, tocolor(255, 255, 255, 255), {"2", "3", "4", "8", "16", "32", "64", "128", "256", "512", "1024"}, self.guiEle["window"])

        self.guiEle["label_zeit"]         = new(CDxLabel, "Max. Minuten: ", 510, 253, 150, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["combo_zeit"]         = new(CDxComboBox, 5, 590, 250, 180, 25, 50, tocolor(255, 255, 255, 255), {"5", "10", "20", "40", "80", "160", "1000"}, self.guiEle["window"])

        self.guiEle["label_eintritt"]     = new(CDxLabel, "Eintritt:", 520, 293, 150, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["edit_eintritt"]      = new(CDxEdit, "0", 590, 290, 180, 25, 50, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["label_fahrzeug"]     = new(CDxLabel, "Fahrzeug: ", 520, 333, 150, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["combo_fahrzeug"]     = new(CDxComboBox, 1, 590, 330, 180, 25, 50, tocolor(255, 255, 255, 255), {"Standart", "Zufall", "Festgelegt"}, self.guiEle["window"])

        self.guiEle["button_start"]       = new(CDxButton, "Erstellen", 590, 390, 180, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button_start"]:addClickFunction(function()
            local gmid      = tonumber(self.guiEle["grid1"]:getRowData(2));
            local mapid     = tonumber(self.guiEle["grid2"]:getRowData(2));
            loadingSprite:setEnabled(true)
            local fahrzeug  = self.guiEle["combo_fahrzeug"]:getSelectedIndex();

            local function createLobby(fahrzeug)
                triggerServerEvent("onPlayerGamemodeCreate", getLocalPlayer(), gmid, mapid, self.guiEle["edit_lobbyname"]:getText(), self.guiEle["combo_spieler"]:getSelectedItem(), self.guiEle["combo_zeit"]:getSelectedItem(), self.guiEle["edit_eintritt"]:getText(), fahrzeug)
                self:hide();
            end

            if(fahrzeug == "Festgelegt") then
                local function ja()
                    fahrzeug = confirmDialog.guiEle["edit"]:getText();

                    if(getVehicleModelFromName(fahrzeug)) then
                        createLobby(fahrzeug);
                    else
                        showInfoBox("error", "Unbekanntes Fahrzeug!");
                        showCursor(true)
                    end
                end

                local function nein()
                    self:hide();
                end

                confirmDialog:showConfirmDialog("Bitte gebe dein Fahrzeug an, welches benutzt werden soll:", ja, nein, false, true);
            else
                createLobby(fahrzeug)
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
-- ///// selectGamemode   	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:selectGamemode()
    local value = tonumber(self.guiEle["grid1"]:getRowData(2))

    self.guiEle["grid2"]:clearRows();

    if(value) then
        for id, tbl in pairs(self.m_defaultMaps[value]) do
            self.guiEle["grid2"]:addRow(tbl[1].."|"..tbl[2])
        end
    end
end

-- ///////////////////////////////
-- ///// selectMap   	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:selectMap()
    local value = (tonumber(self.guiEle["grid2"]:getRowData(2)) or 0)


    local pfad = "res/images/gamemodes/maps/"..value..".jpg";
    local pfad2 = "res/images/gamemodes/maps/0.jpg";

    if(fileExists(pfad)) then
        self.guiEle["image"]:setImage(pfad)
    else
        self.guiEle["image"]:setImage(pfad2)
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    self.m_clickGrid1   = function(...) self:selectGamemode(...) end
    self.m_clickGrid2   = function(...) self:selectMap(...) end

    self.hidedat        = function(...) self:hide();        self.enabled            = false; end

    -- Funktionen --
    self.m_defaultModes = _Gsettings.gameModes

    self.m_defaultMaps  = _Gsettings.gameModeMaps

    -- Events --
end

-- EVENT HANDLER --
