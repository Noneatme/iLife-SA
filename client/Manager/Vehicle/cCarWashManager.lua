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
-- ## Name: CarWashManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CarWashManager = {};
CarWashManager.__index = CarWashManager;

addEvent("onCarwashStop", true)
addEvent("onCarwashStart", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CarWashManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoopBuersten 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:LoopBuersten()
	if(self.buerstenVar) then
		for index, buerste in pairs(self.buersten) do
			stopObject(buerste);
			moveObject(buerste, 1000, self.defaultPosition[index][1]+2, self.defaultPosition[index][2], self.defaultPosition[index][3], 0, 0, 0, "InOutQuad")

		end
	else
		for index, buerste in pairs(self.buersten) do
			stopObject(buerste);
			moveObject(buerste, 1000, self.defaultPosition[index][1]-2, self.defaultPosition[index][2], self.defaultPosition[index][3], 0, 0, 0, "InOutQuad")
			setElementPosition(buerste, unpack(self.defaultPosition[index]))
		end
	end

	self.buerstenVar	= not (self.buerstenVar)
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Render()
	if(self.enabled == true) then
		if(isPedInVehicle(localPlayer)) then
			local speed	= self:GetElementSpeed(getPedOccupiedVehicle(localPlayer), "kmh")

			if(speed > 5) then
				self:SetElementSpeed(getPedOccupiedVehicle(localPlayer), "kmh", 5);
			end
		end
	end
end

-- ///////////////////////////////
-- ///// GetElementSpeed 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:GetElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end
-- ///////////////////////////////
-- ///// SetElementSpeed	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:SetElementSpeed(element, unit, speed) -- only work if element is moving!
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then -- if true - element is valid, no need to check again
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end

	return false
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CarWashManager:Constructor(...)
	-- Klassenvariablen --

	self.enabled		= false;

	self.schild1		= createObject(3334, 2506.8994140625, -1471.8994140625, 24.200000762939, 0, 0, 0);
	self.schild2		= createObject(3334, 2440.8994140625, -1468, 24.39999961853, 0, 0, 180);

	self.pfade			= {}

	self.buersten	=
	{
		["oben_1"]		= createObject(7312, 2487.6999511719, -1462.6999511719, 29.89999961853, 90, 180, 180),
		["oben_2"]		= createObject(7312, 2487.69921875, -1459.5, 29.89999961853, 90, 180, 180),
		["unten_1"]		= createObject(7312, 2475.6999511719, -1461.1999511719, 25.200000762939, 0, 0, 180),

	}


	self.sounds			= {
		["water"]		= playSound3D("http://publicsounds.noneatme.de/waschanlage/amb_water.mp3", 2493.2790527344, -1460.2241210938, 24.021591186523, true),
		["buersten"]	= playSound3D("http://publicsounds.noneatme.de/waschanlage/amb_buersten.mp3", 2474.7336425781, -1461.1313476563, 24.008670806885, true),
		["fans"]		= playSound3D("http://publicsounds.noneatme.de/waschanlage/amb_fans.mp3", 2457.8305664063, -1461.2609863281, 24, true),
	}

	setSoundMaxDistance(self.sounds["water"], 25)
	setSoundMaxDistance(self.sounds["buersten"], 25)
	setSoundMaxDistance(self.sounds["fans"], 25)
	
	self.defaultPosition	= {}

	do
		for index, buerste in pairs(self.buersten) do
			self.defaultPosition[index] = {getElementPosition(buerste)};
			self.defaultPosition[index][1] = self.defaultPosition[index][1]-2

			setElementCollisionsEnabled(buerste, false)
		end

	end

	self.loopBuerstenFunc	= function(...) self:LoopBuersten(...) end;


	self.buerstenVar		= false;
	self:LoopBuersten()

	self.carwashStartFunc	= function() self.enabled = true end;
	self.carwashStopFunc	= function() self.enabled = false end;
	self.renderFunc			= function() self:Render() end;

	self.loopTimer	= setTimer(self.loopBuerstenFunc, 1000, 0);

	-- Methoden --
	FrameTextur:New(self.schild1, "big_cock", "carwash/parken.jpg");
	FrameTextur:New(self.schild2, "big_cock", "carwash/wrongway.jpg");

	-- Events --
	addEventHandler("onCarwashStart", getLocalPlayer(), self.carwashStartFunc)
	addEventHandler("onCarwashStop", getLocalPlayer(), self.carwashStopFunc)

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	--logger:OutputInfo("[CALLING] CarWashManager: Constructor");
end
