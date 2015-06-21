--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Advertisment = {
	["Window"] = false,
	["Label"] = {},
	["Button"] = {},
	["gui_memo"] = {}
}

addEvent("onServerAdvertismentAccept", true)
addEventHandler("onServerAdvertismentAccept", getRootElement(), function(duration)
	hideInventoryGui()

	Advertisment["Window"] = new(CDxWindow, "Werbeantrag", 400, 290, true, true, "Center|Middle")
	
	local durstring = "Unbekannt"
	if (duration == 1) then
		durstring = "1 Stunde"
	end
	if (duration == 2) then
		durstring = "2 Stunden"
	end
	if (duration == 3) then
		durstring = "5 Stunden"
	end
	if (duration == 4) then
		durstring = "1 Tag"
	end
	if (duration == 5) then
		durstring = "1 Woche"
	end
	
	Advertisment["Label"][1] = new(CDxLabel, "Dauer: "..durstring, 5, 0, 390, 30, tocolor(255,255,255,255), 1, "default", "left", "center", Advertisment["Window"])
	Advertisment["Label"][2] = new(CDxLabel, "Text:", 5, 30, 390, 30, tocolor(255,255,255,255), 1, "default", "left", "center", Advertisment["Window"])
	Advertisment["Button"][1] = new(CDxButton, "Beantragen", 5, 220, 390, 35, tocolor(255,255,255,255), Advertisment["Window"])
	Advertisment["gui_memo"][1] = guiCreateMemo(5, 60, 390, 150, "", false)
	
	Advertisment["Button"][1]:addClickFunction(
		function()
			local text = guiGetText(Advertisment["gui_memo"][1])
			
			text = string.gsub(text, "ä", "\\ae")
			text = string.gsub(text, "ö", "\\oe")
			text = string.gsub(text, "ü", "\\ue")		
			text = string.gsub(text, "ß", "\\sz")	
			text = string.gsub(text, "Ä", "\\Ae")
			text = string.gsub(text, "Ö", "\\Oe")
			text = string.gsub(text, "Ü", "\\Ue")		
			
			if (text:len() > 150) then
				showInfoBox("error", "Der Text darf maximal 150 Zeichen enthalten!")
			else
				if (gettok(text, 7, "\n")) then
					showInfoBox("error", "Der Text darf maximal sechs Zeilen enthalten!")
				else
					triggerServerEvent("onClientSubmitAd", getRootElement(), duration, text)
				end
			end
			
			Advertisment["Window"]:hide()
			delete(Advertisment["Window"])
			Advertisment["Window"] = false
		end
	)
	
	Advertisment["Window"]:add(Advertisment["Label"][1])
	Advertisment["Window"]:add(Advertisment["Label"][2])
	Advertisment["Window"]:add(Advertisment["Button"][1])
	Advertisment["Window"]:addGE(Advertisment["gui_memo"][1])
	Advertisment["Window"]:show()
end
)