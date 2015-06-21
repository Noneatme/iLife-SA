--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CRestaurant = inherit(CShop)

function CRestaurant:constructor(dim)
	self.Dim = dim

	self.Ped = createPed ( 46, -783.1181640625, 498.3212890625, 1371.7421875, 0, false)
	setElementInterior(self.Ped, 1)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Marker = ItemShops[3].addMarker(ItemShops[3], 1, dim, -783.4208984375,500.0732421875,1371.7421875)

	self.ID = dim-20000
	CShop.constructor(self, "Restaurant", self.ID)
end

function CRestaurant:destructor()

end
