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


local player_sell_anfragen = {}

function CUserVehicle:constructor(iID,iOwnerID,iInt,iDim,iVID,sKoords,sColor,sTuning,sPlate,fFuel,fKM,iHealth,sHeadLights, iDirtLevel, sAbstellPos, iPaintJob, sSpezialTunings, tKeys, iInventory, miscSettings, sKaufDatum)

	-- Klassenvariablen --
	self.ID 		= iID
	self.OwnerID 	= iOwnerID
	self.Owner 		= Players[self.OwnerID]
	self.OwnerName 	= PlayerNames[self.OwnerID]
	self.Int 		= iInt
	self.Dim 		= iDim
	self.VID 		= iVID
	self.Koords 	= sKoords
	self.Fuel 		= fFuel
	self.Color 		= sColor
	self.Tuning 	= sTuning
	self.HeadLights = sHeadLights or "255|255|255";
	self.Plate 		= sPlate
	self.KM 		= fKM
	self.Health 	= iHealth
	self.Locked 	= true
	self.Engine 	= false
	self.AbstellPos = sAbstellPos;
	self.Freezed	= false;
	self.tuningTeilPreise = TuningTeilPreise:New();
	self.UpgradeInstalled = {}
	self.Paintjob	= tonumber(iPaintJob) or 0
	self.Dirtlevel 	= tonumber(iDirtLevel) or 0
	self.HandBrake	= false;
	self.SpezialTunings = sSpezialTunings;
	self.VehicleName = getVehicleNameFromModel(iVID);

	self.keys			= ((tKeys and fromJSON(tKeys)) or {})
	self.miscSettings	= ((miscSettings and fromJSON(miscSettings)) or {});

	self.iVariant1	= tonumber(self.miscSettings["variant1"]) or 255;
	self.iVariant2 	= tonumber(self.miscSettings["variant2"]) or 255;

	self:setVariant(self.iVariant1, self.iVariant2)

	local saveAgain		= false;
	if not(self.keys) then self.keys = {} end;

	for index, bla in pairs(self.keys) do
		self.keys[tonumber(index)] = bla;
	end

	self:setData("takeys", toJSON(self.keys))
	self:setData("Kaufdatum", sKaufDatum);


	if(self.SpezialTunings) then
		self.SpezialTunings = fromJSON(self.SpezialTunings);

		if not(self.SpezialTunings) then
			self.SpezialTunings = {}
		end
	else
		self.SpezialTunings = {}
	end

	self.iInventory	= (tonumber(iInventory))
	self.Inventory	= Inventories[self.iInventory];

	if not(self.iInventory) or not(self.Inventory) then
		self.iInventory, self.Inventory = CInventory:generateNewInventory();

		saveAgain 		= true;
	end

	self.Inventory:setMaxGewicht(CUserVehicleManager:getInstance().m_tblVehicleTrunks[tonumber(self.VID)] or 250000)

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
	self:setHealth(1000)
	self:setInterior(self.Int)
	self:setDimension(self.Dim)
	self:setDirtLevel(iDirtLevel)

	UserVehicles[tonumber(self.ID)] = self
	if (not (type(UserVehiclesByPlayer[self.OwnerID]) == "table")) then
		UserVehiclesByPlayer[self.OwnerID] = {}
	end

	self.tableTable = {["ID"]=self.ID,["VID"]=self.VID,["Plate"]=self.Plate, ["Vehicle"]=self};
	table.insert(UserVehiclesByPlayer[self.OwnerID], self.tableTable)

	-- Abstell Position --

	self:checkAbstellPosition();

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

	self.eOnModelChange		= bind(CUserVehicle.onModelChange, self);
	addEventHandler("onElementModelChange", self, self.eOnModelChange);

	--Binds
	self.bSwitchEngine = bind(CUserVehicle.switchEngine, self)

	self.switchBrakeFunc = bind(CUserVehicle.switchHandbrake, self)


	self.checkPermissionFunc = function(thePlayer, iSeat)
		if(iSeat == 0) then
			if(thePlayer.hasKeyForVehicle) and (thePlayer:hasKeyForVehicle(self)) then
				return true;
			end
			return false
		else
			return true;
		end
	end
	--Timer

	self.tDestroy = bind(CElement.destroy, self)

	self:tune() -- Tunt das Fahrzeug


	self:switchHandbrake(self.HandBrake);

	self:setDamageProof(true);
	--Konstruktor CVehicle
	CVehicle.constructor(self, "User", true, false)


	self.openForEveryoneVehicle	= true;

	if(saveAgain) then
		self:save();
	end
end

function CUserVehicle:setVariant(i1, i2)
	setVehicleVariant(self, i1, i2);
	self.iVariant1	= i1;
	self.iVariant2 	= i2;
end

function CUserVehicle:setAbstellPosition(iX, iY, iZ, rX, rY, rZ)
	self.AbstellPos = iX.."|"..iY.."|"..iZ.."|"..rX.."|"..rY.."|"..rZ;
	self:save();

	if(tonumber(iX) == 0) and (tonumber(iY) == 0) and (tonumber(iZ) == 0) then
		setElementFrozen(self, false);
	end
	setElementData(self, "v:AbgeschlepptVon", false)
	local r = self:checkAbstellPosition();

	return r;
end

function CUserVehicle:checkAbstellPosition()
	if not(self.AbstellPos) then
		self.AbstellPos = "0|0|0|0|0|0";
	end
	local positions = split(self.AbstellPos, "|", -1)
	if not((tonumber(positions[1]) == 0) and (tonumber(positions[2]) == 0) and (tonumber(positions[3]) == 0)) then
		local x, y, z, rx, ry, rz = tonumber(positions[1]), tonumber(positions[2]), tonumber(positions[3]), tonumber(positions[4]), tonumber(positions[5]), tonumber(positions[6])
		if(x and y and z and rx and ry and rz) then
			setElementPosition(self, x, y, z);
			setElementRotation(self, rx, ry, rz);

			setVehicleRespawnPosition(self, x, y, z, rx, ry, rz)

			setElementFrozen(self, true);

			self:setData("Abgeschleppt", true)
			return true;
		end
	else
	--	setElementFrozen(self, false);
		x, y, z, rx, ry, rz = tonumber(gettok(self.Koords, 1, "|")), tonumber(gettok(self.Koords, 2, "|")), tonumber(gettok(self.Koords, 3, "|")), tonumber(gettok(self.Koords, 4, "|")), tonumber(gettok(self.Koords, 5, "|")), tonumber(gettok(self.Koords, 6, "|")),
		self:setData("Abgeschleppt", false)
		setVehicleRespawnPosition(self, x, y, z, rx, ry, rz)
	end

	return false;
end

function CUserVehicle:onModelChange(iOldModel, iNewModel)
	self.VID = iNewModel;
	self:save();
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
			index = index-1;
			addVehicleUpgrade(self, wert)
		end
	end

	setVehiclePlateText(self, self.Plate);
	setVehiclePaintjob(self, self.Paintjob);

	for index, b in pairs(self.SpezialTunings) do
		self:setSpezialtuningEnabled(index, b);
	end

end


function CUserVehicle:setSpezialtuningEnabled(sTuning, bBool)
	self.SpezialTunings[sTuning] = bBool;

	if(bBool) then
		self:AddCustomUpgrade(sTuning);
	else
		self:RemoveCustomUpgrade(sTuning);
	end
	setElementData(self, "tuningteil:"..sTuning, bBool);

	self:save();
end

function CUserVehicle:destructor()
	outputServerLog("Fahrzeug mit der ID "..self.ID.." wurde zerstoert!")

	logger:OutputPlayerLog(self.OwnerName, "Auto zerstoert", getVehicleNameFromModel(getElementModel(self)), self.ID);

	UserVehicles[self.ID] = nil
end

function CUserVehicle:getID()
	return self.ID
end

function CUserVehicle:getOwnerID()
	return self.OwnerID
end

function CUserVehicle:addUserKey(uPlayer, sName)
	local result = CDatabase:getInstance():query("SELECT ID, Name FROM user WHERE Name=?", sName)
	if(result) and (result[1]) and (result[1]['ID']) and (tonumber(result[1]['ID'])) then
		local id = tonumber(result[1]['ID'])
		sName		= result[1]['Name']
		if not(self.keys[id]) then
			table.insert(self.keys, id, sName);
			self:save();
			Achievements[31]:playerAchieved(uPlayer)
			uPlayer:showInfoBox("sucess", "Der Spieler hat nun einen Autoschluessel!");
			if(getPlayerFromName(sName)) then
				local play = getPlayerFromName(sName);

				play:showInfoBox("info", "Du hast einen Fahrzeugschluessel von "..uPlayer:getName().." erhalten! Fahrzeug: "..self.VehicleName)
			end
			return true;
		else
			uPlayer:showInfoBox("error", "Der Spieler hat bereits einen Autoschluessel!");
			return false;
		end
	else
		uPlayer:showInfoBox("error", "Der Spieler existiert nicht!");
		return false;
	end
	return false;
end

function CUserVehicle:removeUserKey(uPlayer, sName)
	local result = CDatabase:getInstance():query("SELECT ID, Name FROM user WHERE Name=?", sName)
	if(result) and (result[1]) and (result[1]['ID']) and (tonumber(result[1]['ID'])) then
		local id 	= tonumber(result[1]['ID'])
		sName		= result[1]['Name']

		if(self.keys[id]) then
			local newtbl		= {};

			for id2, pn in pairs(self.keys) do
				id2 = tonumber(id2);
				if not(id2 == id) then
					newtbl[id2] = pn;
				end
			end
			self.keys = newtbl;

			self:save();
			uPlayer:showInfoBox("sucess", "Schluessel entfernt!");
			if(getPlayerFromName(sName)) then
				local play = getPlayerFromName(sName);
				play:showInfoBox("info", "Dein Fahrzeugschluessel von "..uPlayer:getName().." wurden entzogen! Fahrzeug: "..self.VehicleName)
			end
			return true;
		else
			uPlayer:showInfoBox("error", "Der Spieler hat keinen Autoschluessel fuer dieses Auto!");
			return false;
		end
	else
		uPlayer:showInfoBox("error", "Der Spieler existiert nicht!");
	end
	return false;
end

function CUserVehicle:getKeys()
	return self.keys;
end


function CUserVehicle:onVehicleExit(thePlayer, seat, jacked)
	self:save()
	if(isKeyBound(thePlayer, "b", "both", self.switchBrakeFunc)) then
		unbindKey(thePlayer, "b", "down", self.switchBrakeFunc)
	end

	self.HBTimer = setTimer(
			function()
				if(self.HandBrake) then
					self.HandBrake = false;
					self:switchHandbrake(self.HandBrake, false)
				else
					self.HandBrake = true;
					self:switchHandbrake(self.HandBrake, false)
				end
				self:setDamageProof(true);
			end
	, 1000, 1)

	self:shutAllDoors();
end


function CUserVehicle:onVehicleEnter(thePlayer, seat, jacked)
	self:save()
	if( thePlayer:hasKeyForVehicle(self) ) then
		if(seat == 0) then
			if not(isKeyBound(thePlayer, "b", "both", self.switchBrakeFunc)) then
				bindKey(thePlayer, "b", "down", self.switchBrakeFunc)
			end
		end
	end

	if (self.HBTimer) and isTimer(self.HBTimer) then
		killTimer(self.HBTimer)
	end

	if(self.HandBrake) then
		self.HandBrake = false;
		self:switchHandbrake(self.HandBrake, false)
	else
		self.HandBrake = true;
		self:switchHandbrake(self.HandBrake, false)
	end
	self:setDamageProof(false);
end

function CUserVehicle:onVehicleDamage(loss)
	self:setHealth(self:getHealth()-loss/10)
end

function CUserVehicle:onVehicleExplode()
	self.Destroyed = true
	if( (self:isOwnerReachable()) ) then
		Players[self:getOwnerID()]:showInfoBox("warning", "Dein Fahrzeug mit dem Nummernschild: "..self.Plate.." wurde zerstört!")
		CDatabase:getInstance():query("DELETE FROM Vehicles WHERE ID=?", self.ID)
		setTimer(self.tDestroy, 2000, 1)
		Achievements[29]:playerAchieved(Players[self:getOwnerID()])
		Players[self:getOwnerID()]:incrementStatistics("Fahrzeuge", "Fahrzeuge_verloren", 1)
		self:removeFromUserVehiclesByPlayer();
	else
		setTimer(function() respawnVehicle(self) end, 5000, 1 )
	end
end


function CUserVehicle:sell(uPlayer)
	if ( getTableSize(getVehicleOccupants(self)) == 0) then
		local r = CDatabase:getInstance():query("DELETE FROM Vehicles WHERE ID=?", self.ID)
		if(r) then
			local iModell = self.VID
			local preis = global_vehicle_preise[iModell]
			if not(preis) then
				preis = 0;
			end
			self:removeFromUserVehiclesByPlayer();
			self.tDestroy(true)

			preis = math.floor(preis/100*50)

			if(preis > 999999) then
				preis = 0;
			end

			uPlayer:addMoney(preis);

			logger:OutputPlayerLog(uPlayer, "Autoverkauf", getVehicleNameFromModel(iModell), "$"..preis)

			uPlayer:showInfoBox("sucess", "Du hast f\uer deinen "..getVehicleNameFromModel(iModell).." $"..preis.." bekommen!");
		end
	else
		uPlayer:showInfoBox("error", "Dein Fahrzeug ist nicht leer!");
	end
end

function CUserVehicle:sendInventory(uPlayer)
	if not(self.Inventory) then
		self.Inventory = Inventories[self.iInventory]
	end

	self.Inventory:refreshGewicht();
	triggerClientEvent(uPlayer, "onClientInventoryRecieve", uPlayer, toJSON(self.Inventory));
end

function CUserVehicle:switchLocked(thePlayer)
	if not(clientcheck(thePlayer, client)) then return end
	if(thePlayer:hasKeyForVehicle(self)) then
		if (self:isLocked()) then
			self:setLocked(false)
			self.Locked = false
			local x,y,z = self:getPosition()
			triggerClientEvent("onServerPlaySound", self, x, y, z, "res/sounds/car_unlock.mp3")
			-- Timer --
			setVehicleOverrideLights(self, 2);
			setTimer(setVehicleOverrideLights, 200, 1, self, 1);
			setTimer(setVehicleOverrideLights, 300, 1, self, 2);
			setTimer(setVehicleOverrideLights, 500, 1, self, 0);

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

function CUserVehicle:switchHandbrake(uPlayer, bBool)
	if(self) and (isElement(self)) then
		if(getElementData(self, "Abgeschleppt") ~= true) then


			if(self:getTowedByVehicle()) then
				if(self:getTowedByVehicle().save) then
					self:getTowedByVehicle().HandBrake = self.HandBrake;
					self:getTowedByVehicle():switchHandbrake(uPlayer, self.HandBrake)
				end
			end

			self.HandBrake = not (self.HandBrake);


			if(getVehicleOccupant(self)) then
				local uPlayer = getVehicleOccupant(self);
				if(uPlayer:hasKeyForVehicle(self)) then
					triggerClientEvent(uPlayer, "onClientVehicleHandbrakeSwitch", uPlayer, self, self.HandBrake);
				end

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

function CUserVehicle:getInventory()
	return self.Inventory
end


function CUserVehicle:isOwnerReachable()
	if isElement((Players[self.OwnerID])) then
		local x,y,z = getElementPosition(self)
		local x1,y1,z1 = getElementPosition(Players[self.OwnerID])
		if (getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 35) then
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

		if(self:getTowedByVehicle()) then
			if(self:getTowedByVehicle().save) then
				self:getTowedByVehicle():park(thePlayer)
			end
		end
	else
		thePlayer:showInfoBox("error", "Dieses Fahrzeug gehört dir nicht!")
	end
end

function CUserVehicle:save()
	if (not (self.Destroyed)) then
		self.Health=self:getHealth();

		self.miscSettings	=
		{
			["variant1"]	= self.iVariant1,
			["variant2"]	= self.iVariant2,
		}

		CDatabase:getInstance():query("UPDATE vehicles SET `OwnerID`=?, `VID`=?, `Int`=?, `Dim`=?, `Koords`=?, `Color`=?, `Tuning`=?, `Plate`=?, `Fuel`=?, `KM`=?, `Health`=?, `LichtFarbe`=?, `Dirtlevel`=?, `Abstellposition`=?, `Paintjob`=?, `Spezialtunings`=?, `Schluessel`=?, `Inventar`=?, `MiscSettings`=?  WHERE `ID`=?;", tonumber(self.OwnerID), tonumber(self.VID), tonumber(self.Int), self.Dim, self.Koords, self.Color, self.Tuning, self.Plate, self.Fuel, self.KM, self.Health, self.HeadLights, self.Dirtlevel, self.AbstellPos, self.Paintjob, toJSON(self.SpezialTunings), toJSON(self.keys), tonumber(self.iInventory), toJSON(self.miscSettings), self.ID)
		self:setData("takeys", toJSON(self.keys));
	end
end

function CUserVehicle:respawn(thePlayer)
	if (self:getOwnerID() == thePlayer:getID()) or (thePlayer:getAdminLevel() > 0) then
		if ( getTableSize(getVehicleOccupants(self)) == 0) then
			if not(self:isTowed()) then
				local health = getElementHealth(self)
				respawnVehicle(self)
				self.Engine 			= false
				self.Locked 			= true
				self.HandBrake 			= false;
				self:switchHandbrake(self.HandBrake, false)
				self.reifenpumpeDone 	= false;

				setElementHealth(self, health)
				if (health < 400) then
					setElementHealth(self, 400)
				end
				setVehicleEngineState(self, false)
				setVehicleLocked(self, true)
				setVehicleOverrideLights(self, 0);
				self:resetHandling();
				self:tune();

				local r = self:checkAbstellPosition();

				setElementDimension(self, 0);
				setElementInterior(self, 0);

				if(r == true) then
					thePlayer:showInfoBox("info", "Dieses Fahrzeug wurde abgeschleppt!\nEs muss erst freigekauft werden.");
				else
					thePlayer:showInfoBox("info", "Du hast das Fahrzeug erfolgreich respawnt!")
				end
			else
				thePlayer:showInfoBox("error", "Dieses Fahrzeug wird gerade von "..getPlayerName(self:isTowed()).." abgeschleppt!");
			end
		else
			thePlayer:showInfoBox("error", "Dieses Fahrzeug ist nicht leer!")
		end
	else
		thePlayer:showInfoBox("error", "Dieses Fahrzeug gehört dir nicht!")
	end
end



addEvent("onPlayerErsatzreifenUse", true)
addEventHandler("onPlayerErsatzreifenUse", getRootElement(), function(iID)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);

	if(tonumber(iID)) and (UserVehicles[iID]) then
		local uVehicle = UserVehicles[iID];
		if(client:hasKeyForVehicle(uVehicle)) then
			if not(UserVehicles[iID].reifenpumpeDone) then
				setVehicleWheelStates(UserVehicles[iID], 0, 0, 0, 0);
				UserVehicles[iID].reifenpumpeDone = true;
				client:showInfoBox("sucess", "Die Reifen wurden erneuert!")
			else
				client:showInfoBox("error", "Das Fahrzeug hat schon neue Reifen erhalten!")
			end
		else
			client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
		end
	end
end)
addEvent("onPlayerKofferaumInventoryRequest", true)
addEventHandler("onPlayerKofferaumInventoryRequest", getRootElement(), function(iID, iType, sType)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if(sType == "Corporationsfahrzeug") then
		if(tonumber(iID)) and (CorporationVehicles[iID]) then
			local uVehicle = CorporationVehicles[iID];
			local x, y, z = getElementPosition(uVehicle)
			if(client:getCorporation():getID() == uVehicle:getCorporation():getID()) then
				if(client:hasCorpRole(5)) then
					if(iType == 1) then -- Lagern
						triggerClientEvent(client, "onClientInventoryRecieve", client, toJSON(client.Inventory));
						triggerClientEvent(client, "onClientInventoryOpen", client, iType, "corporationvehicle", iID);
					elseif(iType == 2) then -- Storen
						uVehicle:sendInventory(client)
						triggerClientEvent(client, "onClientInventoryOpen", client, iType, "corporationvehicle", iID);
					end
					uVehicle:openTrunk();
					uVehicle:addTrunkUser(client)
					triggerClientEvent("onServerPlaySound", uVehicle, x, y, z, "res/sounds/vehicle/trunk_open.ogg")
				else
					client:showInfoBox("error", "Du hast nicht die Rolle des Storage Managers!")
				end
			else
				client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
			end
		else
			client:showInfoBox("error", "Dieses Fahrzeug existiert nicht!")
		end
	else
		if(tonumber(iID)) and (UserVehicles[iID]) then
			local uVehicle = UserVehicles[iID];
			local x, y, z = getElementPosition(uVehicle)
			if(client:hasKeyForVehicle(uVehicle)) then
				if(iType == 1) then -- Lagern
					triggerClientEvent(client, "onClientInventoryRecieve", client, toJSON(client.Inventory));
					triggerClientEvent(client, "onClientInventoryOpen", client, iType, "uservehicle", iID);
				elseif(iType == 2) then -- Storen
					uVehicle:sendInventory(client)
					triggerClientEvent(client, "onClientInventoryOpen", client, iType, "uservehicle", iID);
				end
				uVehicle:openTrunk();
				uVehicle:addTrunkUser(client)
				triggerClientEvent("onServerPlaySound", uVehicle, x, y, z, "res/sounds/vehicle/trunk_open.ogg")
			else
				client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
			end
		else
			client:showInfoBox("error", "Dieses Fahrzeug existiert nicht!")
		end
	end
end)

addEvent("onPlayerKofferaumDepositItem", true)
addEventHandler("onPlayerKofferaumDepositItem", getRootElement(), function(iVehicleID, iID, am, sType)
	client:setLoading(false);
	iVehicleID	= tonumber(iVehicleID);
	iID         = tonumber(iID)
	am          = tonumber(am)
	local item  = Items[iID]
	if(sType == "corporationvehicle") then
		if(tonumber(iID)) and (CorporationVehicles[iVehicleID]) then
			local uVehicle = CorporationVehicles[iVehicleID];
			local x, y, z = getElementPosition(uVehicle)
			if(client:getCorporation():getID() == uVehicle:getCorporation():getID()) then
				if(client:hasCorpRole(5)) then
					if(client:getInventory():hasItem(item, am)) then
						if(uVehicle:getInventory():canItemBeAdded(item, am, true)) then
							local suc = uVehicle:getInventory():addItem(item, am, false);
							if(suc) then
								client:getInventory():removeItem(item, am);
								client:refreshInventory();
							else
								client:showInfoBox("error", "Der Kofferaum kann dieses Item nicht mehr aufnehmen!")
							end
						else
							client:showInfoBox("error", "Der Kofferaum des Fahrzeuges ist voll!")
						end
					else
						client:showInfoBox("error", "Soviel von dem Item besitzt du nicht!")
					end
				else
					client:showInfoBox("error", "Du benoetigst die Corporation Rolle: Storage Manager!")
				end
			else
				client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
			end
		else
			client:showInfoBox("error", "Dieses Fahrzeug existiert nicht!")
		end
	else
		if(client:hasKeyForVehicle(UserVehicles[iVehicleID])) then
			if(client:getInventory():hasItem(item, am)) then
				if(UserVehicles[iVehicleID]:getInventory():canItemBeAdded(item, am, true)) then
					local suc = UserVehicles[iVehicleID].Inventory:addItem(item, am, false);
					if(suc) then
						client:getInventory():removeItem(item, am);
						client:refreshInventory();
					else
						client:showInfoBox("error", "Der Kofferaum kann dieses Item nicht mehr aufnehmen!")
					end
				else
					client:showInfoBox("error", "Der Kofferaum des Fahrzeuges kann dieses Item nicht mehr aufnehmen!")
				end
			else
				client:showInfoBox("error", "Soviel von dem Item besitzt du nicht!")
			end
		end
	end
end)

addEvent("onPlayerKofferaumWithdrawItem", true)
addEventHandler("onPlayerKofferaumWithdrawItem", getRootElement(), function(iVehicleID, iID, am, sType)
	client:setLoading(false);
	iVehicleID	= tonumber(iVehicleID);
	iID         = tonumber(iID)
	am          = tonumber(am)
	local item  = Items[iID]
	if(sType == "corporationvehicle") then
		if(tonumber(iID)) and (CorporationVehicles[iVehicleID]) then
			local uVehicle = CorporationVehicles[iVehicleID];
			local x, y, z = getElementPosition(uVehicle)
			if(client:getCorporation():getID() == uVehicle:getCorporation():getID()) then
				if(client:hasCorpRole(5)) then
					if(uVehicle:getInventory():hasItem(item, am)) then
						if(client:getInventory():canItemBeAdded(item, am, true)) then
							local suc = client:getInventory():addItem(item, am, false);
							if(suc) then
								uVehicle:getInventory():removeItem(item, am);
								uVehicle:sendInventory(client)
							else
								client:showInfoBox("error", "Du kannst dieses Item nicht mehr aufnehmen!")
							end
						else
							client:showInfoBox("error", "Dein Inventar ist voll!")
						end
					else
						client:showInfoBox("error", "Soviel von dem Item besitzt der Kofferaum nicht!")
					end
				else
					client:showInfoBox("error", "Du benoetigst die Corporation Rolle: Storage Manager!")
				end
			else
				client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
			end
		else
			client:showInfoBox("error", "Dieses Fahrzeug existiert nicht!")
		end
	else
		if(client:hasKeyForVehicle(UserVehicles[iVehicleID])) then
			if(UserVehicles[iVehicleID].Inventory:hasItem(item, am)) then
				if(client:getInventory():canItemBeAdded(item, am, true)) then
					if not(client:getInventory():hasItemFullStackWith(item, am)) then
						UserVehicles[iVehicleID].Inventory:removeItem(item, am);
						client:getInventory():addItem(item, am);
						UserVehicles[iVehicleID]:sendInventory(client)
					else
						client:showInfoBox("error", "Dafuer reicht dein Inventarplatz nicht!")
					end
				else
					client:showInfoBox("error", "Dein Inventar ist zu voll fuer dieses Item!")
				end
			else
				client:showInfoBox("error", "Soviel von dem Item ist nicht mehr vorhanden!")
			end
		end
	end
end)
addEvent("onPlayerKofferaumFinished", true)
addEventHandler("onPlayerKofferaumFinished", getRootElement(), function(iID, sType)
	if(sType == "corporationvehicle") then
		local vehicle	= CorporationVehicles[iID];
		if(vehicle) and (vehicle.trunkOpened) then
			vehicle:removeTrunkUser(client)
			if(vehicle:getTrunkUsers() < 1) then -- Close the Trunk
				vehicle:closeTrunk();
				local x, y, z = getElementPosition(vehicle)
				setTimer(triggerClientEvent, 900, 1, "onServerPlaySound", vehicle, x, y, z, "res/sounds/vehicle/trunk_close.ogg")
			end
		end
	else
		if(UserVehicles[iID].trunkOpened) then
			UserVehicles[iID]:removeTrunkUser(client)
			if(UserVehicles[iID]:getTrunkUsers() < 1) then -- Close the Trunk
				UserVehicles[iID]:closeTrunk();
				local x, y, z = getElementPosition(UserVehicles[iID])
				setTimer(triggerClientEvent, 900, 1, "onServerPlaySound", UserVehicles[iID], x, y, z, "res/sounds/vehicle/trunk_close.ogg")
			end
		end
	end
end)
--[[
addEvent("onUserVehicleOpenKofferaum", true)
addEventHandler("onUserVehicleOpenKofferaum", getRootElement(), function(iID)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);

	if(tonumber(iID)) and (UserVehicles[iID]) then
		local uVehicle = UserVehicles[iID];

		if(client:hasKeyForVehicle(uVehicle)) then

		else
			client:showInfoBox("error", "Du hast kein Schluesel fuer dieses Fahrzeug!")
		end
	else
		client:showInfoBox("error", "Dieses Fahrzeug existiert nicht!")
	end
end)
]]
addEvent("onPlayerUserVehicleRespawn", true)
addEventHandler("onPlayerUserVehicleRespawn", getRootElement(),
function(ID)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if (UserVehicles[ID]) then
		UserVehicles[ID]:respawn(client)
	else
		client:showInfoBox("error", "Dein Fahrzeug ist nicht mehr vorhanden!\nEvenutell wurde es zerstoert, oder verbuggt.");
	end
end
)

addEvent("onPlayerUserVehicleSell", true)
addEventHandler("onPlayerUserVehicleSell", getRootElement(),
function(ID)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if (UserVehicles[ID]) then
		UserVehicles[ID]:sell(client);
	else
		client:showInfoBox("error", "Dein Fahrzeug ist nicht mehr vorhanden!\nEvenutell wurde es zerstoert, oder verbuggt.");
	end
end
)

addEvent("onPlayerRequestUserVehicles", true)
addEventHandler("onPlayerRequestUserVehicles", getRootElement(),
function(thePlayer)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if (not(type(UserVehiclesByPlayer[client:getID()]) == "table")) then
		if(UserVehiclesByPlayer[client:getID()]) then
			UserVehiclesByPlayer[client:getID()] = {}
		else
			client:showInfoBox("error", "Fehler bei der Verarbeitung!\nVersuche es erneut.");
		end
	end
	triggerClientEvent(client, "onClientReceivUserVehicles", client, UserVehiclesByPlayer[client:getID()], global_vehicle_preise, thePlayer)
end
)

addEvent("onUserVehicleRespawnRequest", true)
addEventHandler("onUserVehicleRespawnRequest", getRootElement(),
function(ID)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);

	if(UserVehicles[tonumber(ID)]) then
		UserVehicles[tonumber(ID)]:respawn(client)
	else
		client:showInfoBox("error", "Dein Fahrzeug ist nicht mehr vorhanden!\nEvenutell wurde es zerstoert, oder verbuggt.");
	end
end)

addEvent("onUserVehicleAdminChangeModel", true)
addEventHandler("onUserVehicleAdminChangeModel", getRootElement(), function(iID, iModell)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if(client:getAdminLevel() >= 3) then
		if(iID) then
			if(UserVehicles[iID]) then

				local uVehicle 			= UserVehicles[iID]
				local tune 				= false;
				local iRichtigesModell 	= iModell;

				if(string.find(tostring(iModell), "1337")) then
					tune 				= true;
					iRichtigesModell 	= tonumber((string.gsub(tostring(iModell), "1337", "")));
				end

				if(iRichtigesModell) then
					uVehicle.VID = iRichtigesModell;
					setElementModel(uVehicle, iRichtigesModell);

				end

				if(tune) then
					uVehicle:setSpezialtuningEnabled("Kofferaum", true);
					uVehicle:setSpezialtuningEnabled("Panzerung", true);
					uVehicle:setSpezialtuningEnabled("Sportmotor", true);
					uVehicle:setSpezialtuningEnabled("GPS", true);
					uVehicle:setSpezialtuningEnabled("Ersatzreifen", true);
					uVehicle:setSpezialtuningEnabled("Bessere Hydraulik", true);
					uVehicle:setSpezialtuningEnabled("Grosser Tank", true);
				end


				client:showInfoBox("sucess", "Fahrzeug wurde ver\aendert!")
				if(getPlayerFromName(uVehicle.OwnerName)) then
					getPlayerFromName(uVehicle.OwnerName):showInfoBox("sucess", "Dein Fahrzeug '"..getVehicleNameFromModel(getElementModel(uVehicle)).." wurde von Admin "..getPlayerName(client).." ver\aender!");
				end
				uVehicle:save();
			end
		end
	end
end)

addEvent("onUserVehicleAdminDelete", true)
addEventHandler("onUserVehicleAdminDelete", getRootElement(), function(iID, sMSG)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	if(client:getAdminLevel() > 0) then
		if(iID) then
			if(UserVehicles[iID]) then

				local uPlayer					= client;
				local uVehicle					= UserVehicles[iID];

				local r = CDatabase:getInstance():query("DELETE FROM Vehicles WHERE ID=?", uVehicle.ID)

				if(r) then
					uPlayer:showInfoBox("sucess", "Auto erfolgreich geloescht!");
					offlineMSGManager:AddOfflineMSG(uVehicle.OwnerName, "Dein Fahrzeug "..getVehicleNameFromModel(getElementModel(uVehicle)).." wurde von Admin "..getPlayerName(uPlayer).." geloescht!("..sMSG..")")

					uVehicle:removeFromUserVehiclesByPlayer();
					uVehicle.tDestroy(true);
					logger:OutputPlayerLog(client, "Löschte Fahrzeug!", tostring(iID));
				else
					uPlayer:showInfoBox("error", "MySQL Fehler!")
				end
			end
		end
	end
end)

addEvent("onPlayerUserVehicleMakeSellRequest", true)
addEventHandler("onPlayerUserVehicleMakeSellRequest", getRootElement(), function(uPlayer, iID, iPreis)
	if (not(clientcheck(source, client))) then return false end
	client:setLoading(false);
	iID = tonumber(iID)
	if(iID) then
		if(UserVehicles[iID]) then
			if not(UserVehicles[iID]:getSellerTo()) then
				if not(player_sell_anfragen[uPlayer]) then
					if(iPreis >= 0) and (iPreis < 999999999) then
						player_sell_anfragen[uPlayer] 	= {client, iID, iPreis};
						local uVehicle					= UserVehicles[iID];

						client:showInfoBox("sucess", "Du hast "..getPlayerName(uPlayer).." deinen Wagen f\uer $"..iPreis.." angeboten!")
						uPlayer:showInfoBox("info", "Du hast ein Fahrzeugangebot von "..getPlayerName(client).." erhalten!")

						outputChatBox(getPlayerName(client).." bietet dir sein(en) "..getVehicleNameFromModel(getElementModel(uVehicle)).." f\uer $"..iPreis.." an.", uPlayer, 0, 200, 0)
						outputChatBox("Tippe /accept um dieses Angebot anzunehmen. (Andererseits /reject)", uPlayer, 0, 200, 0)

						uVehicle:setData("vehiclerequest", true)
					else
						client:showInfoBox("error", "Ung\ueltiger Preis!");
					end
				else
					client:showInfoBox("error", "Der Spieler hat bereits eine Anfrage erhalten!");
				end
			else
				local uSellTo, uPlayer2 = UserVehicles[iID]:getSellerTo();
				if(client == uPlayer2) then
					player_sell_anfragen[uSellTo] = false;
					client:showInfoBox("sucess", "Fahrzeugangebot wurde zur\ueckgezogen.");
					UserVehicles[iID]:setData("vehiclerequest", false)
				end
			end
		else
			client:showInfoBox("error", "Fahrzeug existiert nicht!");
		end
	else
		client:showInfoBox("error", "Fahrzeug existiert nicht!");
	end
end)

function table.getIndexAt(tblTable, sWert)
	for index, dat in pairs(tblTable) do
		if(dat == sWert) then
			return index;
		end
	end
	return false;
end


function CUserVehicle:getSellerTo()
	for index, tbl in pairs(player_sell_anfragen) do
		if(tbl) and (index) then
			if(tbl[2] == self.ID) then
				return tbl[1], index;
			end
		end
	end
end


-- Nimmt das Auto aus den Usertable raus
function CUserVehicle:removeFromUserVehiclesByPlayer()
	if not(self.tableTable) then
		self.tableTable = {}
	end
	if(UserVehiclesByPlayer[self.OwnerID]) then
		table.remove(UserVehiclesByPlayer[self.OwnerID], table.getIndexAt(UserVehiclesByPlayer[self.OwnerID], self.tableTable) or 0)
	end
end

-- Packt es in den Usertable rein
function CUserVehicle:insertIntoUserVehiclesByPlayer()
	self.tableTable = {["ID"]=self.ID,["VID"]=self.VID,["Plate"]=self.Plate, ["Vehicle"]=self};
	if not(UserVehiclesByPlayer[self.OwnerID]) then
		UserVehiclesByPlayer[self.OwnerID] = {}
	end
	table.insert(UserVehiclesByPlayer[self.OwnerID], self.tableTable)
end

-- Accept

addCommandHandler("accept", function(uPlayer)
	if(player_sell_anfragen[uPlayer]) then
		if(uPlayer.LoggedIn) then
			local uSeller, iID, iPreis = player_sell_anfragen[uPlayer][1], player_sell_anfragen[uPlayer][2], player_sell_anfragen[uPlayer][3];

			if(isElement(uSeller)) then
				if(tonumber(uPlayer:getMoney()) >= iPreis) then
					local uVehicle = UserVehicles[iID];
					if(uVehicle) then
						-- Buy --
						player_sell_anfragen[uPlayer] = false;

						uVehicle:removeFromUserVehiclesByPlayer()

						uVehicle.OwnerID 	= uPlayer:getID()
						uVehicle.Owner 		= Players[uVehicle.OwnerID]
						uVehicle.OwnerName 	= PlayerNames[uVehicle.OwnerID]

						uVehicle:setData("OwnerName", uVehicle.OwnerName)

						uVehicle:save()

						uPlayer:addMoney(-iPreis)
						uSeller:addMoney(iPreis)

						uPlayer:showInfoBox("sucess", "Du hast das Fahrzeug gekauft!\n-$"..iPreis);
						uSeller:showInfoBox("sucess", getPlayerName(uPlayer).." hat dir dein(en) "..getVehicleNameFromModel(getElementModel(uVehicle)).." abgekauft!\n+$"..iPreis);

						logger:OutputPlayerLog(uSeller, "Autoweiterverkauf", "An "..getPlayerName(uPlayer)..", "..getVehicleNameFromModel(getElementModel(uVehicle)), "$"..iPreis)

						outputServerLog(getPlayerName(uPlayer).." hat Auto von "..getPlayerName(uSeller).." gekauft. ($"..iPreis..")")
						UserVehicles[iID]:setData("vehiclerequest", false)
						uVehicle:insertIntoUserVehiclesByPlayer()
					else
						uPlayer:showInfoBox("error", "Fahrzeug existiert nicht!")
					end
				else
					uPlayer:showInfoBox("error", "Soviel Geld hast du nicht auf der Hand!")
				end
			else
				player_sell_anfragen[uPlayer] = false;
				uPlayer:showInfoBox("error", "Der Spieler ist nicht mehr Online - Angebot zur\ueckgezogen.")
				UserVehicles[iID]:setData("vehiclerequest", false)
			end
		end
	end
end)

addCommandHandler("reject", function(uPlayer)
	if(player_sell_anfragen[uPlayer]) then
		local uSeller, iID, iPreis = player_sell_anfragen[uPlayer][1], player_sell_anfragen[uPlayer][2], player_sell_anfragen[uPlayer][3];

		UserVehicles[iID]:setData("vehiclerequest", false)
		player_sell_anfragen[uPlayer] = false;
		uPlayer:showInfoBox("info", "Du hast das Angebot zurueckgezogen!")
		if(isElement(uSeller)) then
			uSeller:showInfoBox("error", getPlayerName(uPlayer).." hat deine Kaufanfrage abgelehnt.");
		end
	end
end)
