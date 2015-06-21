--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

GangAreas = {}

GangwarUnderAttack = false

CGangArea = {}

function CGangArea:constructor(iID, sName, tColShapes, iFactionID, iLastAttacked, bUseable, iIncome)
	self.ID = iID
	self.Name = sName
	self.ColShapes = {}
	self.RadarAreas = {}
	self.DimRadarAreas = {}
	self.Faction = Factions[iFactionID]
	self.LastAttacked = iLastAttacked
	self.Useable = bUseable
	self.Income = iIncome
	
	for k,v in pairs(tColShapes) do
		if (self.Useable ~= 0) then
			table.insert(self.ColShapes, createColCuboid(v["X"], v["Y"], v["Z"], v["W"], v["H"], v["D"]))
			local r,g,b = self.Faction:getColors()
			table.insert(self.RadarAreas, createRadarArea(v["X"], v["Y"], v["W"], v["H"], r, g, b, 70, getRootElement()))
			table.insert(self.DimRadarAreas, createRadarArea(v["X"], v["Y"], v["W"], v["H"], r, g, b, 0, getRootElement()))
		end
	end
	
	for k,v in pairs(self.ColShapes) do
		setElementDimension(v, 60000)
		addEventHandler("onColShapeHit", v, bind(CGangArea.onColShapeHit, self))
		addEventHandler("onColShapeLeave", v, bind(CGangArea.onColShapeLeave, self))
	end
	
	self.isUnderAttack = false

	self.Peds = {}
	
	self.Attacker = nil
	self.endTimer = nil

	self.CapturePoints = {}
	
	self.ActiveDefender = {}
	self.ActiveAttacker = {}

	self.StartDefender = {}
	self.StartAttacker = {}

	self.PreLeaveTimers = {}
	self.LeaveTimers = {}
	
	self.CountAttacker = 0
	self.CountDefender = 0

	self.TicketsAttacker = 2000
	self.TicketsDefender = 2000
	
	self.LastTick = getTickCount()
	
	GangAreas[self.Name] = self
end

function CGangArea:destructor()

end

function CGangArea:addPed(thePed)
	table.insert(self.Peds, thePed)
end

function CGangArea:onColShapeHit(hitElement, matchingDimension)
	if (self.isUnderAttack) then
		if (getElementType(hitElement) == "player") then
			if (matchingDimension) then
				--returned to gw?
				local vehicle = false
				if (isPedInVehicle(hitElement)) then
					vehicle = getPedOccupiedVehicle(hitElement)
				end
				if (self.PreLeaveTimers[hitElement:getName()] and isTimer(self.PreLeaveTimers[hitElement:getName()])) then
					killTimer(self.PreLeaveTimers[hitElement:getName()])
				end
				if (self.LeaveTimers[hitElement:getName()] and isTimer(self.LeaveTimers[hitElement:getName()])) then
					killTimer(self.LeaveTimers[hitElement:getName()])
				end
			else
				-- new to gw?
				local vehicle = false
				if (isPedInVehicle(hitElement)) then
					vehicle = getPedOccupiedVehicle(hitElement)
				end
				
				if (self.ActiveDefender[hitElement:getName()]) then
					setElementDimension(hitElement, 60000)
					if (vehicle) then
						setElementDimension(vehicle, 60000)
					end
					hitElement:incrementStatistics("GangWar", "GangWars_betreten", 1)
				end
				
			end
		end
	end
end

function CGangArea:onColShapeLeave(leaveElement, matchingDimension)
	if (self.isUnderAttack) then
		if (getElementType(leaveElement) == "player") then
			if (matchingDimension) then
				--left or died?
				local vehicle = false
				if (isPedInVehicle(leaveElement)) then
					vehicle = getPedOccupiedVehicle(leaveElement)
				end
				self.PreLeaveTimers[leaveElement:getName()] = setTimer(
					function() 
						if (getElementDimension(leaveElement) == 60000) then
							-- Give him a chance to return!
							if (getElementZoneName(leaveElement) == self.Name) then
								return false
							end
							outputChatBox("Du hast 10 Sekunden Zeit um das Gebiet erneut zu betreten!", leaveElement, 255,0,0)
							self.LeaveTimers[leaveElement:getName()] = setTimer(
								function()
									if (getElementZoneName(leaveElement) == self.Name) then
										return false
									end
									setElementDimension(leaveElement, 0)
									if (vehicle) then
										setElementDimension(vehicle, 0)
									end
									self.ActiveDefender[leaveElement:getName()] = nil
									self.ActiveAttacker[leaveElement:getName()] = nil
									outputChatBox("Du hast die Schlacht verlassen! Schäme dich!", leaveElement, 255,0,0)
								end
							, 10000, 1)
						end
					end
				, 1000, 1)
			else
				-- Died
				self.ActiveDefender[leaveElement:getName()] = nil
				self.ActiveAttacker[leaveElement:getName()] = nil
			end
		end
	end
end


function CGangArea:startGangWar(thePlayer)
	
	if (GangwarUnderAttack) then
		thePlayer:showInfoBox("error", "Es wird bereits ein Gebiet umkämpft!")
		return false
	end
	
	if ( (thePlayer:getFaction():getType() == 2) and (self.Faction ~= thePlayer:getFaction())) then
		if (thePlayer:getRank() >= 4) then
			GangwarUnderAttack = true
			self.isUnderAttack = true
			self.Attacker = thePlayer:getFaction()
		else
			thePlayer:showInfoBox("error", "Dafür benötigst du mindestens Rang 4!")
			return false
		end
	else
		return false
	end

	for  k,v in ipairs(getElementsByType("pickup")) do
		if (getElementData(v, "h:iFactionID") and getElementData(v, "h:iFactionID") ~= 0) then
			if (getElementZoneName(v) == getElementZoneName(thePlayer)) then
				thePlayer:showInfoBox("error", "Dieses Gebiet ist ein Hauptquartier!")
				GangwarUnderAttack = false
				return false
			end
		end
	end
	
	for k,v in ipairs(getElementsByType("player")) do
		if (getElementData(v, "online")) and (v:getFaction() == self.Faction) then
			self.ActiveDefender[v:getName()] = true
			table.insert(self.StartDefender, v)
		end
	end

	for  k,v in ipairs(self:getElementsIn("player")) do
		if (getElementData(v, "online")) and (v:getFaction() == self.Attacker) then
			self.ActiveAttacker[v:getName()] = true
			table.insert(self.StartAttacker, v)
			if (getElementDimension(v) == 0) then
				setElementDimension(v, 60000)
			end
			v:incrementStatistics("GangWar", "GangWars_betreten", 1)
		end
		if (v:getFaction() == self.Faction) then
			self.ActiveDefender[v:getName()] = true
			if (getElementDimension(v) == 0) then
				setElementDimension(v, 60000)
			end
			v:incrementStatistics("GangWar", "GangWars_betreten", 1)
		end
	end

	for  k,v in ipairs(self:getElementsIn("vehicle")) do
		if (getElementData(v, "Fraktion") and  (getElementData(v, "Fraktion") == thePlayer:getFaction():getID())) then
			setElementDimension(v, 60000)
		end
	end

	self.CountAttacker = #self.StartAttacker
	self.CountDefender = #self.StartDefender

	local minAttacker	= 3

	if (self.CountAttacker < minAttacker) then
		thePlayer:showInfoBox("error", "Es werden mindestens "..minAttacker.." Angreifer benötigt!")
		self:reset()
		return false
	end

	if (self.CountAttacker > self.CountDefender) then
		thePlayer:showInfoBox("error", "Es müssen weniger Angreifer als Verteidiger teilnehmen!")
		self:reset()
		return false
	end
	
	local time = getRealTime()

	if ((self.LastAttacked +(60*60*24)) > time["timestamp"]) then
		thePlayer:showInfoBox("error", "Dieses Gebiet wurde heute bereits umkämpft!")
		self:reset()
		return false
	end

	self.LastAttacked = time["timestamp"]

	for  k,v in ipairs(self.Peds) do
		local x,y,z = getElementPosition(v)
		local rx,ry,rz = getElementRotation(v)
		table.insert(self.CapturePoints, new(CCapturePoint, createPed(getElementModel(v), x,y,z, rz, true), createMarker(x,y,z-1, "cylinder", 6, 125, 0, 0, 50, getRootElement()), self.Faction, self.Attacker))
	end
	
	self.Timer = setTimer(
	function()
		if (getTickCount()-self.LastTick > 5000) and (getTickCount()-self.AttackStamp > 180000) then
			for k,v in ipairs(self.CapturePoints) do
				v:update()
				if (v:getPoints() <= 0) then
					self.TicketsAttacker = self.TicketsAttacker - ((1*(math.abs(v:getPoints())/100))*5/#self.CapturePoints)
				else
					self.TicketsDefender = self.TicketsDefender - ((1*(math.abs(v:getPoints())/100))*5/#self.CapturePoints)
				end
				if (self.TicketsAttacker <= 0) or (self.TicketsDefender <= 0) then
					self:finish(self.TicketsAttacker > 0)
					return true
				end
			end
			RPCCall("updateGangWarRenderer", self.TicketsDefender,  self.TicketsAttacker)
		else
			for k,v in ipairs(self.CapturePoints) do
				v:update()
			end
		end
	end,
	1500, 0)
	
	for k,v in ipairs(self.RadarAreas) do
		setRadarAreaColor(v, 255, 0 ,0 ,125)
		setRadarAreaFlashing(v, true)
	end
	
	for k,v in ipairs(self.DimRadarAreas) do
		setElementDimension(v, 60000)
		setRadarAreaColor(v, 255, 0 ,0 ,125)
		setRadarAreaFlashing(v, true)
	end

	self.AttackStamp = getTickCount()
	
	local tblMarkers = {}
	for k,v in ipairs(self.CapturePoints) do
		table.insert(tblMarkers, v.Marker)
	end
	RPCCall("initializeGangWarRenderer", self.Faction:getName(), self.Attacker:getName(), tblMarkers)
	
	self.Faction:sendMessage("Ein Ganggebiet ("..self.Name..") wird angegriffen!")
	self.Attacker:sendMessage("Ihr habt ein Ganggebiet ("..self.Name..") angegriffen!")
end

function CGangArea:finish(bSuccess)
	if (bSuccess) then
		self.Faction:sendMessage("Ein Ganggebiet ("..self.Name..") wurde verloren!")
		self.Attacker:sendMessage("Ihr habt ein Ganggebiet ("..self.Name..") erobert!")
		self.Faction = self.Attacker
		self.Income = 200
		for  k,v in ipairs(self.Peds) do
			setElementModel(v, self.Faction:getRankSkin(math.random(1,4)))
		end
		
		for k,v in ipairs(self.StartAttacker) do
			if ((v) and (getElementType(v) == player)) then
				v:incrementStatistics("GangWar", "GangWars_gewonnen", 1)
			end
		end
	else
		self.Faction:sendMessage("Ein Ganggebiet ("..self.Name..") wurde verteidigt!")
		self.Attacker:sendMessage("Ihr habt es nicht geschafft ein Ganggebiet ("..self.Name..") zu erobern!")
		for k,v in ipairs(self.StartDefender) do
			if ((v) and (getElementType(v) == player)) then
				v:incrementStatistics("GangWar", "GangWars_gewonnen", 1)
			end
		end
	end
	RPCCall("finshGangWarRenderer", self.Faction:getName())
	self:save()	
	self:reset()
end

function CGangArea:reset()

	for  k,v in ipairs(self:getElementsIn("player")) do
		if (getElementDimension(v) == 60000) then
			setElementDimension(v, 0)
		end
	end
	for  k,v in ipairs(self:getElementsIn("vehicle")) do
		if (getElementDimension(v) == 60000) then
			setElementDimension(v, 0)
		end
	end

	self.isUnderAttack = false

	self.Attacker = nil

	if (isTimer(self.Timer)) then
		killTimer(self.Timer)
	end

	self.Timer = nil

	self.ActiveDefender = {}
	self.ActiveAttacker = {}

	self.StartDefender = {}
	self.StartAttacker = {}

	self.CountAttacker = 0
	self.CountDefender = 0
	
	self.TicketsAttacker = 2000
	self.TicketsDefender = 2000
	
	local r,g,b = self.Faction:getColors()
	
	for k,v in ipairs(self.RadarAreas) do
		setRadarAreaColor(v, r, g ,b ,70)
		setRadarAreaFlashing(v, false)
	end
	
	for k,v in ipairs(self.DimRadarAreas) do
		setRadarAreaColor(v, 255, 0 ,0 ,0)
		setRadarAreaFlashing(v, false)
	end
	
	for k,v in ipairs(self.CapturePoints) do
		delete(v)
	end
	
	GangwarUnderAttack = false
end

function CGangArea:save()
	CDatabase:getInstance():query("UPDATE Gangareas SET FactionID=?, LastAttacked=?, Income=? WHERE ID=?", self.Faction:getID(), self.LastAttacked, self.Income, self.ID)
end

function CGangArea:getFaction()
	return self.Faction
end

function CGangArea:setIncome(iAmount)
	self.Income = iAmount
end

function CGangArea:getIncome()
	return self.Income
end

function CGangArea:getElementsIn(typ)
	local tabk = {}
	local tab = {}
	
	for k,v in ipairs(self.ColShapes) do
		for kk,vv in ipairs(getElementsWithinColShape(v, typ)) do
			tabk[vv] = true
		end
	end
	
	for k,v in pairs(tabk) do
		table.insert(tab, k)
	end
	
	return tab
end

function CGangArea:isElementIn(element)
	for k,v in ipairs(self.ColShapes) do
		if isElementWithinColShape(element, v) then
			return true
		end
	end
	return false
end


addEvent("onGangwarStartConfirm", true)
addEventHandler("onGangwarStartConfirm", getRootElement(),
function()
	local x,y,z = getElementPosition(client)
	if (type(GangAreas[getZoneName(x,y,z,false)]) == "table") then
		GangAreas[getZoneName(x,y,z,false)]:startGangWar(client)
	end
end)

--[[
addCommandHandler("markarea", function(player, cmd, t)
	local zone = getElementZoneName(player)
	if (GangAreas[zone]) then
		if (tonumber(t) == 1) then
			for k,v in ipairs(GangAreas[zone].RadarAreas) do
				setRadarAreaColor(v, 255,0,0,120)
			end	
		else
			for k,v in ipairs(GangAreas[zone].RadarAreas) do
				local r,g,b = GangAreas[zone].Faction:getColors()
				setRadarAreaColor(v, r,g,b,70)
			end	
		end
	end
 end)
]]
--[[
addCommandHandler("enablega", 
	function(pl, cmd) 
		local x,y,z = getElementPosition(pl)
		local zonename = getZoneName(x,y,z, false)
		CDatabase:getInstance():query("UPDATE Gangareas SET Useable='1' WHERE Name=?", zonename)
	end
)]]

--[[
addCommandHandler("rand", 
	function(pl, cmd) 
		for k,v in pairs(GangAreas) do
			CDatabase:getInstance():query("UPDATE Gangareas SET FactionID = ? WHERE ID=? ", math.random(3,5), v.ID)
		end
	end
)
]]

--[[
- 

]]