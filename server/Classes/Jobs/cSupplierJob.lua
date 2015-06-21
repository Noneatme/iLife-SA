--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSupplierJob = {}

addEvent("onSupplierJobStart", true)

function CSupplierJob:constructor()
	--Targets  to finish the Job
	self.Targets = {
		[1] = "2396.0302734375|-1977.56640625|13.546875", --Ammunation South
		[2] = "2395.7197265625|-1887.3681640625|13.54687", --Clucking Bell South
		[3] = "2478.9482421875|-1741.8134765625|13.546875", -- Supermarket South
		[4] = "2244.9970703125|-1661.21484375|15.469003677368", -- ZIP Groove
		[5] = "1567.9130859375|-1878.083984375|13.546875", -- Restaurant South
		[6] = "1352.30859375|-1751.87890625|13.358191490173", -- Supermarket PD
		[7] = "1422.4892578125|-1706.796875|13.546875", -- Clothes PD
		[8] = "1362.6484375|-1279.958984375|13.3828125", --Ammunation Central
		[9] = "1148.302734375|-1135.8349609375|23.828125", --Sexshop Central
		[10] = "987.1416015625|-946.712890625|41.458801269531", -- Temple Cars
		[11] = "2125.7353515625|-1117.5107421875|25.346075057983", --Cout an Schulz
		[12] = "765.939453125|-1431.306640625|13.530225753784", --Boat Club
		[13] = "561.01171875|-1248.806640625|17.233730316162", --Grotti
		[14] = "449.6318359375|-1479.5322265625|30.626256942749" --Clothes East
	}

	--Current Playersessions
	self.Current = {}

	--Vehicle Spawn
	self.Spawn = "0|0|2205.0634765625|-2229.849609375|14.555351257324|359.53308105469|0|314.55505371094"

	--Job Marker
	self.Marker = createMarker(2179.5302734375,-2255.6435546875,14.7734375, "corona", 2, 125,0,0,255, getRootElement())

	-- Job Marker Hit Event
	addEventHandler("onMarkerHit", self.Marker, function(hitElement, matchingDimensions)
		if (hitElement:getType() == "player") then
			if ( not (isPedInVehicle(hitElement)) ) then
				triggerClientEvent(hitElement, "onClientSupplierjobMarkerHit", hitElement)
			end
		end
	end
	)

	-- Koords for CJob
	self.Koords = "2179.5302734375|-2255.6435546875|14.7734375"

	-- Endposition
	self.EndPos = "2183.5419921875|-2260.421875|13.403070449829"

	--Eventhandler
	self.eOnSupplierJobStart = bind(self.onStart, self)
	addEventHandler("onSupplierJobStart", getRootElement(), self.eOnSupplierJobStart)

	self.eOnSupplierJobFinish = bind(self.onFinish, self)

	-- Call the CJob Constructor
	new(CJob, 1, "Zulieferer", self.Koords)
end

function CSupplierJob:destructor()

end

function CSupplierJob:onStart()
	if not(clientcheck(source, client)) then return false end

	if (not (isElementWithinMarker(client, self.Marker))) then
		client:showInfoBox("error", "Du bist am falschen Ort!")
		return false
	end

	local thePlayer = source
	Achievements[5]:playerAchieved(thePlayer)
	local theTarget = math.random(1,#self.Targets)
	self.Current[thePlayer:getName()] = {
		["Target"] = self.Targets[theTarget],
		["Vehicle"] = createVehicle(515, gettok(self.Spawn, 3, "|"), gettok(self.Spawn, 4, "|"), gettok(self.Spawn, 5, "|"), gettok(self.Spawn, 6, "|"), gettok(self.Spawn, 7, "|"), gettok(self.Spawn, 8, "|"), "Plate", false, 0, 0),
		["Trailer"] = createVehicle(435, 0,0,0,gettok(self.Spawn, 6, "|"), gettok(self.Spawn, 7, "|"), gettok(self.Spawn, 8, "|"),"Plate", false, math.random(0,5),0),
		["Marker"] =  createMarker(gettok(self.Targets[theTarget],1,"|"), gettok(self.Targets[theTarget],2,"|"), gettok(self.Targets[theTarget],3,"|"), "corona", 3, 0,255,0,255, thePlayer),
		["Blip"] = createBlip(gettok(self.Targets[theTarget],1,"|"), gettok(self.Targets[theTarget],2,"|"), gettok(self.Targets[theTarget],3,"|"), 41, 3, 255, 0, 0, 255, 0, 1337, thePlayer)
	}

	setVehicleEngineState(self.Current[thePlayer:getName()]["Vehicle"], true)
	setVehicleLocked(self.Current[thePlayer:getName()]["Vehicle"], true)
	warpPedIntoVehicle(thePlayer, self.Current[thePlayer:getName()]["Vehicle"])
	attachTrailerToVehicle(self.Current[thePlayer:getName()]["Vehicle"], self.Current[thePlayer:getName()]["Trailer"])

	triggerClientEvent(getRootElement(), "ghostElement", self.Current[thePlayer:getName()]["Vehicle"])
	triggerClientEvent(getRootElement(), "ghostElement", self.Current[thePlayer:getName()]["Trailer"])

	addEventHandler("onMarkerHit", self.Current[thePlayer:getName()]["Marker"],
		function(theElement, matchingDimension)
			if (matchingDimension) then
				if (theElement and isElement(theElement) and getElementType(theElement) == "vehicle") then
					if (getVehicleOccupant(theElement) == thePlayer) then
						if (theElement == self.Current[getVehicleOccupant(theElement):getName()]["Vehicle"]) then
							self:onFinish(getVehicleOccupant(theElement,0), true)
						end
					end
				end
			end
		end
	)

	setVehicleEngineState(self.Current[thePlayer:getName()]["Vehicle"], true)

	addEventHandler("onTrailerDetach", self.Current[thePlayer:getName()]["Trailer"],
		function()
			self:onFinish(thePlayer, false)
		end
	)

	addEventHandler("onVehicleStartExit", self.Current[thePlayer:getName()]["Vehicle"],
		function(theExiter, seat, jacked, door)
			if (not jacked) then
				self:onFinish(theExiter, false)
			end
		end
	)

end

function CSupplierJob:onFinish(thePlayer, sucess)
	if (sucess) then
		local money = math.round((getDistanceBetweenPoints3D(gettok(self.Koords, 1, "|"), gettok(self.Koords, 2, "|"), gettok(self.Koords, 3, "|"), gettok(self.Current[thePlayer:getName()]["Target"],1,"|"), gettok(self.Current[thePlayer:getName()]["Target"],2,"|"), gettok(self.Current[thePlayer:getName()]["Target"],3,"|"))/5)*getEventMultiplicator())
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
	destroyElement(self.Current[thePlayer:getName()]["Vehicle"])
	destroyElement(self.Current[thePlayer:getName()]["Trailer"])
	destroyElement(self.Current[thePlayer:getName()]["Marker"])
	destroyElement(self.Current[thePlayer:getName()]["Blip"])
	self.Current[thePlayer:getName()] = nil
end

SupplierJob = new(CSupplierJob)
