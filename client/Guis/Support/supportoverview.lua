--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

SupportTickets = {}

SupportOverview = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local sx,sy = guiGetScreenSize()
		SupportOverview.window[1] = guiCreateWindow((sx/2)-300, (sy/2)-220, 600, 440, "Support", false)
		guiWindowSetSizable(SupportOverview.window[1], false)
		guiSetAlpha(SupportOverview.window[1], 0.90)
		guiSetProperty(SupportOverview.window[1], "CaptionColour", "FFFFFDFD")

		SupportOverview.label[1] = guiCreateLabel(11, 22, 290, 24, "Tickets:", false, SupportOverview.window[1])
		SupportOverview.gridlist[1] = guiCreateGridList(12, 57, 578, 327, false, SupportOverview.window[1])
		guiGridListAddColumn(SupportOverview.gridlist[1], "Betreff", 0.5)
		guiGridListAddColumn(SupportOverview.gridlist[1], "Status", 0.5)
		SupportOverview.button[1] = guiCreateButton(12, 394, 578, 36, "Anzeigen/Bearbeiten", false, SupportOverview.window[1])
		guiSetProperty(SupportOverview.button[1], "NormalTextColour", "FFAAAAAA")
		SupportOverview.button[2] = guiCreateButton(253, 22, 165, 31, "+ Neues Ticket", false, SupportOverview.window[1])
		guiSetProperty(SupportOverview.button[2], "NormalTextColour", "FFAAAAAA")
		SupportOverview.label[2] = guiCreateLabel(527, 1, 73, 15, "", false, SupportOverview.window[1])
		SupportOverview.button[3] = guiCreateButton(425, 22, 165, 31, "Schließen", false, SupportOverview.window[1])
		guiSetProperty(SupportOverview.button[3], "NormalTextColour", "FFAAAAAA")

		guiGridListSetSelectionMode(SupportOverview.gridlist[1], 0)
		
		guiSetVisible(SupportOverview.window[1], false)	

		addEventHandler("onClientGUIClick", SupportOverview.button[3], 
			function(button, state) 
				if (button == "left") then
					hideSupportOverviewGui()
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", SupportOverview.button[2], 
			function(button, state) 
				if (button == "left") then
					hideSupportOverviewGui()
					showSupportTicketCreateGui()
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", SupportOverview.button[1], 
			function(button, state) 
				if (button == "left") then
					local row, column = guiGridListGetSelectedItem(SupportOverview.gridlist[1])
					if (row ~= -1) then
						hideSupportOverviewGui()
						showSupportTicketDetailsGui(guiGridListGetItemData(SupportOverview.gridlist[1], row, column))
					else
						showInfoBox("error", "Du musst ein Ticket auswählen!")
					end
				end
			end
		, false)

	end
)


function showSupportOverviewGui()
	if (not (clientBusy)) then
		hideSupportOverviewGui()
		clientbusy = true
		guiSetInputEnabled(true)
		showCursor(true)
		toggleAllControls(false)
		guiSetVisible(SupportOverview.window[1], true)
		refreshSupportTickets()
	end
end

function hideSupportOverviewGui()
	clientbusy = false
	guiSetInputEnabled(false)
	showCursor(false)
	toggleAllControls(true)
	guiSetVisible(SupportOverview.window[1], false)
end


function refreshSupportTickets()
	guiGridListClear(SupportOverview.gridlist[1])
	local Tickets = getElementData(localPlayer, "SupportTickets")

	for k,v in pairs(Tickets) do
		guiGridListAddRow(SupportOverview.gridlist[1])
		
		guiGridListSetItemText(SupportOverview.gridlist[1], k-1, 1, v["Subject"], false, false)
		local state = "Offen"
		guiGridListSetItemText(SupportOverview.gridlist[1], k-1, 2, state, false, false)
		guiGridListSetItemColor(SupportOverview.gridlist[1], k-1, 2, 255, 0, 0, 255)
		if (v["State"] ~= 0) then
			state = "Geschlossen"
			guiGridListSetItemText(SupportOverview.gridlist[1], k-1, 2, state, false, false)
			guiGridListSetItemColor(SupportOverview.gridlist[1], k-1, 2, 0, 255, 0, 255)
		end
		
		guiGridListSetItemData(SupportOverview.gridlist[1], k-1, 1, v["ID"])
		guiGridListSetItemData(SupportOverview.gridlist[1], k-1, 2, v["ID"])
	end
end

addCommandHandler("Support", showSupportOverviewGui)
addCommandHandler("support", showSupportOverviewGui)
addCommandHandler("report", showSupportOverviewGui)
addCommandHandler("Report", showSupportOverviewGui)


addEventHandler("onClientElementDataChange", getLocalPlayer(), 
	function(dataName, oldValue)
		if (dataName == "SupportTickets") then
			SupportTickets = getElementData(localPlayer, "SupportTickets")
			refreshSupportTickets()
		end
	end
)


SupportTicketCreateGui = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        SupportTicketCreateGui.window[1] = guiCreateWindow(564, 250, 506, 408, "Neues Ticket", false)
        guiWindowSetSizable(SupportTicketCreateGui.window[1], false)

        SupportTicketCreateGui.label[1] = guiCreateLabel(10, 23, 138, 31, "Betreff:", false, SupportTicketCreateGui.window[1])
        SupportTicketCreateGui.edit[1] = guiCreateEdit(10, 54, 482, 36, "", false, SupportTicketCreateGui.window[1])
        SupportTicketCreateGui.label[2] = guiCreateLabel(10, 100, 111, 26, "Text:", false, SupportTicketCreateGui.window[1])
        SupportTicketCreateGui.memo[1] = guiCreateMemo(10, 126, 482, 210, "", false, SupportTicketCreateGui.window[1])
        SupportTicketCreateGui.button[1] = guiCreateButton(10, 346, 231, 47, "Abbrechen", false, SupportTicketCreateGui.window[1])
        guiSetProperty(SupportTicketCreateGui.button[1], "NormalTextColour", "FFAAAAAA")
        SupportTicketCreateGui.button[2] = guiCreateButton(261, 346, 231, 47, "Absenden", false, SupportTicketCreateGui.window[1])
        guiSetProperty(SupportTicketCreateGui.button[2], "NormalTextColour", "FFAAAAAA")    
		
		guiSetVisible(SupportTicketCreateGui.window[1], false)
		
		addEventHandler("onClientGUIClick", SupportTicketCreateGui.button[1], 
			function(button, state) 
				if (button == "left") then
					hideSupportTicketCreateGui()
					showSupportOverviewGui()
					refreshSupportTickets()
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", SupportTicketCreateGui.button[2], 
			function(button, state) 
				if (button == "left") then
					if (guiGetText(SupportTicketCreateGui.edit[1]) ~= "" and guiGetText(SupportTicketCreateGui.memo[1]) ~= "" ) then
						triggerServerEvent("onPlayerCreateTicket", getRootElement(), guiGetText(SupportTicketCreateGui.edit[1]), guiGetText(SupportTicketCreateGui.memo[1]))
						hideSupportTicketCreateGui()
						guiSetText(SupportTicketCreateGui.edit[1], "")
						guiSetText(SupportTicketCreateGui.memo[1], "")
						showSupportOverviewGui()
					end
				end
			end
		, false)
    end
)

function showSupportTicketCreateGui()
	if (not (clientBusy)) then
		hideSupportTicketCreateGui()
		clientBusy = true
		guiSetInputEnabled(true)
		showCursor(true)
		toggleAllControls(false)
		guiSetVisible(SupportTicketCreateGui.window[1], true)
	end
end

function hideSupportTicketCreateGui()
	clientBusy = false
	guiSetInputEnabled(false)
	showCursor(false)
	toggleAllControls(true)
	guiSetVisible(SupportTicketCreateGui.window[1], false)
end



SupportTicketDetailsGui = {
    edit = {},
    button = {},
    window = {},
    label = {},
    memo = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
		local sx,sy = guiGetScreenSize()
        SupportTicketDetailsGui.window[1] = guiCreateWindow((sx/2)-269, (sy/2)-209, 538, 418, "Ticket Informationen", false)
        guiWindowSetSizable(SupportTicketDetailsGui.window[1], false)

        SupportTicketDetailsGui.button[1] = guiCreateButton(226, 21, 296, 31, "Zurück", false, SupportTicketDetailsGui.window[1])
        guiSetProperty(SupportTicketDetailsGui.button[1], "NormalTextColour", "FFAAAAAA")
        SupportTicketDetailsGui.label[1] = guiCreateLabel(10, 25, 61, 17, "Ticket ID:", false, SupportTicketDetailsGui.window[1])
        SupportTicketDetailsGui.edit[1] = guiCreateEdit(71, 21, 145, 31, "1", false, SupportTicketDetailsGui.window[1])
        guiEditSetReadOnly(SupportTicketDetailsGui.edit[1], true)
        SupportTicketDetailsGui.label[2] = guiCreateLabel(10, 62, 74, 23, "Verlauf:", false, SupportTicketDetailsGui.window[1])
        SupportTicketDetailsGui.memo[1] = guiCreateMemo(10, 85, 512, 185, "", false, SupportTicketDetailsGui.window[1])
        guiMemoSetReadOnly(SupportTicketDetailsGui.memo[1], true)
        SupportTicketDetailsGui.label[3] = guiCreateLabel(13, 270, 81, 22, "Antworten:", false, SupportTicketDetailsGui.window[1])
        SupportTicketDetailsGui.memo[2] = guiCreateMemo(10, 292, 512, 73, "", false, SupportTicketDetailsGui.window[1])
        SupportTicketDetailsGui.button[2] = guiCreateButton(10, 366, 512, 42, "Antworten", false, SupportTicketDetailsGui.window[1])
        guiSetProperty(SupportTicketDetailsGui.button[2], "NormalTextColour", "FFAAAAAA")
        SupportTicketDetailsGui.label[4] = guiCreateLabel(231, 62, 43, 19, "Status:", false, SupportTicketDetailsGui.window[1])
        SupportTicketDetailsGui.label[5] = guiCreateLabel(274, 62, 131, 19, "Offen", false, SupportTicketDetailsGui.window[1])
        guiLabelSetColor(SupportTicketDetailsGui.label[5], 254, 0, 5)    
		
		guiSetVisible(SupportTicketDetailsGui.window[1], false)
		
		addEventHandler("onClientGUIClick", SupportTicketDetailsGui.button[1], 
			function(button, state) 
				if (button == "left") then
					hideSupportTicketDetailsGui()
					showSupportOverviewGui()
					refreshSupportTickets()
				end
			end
		, false)
		
		addEventHandler("onClientGUIClick", SupportTicketDetailsGui.button[2], 
			function(button, state) 
				if (button == "left") then
					if (guiGetText(SupportTicketDetailsGui.memo[2]) ~= "") then
						triggerServerEvent("onPlayerAnswerTicket", getRootElement(), tonumber(guiGetText(SupportTicketDetailsGui.edit[1])), guiGetText(SupportTicketDetailsGui.memo[2]))
						guiSetText(SupportTicketDetailsGui.memo[2], "")
					end
					hideSupportTicketDetailsGui()
					showSupportOverviewGui()
					refreshSupportTickets()
				end
			end
		, false)
    end
)


function showSupportTicketDetailsGui(TID)
	if (not (clientBusy)) then
		hideSupportTicketDetailsGui()
		clientBusy = true
		guiSetInputEnabled(true)
		showCursor(true)
		toggleAllControls(false)
		
		for k,v in ipairs(SupportTickets) do
			if (v["ID"] == TID) then
				local str = ""
				for kk,vv in pairs(v["Answer"]) do
				 str = str..vv["Name"]..":\n"..vv["Text"].."\n"
				end
				guiSetText(SupportTicketDetailsGui.memo[1], v["Subject"].."\n\n"..v["Text"].."\n\n"..str)
				
				guiSetText(SupportTicketDetailsGui.label[5], "Geschlossen")
				guiLabelSetColor(SupportTicketDetailsGui.label[5], 0, 255, 0)
				if (tonumber(v["State"]) == 0) then
					guiSetText(SupportTicketDetailsGui.label[5], "Offen")
					guiLabelSetColor(SupportTicketDetailsGui.label[5], 255, 0, 0)
				end
				guiSetText(SupportTicketDetailsGui.edit[1], tostring(TID))
				break;
			end
		end
		guiSetVisible(SupportTicketDetailsGui.window[1], true)
	end
end

function hideSupportTicketDetailsGui()
	clientBusy = false
	guiSetInputEnabled(false)
	showCursor(false)
	toggleAllControls(true)
	guiSetVisible(SupportTicketDetailsGui.window[1], false)
end