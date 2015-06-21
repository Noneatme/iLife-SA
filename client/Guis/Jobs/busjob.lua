--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Busjob = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onBJStartMarkerHit", true)
addEventHandler("onBJStartMarkerHit", getRootElement(), function()
	if not(clientBusy) then
		Busjob["Window"] = new(CDxWindow, "Los Santos Busline", 200, 320, true, true, "Center|Middle")
		Busjob["Label"][1] = new(CDxLabel, "Wilkommen.\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu veridenen.\n\nFahren Sie die vorgegebene Strecke mit dem Bus ab und transportieren Sie die Fahrgäste.!\n\nVorraussetzungen: Fahrlizenz Klassen B,D", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", Busjob["Window"])
		Busjob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), Busjob["Window"])

		Busjob["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onClientBJStartPressed", getLocalPlayer())
				Busjob["Window"]:hide()
				delete(Busjob["Window"])
				Busjob["Window"] = false
				setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
			end
		)

		Busjob["Window"]:add(Busjob["Label"][1])
		Busjob["Window"]:add(Busjob["Button"][1])
		Busjob["Window"]:show()
	end
end
)

addEvent("onTruckerStartMarkerHit", true)
addEventHandler("onTruckerStartMarkerHit", getRootElement(), function()
	if not(clientBusy) then
		Busjob["Window"] = new(CDxWindow, "Truckerjob", 200, 320, true, true, "Center|Middle")
		Busjob["Label"][1] = new(CDxLabel, "Wilkommen.\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu veridenen.\n\nFahren Sie die Ware mit einem Truck ab und transportieren Sie die Ware schnell!\n\nVorraussetzungen: Fahrlizenz Klassen B,D", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", Busjob["Window"])
		Busjob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), Busjob["Window"])

		Busjob["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onTruckerStartMarkerHitDo", getLocalPlayer())
				Busjob["Window"]:hide()
				delete(Busjob["Window"])
				Busjob["Window"] = false
				setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
			end
		)

		Busjob["Window"]:add(Busjob["Label"][1])
		Busjob["Window"]:add(Busjob["Button"][1])
		Busjob["Window"]:show()
	end
end
)
