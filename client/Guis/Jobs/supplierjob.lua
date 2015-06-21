--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Supplierjob = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onClientSupplierjobMarkerHit", true)
addEventHandler("onClientSupplierjobMarkerHit", getRootElement(), function()
	if not(clientBusy) then
		Supplierjob["Window"] = new(CDxWindow, "Truck 'n Go!", 200, 320, true, true, "Center|Middle")
		Supplierjob["Label"][1] = new(CDxLabel, "Wilkommen bei Truck 'n Go!\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu verdienen.\n\nLiefern sie die Ware zum Bestimmungsort.\n\nVorraussetzungen: Führerschein Klassen B,C", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", Supplierjob["Window"])
		Supplierjob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), Supplierjob["Window"])
		
		Supplierjob["Button"][1]:addClickFunction(
			function()
				triggerServerEvent("onSupplierJobStart", getLocalPlayer())
				Supplierjob["Window"]:hide()
				delete(Supplierjob["Window"])
				Supplierjob["Window"] = false
				setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
			end
		)
		
		Supplierjob["Window"]:add(Supplierjob["Label"][1])
		Supplierjob["Window"]:add(Supplierjob["Button"][1])
		Supplierjob["Window"]:show()
	end
end
)