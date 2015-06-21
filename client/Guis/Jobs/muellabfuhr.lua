--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

muellabfuhr = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onClientMuellabfuhrMarkerHit", true)
addEventHandler("onClientMuellabfuhrMarkerHit", getRootElement(), function()
	muellabfuhr["Window"] = new(CDxWindow, "Muellabfuhr!", 200, 320, true, true, "Center|Middle")
	muellabfuhr["Label"][1] = new(CDxLabel, "Wilkommen bei der Muellabfuhr!\nHier haben Sie die Möglichkeit in kuerzester Zeit etwas Geld zu verdienen.\n\nLeeren sie die ausgewählte Muelltonne.", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", muellabfuhr["Window"])
	muellabfuhr["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), muellabfuhr["Window"])
	
	muellabfuhr["Button"][1]:addClickFunction(
		function()
			triggerServerEvent("onMuellabfuhrStart", getLocalPlayer())
			muellabfuhr["Window"]:hide()
			delete(muellabfuhr["Window"])
			muellabfuhr["Window"] = false
			setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
		end
	)
	
	muellabfuhr["Window"]:add(muellabfuhr["Label"][1])
	muellabfuhr["Window"]:add(muellabfuhr["Button"][1])
	muellabfuhr["Window"]:show()
end
)