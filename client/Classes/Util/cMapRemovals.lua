--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: MapRemoval.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

MapRemoval = {};
MapRemoval.__index = MapRemoval;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MapRemoval:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Startup	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MapRemoval:Startup()

end

-- ///////////////////////////////
-- ///// Remove		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MapRemoval:Remove()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MapRemoval:Constructor(...)
	self:Startup()
	
	
	self:Remove()
	--outputDebugString("[CALLING] MapRemoval: Constructor");
end

-- EVENT HANDLER --
