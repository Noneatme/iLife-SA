--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

FactionData = {}

addEvent("onServerSendsFactionInfo", true)
addEventHandler("onServerSendsFactionInfo", getRootElement(),
	function(FactionInfo)
		FactionData = FactionInfo
		triggerEvent("BankGuiRefresh", getLocalPlayer())
	end
)

Faction = {
	["Window"] = false,
	["Button"] = {},
	["Label"] = {},
	["Edit"] = {},
	["Image"] = {},
	["List"] = {}
}

factionInventoryGui = false;

function showFactionGui(tFactionData ,bIsLeader, tFactionMembers, iRank)
	if (not clientBusy) then
		hideFactionGui()

		Faction["Window"] = new(CDxWindow, "Fraktion", 510, 305, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), "res/images/dxGui/misc/icons/faction.png", "Fraktion"}, "Hier siehst du deine Fraktion.")
		Faction["Window"]:setHideFunction(function() Faction["Window"] = nil end)
		Faction["Label"][1] = new(CDxLabel, "Mitglieder:", 8, 0, 155, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])

		Faction["Label"][2] = new(CDxLabel, "Name:", 225, 19, 330, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])
		Faction["Label"][3] = new(CDxLabel, tFactionData["Name"], 335, 19, 483, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])

		Faction["Label"][4] = new(CDxLabel, "Fraktionskasse:", 225, 55, 330, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])
		Faction["Label"][5] = new(CDxLabel, tFactionData["Money"].."$", 335, 55, 483, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])

		Faction["Label"][6] = new(CDxLabel, "Dein Lohnbonus:", 225, 91, 330, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])
		Faction["Label"][7] = new(CDxLabel, (tFactionData["Boni"][iRank] or 0).."$", 335, 91, 483, 36, tocolor(255,255,255,255), 1, "default", "left", "center", Faction["Window"])


		Faction["List"][1] = new(CDxList, 8, 29, 205, 240, tocolor(125,125,125,200), Faction["Window"])
		Faction["List"][1]:addColumn("Name")
		Faction["List"][1]:addColumn("Rang")

		local FactionPlayers = {[1]={},[2]={},[3]={},[4]={},[5]={}}

		for k, v in ipairs(tFactionMembers) do
            if(FactionPlayers[tonumber(v["Rang"])]) then
			    table.insert(FactionPlayers[tonumber(v["Rang"])], v["Name"])
            end
		end

		for k, v in ipairs(FactionPlayers) do
			local a = {}
			for kk,vv in ipairs(v) do
				table.insert(a, vv)
			end
			table.sort(a, function (a, b) return a:upper() < b:upper() end)
			FactionPlayers[k] = {}
			for kpt,kss in ipairs(a) do
				table.insert(FactionPlayers[k], kss)
			end
		end

		for k=5,1,-1 do
			for kk,vv in ipairs(FactionPlayers[k]) do
				Faction["List"][1]:addRow(vv.."|"..k)
			end
		end

		Faction["Button"][2] = new(CDxButton, "Fraktion verlassen", 279, 171, 150, 33, tocolor(255,255,255,255), Faction["Window"])
		Faction["Button"][2]:addClickFunction(
			function()
				confirmDialog:showConfirmDialog("Bist du sicher, das du deine Fraktion verlassen moechtest?\nDiese Aktion kann nicht Rueckgaengig gemacht werden!", function()
					hideFactionGui()
					triggerServerEvent("onPlayerLeaveFaction", getLocalPlayer())

				end, function() showCursor(true) end, false, false)
			end
		)


		Faction["Window"]:add(Faction["Label"][1])
		Faction["Window"]:add(Faction["Label"][2])
		Faction["Window"]:add(Faction["Label"][3])
		Faction["Window"]:add(Faction["Label"][4])
		Faction["Window"]:add(Faction["Label"][5])
		Faction["Window"]:add(Faction["Label"][6])
		Faction["Window"]:add(Faction["Label"][7])
		Faction["Window"]:add(Faction["List"][1])
		Faction["Window"]:add(Faction["List"][1])
		Faction["Window"]:add(Faction["Button"][2])

		if (tFactionData["Type"] ~= 1) then
			Faction["Button"][1] = new(CDxButton, "Skin setzen", 279, 124, 150, 33, tocolor(255,255,255,255), Faction["Window"])
			Faction["Button"][1]:addClickFunction(
				function()
					triggerServerEvent("onPlayerTakeFactionSkin", getLocalPlayer())
				end
			)
			Faction["Window"]:add(Faction["Button"][1])
		end

		if (bIsLeader) then
			Faction["Button"][3] = new(CDxButton, "Zur Verwaltung", 219, 236, 150, 33, tocolor(255,255,255,255), Faction["Window"])
			Faction["Button"][3]:addClickFunction(
				function()
					clientBusy = false
					triggerServerEvent("onPlayerOpenLeaderGui", getLocalPlayer())
				end
			)
			Faction["Window"]:add(Faction["Button"][3])
		end
		Faction["Button"][4] = new(CDxButton, "Fraktionslager", 379, 236, 125, 33, tocolor(255,255,255,255), Faction["Window"])
		Faction["Button"][4]:addClickFunction(
			function()
				if not(factionInventoryGui) then
					factionInventoryGui = cFactionInventoryGui:new();
				end
				clientBusy = false
				hideFactionGui()
				factionInventoryGui:show()
			end
		)

		Faction["Window"]:add(Faction["Button"][4])

		Faction["Window"]:show()
	end
end
addEvent("showFactionGui", true)
addEventHandler("showFactionGui", getRootElement(), showFactionGui)

function toggleFactionGui(tFactionData ,bIsLeader, tFactionMembers, iRank)
	if (Faction["Window"]) then
		hideFactionGui()
	else
		if (FactionLeader["Window"]) then
			hideFactionLeaderGui()
		else
			showFactionGui(tFactionData ,bIsLeader, tFactionMembers, iRank)
		end
	end
end
addEvent("toggleFactionGui", true)
addEventHandler("toggleFactionGui", getLocalPlayer(), toggleFactionGui)

function hideFactionGui()
	if (Faction["Window"]) then
		Faction["Window"]:hide()
		Faction["Window"] = false
	end
end
addEvent("hideFactionGui", true)
addEventHandler("hideFactionGui", getRootElement(), hideFactionGui)

FactionLeader = {
	["Window"] = false,
	["Button"] = {},
	["Label"] = {},
	["Edit"] = {},
	["Image"] = {},
	["List"] = {}
}

function showFactionLeaderGui(tFactionData, tFactionMembers)
	if (not clientBusy) then
		hideFactionGui()
		hideFactionLeaderGui()

		FactionLeader["Window"] = new(CDxWindow, "Fraktion", 480, 460, true, true, "Center|Middle")

		FactionLeader["Button"][1] = new(CDxButton, "Rauswerfen", 255, 10, 205, 42, tocolor(255,255,255,255), FactionLeader["Window"])

		FactionLeader["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onPlayerExecuteServerCommand", getLocalPlayer(), "uninvite", FactionLeader["List"][1]:getRowData(1))
				hideFactionGui()
				hideFactionLeaderGui()
			end
		)

		FactionLeader["Label"][1] = new(CDxLabel, "Name:", 255, 52, 205, 36, tocolor(255,255,255,255), 1, "default", "left", "center", FactionLeader["Window"])

		FactionLeader["Edit"][1] = new(CDxEdit, "", 255, 80, 205, 36, "normal", tocolor(0,0,0,255), FactionLeader["Window"])

		FactionLeader["Button"][2] = new(CDxButton, "Einladen", 255, 130, 205,36, tocolor(255,255,255,255), FactionLeader["Window"])

		FactionLeader["Button"][2]:addClickFunction(
			function()
				triggerServerEvent("onPlayerExecuteServerCommand", getLocalPlayer(), "invite", FactionLeader["Edit"][1]:getText())
				hideFactionGui()
				hideFactionLeaderGui()
			end
		)

		FactionLeader["Label"][2] = new(CDxLabel, "Rang (1-5):", 255, 178, 205, 36, tocolor(255,255,255,255), 1, "default", "left", "center", FactionLeader["Window"])

		FactionLeader["Edit"][2] = new(CDxEdit, "1", 255, 215, 205, 36, "Number", tocolor(0,0,0,255), FactionLeader["Window"])

		FactionLeader["Button"][3] = new(CDxButton, "Rang setzen", 255, 265, 205, 36, tocolor(255,255,255,255), FactionLeader["Window"])

		FactionLeader["Button"][3]:addClickFunction(
			function()
				triggerServerEvent("onPlayerExecuteServerCommand", getLocalPlayer(), "giverank", FactionLeader["List"][1]:getRowData(1).." "..FactionLeader["Edit"][2]:getText())
				hideFactionGui()
				hideFactionLeaderGui()
			end
		)

		FactionLeader["Label"][3] = new(CDxLabel, "Haus (ID):", 255, 304, 205, 36, tocolor(255,255,255,255), 1, "default", "left", "center", FactionLeader["Window"])

		FactionLeader["Edit"][3] = new(CDxEdit, "1", 255, 341, 205, 36, "Number", tocolor(0,0,0,255), FactionLeader["Window"])

		FactionLeader["Button"][4] = new(CDxButton, "Hinzufügen/Entfernen", 255, 386, 205, 36, tocolor(255,255,255,255), FactionLeader["Window"])

		FactionLeader["Button"][4]:addClickFunction(
			function()
				triggerServerEvent("onLeaderAddRevokeHouse", getRootElement(), tonumber(FactionLeader["Edit"][3]:getText()))
				hideFactionGui()
				hideFactionLeaderGui()
			end
		)

		FactionLeader["List"][1] = new(CDxList, 8, 5, 235, 415, tocolor(125,125,125,200), FactionLeader["Window"])
		FactionLeader["List"][1]:addColumn("Name")
		FactionLeader["List"][1]:addColumn("Rang")

		local FactionPlayers = {[1]={},[2]={},[3]={},[4]={},[5]={}}

		for k, v in ipairs(tFactionMembers) do
			table.insert(FactionPlayers[v["Rang"]], v["Name"])
		end

		for k, v in ipairs(FactionPlayers) do
			local a = {}
			for kk,vv in ipairs(v) do
				table.insert(a, vv)
			end
			table.sort(a, function (a, b) return a:upper() < b:upper() end)
			FactionPlayers[k] = {}
			for kpt,kss in ipairs(a) do
				table.insert(FactionPlayers[k], kss)
			end
		end

		for k=5,1,-1 do
			for kk,vv in ipairs(FactionPlayers[k]) do
				FactionLeader["List"][1]:addRow(vv.."|"..k)
			end
		end

		FactionLeader["Window"]:add(FactionLeader["Label"][1])
		FactionLeader["Window"]:add(FactionLeader["Label"][2])
		FactionLeader["Window"]:add(FactionLeader["Label"][3])
		FactionLeader["Window"]:add(FactionLeader["List"][1])
		FactionLeader["Window"]:add(FactionLeader["Button"][1])
		FactionLeader["Window"]:add(FactionLeader["Button"][2])
		FactionLeader["Window"]:add(FactionLeader["Button"][3])
		FactionLeader["Window"]:add(FactionLeader["Button"][4])
		FactionLeader["Window"]:add(FactionLeader["Edit"][1])
		FactionLeader["Window"]:add(FactionLeader["Edit"][2])
		FactionLeader["Window"]:add(FactionLeader["Edit"][3])

		FactionLeader["Window"]:show()
	end
end
addEvent("showFactionLeaderGui", true)
addEventHandler("showFactionLeaderGui", getRootElement(), showFactionLeaderGui)

function hideFactionLeaderGui()
	if (FactionLeader["Window"]) then
		FactionLeader["Window"]:hide()
		delete(FactionLeader["Window"])
		FactionLeader["Window"] = false
	end
end
addEvent("hideFactionLeaderGui", true)
addEventHandler("hideFactionLeaderGui", getRootElement(), hideFactionLeaderGui)

addEvent("onClientStartGW", true)
addEventHandler("onClientStartGW", getRootElement(),
	function()
		confirmDialog:showConfirmDialog("Tippe \"Attack\" ein um das Gebiet anzugreifen:", function()
					local msg = confirmDialog.guiEle["edit"]:getText();
					if (msg == "Attack") then
						triggerServerEvent("onGangwarStartConfirm", getRootElement())
					end
					--triggerServerEvent("onUserVehicleAdminDelete", localPlayer, tonumber(getElementData(theVehicle, "ID")), msg);
				end, false, false, true)
	end
)


local curAt = {}

addEvent("onGangPedStartFire", true)
addEventHandler("onGangPedStartFire", getRootElement(),
	function(pl)
		if (curAt[source]) and (getElementType(pl) == "player") then
		else
			local x,y,z = getPedBonePosition(pl, 6)
			setPedAimTarget(source, x,y,z)
			setPedControlState(source, "fire", true)

			curAt[source] = true

			setTimer(
				function(bot)
					local x,y,z = getPedBonePosition(pl, 6)
					setPedAimTarget(bot, x,y,z)
					setPedControlState(bot, "fire", true)
				end, 70, 60, source
			)

			setTimer(
				function(ped)
					setPedControlState(ped, "fire", false)
					setPedControlState(ped, "aim_weapon", false)
					setPedWeaponSlot(ped, 0)
					curAt[ped] = nil
				end, 5000, 1, source
			)
		end
	end
)
