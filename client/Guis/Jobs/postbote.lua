--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

postbote = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onClientPostboteMarkerHit", true)
addEventHandler("onClientPostboteMarkerHit", getRootElement(), function()
	postbote["Window"] = new(CDxWindow, "Postamt!", 200, 320, true, true, "Center|Middle")
	postbote["Label"][1] = new(CDxLabel, "Wilkommen beim Postamt!\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu verdienen.\n\nLiefern sie die Ware zum Bestimmungsort.", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", postbote["Window"])
	postbote["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), postbote["Window"])
	
	postbote["Button"][1]:addClickFunction(
		function()
			triggerServerEvent("onPostboteStart", getLocalPlayer())
			postbote["Window"]:hide()
			delete(postbote["Window"])
			postbote["Window"] = false
			setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
		end
	)
	
	postbote["Window"]:add(postbote["Label"][1])
	postbote["Window"]:add(postbote["Button"][1])
	postbote["Window"]:show()
end
)