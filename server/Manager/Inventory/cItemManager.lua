--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CItemManager = inherit(cSingleton)

function CItemManager:constructor()
	local start = getTickCount()
    local result = CDatabase:getInstance():query("SELECT * FROM item")

	self.m_tblItems			= {}
	self.m_tblItemNames		= {}

	if(#result > 0) then
		for key, value in pairs(result) do
			self.m_tblItems[tonumber(value["ID"])] = new (CItem, value["ID"], value["Name"], value["Description"], value["Category"], value["Stacksize"], value["Useable"], value["Consume"], value["Tradeable"], value["Deleteable"], value["Illegal"], value["Template"], value["Cost"], value["Gewicht"])
			self.m_tblItemNames[self.m_tblItems[tonumber(value["ID"])]:getName()] = self.m_tblItems[tonumber(value["ID"])];

		end

		outputServerLog("Es wurden "..tostring(#result).." Items gefunden! (" .. getTickCount() - start .. "ms)")


	else
		outputServerLog("Es wurden keine Items gefunden!")
	end
end

function CItemManager:getItemFromID(iID)
	iID = tonumber(iID)
	if(self.m_tblItems[iID]) then
		return self.m_tblItems[iID]
	end
	return false;
end

function CItemManager:getItemMaxStack(iID)
	iID = tonumber(iID)
	if(self.m_tblItems[iID]) then
		return self.m_tblItems[iID].Stacksize
	end
	return false;
end

function CItemManager:getItemFromName(sItem)
	if(self.m_tblItemNames[sItem]) then
		return self.m_tblItemNames[sItem]
	end
	return false;
end

function CItemManager:getItems()
	if(self.m_tblItems) then
		return self.m_tblItems
	end
	return false;
end

function CItemManager:getItemCount()
	if(self.m_tblItems) then
		return #self.m_tblItems
	end
	return false;
end

function CItemManager:destructor()

end
