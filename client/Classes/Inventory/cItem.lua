--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ItemCategories = {}
Items = {}
ItemNames = {}

addEvent("onClientItemCategoriesRecieve", true)
addEventHandler("onClientItemCategoriesRecieve", getRootElement(),
	function(JSONItemCategories)
		ItemCategories = fromJSON(JSONItemCategories)
		for k,v in ipairs(ItemCategories) do
			v["Name"] = parseString(v["Name"])
		end
	end
)

addEvent("onCLientItemsRecieve", true)
addEventHandler("onCLientItemsRecieve", getRootElement(),
	function(JSONItems)
		Items = fromJSON(JSONItems)
		
		for k,v in ipairs(Items) do
			v["Name"] = parseString(v["Name"])
			v["Description"] = parseString(v["Description"])
		end
		
		for k,v in pairs(Items) do
			ItemNames[v["Name"]] = v["ID"]
		end
	end
)

addEventHandler("onClientResourceStart", getRootElement(),
	function()
		triggerServerEvent("onClientRequestItemCategories", getLocalPlayer())
		triggerServerEvent("onClientRequestItems", getLocalPlayer())
		triggerServerEvent("onClientRequestItemShops", getLocalPlayer())
	end
)