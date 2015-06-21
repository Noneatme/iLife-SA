--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCraftingManager = inherit(cSingleton)

function CCraftingManager:constructor()
	
	--GeneralCrafting
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM item_crafting")
	if(#result > 0) then
		for k, v in pairs(result) do
			local IngredientItemIDs = fromJSON(v["Ingredients"])
			local CraftedItem = Items[v["CraftedItem"]]
			local IngredientItems = {}
			for ItemID,Count in pairs(IngredientItemIDs) do
				table.insert(IngredientItems, {["Item"]=Items[tonumber(ItemID)],["Count"]=Count})
			end
			new (CCrafting, v["ID"],  IngredientItems, CraftedItem, v["CraftedItemCount"], v["Cost"])
		end
		outputServerLog("Es wurden "..tostring(#result).." Crafting Tables gefunden! (" .. getTickCount() - start .. "ms)")
	else
		outputServerLog("Es wurden keine Crafting Tables gefunden!")
	end
	
	--CraftingPoints
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM item_crafting_point")
	if(#result > 0) then
		for k, v in pairs(result) do
			local Position = fromJSON(v["Position"])
			local marker = createMarker(Position["X"],Position["Y"],Position["Z"],"corona",2,255,0,0,255,getRootElement())
			setElementInterior(marker, Position["Int"])
			setElementDimension(marker,Position["Dim"] )
			enew(marker, CCraftingPoint, v["ID"], v["Name"],fromJSON(v["Craftings"]), v["Restriction"])
		end
		outputServerLog("Es wurden "..tostring(#result).." Crafting Points gefunden! (" .. getTickCount() - start .. "ms)")
	else
		outputServerLog("Es wurden keine Crafting Points gefunden!")
	end      
end

function CCraftingManager:destructor()

end