--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CLSPD = {}


function CLSPD:constructor()

	addEvent("onPlayerGrabRequest", true)

	addEventHandler("onPlayerGrabRequest", getRootElement(), function(sPlayername)
		local 			uPlayer = client;
		local 			uPlayer2;
		if(getPlayerFromName(sPlayername)) then
			uPlayer2 = getPlayerFromName(sPlayername)
			if(isPedInVehicle(uPlayer)) then
				local veh = uPlayer:getOccupiedVehicle();
				if(uPlayer:getFaction():getType() == 1) then
					if(uPlayer2.Crack) and (uPlayer2.CrackCounter > 1) then
						local x, y, z = uPlayer:getPosition()
						local x2, y2, z2 = uPlayer2:getPosition()
						if(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 10) then
							local seat = getVehicleFreeSeat(veh)
							if(seat) then
								warpPedIntoVehicle(uPlayer2, veh, seat)
								uPlayer:showInfoBox("sucess", "Der Spieler wurde in dein Auto gezogen!")
								uPlayer2:showInfoBox("info", "Du wurdest in ein Auto gezogen!")
								uPlayer2.CrackCounter = 0;
							else
								uPlayer:showInfoBox("error", "In deinem Fahrzeug ist kein Platz mehr!")
							end
						else
							uPlayer:showInfoBox("error", "Der Spieler ist zu weit weg!")
						end
					else
						uPlayer:showInfoBox("error", "Der Spieler ist nicht getazert!")
					end
				end
			end
		end
	end)


	self.DachMarkerIn	= createMarker(1564.9041748047, -1666.6864013672, 28.395606994629, "corona", 1, 255, 255, 255, 255);
	-- Davor: 1564.8591308594, -1664.8547363281, 28.395606994629

	addEventHandler("onMarkerHit", self.DachMarkerIn,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						if (hitElement:getFaction():getType() == 1) then
							hitElement:fadeInPosition(1556.2912597656, -2935.939453125, 219.09289550781, 20141, 10)
							hitElement:setRotation(0,0,0)
						else
							hitElement:showInfoBox("error", "Es ist abgeschlossen!")
						end
					end
				end
			end
		end
	)


	self.DachMarkerOut = createMarker(1556.0463867188, -2933.8024902344, 219.09289550781, "corona", 1, 255, 255, 255, 255);
	setElementInterior(self.DachMarkerOut, 10)
	setElementDimension(self.DachMarkerOut, 20141)
	-- Davor: 1556.2912597656, -2935.939453125, 219.09289550781
	addEventHandler("onMarkerHit", self.DachMarkerOut,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						if (hitElement:getFaction():getType() == 1) then
							hitElement:fadeInPosition(1564.8591308594, -1664.8547363281, 28.395606994629, 0, 0)
						else
							hitElement:showInfoBox("error", "Es ist abgeschlossen!")
						end
					end
				end
			end
		end
	)

	self.GaragenMarkerIn = createMarker(1552.1259765625, -2954.587890625, 219.09289550781, "corona", 1, 255, 255, 255, 255, getRootElement())
	setElementInterior(self.GaragenMarkerIn, 10, 1552.1259765625, -2954.587890625, 219.09289550781)
	setElementDimension(self.GaragenMarkerIn, 20141)

	addEventHandler("onMarkerHit", self.GaragenMarkerIn,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						if (hitElement:getFaction():getType() == 1) then
							hitElement:fadeInPosition(1568.6787109375, -1691.57421875, 5.890625, 0, 0)
							hitElement:setRotation(0,0,0)
						else
							hitElement:showInfoBox("error", "Es ist abgeschlossen!")
						end
					end
				end
			end
		end
	)

	self.GaragenMarkerOut = createMarker(1568.630859375,-1689.9716796875,6.21875, "corona", 1, 255, 255, 255, 255,getRootElement())
	addEventHandler("onMarkerHit", self.GaragenMarkerOut,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						hitElement:fadeInPosition(1553.8515625, -2954.8369140625, 219.09289550781, 20141, 10)
						hitElement:setRotation(0,0,180)
					end
				end
			end
		end
	)

	self.PrisonMarkerIn = createMarker(3776.0673828125, -1599.67578125, 120.96875, "corona", 1, 255, 255, 255, 255,getRootElement())
	setElementInterior(self.PrisonMarkerIn, 1, 3776.0673828125, -1599.67578125, 120.96875)
	setElementDimension(self.PrisonMarkerIn, 0)

	addEventHandler("onMarkerHit", self.PrisonMarkerIn,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						if (hitElement:getJailtime() <= 0) then
							hitElement:fadeInPosition(1557.9619140625, -2933.9638671875, 219.09289550781, 20141, 10)
							hitElement:setRotation(0,0,90)
						else
							hitElement:showInfoBox("warning", "Du musst deine Strafe absitzen!")
						end
					end
				end
			end
		end
	)

	self.PrisonMarkerOut = createMarker(1559.966796875, -2934.1015625, 218.40992736816, "corona", 1, 255, 255, 255, 255, getRootElement())
	setElementInterior(self.PrisonMarkerOut, 10, 1559.966796875, -2934.1015625, 218.40992736816)
	setElementDimension(self.PrisonMarkerOut, 20141)

	addEventHandler("onMarkerHit", self.PrisonMarkerOut,
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player") then
					if (not(isPedInVehicle(hitElement))) then
						hitElement:fadeInPosition(3771.5751953125,-1599.5302734375,120.96875, 0, 1)
						hitElement:setRotation(0,0,90)
					end
				end
			end
		end
	)

	self.trainingMarkerOut		= createMarker(1540.5018310547, -1670.7862548828, 1912.5562744141, "corona", 1, 0, 255, 0, 255);
	setElementInterior(self.trainingMarkerOut, 2);
	setElementDimension(self.trainingMarkerOut, 1337);

	-- Davor: 1540.4644775391, -1668.9951171875, 1912.5562744141


	self.trainingMarkerIn		= createMarker(1524.4831542969, -1677.8615722656, 6.21875, "corona", 1, 0, 255, 0, 255);

	-- Davor: 1526.3999023438, -1677.8438720703, 5.890625


	addEventHandler("onMarkerHit", self.trainingMarkerIn, function(uElement, dim)
		if(dim) then
			uElement:fadeInPosition(1540.4644775391, -1668.9951171875, 1912.5562744141, 1337, 2);
		end
	end)

	addEventHandler("onMarkerHit", self.trainingMarkerOut, function(uElement, dim)
		if(dim) then
			uElement:fadeInPosition(1526.3999023438, -1677.8438720703, 5.890625, 0, 0);
		end
	end)

	self.DutyPickup = createPickup(1564.1484375, -2941.783203125, 219.09289550781, 3, 1275, 100)
	setElementInterior(self.DutyPickup, 10)
	setElementDimension(self.DutyPickup, 20141)

	addEventHandler("onPickupHit", self.DutyPickup,
		function(thePlayer)
			if (thePlayer:getFaction():getID() == 1) then
				if (thePlayer:isDuty()) then
					thePlayer:setDuty(false)
					thePlayer:setSkin(thePlayer:getSkin())
					thePlayer:showInfoBox("info", "Du hast deinen Dienst beendet!")
					thePlayer:resetWeapons()
				else
					thePlayer:setDuty(true)
					thePlayer:setSkin(Factions[1]:getRankSkin(thePlayer:getRank()), true)
					thePlayer:showInfoBox("info", "Du bist nun in Dienst!")
					thePlayer:getInventory():addItem(Items[273], 1);
				end
			else
				thePlayer:showInfoBox("error", "Du bist kein Beamter beim LSPD!")
			end
		end
	)

	self.m_uAsservatenPickup	= createMarker(1528.4302978516, -2950.0439453125, 220.49133300781, "corona", 1.0, 0, 255, 0, 200);
	self.m_uAsservatenPickup:setInterior(10)
	self.m_uAsservatenPickup:setDimension(20141);

	addEventHandler("onMarkerHit", self.m_uAsservatenPickup, function(hitElement, dim)
		if(dim) and(hitElement) and (getElementType(hitElement) == "player") then
			if(hitElement:getFaction():getType() == 1) then	-- Gute Fraktion
				cAsservatenkammer:getInstance():sendPlayerInfo(hitElement)
			end
		end
	end)

	addEventHandler("onMarkerLeave", self.m_uAsservatenPickup, function(hitElement, dim)
		if(dim) and(hitElement) and (getElementType(hitElement) == "player") then
			if(hitElement:getFaction():getType() == 1) then	-- Gute Fraktion
				cAsservatenkammer:getInstance():unsendPlayerInfo(hitElement)
			end
		end
	end)

	self.WeaponPickup = createPickup(1542.3359375, -2950.251953125, 220.49133300781, 3, 1242, 100)
	setElementInterior(self.WeaponPickup, 10)
	setElementDimension(self.WeaponPickup, 20141)

	addEventHandler("onPickupHit", self.WeaponPickup,
		function(thePlayer)
			if (thePlayer:getFaction():getID() == 1) then
				if (thePlayer:isDuty()) then
					thePlayer:resetWeapons()
					setElementHealth(thePlayer, 100);
					if (thePlayer:getRank() == 1) then
						thePlayer:addWeapon(22, 150, false) 	-- 9mm
						setPedStat(thePlayer,69,500)		 	-- 9mm Skill auf 500 da sonst Dual-9mm
					end
					if (thePlayer:getRank() == 2) then
						thePlayer:addWeapon(23, 30, false) 	-- Tazer
						thePlayer:addWeapon(25, 150, false) -- Shotgun
						thePlayer:addWeapon(29, 540, false) -- MP5
					end
					if (thePlayer:getRank() == 3) then
						thePlayer:addWeapon(23, 30, false) -- Tazer
						thePlayer:addWeapon(31, 540, false) -- M4
						thePlayer:addWeapon(25, 150, false) -- Shotgun
						thePlayer:addWeapon(29, 540, false) -- MP5
						thePlayer:addWeapon(17, 1, false) -- Tear Gas
					end
					if (thePlayer:getRank() == 4) then
						thePlayer:addWeapon(23, 30, false) -- Tazer
						thePlayer:addWeapon(31, 540, false) -- M4
						thePlayer:addWeapon(25, 150, false) -- Shotgun
						thePlayer:addWeapon(17, 3, false) -- Tear Gas
						thePlayer:addWeapon(29, 540, false) -- MP5
						thePlayer:addWeapon(34, 10, false) -- Sniper
					end
					if (thePlayer:getRank() > 4) then
						thePlayer:addWeapon(23, 30, false) -- Tazer
						thePlayer:addWeapon(31, 540, false) -- M4
						thePlayer:addWeapon(17, 3, false) -- Tear Gas
						thePlayer:addWeapon(25, 150, false) -- Shotgun
						thePlayer:addWeapon(34, 10, false) -- Sniper
						thePlayer:addWeapon(29, 540, false) -- MP5
					end

					thePlayer:addWeapon(3, 1, false)
					thePlayer:showInfoBox("info", "Du bist nun ausgerüstet!")
					setPedArmor(thePlayer, 100)
				else
					thePlayer:showInfoBox("error", "Du bist nicht im Dienst!")
				end
			else
				thePlayer:showInfoBox("error", "Du bist kein Beamter beim LSPD!")
			end
		end
	)

	self.Jailmarker1 = createColSphere(1568.7600097656, -1694.1672363281, 5.890625, 5)
	self.Jailmarker2 = createColSphere(1564.474609375, -1694.451171875, 4.890625, 5)

	local function einknasten(hitElement, matching)
		jailFunction(hitElement, matching, 1)
	end

	addEventHandler("onColShapeHit", self.Jailmarker1, einknasten)
	addEventHandler("onColShapeHit", self.Jailmarker2, einknasten)

	--[[
	self.GarageGate1 = createObject(988, 1589.69995, -1637.76001, 13.1, 0, 0, 181.5)
	self.GarageGate2 = createObject(988, 1584.19995, -1637.81006, 13.1, 0, 0, 179.747)
	self.GarageShapeSphere = createColSphere(1589.19995, -1637.81006, 13.1, 10)

	addEventHandler("onColShapeHit", self.GarageShapeSphere,
		function(hitElement, matching)
			if ((getElementType(hitElement) == "player") and (matching)) then
				if (hitElement:getFaction():getType() == 1) then
					local x,y,z = getElementPosition(self.GarageGate1)
					local x2,y2,z2 = getElementPosition(self.GarageGate2)
					if (math.floor(z) == (13)) then
						moveObject(self.GarageGate1, 4000, x,y,z-5)
						moveObject(self.GarageGate2, 4000, x2,y2,z-5)
					end
				end
			end
		end
	)

	addEventHandler("onColShapeLeave", self.GarageShapeSphere,
		function(hitElement, matching)
			if ((getElementType(hitElement) == "player") and (matching)) then
				if (hitElement:getFaction():getType() == 1) then
					local x,y,z = getElementPosition(self.GarageGate1)
					local x2,y2,z2 = getElementPosition(self.GarageGate2)
					if (math.floor(z) == (13)-5) then
						for k,v in ipairs(getElementsWithinColShape (source, "player")) do
							if (v:getFaction():getType() == 1) then
								if (v ~= hitElement) then
									return false
								end
							end
						end
						moveObject(self.GarageGate1, 4000, x,y,13)
						moveObject(self.GarageGate2, 4000, x2,y2,13)
					end
				end
			end
		end
	)

	setTimer(
		function()
			local x,y,z = getElementPosition(self.GarageGate1)
			local x2,y2,z2 = getElementPosition(self.GarageGate2)
			if (math.floor(z) == (13)-5) then
				for k,v in ipairs(getElementsWithinColShape (self.GarageShapeSphere, "player")) do
					if (v:getFaction():getType() == 1) then
						return false
					end
				end
				moveObject(self.GarageGate1, 4000, x,y,13)
				moveObject(self.GarageGate2, 4000, x2,y2,13)
			end
		end, 20000, 0
	)
	]]



	self.Jailped = createPed(281,1561.38916, -2954.85669, 219.10001, 90, false)
	setElementInterior(self.Jailped, 10)
	setElementDimension(self.Jailped, 20141)

	addEventHandler("onElementClicked", self.Jailped,
		function(btn, state, thePlayer)
		 if  ((btn == "left") and (state == "down")) then
			outputChatBox("Officer: Klicke mich mit Rechtsklick an um dich zu stellen! (8 Minuten für jedes Wanted)", thePlayer, 255,255,255)
		 end
		  if  ((btn == "right") and (state == "down")) then
			if thePlayer:getWanteds() > 0 then
				toggleAllControls (thePlayer, false)
				thePlayer:showInfoBox("info","Du wirst in 10 Sekunden eingesperrt!")
				setTimer(
					function()
						if thePlayer:getWanteds() > 0 then
							Factions[1]:addDepotMoney(thePlayer:getWanteds()*100)
							toggleAllControls (thePlayer, true)
							for k2,v2 in ipairs( getElementsByType("player")) do
								if (getElementData(v2, "online")) and (v2:getFaction():getType() == 1) then
									if (thePlayer:getFaction():getType() == 2) then
										outputChatBox("Der Spieler "..thePlayer:getName().." hat sich gestellt und wurde für "..tostring(thePlayer:getWanteds()*4).." Minuten eingesperrt!", v2, 0, 255, 0)
									else
										outputChatBox("Der Spieler "..thePlayer:getName().." hat sich gestellt und wurde für "..tostring(thePlayer:getWanteds()*8).." Minuten eingesperrt!", v2, 0, 255, 0)
									end
								end
							end
							thePlayer:jail(thePlayer:getWanteds()*8, true, 1)
						end
					end, 10000, 1
				)
			else
				outputChatBox("Officer: Sie werden nicht gesucht!", thePlayer, 255,255,255)
			end
		 end
		end
	)

	setElementData(self.Jailped, "EastereggPed", true)
	setElementFrozen(self.Jailped, true)

	setWeaponProperty(23, "poor", "damage", 10)
	setWeaponProperty(23, "poor", "maximum_clip_ammo", 1)

	setWeaponProperty(23, "pro", "damage", 10)
	setWeaponProperty(23, "pro", "maximum_clip_ammo", 1)

	addCommandHandler("m",
		function(thePlayer, cmd, ...)
			if not (getElementData(thePlayer, "online")) then return false end
			if (thePlayer:getFaction():getType() == 1) then
				if (getPedOccupiedVehicle(thePlayer) and getElementData(getPedOccupiedVehicle(thePlayer), "Fraktion") and Factions[getElementData(getPedOccupiedVehicle(thePlayer), "Fraktion")]:getType() == 1 and thePlayer:isDuty()) then
					local x,y,z = thePlayer:getPosition()
					local sphere = createColSphere(x, y,z, 70)

					local parametersTable = {...}
					local stringWithAllParameters = table.concat( parametersTable, " " )

					for k,v in ipairs(getElementsWithinColShape(sphere, "player")) do
						if ((getElementDimension(v) == getElementDimension(thePlayer)) and (getElementInterior(v) == getElementInterior(thePlayer))) then
							outputChatBox("[Officer]"..getPlayerName(thePlayer)..": "..stringWithAllParameters, v, 255, 255, 20)
						end
					end
					destroyElement(sphere)
				end
			end
		end
	)

	setModelHandling(596, "maxVelocity", getOriginalHandling(596)["maxVelocity"]*1.15)
	setModelHandling(599, "maxVelocity", getOriginalHandling(599)["maxVelocity"]*1.15)
	setModelHandling(523, "maxVelocity", getOriginalHandling(523)["maxVelocity"]*1.15)


end

function CLSPD:destructor()

end

LSPD = new(CLSPD)
