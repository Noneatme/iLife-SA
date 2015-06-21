--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

UserVehicles = {}
UserVehiclesByPlayer = {}

CUserVehicle = inherit(CVehicle)

addEvent("onVehicleSwitchLock", true)

function CUserVehicle:constructor(iID,iOwnerID,iInt,iDim,iVID,sKoords,sColor,sTuning,sPlate,fFuel,fKM,iHealth,sHeadLights, iDirtLevel)

	-- Klassenvariablen --
	self.ID 		= iID
	self.OwnerID 	= iOwnerID
	self.Owner 		= Players[self.OwnerID]
	self.OwnerName 	= PlayerNames[self.OwnerID]
	self.Int 		= iInt
	self.Dim 		= iDim
	self.VID 		= iVID
	self.Koords 	= sKoords
	self.Color 		= sColor
	self.Tuning 	= sTuning
	self.HeadLights = sHeadLights or "255|255|255";
	self.Plate 		= sPlate
	self.Fuel 		= fFuel
	self.KM 		= fKM
	self.Health 	= iHealth
	self.Locked 	= true
	self.Engine 	= false
	self.tuningTeilPreise = TuningTeilPreise:New();

	-- Methoden --
	self:setData("Locked", self.Locked)
	self:setData("Engine", self.Engine)
	self:setData("Plate", self.Plate)
	self:setData("OwnerName", self.OwnerName)
	self:setData("ID", self.ID)
	self:setData("UserVehicle", true)

	self:setInterior(self.Int)
	self:setDimension(self.Dim)
	self:setPlateText(self.Plate)
	self:setLocked(true)
	self:setEngineState(false)
	self:setHealth(self.Health)
	self:setInterior(self.Int)
	self:setDimension(self.Dim)
	self:setDirtLevel(iDirtLevel)

	UserVehicles[tonumber(self.ID)] = self
	if (not (type(UserVehiclesByPlayer[self.OwnerID]) == "table")) then
		UserVehiclesByPlayer[self.OwnerID] = {}
	end
	table.insert(UserVehiclesByPlayer[self.OwnerID] , {["ID"]=self.ID,["VID"]=self.VID,["Plate"]=self.Plate})

	--Events

	self.eOnVehicleEnter = bind(CUserVehicle.onVehicleEnter,self)
	addEventHandler("onVehicleEnter", self, self.eOnVehicleEnter)

	self.eOnVehicleExit  = bind(CUserVehicle.onVehicleExit,self)
	addEventHandler("onVehicleStartExit", self, self.eOnVehicleExit)
	addEventHandler("onVehicleExit", self, self.eOnVehicleExit)

	self.eOnVehicleExplode = bind(CUserVehicle.onVehicleExplode, self)
	addEventHandler("onVehicleExplode", self, self.eOnVehicleExplode)

	self.eOnVehicleSwitchLock = bind(CUserVehicle.switchLocked, self)
	addEventHandler("onVehicleSwitchLock", self, self.eOnVehicleSwitchLock)

	self.switchEngineBla = bind(function(self, player, key, state)  carStart:Toggle(player, key, state, self) end, self);

	--Binds
	self.bSwitchEngine = bind(CUserVehicle.switchEngine, self)

	--Timer
	self.tDestroy = bind(CElement.destroy, self)

	self:tune() -- Tunt das Fahrzeug

	--Konstruktor CVehicle
	CVehicle.constructor(self, "User", true)
end

function CUserVehicle:tune()
	if(self.Color) and (#tostring(self.Color) > 1) then
		local tbl = split(self.Color, "|", -1);
		for index, wert in pairs(tbl) do
			tbl[index] = (tonumber(wert) or 255)
		end
		setVehicleColor(self, unpack(tbl));
	end

	if(self.HeadLights) and (#tostring(self.HeadLights) > 1) then
		local tbl = split(self.HeadLights, "|", -1);
		for index, wert in pairs(tbl) do
			tbl[index] = (tonumber(wert) or 255)
		end
		setVehicleHeadLightColor(self, unpack(tbl));
	end
	-- Tuning

	if(self.Tuning) and (#tostring(self.Tuning) > 1) then
		local tbl = split(self.Tuning, "|", -1);
		for index, wert in pairs(tbl) do
			local wat = (tonumber(wert) or 0)

			if(wat == 1) then

				if(self.tuningTeilPreise.customItemSlot[index]) then
					self:AddCustomUpgrade(self.tuningTeilPreise.customItemSlot[index]);
				end
			else
				addVehicleUpgrade(self, wat)
			end
		end

	end
end

function CUserVehicle:destructor()
	outputServerLog("Fahrzeug mit der ID "..self.ID.." wurde zerstoert!")
	UserVehicles[self.ID] = nil
end

function CUserVehicle:getID()
	return self.ID
end

function CUserVehicle:getOwnerID()
	return self.OwnerID
end

function CUserVehicle:onVehicleExit(thePlayer, seat, jacked)
	self:save()
	if(isKeyBound(thePlayer, "x", "both", self.switchEngineBla)) then
		unbindKey(thePlayer, "x", "both", self.switchEngineBla)
	end
end

function CUserVehicle:onVehicleEnter(thePlayer, seat, jacked)
	self:save()
	if( thePlayer:hasKeyForVehicle(self) ) then
		if(seat == 0) then
			if not(isKeyBound(thePlayer, "x", "both", self.switchEngineBla)) then
				bindKey(thePlayer, "x", "both", self.switchEngineBla)
			end
		end
	end
end

function CUserVehicle:onVehicleDamage(loss)
	if( not(self:isOwnerOnline()) ) then
		self:setHealth(self:getHealth())
	else
		self:setHealth(self:getHealth()-loss/10)
	end
end

function CUserVehicle:onVehicleExplode()
	self.Destroyed = true
	if( (self:isOwnerReachable()) ) then
		Players[self:getOwnerID()]:showInfoBox("warning", "Dein Fahrzeug mit dem Nummernschild: "..self.Plate.." wurde zerstört!")
		CDatabase:getInstance():query("DELETE FROM Vehicles WHERE ID=?", self.ID)
		setTimer(self.tDestroy, 2000, 1)
	else
		setTimer(function() respawnVehicle(self) end, 5000, 1 )
	end
end

function CUserVehicle:switchLocked(thePlayer)
	if not(clientcheck(thePlayer, client)) then return end
	if(thePlayer:hasKeyForVehicle(self)) then
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

function CUserVehicle:switchEngine(thePlayer)
	local yes = false
	if (self:getEngineState()) then
		self:setEngineState(false)
	else
		if (thePlayer:hasKeyForVehicle(self)) then
			self:setEngineState(true)
		else
			yes = true
		end
	end
	self:setData("Engine", self:getEngineState())
	if(yes) then
		return "nope"
	end
end

function CUserVehicle:isOwnerReachable()
	if isElement((Players[self.OwnerID])) then
		local x,y,z = getElementPosition(self)
		local x1,y1,z1 = getElementPosition(Players[self.OwnerID])
		if (getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 250) then
			return Players[self.OwnerID]
		end
	end
	return false
end

function CUserVehicle:park(thePlayer)
	if (self:getOwnerID() == thePlayer:getID()) then
		self.Int = self:getInterior()
		self.Dim = self:getDimension()

		local x,y,z = self:getPosition()
		local rx,ry,rz = self:getRotation()

		self.Koords = tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz)

		setVehicleRespawnPosition(self, x, y, z, rx, ry, rz)

		self:save()

		thePlayer:showInfoBox("info","Du hast das Fahrzeug erfolgreich geparkt!")
	else
		thePlayer:showInfoBox("error", "Dieses Fahrzeug gehört dir nicht!")
	end
end

function CUserVehicle:save()
	if (not (self.Destroyed)) then
		self.Health=self:getHealth()

		CDatabase:getInstance():query("UPDATE Vehicles SET `OwnerID`=?, `Int`=?, `Dim`=?, `Koords`=?, `Color`=?, `Tuning`=?, `Plate`=?, `Fuel`=?, `KM`=?, `Health`=?, `LichtFarbe`=?, `Dirtlevel`=? WHERE `ID`=?;", tonumber(self.OwnerID), tonumber(self.Int), self.Dim, self.Koords, self.Color, self.Tuning, self.Plate, self.Fuel, self.KM, self.Health, self.HeadLights, self.DirtLevel, self.ID)
	end
end

function CUserVehicle:respawn(thePlayer)
	if (self:getOwnerID() == thePlayer:getID()) then
		if ( getTableSize(getVehicleOccupants(self)) == 0) then
			local health = getElementHealth(self)
			respawnVehicle(self)
			self.Engine = false
			setVehicleEngineState(self, false)
			setVehicleOverrideLights(self, 0);
			self.Locked = true
			setVehicleLocked(self, true)
			setElementHealth(self, health)
			thePlayer:showInfoBox("info", "Du hast dein Fahrzeug erfolgreich respawnt!")
			self:tune();
		else
			thePlayer:showInfoBox("error", "Dieses Fahrzeug ist nicht leer!")
		end
	else
		thePlayer:showInfoBox("error", "Dieses Fahrzeug gehört dir nicht!")
	end
end

addEvent("onPlayerUserVehicleRespawn", true)
addEventHandler("onPlayerUserVehicleRespawn", getRootElement(),
	function(ID)
		if (not(clientcheck(source, client))) then return false end
		if (UserVehicles[ID]) then
			UserVehicles[ID]:respawn(client)
		end
	end
)

addEvent("onPlayerRequestUserVehicles", true)
addEventHandler("onPlayerRequestUserVehicles", getRootElement(),
	function()
		if (not(clientcheck(source, client))) then return false end
		if (not(type(UserVehiclesByPlayer[client:getID()]) == "table")) then
			UserVehiclesByPlayer[client:getID()] = {}
		end
		triggerClientEvent(client, "onClientReceivUserVehicles", client, UserVehiclesByPlayer[client:getID()])
	end
)

addEvent("onUserVehicleRespawnRequest", true)
addEventHandler("onUserVehicleRespawnRequest", getRootElement(),
function(ID)
	if (not(clientcheck(source, client))) then return false end
	UserVehicles[tonumber(ID)]:respawn(source)
end)
