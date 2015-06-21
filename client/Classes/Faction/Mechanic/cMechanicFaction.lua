--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: MechanicFaction.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

MechanicFaction = {};
MechanicFaction.__index = MechanicFaction;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MechanicFaction:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MechanicFaction:Constructor(...)
	-- Klassenvariablen --
	self.baseSchild		= createObject(7023, 2773.1000976563, -2061.6000976563, 11.10000038147, 0, 0, 270)
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] MechanicFaction: Constructor");
end

-- EVENT HANDLER --
