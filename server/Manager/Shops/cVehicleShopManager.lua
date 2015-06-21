--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CVehicleShopManager = inherit(cSingleton)

function CVehicleShopManager:constructor()
	local start = getTickCount()
	
	local result = CDatabase:getInstance():query("SELECT * FROM shop_vehicle")
	if(#result > 0) then
		for key, value in pairs(result) do
			new (CVehicleShop, value["ID"], value["Name"], value["Money"], value["Chain"], value["IconCoords"], value["SpawnCoords"], value["Owner"], value["Filliale"])
		end
	end
	outputServerLog("Es wurden "..tostring(#result).." Vehicle_Shops gefunden! (" .. getTickCount() - start .. "ms)")
end

function CVehicleShopManager:destructor()

end