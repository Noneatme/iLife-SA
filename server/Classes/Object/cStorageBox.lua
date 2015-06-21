--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CStorageBox = {}

addEvent("onClientStorageBoxOpen", true)

addEvent("onClientStoreItemInBox", true)
addEvent("onClientRemoveItemFromBox", true)

function CStorageBox:constructor()
	addEventHandler("onClientStorageBoxOpen", getRootElement(), bind(CStorageBox.boxOpen, self))

	addEventHandler("onClientStoreItemInBox", getRootElement(), bind(CStorageBox.storeItem, self))
	addEventHandler("onClientRemoveItemFromBox", getRootElement(), bind(CStorageBox.removeItem, self))
end

function CStorageBox:destructor()

end

function CStorageBox:getItemCount(uObject, ItemID, Amount)
	local sum = 0
	for k,v in pairs(uObject:GetWAData("items")) do
		sum = sum+v
	end
	return sum
end

function CStorageBox:storeItem(uObject, ItemID, Amount)
	local preItems = uObject:GetWAData("items")
	if (client:getInventory():removeItem(Items[ItemID], Amount)) then
		if (preItems[tostring(ItemID)]) then
			preItems[tostring(ItemID)] = preItems[tostring(ItemID)] + Amount
		else
			preItems[tostring(ItemID)] = Amount
		end
		uObject:SetWAData("items", preItems);
		client:showInfoBox("info", "Du hast ein Item eingelagert!")
		logger:OutputPlayerLog(client, "Item eingelagert", tostring(ItemID), tostring(Amount))
	end
	self:sendPlayerData(client, uObject)
	client:refreshInventory()
end

function CStorageBox:removeItem(uObject, ItemID, Amount)
	local preItems = uObject:GetWAData("items")
	if (not preItems[tostring(ItemID)] or preItems[tostring(ItemID)] < Amount) then
		return false
	end
	client:getInventory():addItem(Items[ItemID], Amount, false)
	preItems[tostring(ItemID)] = preItems[tostring(ItemID)]-Amount
	if (preItems[tostring(ItemID)] == 0) then preItems[tostring(ItemID)] = nil end
	uObject:SetWAData("items", preItems);
	client:showInfoBox("info", "Du hast ein Item ausgelagert!")
	logger:OutputPlayerLog(client, "Item ausgelagert", tostring(ItemID), tostring(Amount))
	self:sendPlayerData(client, uObject)
	client:refreshInventory()
end

function CStorageBox:sendPlayerData(uPlayer, uObject)
	triggerClientEvent(uPlayer, "onClientStorageBoxInfosRefresh", uPlayer, uObject, uObject:GetWAData("items"))
end

function CStorageBox:boxOpen(uObject)
	if(self:hasPermissions(client, uObject)) then
		self:sendPlayerData(client, uObject)
	else
		client:showInfoBox("error", "Diese Box kannst du nicht öffnen!");
	end
end

function CStorageBox:hasPermissions(uPlayer, uObject)
	if(tonumber(uPlayer:getID()) == tonumber(uObject:GetOwner())) or(uPlayer:getAdminlevel() >= 3) then
		return true;
	end

	return false;
end
