--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cAFKManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cAFKManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// onKey       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAFKManager:onKey()
    if(isTimer(self.m_uTimer)) then
        killTimer(self.m_uTimer)
    end

    self.m_uTimer       = setTimer(self.m_funcGoAFK, self.m_iTimeToWait, 1)

    if(localPlayer:getData("p:AFK")) then
        localPlayer:setData("p:AFK", false)
    end
end

-- ///////////////////////////////
-- ///// onAFKGo       		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAFKManager:onAFKGo()
    if not(localPlayer:getData("p:AFK")) then
        localPlayer:setData("p:AFK", true)
    end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAFKManager:constructor(...)
    -- Klassenvariablen --
    self.m_funcOnKey        = function(...) self:onKey(...) end
    self.m_funcGoAFK        = function(...) self:onAFKGo(...) end

    self.m_uTimer           = false;
    self.m_iTimeToWait      = 30000;

    -- Funktionen --
    addEventHandler("onClientKey", getRootElement(), self.m_funcOnKey)

    -- Events --
end

-- EVENT HANDLER --
