--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ChangeSpawn = {
	["Window"] = false,
	["Image"] = {},
	["List"] = {},
	["Label"] = {},
	["Button"] = {}
}

function showChangeSpawnGui()
	if (not clientBusy) then
		hideChangeSpawnGui()
		
		ChangeSpawn["Window"] = new(CDxWindow, "Spieler", 500, 310, true, true, "Center|Middle")
		
		ChangeSpawn["Label"][1] = new(CDxLabel, "Feste Spawnpositionen greifen nur, wenn ein Spieler mindestens 15 Minuten ausgeloggt war.", 9, 10, 482, 90, tocolor(255,0,0,255), 1, "clear", "center", "top", ChangeSpawn["Window"])
		
		ChangeSpawn["List"][1] = new(CDxList, 10, 60, 480, 150, tocolor(125,125,125,200), ChangeSpawn["Window"])
		ChangeSpawn["List"][1]:addColumn("Spawnposition")

		ChangeSpawn["List"][1]:addRow("Dynamische Position")
		ChangeSpawn["List"][1]:addRow("Aktuelle Position")
		ChangeSpawn["List"][1]:addRow("Stadthalle LS")
		ChangeSpawn["List"][1]:addRow("Pier LS")
		ChangeSpawn["List"][1]:addRow("Hafen LS")
		
		ChangeSpawn["Button"][1] = new(CDxButton, "Auswählen", 10, 230, 480, 42, tocolor(255,255,255,255), ChangeSpawn["Window"])
		
		ChangeSpawn["Button"][1]:addClickFunction(
			function()
				if (ChangeSpawn["List"][1]:getRowData(1) ~= "nil") then
					hideChangeSpawnGui()
					triggerServerEvent("onPlayerChangeSpawn", getLocalPlayer(), ChangeSpawn["List"][1]:getRowData(1))
				else
					showInfoBox("error", "Du musst einen Spawn auswählen!")
				end
			end
		)
		ChangeSpawn["Window"]:add(ChangeSpawn["Label"][1])
		ChangeSpawn["Window"]:add(ChangeSpawn["List"][1])
		ChangeSpawn["Window"]:add(ChangeSpawn["Button"][1])
		ChangeSpawn["Window"]:show()
	end
end

function hideChangeSpawnGui()
	if (ChangeSpawn["Window"]) then
		ChangeSpawn["Window"]:hide()
		delete(ChangeSpawn["Window"])
		ChangeSpawn["Window"] = false
	end
end