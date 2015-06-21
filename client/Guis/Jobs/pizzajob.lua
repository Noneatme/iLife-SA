--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

pizzajob = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

addEvent("onClientPizzajobMarkerHit", true)
addEventHandler("onClientPizzajobMarkerHit", getRootElement(), function()
	pizzajob["Window"] = new(CDxWindow, "The well stacked Pizza!", 200, 320, true, true, "Center|Middle")
	pizzajob["Label"][1] = new(CDxLabel, "Wilkommen bei The well stacked Pizza!\nHier haben Sie die Möglichkeit in kürzester Zeit etwas Geld zu verdienen.\n\nLiefern sie die Ware zum Bestimmungsort.", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", pizzajob["Window"])
	pizzajob["Button"][1] = new(CDxButton, "Starten", 5, 250, 190, 35, tocolor(255,255,255,255), pizzajob["Window"])
	
	pizzajob["Button"][1]:addClickFunction(
		function()
			triggerServerEvent("onPizzaJobStart", getLocalPlayer())
			pizzajob["Window"]:hide()
			delete(pizzajob["Window"])
			pizzajob["Window"] = false
			setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 1000,1)
		end
	)
	
	pizzajob["Window"]:add(pizzajob["Label"][1])
	pizzajob["Window"]:add(pizzajob["Button"][1])
	pizzajob["Window"]:show()
end
)