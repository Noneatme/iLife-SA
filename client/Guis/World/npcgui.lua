--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

NPCGui = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {}
}

function showNPCGui(NPCData)
	if (not clientBusy) then
		NPCGui["Window"] = new(CDxWindow, "Konversation", 200, 320, true, true, "Center|Middle")
		NPCGui["Label"][1] = new(CDxLabel, "", 5, 0, 190, 230, tocolor(255,255,255,255), 1, "default", "left", "center", NPCGui["Window"])
		
		NPCGui["Button"][1] = new(CDxButton, "Auf Wiedersehen!", 5, 250, 190, 35, tocolor(255,255,255,255), NPCGui["Window"])
		NPCGui["Button"][1]:addClickFunction(
			function()
				hideNPCGui()
			end
		)
		
		NPCGui["Button"][2] = new(CDxButton, "Deal!", 5, 210, 190, 35, tocolor(255,255,255,255), NPCGui["Window"])
		NPCGui["Button"][2]:addClickFunction(
			function()
				hideNPCGui()
			end
		)
		
		NPCGui["Window"]:add(NPCGui["Label"][1])
		NPCGui["Window"]:add(NPCGui["Button"][1])
		NPCGui["Window"]:show()
	end
end

function hideNPCGui()
	if (NPCGui["Window"]) then
		NPCGui["Window"]:hide()
		delete(NPCGui["Window"])
		NPCGui["Window"] = false
		clientBusy = false
	end
end