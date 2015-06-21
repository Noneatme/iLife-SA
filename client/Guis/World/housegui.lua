--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

House = {
	["Window"] = false,
	["Button"] = {},
	["Label"] = {},
	["Edit"] = {},
	["List"] = {}
}

function showHouseGui(ID, Owner, Locked, Price, Keys, FactionID, FactionName, CorpID, CorpName)
	hideHouseGui()
	if (FactionID == 0) and (CorpID == 0) then
		if (Owner == getPlayerName(getLocalPlayer())) then

			House["Window"] = new(CDxWindow, "Hausmanagement", 645, 350, true, true, "Center|Middle", 0, 0, {tocolor(125, 255, 125, 255), false, "Hausmanagement"}, "In diesem Menu kannst du allerhand Sachen einstellen, da dir dieses Haus gehoert.")
		else
			House["Window"] = new(CDxWindow, "Hausmanagement", 310, 350, true, true, "Center|Middle", 0, 0, false, "Wenn du dieses Haus kaufen moechtest, musst du genug Geld auf deinem Konto besitzen.")
		end
		--House["Label"][1] = guiCreateLabel(20,33,160,26,"Dieses Haus gehört:",false,House["Window"])
		House["Label"][1] = new(CDxLabel, "Dieses Haus gehört:", 20, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		--House["Edit"][1] = guiCreateEdit(17,65,139,46,"ReWrite",false,House["Window"])
		--House["Label"][2] = guiCreateLabel(177,33,160,26,"Wert:",false,House["Window"])
		House["Label"][2] = new(CDxLabel, "Wert:", 177, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		--House["Label"][3] = guiCreateLabel(177,75,67,26,"25.000$",false,House["Window"])
		House["Label"][3] = new(CDxLabel, formNumberToMoneyString(tostring(Price)), 177, 75, 117, 26, tocolor(0,125,0,255), 1, "default", "left", "center", House["Window"])
		--House["Button"][1] = guiCreateButton(12,154,237,52,"Eintreten",false,House["Window"])
		House["Button"][1] = new(CDxButton, "Eintreten", 12, 154, 175, 42, tocolor(255,255,255,255), House["Window"])
		House["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onPlayerHouseEnter", getLocalPlayer(), ID, getLocalPlayer())
			end
		)
		--House["Button"][2] = guiCreateButton(12,209,236,52,"Verkaufen",false,House["Window"])
		--House["Label"][4] = guiCreateLabel(20,127,160,26,"Es ist abgeschlossen.",false,House["Window"])
		if (Locked) then
			House["Label"][4] = new(CDxLabel, "Es ist abgeschlossen.", 20, 127, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		else
			House["Label"][4] = new(CDxLabel, "Es ist aufgeschlossen.", 20, 127, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		end
		--House["Button"][3] = guiCreateButton(12,264,236,52,"Abschließen",false,House["Window"])

		House["Window"]:add(House["Label"][1])
		House["Window"]:add(House["Label"][2])
		House["Window"]:add(House["Label"][3])
		House["Window"]:add(House["Button"][1])

		House["Window"]:add(House["Label"][4])

		if (Keys[getPlayerName(getLocalPlayer())] or Owner == "" or Owner == getPlayerName(getLocalPlayer()) ) then
			if (Locked) then
				House["Button"][2] = new(CDxButton, "Aufschließen", 12, 209, 175, 42, tocolor(255,255,255,255), House["Window"])
			else
				House["Button"][2] = new(CDxButton, "Abschließen", 12, 209, 175, 42, tocolor(255,255,255,255), House["Window"])
			end
			House["Button"][2]:addClickFunction(
				function()
					triggerServerEvent("onPlayerHouseToggleLocked", getLocalPlayer(), ID, getLocalPlayer())
				end
			)
			House["Window"]:add(House["Button"][2])
		end

		if (Owner == "") then
			House["Button"][3] = new(CDxButton, "Kaufen", 12, 264, 175, 42, tocolor(255,255,255,255), House["Window"])
			House["Window"]:add(House["Button"][3])
			House["Edit"][1] =  new(CDxEdit, "Niemanden", 17, 65, 150, 42, "normal", tocolor(0,0,0,255), House["Window"])
		else
			if (Owner == getPlayerName(getLocalPlayer())) then
				House["Button"][3] = new(CDxButton, "Verkaufen", 12, 264, 175, 42, tocolor(255,255,255,255), House["Window"])
				House["Window"]:add(House["Button"][3])
			end
			House["Edit"][1] =  new(CDxEdit, Owner, 17, 65, 150, 42, "normal", tocolor(0,0,0,255), House["Window"])
		end
		if (House["Button"][3]) then
			House["Button"][3]:addClickFunction(
				function()
					triggerServerEvent("onPlayerHouseBuySell", getLocalPlayer(), ID, getLocalPlayer())
				end
			)
		end
		House["Window"]:add(House["Edit"][1])

		if (Owner == getPlayerName(getLocalPlayer())) then
			--House["Grid"][1] = guiCreateGridList(268,72,165,244,false,House["Window"])

			House["List"][1] = new(CDxList, 318, 72, 165, 244, tocolor(125,125,125,200), House["Window"])
			--guiGridListAddColumn(House["Grid[1],"Name",0.2)
			House["List"][1]:addColumn("Nummer")
			House["List"][1]:addColumn("Name")

			local count =1

			for index, value in ipairs(Keys) do
				if(value) and (value["Name"]) then
					House["List"][1]:addRow(count.."|"..value["Name"])
					count = count+1
				end
			end


			House["Edit"][2] =  new(CDxEdit, "", 493, 68, 150, 42, "normal", tocolor(0,0,0,255), House["Window"])
			House["Label"][5] = new(CDxLabel, "Spieler:", 496, 33, 109, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
			House["Button"][4] = new(CDxButton, "Schlüssel vergeben", 493, 130, 150, 42, tocolor(255,255,255,255), House["Window"])
			House["Button"][4]:addClickFunction(
				function()
					triggerServerEvent("onPlayerHouseGiveKey", getLocalPlayer(), ID, House["Edit"][2]:getText())
				end
			)
			House["Button"][5] = new(CDxButton, "Schlüssel entziehen", 493, 181, 150, 42, tocolor(255,255,255,255), House["Window"])
			House["Button"][5]:addClickFunction(
				function()
					triggerServerEvent("onPlayerHouseRevokeKey", getLocalPlayer(), ID, House["List"][1]:getRowData(2))
				end
			)
			House["Label"][6] = new(CDxLabel, "Schlüssel:", 320, 33, 109, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])

			House["Window"]:add(House["List"][1])
			House["Window"]:add(House["Edit"][2])
			House["Window"]:add(House["Label"][5])
			House["Window"]:add(House["Button"][4])
			House["Window"]:add(House["Button"][5])
			House["Window"]:add(House["Label"][6])
		end

		House["Window"]:show()
	elseif(FactionID ~= 0) then
		House["Window"] = new(CDxWindow, "Fraktionshaus", 310, 210, true, true, "Center|Middle")
		House["Label"][1] = new(CDxLabel, "Dieses Haus gehört:", 20, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		House["Label"][2] = new(CDxLabel, "Wert:", 177, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		House["Label"][3] = new(CDxLabel, formNumberToMoneyString(tostring(Price)), 177, 75, 117, 26, tocolor(0,125,0,255), 1, "default", "left", "center", House["Window"])
		House["Button"][1] = new(CDxButton, "Eintreten", 12, 110, 175, 42, tocolor(255,255,255,255), House["Window"])
		House["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onPlayerHouseEnter", getLocalPlayer(), ID, getLocalPlayer())
			end
		)

		House["Window"]:add(House["Label"][1])
		House["Window"]:add(House["Label"][2])
		House["Window"]:add(House["Label"][3])
		House["Window"]:add(House["Button"][1])

		House["Edit"][1] =  new(CDxEdit, tostring(FactionName), 17, 65, 150, 42, "normal", tocolor(0,0,0,255), House["Window"])

		House["Window"]:add(House["Edit"][1])

		House["Window"]:show()
	elseif(CorpID ~= 0) then
		House["Window"] = new(CDxWindow, "Corporationshaus", 310, 210, true, true, "Center|Middle")
		House["Label"][1] = new(CDxLabel, "Dieses Haus gehört:", 20, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		House["Label"][2] = new(CDxLabel, "Wert:", 177, 33, 160, 26, tocolor(255,255,255,255), 1, "default", "left", "center", House["Window"])
		House["Label"][3] = new(CDxLabel, formNumberToMoneyString(tostring(Price)), 177, 75, 117, 26, tocolor(0,125,0,255), 1, "default", "left", "center", House["Window"])
		House["Button"][1] = new(CDxButton, "Eintreten", 12, 110, 175, 42, tocolor(255,255,255,255), House["Window"])
		House["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onPlayerHouseEnter", getLocalPlayer(), ID, getLocalPlayer())
			end
		)

		House["Window"]:add(House["Label"][1])
		House["Window"]:add(House["Label"][2])
		House["Window"]:add(House["Label"][3])
		House["Window"]:add(House["Button"][1])

		House["Edit"][1] =  new(CDxEdit, tostring(CorpName), 17, 65, 150, 42, "normal", tocolor(0,0,0,255), House["Window"])

		House["Window"]:add(House["Edit"][1])

		House["Window"]:show()
	end
end
addEvent("showHouseGui", true)
addEventHandler("showHouseGui", getRootElement(), showHouseGui)

function hideHouseGui()
	if (House["Window"]) then
		House["Window"]:hide()
		delete(House["Window"])
		House["Window"] = false
	end
end
addEvent("hideHouseGui", true)
addEventHandler("hideHouseGui", getRootElement(), hideHouseGui)
