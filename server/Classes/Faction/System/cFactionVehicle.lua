--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

FactionVehicles = {}

CFactionVehicle = inherit(CVehicle)

local sportmotor_models =
{
	[582] = true,		-- Newsvan, die Teile sind uebelst Langsam
	[596] = true,		-- PD LS
	[599] = true,		-- Police Ranger
    [getVehicleModelFromName("FBI Rancer")] = true,
    [getVehicleModelFromName("FBI Truck")] = true,

}

local panzerung_models  =
{
    [getVehicleModelFromName("FBI Rancer")] = true,
    [getVehicleModelFromName("FBI Truck")] = true,
    [getVehicleModelFromName("Enforcer")] = true,

}

local vehicle_sirens    =
{
    ["FBI Rancer"] = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 4, 2, true, false, true, false)
        setVehicleSirens(veh, 1, 0.7, 1, 1, 0, 0, 255, 255, 255)
        setVehicleSirens(veh, 2, 0.25, 1, 1, 255, 0, 0, 255, 255)
        setVehicleSirens(veh, 3, -0.25, 1, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 4, -0.7, 1, 1, 255, 0, 0, 200, 200)
    end,

    ["Police LS"]   = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 8, 2, false, false, false, false)
        setVehicleSirens(veh, 1, 0.7, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 2, 0.25, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 3, -0.25, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 4, -0.7, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 5, 1, 2.2, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 6, -1, 2.2, 0, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 7, -1, -2.7, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 8, 1, -2.7, 0, 0, 0, 255, 200, 200)
    end,
    ["Police LV"] = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 8, 2, false, false, false, false)
        setVehicleSirens(veh, 1, 0.7, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 2, 0.25, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 3, -0.25, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 4, -0.7, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 5, 1, 2.2, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 6, -1, 2.2, 0, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 7, -1, -2.7, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 8, 1, -2.7, 0, 0, 0, 255, 200, 200)
    end,
    ["Police SF"] = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 8, 2, false, false, false, false)
        setVehicleSirens(veh, 1, 0.7, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 2, 0.25, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 3, -0.25, -0.35, 1, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 4, -0.7, -0.35, 1, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 5, 1, 2.2, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 6, -1, 2.2, 0, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 7, -1, -2.7, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 8, 1, -2.7, 0, 0, 0, 255, 200, 200)
    end,
    ["Police Ranger"] = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 8, 2, false, false, false, false)
        setVehicleSirens(veh, 1, 0.7, 0.05, 1.2, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 2, 0.25, 0.05, 1.2, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 3, -0.25, 0.05, 1.2, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 4, -0.7, 0.05, 1.2, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 5, 1, 2.2, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 6, -1, 2.2, 0, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 7, -1, -2.7, 0, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 8, 1, -2.7, 0, 0, 0, 255, 200, 200)
    end,
    ["Enforcer"]      = function(veh)
        removeVehicleSirens(veh)
        addVehicleSirens(veh, 8, 2, false, false, false, false)
        setVehicleSirens(veh, 1, 0.3, 1.15, 1.4, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 2, 0.1, 1.15, 1.4, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 3, -0.1, 1.15, 1.4, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 4, -0.4, 1.15, 1.4, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 5, 1, 3.2, -0.5, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 6, -1, 3.2, -0.5, 0, 0, 255, 200, 200)
        setVehicleSirens(veh, 7, -1, -3.9, -0.5, 255, 0, 0, 200, 200)
        setVehicleSirens(veh, 8, 1, -3.9, -0.5, 0, 0, 255, 200, 200)
    end,
}

function CFactionVehicle:constructor(iID, iVID, iFID, iInt, iDim, sKoords, sColor, sTuning, iKM, sType, iLeft)
	if(self) then
		self.ID = iID
		self.VID = iVID
		self.FID = iFID
		self.Int = iInt
		self.Dim = iDim
		self.Koords = sKoords
		self.Color = sColor
		self.Tuning = sTuning
		self.KM = iKM
		self.Type = sType
		self.Left = iLeft
		self.Faction = Factions[self.FID]
		self.HandBrake	= false;
        if(vehicle_sirens[getVehicleNameFromModel(self.VID)]) then
            vehicle_sirens[getVehicleNameFromModel(self.VID)](self);
            setElementData(self, "customSirens", true)
        end

		Factions[self.FID]["Vehicles"][self.ID] = self

		local c1,c2,c3
		c1 = gettok(self.Color,1,"|")
		c2 = gettok(self.Color,2,"|")
		c3 = gettok(self.Color,3,"|")
		c4 = gettok(self.Color,4,"|")
		c5 = gettok(self.Color,5,"|")
		c6 = gettok(self.Color,6,"|")
		self:setColor(c1,c2,c3,c4,c5,c6)
		--Eventfunktionen/EventHandler

		self.eOnVehicleExplode = bind(CFactionVehicle.onVehicleExplode, self)
		self.tAfterVehicleExplode = bind(CFactionVehicle.afterVehicleExplode, self)
		addEventHandler("onVehicleExplode", self, self.eOnVehicleExplode)

		self.eOnVehicleStartEnter = bind(CFactionVehicle.onStartEnter, self)
		addEventHandler("onVehicleStartEnter", self, self.eOnVehicleStartEnter)

		self.eOnEnter = bind(CFactionVehicle.onEnter,self)
		addEventHandler("onVehicleEnter", self, self.eOnEnter)

		self.eOnExit = bind(CFactionVehicle.onExit,self)
		addEventHandler("onVehicleExit", self, self.eOnExit)

		self.eOnStartExit = bind(CFactionVehicle.onStartExit,self)
		addEventHandler("onVehicleStartExit", self, self.eOnStartExit)

		self.eOnVehicleSwitchLock = bind(CFactionVehicle.switchLocked, self)
		addEventHandler("onVehicleSwitchLock", self, self.eOnVehicleSwitchLock)

		--Binds
		self.bSwitchEngine = bind(CFactionVehicle.switchEngine, self)

		self.switchBrakeFunc = bind(CFactionVehicle.switchHandbrake, self)

		setElementData(self, "Fraktion", self.FID);
		self:setData("FactionVehicle", true)


		self.openForEveryoneVehicle	= false;

--[[
		self.checkPermissionFunc = function(thePlayer)
			if(thePlayer:getFaction():getID() ~= self.FID or ( (thePlayer:getFaction():getType() == 1) and (not(thePlayer:isDuty())))) then
				return false;
			else
				return true;
			end
		end
]]
		self.checkPermissionFunc = false
		CVehicle.constructor(self, "Faction", true)

		self:setDirtLevel(0);
		setVehiclePlateText(self, self.Faction.ShortName);

		if(sportmotor_models[self.VID]) then
			self:AddCustomUpgrade("sportmotor");
        end

        if(panzerung_models[self.VID]) then
            self:AddCustomUpgrade("panzerung");
        end

		FactionVehicles[self.ID] = self
		toggleVehicleRespawn(self, true);
		setVehicleIdleRespawnDelay(self, 9000000)
		setVehicleRespawnDelay(self, 600000)
		self:switchHandbrake(self.HandBrake);

		if (getElementModel(self) == 417) then
			setVehicleAsMagnetHelicopter ( self )
		end
	end
end

function CFactionVehicle:destructor()

end

function CFactionVehicle:onDamage()

end

function CFactionVehicle:setKoords(iX, iY, iZ, iRx, iRy, iRz)
	self.Koords = iX.."|"..iY.."|"..iZ.."|"..iRx.."|"..iRy.."|"..iRz
	setVehicleRespawnPosition (self, iX, iY, iZ, iRx, iRy, iRz)
	self:save()
end

function CFactionVehicle:switchLocked(thePlayer)
	if(thePlayer.Fraktion:getID() == self.FID) then
		if (self:isLocked()) then
			self:setLocked(false)
			self.Locked = false
			local x,y,z = self:getPosition()
			triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_unlock.mp3")
		else
			self:setLocked(true)
			self.Locked = true
			local x,y,z = self:getPosition()
			triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_lock.mp3")
		end
		self:setData("Locked", self.Locked)
	else
		thePlayer:showInfoBox("error", "Für dieses Fahrzeug besitzt du keinen Schlüssel!")
	end
end

function CFactionVehicle:getFaction()
	return self.Faction
end

function CFactionVehicle:onStartEnter(thePlayer, theSeat)
    local sucess = false;

	if(thePlayer:getFaction():getID() == self.FID) then
        sucess = true;
    else
        if(theSeat ~= 0) then
            sucess = true
        end

        if((self.FID == 1) or (self.FID == 2)) and (thePlayer:getFaction():getType() == 1) then
            sucess = true
        end
    end


    if not(sucess) then
		cancelEvent()
		thePlayer:showInfoBox("error", "Du darfst dieses Fahrzeug nicht fahren!")
	end
end

function CFactionVehicle:onEnter(thePlayer, theSeat)
	if(theSeat == 0) then
		if not(isKeyBound(thePlayer, "b", "both", self.switchBrakeFunc)) then
			bindKey(thePlayer, "b", "down", self.switchBrakeFunc)
		end

		if(self.HandBrake) then
			self.HandBrake = false;
			self:switchHandbrake(self.HandBrake, false)
		else
			self.HandBrake = true;
			self:switchHandbrake(self.HandBrake, false)
		end
	end
end

function CFactionVehicle:onExit(thePlayer, theSeat)
	if(theSeat == 0) then
		unbindKey(thePlayer, "b", "down", self.switchBrakeFunc)

		setTimer(
			function()
				if(self.HandBrake) then
					self.HandBrake = false;
					self:switchHandbrake(self.HandBrake, false)
				else
					self.HandBrake = true;
					self:switchHandbrake(self.HandBrake, false)
				end
			end
		, 2000, 1)
	end

	self:shutAllDoors();
end

function CFactionVehicle:onStartExit(thePlayer, theSeat)
	if (self:isLocked()) then
		if (thePlayer.Fraktion:getID() ~= self.FID) then
			cancelEvent()
		end
	end
end

function CFactionVehicle:onVehicleExplode()
	setTimer(function()
		self:setPosition(2360.5498046875,-655.6201171875,128.10540771484)
	end,5000,1)
	setTimer(self.tAfterVehicleExplode, 300000, 1)
end

function CFactionVehicle:afterVehicleExplode()
	--respawnVehicle(self)
end

function CFactionVehicle:save()
	CDatabase:getInstance():query("UPDATE Faction_Vehicle SET Koords=?, KM=? WHERE ID=?", self.Koords, self.KM, self.ID)
end

function CFactionVehicle:switchEngine(thePlayer)
	if (self:getEngineState()) then
		self:setEngineState(false)
	else
		if (thePlayer:getFaction():getID() == self.FID) then
			self:setEngineState(true)
		end
	end
end

function CFactionVehicle:switchHandbrake(uPlayer, bBool)
	self.HandBrake = not (self.HandBrake);
	if(getVehicleOccupant(self)) then
		local uPlayer = getVehicleOccupant(self);
		triggerClientEvent(uPlayer, "onClientVehicleHandbrakeSwitch", uPlayer, self, self.HandBrake);
		if not(self.HandBrake) then
			setElementFrozen(self, false);
		end
	else
		if(self.HandBrake) then
			setElementFrozen(self, true)
		else
			setElementFrozen(self, false);
		end
	end
	self:setData("handbrake", self.HandBrake);
	if(uPlayer) and (bBool ~= false)  then
		if(uPlayer == getVehicleOccupant(self)) then
			local x,y,z = self:getPosition()
			if(self.HandBrake) then
				triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_break_lock.mp3")
			else
				triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_break_unlock.mp3")
			end
		end
	end
end
