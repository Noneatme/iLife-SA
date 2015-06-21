--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onBriefcaseCarHit", true)

CBriefcaseRace = {}

function CBriefcaseRace:constructor(Faction1, Faction2, neededTickets, caseHolder, endFunc)
	--Robber
	self.Faction1 = Faction1
	
	--Defenser
	self.Faction2 = Faction2
	
	self.Tickets = 0
	self.neededTickets = neededTickets
	
	self.onEndFunction = endFunc
	
	self.eOnMarkerHit = bind(CBriefcaseRace.onMarkerHit, self)
	
	self:createNewMarker()
	
	self:changeCaseHolder(caseHolder)
	
	self.LastTook = getTickCount()
	
	self.eOnBriefCaseCarHit = bind(CBriefcaseRace.onBriefCaseCarHit, self)
	addEventHandler("onBriefcaseCarHit", getRootElement(), self.eOnBriefCaseCarHit)
	
	self.eOnPlayerDamage = bind(CBriefcaseRace.playerDamage, self)
	addEventHandler("onPlayerDamage", getRootElement(), self.eOnPlayerDamage)
	
	self.eOnPlayerWasted = bind(CBriefcaseRace.playerWasted, self)
	addEventHandler("onPlayerWasted", getRootElement(), self.eOnPlayerWasted)
	
	self.eOnPlayerDC = bind(CBriefcaseRace.playerDC, self)
	addEventHandler("onPlayerQuit", getRootElement(), self.eOnPlayerDC)
	
	self.eOnVehicleStartEnter = bind(CBriefcaseRace.vehicleStartExit, self)
	addEventHandler("onVehicleStartEnter", getRootElement(), self.eOnVehicleStartEnter)
end

function CBriefcaseRace:destructor()
	self:cleanUp()
end

function CBriefcaseRace:onBriefCaseCarHit()
	if (self.CaseHolder) and (client ~= self.CaseHolder) then
		if (getPedOccupiedVehicleSeat(client) == 0) then
			if (client:getFaction() ~= self.CaseHolder:getFaction()) then
				if (client:getFaction() == self.Faction1) or (client:getFaction() == self.Faction2) then
					if ( (getTickCount()-self.LastTook) > 3000) then
						self.LastTook = getTickCount()
						self:changeCaseHolder(client)
					end
				end
			end
		end
	end
end

function CBriefcaseRace:createNewMarker()
	--Faction 1
	if (self.CurrentMarker1 and isElement(self.CurrentMarker1)) then
		removeEventHandler("onMarkerHit", self.CurrentMarker1, self.eOnMarkerHit)
		destroyElement(self.CurrentMarker1)
		self.CurrentMarker1 = nil
	end
	
	if(self.Faction1) and (self.Faction1:getType() == 1) and (self.Tickets == 0) then
		self.CurrentMarker1 = createMarker(1535.4716796875, -1675.4580078125, 13.06248664856,"corona", 3, 255, 0, 0, 0, getRootElement())
	else
		local x,y,z = self:getRandomFactionPedMarkerPosition()
		self.CurrentMarker1 = createMarker(x, y, z,"corona", 3, 255, 0, 0, 0, getRootElement())
	end
	
	local r,g,b = self.Faction1:getColors()
	
	if (self.Marker1Blip and isElement(self.Marker1Blip)) then
		destroyElement(self.Marker1Blip)
		self.Marker1Blip = nil
	end
	
	self.Marker1Blip = createBlipAttachedTo(self.CurrentMarker1, 0, 3, r, g, b, 255,0,9999, self.CaseHolder)
	setElementVisibleTo(self.Marker1Blip, getRootElement(), false)
	
	addEventHandler("onMarkerHit", self.CurrentMarker1, self.eOnMarkerHit)
		
	-- Faction2
	if (isElement(self.CurrentMarker2)) then
		removeEventHandler("onMarkerHit", self.CurrentMarker2, self.eOnMarkerHit)
		destroyElement(self.CurrentMarker2)
		self.CurrentMarker2 = nil
	end
	
	if (self.Faction2:getType() == 1) and (self.Tickets == 0) then
		self.CurrentMarker2 = createMarker(1535.4716796875, -1675.4580078125, 13.06248664856,"corona", 3, 255, 0, 0, 0, getRootElement())
	else
		local x,y,z = self:getRandomFactionPedMarkerPosition()
		self.CurrentMarker2 = createMarker(x, y, z,"corona", 3, 255, 0, 0, 0, getRootElement())
	end
	
	local r,g,b = self.Faction2:getColors()
	
	if (self.Marker2Blip and isElement(self.Marker2Blip)) then
		destroyElement(self.Marker2Blip)
		self.Marker2Blip = nil
	end
	
	self.Marker2Blip = createBlipAttachedTo(self.CurrentMarker2, 0, 3, r, g, b, 255,0,9999,self.CaseHolder)
	setElementVisibleTo(self.Marker2Blip, getRootElement(), false)
	
	addEventHandler("onMarkerHit", self.CurrentMarker2, self.eOnMarkerHit)

	--Blip Visibility
	for k,v in pairs(self.Faction1:getOnlinePlayers()) do
		setElementVisibleTo(self.Marker1Blip, v, true)
		setElementVisibleTo(self.Marker2Blip, v, true)
	end
	
	for k,v in pairs(self.Faction2:getOnlinePlayers()) do
		setElementVisibleTo(self.Marker1Blip, v, true)
		setElementVisibleTo(self.Marker2Blip, v, true)
	end
end

function CBriefcaseRace:onMarkerHit(theElement, match)
	if not(match) then
		return false
	end

	local thePlayer = false
	if ( getElementType(theElement) == "vehicle") then
		for k,v in ipairs(getVehicleOccupants(theElement)) do
			if (v == self.CaseHolder) then
				thePlayer = v
			end
		end
	end
	
	if not(thePlayer) then
		if  (getElementType(theElement) == "player") then
			if (theElement == self.CaseHolder) then
				thePlayer = theElement
			end
		end
	end
	
	if (not thePlayer) then
		return false
	end
	
	if (thePlayer:getFaction() == self.Faction1) then
		if (source == self.CurrentMarker1) then
			self.CaseHolder:showInfoBox("info", "Du hast einen Teil der Beute abgegeben!")
			triggerClientEvent(self.CaseHolder, "onServerPlaySavedSound", getRootElement(), "res/sounds/wow/quest_finished.mp3", "Briefcase_Race_Point", false)
			self.Tickets = self.Tickets + math.random(200,334)
			if (self.Tickets >= 1000) then
				self.Tickets = 1000
				self:teamWon(self.Faction1)
			else
				self:createNewMarker()
			end
		end
	elseif (thePlayer:getFaction() == self.Faction2) then
		if (source == self.CurrentMarker2) then
			self.CaseHolder:showInfoBox("info", "Du hast einen Teil der Beute zurückerlangt!")
			triggerClientEvent(self.CaseHolder, "onServerPlaySavedSound", getRootElement(), "res/sounds/wow/quest_finished.mp3", "Briefcase_Race_Point", false)
			if (self.Tickets <= 0) then
				self.Tickets = 0
				self:teamWon(self.Faction2)
			else
				self.Tickets = self.Tickets - math.random(200,334)
				if (self.Tickets <= 0) then
					self.Tickets = 0
				end
				self:createNewMarker()
			end
		end
	end
end

function CBriefcaseRace:getRandomFactionPedMarkerPosition()
	local choose = 1
	
	repeat
		choose = math.random(1, table.size(FactionPeds))
	until FactionPeds[choose]
	
	return getElementPosition(FactionPeds[choose])
end

function CBriefcaseRace:teamWon(theFaction)
	self.onEndFunction(theFaction)
end

function CBriefcaseRace:changeCaseHolder(newHolder)
	if (self.CaseHolder and isElement(self.CaseHolder)) then
		setElementData(self.CaseHolder, "CaseHolder", nil)
		self.CaseHolder:showInfoBox("info", "Dir wurde die Beute abgenommen!")
		triggerClientEvent(self.CaseHolder, "onServerPlaySavedSound", getRootElement(), "res/sounds/wow/quest_abort.ogg", "Briefcase_Race_Fail", false)
	end

	if(isElement(self.CaseHolder)) then
		self.Faction1:sendMessage(getPlayerName(self.CaseHolder).." besitzt nun die Beute!")
		self.Faction2:sendMessage(getPlayerName(self.CaseHolder).." besitzt nun die Beute!")
	end
	
	self.CaseHolder = newHolder
	setElementData(self.CaseHolder, "CaseHolder", true)

	self.CaseHolder:showInfoBox("info", "Du hast die Beute erobert!")
	triggerClientEvent(self.CaseHolder, "onServerPlaySavedSound", getRootElement(), "res/sounds/wow/quest_accept.mp3", "Briefcase_Race_Success", false)

	
	if (self.HolderBlip and isElement(self.HolderBlip)) then
		destroyElement(self.HolderBlip)
		self.HolderBlip = nil
	end
	
	self.HolderBlip = createBlipAttachedTo(self.CaseHolder, 0, 3, 255, 0, 0, 255, 0, 9999, self.CaseHolder)
	
	for k,v in pairs(self.Faction1:getOnlinePlayers()) do
		setElementVisibleTo(self.HolderBlip, v, true)
	end
	
	for k,v in pairs(self.Faction2:getOnlinePlayers()) do
		setElementVisibleTo(self.HolderBlip, v, true)
	end

end

function CBriefcaseRace:cleanUp()
	removeEventHandler("onBriefcaseCarHit", getRootElement(), self.eOnBriefCaseCarHit)
	removeEventHandler("onPlayerWasted", getRootElement(), self.eOnPlayerWasted)
	removeEventHandler("onPlayerQuit", getRootElement(), self.eOnPlayerDC)
	removeEventHandler("onPlayerDamage", getRootElement(), self.eOnPlayerDamage)
	
	if (self.Pickup and isElement(self.Pickup)) then
		destroyElement(self.Pickup)
	end
	
	self.CaseHolder = nil
	
	if (self.HolderBlip and isElement(self.HolderBlip)) then
		destroyElement(self.HolderBlip)
		self.HolderBlip = nil
	end
	
	if (self.CurrentMarker1 and isElement(self.CurrentMarker1)) then
		removeEventHandler("onMarkerHit", self.CurrentMarker1, self.eOnMarkerHit)
		destroyElement(self.CurrentMarker1)
		self.CurrentMarker1 = nil
	end
	
	if (self.Marker1Blip and isElement(self.Marker1Blip)) then
		destroyElement(self.Marker1Blip)
		self.Marker1Blip = nil
	end
	
	
	if (isElement(self.CurrentMarker2)) then
		removeEventHandler("onMarkerHit", self.CurrentMarker2, self.eOnMarkerHit)
		destroyElement(self.CurrentMarker2)
		self.CurrentMarker2 = nil
	end

	if (self.Marker2Blip and isElement(self.Marker2Blip)) then
		destroyElement(self.Marker2Blip)
		self.Marker2Blip = nil
	end
end

function CBriefcaseRace:playerDC()
	if (source == self.CaseHolder) then
		local x,y,z = getElementPosition(source)
		self.Pickup = createPickup(x, y, z, 3, 1274, 2000)
		setElementData(self.CaseHolder, "CaseHolder", nil)
		self.CaseHolder = false
		addEventHandler("onPickupHit", self.Pickup, bind(CBriefcaseRace.pickupHit, self))
	end
end

function CBriefcaseRace:playerWasted()
	if (source == self.CaseHolder) then
		local x,y,z = getElementPosition(source)
		self.Pickup = createPickup(x, y, z, 3, 1274, 2000)
		setElementData(self.CaseHolder, "CaseHolder", nil)
		self.CaseHolder = false
		addEventHandler("onPickupHit", self.Pickup, bind(CBriefcaseRace.pickupHit, self))
	end
end

function CBriefcaseRace:playerDamage(attacker,attackerweapon)
	if (source == self.CaseHolder) then
		if(self.CaseHolder) and (attacker and isElement(attacker) and attacker:getFaction() ~= self.CaseHolder:getFaction()) then
			if (attacker:getFaction() == self.Faction1) or (attacker:getFaction() == self.Faction2) then
				if (attackerweapon == 0) then
					if ( (getTickCount()-self.LastTook) > 3000) then
						self.LastTook = getTickCount()
						self:changeCaseHolder(attacker)
					end
				end
			end
		end
	end
end
		
function CBriefcaseRace:pickupHit(thePlayer)
	if (thePlayer:getFaction() == self.Faction1) or (thePlayer:getFaction() == self.Faction2) then
		destroyElement(source)
		self:changeCaseHolder(thePlayer)
	end
end

function CBriefcaseRace:vehicleStartExit(enteringPlayer, seat, jacked, door)
	if (enteringPlayer == self.CaseHolder) then
		if (getVehicleType(source) == "Helicopter") or (getVehicleType(source) == "Plane") then
			enteringPlayer:showInfoBox("error", "Die Beute kann nicht über die Luft verteilt werden!")
			cancelEvent()
		end
	end
end