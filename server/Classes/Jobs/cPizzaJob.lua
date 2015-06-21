--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
CPizzaJob = {}
addEvent("onPizzaJobStart",true)

function CPizzaJob:constructor()
-- Current Playersessions
	self.Current = {}
	
-- Spawn
	self.Spawn = "0|0|2095.9057617188|-1807.4683837891|13.544578552246|359.30987548828|0.0001220703125|90.007446289063"

-- Endposition
	self.EndPos = "2101.5959472656|-1802.4538574219|13.5546875"
	
-- Eventhandler

	self.eOnPizzaJobStart = bind(CPizzaJob.onStart,self)
	addEventHandler("onPizzaJobStart",getRootElement(),self.eOnPizzaJobStart)
	
	self.eOnPizzaJobFinish = bind(CPizzaJob.onFinish,self)

-- Marker
	self.Marker = createMarker(2101.904296875,-1811.3232421875,13.5546875, "corona", 2, 125,0,0,255, getRootElement())
-- Job Marker Hit Event

	addEventHandler("onMarkerHit", self.Marker, function(hitElement, matchingDimensions)
		if (hitElement:getType() == "player") then
			if ( not (isPedInVehicle(hitElement)) ) then
				triggerClientEvent(hitElement, "onClientPizzajobMarkerHit", hitElement)
			end
		end
	end
	)
	
-- Koords for CJob

	self.Koords = "2101.904296875|-1811.3232421875|13.5546875"
	
-- Call the CJob Constructor
	new(CJob, 6,"Pizzajob",self.Koords)
end

function CPizzaJob:destructor()

end

function CPizzaJob:getNewHouse()
	newhouse = Houses[math.random(1, #Houses)]
	return newhouse
end

function CPizzaJob:onStart()
	if not(clientcheck(source, client)) then return false end
	local thePlayer = source
	Achievements[5]:playerAchieved(thePlayer)
	local target = self:getNewHouse()
	x,y,z = getElementPosition(target)
	if (self.Current[thePlayer:getName()]) then
		showInfoBox("error", "Fahre deinen vorherigen Job zuende!")
		return
	end
	self.Current[thePlayer:getName()] = {
		["Vehicle"] = createVehicle(448, gettok(self.Spawn, 3, "|"), gettok(self.Spawn, 4, "|"), gettok(self.Spawn, 5, "|"), gettok(self.Spawn, 6, "|"), gettok(self.Spawn, 7, "|"), gettok(self.Spawn, 8, "|"), "Plate", false, 0, 0),
		["Blip"] = createBlip(x,y,z,41,3,255,0,0,255,0,1337,thePlayer),
		["Target"] = x.."|"..y.."|"..z,
		["Colshape"] = createColSphere(x,y,z,3)
	}
	
	setVehicleEngineState(self.Current[thePlayer:getName()]["Vehicle"],true)
	warpPedIntoVehicle(thePlayer,self.Current[thePlayer:getName()]["Vehicle"])
	triggerClientEvent(getRootElement(), "ghostElement", self.Current[thePlayer:getName()]["Vehicle"])
	triggerClientEvent(thePlayer,"pedCanBeKnockedOffBike",thePlayer)
	addEventHandler("onColShapeHit",self.Current[thePlayer:getName()]["Colshape"],
		function(hitElement,matching)
			if ( hitElement == getPedOccupiedVehicle(thePlayer) ) then
				self:onFinish(thePlayer, true)
			end
		end)
		
	addEventHandler("onVehicleStartExit", self.Current[thePlayer:getName()]["Vehicle"], 
		function(theExiter, seat, jacked, door)
			self:onFinish(theExiter, false)
		end
	)
	
	addEventHandler("onPlayerQuit",thePlayer,onPlayerQuitInPizzaJob)
	addEventHandler("onPlayerWasted",thePlayer,onPlayerQuitInMuellabfuhr)
end

function onPlayerQuitInPizzaJob()
	self:onFinish(source, false)
end

function CPizzaJob:onFinish(thePlayer, sucess)
	if (sucess) then
		local money = math.round(getDistanceBetweenPoints3D(gettok(self.Koords, 1, "|"), gettok(self.Koords, 2, "|"), gettok(self.Koords, 3, "|"), gettok(self.Current[thePlayer:getName()]["Target"],1,"|"), gettok(self.Current[thePlayer:getName()]["Target"],2,"|"), gettok(self.Current[thePlayer:getName()]["Target"],3,"|"))/9)
		thePlayer:showInfoBox("info", "Du hast für den Job "..tostring(money).."$ erhalten!")
		thePlayer:setMoney(thePlayer:getMoney()+money)
		thePlayer:incrementStatistics("Job", "Geld_erarbeitet", money)
		thePlayer:checkJobAchievements()
	else
		thePlayer:showInfoBox("info", "Der Job wurde abgebrochen!")
	end
	triggerClientEvent(thePlayer,"pedCanBeKnockedOffBike",thePlayer)
	removePedFromVehicle(thePlayer)
	thePlayer:setPosition(gettok(self.EndPos, 1, "|"), gettok(self.EndPos, 2, "|"), gettok(self.EndPos, 3, "|"))
	destroyElement(self.Current[thePlayer:getName()]["Vehicle"])
	destroyElement(self.Current[thePlayer:getName()]["Blip"])
	destroyElement(self.Current[thePlayer:getName()]["Colshape"])
	setElementDimension(thePlayer,0)
	setElementDimension(thePlayer,0)
	removeEventHandler("onPlayerQuit",thePlayer,onPlayerQuitInPizzaJob)
	removeEventHandler("onPlayerWasted",thePlayer,onPlayerQuitInMuellabfuhr)
	self.Current[thePlayer:getName()] = nil
end

PizzaJob = new(CPizzaJob)

]]