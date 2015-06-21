--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onClientLineJobStart", true)
addEvent("onClientLineJobFinish", true)
addEvent("onClientLineJobStep", true)

CLineJob = {}

function CLineJob:constructor()
	--[[
	self.Marker = createMarker(2653.622070,-1458.5361328125, 30.5509, "corona", 2, 255, 0, 0, 255, getRootElement())

	addEventHandler("onMarkerHit", self.Marker,
		function(hitElement, matching)
			if (matching) then
				hitElement:showInfoBox("info","Der Job ist noch nicht implementiert!")
				-- triggerClientEvent(hitElement, "onLineJobMarkerHit", getRootElement())
			end
		end
	)

	addEventHandler("onClientLineJobStart", getRootElement(), bind(CLineJob.start, self))
	addEventHandler("onClientLineJobFinish", getRootElement(), bind(CLineJob.finish, self))
	addEventHandler("onClientLineJobStep", getRootElement(), bind(CLineJob.step, self))

	-- Player States
	self.State = {}

	-- Speed Dificulty
	self.Speeds = {5,10,20,50}

	-- Earnings
	self.Earnings = {10,15,25,45}

	-- Calling CJob Constructor for further Handling.
	new(CJob, 9, "Fließbandarbeiter", "2653.6220703125|-1458.5361328125|30.550909042358")
	]]
end

function CLineJob:destructor()

end

function CLineJob:step()
	if (self.State[getPlayerName(client)]) then
		--Add money to State
		self.State[getPlayerName(client)]["Money"] = self.State[getPlayerName(client)]["Money"] + self.Earnings[math.round(((getTickCount()-self.State[getPlayerName(client)]["Starttick"])%240000)/4)]
		self.State[getPlayerName(client)]["Step"] = self.State[getPlayerName(client)]["Step"]+1
	end
end

function CLineJob:start()
	--Achievement for working
	Achievements[5]:playerAchieved(client)

	--Reset the state if player already started a job
	if (self.State[getPlayerName(client)]) then
		self.State[getPlayerName(client)] = {}
	end

	self.State[getPlayerName(client)]["Starttick"] = getTickCount()
	self.State[getPlayerName(client)]["Step"] = 0
	self.State[getPlayerName(client)]["Money"] = 0

	--Tell the client the Speed values
	triggerClientEvent(client, "onLineJobStart", getRootElement(), self.Speeds)
end

function CLineJob:finish(count)
	if (self.State[getPlayerName(client)]) then
		local duration = getTickCount()-self.State[getPlayerName(client)]["Starttick"]
		if (count ~= self.State[getPlayerName(client)]["Step"]) then
			--Job mismatch
			cheatBan(client, 3)
		end
		if (duration > 240000) or (duration < 120000)  then
			-- Player failed to fast or was cheating.
			self:reset(client)
			return false
		end
		client:addMoney(self.State[getPlayerName(client)]["Money"])
		client:showInfoBox("info", "Du hast "..formNumberToMoneyString(self.State[getPlayerName(client)]["Money"]).." erarbeitet!")

		client:incrementStatistics("Job", "Geld_erarbeitet", self.State[getPlayerName(client)]["Money"])
		client:checkJobAchievements()
	else
		--Not working
	end
end

function CLineJob:reset()
	self.State[getPlayerName(client)] = false
	triggerClientEvent(client, "onServerResetLineJob", getRootElement())
end

LineJob = new(CLineJob)
