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

cLobbybrowserGUI = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cLobbybrowserGUI:new(...)
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

function cLobbybrowserGUI:show()
    if not(clientBusy) then
        if (self.enabled) then
            self:hide()
        end
        self:createElements()
        self.enabled = true
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
    end
end

-- ///////////////////////////////
-- ///// updateTime 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:updateTime()
    self.guiEle["label2"]:setText(self.Time);
end



-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	    = new(CDxWindow, "iLife Lobbybrowser", 800, 350, true, true, "Center|Middle", 0, 0, {tocolor(125, 225, 155, 255), false, "Hall of Games"}, "Weahle ein Gamemode aus, und klicke auf 'Spiel Beitreten' um zu beginnen.")
        self.guiEle["window"]:setHideFunction(self.hidedat)

        self.guiEle["label1"]       = new(CDxLabel, "Klicke auf ein Item um die Lobbys zu sehen.", 15, 10, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["label2"]       = new(CDxLabel, "Gamemode:", 100, 40, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])
        self.guiEle["label3"]       = new(CDxLabel, "Lobbys:", 490, 40, 300, 20, tocolor(255, 255, 255, 255), 1, false, "left", "top", self.guiEle["window"])

        self.guiEle["grid1"]        = new(CDxList, 10, 60, 230, 260, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["grid1"]:addColumn("Event");
        self.guiEle["grid1"]:addColumn("ID");
        -- GRID 1 --

        for index, name in pairs(self.m_defaultModes) do
            self.guiEle["grid1"]:addRow(name.."|"..index)
        end

        self.guiEle["grid1"]:addClickFunction(function()
            triggerServerEvent("onPlayerLobbybrowserGamemodesRequest", localPlayer, tonumber(self.guiEle["grid1"]:getRowData(2)));
            loadingSprite:setEnabled(true)
        end)

        self.guiEle["grid2"]        = new(CDxList, 270, 60, 500, 260, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["grid2"]:addColumn("LobbyID");
        self.guiEle["grid2"]:addColumn("Lobby Name");
        self.guiEle["grid2"]:addColumn("Eintritt");
        self.guiEle["grid2"]:addColumn("Spieler");
        self.guiEle["grid2"]:addColumn("Max. Spieler");
        self.guiEle["grid2"]:addColumn("Map");
        self.guiEle["grid2"]:addColumn("Status");

        self.guiEle["grid1"]:addClickFunction(self.m_clickGrid1)

        self.guiEle["button_1"]        = new(CDxButton, "Spiel Beitreten", 270, 10, 180, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["button_2"]        = new(CDxButton, "Lobby Erstellen", 590, 10, 180, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

        self.guiEle["button_1"]:addClickFunction(function()
            local value = tonumber(self.guiEle["grid2"]:getRowData(1))
            if(value) then
                local lobby = self.m_tblLobbys[value]

                local function beitreten(iInt)
                    triggerServerEvent("onPlayerGamemodeLobbyBeitrete", localPlayer, value, iInt)
                    self:hide();
                    loadingSprite:setEnabled(true)
                end

                if(lobby.m_bZuschauerAllowed) then
                    local function ja()
                        beitreten(1)
                    end

                    local function nein()
                        beitreten()
                    end
                    self:hide();
                    confirmDialog:showConfirmDialog("Moechtest du als Zuschauer beitreten?", ja, nein, false, false);
                else
                    beitreten()
                end
            else
                showInfoBox("error", "Du musst eine Lobby auswaehlen!")
            end
        end)

        self.guiEle["button_2"]:addClickFunction(function()
            self:hide()
            cGamemodeGUI:new():show()
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

function cLobbybrowserGUI:selectGamemode()
    local value = tonumber(self.guiEle["grid1"]:getRowData(2))

end

-- ///////////////////////////////
-- ///// selectMap   	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:selectMap()
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
-- ///// onLobbysReceive 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:onLobbysReceive(tblLobbys)
    loadingSprite:setEnabled(false)
    if(self.guiEle["window"]) then
        self.guiEle["grid2"]:clearRows();
        self.m_tblLobbys = {}

        for index, lobby in pairs(tblLobbys) do
            local status = lobby.m_sStatus;
            if(status ~= "Beendet") then
                self.m_tblLobbys[lobby.m_iID] = lobby;
                self.guiEle["grid2"]:addRow(lobby.m_iID.."|"..lobby.m_sName.."|$"..lobby.m_iCost.."|"..lobby.m_iCurPlayers.."|"..lobby.m_iMaxPlayers.."|".._Gsettings.gameModeMaps[lobby.m_iType][lobby.m_iMap][1].."|"..status);
            end
        end


    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cLobbybrowserGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    self.m_clickGrid1   = function(...) self:selectGamemode(...) end
    self.m_clickGrid2   = function(...) self:selectMap(...) end

    self.hidedat        = function() self:hide() end
    self.m_funcReceiveLobbys    = function(...) self:onLobbysReceive(...) end

    addEvent("onClientPlayerReceiveGamemodeLobbys", true)

    -- Funktionen --
    self.m_defaultModes = _Gsettings.gameModes

    self.m_defaultMaps  = _Gsettings.gameModeMaps

    addEventHandler("onClientPlayerReceiveGamemodeLobbys", getLocalPlayer(), self.m_funcReceiveLobbys)
    -- Events --
end

-- EVENT HANDLER --



--cLobbybrowserGUI:new():show()