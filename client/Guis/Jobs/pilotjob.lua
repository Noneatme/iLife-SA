--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Pilotjob = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onClientPilotjobMarkerHit", true)
addEventHandler("onClientPilotjobMarkerHit", getRootElement(), function()
	Pilotjob["Window"] = new(CDxWindow, "Express Transports", 200, 320, true, true, "Center|Middle")
	Pilotjob["Label"][1] = new(CDxLabel, "Wilkommen Express Transports!\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu verdienen.\n\nFliegen Sie die Ware zum Bestimmungsort.\n\nVorraussetzungen: Fluglizenz", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", Pilotjob["Window"])
	Pilotjob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), Pilotjob["Window"])
	
	Pilotjob["Button"][1]:addClickFunction(
		function()
			triggerServerEvent("onPilotJobStart", getLocalPlayer())
			Pilotjob["Window"]:hide()
			delete(Pilotjob["Window"])
			Pilotjob["Window"] = false
			setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
		end
	)
	
	Pilotjob["Window"]:add(Pilotjob["Label"][1])
	Pilotjob["Window"]:add(Pilotjob["Button"][1])
	Pilotjob["Window"]:show()
end
)