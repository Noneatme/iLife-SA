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
-- ## Name: UserVehicleManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

UserVehicleManager = {};
UserVehicleManager.__index = UserVehicleManager;

addEvent("onClientVehicleHandbrakeSwitch", true)
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function UserVehicleManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// SwitchHandbrake	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function UserVehicleManager:SwitchHandbrake(uVehicle, bBool)
	self.handbrakeState = bBool;
	self.vehicle		= uVehicle;
	setControlState("handbrake", bBool)
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function UserVehicleManager:Render()
	if(isPedInVehicle(localPlayer)) and (getPedOccupiedVehicle(localPlayer)) then
		local dingens = getElementData(getPedOccupiedVehicle(localPlayer), "handbrake")
		if(self.vehicle == getPedOccupiedVehicle(localPlayer)) or (dingens) then
			if(self.handbrakeState == true) or (dingens) then
				setControlState("handbrake", true)
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function UserVehicleManager:Constructor(...)
	-- Klassenvariablen --
	self.handbrakeState = false;
	self.vehicle		= false;

	-- Methoden --
	self.switchHandbrakeFunc	= function(...) self:SwitchHandbrake(...) end;
	self.renderFunc				= function(...) self:Render(...) end;
	-- Events --
	addEventHandler("onClientVehicleHandbrakeSwitch", getLocalPlayer(), self.switchHandbrakeFunc)

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
	--logger:OutputInfo("[CALLING] UserVehicleManager: Constructor");
end

-- EVENT HANDLER --
