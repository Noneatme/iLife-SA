--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CSexshop = inherit(CShop)

function CSexshop:constructor(dim)
	self.Dim = dim

	self.Ped = createPed(178, -104.841796875, -8.9013671875, 1000.71875, 180, false)
	setElementInterior(self.Ped, 3)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Marker = createMarker(-104.794921875, -10.6650390625, 1000.71875, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 3)
	setElementDimension(self.Marker, self.Dim)

	self.eOnMarkerHit = bind(self.onSexshopMarkerHit, self)
	addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

	self.ID = dim-20000
	CShop.constructor(self, "Sexshop", self.ID)
end

function CSexshop:destructor(dim)

end

function CSexshop:onSexshopMarkerHit(hitElement, matchingDimensions)
	if (matchingDimensions) then
		if (getElementType(hitElement) == "player") then
			triggerClientEvent(hitElement, "showSexshopGui", hitElement)
		end
	end
end
