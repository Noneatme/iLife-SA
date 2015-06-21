--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CMinerJob = {}

function CMinerJob:constructor()
	self.Marker = {}

	self.Marker[1] = createMarker(614.72210693359, 868.37243652344, -42.9609375, "corona", 4, 255, 0, 0, 255, getRootElement())
	addEventHandler("onMarkerHit", self.Marker[1],
		function(hitElement, match)
			if (match and getElementType(hitElement) == "player" and not(isPedInVehicle(hitElement))) then
				triggerClientEvent(hitElement, "onMinerJobMarkerHit", getRootElement(), 1)
			end
		end
	)

	self.Marker[2] = createMarker(589.91430664063, 916.27349853516, -43.076103210449, "corona", 4, 255, 0, 0, 255, getRootElement())
	addEventHandler("onMarkerHit", self.Marker[2],
		function(hitElement, match)
			if (match and getElementType(hitElement) == "player" and not(isPedInVehicle(hitElement))) then
				triggerClientEvent(hitElement, "onMinerJobMarkerHit", getRootElement(), 2)
			end
		end
	)

	self.Marker[3] = createMarker(550.57067871094, 908.07446289063, -42.9609375, "corona", 4, 255, 0, 0, 255, getRootElement())
	addEventHandler("onMarkerHit", self.Marker[3],
		function(hitElement, match)
			if (match and getElementType(hitElement) == "player" and not(isPedInVehicle(hitElement))) then
				triggerClientEvent(hitElement, "onMinerJobMarkerHit", getRootElement(), 3)
			end
		end
	)

	self.Earnings = {
		[1] = 150,
		[2] = 500,
		[3] = 2000,
	}

	self.ItemEarnings = {
		[1] = 229,
		[2] = 229,
		[3] = 229,
	}

	self.State = {}

	addEvent("onClientMinerJobStart", true)
	addEventHandler("onClientMinerJobStart", getRootElement(), bind(CMinerJob.start, self))

	addEvent("onClientMinerJobFinish", true)
	addEventHandler("onClientMinerJobFinish", getRootElement(), bind(CMinerJob.finish, self))

	new(CJob, 9, "Bohrmeister", "605.94879150391|868.27996826172|-40.185264587402")
end

function CMinerJob:destructor()

end

function CMinerJob:start(difficulty, typ)
	Achievements[5]:playerAchieved(client)

	self.State[getPlayerName(client)] = {["Difficulty"]=difficulty,["Typ"]=typ,["TickCount"]=getTickCount()}
	triggerClientEvent(client, "onServerSubmitMinerJob", getRootElement(), difficulty, typ)
end

function CMinerJob:finish(success)
	if (success) then
		if (type(self.State[getPlayerName(client)]) == "table") then
			if (self.State[getPlayerName(client)]["Typ"] == 2) then
				local itemcount = 1

				if (self.State[getPlayerName(client)]["Difficulty"] == 3) then
					itemcount = 40
				else
					if (self.State[getPlayerName(client)]["Difficulty"] == 2) then
						itemcount = 10
					else
						itemcount = 3
					end
				end

				client:showInfoBox("info", "Du hast "..Items[self.ItemEarnings[self.State[getPlayerName(client)]["Difficulty"]]]:getName().." (x"..tostring(itemcount)..") erhalten!")

				client:getInventory():addItem(Items[self.ItemEarnings[self.State[getPlayerName(client)]["Difficulty"]]], itemcount)
				client:refreshInventory()
				client:incrementStatistics("Job", "Items_abgebaut", itemcount)
			else
				client:addMoney(self.Earnings[self.State[getPlayerName(client)]["Difficulty"]]*getEventMultiplicator())
				client:incrementStatistics("Job", "Geld_erarbeitet", self.Earnings[self.State[getPlayerName(client)]["Difficulty"]])
				client:checkJobAchievements()
				client:showInfoBox("info", "Du erhälst "..tostring(self.Earnings[self.State[getPlayerName(client)]["Difficulty"]]).."$ !")
			end
		end
	else
		client:showInfoBox("error","Dir ist dein Bohrer kaputt gegangen.")
	end
end

MinerJob = new(CMinerJob)
