--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

GoodFactions = {[1]=true, [2]=true}

PD_Comp_Selected_Player = ""
PD_Comp_Last_Scroll = 0

PDComputer = {
	["Window"] = false,
	["Image"] = {},
	["Button"] = {},
	["Label"] = {},
	["Edit"] = {},
	["List"] = {},
	["Timer"] = {}
}



function showPDComputerGui()
	PDComputer["Window"] = new(CDxWindow, "Polizeidatenbank", 620, 470, true, true, "Center|Middle")
	PDComputer["Image"][1] = new(CDxImage, 0, 0, 620, 453, "/res/images/pdcomputer.png",tocolor(255,255,255,255), PDComputer["Window"])
	PDComputer["Label"][1] = new(CDxLabel, "San Andreas Police Department", 77, 6, 496, 52, tocolor(255,255,255,255), 0.70, "bankgothic", "left", "top", PDComputer["Window"])
	PDComputer["Label"][2] = new(CDxLabel, "Spieler: ", 79, 55, 207, 76, tocolor(255,255,255,255), 1, "bankgothic", "left", "top", PDComputer["Window"])
	PDComputer["Label"][3] = new(CDxLabel, "Grund: ", 221, 89, 449, 105, tocolor(255,255,255,255), 1, "default", "left", "top", PDComputer["Window"])
	PDComputer["List"][1] = new(CDxList, 11, 93, 196, 355, tocolor(125,125,125,200), PDComputer["Window"])
	PDComputer["List"][2] = new(CDxList, 222, 108, 380, 300, tocolor(125,125,125,200), PDComputer["Window"])
	PDComputer["Button"][1] = new(CDxButton, "Orten", 222, 48, 380, 37, tocolor(255,255,255,255), PDComputer["Window"])
	PDComputer["Button"][2] = new(CDxButton, "Wanted löschen", 222, 415, 185, 37, tocolor(255,255,255,255), PDComputer["Window"])
	PDComputer["Button"][3] = new(CDxButton, "Wanted geben", 417, 415, 185, 37, tocolor(255,255,255,255), PDComputer["Window"])
	
	PDComputer["List"][1]:addColumn("Name")
	PDComputer["List"][1]:addColumn("Wanteds")
	
	PDComputer["List"][2]:addColumn("Wanteds")
	PDComputer["List"][2]:addColumn("Name")
	
	PDComputer["List"][2]:addRow("1|Körperverletzung")
	PDComputer["List"][2]:addRow("1|Täuschung (Lügen)")
	PDComputer["List"][2]:addRow("1|Beamtenbehinderung")
	PDComputer["List"][2]:addRow("1|Lärmbelästigung")
	PDComputer["List"][2]:addRow("1|Fahrerflucht")
	PDComputer["List"][2]:addRow("1|Beihilfe zur Flucht")
	PDComputer["List"][2]:addRow("1|Beamtenbelästugung")
	PDComputer["List"][2]:addRow("1|Beleidigung")
	PDComputer["List"][2]:addRow("1|Befehlsverweigerung")
	PDComputer["List"][2]:addRow("1|Fahren ohne Fahrerlaubis")
	PDComputer["List"][2]:addRow("1|Sachbeschädigung")
	PDComputer["List"][2]:addRow("1|Beihilfe zum Rubüberfall")
	PDComputer["List"][2]:addRow("1|Drogenkonsum")
	PDComputer["List"][2]:addRow("1|Drohung und Erpressung")
	PDComputer["List"][2]:addRow("1|Diebstahl")

	PDComputer["List"][2]:addRow("2|Waffennutzung (Schusswaffen)")
	PDComputer["List"][2]:addRow("2|Verweigerung (Durchsuchung)")
	PDComputer["List"][2]:addRow("2|Drogenhandel")
	PDComputer["List"][2]:addRow("2|Bestechungsversuch")
	PDComputer["List"][2]:addRow("2|Waffenverkauf")
	PDComputer["List"][2]:addRow("2|Waffenschmuggel")
	PDComputer["List"][2]:addRow("2|Überfall (Person)")
	PDComputer["List"][2]:addRow("2|Überfall (Geschäft)")
	PDComputer["List"][2]:addRow("2|Mitführen illegaler Gegenstände")
	PDComputer["List"][2]:addRow("2|Illegale Straßenrennen")
	
	PDComputer["List"][2]:addRow("3|Unerlaubtes Betreten von Staatsgelände")
	PDComputer["List"][2]:addRow("3|Ausrauben von Versorgungshelikoptern")
	PDComputer["List"][2]:addRow("3|Waffentruck")

	PDComputer["List"][2]:addRow("4|Mord (oder Beihilfe)")
	
	PDComputer["List"][2]:addRow("5|Geiselnahme")
	PDComputer["List"][2]:addRow("5|Massenmord")

	PDComputer["List"][2]:addRow("6|Terrorismus")	
	
	PD_Comp_Last_Scroll = 0
	PD_Comp_Selected_Player = ""
	
	refreshPDComputerGui()
	
	PDComputer["Button"][1]:addClickFunction(
	function ()
		triggerServerEvent("onCopLocatePlayer", getLocalPlayer(), PDComputer["List"][1]:getRowData(1))
	end
	)
	
	PDComputer["Button"][2]:addClickFunction(
	function ()
		triggerServerEvent("onCopDeleteWanted", getLocalPlayer(), PDComputer["List"][1]:getRowData(1), "Akte gelöscht.")
		PD_Comp_Selected_Player = PDComputer["List"][1]:getRowData(1)
		PD_Comp_Last_Scroll = PDComputer["List"][1].Scroll
	end
	)
	
	PDComputer["Button"][3]:addClickFunction(
	function ()
		if  (PDComputer["List"][2]:getRowData(1) ~= "nil") then
			triggerServerEvent("onCopGiveWanted", getLocalPlayer(), PDComputer["List"][1]:getRowData(1), tonumber(PDComputer["List"][2]:getRowData(1)), PDComputer["List"][2]:getRowData(2))
			PD_Comp_Selected_Player = PDComputer["List"][1]:getRowData(1)
			PD_Comp_Last_Scroll = PDComputer["List"][1].Scroll
		else
			showInfoBox("error", "Du musst einen Grund auswählen!")
		end
	end
	)

	PDComputer["Window"]:add(PDComputer["Image"][1])
	PDComputer["Window"]:add(PDComputer["Label"][1])
	PDComputer["Window"]:add(PDComputer["Label"][2])
	PDComputer["Window"]:add(PDComputer["Label"][3])
	PDComputer["Window"]:add(PDComputer["List"][1])
	PDComputer["Window"]:add(PDComputer["List"][2])
	PDComputer["Window"]:add(PDComputer["Button"][1])
	PDComputer["Window"]:add(PDComputer["Button"][2])
	PDComputer["Window"]:add(PDComputer["Button"][3])
	
	PDComputer["Window"]:show()
end

function hidePDComputerGui()
	if (PDComputer["Window"]) then
		PDComputer["Window"]:hide()
		delete(PDComputer["Window"])
		PDComputer["Window"] = false
	end
end

function togglePDComputer()
	if (PDComputer["Window"]) then
		hidePDComputerGui()
	else
		if (isPedInVehicle(localPlayer)) then
			if (GoodFactions[getElementData(getPedOccupiedVehicle(localPlayer), "Fraktion")]) then
				if (GoodFactions[getElementData(localPlayer, "Fraktion")]) then
					showPDComputerGui()
				end
			end
		end
	end
end

bindKey(_Gsettings.keys.WantedCP, "down", togglePDComputer)

function refreshPDComputerGui()
	if (PDComputer["Window"]) then
		PDComputer["List"][1]:clearRows()

		local PDPlayers = { [0]={},[1]={},[2]={},[3]={},[4]={},[5]={},[6]={}}
		
		for k, v in ipairs(getElementsByType("player")) do
			if (getElementData(v, "online")) then
				table.insert(PDPlayers[getElementData(v, "Wanteds")], v)
			end
		end
		
		for k, v in pairs(PDPlayers) do
			local a = {}
			for kk,vv in ipairs(v) do
				table.insert(a, getPlayerName(vv))
			end
			table.sort(a, function (a, b) return a:upper() < b:upper() end)
			PDPlayers[k] = {}
			for kpt,kss in ipairs(a) do
				table.insert(PDPlayers[k], getPlayerFromName(kss))
			end
		end
		
		for k=6,0,-1 do
			for kk,vv in ipairs(PDPlayers[k]) do
				PDComputer["List"][1]:addRow(getPlayerName(vv).."|"..getElementData(vv, "Wanteds"))
				if (PD_Comp_Selected_Player == getPlayerName(vv)) then
					PDComputer["List"][1]:setSelectedRow(PDComputer["List"][1]:getRowCount())
				end
			end
		end
		PDComputer["List"][1].Scroll = PD_Comp_Last_Scroll
	end
end
addEvent("refreshPDComputerGui", true)
addEventHandler("refreshPDComputerGui", getRootElement(), refreshPDComputerGui)