--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Craftings = {}
CCrafting = {}

function CCrafting:constructor(iID, tableIngredients, CraftedItem, iCraftedItemCount, iCost)
	self.ID = iID
	self.Ingredients = tableIngredients
	
	self.IngredientsByID = {}
	
	for k,v in ipairs(self.Ingredients) do
		self.IngredientsByID[v["Item"]:getID()] = v["Count"]
	end
	
	self.CraftedItem = CraftedItem
	self.CraftedItemCount = iCraftedItemCount
	self.Cost = iCost
	
	Craftings[self.ID] = self
end

function CCrafting:destructor()

end

function CCrafting:execute(thePlayer)
	if (thePlayer:getInventory():hasItems(self.Ingredients)) then
		if (thePlayer:getInventory():getCount(self.CraftedItem)+self.CraftedItemCount <=  self.CraftedItem:getStacksize()) then
			if (thePlayer:payMoney(self.Cost)) then
				thePlayer:getInventory():removeItems(self.Ingredients)
				thePlayer:getInventory():addItem(self.CraftedItem, self.CraftedItemCount)
				thePlayer:showInfoBox("info", "Du hast ein Item ("..self.CraftedItem.Name.." x"..self.CraftedItemCount..") gecrafted!")
				thePlayer:incrementStatistics("Crafting", "Items_hergestellt", self.CraftedItemCount)
				thePlayer:incrementStatistics("Crafting", "Vorg\aenge_insgesamt", 1)
				thePlayer:incrementStatistics("Crafting", "Geld_ausgegeben", self.Cost)
			end
		else
			thePlayer:showInfoBox("error", "Davon kannst du nichts mehr tragen!")
		end
	else
		thePlayer:showInfoBox("error", "Um dieses Item zu craften fehlen dir die nötigen Mittel!")
	end
end

function CCrafting:isCraftableWithItems(tblItems)
	for k,v in ipairs(tblItems) do
		
	end
end

addEvent("onPlayerCraft", true)
addEventHandler("onPlayerCraft", getRootElement(),
	function(CraftingID)
		if (Craftings[tonumber(CraftingID)]) then
			Craftings[tonumber(CraftingID)]:execute(client)
			client:refreshInventory()
		else
			client:showInfoBox("error", "Dieses Crafting gibt es nicht!")
		end
	end
)