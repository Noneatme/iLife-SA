--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CPayNSprayManager = inherit(cSingleton)

function CPayNSprayManager:constructor()
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM shop_paynspray")
	if(#result > 0) then
		for key, value in pairs(result) do
			local PNP = createMarker(gettok(value["Pos"], 1 , "|"), gettok(value["Pos"], 2 , "|"), gettok(value["Pos"], 3 , "|"), "corona", 3, 255, 255, 255, 0, getRootElement())
			enew (PNP, CPayNSpray, value["ID"], value["GaragenID"], value["Pos"] ,value["BPos"] , value["Chain"], value["iOwner"], value["Filliale"])
		end
	end
	outputServerLog("Es wurden "..tostring(#result).." PayNSprays gefunden! (" .. getTickCount() - start .. "ms)")
end

function CPayNSprayManager:destructor()

end