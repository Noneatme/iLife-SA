--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CChest = {}

function CChest:constructor(Chest, Lobby, Spawn)
	self.Lobby = Lobby
	self.Spawn = Spawn
	
	self.Chest = Chest
	
	self.Rand = math.random(1, 10)
	
	addEventHandler("onElementClicked", self.Chest, 
		function(btn, state, thePlayer)
			if (state == "down") then
				local x,y,z = getElementPosition(self.Chest)
				local x1, y1, z1 = getElementPosition(thePlayer)
				if (getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) <= 2) then
					if isTimer(self.Respawn) then
						thePlayer:showInfoBox("info", "Diese Kiste ist leer!")
					end
					if (self.Rand < 2) then
						thePlayer:showInfoBox("info", "Diese Kiste ist leer!")
					else
						if (self.Rand == 2) then
							thePlayer:showInfoBox("info", "Du hast ein Medikit gefunden!")
							setElementHealth(thePlayer, 100)
						end
						if (self.Rand == 3) then
							thePlayer:showInfoBox("info", "Du hast eine Schutzweste gefunden!")
							setPedArmor(thePlayer, 100)
						end
						if (self.Rand == 4) then
							thePlayer:showInfoBox("info", "Du hast einen Dildo gefunden!")
							giveWeapon(thePlayer, 10, 1)
						end
						if (self.Rand == 5) then
							thePlayer:showInfoBox("info", "Du hast eine Shotgun gefunden!")
							giveWeapon(thePlayer, 25, 5)
						end
						if (self.Rand == 6) then
							thePlayer:showInfoBox("info", "Du hast ein Tränengas gefunden!")
							giveWeapon(thePlayer, 17, 1)
						end
						if (self.Rand == 7) then
							thePlayer:showInfoBox("info", "Du hast ein Katana gefunden!")
							giveWeapon(thePlayer, 8, 1)
						end
						if (self.Rand == 8 ) then
							thePlayer:showInfoBox("info", "Du hast ein Gewehr gefunden!")
							giveWeapon(thePlayer, 33, 5)
						end	
						if (self.Rand == 9) then
							thePlayer:showInfoBox("info", "Du hast eine Deagle gefunden!")
							giveWeapon(thePlayer, 24, 5)
						end
						if (self.Rand == 10) then
							thePlayer:showInfoBox("info", "Du hast einen Raketenwerfer gefunden!")
							giveWeapon(thePlayer, 35, 1)
						end
					end
					self.Rand = 1
					setTimer(function() self.Rand = math.random(1, 10) end, 60000, 1)
				else
					thePlayer:showInfoBox("error", "Du bist zu weit entfernt!")
				end
			end
		end
	)
end

function CChest:destructor()
	destroyElement(self.Chest)
	if isTimer(self.Respawn) then
		killTimer(self.Respawn)
	end
end