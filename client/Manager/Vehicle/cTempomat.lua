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
-- ## Name: cTempomatManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cTempomatManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cTempomatManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTempomatManager:constructor(...)
    -- Klassenvariablen --


    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --
