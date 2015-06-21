--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCrashedHeli = inherit(CVehicle)

function CCrashedHeli:constructor()
	self.Items = {}
	self.Items[230] = math.random(0,5)
	self.Items[231] = math.random(0,5)
	self.Items[232] = math.random(0,5)
	self.Items[233] = math.random(0,3)
	self.Items[234] = math.random(0,4)
	self.Items[235] = math.random(0,2)
	self.Items[236] = math.random(0,2)
	self.Items[237] = math.random(0,2)
	self.Items[238] = math.random(0,1)
	self.Items[239] = math.random(0,2)
	self.Items[240] = math.random(0,1)
	
	self.LootedPlayers = {}
	
	setTimer(
		function()
			destroyElement(self)
		end
	, 900000, 1)
	
	for k,v in pairs(Factions) do
		if (v.Type == 1) or (v.Type == 2) then
			v:sendMessage("Ein Versorgungshelikopter ist abgestürzt! Zone: "..getElementZoneName(self), 255, 0 ,0)
		end
	end
	
	setElementFrozen(self, true)
	setVehicleLocked(self, true)
	setElementHealth(self, 400)
	setVehicleDamageProof(self, true)
	
	addEventHandler("onElementClicked", self, bind(CCrashedHeli.onClick, self))
end

function CCrashedHeli:destructor()
end

function CCrashedHeli:onClick(mouseButton, buttonState, playerWhoClicked)
	if (mouseButton == "left") and (buttonState == "down") then
		if not(self.LootedPlayers[getPlayerName(playerWhoClicked)]) then
			if (getDistanceBetweenElements3D(playerWhoClicked, self) < 6) then
				if (not isPedInVehicle(playerWhoClicked)) then
					if (playerWhoClicked:getFaction():getType() == 1) then
						--Good Faction -> Secure
						self.LootedPlayers[getPlayerName(playerWhoClicked)] = true
						local ggn = 0
						for k,v in pairs(self.Items) do
							if (v > 0) then
								local count = math.random(0,1)
								if (count == 1) then
									self.Items[k] = self.Items[k] -count
									ggn = ggn+1
								end
							end
						end
						if (ggn > 0) then
							playerWhoClicked:showInfoBox("info", "Gegenstände gesichert! Du erhälst "..tostring(ggn*100).."$")
							playerWhoClicked:addMoney(ggn*100)
						else
							playerWhoClicked:showInfoBox("info", "Du konntest nichts sichern!")
						end
					end
					if (playerWhoClicked:getFaction():getType() == 2) then
						--Bad Faction -> Loot
						self.LootedPlayers[getPlayerName(playerWhoClicked)] = true
						local ggn = 0
						for k,v in pairs(self.Items) do
							if (v > 0) then
								local count = math.random(0,1)
								if (count == 1) then
									self.Items[k] = self.Items[k] -count
									playerWhoClicked:getInventory():addItem(Items[k], 1)
									playerWhoClicked:refreshInventory()
									ggn = ggn+1
								end
							end
						end

						local playerDone	= {}
						for k,v in ipairs(getElementsByType("player")) do
							if (getElementData(v, "online") and v.Fraktion:getType() == 1) then
								if (getDistanceBetweenElements3D(v, playerWhoClicked) <  12) then
									if not(playerDone[playerWhoClicked]) then
										playerDone[playerWhoClicked] = true
										CFaction:sendTypeMessage(1, "Der Spieler "..getPlayerName(playerWhoClicked).." wurde beim Ausrauben eines Versorgungshelikopters erwischt.", 0,120,0)
										playerWhoClicked:setWanteds(playerWhoClicked:getWanteds()+3)
									end
								end
							end
						end
						
						if (ggn > 0) then
							playerWhoClicked:showInfoBox("info", "Gegenstände geplündert! Schnell weg!")
						else
							playerWhoClicked:showInfoBox("info", "Du konntest nichts plündern!")
						end
					end
				else
					playerWhoClicked:showInfoBox("error", "Dafür muss du dein Fahrzeug verlassen!")
				end
			else
				playerWhoClicked:showInfoBox("error", "Du bist zu weit entfernt!")
			end
		else
			playerWhoClicked:showInfoBox("error", "Dort gibt es nichts mehr zu holen!")
		end
	end
end