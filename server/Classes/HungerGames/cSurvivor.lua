--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSurvivor = {}

function CSurvivor:constructor(Player, Lobby, Spawn)
	self.Player = Player
	self.PlayerName = self.Player:getName()
	self.Spawn = Spawn
	self.Lobby = Lobby

	spawnPlayer(self.Player, Spawn["X"], Spawn["Y"], Spawn["Z"], Spawn["RotZ"], self.Player:getSkin(), 0, self.Lobby:getDimension(), nil)

	setElementDimension(self.Player, self.Lobby:getDimension())

	toggleAllControls(self.Player, false)

	self.eOnWasted = bind(CSurvivor.onWasted, self)
	addEventHandler("onPlayerWasted", self.Player, self.eOnWasted)

	self.eOnDisconnect = bind(CSurvivor.onDisconnect, self)
	addEventHandler("onPlayerQuit", self.Player, self.eOnDisconnect)

	self.bOnLeave = bind(CSurvivor.bLeave, self)
	bindKey(self.Player, "F4", "down", self.bOnLeave)

	setPlayerHudComponentVisible(self.Player, "crosshair", true)

	self.Player:showInfoBox("info", "Du kannst die Lobby mit F4 verlassen!")
end

function CSurvivor:destructor(dc, left)
	if (dc) then
	else
		unbindKey(self.Player, "F4", "down", self.bOnLeave)
		if (left) then
			spawnPlayer(self.Player, 1800+((math.random(1,400)/100)-2), -1303+((math.random(1,400)/100)-2), 120.25536347, 0, self.Player.Skin, 0, 2)
			self.Player:setInSpecial(nil)
			setElementFrozen(self.Player, false)
			toggleAllControls(self.Player, true)
		else
			self.Lobby:PlayerDied(self.Player)
			setTimer(function() spawnPlayer(self.Player, 1800+((math.random(1,400)/100)-2), -1303+((math.random(1,400)/100)-2), 120.25536347, 0, self.Player.Skin, 0, 2) self.Player:setInSpecial(nil) setElementFrozen(self.Player, false) toggleAllControls(self.Player, true) end, 5000, 1)
		end
	end
	removeEventHandler("onPlayerWasted", self.Player, self.eOnWasted)
	removeEventHandler("onPlayerQuit", self.Player, self.eOnDisconnect)
end

function CSurvivor:startFight()
	toggleAllControls(self.Player, true)
end

function CSurvivor:onWasted()
	self.Player:showInfoBox("info", "Du hast Rang "..self.Lobby:getSurvivorCount().." erreicht!")
	delete(self)
end

function CSurvivor:onDisconnect()
	self.Lobby:SurvivorDisconnected(self)
	delete(self, true)
end

function CSurvivor:getPlayer()
	return self.Player
end

function CSurvivor:getPlayersName()
	return self.PlayerName
end

function CSurvivor:getSpawn()
	return self.Spawn
end

function CSurvivor:bLeave()
	self.Lobby:SurvivorLeft(self)
end
