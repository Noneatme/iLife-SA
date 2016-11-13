--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Lobbys = {}
OfficialLobbys = {}

CLobby = {}

function CLobby:constructor(Map ,Size, Name, MinPlayers, Custom)
	
	self.Custom = Custom
	
	--Game Type
	-- 1: Standard
	self.Type = 1
	-- Game Map
	self.Mapname = Map
	self.Map = new(CMap, Map)
	-- Game Size
	if (self.Map:getMaxSize() < Size) then
		Size = self.Map:getMaxSize()
	end
	self.Size = Size
	
	self.Name = Name
	
	self.Dim = getEmptyDimension()
	
	self.Dimped = createPed(0,0,0,0)
	setElementDimension(self.Dimped, self.Dim)
	
	if (not(self.Custom)) then
		self.ID = "O"..self.Dim
	else
		self.ID = self.Dim
	end
	
	self.MinPlayers = MinPlayers
	
	--If desired Gamesize is bigger then Mapsize!
	if (self.Size > self.Map:getMaxSize()) then
		self.Size = self.Map:getMaxSize()
	end

	--Fetch Playerspawns from CMap
	self.PlayerSpawns = self.Map:getPlayerSpawns()
	self.FreeSpawns = self.PlayerSpawns
	self.BusySpawns = {}
	
	--Status
	-- 0: Preparing
	-- 1: Start
	-- 2: End
	self.Status = 0
	
	--Players at Beginnging of the Round
	self.Players = {}
	--Spectators
	self.Spectators = {}
	--Survivors
	self.Survivors = {}

	self.Chests = {}
	
	self.Objects = {}
	
	for k,v in ipairs(self.Map:getObjects()) do
		local obj = createObject(v["ID"], v["X"], v["Y"], v["Z"], v["RotX"], v["RotY"], v["RotZ"], false)
		setObjectScale(obj, v["Scale"])
		setElementCollisionsEnabled(obj, v["collisions"])
		--setObjectBreakable(obj, v["breakable"])
		setElementDimension(obj, self.Dim)
		table.insert(self.Objects, obj)
	end
	
	--Save the current timestamp to calculate runtime
	self.CreationTimestamp = 0
	
	self.Winner = nil
	
	--Add instance to Table
	Lobbys[tostring(self.ID)] = self
	
	if (not (self.Custom)) then
		OfficialLobbys[tostring(self.ID)] = self
	end
end

function CLobby:destructor()
	--Remove instance from Table
	for k,v in pairs(self.Survivors) do
		delete(v)
	end
	
	for k,v in ipairs(self.Chests) do
		delete(v)
	end
	for k,v in ipairs(self.Objects) do
		destroyElement(v)
	end
	
	destroyElement(self.Dimped)
	
	Lobbys[tostring(self.ID)] = nil
	if (self.Winner) then
		outputDebugString("The Lobby with ID "..self.ID.." finished! Winner: "..self.Winner)
	end

	OfficialLobbys[tostring(self.ID)] = nil
end

function CLobby:joinPlayer(thePlayer)
	-- If Game is in preparation... Let the player join!
	if (self.Status == 0) then
		--Save the Player into the instance.
		self.Players[thePlayer:getName()] = thePlayer
		-- Create a new CSurvivor instance
		self.Survivors[thePlayer:getName()] = new(CSurvivor, thePlayer, self, self.FreeSpawns[1])
		thePlayer:setInSpecial("HungerGames")
		--Handle Spawns. They should not be used twice!
		table.insert(self.BusySpawns, self.FreeSpawns[1])
		table.remove(self.FreeSpawns, 1)
		if (table.size(self.Players) >= self.MinPlayers) then
			if (not(isTimer(self.StartTimer))) then
				self:sendMessageToAllPlayers("Es sind genug Spieler angemeldet! Das Spiel beginnt in 3 Minuten!", 0,255,0)
				self.TimerCounts = 0
				self.StartTimer = setTimer(
					function()
						if (table.size(self.Players) >= self.MinPlayers) then
							self.TimerCounts = self.TimerCounts+1
							--outputDebugString("Tick: "..self.TimerCounts)
							if ( (self.TimerCounts < 31) and (self.TimerCounts%12 == 0)) then
								self:sendMessageToAllPlayers("Das Spiel startet in "..(3-(self.TimerCounts/12)).." Minute(n)!", 0,255,0)
							end
							if ( (self.TimerCounts > 31) and (self.TimerCounts < 36)) then
								self:sendMessageToAllPlayers("Das Spiel startet in "..((36-self.TimerCounts)*5).." Sekunden!", 0,255,0)
							end
							if (self.TimerCounts == 36) then
								self:startGame()
								for k,v in ipairs(self.Map:getChestPositions()) do
									--outputDebugString(toJSON(v))
									if (math.random(1,3) == 3) then
										local chest = createObject(2977, v["X"], v["Y"], v["Z"]-0.1,v["RotX"], v["RotY"], v["RotZ"])
										setElementDimension(chest, self.Dim)
										table.insert(self.Chests, new(CChest, chest ,self, v))
									end
								end
							end
						else
							self:sendMessageToAllPlayers("Es haben zu viele Spieler verlassen.", 255,0,0)
							killTimer(self.StartTimer)
							self.TimerCounts = 0
						end
				end, 5000, 36)
			end
		else
			self:sendMessageToAllPlayers("Es müssen weitere "..(math.round(self.MinPlayers-table.size(self.Players)+0.5,0,"floor")).." Spieler beitreten, damit das Spiel startet!", 0,255,0)
			--outputDebugString("Min: "..self.MinPlayers.." | Currently: "..table.size(self.Players))
		end
	else
		thePlayer:showInfoBox("error", "Das Spiel läuft bereits!")
	end
end

function CLobby:leavePlayer(thePlayer)
	if (self.Status == 0) then
		self.Players[thePlayer:getName()] = nil
		for k,v in ipairs(self.BusySpawns) do
			if (self.Survivors[thePlayer:getName()]:getSpawn() == v) then
				table.remove(self.BusySpawns, k)
				table.insert(self.FreeSpawns, v)
			end
		end
	else
		if (self.Status == 1) then
			delete(self.Survivors[thePlayer:getName()])
		end
	end
	self.Survivors[thePlayer:getName()] = nil
end

function CLobby:startGame()
	self.Status = 1
	for k,v in pairs(self.Survivors) do
		toggleAllControls(v:getPlayer(), true)
	end
	self:sendMessageToAllPlayers("Das Spiel hat begonnen! Fröhliche Hungerspiele!", 255,255,0)
end

function CLobby:getSurvivorCount()
	return table.size(self.Survivors)
end

function CLobby:PlayerDied(thePlayer)
	if (self.Status == 1) then
		for k,v in pairs(self.Survivors) do
			triggerClientEvent(v:getPlayer(), "onClientPlaySound", v:getPlayer(), "http://rewrite.ga/HungerGames/Kanone.mp3", 2, false)
		end
		self.Survivors[thePlayer:getName()] = nil
		self:sendMessageToAllPlayers(thePlayer:getName().." ist gestorben! Es gibt noch "..table.size(self.Survivors).." Überlebende!", 0,255,0)
		if (table.size(self.Survivors) == 1) then 
			for k,v in pairs(self.Survivors) do
				self.Winner = v:getPlayer():getName()
			end
			self:finish()
		end
	end
end

function CLobby:SurvivorLeft(theSurvivor)
	if (self.Status == 0) then
		self.Players[theSurvivor:getPlayersName()] = nil
		for k,v in ipairs(self.BusySpawns) do
			if (self.Survivors[theSurvivor:getPlayersName()]:getSpawn() == v) then
				table.remove(self.BusySpawns, k)
				table.insert(self.FreeSpawns, v)
			end
		end
		local sname = theSurvivor:getPlayersName()
		delete(self.Survivors[theSurvivor:getPlayersName()], false, true)
		self.Survivors[sname] = nil
		if (table.size(self.Survivors) == 0) then 
			if (self.Custom) then
				delete(self)
			end
		end
	end
	if (self.Status == 1) then
		setElementHealth(theSurvivor:getPlayer(), 0)
	end
end

function CLobby:SurvivorDisconnected(theSurvivor)
	if (self.Status == 0) then
		self.Players[theSurvivor:getPlayersName()] = nil
		for k,v in ipairs(self.BusySpawns) do
			if (self.Survivors[theSurvivor:getPlayersName()]:getSpawn() == v) then
				table.remove(self.BusySpawns, k)
				table.insert(self.FreeSpawns, v)
			end
		end
		local sname = theSurvivor:getPlayersName()
		delete(self.Survivors[theSurvivor:getPlayersName()], true, false)
		self.Survivors[sname] = nil
		if (table.size(self.Survivors) == 0) then 
			if (self.Custom) then
				delete(self)
			end
		end
	end
	if (self.Status == 1) then
		for k,v in pairs(self.Survivors) do
			triggerClientEvent(v:getPlayer(), "onClientPlaySound", v:getPlayer(), "http://rewrite.ga/HungerGames/Kanone.mp3", 2, false)
		end
		self.Survivors[theSurvivor:getPlayersName()] = nil
		self:sendMessageToAllPlayers(theSurvivor:getPlayersName().." hat das Spiel verlassen! Es gibt noch "..table.size(self.Survivors).." Überlebende!", 0,255,0)
		
		if (table.size(self.Survivors) == 1) then 
			for k,v in pairs(self.Survivors) do
				self.Winner = v:getPlayer():getName()
			end
			self:finish()
		end
	end
end

function CLobby:getDimension()
	return self.Dim
end

function CLobby:finish()
	self:sendMessageToAllPlayers("Du hast die HungerGames gewonnen!", 0,255,0)
	if (not (self.Custom)) then
	end
	setTimer(function()
		for k,v in pairs(self.Survivors) do
			v:getPlayer():getInventory():addItem(Items[41], 1)
			v:getPlayer():showInfoBox("info", "Du hast eine Gewinnmünze erhalten!")
			Achievements[67]:playerAchieved(v:getPlayer())
		end	
	
		delete(self) 	
	end, 5000, 1)
end																						

function CLobby:sendMessageToAllPlayers(msg, r,g,b)
	for k,v in pairs(self.Survivors) do
		v:getPlayer():showInfoBox("info", msg)
	end
end

function CLobby:isSurvivor(tp)
	if ( not (self.Survivors[tp:getName()]) ) then
		return false
	end
	return true
end

addEvent("onPlayerJoinLobby", true)
addEventHandler("onPlayerJoinLobby", getRootElement(),
function(id)
	id = tostring(id)
	if (Lobbys[id]) then
		if (Lobbys[id]:isSurvivor(source)) then
		else
			Lobbys[id]:joinPlayer(source)
		end
	else
		source:showInfoBox("error", "Diese Lobby existiert nicht!")
	end
end
)

addEvent("onClientRequestLobbies", true)
addEventHandler("onClientRequestLobbies", getRootElement(), 
	function() 
		local States = {
			[0] = "In Preperation",
			[1] = "Running"
		}
		local Lob = {}
		for k,v in pairs(Lobbys) do
			Lob[v["ID"]] = {
				["ID"]= v["ID"],
				["Name"] = v["Name"],
				["Size"] = table.size(v["Survivors"]).."/"..v["Size"],
				["Mapname"] = v["Mapname"],
				["Status"] = States[v["Status"]]
			}
		end
		triggerClientEvent(source, "onServerSendLobbies", source, Lob)
	end
)

addEvent("onPlayerStartLobby", true)
addEventHandler("onPlayerStartLobby", getRootElement(),
	function(Name, MaxPlayers, Map)
		local lobby = new(CLobby, Map, MaxPlayers, Name, MaxPlayers/2, true)
		lobby:joinPlayer(source)
	end
)

setTimer(
function()
	if (table.size(OfficialLobbys) < 3) then
		for i=table.size(OfficialLobbys),2,1 do
			local mapstr = ClientMaps[math.random(1, #ClientMaps)]
			new(CLobby, mapstr, 1024, "Ranked Lobby", 3, false)
		end
	end
end,30000,0)

setTimer(
function()
	for k,v in pairs(Lobbys) do
		if (v.Status == 1) then
			for kk,vv in pairs(v.Survivors) do
				if (isElementInWater(vv.Player)) then
					setElementHealth(vv.Player, 0)
				end
			end
		end
	end
end, 5000, 0)
