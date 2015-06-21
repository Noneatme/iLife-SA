--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CItemShopManager = inherit(cSingleton)

function CItemShopManager:constructor()
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM itemshop")

	for k,v in ipairs(result) do
		new(CItemShop, v["ID"], v["Name"], v["Description"], v["Items"], v["Currency"], (v["Sell"] or 0), v["Filiale"] or 0)
	end

	outputServerLog("Es wurden "..#result.." ItemShops gefunden! (" .. getTickCount() - start .. "ms)")

	--Drogenshop Bayside
	ItemShops[20].addMarker(ItemShops[20], 0, 0, -2514.9987792969, 2354.6628417969, 4.9840431213379)

	-- Vorarbeiter
	ItemShops[21].addMarker(ItemShops[21], 0, 0, 591.21875, 871.8427734375, -42.497318267822)

	-- Drogen verkaufen
	ItemShops[26].addMarker(ItemShops[26], 0, 0, 160.62634277344, -160.4017791748, 1.578125);

	-- Mechaniker
	addEventHandler("onMarkerHit", createMarker(2770.0830078125, -2063.078125, 12.272819519043, "corona", 2, 255, 0, 0, 255, getRootElement()),
		function(hitElement, matching)
			if (matching) then
				if (getElementType(hitElement) == "player" ) then
					if not isPedInVehicle(hitElement) then
						if hitElement.Fraktion:getID() == 7 then
							triggerClientEvent(hitElement, "onItemShopOpen", hitElement, 22)
						else
							hitElement:showInfoBox("error", "Dies ist nur als Mechaniker möglich!")
						end
					else
						hitElement:showInfoBox("error", "Steige aus deinem Fahrzeug aus!")
					end
				end
			end
		end
	)
end

function CItemShopManager:destructor()

end
