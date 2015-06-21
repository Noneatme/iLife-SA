--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CVehicle = inherit(CElement)
registerElementClass("vehicle", CVehicle)

function CVehicle:constructor(sType, iExtendedRadio, bOpenForEveryone)
	self.ExtendedRadio = iExtendedRadio
	self.Type = sType

	setElementData(self, "ExtendedRadio", self.iExtendedRadio)
	setElementData(self, "Type", self.Type)

	self.eOnVehicleDamage = bind(CVehicle.onVehicleDamage,self)
	addEventHandler("onVehicleDamage", self, self.eOnVehicleDamage)

	self.eOnVehicleStartEnter = bind(CVehicle.onVehicleStartEnter,self)
	addEventHandler("onVehicleStartEnter", self, self.eOnVehicleStartEnter)

	self.eOnVehicleEnter = bind(CVehicle.onVehicleEnter,self)
	addEventHandler("onVehicleEnter", self, self.eOnVehicleEnter)

	self.eOnVehicleExit = bind(CVehicle.onVehicleExit,self)
	addEventHandler("onVehicleExit", self, self.eOnVehicleExit)

	self.bSwitchLight = bind(CVehicle.switchLight, self)
	self.switchEngine = bind(CVehicle.switchEngine, self);

	if(bOpenForEveryone ~= nil) then
		self.openForEveryoneVehicle	= bOpenForEveryone;
	else
		self.openForEveryoneVehicle	= true;
	end

	self.switchEngineBla = bind(function(self, player, key, state)
		if(getPedOccupiedVehicle(player) == self) then
			local canToggle		= false;
			if not(self.openForEveryoneVehicle) then
				if(self.checkPermissionFunc) and (self.checkPermissionFunc(player)) then
					canToggle = true;
				end
			else
				canToggle	= true;

				if(self.Type == "User") then
					if(player:hasKeyForVehicle(self) ~= true) then
						canToggle = false
					end
				end
			end
			if(canToggle) then
				carStart:Toggle(player, key, state, self)
			else
				player:showInfoBox("error", "Du hast kein Schluessel fuer die Zuendung!");
			end
		else
			unbindKey(player, "x", "both", self.switchEngineBla);
		end
	end, self);

	if (not self.Fuel) then
		self.Fuel = 100
	end
	setElementData(self, "Fuel", self.Fuel)

	self:setOverrideLights(false)
	self:setEngineState(false)

	self.UpgradeInstalled = {}

	self.tFuelTimer = bind(CVehicle.fuelTimer, self)
	self.Fueltimer = false


	-- Schadensreduzierung --
	setVehicleHandling(self, "collisionDamageMultiplier", (getVehicleHandling(self)['collisionDamageMultiplier']/100*25))
end

function CVehicle:AddCustomUpgrade(iUpgrade)
	if not(self.CTT) then
		self.CTT = TuningTeilPreise:New();
	end
	--[[
	self.customTunings	=
	{
	["GPS"] 				= {2001, 18},
	["Kofferaum"]			= {2002, 19},
	["Grosser Tank"]		= {2003, 20},
	["Sportmotor"]			= {2004, 21},
	["Panzerung"]			= {2005, 22},
	["Ersatzreifen"]		= {2006, 23},
	["Bessere Hydraulik"] 	= {2007, 24},
	}

	]]
	iUpgrade = string.lower(iUpgrade);

	if(iUpgrade == "sportmotor") then
		setVehicleHandling(self, "engineAcceleration", (getOriginalHandling(getElementModel(self))['engineAcceleration']/100*130))
		setVehicleHandling(self, "maxVelocity", (getVehicleHandling(self)['maxVelocity']/100*130))
	end
	if(iUpgrade == "panzerung") then
		setVehicleHandling(self, "collisionDamageMultiplier", (getOriginalHandling(getElementModel(self))['collisionDamageMultiplier']/100*25))
        setElementHealth(self, 5000);
		self:setMaxHealth(5000)
	end
	if(iUpgrade == "bessere hydraulik") then
		setVehicleHandling(self, "suspensionDamping", (getOriginalHandling(getElementModel(self))['suspensionDamping']/100*150))
		setVehicleHandling(self, "suspensionHighSpeedDamping", (getOriginalHandling(getElementModel(self))['suspensionDamping']/100*150))
	end
	self.UpgradeInstalled[iUpgrade] = true;
end

function CVehicle:RemoveCustomUpgrade(iUpgrade)

	iUpgrade = string.lower(iUpgrade);

	if(iUpgrade == "sportmotor") then
		setVehicleHandling(self, "engineAcceleration", (getOriginalHandling(getElementModel(self))['engineAcceleration']))
		setVehicleHandling(self, "maxVelocity", (getOriginalHandling(getElementModel(self))['maxVelocity']))
	end
	if(iUpgrade == "panzerung") then
		setVehicleHandling(self, "collisionDamageMultiplier", (getOriginalHandling(getElementModel(self))['collisionDamageMultiplier']))
		self:setMaxHealth(1000)
	end
	if(iUpgrade == "bessere hydraulik") then
		setVehicleHandling(self, "suspensionDamping", (getOriginalHandling(getElementModel(self))['suspensionDamping']))
		setVehicleHandling(self, "suspensionHighSpeedDamping", (getOriginalHandling(getElementModel(self))['suspensionDamping']))
	end

	self.UpgradeInstalled[iUpgrade] = false;
end

function CVehicle:switchEngine(thePlayer)
	self:setEngineState(not(self:getEngineState()))
end

function CVehicle:getDoorFromSeat(iSeat)
	local tbl =
	{
		[0] = 2,
		[1] = 3,
		[2] = 4,
		[3] = 5,
	}

	return tbl[iSeat];
end

function CVehicle:enableGhostmode(iTime)
	triggerClientEvent(getRootElement(), "onClientGhostmodeElement", getRootElement(), self, iTime or 5000)
end

function CVehicle:shutAllDoors()
	for i = 2, 5, 1 do
		setVehicleDoorOpenRatio(self, i, 0, (iMS or 1000))
	end
end
function CVehicle:destructor()
end

function CVehicle:getType()
	return self.Type
end

function CVehicle:getMaxHealth()
	return self.m_iMaxHealth or 1000
end

function CVehicle:setMaxHealth(iHealth)
	self.m_iMaxHealth	= iHealth;
end
function CVehicle:getElementModel()
	return getElementModel(self)
end

function CVehicle:getOverrideLights()
	if(self) then
		if (getVehicleOverrideLights (self) == 2) then
			return true
		else
			return false
		end
	end
end

function CVehicle:setOverrideLights(bState)
	if(self) then		-- Binds Fail!
		if (bState) then
			iValue = 2
		else
			iValue = 1
		end
		self.Lights = bState
		setVehicleOverrideLights(self, iValue)
	end
end

function CVehicle:openTrunk(iMS)
	return setVehicleDoorOpenRatio(self, 1, 1, (iMS or 1000))
end

function CVehicle:closeTrunk(iMS)
	return setVehicleDoorOpenRatio(self, 1, 0, (iMS or 1000))
end

function CVehicle:addTrunkUser(uPlayer)
	if not(self.trunkOpened) then
		self.trunkOpened = {}
	end
	self.trunkOpened[uPlayer] = true;
end

function CVehicle:removeTrunkUser(uPlayer)
	if not(self.trunkOpened) then
		self.trunkOpened = {}
	end
	self.trunkOpened[uPlayer] = nil;
end

function CVehicle:getTrunkUsers()
	local users = 0
	if not(self.trunkOpened) then
		self.trunkOpened = {}
		return 0
	end

	for user, _ in pairs(self.trunkOpened) do
		if(user) and (isElement(user)) then
			users = users+1;
		else
			self.trunkOpened[user] = nil;
			table.remove(self.trunkOpened, user)
		end
	end
	return users;
end

function CVehicle:switchLight()
	if(self) then					-- Hier kommen Warnings!
		self:setOverrideLights(not(self:getOverrideLights()))

		if(self:getTowedByVehicle()) then
			self:getTowedByVehicle():setOverrideLights(self:getOverrideLights());
		end
	end
end

function CVehicle:setEngineState(state)
	if (state) then
		if self.Fuel > 0 and not self.Fueltimer or not isTimer(self.Fueltimer) then
			self.Fueltimer = setTimer(self.tFuelTimer, 10000, 1)
		end
		setElementData(self, "Engine", state)
		self.Engine = state
		return setVehicleEngineState(self, state)
	else
		if (not state) then
			setElementData(self, "Engine", state)
			self.Engine = state
			setVehicleEngineState(self, state)
		end
	end
	return false
end

function CVehicle:setDirtLevel(iLevel)
	return setElementData(self, "DirtLevel", (iLevel or 3))
end

function CVehicle:getDirtLevel()
	return (getElementData(self, "DirtLevel") or 0)
end

function CVehicle:getEngineState()
	return self.Engine
end

function CVehicle:getLightState(state)
	return getVehicleLightState(self)
end

function CVehicle:getHandling()
	return getVehicleHandling(self)
end

function CVehicle:getDoorState(door)
	return getVehicleDoorState ( self, door)
end

function CVehicle:resetHandling()
	local handling = getModelHandling(getElementModel(self))
	for index, value in pairs(handling) do
		setVehicleHandling(self, index, value);
	end
end

function CVehicle:isTowed()
	if(getElementData(self, "Towed")) then
		return getElementData(self, "Towed");
	else
		return false;
	end
end

function CVehicle:getColor(bRgb)
	return getVehicleColor (self, bRgb)
end

function CVehicle:setColor(c1,c2,c3,c4,c5,c6)
	return setVehicleColor (self, c1,c2,c3,c4,c5,c6)
end

function CVehicle:getOccupant(seat)
	return getVehicleOccupant(self, seat)
end

function CVehicle:getName()
	return getVehicleName(self)
end

function CVehicle:setLightState(state)
	return setVehicleLightState(self, state)
end

function CVehicle:setHandling(key, value)
	return setVehicleHandling(self, key, value)
end

function CVehicle:setDoorState(door, state)
	return setVehicleDoorState ( self, door, state)
end

function CVehicle:setPlateText(plateText)
--return setVehiclePlateText( self, plateText)
end

function CVehicle:setLocked(state)
	setVehicleLocked (self, state)
end

function CVehicle:isLocked()
	return isVehicleLocked(self)
end

function CVehicle:respawn()
	self:setEngineState(false)
	return respawnVehicle(self)
end

function CVehicle:blow()
	return blowVehicle(self)
end

function CVehicle:fix()
	fixVehicle(self)

	if(self.SpezialTunings) and (self.SpezialTunings["Panzerung"]) then
		self:setHealth(5000);
	end
end

function CVehicle:setDamageProof(bBool)
	return setVehicleDamageProof(self, bBool)
end

function CVehicle:getDamageProof()
	return getVehicleDamageProof(self)
end

function CVehicle:onVehicleDamage(loss)
--	self:setHealth(self:getHealth()-loss/10)

end

function CVehicle:onVehicleStartEnter(thePlayer, theSeat)
	if not(self.openForEveryoneVehicle) then
		if(self.checkPermissionFunc) then
			if not(self.checkPermissionFunc(thePlayer, theSeat)) then
				cancelEvent()
				thePlayer:showInfoBox("error", "Du hast kein Schluessel fuer dieses Fahrzeug!")
			end
		end
	end
end

function CVehicle:getFuel()
	return self.Fuel
end

function CVehicle:setFuel(iFuel)
	if (iFuel > vehicleCategoryManager:getCategoryTankSize(vehicleCategoryManager:getVehicleCategory(self))) then
		iFuel = vehicleCategoryManager:getCategoryTankSize(vehicleCategoryManager:getVehicleCategory(self))
	end
	self.Fuel = iFuel
	setElementData(self, "Fuel", self.Fuel)
end

function CVehicle:onVehicleEnter(thePlayer, seat, jacked)
	self:setEngineState(self.Engine)
	self:setOverrideLights(self.Lights)
	if (seat == 0) then
		bindKey(thePlayer, "l", "down", self.bSwitchLight)
		if not(isKeyBound(thePlayer, "x", "both", self.switchEngineBla)) then
			bindKey(thePlayer, "x", "both", self.switchEngineBla)
		end
	end
	if not self.Fueltimer or not isTimer(self.Fueltimer) then
		self.Fueltimer = setTimer(self.tFuelTimer, 10000, 1)
	end
	if(thePlayer:getPlaytimeHours() <= 1) then
		thePlayer:showInfoBox("info", "Halte 'X' gedrueckt um den Motor zu starten. Benutze 'B' um die Handbremse zu loesen.")
	end
end

function CVehicle:onVehicleExit(thePlayer, seat, jacked)
	if (seat == 0) then
		if(isKeyBound(thePlayer, "l", "down", self.bSwitchLight)) then
			unbindKey(thePlayer, "l", "down", self.bSwitchLight)
		end

		if(isKeyBound(thePlayer, "x", "both", self.switchEngineBla)) then
			unbindKey(thePlayer, "x", "both", self.switchEngineBla)
		end
	end

end

function CVehicle:fuelTimer()
	if (not self or not isElement(self)) then
		return false
	end
	if (getElementData(self, "noobcar")) then
		return false
	end
	local cat = vehicleCategoryManager:getVehicleCategory(self)
	if vehicleCategoryManager:isNoFuelVehicleCategory(cat) then -- Fahrraeder oder Trailer
		return false
	end
	if getVehicleEngineState ( self ) then
		local vx, vy, vz = getElementVelocity ( self )

		local vehfactor = 1800

		if self.UpgradeInstalled["grosser tank"] then
				vehfactor = vehfactor * 2
		end


		if vehfactor then
			local mileage = vehicleCategoryManager:getCategoryMileage(cat)
			local speed = math.floor (math.sqrt(vx^2 + vy^2 + vz^2)*214) / vehfactor*(mileage/10) + 0.2
			self:setFuel(self.Fuel - speed)
			if self.Fueltimer and isTimer(self.Fueltimer) then
				killTimer(self.Fueltimer)
			end

			if self.Fuel <= 0 then
				if getVehicleOccupant ( self, 0 ) then
					getVehicleOccupant ( self, 0 ):showInfoBox("warning", "Dir ist das Benzin ausgegangen!")
				else

				end
				setVehicleEngineState ( self, false)
				self:setFuel(0)
			else
				self.Fueltimer = setTimer(self.tFuelTimer, 10000, 1)
			end
		end
	else
	end
end

function CVehicle:addSirens(...)
	return addVehicleSirens(self, ...)
end

function CVehicle:setSirens(...)
	return setVehicleSirens(self, ...)
end

function CVehicle:removeSirens(...)
	return removeVehicleSirens(self, ...)
end
function CVehicle:getSirens(...)
	return getVehicleSirens(self, ...)
end

function CVehicle:setSirensOn(...)
	return setVehicleSirensOn(self, ...)
end


addEventHandler("onVehicleStartEnter", getRootElement(), function(thePlayer)
	if not(source.getFuel) then
		enew(source, CVehicle, 1, false);
		outputDebugScript("Created new CVehicle Instance for Vehicle "..tostring(source));
	end
end)
