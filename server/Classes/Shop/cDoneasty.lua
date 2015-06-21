--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Doneastys = {}

DoneastyObjects = {}

CDoneasty = inherit(CShop)

function CDoneasty:constructor(iDim)

	self.Dim = iDim
	self.Ped = createPed(219, 1249, -767.09998, 1084, 220)
	setElementInterior(self.Ped, 5)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, iDim, self.Ped)

	self.Objects = {}

	for k,v in pairs(mapManager:getMapRootObjects("res/maps/misc/doneasty.map")) do
		local x,y,z = getElementPosition(v)
		local rx,ry,rz = getElementRotation(v)
		local n = createObject(getElementModel(v), x, y, z, rx, ry, rz)
		setObjectScale(n, getObjectScale(v))
		setElementInterior(n, 5)
		setElementDimension(n, self.Dim)
		table.insert(self.Objects, n)
		table.insert(DoneastyObjects, n)
	end

	self.ShopMarker = ItemShops[9].addMarker(ItemShops[9], 1, self.Dim, 1250.56640625, -768.8662109375, 1084.0146484375)
	setElementInterior(self.ShopMarker, 5)

	self.ID = iDim-20000

	CShop.constructor(self, "Doneasty", self.ID)

	table.insert(Doneastys, self)

end

function CDoneasty:destructor()

end

addEvent("onClientRequestDoneastyObects", true)
addEventHandler("onClientRequestDoneastyObects", getRootElement(),
	function()
		triggerClientEvent(client, "onServerSendDoneastyObjects", client, DoneastyObjects )
	end
)
