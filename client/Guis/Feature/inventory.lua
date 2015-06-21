--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

InventorySelectedItem = nil

InventoryData = {}

local currentUservehicle = false;

addEvent("onClientInventoryRecieve", true)
addEventHandler("onClientInventoryRecieve", getRootElement(),
    function(JSONInventory, itemss)
        InventoryData = fromJSON(JSONInventory)
        refreshInventory()
        if(itemss) then
            Items = itemss;
        end
    end
)

Inventory = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

Inventory_CurrentSelectedCategory = 1

function showInventoryGui(iFaction, sType, iID)
	if (not clientBusy) then
		hideInventoryGui()

		local sBenutzenString    = "Benutzen";
		if(iFaction == 1) then
			sBenutzenString = "Lagern";
		elseif(iFaction == 2) then
			sBenutzenString = "Herausholen";
		end

		if(sType == "uservehicle") then
			currentUservehicle = iID;
        elseif(sType == "corporationstore") then
            currentUservehicle = iID;
		end

		Inventory["Window"] = new(CDxWindow, "Inventar", 502, 427, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 155, 255), "res/images/dxGui/misc/icons/inventory.png", "Inventar"}, "Hier kannst du deine Items begutachten.")

		Inventory["Window"]:setHideFunction(function()
			Inventory["Window"] = nil
			if(sType == "uservehicle") then
				triggerServerEvent("onPlayerKofferaumFinished", localPlayer, currentUservehicle)
				currentUservehicle = false;
			end
		end)

		Inventory["Image"][2] = new(CDxImage, 16, 0, 75, 60, "/res/images/iBag.png",tocolor(255,255,255,255), Inventory["Window"])

		Inventory["Image"][3] = new(CDxImage, 184, 24, 30, 30, "/res/images/left.png",tocolor(255,255,255,255), Inventory["Window"])
		Inventory["Image"][4] = new(CDxImage, 467, 24, 30, 30, "/res/images/right.png",tocolor(255,255,255,255), Inventory["Window"])

		Inventory["Image"][5] = new(CDxImage, 60, 70, 64, 64, "/res/images/none.png",tocolor(255,255,255,255), Inventory["Window"])

		Inventory["Label"][1] = new(CDxLabel, ItemCategories[Inventory_CurrentSelectedCategory]["Name"],202, 18, 285, 56, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", Inventory["Window"])
		Inventory["Label"][2] = new(CDxLabel, "", 9, 140, 175, 80, tocolor(255,255,255,255), 1, "clear", "center", "top", Inventory["Window"])
		Inventory["Label"][3] = new(CDxLabel, "Anzahl:", 9, 275, 175, 30, tocolor(255,255,255,255), 1, "default", "left", "top", Inventory["Window"])

		Inventory["List"][1] = new(CDxList, 196, 57, 293, 328, tocolor(125,125,125,200), Inventory["Window"])


		Inventory["Button"][1] = new(CDxButton, sBenutzenString, 9, 226, 175, 42, tocolor(255,255,255,255), Inventory["Window"])
		Inventory["Button"][2] = new(CDxButton, "Wegwerfen", 9, 342, 175, 42, tocolor(255,255,255,255), Inventory["Window"])

		Inventory["Edit"][1] = new(CDxEdit, "1", 9, 299, 175, 42, "Number", tocolor(0,0,0,255), Inventory["Window"])

		Inventory["List"][1]:addColumn("Name")
		Inventory["List"][1]:addColumn("Anzahl")

		for k,v in pairs(Items) do
			if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == Inventory_CurrentSelectedCategory) ) then
				Inventory["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])
			end
		end

		Inventory["Button"][1]:addClickFunction(
			function ()
				if (Inventory["List"][1]:getRowData(1) == "nil") then
					showInfoBox("error", "Du musst ein Item auswählen.")
					return false
				end
				if (InventoryData["Items"][tostring(ItemNames[Inventory["List"][1]:getRowData(1)])] >1) then
					InventorySelectedItem = Inventory["List"][1]:getSelectedRow()
				end
				if(sType == "uservehicle") then
					if(iFaction == 1) then
						triggerServerEvent("onPlayerKofferaumDepositItem", getLocalPlayer(), iID, ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					elseif(iFaction == 2) then
						triggerServerEvent("onPlayerKofferaumWithdrawItem", getLocalPlayer(), iID, ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					end
				elseif(sType == "corporationstore") then
                    if(iFaction == 1) then
						triggerServerEvent("onPlayerCorporationLagerEinlager", getLocalPlayer(), iID, ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					elseif(iFaction == 2) then
						triggerServerEvent("onPlayerCorporationLagerAuslager", getLocalPlayer(), iID, ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					end
                else

					if(iFaction == 1) then
						triggerServerEvent("onPlayerFactionDepositItem", getLocalPlayer(), ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					elseif(iFaction == 2) then
						triggerServerEvent("onPlayerFactionWithdrawItem", getLocalPlayer(), ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
					else
						triggerServerEvent("onPlayerUseItem", getLocalPlayer(), ItemNames[Inventory["List"][1]:getRowData(1)])
					end
				end
				loadingSprite:setEnabled(true);
			end
		)

		Inventory["Button"][2]:addClickFunction(
			function ()
				if (Inventory["List"][1]:getRowData(1) == "nil") then
					showInfoBox("error", "Du musst ein Item auswählen.")
					return false
				end
				if (tonumber(Inventory["Edit"][1]:getText()) >= 1 ) then
				   triggerServerEvent("onPlayerDeleteItem", getLocalPlayer(), ItemNames[Inventory["List"][1]:getRowData(1)], tonumber(Inventory["Edit"][1]:getText()))
				   loadingSprite:setEnabled(true);
				else
					showInfoBox("error", "Du musst eine Zahl > 0 eingeben.")
				end
			end
		)

		if(iFaction ~= nil) then
			Inventory["Button"][2]:setDisabled(true);
		end

		Inventory["List"][1]:addClickFunction(
			function()
				if (Inventory["List"][1]:getRowData(1) ~= "nil") then
					local ItemID = ItemNames[Inventory["List"][1]:getRowData(1)]

                    if(Items[ItemID]) and (Items[ItemID]["Description"]) then
					    Inventory["Label"][2]:setText(Items[ItemID]["Description"])
                    end
					if (fileExists("res/images/items/"..ItemID..".png")) then
						Inventory["Image"][5]:setImage("res/images/items/"..ItemID..".png")
					else
						Inventory["Image"][5]:setImage("res/images/none.png")
					end
				end
			end
		)

		Inventory["Image"][3]:addClickFunction(
			function()
				if (Inventory_CurrentSelectedCategory ~= 1) then
					Inventory_CurrentSelectedCategory = Inventory_CurrentSelectedCategory-1
				else
					Inventory_CurrentSelectedCategory = #ItemCategories
				end
				refreshInventory()
				if ((Inventory["List"][1]:getRowCount() == 0) and (Inventory_CurrentSelectedCategory ~= 0)) then
					Inventory["Image"][3]:onClick("left", "down")
				end
			end
		)

		Inventory["Image"][4]:addClickFunction(
			function()
				if (Inventory_CurrentSelectedCategory ~= #ItemCategories) then
					Inventory_CurrentSelectedCategory = Inventory_CurrentSelectedCategory+1
				else
					Inventory_CurrentSelectedCategory =  1
				end
				refreshInventory()
				if ((Inventory["List"][1]:getRowCount() == 0) and (Inventory_CurrentSelectedCategory ~= 0)) then
					Inventory["Image"][4]:onClick("left", "down")
				end
			end
		)

		Inventory["Window"]:add(Inventory["Image"][2])
		Inventory["Window"]:add(Inventory["Image"][3])
		Inventory["Window"]:add(Inventory["Image"][4])
		Inventory["Window"]:add(Inventory["Image"][5])

		Inventory["Window"]:add(Inventory["Label"][1])
		Inventory["Window"]:add(Inventory["Label"][2])
		Inventory["Window"]:add(Inventory["Label"][3])

		Inventory["Window"]:add(Inventory["List"][1])

		Inventory["Window"]:add(Inventory["Button"][1])
		Inventory["Window"]:add(Inventory["Button"][2])

		Inventory["Window"]:add(Inventory["Edit"][1])

		Inventory["Window"]:show()
	end
end

function refreshInventory()
    if (Inventory["Window"]) then
        Inventory["List"][1]:clearRows()
        Inventory["Label"][2]:setText("")
        Inventory["Image"][5]:setImage("/res/images/none.png")
        Inventory["Label"][1]:setText(ItemCategories[Inventory_CurrentSelectedCategory]["Name"])
        for k,v in pairs(Items) do
            if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == Inventory_CurrentSelectedCategory) ) then
                Inventory["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])
            end
        end

		if (InventorySelectedItem) then
			Inventory["List"][1]:setSelectedRow(InventorySelectedItem)
			InventorySelectedItem = nil
			if (Inventory["List"][1]:getRowData(1) ~= "nil") then
				local ItemID = ItemNames[Inventory["List"][1]:getRowData(1)]
				Inventory["Label"][2]:setText(Items[ItemID]["Description"])
				if (fileExists("res/images/items/"..ItemID..".png")) then
					Inventory["Image"][5]:setImage("res/images/items/"..ItemID..".png")
				else
					Inventory["Image"][5]:setImage("res/images/none.png")
				end
			end
		end
	end
end

addEvent("toggleInventoryGui", true)
addEventHandler("toggleInventoryGui", getRootElement(),
    function(id, ...)
		if not(getElementData(localPlayer, "inlobby")) or (getElementData(localPlayer, "zuschauer")) then
			if(Inventory["Window"]) then
				hideInventoryGui()
			else
				showInventoryGui(id, ...)
				if not(id) then
					triggerServerEvent("onPlayerRefreshInventory", localPlayer);
				end
			end
		end
    end
)

function hideInventoryGui()
	if (Inventory["Window"]) then
		Inventory["Window"]:hide()
		Inventory["Window"] = nil

	end
end
addEvent("hideInventoryGui", true)
addEventHandler("hideInventoryGui", getRootElement(), hideInventoryGui)
