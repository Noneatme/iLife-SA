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
-- ## Name: CarStart.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CarStart = {};
CarStart.__index = CarStart;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CarStart:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// VehicleSound 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarStart:VehicleSound(vehicle, was)
	local x, y, z = getElementPosition(vehicle);

	if(isElement(self.vehicleSound[vehicle])) then
		if(isTimer(self.vehicleTurnTimer[vehicle])) then
			killTimer(self.vehicleTurnTimer[vehicle])
		end
		local sound = self.vehicleSound[vehicle]
		setTimer(function()
			if(isElement(sound)) then
				destroyElement(sound);
			end
		end, 200, 1)
	end

	self.vehicleSound[vehicle] = playSound3D(self.pfade.sounds..was..".mp3", x, y, z);
	setSoundVolume(self.vehicleSound[vehicle], 1)
	attachElements(self.vehicleSound[vehicle], vehicle)
	setElementDimension(self.vehicleSound[vehicle], getElementDimension(vehicle))
	setElementInterior(self.vehicleSound[vehicle], getElementInterior(vehicle))
	setSoundMaxDistance(self.vehicleSound[vehicle], 50)

	if(was == "engine_start") then
		self.vehicleTurnTimer[vehicle] = setTimer(function()
			if(isElement(vehicle)) then
				if(self.vehicleTurnVar[vehicle] == 1) then
					setVehicleTurnVelocity(vehicle, 0.01, 0.01, 0)
					self.vehicleTurnVar[vehicle] = 0
				else
					setVehicleTurnVelocity(vehicle, -0.01, -0.01, 0)
					self.vehicleTurnVar[vehicle] = 1
				end
			else
				killTimer(self.vehicleTurnTimer[vehicle])
			end
		end, 100, -1)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarStart:Constructor(...)
	addEvent("onVehicleStartSound", true)


	self.pfade = {}
	self.pfade.sounds = "res/sounds/car/"

	self.vehicleSound = {}
	self.vehicleTurnTimer = {}
	self.vehicleTurnVar = {}

	self.vehicleSoundFunc = function(...) self:VehicleSound(...) end;

	addEventHandler("onVehicleStartSound", getRootElement(), self.vehicleSoundFunc)
	--outputDebugString("[CALLING] CarStart: Constructor");
end

-- EVENT HANDLER --
