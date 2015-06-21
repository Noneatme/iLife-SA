--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDrugCookJob = {}

function CDrugCookJob:constructor()
	addEvent("onClientDrugCookStep", true)
	addEventHandler("onClientDrugCookStep", getRootElement(), bind(CDrugCookJob.onClientStep, self))

	self.StartMarker = createMarker(2755.3447265625,-2515.6015625,13.639715194702, "corona", 1, 255, 0, 0, 255, getRootElement())
	addEventHandler("onMarkerHit", self.StartMarker,
		function (element, matching)
			if (getElementType(element) == "player") then
				if not(isPedInVehicle(element)) then
					triggerClientEvent(element, "onDrugCookJobMarkerHit", element)
				end
			end
		end
	)


	self.State = {}

	--Ped: 1372.1103515625|-47.703125|1000.9165649414


	self.StationKoords = {
		[1] = {["X"]=1360.59998,["Y"]=-30.4,["Z"]=1000.59000} , --Crate
		[2] = {["X"]=1371.30005,["Y"]=-19.4,["Z"]=1000.59000} , --Goods
		[3] = {["X"]=1361.09998,["Y"]=-35.1,["Z"]=1000.59000} , --Oil
		[4] = {["X"]=1375.50000,["Y"]=-42.5,["Z"]=1000.59000} , --Smoke
		[5] = {["X"]=1377.09998,["Y"]=-11.9,["Z"]=1000.59000} , --Gas
		[6] = {["X"]=1376.30005,["Y"]=-28.3,["Z"]=1000.59000} , --Water
		[7] = {["X"]=1361.00000,["Y"]=-16.8,["Z"]=1000.59000} , --Boxing
		[8] = {["X"]=1361.90002,["Y"]=-44.5,["Z"]=1000.59000} 	--Turnin
	}

	self.MapRoot = mapManager:getMapRootObjects("res/maps/jobs/druglabor.map")

	self.Objects = {}

	for k,v in pairs(self.MapRoot) do
		table.insert(self.Objects, v)
	end

	new(CJob, 5, "Drogenkoch", "2755.3447265625|-2515.6015625|13.639715194702")
end

function CDrugCookJob:destructor()

end

function CDrugCookJob:start(thePlayer)
	Achievements[5]:playerAchieved(thePlayer)
	local dim = getEmptyDimension()
	triggerClientEvent(thePlayer, "onClientRecieveDrugCookMap", thePlayer, self.Objects, dim)
	setElementInterior(thePlayer, 1, 1363.3974609375, -35.451171875, 1000.921875)
	setElementDimension(thePlayer, dim)

	self.State[thePlayer] = {
		["Dim"] = dim,
		["Station"] = 1,
		["Purity"] = 100,
		["StateMarker"] = createMarker(1360.59998, -30.4, 1000.59000, "corona", 1, 255, 255, 255, 255, getRootElement()),
		["ExitPed"] = createPed(144, 1372.1103515625, -47.703125, 1000.9165649414, 0, false)
	}

	setElementInterior(self.State[thePlayer]["ExitPed"], 1)
	setElementDimension(self.State[thePlayer]["ExitPed"], dim)

	setElementInterior(self.State[thePlayer]["StateMarker"], 1)
	setElementDimension(self.State[thePlayer]["StateMarker"], dim)

	addEventHandler("onMarkerHit", self.State[thePlayer]["StateMarker"],
	function(hitElement, matching)
		if (matching and hitElement==thePlayer) then
			self:nextStep(thePlayer)
		end
	end
	)

	addEventHandler("onElementClicked", self.State[thePlayer]["ExitPed"],
		function()
			self:stop(thePlayer)
		end
	)
end

function CDrugCookJob:stop(thePlayer)
	triggerClientEvent(thePlayer,"onClientEndDrugCookJob", getRootElement())
	setElementInterior(thePlayer, 0)
	setElementDimension(thePlayer, 0)
	setElementPosition(thePlayer, 2755.82421875, -2508.427734375, 13.64318561554)

	destroyElement(self.State[thePlayer]["ExitPed"])
	destroyElement(self.State[thePlayer]["StateMarker"])
	self.State[thePlayer] = nil
end

function CDrugCookJob:onClientStep(Purity)
	if (self.State[client]) then
		self.State[client]["Purity"] = self.State[client]["Purity"]-(20-((20*Purity/100)))
	end
end

function CDrugCookJob:nextStep(thePlayer)
	if (self.State[thePlayer]) then
		triggerClientEvent(thePlayer, "onClientDrugCookStep", getRootElement(), self.State[thePlayer]["Station"])
		if (self.State[thePlayer]["Station"] < #self.StationKoords) then
			self.State[thePlayer]["Station"] = self.State[thePlayer]["Station"]+1
		else
			self.State[thePlayer]["Station"] = 1
			local money = 0
			if self.State[thePlayer]["Purity"] >= 60 then
				if (self.State[thePlayer]["Purity"] > 80) then
					if (self.State[thePlayer]["Purity"] > 95) then
						if (self.State[thePlayer]["Purity"] == 100) then
							money = math.floor(2500*1.87)
						else
							money = math.floor(math.random(1200,1500)*1.87)
						end
					else
						money = math.floor(math.random(800,1000)*1.87)
					end
				else
					money = math.floor(math.random(200,300)*1.87)
				end
			end

			if (self.State[thePlayer]["Purity"]>=60) then
				Achievements[27]:playerAchieved(thePlayer)
			end
			if (self.State[thePlayer]["Purity"]>=98) then
				Achievements[4]:playerAchieved(thePlayer)
			end

			thePlayer:showInfoBox("info", "Reinheit: "..math.floor(self.State[thePlayer]["Purity"]).."%\nLohn:"..formNumberToMoneyString(money))
			money = money*getEventMultiplicator()
			thePlayer:addMoney(money)

			thePlayer:incrementStatistics("Job", "Geld_erarbeitet", money)
			thePlayer:checkJobAchievements()

			self.State[thePlayer]["Purity"] = 100
		end

		local x = self.StationKoords[self.State[thePlayer]["Station"]]["X"]
		local y = self.StationKoords[self.State[thePlayer]["Station"]]["Y"]
		local z = self.StationKoords[self.State[thePlayer]["Station"]]["Z"]

		destroyElement(self.State[thePlayer]["StateMarker"])
		self.State[thePlayer]["StateMarker"] = createMarker(x, y, z, "corona", 1, 255, 255, 255, 255, getRootElement())

		addEventHandler("onMarkerHit", self.State[thePlayer]["StateMarker"],
		function(hitElement, matching)
			if (matching and hitElement==thePlayer) then
				self:nextStep(thePlayer)
			end
		end
		)

		setElementInterior(self.State[thePlayer]["StateMarker"], 1)
		setElementDimension(self.State[thePlayer]["StateMarker"], self.State[thePlayer]["Dim"])
	end

end

addEvent("onClientDrugCookJobStart", true)
addEventHandler("onClientDrugCookJobStart", getRootElement(),
	function()
		if not(clientcheck(source, client)) then return false end
		DrugCookJob:start(source)
	end
)
