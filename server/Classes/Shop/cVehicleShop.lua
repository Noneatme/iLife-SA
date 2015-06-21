--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

VehicleShops = {}
CVehicleShop = inherit(CShop)

function CVehicleShop:constructor(iID, sName, iMoney, Chain, sIconCoords, sSpawnCoords, iOwner, iFilliale)
	CShop.constructor(self, sName, iID)
	self.ID 			= iID
	self.IconCoords 	= sIconCoords
	self.SpawnCoords 	= sSpawnCoords
	self.Chain 			= Chains[Chain]
	self.Filliale 		= iFilliale;

	local i = gettok(self.IconCoords, 1, "|")
	local d = gettok(self.IconCoords, 2, "|")
	local x = gettok(self.IconCoords, 3, "|")
	local y = gettok(self.IconCoords, 4, "|")
	local z = gettok(self.IconCoords, 5, "|")


	if( (self.Chain:getID() == 1) or (self.Chain:getID() == 8) ) then
		self.Blip = createBlip (x, y, z, 55, 2, 0, 0, 0, 255,0,150, getRootElement() )
	end

	if(self.Chain:getID() == 7) then
		self.Blip = createBlip (x, y, z, 9, 2, 0, 0, 0, 255,0,150, getRootElement() )
	end

	if(self.Chain:getID() == 24) then
		self.Blip = createBlip (x, y, z, 5, 2, 0, 0, 0, 255,0,150, getRootElement() )
	end


	self:spawnCars()

	VehicleShops[self.ID] = self
end

function CVehicleShop:destructor()

end

function CVehicleShop:getChain()
	return self.Chain
end

function CVehicleShop:getSpawnCoords()
	return self.SpawnCoords
end

function CVehicleShop:spawnCars()
	local result = CDatabase:getInstance():query("SELECT * FROM shop_vehicle_data WHERE ShopID=?", self.ID)
	if (#result > 0) then
		for key, value in ipairs(result) do
			local theVehicle = createVehicle(value["VID"], gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"), "4Sale")
			enew(theVehicle, CVehicleShopVehicle, value["ID"], self, value["Int"], value["Dim"], value["Color"], value["Tuning"], value["Type"], value["Stock"],value["Price"])
			cInformationWindowManager:getInstance():addInfoWindow({gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|")+1}, getVehicleNameFromModel(value["VID"]), 30);
		end
	end
	outputServerLog("Es wurden "..tostring(#result).." Vehicles fuer "..self:getName().." gefunden!")
end

function CVehicleShop:save()
	CDatabase:getInstance():query("UPDATE Shop_Vehicle SET SpawnCoords=?, Money=? WHERE ID=?", self.SpawnCoords, self.Money, self.ID)
end
