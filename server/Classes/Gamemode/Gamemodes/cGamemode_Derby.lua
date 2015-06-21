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
-- Time: 23:46
-- To change this template use File | Settings | File Templates.
--

cGamemode_Derby = inherit(cGamemode);

--[[

]]
-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cGamemode_Derby:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// onStart     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode_Derby:onStart()
    -- Reset all Timers
    --[[
    for index, timer in pairs(self.m_tblPlayerContactTimer) do
        if(isTimer(timer)) then
            killTimer(timer)
        end
    end

    local players       = self:getPlayingPlayers()

    for index, player in pairs(players) do
        self.m_tblPlayerContactTimer[player]    = setTimer(self.m_funcOnContactTimerAblauf, self.m_iContactTimerTime, 1, player)
    end--]]
    -- BUGGY DONT WORK

end

-- ///////////////////////////////
-- onPlayerContacttimerAblauf
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode_Derby:onPlayerContacttimerAblauf(uPlayer)
    if(uPlayer) and (isElement(uPlayer)) and (self:isPlayerInGamemode(uPlayer)) then

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemode_Derby:constructor(uMap, ...)
    -- Klassenvariablen --
    -- Kontakttimer --
    self.m_tblPlayerContactTimer        = {}
    self.m_iContactTimerTime            = 60000;        -- Contacttimer Seconds

    -- Funktionen --
    self.m_funcOnContactTimerAblauf     = function(...) self:onPlayerContacttimerAblauf(...) end

    -- Events --
    cGamemode.constructor(self, 1, uMap, ...)
    
end

-- EVENT HANDLER --
