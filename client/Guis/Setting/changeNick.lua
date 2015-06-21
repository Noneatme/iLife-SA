--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ChangeNick = {
	["Window"] = false,
	["Image"] = {},
	["Edit"] = {},
	["Label"] = {},
	["Button"] = {}
}

function showChangeNickGui()
	hideInventoryGui()
	if (not clientBusy) then
		hideChangeNickGui()
		
		ChangeNick["Window"] = new(CDxWindow, "Namen ändern", 500, 310, true, true, "Center|Middle")
		
		ChangeNick["Label"][1] = new(CDxLabel, "Achtung: Dies kann nur bezahlt rückgängig gemacht werden.", 9, 10, 482, 90, tocolor(255,0,0,255), 1, "clear", "center", "top", ChangeNick["Window"])
		
		ChangeNick["Label"][2] = new(CDxLabel, "Neuer Name:", 9, 50, 482, 30, tocolor(255,0,0,255), 1, "clear", "left", "top", ChangeNick["Window"])
		ChangeNick["Edit"][1] = new(CDxEdit, "", 9, 80, 480, 42, "", tocolor(0,0,0,255), ChangeNick["Window"])  
		
		ChangeNick["Label"][3] = new(CDxLabel, "Wiederholung:", 9, 140, 482, 30, tocolor(255,0,0,255), 1, "clear", "left", "top", ChangeNick["Window"])
		ChangeNick["Edit"][2] = new(CDxEdit, "", 9, 170, 480, 42, "", tocolor(0,0,0,255), ChangeNick["Window"])
		
		ChangeNick["Button"][1] = new(CDxButton, "Auswählen", 10, 230, 480, 42, tocolor(255,255,255,255), ChangeNick["Window"])
		
		ChangeNick["Button"][1]:addClickFunction(
			function()
				if (ChangeNick["Edit"][1]:getText() == ChangeNick["Edit"][2]:getText()) then
					if ( ChangeNick["Edit"][1]:getText() == clearNameFromBullshit(ChangeNick["Edit"][1]:getText()) ) then
						hideChangeNickGui()
						triggerServerEvent("onPlayerChangeName", getLocalPlayer(), ChangeNick["Edit"][1]:getText())
					else
						showInfoBox("error", "Der Namen enthält ungültige Zeichen!")
					end
				else
					showInfoBox("error", "Die Eingaben stimmen nicht überein!")
				end
			end
		)
		
		ChangeNick["Window"]:add(ChangeNick["Label"][1])
		ChangeNick["Window"]:add(ChangeNick["Label"][2])
		ChangeNick["Window"]:add(ChangeNick["Label"][3])
		ChangeNick["Window"]:add(ChangeNick["Edit"][1])
		ChangeNick["Window"]:add(ChangeNick["Edit"][2])
		ChangeNick["Window"]:add(ChangeNick["Button"][1])
		ChangeNick["Window"]:show()
	end
end

addEvent("onClientNamechangeOpen", true)
addEventHandler("onClientNamechangeOpen", getRootElement(), showChangeNickGui)

function hideChangeNickGui()
	if (ChangeNick["Window"]) then
		ChangeNick["Window"]:hide()
		delete(ChangeNick["Window"])
		ChangeNick["Window"] = false
	end
end

function clearNameFromBullshit(Name)
	return string.gsub(string.gsub(string.gsub(Name, '#%x%x%x%x%x%x', ''), '|', ''),'#','')
end