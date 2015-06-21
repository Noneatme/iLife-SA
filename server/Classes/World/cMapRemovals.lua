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
-- ## Name: cMapRemovalsManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- ## Date: March 2015                  ##
-- #######################################

cMapRemovalsManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapRemovalsManager:removeWorldModels()
    if not(self.m_bRemoved) then
        -- SpF BASE --
        removeWorldModel(5630, 50, 1937.3569335938, -1576.4478759766, 23.150228500366)
        removeWorldModel(1307, 80, 1963.7387695313, -1592.5048828125, 14.331320762634)
        removeWorldModel(1307, 50, 1963.7387695313, -1592.5048828125, 14.331320762634)
        removeWorldModel(1308, 80, 1963.7387695313, -1592.5048828125, 14.331320762634)
        removeWorldModel(5634, 80, 1963.7387695313, -1592.5048828125, 14.331320762634)
        removeWorldModel(5639, 80, 1963.7387695313, -1592.5048828125, 14.331320762634)
        self.m_bRemoved     = true;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cMapRemovalsManager:constructor(...)
    -- Klassenvariablen --
    self.m_bRemoved         = false;

    self:removeWorldModels();

    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --
