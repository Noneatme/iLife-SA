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
-- ## Name: TrafficLightsManager.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TrafficLightsManager = {};
TrafficLightsManager.__index = TrafficLightsManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TrafficLightsManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// TriggerState 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrafficLightsManager:TriggerOutOfOrderState()
	if(self.outOfOrder == true) then
		
		local tbl = {[true] = 9, [false] = 6};
		
		self.outOfOrderState = not (self.outOfOrderState);
		
		setTrafficLightState(tbl[self.outOfOrderState]);
		
	else
		self:OutOfOrder(false);
	end
end

-- ///////////////////////////////
-- ///// OutOfOrder			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrafficLightsManager:OutOfOrder(bBool)
	if(isTimer(self.outOfOrderTimer)) then
		killTimer(self.outOfOrderTimer);
	end

	if(bBool) then
		self.outOfOrderTimer = setTimer(self.triggerOutOfOrderFunc, self.outOfOrderTime, -1)
	end

	setTrafficLightsLocked(self.outOfOrder);
end


-- ///////////////////////////////
-- ///// CheckState 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrafficLightsManager:CheckState()
	local day = getRealTime().weekday+1;
	
	if(day == 7) or (day == 6) or (day == 5) then
		-- Out of Order
		if(self.outOfOrder == false) then
			self.outOfOrder = true;
			self.locked 	= true;
			self:OutOfOrder(true);
			
			--outputDebugString("Setting traffic lights to out of order");
		end
	else
		if(self.outOfOrder == true) then
			self.outOfOrder = false;
			self.locked		= false;
			self:OutOfOrder(false);
			
			--outputDebugString("Setting traffic lights to normal state");
		end
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrafficLightsManager:Constructor(...)
	-- Klassenvariablen --
	self.outOfOrder 		= false;
	self.outOfOrderState 	= false;
	self.locked				= false;

	self.outOfOrderTimer 	= nil;

	self.outOfOrderTime 	= 500;

	-- Methoden --
	self.triggerOutOfOrderFunc 	= function(...) self:TriggerOutOfOrderState(...) end;	
	self.checkStateFunc			= function(...) self:CheckState(...) end;
	
	self:CheckState()

	-- Events --
	self.checkStateTimer 	= setTimer(self.checkStateFunc, 60*60*1000, 0);
		
	--logger:OutputInfo("[CALLING] TrafficLightsManager: Constructor");
end

-- EVENT HANDLER --
