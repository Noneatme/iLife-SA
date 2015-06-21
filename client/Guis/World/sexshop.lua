--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

SexWeaponprices = {
["Weapon"] = 
	{
		["Blumen"] = 25,
		["Vibrator"] = 175,
		["Lilaner Dildo"] = 150,
		["Kurzer Dildo"] = 150
	}
}

Sexshop = {
	["Window"] = false,
	["Image"] = {},
	["Button"] = {},
	["Label"] = {},
	["List"] = {}
}

function showSexshopGui()
	hideSexshopGui()
	
	Sexshop["Window"] = new(CDxWindow, "Sexshop", 502, 327, true, true, "Center|Middle")
	
	Sexshop["Image"][1] = new(CDxImage, 0, 0, 500, 297, "/res/images/sexshop.png",tocolor(255,255,255,255), Sexshop["Window"])
	Sexshop["Image"][2] = new(CDxImage, 5, 81, 77, 71, false,tocolor(255,255,255,255), Sexshop["Window"])
	
	Sexshop["Label"][1] = new(CDxLabel, "Wählen sie ein Produkt aus!", 6, 160, 185, 155, tocolor(255,255,255,255), 1.0, "default", "left", "top", Sexshop["Window"])
	
	Sexshop["Label"][2] = new(CDxLabel, "Preis: ", 97, 105, 165, 102, tocolor(255,255,255,255), 1, "default", "left", "top", Sexshop["Window"])
	Sexshop["Label"][3] = new(CDxLabel, "Produkt:", 89, 80, 157, 77, tocolor(255,255,255,255), 1, "default-bold", "left", "top", Sexshop["Window"])	
	
	Sexshop["List"][1] = new(CDxList, 197, 6, 295, 233, tocolor(125,125,125,200), Sexshop["Window"])
	
	Sexshop["Button"][1] = new(CDxButton, "Produkt kaufen", 5, 184, 180, 40, tocolor(255,255,255,255), Sexshop["Window"])

	Sexshop["List"][1]:addColumn("Name")
	Sexshop["List"][1]:addColumn("Typ")
	
	Sexshop["List"][1]:addRow("Blumen|Geschenk")
	Sexshop["List"][1]:addRow("Vibrator|Werkzeug")
	Sexshop["List"][1]:addRow("Lilaner Dildo|Werkzeug")
	Sexshop["List"][1]:addRow("Kurzer Dildo|Werkzeug")
	
	Sexshop["Label"][2]:setColorCoded(true)
	
	Sexshop["Button"][1]:addClickFunction(
		function ()
			triggerServerEvent("onPlayerBuySexWeapon", getLocalPlayer(), Sexshop["List"][1]:getRowData(1))
		end
	)
	
	Sexshop["List"][1]:addClickFunction(
		function()
			Sexshop["Label"][2]:setText("Preis: #00FF00"..tostring(SexWeaponprices["Weapon"][Sexshop["List"][1]:getRowData(1)]).."$")
			
			Sexshop["Image"][2]:setImage("/res/images/iroticx/"..Sexshop["List"][1]:getRowData(1)..".png")
		end
	)
	
	Sexshop["Window"]:add(Sexshop["Image"][1])
	Sexshop["Window"]:add(Sexshop["Image"][2])
	Sexshop["Window"]:add(Sexshop["Label"][1])
	Sexshop["Window"]:add(Sexshop["Label"][2])
	Sexshop["Window"]:add(Sexshop["Label"][3])
	Sexshop["Window"]:add(Sexshop["List"][1])
	Sexshop["Window"]:add(Sexshop["Button"][1])
	
	Sexshop["Window"]:show()
end
addEvent("showSexshopGui", true)
addEventHandler("showSexshopGui", getRootElement(), showSexshopGui)

function hideSexshopGui()
	if (Sexshop["Window"]) then
		Sexshop["Window"]:hide()
		delete(Sexshop["Window"])
		Sexshop["Window"] = false
	end
end
addEvent("hideSexshopGui", true)
addEventHandler("hideSexshopGui", getRootElement(), hideSexshopGui)

function refreshSexshopGui()
	setTimer(
		function()
		end
	, 1000, 1
	)
end
addEvent("refreshSexshopGui", true)
addEventHandler("refreshSexshopGui", getRootElement(), refreshSexshopGui)