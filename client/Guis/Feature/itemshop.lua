--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onItemShopOpen", true)

ItemShopSelectedItem = nil

ItemShops = {}

addEvent("onClientItemShopsRecieve", true)
addEventHandler("onClientItemShopsRecieve", getRootElement(),
	function(JSONItemShops)
		ItemShops = fromJSON(JSONItemShops)

		for k,v in ipairs(ItemShops) do
			v["Name"] = string.gsub(v["Name"], "\oe", "ö")
			v["Name"] = string.gsub(v["Name"], "\ae", "ä")
			v["Name"] = string.gsub(v["Name"], "\ue", "ü")
			v["Description"] = string.gsub(v["Description"], "\oe", "ö")
			v["Description"] = string.gsub(v["Description"], "\ae", "ä")
			v["Description"] = string.gsub(v["Description"], "\ue", "ü")
		end

	end
)

ItemShop = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

currentItemShopID = 0

function showItemShopGui(id, iSell)
	currentItemShopID = id
    hideItemShopGui()

    ItemShop["Window"] = new(CDxWindow, ItemShops[id]["Name"], 552, 427, true, true, "Center|Middle")

	local pfad	= "res/images/shops/"..id..".png"
	if(fileExists("res/images/shops/"..id..".png")) then else
		pfad = "res/images/shops/11.png";
	end
	ItemShop["Image"][1] = new(CDxImage, 16, 0, 75, 60, pfad, tocolor(255,255,255,255), ItemShop["Window"])

	ItemShop["Image"][2] = new(CDxImage, 60, 70, 64, 64, "/res/images/none.png",tocolor(255,255,255,255), ItemShop["Window"])

	local label = ""
	local label2 = ""
	if(iSell == 1) then
		label = "Items verkaufen:"
		label2 = "Verkaufen"
	else
		label = "Items kaufen:"
		label2 = "Kaufen"
	end
	ItemShop["Label"][1] = new(CDxLabel, label ,202, 18, 285, 56, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", ItemShop["Window"])
	ItemShop["Label"][2] = new(CDxLabel, "", 9, 140, 175, 80, tocolor(255,255,255,255), 1, "clear", "center", "top", ItemShop["Window"])
	ItemShop["Label"][3] = new(CDxLabel, "Anzahl:", 9, 275, 175, 30, tocolor(255,255,255,255), 1, "default", "left", "top", ItemShop["Window"])

    ItemShop["Button"][1] = new(CDxButton, label2, 9, 342, 175, 42, tocolor(255,255,255,255), ItemShop["Window"])

    ItemShop["Edit"][1] = new(CDxEdit, "1", 9, 299, 175, 42, "Number", tocolor(0,0,0,255), ItemShop["Window"])

	ItemShop["List"][1] = new(CDxList, 196, 57, 333, 328, tocolor(125,125,125,200), ItemShop["Window"])

	ItemShop["List"][1]:addColumn("Icon", true)
    ItemShop["List"][1]:addColumn("Name")
	ItemShop["List"][1]:addColumn("Preis")
	ItemShop["List"][1]:addColumn("Gewicht")

	--[[for k,v in ipairs(Items) do
	    if ( (ItemShops["Items"][tostring(v["ID"])]) ) then
            ItemShop["List"][1]:addRow(v["Name"].."|"..v["Cost"])
	    end
	end]]

	for k,v in ipairs(getNumericIndexTable(ItemShops[id]["Items"])) do
		local item = Items[tonumber(v)]
		if(item) then
			local moneystring = ""
			local cost = item["Cost"]
			if(iSell == 1) then
				cost = tonumber(math.floor(item["Cost"]/2));
			-- Money
			end
			if (ItemShops[id]["Currency"] == 1) then
				moneystring = formNumberToMoneyString(cost)
			end
			-- Bonuspoints
			if (ItemShops[id]["Currency"] == 2) then
				moneystring = tostring(cost/1000).." BP"
			end
			-- Gewinnmünzen
			if (ItemShops[id]["Currency"] == 3) then
				moneystring = tostring(cost).." GM"
			end
			local icon	= "res/images/none.png"
			if(fileExists("res/images/items/"..item.ID..".png")) then
				icon = "res/images/items/"..item.ID..".png"
			end
			local gewicht = item.Gewicht or 0
			if(gewicht > 1000) then
				gewicht = (gewicht/1000).."kg"
			else
				gewicht = gewicht.."g"
			end
			ItemShop["List"][1]:addRow(icon.."|"..item["Name"].."|"..moneystring.."|"..gewicht, 1)
		end
	end

    ItemShop["Button"][1]:addClickFunction(
		function ()
			if (ItemShop["List"][1]:getRowData(2) == "nil") then
				showInfoBox("error", "Du musst ein Item auswählen.")
				return false
			end
		    if (tonumber(ItemShop["Edit"][1]:getText()) >= 1 ) then
		       triggerServerEvent("onClientBuyItemFromShop", getLocalPlayer(), currentItemShopID,ItemNames[ItemShop["List"][1]:getRowData(2)], tonumber(ItemShop["Edit"][1]:getText()))
		    else
		        showInfoBox("error", "Du musst eine Zahl > 0 eingeben.")
		    end
		end
	)

	ItemShop["List"][1]:addClickFunction(
		function()
			if (ItemShop["List"][1]:getRowData(2) ~= "nil") then
				local ItemID = ItemNames[ItemShop["List"][1]:getRowData(2)]
				ItemShop["Label"][2]:setText(Items[ItemID]["Description"])
				if (fileExists("res/images/items/"..ItemID..".png")) then
					ItemShop["Image"][2]:setImage("res/images/items/"..ItemID..".png")
				else
					ItemShop["Image"][2]:setImage("res/images/none.png")
				end
			end
		end
    )

	ItemShop["Window"]:add(ItemShop["Image"][1])
	ItemShop["Window"]:add(ItemShop["Image"][2])

	ItemShop["Window"]:add(ItemShop["Label"][1])
	ItemShop["Window"]:add(ItemShop["Label"][2])
	ItemShop["Window"]:add(ItemShop["Label"][3])

	ItemShop["Window"]:add(ItemShop["List"][1])

	ItemShop["Window"]:add(ItemShop["Button"][1])
	ItemShop["Window"]:add(ItemShop["Button"][2])

	ItemShop["Window"]:add(ItemShop["Edit"][1])

	ItemShop["Window"]:show()
end

addEvent("onItemShopOpen", true)
addEventHandler("onItemShopOpen", getRootElement(),
    function(...)
        showItemShopGui(...)
    end
)

function hideItemShopGui()
	if (ItemShop["Window"]) then
		ItemShop["Window"]:hide()
		delete(ItemShop["Window"])
		ItemShop["Window"] = nil
	end
end
addEvent("hideItemShopGui", true)
addEventHandler("hideItemShopGui", getRootElement(), hideItemShopGui)
