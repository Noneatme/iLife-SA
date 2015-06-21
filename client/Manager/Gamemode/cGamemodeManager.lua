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
-- Date: 07.02.2015
-- Time: 21:12
-- To change this template use File | Settings | File Templates.
--

cGamemodeManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cGamemodeManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// loadMap    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:loadMap(sMap, iDim, iInt)
    mapManager:loadMap(sMap, iDim, iInt);
    self.m_sCurrentMap      = sMap;
end

-- ///////////////////////////////
-- ///// enterGamemode		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:enterGamemode(lobby)
    if not(self.m_bEnabled) then
        self.m_bEnabled     = true;
        self.m_bShown       = false;
        bindKey("backspace", "down", self.m_funcExitGamemode)

        local map = "res/maps/Gamemodes/"..lobby.m_uMap.m_iGamemode.."/"..lobby.m_uMap.m_iID..".map"
        mapManager:unloadMap(map);
        self:loadMap(map, lobby.m_uMap.m_iDimension, lobby.m_uMap.m_iInterior);
    end
end


-- ///////////////////////////////
-- ///// exitGamemode		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:exitGamemode()
    if(self.m_bEnabled) then
        self.m_bEnabled = false;
        unbindKey("backspace", "down", self.m_funcExitGamemode)

        mapManager:unloadMap(self.m_sCurrentMap);
    end
end

-- ///////////////////////////////
-- ///// showBrowser		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:showBrowser()
    self.m_gamemodeBrowser:show();
end

-- ///////////////////////////////
-- ///// exitKey    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:exitKey()
    if not(self.m_bShown) then
        self.m_bShown = true;

        local function ja()
            triggerServerEvent("onPlayerGamemodeLobbyLeave", localPlayer)
            self:exitGamemode();
        end

        local function nein()
            self.m_bShown = false;
        end

        confirmDialog:showConfirmDialog("Moechtest du diese Lobby verlassen?", ja, nein, false, false);
    end
end

-- ///////////////////////////////
-- ///// countDown   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:countDown(iCount)
    self.m_iCDStartTick   = getTickCount();

    if not(self.m_bCountdownRendered) then
        self.m_bCountdownRendered = true
        addEventHandler("onClientRender", getRootElement(), self.m_funcRenderCountdown)
    end

    self.m_iCurrentCount        = iCount;

    if(iCount ~= 0) then
        playSound("res/sounds/gamemode/countdown.ogg", false)
    else
        playSound("res/sounds/gamemode/countdown_go.ogg", false)
    end
end

-- ///////////////////////////////
-- ///// renderCountdown    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:renderCountdown()
    if not(self.m_bCountdownRendered) and (self.m_iCurrentCount) then
        removeEventHandler("onClientRender", getRootElement(), self.m_funcRenderCountdown)
        return
    end

    local fProgress = 1-(getTickCount()-self.m_iCDStartTick)/1000;

    if(fProgress < 0) then
        fProgress = 0;
    end

    if(fProgress > 1) then
        fProgress = 1
    end

    local alpha     = fProgress*255;

    local x, y = guiGetScreenSize()
    local sString = self.m_iCurrentCount;
    if(sString == 0) then sString = "Go!" end
    dxDrawText(sString, x/2, y/2, x/2, y/2, tocolor(255, 255, 255, alpha), 1, CDxWindow.gFont2, "center", "center")

    if(alpha < 0) then
        removeEventHandler("onClientRender", getRootElement(), self.m_funcRenderCountdown)
    end
end

-- ///////////////////////////////
-- ///// onGamemodeSoundPlay//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:onGamemodeSoundPlay(sSound)
    if(fileExists("res/sounds/gamemode/"..sSound)) then
        playSound("res/sounds/gamemode/"..sSound, false)
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeManager:constructor(...)
    -- Klassenvariablen --
    addEvent("onGamemodeBrowserShow", true)
    addEvent("onClientGamemodeEnter", true)
    addEvent("onClientGamemodeExit", true)
    addEvent("onGamemodeCountdownCount", true)
    addEvent("onGamemodeLobbySoundPlay", true)

    self.m_bEnabled                 = false;

    self.m_gamemodeBrowser          = cLobbybrowserGUI:new()

    -- Funktionen --
    self.m_funcShowBrowser          = function(...) self:showBrowser(...) end
    self.m_funcEnterGamemode        = function(...) self:enterGamemode(...) end
    self.m_funcExitGamemode         = function(...) self:exitKey(...) end
    self.m_funcRenderCountdown      = function(...) self:renderCountdown(...) end

    -- Events --
    addEventHandler("onGamemodeBrowserShow", getLocalPlayer(), self.m_funcShowBrowser)
    addEventHandler("onClientGamemodeEnter", getLocalPlayer(), self.m_funcEnterGamemode)
    addEventHandler("onClientGamemodeExit", getLocalPlayer(), function()  self:exitGamemode() end)
    addEventHandler("onGamemodeCountdownCount", getLocalPlayer(), function(...) self:countDown(...) end)
    addEventHandler("onGamemodeLobbySoundPlay", getLocalPlayer(), function(...) self:onGamemodeSoundPlay(...) end)
end

-- EVENT HANDLER --

