--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCapturePoint = {}

function CCapturePoint:constructor(thePed, theMarker, Defender, Attacker)
	--Ped
	self.Ped = thePed
	setElementDimension(self.Ped, 60000)
	setElementFrozen(self.Ped, true)
	setElementData(self.Ped, "FactionPed", true)
	setElementData(self.Ped, "FactionID", Defender:getID())
	--Marker
	self.Marker = theMarker
	setElementData(self.Marker, "CapturePoint", true)
	setElementData(self.Marker, "Score", 100)
	setElementDimension(self.Marker, getElementDimension(self.Ped))
	--Faction
	self.Defender = Defender
	self.Attacker = Attacker
	
	--Color Things
	self.X,self.Y,self.Z = getElementPosition(self.Ped)
	self.R,self.G,self.B = Defender:getColors()
	setMarkerColor(self.Marker, self.R,self.G,self.B, 15)
	
	--Blip
	self.Blip = createBlip(self.X,self.Y,self.Z, 0, 2, self.R,self.G,self.B,255,0,99999, getRootElement())
	setElementDimension(self.Blip, getElementDimension(self.Ped))
	
	--Score (-100 -> 100)
	self.Score = -100
end

function CCapturePoint:destructor()
	destroyElement(self.Ped)
	destroyElement(self.Marker)
	destroyElement(self.Blip)
end

function CCapturePoint:getMarker()
	return self.Marker
end

function CCapturePoint:getPed()
	return self.Ped
end

function CCapturePoint:getPoints()
	return self.Score
end

function CCapturePoint:update()
	local shape = createColSphere(self.X,self.Y,self.Z, getMarkerSize(self.Marker))
	setElementDimension(shape, 60000)
	for k,v in ipairs(getElementsWithinColShape(shape, "player")) do
		if (getElementDimension(v) == 60000) and (getElementHealth(v) > 0) and (isElementWithinMarker(v, self.Marker)) then
			if ((v:getFaction() == self.Defender) and (self.Score > -100) ) then
				self.Score = self.Score-1
			end
			if ((v:getFaction() == self.Attacker) and (self.Score < 100) ) then
				self.Score = self.Score+1
			end
		end
	end
	
	setElementData(self.Marker, "Score", self.Score)
	
	destroyElement(shape)
	
	local r1,g1,b1 = self.Defender:getColors()
	local r2,g2,b2 = self.Attacker:getColors()
	
	self.R, self.G, self.B = interpolateBetween(r1,g1,b1,r2,g2,b2, (self.Score+100)/ 200, "Linear")
	
	setMarkerColor(self.Marker, self.R,self.G,self.B, 15)
	setBlipColor(self.Blip, self.R,self.G,self.B, 255)
end