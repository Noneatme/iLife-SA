--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ChooseStatus = {
	["Window"] = false,
	["Image"] = {},
	["List"] = {},
	["Button"] = {}
}

function showChooseStatusGui()
	if (not clientBusy) then
		hideChooseStatusGui()
		
		ChooseStatus["Window"] = new(CDxWindow, "Spieler", 500, 350, true, true, "Center|Middle")
		
		ChooseStatus["List"][1] = new(CDxList, 10, 10, 480, 250, tocolor(125,125,125,200), ChooseStatus["Window"])
		ChooseStatus["List"][1]:addColumn("Status")
		--ChooseStatus["List"][1]:addColumn("Ausgewählt")
		
		for s,b in pairs(getElementData(localPlayer, "All_Status")) do
			ChooseStatus["List"][1]:addRow(s)
		end
		
		ChooseStatus["Button"][1] = new(CDxButton, "Auswählen", 10, 270, 480, 42, tocolor(255,255,255,255), ChooseStatus["Window"])
		
		ChooseStatus["Button"][1]:addClickFunction(
			function()
				if (ChooseStatus["List"][1]:getRowData(1) ~= "nil") then
					hideChooseStatusGui()
					triggerServerEvent("onPlayerChooseStatus", getLocalPlayer(), ChooseStatus["List"][1]:getRowData(1))
				else
					showInfoBox("error", "Du musst einen Status auswählen!")
				end
			end
		)
		
		ChooseStatus["Window"]:add(ChooseStatus["List"][1])
		ChooseStatus["Window"]:add(ChooseStatus["Button"][1])
		ChooseStatus["Window"]:show()
	end
end

function hideChooseStatusGui()
	if (ChooseStatus["Window"]) then
		ChooseStatus["Window"]:hide()
		delete(ChooseStatus["Window"])
		ChooseStatus["Window"] = false
	end
end