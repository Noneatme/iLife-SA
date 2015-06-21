--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CInventoryManager = inherit(cSingleton)

function CInventoryManager:constructor()
	local start = getTickCount()
    local result = CDatabase:getInstance():query("SELECT * FROM inventory")
	if(#result > 0) then
		for key, value in pairs(result) do
			new (CInventory, tonumber(value["ID"]), value["Type"], value["Categories"], value["Items"], value["Slots"])
		end
		outputServerLog("Es wurden "..tostring(#result).." Inventare gefunden! (" .. getTickCount() - start .. "ms)")
	else
		outputServerLog("Es wurden keine Inventare gefunden!")
	end    
end

function CInventoryManager:destructor()
    
end