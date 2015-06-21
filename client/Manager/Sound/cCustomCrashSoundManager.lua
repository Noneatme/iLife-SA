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
-- ## Name: CustomCrashSoundManager.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CustomCrashSoundManager = {};
CustomCrashSoundManager.__index = CustomCrashSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomCrashSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Collision	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomCrashSoundManager:VehicleCollision(uCollider, iForce, iBodyPart, iX, iY, iZ, iNX, iNY, iNZ, iHitElementForce, iModel)
	outputChatBox(iForce)
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomCrashSoundManager:Constructor(...)
	-- Klassenvariablen --
	
	
	-- Methoden --
	self.vehicleCollisionEvent = function(...) self:VehicleCollision(...) end;
	
	-- Events --
	
		
	addEventHandler("onClientVehicleCollision", getRootElement(), self.vehicleCollisionEvent);
	--logger:OutputInfo("[CALLING] CustomCrashSoundManager: Constructor");
end

-- EVENT HANDLER --

