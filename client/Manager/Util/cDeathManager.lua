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
-- Date: 16.01.2015
-- Time: 15:46
-- To change this template use File | Settings | File Templates.

cDeathManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cDeathManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// toggleComponents	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:toggleComponents(bBool)
    showChat(bBool)
    if(hud) then
        hud:Toggle(bBool)
    end

end

-- ///////////////////////////////
-- ///// reset      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:reset()
    setGameSpeed(1);
    insanityShader:Disable();
    self:toggleComponents(true)

end
-- ///////////////////////////////
-- ///// playerWasted3		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:playerWasted3()
    fadeCamera(false, 0, 255, 255, 255)

    setTimer(function()
        fadeCamera(true, 0.5, 255, 255, 255)
        self:reset();
    end, 50, 1)

    detachElements(getCamera())
    destroyElement(self.object);


    setCameraTarget(localPlayer)
end

-- ///////////////////////////////
-- ///// playerWasted2		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:playerWasted2()
    removeEventHandler("onClientRender", getRootElement(), self.m_funcRenderPlayerWasted1)
    fadeCamera(false, 0, 255, 255, 255)

    setTimer(function()
        fadeCamera(true, 0.5, 255, 255, 255)
    end, 50, 1)

    local x, y, z = getElementPosition(localPlayer)
    local zone  = getZoneName(x, y, z, true)
    local tbl   = self.locations["Los Santos"];
    if(self.locations[zone]) then
        tbl = self.locations[zone];
    end

    local fromTBL   = tbl[1];
    local toTBL     = tbl[2];

    local object    = createObject(1337, fromTBL[1], fromTBL[2], fromTBL[3], -30, 20, -30);
    setObjectScale(object, 0);

    local x, y, z = toTBL[1], toTBL[2], toTBL[3];
    moveObject(object, 10000, x, y, z);

    attachElements(getCamera(), object)

    self.object = object;


    self.m_sTimer[3]    = setTimer(self.m_playerWasted3Func, self.m_iTime2, 1);
end

-- ///////////////////////////////
-- ///// playerWasted1		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:playerWasted1()
    self.x, self.y, self.z, self.lx, self.ly, self.lz    = getCameraMatrix()

    self.lx, self.ly, self.lz               = getElementPosition(localPlayer)

    self.y      = self.y+(math.random(-40, 40)/10);
    self.x      = self.x+(math.random(-40, 40)/10);

    self.randZ  = math.random(65, 100)

    self.startTick      = getTickCount();
    addEventHandler("onClientRender", getRootElement(), self.m_funcRenderPlayerWasted1)

    self.m_sTimer[2]    = setTimer(self.m_playerWasted2Func, self.m_iTime2, 1);

end

-- ///////////////////////////////
-- ///// renderplayerWasted //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:renderPlayerWasted1()
    local progress      = (getTickCount()-self.startTick)/self.m_iTime1;

    if(progress > 1) then
        removeEventHandler("onClientRender", getRootElement(), self.m_funcRenderPlayerWasted1)
    end

    local x2, y2, z2 = interpolateBetween(self.x, self.y, self.z, self.x, self.y, self.z+self.randZ, progress, "InOutQuad");
    setCameraMatrix(x2, y2, z2, self.lx, self.ly, self.lz)
end

-- ///////////////////////////////
-- ///// playerWasted		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:playerWasted()
    insanityShader:Enable();
    self:toggleComponents(false)
    setGameSpeed(0.35);

    self.m_sound        = playSound(self.m_sSoundURL, false)

    self.m_sTimer[1]    = setTimer(self.m_playerWasted1Func, 1000, 1);

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDeathManager:constructor(...)
    -- Klassenvariablen --
    self.m_sSoundURL        = "http://noneat.me/sound/iLife/music_death_long.ogg";

    -- Funktionen --
    self.m_funcOnPlayerWasted       = function(...) self:playerWasted(...) end
    self.m_playerWasted1Func        = function(...) self:playerWasted1(...) end
    self.m_playerWasted2Func        = function(...) self:playerWasted2(...) end
    self.m_playerWasted3Func        = function(...) self:playerWasted3(...) end

    self.m_funcRenderPlayerWasted1  = function(...) self:renderPlayerWasted1(...) end


    self.m_sTimer               = {};

    self.m_iTime1               = 7000;
    self.m_iTime2               = 5000;
    self.m_iTime3               = 6000;

    self.locations              =
    {
        ["Los Santos"]          = {{-18.954917907715, -1455.6789550781, 140.20616149902, 76.107841491699, -1438.5487060547, 114.32902526855}, {2747.9758300781, -1677.4710693359, 100.24578857422, 2823.1088867188, -1617.9005126953, 71.849464416504}},
        ["San Fierro"]          = {{-2384.9768066406, -433.25277709961, 139.5696105957, -2354.0881347656, -341.45050048828, 114.7052154541}, {-2350.9816894531, 1326.9694824219, 79.747261047363, -2325.6887207031, 1423.3994140625, 71.90283203125}},
        ["Las Venturas"]        = {{1472.1442871094, 455.77203369141, 140.02624511719, 1524.5832519531, 539.16668701172, 122.83654785156}, {2754.3083496094, 2648.9265136719, 99.591552734375, 2797.1357421875, 2727.5998535156, 55.135822296143}},
    }

    -- Events --

    addEventHandler("onClientPlayerWasted", localPlayer, self.m_funcOnPlayerWasted);

    --self:playerWasted();

end

-- EVENT HANDLER --
