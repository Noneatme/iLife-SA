--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
addEvent("onLineJobMarkerHit", true)
addEventHandler("onLineJobMarkerHit", getRootElement(),
	function()
		LineJobStartGui["Window"] = new(CDxWindow, "Angebot", 200, 280, true, true, "Center|Middle")
		LineJobStartGui["Label"][1] = new(CDxLabel, "Hier können Rohstoffe abgebaut werden. Die Rohstoffe können an anderen Orten weiterverarbeitet werden!\n\nAchtung: Dieser Job erfordert logisches Denken und ist nicht für Anfänger geeignet!\n\nSchwierigkeit: "..diffs[difficulty].."\nRohstoff: "..goods[difficulty].."\nAufwand: "..times[difficulty].."", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", LineJobStartGui["Window"])
		LineJobStartGui["Button"][1] = new(CDxButton, "Für Geld arbeiten", 5, 210, 190, 35, tocolor(255,255,255,255), LineJobStartGui["Window"])
		
		LineJobStartGui["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onClientLineJobStart", getRootElement())
				LineJobStartGui["Window"]:hide()
				delete(LineJobStartGui["Window"])
				LineJobStartGui["Window"] = false
			end
		)
		
		LineJobStartGui["Window"]:add(LineJobStartGui["Label"][1])
		LineJobStartGui["Window"]:add(LineJobStartGui["Button"][1])
		LineJobStartGui["Window"]:show()
	end
)

LineJobStartGui = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

local Miner = false
addEvent("onLineJobStart", true)
addEventHandler("onLineJobStart", getRootElement(),
	function()
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
function additionalLineRender()
	if (Miner:isFinished()) then
		if (HandleTick) then
			if ((getTickCount()-HandleTick)>5000) then
				HandleTick = false
				removeEventHandler("onClientRender", getRootElement(), additionalMinerRender)
				triggerServerEvent("onClientLineJobFinish", getRootElement(), Miner:getStatus() == 2)
				
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
]]