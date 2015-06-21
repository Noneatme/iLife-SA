--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Trashcans = {}

CTrashcan = {}

function CTrashcan:constructor(iID, sPos)
	self.ID = iID
	self.Pos = sPos

	self.LastClicked = 0
	self.userClicked = {};

	self.eOnClicked = bind(self.onClicked, self)
	addEventHandler("onElementClicked", self, self.eOnClicked)

	Trashcans[self.ID] = self
end

function CTrashcan:destructor()

end

function CTrashcan:onClicked(button, state, thePlayer)
	if (button == "left" and state == "down") then

		local x,y,z = getElementPosition(self)
		local px,py,pz = getElementPosition(thePlayer)
		if (getDistanceBetweenPoints3D(x,y,z,px,py,pz) > 1.5) then
			thePlayer:showInfoBox("info", "Du bist zu weit entfernt!")
			return false
		end
		if(self.userClicked[thePlayer] == true) then
			return;
		end
		thePlayer:setLoading(true);

		self.userClicked[thePlayer] = true;
		setTimer(function() self.userClicked[thePlayer] = false end, 2000, 1);

		local rotation = self:FindRotation(x, y, px, py);
		setElementRotation(thePlayer, 0, 0, rotation+180);

		setPedAnimation(thePlayer, "shop", "ROB_Shifty", -1, true, false, false)

		setTimer(function()
			setPedAnimation(thePlayer);
			thePlayer:setLoading(false);
			if (not(self.LastClicked+600 > getTimestamp())) then
				Achievements[16]:playerAchieved(thePlayer)
				local rand = math.random(1,10000)
				if (rand <= 3333) then
					thePlayer:showInfoBox("info", "Hier befindet sich nichts wertvolles!")
				else
					if (rand <= 6666) then
						thePlayer:getInventory():addItem(Items[2],1)
						thePlayer:showInfoBox("info", "Du hast eine Pfandflasche gefunden!")
						thePlayer:incrementStatistics("Items", "Pfandflaschen_gefunden", 1)
					else
						if (rand <= 8500) then
							thePlayer:getInventory():addItem(Items[2],2)
							thePlayer:showInfoBox("info", "Du hast zwei Pfandflaschen gefunden!")
							thePlayer:incrementStatistics("Items", "Pfandflaschen_gefunden", 2)
						else
							if (rand <= 8750) then
								thePlayer:getInventory():addItem(Items[185],1)
								thePlayer:showInfoBox("info", "Du hast einen Kaktus gefunden!")
							else
								if (rand <= 9000) then
									thePlayer:getInventory():addItem(Items[2],3)
									thePlayer:showInfoBox("info", "Du hast drei Pfandflaschen gefunden!")
									thePlayer:incrementStatistics("Items", "Pfandflaschen_gefunden", 3)
								else
									if (rand <= 9100) then
										thePlayer:getInventory():addItem(Items[9],1)
										thePlayer:showInfoBox("info", "Du hast einen Gramm Meth gefunden!")
									else
										if (rand <= 9200) then
											thePlayer:getInventory():addItem(Items[14],1)
											thePlayer:showInfoBox("info", "Du hast einen Gramm Kokain gefunden!")
										else
											if (rand <= 9300) then
												thePlayer:getInventory():addItem(Items[10],2)
												thePlayer:showInfoBox("info", "Du hast zwei Gramm Cannabis gefunden!")
											else
												if (rand <= 9500) then
													thePlayer:getInventory():addItem(Items[18],1)
													thePlayer:showInfoBox("info", "Du hast einen Doominator gefunden!")
												else
													if (rand <= 9700) then
														thePlayer:getInventory():addItem(Items[17],1)
														thePlayer:showInfoBox("info", "Du hast einen alten Hamburger gefunden!")
													else
														if (rand <= 9750) then
															thePlayer:getInventory():addItem(Items[41],1)
															thePlayer:showInfoBox("info", "Du hast einen Gewinnmünze gefunden!")
														else
															if (rand <= 9800) then
																thePlayer:getInventory():addItem(Items[4],1)
																thePlayer:showInfoBox("info", "Du hast einen alten Donut gefunden!")
															else
																if (rand <= 9990) then
																thePlayer:getInventory():addItem(Items[6],1)
																thePlayer:showInfoBox("info", "Du hast ein Rubbellos gefunden!")
																else
																	if (rand <= 10000) then
																		thePlayer:getInventory():addItem(Items[10],15)
																		thePlayer:getInventory():addItem(Items[11],15)
																		thePlayer:getInventory():addItem(Items[12],15)
																		thePlayer:getInventory():addItem(Items[14],7)
																		thePlayer:showInfoBox("info", "Du hast ein Paket mit einer Menge Drogen gefunden!")
																		Achievements[78]:playerAchieved(thePlayer)
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				self.LastClicked = getTimestamp()
				thePlayer:refreshInventory()
				if (thePlayer:getStatistics("Items", "Pfandflaschen_gefunden") >= 100) then
					Achievements[11]:playerAchieved(thePlayer)
				end
			else
				thePlayer:showInfoBox("info", "Dieser Mülleimer wurde wohl schon durchsucht!")
			end
		end, 2000, 1)
	end
end

function CTrashcan:FindRotation(x1, y1, x2, y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end;
	return t;
end
