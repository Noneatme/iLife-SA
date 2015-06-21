--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCityDepartment = inherit(CShop)

function CCityDepartment:constructor(dim)
	self.Dim = dim

	self.Ped = createPed(227, 359.7138671875, 173.6025390625, 1008.3893432617, 270, false)
	setElementInterior(self.Ped, 3)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.AdPed = createPed(91, 356.2978515625, 165.93359375, 1008.3762207031, 270, false)
	setElementInterior(self.AdPed, 3)
	setElementDimension(self.AdPed, self.Dim)
	setElementData(self.AdPed, "EastereggPed", true)
	self.AdMarker = ItemShops[8].addMarker(ItemShops[8], 3, dim, 358.2373046875, 165.9853515625, 1008.3828125)


	self.LicenseMarker = ItemShops[2].addMarker(ItemShops[2], 3, dim, 361.8291015625 ,173.6650390625 ,1008.3828125)
	setElementInterior(self.LicenseMarker, 3)
	setElementDimension(self.LicenseMarker, self.Dim)

	self.JobPickup = createPickup(359.634765625, 178.3935546875, 1008.3828125, 3, 1239, 10, 0)
	setElementInterior(self.JobPickup, 3)
	setElementDimension(self.JobPickup, self.Dim)


	self.BonusMarker = ItemShops[24].addMarker(ItemShops[24], 3, dim, 358.537109375, 182.626953125, 1008.3828125)
	self.BonusPed = createPed(227, 356.294921875, 182.556640625, 1008.3762207031, 270, false)
	setElementInterior(self.BonusPed, 3)
	setElementDimension(self.BonusPed, self.Dim)
	setElementData(self.BonusPed, "EastereggPed", true)


	self.eOnJobPickupHit = bind(self.onJobPickupHit, self)
	addEventHandler("onPickupHit", self.JobPickup, self.eOnJobPickupHit)

	self.ID = dim-20000
	CShop.constructor(self, "City Department", self.ID)
end

function CCityDepartment:destructor(dim)

end

function CCityDepartment:onJobPickupHit(thePlayer)
	triggerClientEvent(thePlayer, "onClientJobPickupHit", getRootElement())
end
