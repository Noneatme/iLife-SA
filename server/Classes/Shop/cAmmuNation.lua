--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CAmmuNation = inherit(CShop)

function CAmmuNation:constructor(aType, dim, iFilliale, iChain)
	self.Dim = dim

	self.iFilliale 	= iFilliale;
	self.iChain		= iChain;

	if (aType == 1) then

		self.Ped = createPed(121, 316.1083984375, -133.6748046875, 999.6015625, 90, false)
		setElementInterior(self.Ped, 7)
		setElementDimension(self.Ped, self.Dim)
		setElementData(self.Ped, "EastereggPed", true)
		new(CShopRob, dim, self.Ped)

		self.Marker = createMarker(313.9599609375, -134.23828125, 999.6015625, "corona", 1, 255, 255, 255, 125, getRootElement())
		setElementInterior(self.Marker, 7)
		setElementDimension(self.Marker, self.Dim)

		self.eOnMarkerHit = bind(self.onLicenseMarkerHit, self)
		addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

		self.Ped2 = createPed(121, 308.3349609375, -143.0908203125, 999.6015625, 0, false)
		setElementInterior(self.Ped2, 7)
		setElementDimension(self.Ped2, self.Dim)
		setElementData(self.Ped2, "EastereggPed", true)

		self.Marker2 = createMarker(308.4541015625, -141.00390625, 999.6015625, "corona", 1, 255, 255, 255, 125, getRootElement())
		setElementInterior(self.Marker2, 7)
		setElementDimension(self.Marker2, self.Dim)

		addEventHandler("onMarkerHit", self.Marker2, self.eOnMarkerHit)

		self.Marker3 = createMarker(313, -140, 1004, "corona", 1, 255, 255, 255, 125, getRootElement())
		setElementInterior(self.Marker3, 7)
		setElementDimension(self.Marker3, self.Dim)

		addEventHandler("onMarkerHit", self.Marker3,
			function(hitElement, matching)
				if (matching) then
					if (getElementType(hitElement) == "player" ) then
						if not isPedInVehicle(hitElement) then
							if (hitElement.Fraktion:getType() == 2) then
								triggerClientEvent(hitElement, "onItemShopOpen", hitElement, 23)
							else
								hitElement:showInfoBox("error", "Dies ist nur als Gangmitglied möglich!")
							end
						else
							hitElement:showInfoBox("error", "Steige aus deinem Fahrzeug aus!")
						end
					end
				end
			end
		)


		self.Ped3 = createPed(121, 316.22698974609, -139.07192993164, 1004.0625, 90, false)
		setElementInterior(self.Ped3, 7)
		setElementDimension(self.Ped3, self.Dim)
		setElementData(self.Ped3, "EastereggPed", true)
	end
	self.ID = dim-20000
	CShop.constructor(self, "Ammu Nation", self.ID)

end

function CAmmuNation:destructor(dim)

end

function CAmmuNation:onLicenseMarkerHit(hitElement, matchingDimensions)
	if (matchingDimensions) then
		if (getElementType(hitElement) == "player") then
			if (hitElement:getInventory():hasItem(Items[26], 1)) then
				if (hitElement:getInventory():hasItem(Items[27], 1)) then
					triggerClientEvent(hitElement, "showAmmunationGui", hitElement, self.iFilliale, self.iChain)
				else
					hitElement:showInfoBox("error", "Du benötigst einen kleinen Waffenschein!")
				end
			else
				hitElement:showInfoBox("error", "Du benötigst eine Waffenbesitzkarte!")
			end
		end
	end
end
