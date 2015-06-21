--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CPilotJob = {}

addEvent("onPilotJobStart", true)

function CPilotJob:constructor()
	--Targets  to finish the Job
	self.Targets = {
		[1] = "1477.38671875|1811.0595703125|10.8125", --Las Venturas
		[2] = "411.837890625|2501.400390625|16.484375", --Nevada
		[3] = "-1297.38671875|-10.0693359375|14.1484375", -- San Fierro
		[4] = "300.64654541016|1956.6248779297|17.640625" -- Area 69
	}

	self.Targetnames = {
		[1] = "Las Venturas Airport", --Las Venturas
		[2] = "Nevada", --Nevada
		[3] = "San Fierro Airport", -- San Fierro
		[4] = "Area 69", -- San Fierro
	}

	--Current Playersessions
	self.Current = {}

	--Vehicle Spawn
	self.Spawn = "0|0|1423.3505859375|-2494.5166015625|14.751194953918|0.2142333984375|0|270.29663085938"

	--Job Marker
	self.Marker = createMarker(1642.2109375,-2334.8544921875,13.546875, "corona", 2, 125,0,0,255, getRootElement())

	-- Job Marker Hit Event
	addEventHandler("onMarkerHit", self.Marker, function(hitElement, matchingDimensions)
		if (hitElement:getType() == "player") then
			if ( not (isPedInVehicle(hitElement)) ) then
				triggerClientEvent(hitElement, "onClientPilotjobMarkerHit", hitElement)
			end
		end
	end
	)

	-- Koords for CJob
	self.Koords = "1642.2109375|-2334.8544921875|13.546875"

	-- Endposition
	self.EndPos = "1641.90625|-2330.7958984375|13.546875"

	--Eventhandler
	self.eOnPilotJobStart = bind(self.onStart, self)
	addEventHandler("onPilotJobStart", getRootElement(), self.eOnPilotJobStart)

	self.eOnPilotJobFinish = bind(self.onFinish, self)

	-- Call the CJob Constructor
	new(CJob, 2, "Pilot", self.Koords)
end

function CPilotJob:destructor()

end

function CPilotJob:onStart()
	if not(clientcheck(source, client)) then return false end
	if (not (isElementWithinMarker(client, self.Marker))) then
		client:showInfoBox("error", "Du bist am falschen Ort!")
		return false
	end
	local thePlayer = source
	Achievements[5]:playerAchieved(thePlayer)
	local theTarget = math.random(1,#self.Targets)

	thePlayer:showInfoBox("info", "Ziel:\n\n"..self.Targetnames[theTarget])

	local dim = getEmptyDimension()

	self.Current[thePlayer:getName()] = {
		["Target"] = self.Targets[theTarget],
		["Vehicle"] = createVehicle(592, gettok(self.Spawn, 3, "|"), gettok(self.Spawn, 4, "|"), gettok(self.Spawn, 5, "|"), gettok(self.Spawn, 6, "|"), gettok(self.Spawn, 7, "|"), gettok(self.Spawn, 8, "|"), "Plate", false, 0, 0),
		["Marker"] =  createMarker(gettok(self.Targets[theTarget],1,"|"), gettok(self.Targets[theTarget],2,"|"), gettok(self.Targets[theTarget],3,"|"), "corona", 20, 0,255,0,255, thePlayer),
		["Blip"] = createBlip(gettok(self.Targets[theTarget],1,"|"), gettok(self.Targets[theTarget],2,"|"), gettok(self.Targets[theTarget],3,"|"), 41, 3, 255, 0, 0, 255, 0, 1337, thePlayer)
	}

	triggerClientEvent(getRootElement(), "ghostElement", self.Current[thePlayer:getName()]["Vehicle"])

	setElementDimension(thePlayer, dim)
	setElementDimension(self.Current[thePlayer:getName()]["Vehicle"], dim)
	setElementDimension(self.Current[thePlayer:getName()]["Marker"], dim)

	setElementDimension(self.Current[thePlayer:getName()]["Blip"], dim)

	triggerClientEvent(source, "onHudBlipRefresh", source)

	warpPedIntoVehicle(thePlayer, self.Current[thePlayer:getName()]["Vehicle"])
	setVehicleEngineState(self.Current[thePlayer:getName()]["Vehicle"], true)

	addEventHandler("onMarkerHit", self.Current[thePlayer:getName()]["Marker"],
		function(theElement, matchingDimension)
			if (matchingDimension) then
				if (theElement == self.Current[thePlayer:getName()]["Vehicle"]) then
					self:onFinish(getVehicleOccupant(theElement,0), true)
				end
			end
		end
	)

	addEventHandler("onVehicleStartExit", self.Current[thePlayer:getName()]["Vehicle"],
		function(theExiter, seat, jacked, door)
			self:onFinish(theExiter, false)
		end
	)

	addEventHandler("onVehicleDamage", self.Current[thePlayer:getName()]["Vehicle"],
		function(loss)
			local thePlayer = getVehicleOccupant(source, 0)
			self:onFinish(thePlayer, false)
		end
	)

	addEventHandler("onVehicleExplode", self.Current[thePlayer:getName()]["Vehicle"],
		function()
			local thePlayer = getVehicleOccupant(source, 0)
			self:onFinish(thePlayer, false)
		end
	)

end

function CPilotJob:onFinish(thePlayer, sucess)
	if (sucess) then
		--local money = math.round(getDistanceBetweenPoints3D(gettok(self.Koords, 1, "|"), gettok(self.Koords, 2, "|"), gettok(self.Koords, 3, "|"), gettok(self.Current[thePlayer:getName()]["Target"],1,"|"), gettok(self.Current[thePlayer:getName()]["Target"],2,"|"), gettok(self.Current[thePlayer:getName()]["Target"],3,"|"))/20)
		local money = math.round(math.random(350,550)*getEventMultiplicator())
		thePlayer:showInfoBox("info", "Du hast für den Job "..tostring(money).."$ erhalten!")
		thePlayer:setMoney(thePlayer:getMoney()+money)
		thePlayer:incrementStatistics("Job", "Geld_erarbeitet", money)
		thePlayer:incrementStatistics("Job", "Ware_abgeliefert", 1)
		thePlayer:checkJobAchievements()
	else
		thePlayer:showInfoBox("info", "Der Job wurde abgebrochen!")
	end

	removePedFromVehicle(thePlayer)
	thePlayer:setPosition(gettok(self.EndPos, 1, "|"), gettok(self.EndPos, 2, "|"), gettok(self.EndPos, 3, "|"))
	thePlayer:setDimension(0)
	destroyElement(self.Current[thePlayer:getName()]["Vehicle"])
	destroyElement(self.Current[thePlayer:getName()]["Marker"])
	destroyElement(self.Current[thePlayer:getName()]["Blip"])
	self.Current[thePlayer:getName()] = nil
end

PilotJob = new(CPilotJob)
