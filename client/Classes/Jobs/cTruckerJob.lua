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
-- ## Name: cTruckerJob.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cTruckerJob = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// onStart     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:onStart(tblPos, tblMarker)
    self:onStop()
    self.m_tblBlips         = {}
    self.m_tblMarker        = tblMarker;

    for index, pos in pairs(tblPos) do
        local blip      = createBlip(pos[1], pos[2], pos[3], 51, 2, 0, 0, 255, 255, 0, 1337)
        self.m_tblBlips[blip] = blip;
    end

    for index, marker in pairs(self.m_tblMarker) do
        setElementDimension(marker, 0);
    end
end

-- ///////////////////////////////
-- ///// onStop     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:onStop()
    for index, blip in pairs(self.m_tblBlips) do
        if(isElement(blip)) then
            destroyElement(blip)
        end
    end

    if(self.m_tblMarker) then
        for index, marker in pairs(self.m_tblMarker) do
            setElementDimension(marker, 1337);
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:constructor(...)
    -- Klassenvariablen --
    self.m_bEnabled     = false;

    addEvent("onClientPlayerTruckerjobStop", true)
    addEvent("onClientPlayerTruckerjobStart", true)

    self.m_tblBlips     = {}
    -- Funktionen --
    self.m_funcOnStart          = function(...) self:onStart(...) end
    self.m_funcOnStop           = function(...) self:onStop(...) end

    -- Events --

    addEventHandler("onClientPlayerTruckerjobStop", getLocalPlayer(), self.m_funcOnStop)
    addEventHandler("onClientPlayerTruckerjobStart", getLocalPlayer(), self.m_funcOnStart)
end

-- EVENT HANDLER --
