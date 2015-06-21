--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onClientOpenGangPedBuyMenu", true)
addEvent("onClientOpenGangPedConfiguration",true)

--[[

GangpedConfig = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

local GangpedConfig_CurrentSelectedCategory = 1
function showGangpedConfigGui(ped)
	if (not clientBusy) then
		hideGangpedConfigGui()

		GangpedConfig["Window"] = new(CDxWindow, "Item auswählen", 502, 427, true, true, "Center|Middle")


		GangpedConfig["Image"][1] = new(CDxImage, 184, 24, 30, 30, "/res/images/left.png",tocolor(255,255,255,255), GangpedConfig["Window"])
		GangpedConfig["Image"][2] = new(CDxImage, 467, 24, 30, 30, "/res/images/right.png",tocolor(255,255,255,255), GangpedConfig["Window"])

		GangpedConfig["Image"][3] = new(CDxImage, 60, 70, 64, 64, "/res/images/none.png",tocolor(255,255,255,255), GangpedConfig["Window"])

		GangpedConfig["Label"][1] = new(CDxLabel, ItemCategories[GangpedConfig_CurrentSelectedCategory]["Name"],202, 18, 285, 56, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", GangpedConfig["Window"])
		GangpedConfig["Label"][2] = new(CDxLabel, "", 9, 140, 175, 80, tocolor(255,255,255,255), 1, "clear", "center", "top", GangpedConfig["Window"])
		GangpedConfig["Label"][3] = new(CDxLabel, "Anzahl:", 9, 225, 175, 30, tocolor(255,255,255,255), 1, "default", "left", "top", GangpedConfig["Window"])
		GangpedConfig["Label"][4] = new(CDxLabel, "Preis:", 9, 283, 175, 30, tocolor(255,255,255,255), 1, "default", "left", "top", GangpedConfig["Window"])
		GangpedConfig["List"][1] = new(CDxList, 196, 57, 293, 328, tocolor(125,125,125,200), GangpedConfig["Window"])

		GangpedConfig["Button"][1] = new(CDxButton, "Auswählen", 9, 342, 175, 42, tocolor(255,255,255,255), GangpedConfig["Window"])

		GangpedConfig["Edit"][1] = new(CDxEdit, "1", 9, 240, 175, 42, "Number", tocolor(0,0,0,255), GangpedConfig["Window"])
		GangpedConfig["Edit"][2] = new(CDxEdit, "1000", 9, 299, 175, 42, "Number", tocolor(0,0,0,255), GangpedConfig["Window"])

		GangpedConfig["List"][1]:addColumn("Name")
		GangpedConfig["List"][1]:addColumn("Anzahl")

		for k,v in ipairs(Items) do
			if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == GangpedConfig_CurrentSelectedCategory) ) then
				GangpedConfig["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])
			end
		end

		GangpedConfig["Button"][1]:addClickFunction(
			function ()
				if (GangpedConfig["List"][1]:getRowData(1) == "nil") then
					showInfoBox("error", "Du musst ein Item auswählen.")
					return false
				end
				if (tonumber(GangpedConfig["Edit"][1]:getText()) >= 1 ) then
					if (tonumber(GangpedConfig["Edit"][2]:getText()) >= 1 ) then
						hideGangpedConfigGui()

						confirmDialog:showConfirmDialog("Bist du sicher?\n(Vorhandene Items werden überschrieben)",
							function()
								triggerServerEvent("onClientInsertGangPedItem", ped, ItemNames[GangpedConfig["List"][1]:getRowData(1)], GangpedConfig["Edit"][1]:getText(), GangpedConfig["Edit"][2]:getText())
							end
						, false, false, false)
					else
						showInfoBox("error", "Du musst einen Preis > 0 eingeben.")
					end
				else
					showInfoBox("error", "Du musst eine Anzahl > 0 eingeben.")
				end
			end
		)

		GangpedConfig["List"][1]:addClickFunction(
			function()
				if (GangpedConfig["List"][1]:getRowData(1) ~= "nil") then
					local ItemID = ItemNames[GangpedConfig["List"][1]:getRowData(1)]
					GangpedConfig["Label"][2]:setText(Items[ItemID]["Description"])
					if (fileExists("res/images/items/"..ItemID..".png")) then
						GangpedConfig["Image"][3]:setImage("res/images/items/"..ItemID..".png")
					else
						GangpedConfig["Image"][3]:setImage("res/images/none.png")
					end
				end
			end
		)

		GangpedConfig["Image"][1]:addClickFunction(
			function()
				if (GangpedConfig_CurrentSelectedCategory ~= 1) then
					GangpedConfig_CurrentSelectedCategory = GangpedConfig_CurrentSelectedCategory-1
				else
					GangpedConfig_CurrentSelectedCategory = #ItemCategories
				end
				refreshGangpedConfig()
				if ((GangpedConfig["List"][1]:getRowCount() == 0) and (GangpedConfig_CurrentSelectedCategory ~= 0)) then
					GangpedConfig["Image"][1]:onClick("left", "down")
				end
			end
		)

		GangpedConfig["Image"][2]:addClickFunction(
			function()
				if (GangpedConfig_CurrentSelectedCategory ~= #ItemCategories) then
					GangpedConfig_CurrentSelectedCategory = GangpedConfig_CurrentSelectedCategory+1
				else
					GangpedConfig_CurrentSelectedCategory =  1
				end
				refreshGangpedConfig()
				if ((GangpedConfig["List"][1]:getRowCount() == 0) and (GangpedConfig_CurrentSelectedCategory ~= 0)) then
					GangpedConfig["Image"][2]:onClick("left", "down")
				end
			end
		)

		GangpedConfig["Window"]:add(GangpedConfig["Image"][1])
		GangpedConfig["Window"]:add(GangpedConfig["Image"][2])
		GangpedConfig["Window"]:add(GangpedConfig["Image"][3])

		GangpedConfig["Window"]:add(GangpedConfig["Label"][1])
		GangpedConfig["Window"]:add(GangpedConfig["Label"][2])
		GangpedConfig["Window"]:add(GangpedConfig["Label"][3])
		GangpedConfig["Window"]:add(GangpedConfig["Label"][4])

		GangpedConfig["Window"]:add(GangpedConfig["List"][1])

		GangpedConfig["Window"]:add(GangpedConfig["Button"][1])

		GangpedConfig["Window"]:add(GangpedConfig["Edit"][1])
		GangpedConfig["Window"]:add(GangpedConfig["Edit"][2])

		GangpedConfig["Window"]:show()
	end
end

function refreshGangpedConfig()
    if (GangpedConfig["Window"]) then
        GangpedConfig["List"][1]:clearRows()
        GangpedConfig["Label"][2]:setText("")
        GangpedConfig["Image"][3]:setImage("/res/images/none.png")
        GangpedConfig["Label"][1]:setText(ItemCategories[GangpedConfig_CurrentSelectedCategory]["Name"])
        for k,v in ipairs(Items) do
            if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == GangpedConfig_CurrentSelectedCategory) ) then
                GangpedConfig["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])
            end
        end

		if (GangpedConfigSelectedItem) then
			GangpedConfig["List"][1]:setSelectedRow(GangpedConfigSelectedItem)
			GangpedConfigSelectedItem = nil
			if (GangpedConfig["List"][1]:getRowData(1) ~= "nil") then
				local ItemID = ItemNames[GangpedConfig["List"][1]:getRowData(1)]
				GangpedConfig["Label"][2]:setText(Items[ItemID]["Description"])
				if (fileExists("res/images/items/"..ItemID..".png")) then
					GangpedConfig["Image"][3]:setImage("res/images/items/"..ItemID..".png")
				else
					GangpedConfig["Image"][3]:setImage("res/images/none.png")
				end
			end
		end
	end
end

addEventHandler("onClientOpenGangPedConfiguration", getRootElement(),
    function()
		if(GangpedConfig["Window"]) then
			hideGangpedConfigGui()
		else
			showGangpedConfigGui(source)
		end
    end
)

function hideGangpedConfigGui()
	if (GangpedConfig["Window"]) then
		GangpedConfig["Window"]:hide()
		delete(GangpedConfig["Window"])
		GangpedConfig["Window"] = nil
	end
end

--Buy

GangpedBuy = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

function showGangpedBuyGui(ped, item)
	if (not clientBusy) then
		hideGangpedBuyGui()

		GangpedBuy["Window"] = new(CDxWindow, "Item kaufen: "..Items[item["ID"["Name"], 340, 250, true, true, "Center|Middle")

		local strImg = "/res/images/none.png"
		if (fileExists("/res/images/items/"..tostring(item["ID"])..".png")) then
			strImg = "/res/images/items/"..tostring(item["ID"])..".png"
		end

		GangpedBuy["Image"][1] = new(CDxImage, 210, 15, 64, 64, strImg,tocolor(255,255,255,255), GangpedBuy["Window"])


		GangpedBuy["Label"][1] = new(CDxLabel, Items[item["ID"["Description"], 159, 85, 175, 80, tocolor(255,255,255,255), 1, "clear", "center", "top", GangpedBuy["Window"])
		GangpedBuy["Label"][2] = new(CDxLabel, "Vorhanden: "..item["Count"], 9, 20, 132, 30, tocolor(255,255,255,255), 1, "default", "left", "top", GangpedBuy["Window"])
		GangpedBuy["Label"][3] = new(CDxLabel, "Preis: "..item["Price"].."$", 9, 50, 132, 30, tocolor(255,255,255,255), 1, "default", "left", "top", GangpedBuy["Window"])
		GangpedBuy["Label"][4] = new(CDxLabel, "Anzahl:", 9, 106, 132, 30, tocolor(255,255,255,255), 1, "default-bold", "left", "top", GangpedBuy["Window"])

		GangpedBuy["Edit"][1] = new(CDxEdit, "1", 9, 130, 322, 42, "Number", tocolor(0,0,0,255), GangpedBuy["Window"])

		GangpedBuy["Button"][1] = new(CDxButton, "Kaufen", 9, 175, 322, 42, tocolor(255,255,255,255), GangpedBuy["Window"])

		GangpedBuy["Button"][1]:addClickFunction(
			function ()
				if (tonumber(GangpedBuy["Edit"][1]:getText()) > 0) then
					if (tonumber(item["Count"]) >= tonumber(GangpedBuy["Edit"][1]:getText())) then
						hideGangpedBuyGui()
						triggerServerEvent("onClientBuyGangPedItem", ped, tonumber(GangpedBuy["Edit"][1]:getText()))
					else
						showInfoBox("error", "So viel kannst du nicht kaufen!")
					end
				else
					showInfoBox("error", "Du musst eine Anzahl > 0 eingeben!")
				end
			end
		)

		GangpedBuy["Window"]:add(GangpedBuy["Image"][1])

		GangpedBuy["Window"]:add(GangpedBuy["Label"][1])
		GangpedBuy["Window"]:add(GangpedBuy["Label"][2])
		GangpedBuy["Window"]:add(GangpedBuy["Label"][3])
		GangpedBuy["Window"]:add(GangpedBuy["Label"][4])

		GangpedBuy["Window"]:add(GangpedBuy["Button"][1])

		GangpedBuy["Window"]:add(GangpedBuy["Edit"][1])

		GangpedBuy["Window"]:show()
	end
end


addEventHandler("onClientOpenGangPedBuyMenu", getRootElement(),
    function(item)
		if(GangpedBuy["Window"]) then
			hideGangpedBuyGui()
		else
			showGangpedBuyGui(source, item)
		end
    end
)

function hideGangpedBuyGui()
	if (GangpedBuy["Window"]) then
		GangpedBuy["Window"]:hide()
		delete(GangpedBuy["Window"])
		GangpedBuy["Window"] = nil
	end
end

--]]
