--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

AdminGui = {
    tab = {},
    staticimage = {},
    edit = {},
    window = {},
    tabpanel = {},
    radiobutton = {},
    button = {},
    label = {},
    gridlist = {},
    memo = {}
}

AdminTickets = {}

-- Commands
addCommandHandler("rkick", function(cmd, pln, Reason) triggerServerEvent("onAdminKickPlayer", getLocalPlayer(), getPlayerFromPartialName(pln), Reason) end)
addCommandHandler("warn", function(cmd, pln, Reason) triggerServerEvent("onAdminWarnPlayer", getLocalPlayer(), getPlayerFromPartialName(pln), Reason) end)
addCommandHandler("freeze", function(cmd, pln ) triggerServerEvent("onAdminFreezePlayer", getLocalPlayer(), getPlayerFromPartialName(pln)) end)
addCommandHandler("gethere", function(cmd, pln ) triggerServerEvent("onAdminGetHerePlayer", getLocalPlayer(), getPlayerFromPartialName(pln)) end)
addCommandHandler("goto", function(cmd, pln ) triggerServerEvent("onAdminGoToPlayer", getLocalPlayer(), getPlayerFromPartialName(pln)) end)
addCommandHandler("spec", function(cmd, pln ) triggerServerEvent("onAdminSpectatePlayer", getLocalPlayer(), getPlayerFromPartialName(pln)) end)
addCommandHandler("kill", function(cmd, pln ) triggerServerEvent("onAdminKillPlayer", getLocalPlayer(), getPlayerFromPartialName(pln)) end)
addCommandHandler("a", function(cmd, ID, txt ) triggerServerEvent("onPlayerAnswerTicket", getRootElement(), tonumber(ID), txt) end)
addCommandHandler("close", function(cmd, ID ) triggerServerEvent("onPlayerCloseTicket", getRootElement(), tonumber(ID), 1) end)
addCommandHandler("refer", function(cmd, ID, adm ) if (not adm) then adm = getPlayerName(getLocalPlayer()) end triggerServerEvent("onPlayerReferTicket", getRootElement(), tonumber(ID), adm) end)

function onKickButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminKickPlayer", getLocalPlayer(), tPlayer, guiGetText(AdminGui.memo[1]))
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onBanButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		local multiplicator
		local String = "Sekunde(n)"
		if (guiRadioButtonGetSelected(AdminGui.radiobutton[1])) then
			multiplicator = 60
			String = "Minute(n)"
		end
		if (guiRadioButtonGetSelected(AdminGui.radiobutton[2])) then
			multiplicator = 60*60
			String = "Stunde(n)"
		end
		if (guiRadioButtonGetSelected(AdminGui.radiobutton[3])) then
			multiplicator = 60*60*24
			String = "Tag(e)"
		end
		if (guiRadioButtonGetSelected(AdminGui.radiobutton[4])) then
			multiplicator = 60*60*24*30
			String = "Monat(e)"
		end
		
		if (not tonumber(guiGetText(AdminGui.edit[1]))) then
			guiSetText(AdminGui.edit[1], "1")
		end
		local duration = (tonumber(guiGetText(AdminGui.edit[1])))*multiplicator
		
		String = tostring(guiGetText(AdminGui.edit[1])).." "..String
		triggerServerEvent("onAdminBanPlayer", getLocalPlayer(), tPlayer, guiGetText(AdminGui.memo[1]), duration, String)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onWarnButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminWarnPlayer", getLocalPlayer(), tPlayer, guiGetText(AdminGui.memo[1]))
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onFreezeButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminFreezePlayer", getLocalPlayer(), tPlayer)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onGetHereButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminGetHerePlayer", getLocalPlayer(), tPlayer)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onGoToButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminGoToPlayer", getLocalPlayer(), tPlayer)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onSpecButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminSpectatePlayer", getLocalPlayer(), tPlayer)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onKillButtonHit()
	local sName = guiGridListGetItemText(AdminGui.gridlist[1], guiGridListGetSelectedItem(AdminGui.gridlist[1]), 1)
	local tPlayer = getPlayerFromName(sName)
	
	if (isElement(tPlayer)) then
		triggerServerEvent("onAdminKillPlayer", getLocalPlayer(), tPlayer)
	else
		showInfoBox("error", "Dieser Spieler existiert nicht!")
	end
end

function onShutdownButtonHit()
	triggerServerEvent("onAdminShutdown", getLocalPlayer())
end

function onGMXButtonHit()

	local time = tonumber(guiGetText(AdminGui.edit[4]))
	
	if ( (time ~= nil) and (time >= 0) ) then
		triggerServerEvent("onAdminGMX", getLocalPlayer(), time)
	else
		showInfoBox("error", "Bitte eine Zeit angeben!")
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(), 
	function()
		AdminGui.window[1] = guiCreateWindow(473, 217, 640, 460, "Administration", false)
		guiWindowSetSizable(AdminGui.window[1], false)

		AdminGui.tabpanel[1] = guiCreateTabPanel(9, 22, 622, 429, false, AdminGui.window[1])

		--Tab1 : Player
		AdminGui.tab[1] = guiCreateTab("Spieler (1)", AdminGui.tabpanel[1])

		AdminGui.label[1] = guiCreateLabel(8, 6, 128, 20, "Spieler:", false, AdminGui.tab[1])
		guiSetFont(AdminGui.label[1], "default-bold-small")
		AdminGui.gridlist[1] = guiCreateGridList(7, 27, 210, 370, false, AdminGui.tab[1])
		
		guiGridListClear(AdminGui.gridlist[1])
		local sCol = guiGridListAddColumn ( AdminGui.gridlist[1], "Spieler", 0.9 )
		
		for k,v in ipairs(getElementsByType("player")) do
			local sRow = guiGridListAddRow(AdminGui.gridlist[1])
			guiGridListSetItemText(AdminGui.gridlist[1], sRow, sCol, getPlayerName(v), false, false)
		end
		
		AdminGui.label[2] = guiCreateLabel(232, 139, 149, 21, "Grund:", false, AdminGui.tab[1])
		guiSetFont(AdminGui.label[2], "default-bold-small")
		AdminGui.memo[1] = guiCreateMemo(233, 156, 364, 60, "", false, AdminGui.tab[1])
		AdminGui.label[3] = guiCreateLabel(232, 278, 39, 18, "Dauer:", false, AdminGui.tab[1])
		guiSetFont(AdminGui.label[3], "default-bold-small")
		AdminGui.edit[1] = guiCreateEdit(274, 269, 101, 35, "", false, AdminGui.tab[1])
		AdminGui.radiobutton[1] = guiCreateRadioButton(389, 259, 126, 16, "Minuten", false, AdminGui.tab[1])
		guiRadioButtonSetSelected(AdminGui.radiobutton[1], true)
		AdminGui.radiobutton[2] = guiCreateRadioButton(389, 276, 126, 16, "Stunden", false, AdminGui.tab[1])
		AdminGui.radiobutton[3] = guiCreateRadioButton(389, 293, 126, 16, "Tage", false, AdminGui.tab[1])
		AdminGui.radiobutton[4] = guiCreateRadioButton(483, 276, 126, 16, "Monate", false, AdminGui.tab[1])

		--Buttons--
		AdminGui.button[1] = guiCreateButton(233, 218, 365, 37, "Kicken", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[1], onKickButtonHit, false)
		AdminGui.button[2] = guiCreateButton(233, 358, 365, 37, "Bannen", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[2], onBanButtonHit, false)
		AdminGui.button[3] = guiCreateButton(233, 316, 365, 37, "Verwarnen", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[3], onWarnButtonHit, false)		
		AdminGui.button[4] = guiCreateButton(233, 28, 365, 24, "Freezen", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[4], onFreezeButtonHit, false)
		AdminGui.button[5] = guiCreateButton(233, 53, 183, 24, "Zu dir Porten", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[5], onGetHereButtonHit, false)
		AdminGui.button[6] = guiCreateButton(418, 53, 179, 24, "Zu diesen Spieler Porten", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[6], onGoToButtonHit, false)
		AdminGui.button[7] = guiCreateButton(233, 78, 365, 24, "Spectaten", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[7], onSpecButtonHit, false)
		AdminGui.button[8] = guiCreateButton(233, 103, 365, 24, "Töten/Unstucken", false, AdminGui.tab[1])
		addEventHandler("onClientGUIClick", AdminGui.button[8], onKillButtonHit, false)

		--Tab 2 : Fraktionen
		AdminGui.tab[2] = guiCreateTab("Fraktionen", AdminGui.tabpanel[1])

		AdminGui.label[4] = guiCreateLabel(10, 6, 135, 26, "Fraktionen:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[4], "default-bold-small")
		AdminGui.gridlist[2] = guiCreateGridList(7, 27, 208, 373, false, AdminGui.tab[2])
		AdminGui.label[5] = guiCreateLabel(229, 30, 159, 21, "Spieler:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[5], "default-bold-small")
		AdminGui.edit[2] = guiCreateEdit(228, 49, 199, 34, "", false, AdminGui.tab[2])
		AdminGui.button[9] = guiCreateButton(229, 86, 200, 36, "Entfernen", false, AdminGui.tab[2])
		AdminGui.label[6] = guiCreateLabel(229, 127, 159, 21, "Rank:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[6], "default-bold-small")
		AdminGui.edit[3] = guiCreateEdit(228, 147, 199, 34, "", false, AdminGui.tab[2])
		AdminGui.button[10] = guiCreateButton(229, 184, 200, 36, "Hinzufügen", false, AdminGui.tab[2])
		AdminGui.label[7] = guiCreateLabel(229, 258, 159, 21, "Fraktionskasse:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[7], "default-bold-small")
		AdminGui.label[8] = guiCreateLabel(229, 279, 159, 21, "0$", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[8], "default-bold-small")
		guiLabelSetColor(AdminGui.label[8], 0, 167, 0)
		AdminGui.label[9] = guiCreateLabel(229, 314, 159, 21, "Anzahl Fahrzeuge:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[9], "default-bold-small")
		AdminGui.label[10] = guiCreateLabel(229, 335, 159, 21, "5", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[10], "default-bold-small")
		guiLabelSetColor(AdminGui.label[10], 0, 167, 0)
		AdminGui.label[11] = guiCreateLabel(229, 356, 159, 21, "Anzahl Häuser:", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[11], "default-bold-small")
		AdminGui.label[12] = guiCreateLabel(229, 377, 159, 21, "1", false, AdminGui.tab[2])
		guiSetFont(AdminGui.label[12], "default-bold-small")
		guiLabelSetColor(AdminGui.label[12], 0, 167, 0)

		AdminGui.tab[3] = guiCreateTab("Servermanagement", AdminGui.tabpanel[1])

		AdminGui.staticimage[1] = guiCreateStaticImage(11, 17, 87, 81, ":ilife/res/images/infobox/warning.png", false, AdminGui.tab[3])
		AdminGui.button[11] = guiCreateButton(109, 18, 402, 47, "NOTFALLABSCHALTUNG", false, AdminGui.tab[3])
		AdminGui.staticimage[2] = guiCreateStaticImage(523, 17, 87, 81, ":ilife/res/images/infobox/warning.png", false, AdminGui.tab[3])
		AdminGui.label[13] = guiCreateLabel(197, 70, 244, 26, "Achtung: Es gibt keinen Bestätigungsdialog!", false, AdminGui.tab[3])
		guiSetFont(AdminGui.label[13], "default-bold-small")
		guiLabelSetColor(AdminGui.label[13], 137, 0, 0)
		AdminGui.label[14] = guiCreateLabel(16, 114, 62, 21, "GMX:", false, AdminGui.tab[3])
		guiSetFont(AdminGui.label[14], "default-bold-small")
		AdminGui.edit[4] = guiCreateEdit(36, 137, 70, 34, "", false, AdminGui.tab[3])
		AdminGui.label[15] = guiCreateLabel(16, 144, 62, 21, "In", false, AdminGui.tab[3])
		guiSetFont(AdminGui.label[15], "default-bold-small")
		AdminGui.label[16] = guiCreateLabel(113, 144, 49, 21, "Minuten", false, AdminGui.tab[3])
		guiSetFont(AdminGui.label[16], "default-bold-small")
		AdminGui.button[12] = guiCreateButton(10, 177, 158, 37, "GMX Durchführen", false, AdminGui.tab[3])
		AdminGui.staticimage[3] = guiCreateStaticImage(524, 312, 94, 91, ":ilife/res/images/rewrite.png", false, AdminGui.tab[3])   
		
		addEventHandler("onClientGUIClick", AdminGui.button[11], onShutdownButtonHit, false)
		addEventHandler("onClientGUIClick", AdminGui.button[12], onGMXButtonHit, false)
		
		AdminGui.tab[4] = guiCreateTab("Tickets", AdminGui.tabpanel[1])

		AdminGui.gridlist[3] = guiCreateGridList(10, 10, 309, 385, false, AdminGui.tab[4])
		guiGridListAddColumn(AdminGui.gridlist[3], "ID", 0.3)
		guiGridListAddColumn(AdminGui.gridlist[3], "Spieler", 0.3)
		guiGridListAddColumn(AdminGui.gridlist[3], "Admin", 0.3)
		guiGridListSetSortingEnabled(AdminGui.gridlist[3], false)
		AdminGui.memo[2] = guiCreateMemo(329, 12, 283, 133, "", false, AdminGui.tab[4])
		guiMemoSetReadOnly(AdminGui.memo[2], true)
		AdminGui.memo[3] = guiCreateMemo(329, 155, 283, 55, "", false, AdminGui.tab[4])
		AdminGui.button[13] = guiCreateButton(332, 217, 280, 40, "Antworten", false, AdminGui.tab[4])
		guiSetProperty(AdminGui.button[13], "NormalTextColour", "FFAAAAAA")
		AdminGui.button[14] = guiCreateButton(334, 257, 278, 41, "Schließen", false, AdminGui.tab[4])
		guiSetProperty(AdminGui.button[14], "NormalTextColour", "FFAAAAAA")
		AdminGui.label[17] = guiCreateLabel(336, 303, 86, 22, "Admin:", false, AdminGui.tab[4])
		AdminGui.edit[5] = guiCreateEdit(334, 325, 153, 31, "", false, AdminGui.tab[4])
		AdminGui.button[15] = guiCreateButton(494, 325, 118, 31, "Zuweisen", false, AdminGui.tab[4])
		guiSetProperty(AdminGui.button[15], "NormalTextColour", "FFAAAAAA")    
		AdminGui.button[16] = guiCreateButton(494, 370, 118, 31, "Aktualisieren", false, AdminGui.tab[4])
		guiSetProperty(AdminGui.button[16], "NormalTextColour", "FFAAAAAA")    
		
		addEventHandler("onClientGUIClick", AdminGui.button[16], 
			function(button, state)
				if (button == "left") then
					refreshAdminGuiTickets()
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", AdminGui.button[13], 
			function(button, state)
				if (button == "left") then
					local r, c = guiGridListGetSelectedItem(AdminGui.gridlist[3])
					if (r ~= -1) then
						local ID = guiGridListGetItemData(AdminGui.gridlist[3], r,c)
						triggerServerEvent("onPlayerAnswerTicket", getRootElement(), ID, guiGetText(AdminGui.memo[3]))
					else
						showInfoBox("error", "Wähle ein Ticket aus!")
					end
					
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", AdminGui.button[14], 
			function(button, state)
				if (button == "left") then
					local r, c = guiGridListGetSelectedItem(AdminGui.gridlist[3])
					if (r ~= -1) then
						local ID = guiGridListGetItemData(AdminGui.gridlist[3], r,c)
						triggerServerEvent("onPlayerCloseTicket", getRootElement(), ID, 1)
					else
						showInfoBox("error", "Wähle ein Ticket aus!")
					end
					
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", AdminGui.button[15], 
			function(button, state)
				if (button == "left") then
					local r, c = guiGridListGetSelectedItem(AdminGui.gridlist[3])
					if (r ~= -1) then
						local ID = guiGridListGetItemData(AdminGui.gridlist[3], r,c)
						triggerServerEvent("onPlayerReferTicket", getRootElement(), ID, guiGetText(AdminGui.edit[5]))
					else
						showInfoBox("error", "Wähle ein Ticket aus!")
					end
					
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", AdminGui.gridlist[3], 
			function(button, state)
				if (button == "left") then
					local r, c = guiGridListGetSelectedItem(AdminGui.gridlist[3])
					if (r ~= -1) then
						local ID = guiGridListGetItemData(AdminGui.gridlist[3], r,c)
						local str = ""
						if (table.size(AdminTickets[ID]["Answer"]) > 0) then
							for kk=1,table.size(AdminTickets[ID]["Answer"],1) do
								str = str..AdminTickets[ID]["Answer"][tostring(kk)]["Name"]..":\n"..AdminTickets[ID]["Answer"][tostring(kk)]["Text"].."\n"
							end
						end
						guiSetText(AdminGui.memo[2], AdminTickets[ID]["Subject"].."\n\n"..AdminTickets[ID]["Text"].."\n\n"..str)
						guiSetText(AdminGui.edit[5], AdminTickets[ID]["Admin"])
					end
				end
			end
		, false)
		
		guiSetVisible(AdminGui.window[1], false)
	end
)

function showAdminGUI()
	if (not (clientBusy)) then
		hideAdminGUI()
		clientBusy = true
		guiSetInputEnabled(true)
		showCursor(true)
		toggleAllControls(false)
		guiSetVisible(AdminGui.window[1], true)
		refreshAdminGuiTickets()
		guiGridListClear(AdminGui.gridlist[1])
		for k,v in ipairs(getElementsByType("player")) do
			local sRow = guiGridListAddRow(AdminGui.gridlist[1])
			guiGridListSetItemText(AdminGui.gridlist[1], sRow, 1, getPlayerName(v), false, false)
		end
	end
end

addEvent("onClientRecieveClientTickets", true)
addEventHandler("onClientRecieveClientTickets", getRootElement(),
	function(Data)
		AdminTickets = Data
		refreshAdminGuiTickets()
	end
)

function refreshAdminGuiTickets()
	local clickedBefore = false
	local row, cy = guiGridListGetSelectedItem(AdminGui.gridlist[3])
	if (row and row ~= -1) then
		local xxx,yyy = guiGridListGetSelectedItem(AdminGui.gridlist[3])
		clickedBefore = guiGridListGetItemData(AdminGui.gridlist[3], xxx, yyy)
	end

	guiGridListClear(AdminGui.gridlist[3])
	local count = 0
	for k,v in pairs(AdminTickets) do
		if (v["State"] == 0) then
			guiGridListAddRow(AdminGui.gridlist[3])
			guiGridListSetItemText(AdminGui.gridlist[3], count, 1, v["ID"], false, false)
			guiGridListSetItemText(AdminGui.gridlist[3], count, 2, v["PlayerName"], false, false)
			guiGridListSetItemText(AdminGui.gridlist[3], count, 3, v["Admin"], false, false)
			guiGridListSetItemData(AdminGui.gridlist[3], count, 1, v["ID"], false, false)
			guiGridListSetItemData(AdminGui.gridlist[3], count, 2, v["ID"], false, false)
			guiGridListSetItemData(AdminGui.gridlist[3], count, 3, v["ID"], false, false)
			if (clickedBefore and v["ID"] == clickedBefore) then
				guiGridListSetSelectedItem(AdminGui.gridlist[3], row, 1)
				local r, c = guiGridListGetSelectedItem(AdminGui.gridlist[3])
				if (r ~= -1) then
					local ID = guiGridListGetItemData(AdminGui.gridlist[3], r,c)
					local str = ""
					if (table.size(AdminTickets[ID]["Answer"]) > 0) then
						for kk=1,table.size(AdminTickets[ID]["Answer"],1) do
							str = str..AdminTickets[ID]["Answer"][tostring(kk)]["Name"]..":\n"..AdminTickets[ID]["Answer"][tostring(kk)]["Text"].."\n"
						end
					end
					guiSetText(AdminGui.memo[2], AdminTickets[ID]["Subject"].."\n\n"..AdminTickets[ID]["Text"].."\n\n"..str)
					guiSetText(AdminGui.edit[5], AdminTickets[ID]["Admin"])
				end
			end
			count = count+1
		end
	end
end

function hideAdminGUI()
	guiSetVisible(AdminGui.window[1], false)
	guiSetInputEnabled(false)
	showCursor(false)
	
	toggleAllControls(true)
	clientBusy = false;
end

addEvent("toggleAdminGui", true)
addEventHandler("toggleAdminGui", getLocalPlayer(),
    function()
		if ( guiGetVisible(AdminGui.window[1]) ) then
			hideAdminGUI()
		else
			showAdminGUI()
		end
	end
)