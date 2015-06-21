--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CraftingPoints = {}
CCraftingPoint = inherit(CMarker)

CraftingPointRestriction = {
	[1] = function(player) if (player:getFaction():getType() == 2 and player:getRank() > 1 ) then return true else return false end end,
}

function CCraftingPoint:constructor(iID, sName,tblCraftings, iRestriction)
	self.ID = iID
	self.Name = sName
	self.Craftings = {}
	
	for k,v in ipairs(tblCraftings) do
		table.insert(self.Craftings, Craftings[v])
	end
	
	self.Restriction = iRestriction
	
	self.eOnHit = bind(CCraftingPoint.onHit, self)
	addEventHandler("onMarkerHit", self, self.eOnHit)
	
	CraftingPoints[self.ID] = self
end

function CCraftingPoint:destructor()

end

function CCraftingPoint:onHit(hitElement, matching)
	if (matching and getElementType(hitElement) == "player") then
		if (not isPedInVehicle(hitElement)) then
			if ((self.Restriction == 0) or (CraftingPointRestriction[self.Restriction](hitElement))) then
				triggerClientEvent(hitElement, "showCraftingGui", getRootElement(), self.Name, self.Craftings)
			else
				hitElement:showInfoBox("error", "Dazu bist du nicht autorisiert!")
			end
		else
			hitElement:showInfoBox("error", "Dies ist in einem Fahrzeug nicht möglich!")
		end
	end
end