--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	Sniper Resource			##
-- ## Name: Sniper.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Sniper = {};
Sniper.__index = Sniper;

--[[

]]


-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Sniper:New(...)
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

function Sniper:Constructor(...)
	
	--[[
	setWeaponProperty("sniper", "pro", "flags", 0x040000)
	setWeaponProperty("sniper", "pro", "flags", 0x010000)
	setWeaponProperty("sniper", "pro", "flags", 0x002000)
	setWeaponProperty("sniper", "pro", "flags", 0x001000)
	setWeaponProperty("sniper", "pro", "flags", 0x008000)
	
	outputDebugString("[CALLING] Sniper: Constructor");]]
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sniper:Destructor()
	--setWeaponProperty(34, "pro", "flags", getOriginalWeaponProperty(34, "pro", "flags"))
end

-- EVENT HANDLER --
