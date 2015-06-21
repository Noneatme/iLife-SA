--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ItemCategories = {}

CItemCategory = {}

addEvent("onClientRequestItemCategories", true)
addEventHandler("onClientRequestItemCategories", getRootElement(),
    function()
        triggerClientEvent(source, "onClientItemCategoriesRecieve", source, toJSON(ItemCategories))
    end
)

function CItemCategory:constructor(iID, sName, sDesc)
	self.ID                = iID
	self.Name              = sName
	self.Description    = sDesc

	ItemCategories[self.ID] = self
end

function CItemCategory:destructor()

end

function CItemCategory:getID()
	return self.ID
end
