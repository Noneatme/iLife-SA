--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onMinerJobMarkerHit", true)
addEventHandler("onMinerJobMarkerHit", getRootElement(),
	function(difficulty)
		
		local diffs = {
			[1] = "Extrem Einfach",
			[2] = "Ziemlich Einfach",
			[3] = "Einfach",
		}
		
		local times = {
			[1] = "2 Minuten",
			[2] = "3 Minuten",
			[3] = "4 Minuten",
		}
		
		local goods = {
			[1] = "Eisen",
			[2] = "Eisen",
			[3] = "Eisen",
		}
	
		MinerJobStartGui["Window"] = new(CDxWindow, "Angebot", 200, 320, true, true, "Center|Middle")
		MinerJobStartGui["Label"][1] = new(CDxLabel, "Hier können Rohstoffe abgebaut werden. Die Rohstoffe können an anderen Orten weiterverarbeitet werden!\n\nAchtung: Dieser Job erfordert logisches Denken und ist nicht für Anfänger geeignet!\n\nSchwierigkeit: "..diffs[difficulty].."\nRohstoff: "..goods[difficulty].."\nAufwand: "..times[difficulty].."", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", MinerJobStartGui["Window"])
		MinerJobStartGui["Button"][1] = new(CDxButton, "Für Geld arbeiten", 5, 210, 190, 35, tocolor(255,255,255,255), MinerJobStartGui["Window"])
		MinerJobStartGui["Button"][2] = new(CDxButton, "Für Rohstoffe arbeiten", 5, 250, 190, 35, tocolor(255,255,255,255), MinerJobStartGui["Window"])
		
		MinerJobStartGui["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onClientMinerJobStart", getRootElement(), difficulty, 1)
				MinerJobStartGui["Window"]:hide()
				delete(MinerJobStartGui["Window"])
				MinerJobStartGui["Window"] = false
			end
		)
		
		MinerJobStartGui["Button"][2]:addClickFunction(
			function()
				triggerServerEvent("onClientMinerJobStart", getRootElement(), difficulty, 2)
				MinerJobStartGui["Window"]:hide()
				delete(MinerJobStartGui["Window"])
				MinerJobStartGui["Window"] = false
			end
		)
		
		MinerJobStartGui["Window"]:add(MinerJobStartGui["Label"][1])
		MinerJobStartGui["Window"]:add(MinerJobStartGui["Button"][1])
		MinerJobStartGui["Window"]:add(MinerJobStartGui["Button"][2])
		MinerJobStartGui["Window"]:show()
	end
)

MinerJobStartGui = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

local Miner = false
addEvent("onServerSubmitMinerJob", true)
addEventHandler("onServerSubmitMinerJob", getRootElement(),
	function(difficulty, typ)
		if (difficulty == 1) then
			Miner = new(CMineSweeper, 9, 9, 30, 10)
		end
		if (difficulty == 2) then
			Miner = new(CMineSweeper, 16, 16, 25, 40)
		end
		if (difficulty == 3) then
			Miner = new(CMineSweeper, 30, 16, 20, 99)
		end
		
		showInfoBox("info", "Sichere die Rohstoffe!")
		toggleAllControls(false)
		hud:Toggle(false)
		showChat(false)
		clientBusy = true
		showCursor(true)

		addEventHandler("onClientRender", getRootElement(), additionalMinerRender)
		Miner:start()
	end
)

local HandleTick = false
function additionalMinerRender()
	if (Miner:isFinished()) then
		if (HandleTick) then
			if ((getTickCount()-HandleTick)>5000) then
				HandleTick = false
				removeEventHandler("onClientRender", getRootElement(), additionalMinerRender)
				triggerServerEvent("onClientMinerJobFinish", getRootElement(), Miner:getStatus() == 2)
				
				toggleAllControls(true)
				hud:Toggle(true)
				showChat(true)
				clientBusy = false
				showCursor(false)
				delete(Miner)
				Miner = false
			end
		else
			HandleTick = getTickCount()
		end	
	end
end