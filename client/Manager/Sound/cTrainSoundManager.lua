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
-- ## Name: TrainSoundManager.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TrainSoundManager = {};
TrainSoundManager.__index = TrainSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TrainSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// CheckSounds		//////
-- ///// Returns: nil	//////
-- ///////////////////////////////

function TrainSoundManager:CheckSounds()
	
	setWorldSoundEnabled(7, 0, false)
	setWorldSoundEnabled(7, 2, false)
	
	if(self.hornPlay == true) then
		if(isPedInVehicle(localPlayer) == false) then
			if(isElement(self.lastVehicle)) then
				triggerServerEvent("onTrainSoundPlay", getLocalPlayer(), self.lastVehicle, "train_horn_end")
				self.hornPlay = false;
			end
		end
	end

	for index, train in pairs(getElementsByType("vehicle", getRootElement(), true)) do
		if(self:IsTrain(getElementModel(train))) then
			if not(isElement(self.trainSounds.idleSounds[train])) then
				local x, y, z = getElementPosition(train)

				self.trainSounds.idleSounds[train] = playSound3D(self.pfade.sounds.."train_engine_idle.mp3", x, y, z, true)
				setSoundMaxDistance(self.trainSounds.idleSounds[train], 100);
				setSoundVolume(self.trainSounds.idleSounds[train], 0.1)
				attachElements(self.trainSounds.idleSounds[train], train, 0, 2, 0)

				self.trainSounds.railSounds[train] = playSound3D(self.pfade.sounds.."train_wheels_loop.mp3", x, y, z, true)
				setSoundMaxDistance(self.trainSounds.railSounds[train], 150);
				setSoundVolume(self.trainSounds.railSounds[train], 0.45)
				attachElements(self.trainSounds.railSounds[train], train, 0, 0, -0.5)

			end

			if(isElement(self.trainSounds.railSounds[train])) then
				local speed = getElementSpeed(train);
				speed = speed/150
				local b1, b2, b3, b4 = getSoundProperties(self.trainSounds.railSounds[train])


				if(speed > 1.2) then
					speed = 1.2
				elseif(speed < 0.1) or (isTrainDerailed(train)) then
					speed = 0.01
				end

				setSoundSpeed(self.trainSounds.railSounds[train], speed)
				if(getVehicleEngineState(train) == false) then
					setSoundVolume(self.trainSounds.idleSounds[train], 0)
				else
					setSoundVolume(self.trainSounds.idleSounds[train], 0.1)
				end
			end
		end
	end

	for index, sound in pairs(self.trainSounds.idleSounds) do
		if not(isElement(index)) then
			destroyElement(self.trainSounds.idleSounds[index])
			destroyElement(self.trainSounds.railSounds[index])
			self.trainSounds.idleSounds[index] = nil
		end
	end
end

-- ///////////////////////////////
-- ///// PlayTrainSound		//////
-- ///// Returns: nil	//////
-- ///////////////////////////////

function TrainSoundManager:PlayTrainSound(train, sound)
	if(sound == "brakesound") then
		local x, y, z = getElementPosition(train)
		self.trainSounds.brakeSounds[train] = playSound3D(self.pfade.sounds.."squeal/train_squeal_0"..math.random(1, self.maxSquealSounds)..".mp3", x, y, z, false)
		setSoundMaxDistance(self.trainSounds.brakeSounds[train], 150);
		setSoundVolume(self.trainSounds.brakeSounds[train], 0.3)
		attachElements(self.trainSounds.brakeSounds[train], train, 0, 0, -0.5)

	else
		local oldlength = 0
		local oldsound = self.currentSounds[train];
		if(isElement(self.trainSounds.hornnear[train])) then
			local sound1, sound2 = self.trainSounds.hornfar[train], self.trainSounds.hornnear[train]
			oldlength = getSoundPosition(self.trainSounds.hornnear[train]);
			if(sound == "train_horn_end") then
				setTimer(destroyElement, 50, 1, sound1)
				setTimer(destroyElement, 50, 1, sound2)
			else
				setTimer(destroyElement, 100, 1, sound1)
				setTimer(destroyElement, 100, 1, sound2)
			end

		end

		if(isTimer(self.trainSoundLoopTimer[train])) then
			killTimer(self.trainSoundLoopTimer[train]);
		end

		local x, y, z = getElementPosition(train)

		local loop = false
		if(sound == "train_horn_loop") then
			loop = true;
		end

		self.trainSounds.hornnear[train] = playSound3D(self.pfade.sounds.."near/"..sound..".mp3", x, y, z, loop);
		setSoundMaxDistance(self.trainSounds.hornnear[train], 250);
		setSoundMinDistance(self.trainSounds.hornnear[train], 0);
		self.trainSounds.hornfar[train] = playSound3D(self.pfade.sounds.."far/"..sound..".mp3", x, y, z, loop);
		local s = setSoundMinDistance(self.trainSounds.hornfar[train], 0);
		setSoundMaxDistance(self.trainSounds.hornfar[train], 550);
		if(sound == "train_horn_end") and (oldsound == "train_horn_start") then
			setSoundPosition(self.trainSounds.hornnear[train], (-getSoundLength(self.trainSounds.hornnear[train])/2)+(getSoundLength(self.trainSounds.hornnear[train])-oldlength))
			setSoundPosition(self.trainSounds.hornfar[train], (-getSoundLength(self.trainSounds.hornfar[train])/2)+(getSoundLength(self.trainSounds.hornfar[train])-oldlength))

		end
		if(sound == "train_horn_start") then
			self.trainSoundLoopTimer[train] = setTimer(self.trainSoundPlayFunc, (getSoundLength(self.trainSounds.hornnear[train])*1000)-32, 1, train, "train_horn_loop")
		end

		attachElements(self.trainSounds.hornnear[train], train);
		attachElements(self.trainSounds.hornfar[train], train);

		self.currentSounds[train] = sound;
	end

end

-- ///////////////////////////////
-- ///// TriggerHorn		//////
-- ///// Returns: nil		//////
-- ///////////////////////////////

function TrainSoundManager:TriggerHorn(key, state)
	if(isPedInVehicle(localPlayer)) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if(self:IsTrain(getElementModel(vehicle))) and (getVehicleOccupant(vehicle) == localPlayer) then
			if(state == "down") then
				self.hornPlay = true;
				self.lastVehicle = vehicle;
				triggerServerEvent("onTrainSoundPlay", getLocalPlayer(), vehicle, "train_horn_start")
			else
				triggerServerEvent("onTrainSoundPlay", getLocalPlayer(), vehicle, "train_horn_end")
				self.hornPlay = false;
			end
		end
	end
end

-- ///////////////////////////////
-- ///// TriggerBrakeFunc	//////
-- ///// Returns: nil		//////
-- ///////////////////////////////

function TrainSoundManager:TriggerBrakeFunc(key, state)
	if(isPedInVehicle(localPlayer)) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if(self:IsTrain(getElementModel(vehicle))) and (getVehicleOccupant(vehicle) == localPlayer) then
			if(self.canTriggerBrakeSound == true) then
				-- Check

				if(self:IsTrainBreaking(vehicle, key) == true) then
					triggerServerEvent("onTrainSoundPlay", getLocalPlayer(), vehicle, "brakesound")
					self.canTriggerBrakeSound = false;
					setTimer(function() self.canTriggerBrakeSound = true end, 10000, 1);
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// IsTrain			//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function TrainSoundManager:IsTrain(model)
	if(self.trainModels[model]) and (self.trainModels[model] == true) then
		return true;
	end

	return false;
end

-- ///////////////////////////////
-- ///// IsTrainBreaking	//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function TrainSoundManager:IsTrainBreaking(vehicle, key)
	if(key ~= "accelerate") then
		if(getTrainSpeed(vehicle) > 0) then
			return true;
		else
			return false;
		end
	else
		if(getTrainSpeed(vehicle) < 0) then
			return true;
		else
			return false;
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainSoundManager:Constructor(...)
	-- Attribute --
	self.pfade = {}
	self.pfade.sounds = "res/sounds/train/"


	self.trainSounds 				= {}
	self.trainSounds.idleSounds 	= {}
	self.trainSounds.hornfar		= {}
	self.trainSounds.hornnear		= {}
	self.trainSounds.railSounds 	= {}
	self.trainSounds.brakeSounds	= {}
	self.currentSounds = {}

	self.trainSoundLoopTimer = {}

	self.hornPlay = false;
	self.canTriggerBrakeSound = true;
	self.lastVehicle = nil;
	self.maxSquealSounds = 7;


	self.trainModels =
	{
		[449] = true,
		[537] = true,
		[538] = true,
	}

	addEvent("onTrainSoundPlayClient", true)

	-- Methoden --

	self.checkSoundsFunc = function() self:CheckSounds() end;
	self.trainSoundPlayFunc = function(...) self:PlayTrainSound(...) end;
	self.triggerHornFunc = function(...) self:TriggerHorn(...) end;
	self.triggerBrakeSound = function(...) self:TriggerBrakeFunc(...) end;

	-- Events --

	bindKey("horn", "both", self.triggerHornFunc)
	bindKey("brake_reverse", "down", self.triggerBrakeSound)
	bindKey("accelerate", "down", self.triggerBrakeSound)

	addEventHandler("onTrainSoundPlayClient", getRootElement(), self.trainSoundPlayFunc)
	setTimer(self.checkSoundsFunc, 1000, -1)
	--outputDebugString("[CALLING] TrainSoundManager: Constructor");
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
		end
	else
		--outputDebugString("Not an element. Can't get speed")
		return false
	end
end


-- EVENT HANDLER --

trainSoundManager = TrainSoundManager:New();