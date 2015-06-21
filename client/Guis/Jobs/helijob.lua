--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Helijob = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onHJMarkerHit", true)
addEventHandler("onHJMarkerHit", getRootElement(), function()
	Helijob["Window"] = new(CDxWindow, "Easy Transport", 200, 320, true, true, "Center|Middle")
	Helijob["Label"][1] = new(CDxLabel, "Wilkommen bei Easy Transport.\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu machen.\n\nHolen Sie mit dem Helikopter die Ware vom Hafen ab und transportiere sie zum Zielpunkt. Geld erhalten Sie, nachdem sie sich eine neue Ladung abgeholt haben!\n\nVorraussetzungen: Fluglizenz", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", Helijob["Window"])
	Helijob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), Helijob["Window"])
	
	Helijob["Button"][1]:addClickFunction(
		function()
			triggerServerEvent("onClientHJStartPressed", getLocalPlayer())
			Helijob["Window"]:hide()
			delete(Helijob["Window"])
			Helijob["Window"] = false
		end
	)
	
	Helijob["Window"]:add(Helijob["Label"][1])
	Helijob["Window"]:add(Helijob["Button"][1])
	Helijob["Window"]:show()
end
)