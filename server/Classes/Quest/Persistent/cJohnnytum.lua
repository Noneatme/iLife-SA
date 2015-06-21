--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CJohnnytum = {}

function CJohnnytum:constructor()
	self.MapDimension = 25000
	
	--Marker(in)
	self.InMarker = createMarker(2253.9453125, -1333.234375, 24, "corona", 2, 255, 255, 0,255, getRootElement())

	addEventHandler("onMarkerHit", self.InMarker,
		function(hitElement, match)
			if (match and  (getElementType(hitElement) == "player" )) then
				if (isPedInVehicle(hitElement)) then
					return false
				end
				if (hitElement:isQuestFinished(Quests[18])) then
					hitElement:fadeInPosition(2250.3999, -1331, 24, 25000, 0)
				else
					hitElement:showInfoBox("error", "Zutritt nur für Mitglieder des Johnnytums (Level 2+)!")
				end
			end
		end
	)
	
	--Marker(out)
	self.OutMarker = createMarker(2252.5, -1330.9, 24, "corona", 2, 255, 255, 0, 255, getRootElement())
	setElementDimension(self.OutMarker, 25000)
	
	addEventHandler("onMarkerHit", self.OutMarker,
		function(hitElement, match)
			if (match and  (getElementType(hitElement) == "player" )) then
				if (isPedInVehicle(hitElement)) then
					return false
				end
				hitElement:fadeInPosition(2257.8193359375, -1333.45703125, 24, 0, 0, 270)
			end
		end
	)
	
	
	--CavePed(in)
	self.CavePedIn = createPed(247, 2235.8999, -1331.2, 24, 270, false)
	setElementDimension(self.CavePedIn, 25000)
	setElementFrozen(self.CavePedIn, true)
	
	addEventHandler("onElementClicked", self.CavePedIn,
		function( button, state, thePlayer)
			if (button ~= "left" or state ~= "down") then
				return false
			end
			if (thePlayer:isQuestFinished(Quests[19])) then
				thePlayer:fadeInPosition(5124.12109375, -2801.6201171875, 66.334378051758, 25000, 0, 90)
			else
				outputChatBox("Türsteher: Zutritt erst ab Level 3!", thePlayer, 255,255,255, false)
			end
		end
	)
	
	--CavePed(out)
	self.CavePedOut = createPed(247, 5127.2002, -2801.6001, 66, 90, false)
	setElementDimension(self.CavePedOut, 25000)
	setElementFrozen(self.CavePedOut, true)
	
	addEventHandler("onElementClicked", self.CavePedOut,
		function( button, state, thePlayer)
			if (button ~= "left" or state ~= "down") then
				return false
			end
			thePlayer:fadeInPosition(2238.2, -1331.1, 24, 25000, 0, 270)
		end
	)
	
	--SektenPeds(static)
	self.Whore1 = createPed(237, 5141, -2857.3999, 85, 0, false)
	self.Whore2 = createPed(237, 5156, -2852.7, 85, 0, false)
	setElementDimension(self.Whore1, 25000)
	setElementDimension(self.Whore2, 25000)
	
	setPedAnimation(self.Whore1, "DANCING", "dance_loop", -1, true, false, false, false)
	setPedAnimation(self.Whore2, "DANCING", "dance_loop", -1, true, false, false, false)
end

function CJohnnytum:destructor()

end