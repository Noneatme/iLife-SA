--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA Slotmachine Resource	##
-- ## Name: Slotmachine_Settings.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Slotmachine_Settings = {};
Slotmachine_Settings.__index = Slotmachine_Settings;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Slotmachine_Settings:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlaySlotSound		//////
-- ///// Returns: sound		//////
-- ///////////////////////////////

function Slotmachine_Settings:PlaySlotSound(x, y, z, dateifpad, int, dim)
	local s = playSound3D("res/sounds/slotmachine/"..dateifpad..".mp3", x, y, z)
	setSoundMaxDistance(s, 50)
	
	if(int) then
		setElementInterior(s, int)
	end
	if(dim) then
		setElementDimension(s, dim)
	end
	return s;
end

-- ///////////////////////////////
-- ///// JackPot	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:JackPot(x, y, z)
	setTimer(function()
		for i = 1, 10, 1 do
			fxAddSparks(x, y, z, 0, 0, 2, 5, 20, 0, 0, 0, false, 0.5, 5)
		end
	end, 300, 10)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine_Settings:Constructor(...)
	-- Events
	addEvent("onSlotmachineSoundPlay", true)
	addEvent("onSlotmachineWintext", true)
	addEvent("onSlotmachineJackpot", true)
	
	-- Funktionen
	self.slotmachine_sound = function(...) self:PlaySlotSound(...) end;
	self.jackpot_func = function(...) self:JackPot(...) end;
	
	self.text = "";
	self.enabled = false;
	
	-- Events
	addEventHandler("onSlotmachineSoundPlay", getLocalPlayer(), self.slotmachine_sound)
	addEventHandler("onSlotmachineJackpot", getLocalPlayer(), self.jackpot_func)
	

	--outputDebugString("[CALLING] Slotmachine_Settings: Constructor");
end

-- EVENT HANDLER --