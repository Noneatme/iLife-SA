--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[

addEventHandler("onClientResourceStart", resourceRoot,
    function()
    end
)

addEventHandler("onClientRender", root,
    function()
        --------------dxDrawImage(0, 0, 500, 245, ":ilife/res/images/ammunation.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
        --------------dxDrawRectangle(197, 6, 295, 233, tocolor(255, 255, 255, 255), true)
        --------------dxDrawRectangle(5, 61, 77, 71, tocolor(255, 255, 255, 255), true)

		-------------dxDrawText("Waffe:", 97, 85, 165, 102, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
        -------------dxDrawText("Magazin:", 85, 101, 153, 118, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
        -------------dxDrawText("Preise:", 89, 60, 157, 77, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "top", false, false, true, false, false)
        -------------dxDrawText("Wählen sie ein Produkt aus!", 6, 140, 185, 155, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)

		dxDrawRectangle(5, 164, 180, 35, tocolor(255, 255, 255, 255), true)
        dxDrawRectangle(5, 204, 180, 35, tocolor(255, 255, 255, 255), true)
    end
)
]]

Weaponprices = {
["Weapon"] =
	{
		["9mm"] = 450,
		["Desert Eagle"] = 1100,
		["Shotgun"] = 950,
		["Uzi"] = 1250,
		["MP5"] = 1750,
		["Country Rifle"] = 2150,
		["AK-47"] = 3450,
		["M4"] = 5500,
        ["Armor"] = 450,
	},
["Ammu"] =
	{
		["9mm"] = 110,
		["Desert Eagle"] = 240,
		["Shotgun"] = 10,
		["Uzi"] = 270,
		["MP5"] = 320,
		["Country Rifle"] = 15,
		["AK-47"] = 450,
		["M4"] = 625
	}
}

Ammunation = {
	["Window"] = false,
	["Image"] = {},
	["Button"] = {},
	["Label"] = {},
	["List"] = {}
}

function showAmmunationGui(iF, iC)
	hideAmmunationGui()

	Ammunation["Window"] = new(CDxWindow, "Ammunation", 502, 327, true, true, "Center|Middle")

	Ammunation["Image"][1] = new(CDxImage, 0, 0, 500, 297, "/res/images/ammunation.png",tocolor(255,255,255,255), Ammunation["Window"])
	Ammunation["Image"][2] = new(CDxImage, 5, 81, 77, 71, false,tocolor(255,255,255,255), Ammunation["Window"])

	Ammunation["Label"][1] = new(CDxLabel, "Wählen sie ein Produkt aus!", 6, 160, 185, 155, tocolor(255,255,255,255), 1.0, "default", "left", "top", Ammunation["Window"])

	Ammunation["Label"][2] = new(CDxLabel, "Waffe: ", 97, 105, 165, 102, tocolor(255,255,255,255), 1, "default", "left", "top", Ammunation["Window"])
	Ammunation["Label"][3] = new(CDxLabel, "Magazin: ", 85, 121, 153, 118, tocolor(255,255,255,255), 1, "default", "left", "top", Ammunation["Window"])
	Ammunation["Label"][4] = new(CDxLabel, "Preise:", 89, 80, 157, 77, tocolor(255,255,255,255), 1, "default-bold", "left", "top", Ammunation["Window"])

	Ammunation["List"][1] = new(CDxList, 197, 6, 295, 233, tocolor(125,125,125,200), Ammunation["Window"])

	Ammunation["Button"][1] = new(CDxButton, "Waffen kaufen", 5, 184, 180, 35, tocolor(255,255,255,255), Ammunation["Window"])
	Ammunation["Button"][2] = new(CDxButton, "Magazin kaufen", 5, 224, 180, 35, tocolor(255,255,255,255), Ammunation["Window"])

	Ammunation["List"][1]:addColumn("Name")
	Ammunation["List"][1]:addColumn("Typ")
	Ammunation["List"][1]:addColumn("Magazingröße")

	Ammunation["List"][1]:addRow("9mm|Pistole|17")
	Ammunation["List"][1]:addRow("Desert Eagle|Pistole|7")
	Ammunation["List"][1]:addRow("Shotgun|Schrotflinte|1")
	Ammunation["List"][1]:addRow("Uzi|Maschinenpistole|50")
	Ammunation["List"][1]:addRow("MP5|Maschinenpistole|30")
	Ammunation["List"][1]:addRow("Country Rifle|Gewehr|1")
	Ammunation["List"][1]:addRow("AK-47|Sturmgewehr|30")
	Ammunation["List"][1]:addRow("M4|Sturmgewehr|50")
    Ammunation["List"][1]:addRow("Armor|Schutzweste|100")

	Ammunation["Label"][2]:setColorCoded(true)
	Ammunation["Label"][3]:setColorCoded(true)

	Ammunation["Button"][1]:addClickFunction(
		function ()
			triggerServerEvent("onPlayerBuyWeapon", getLocalPlayer(), Ammunation["List"][1]:getRowData(1), iF, iC)
		end
	)

	Ammunation["Button"][2]:addClickFunction(
		function ()
			triggerServerEvent("onPlayerBuyAmmo", getLocalPlayer(), Ammunation["List"][1]:getRowData(1), iF, iC)
		end
	)

	Ammunation["List"][1]:addClickFunction(
		function()
			Ammunation["Label"][2]:setText("Waffe: #00FF00"..tostring(Weaponprices["Weapon"][Ammunation["List"][1]:getRowData(1)]).."$")
			Ammunation["Label"][3]:setText("Magazin: #00FF00"..tostring(Weaponprices["Ammu"][Ammunation["List"][1]:getRowData(1)]).."$")

			Ammunation["Image"][2]:setImage("/res/images/weapons/"..Ammunation["List"][1]:getRowData(1)..".png")
		end
	)

	Ammunation["Window"]:add(Ammunation["Image"][1])
	Ammunation["Window"]:add(Ammunation["Image"][2])
	Ammunation["Window"]:add(Ammunation["Label"][1])
	Ammunation["Window"]:add(Ammunation["Label"][2])
	Ammunation["Window"]:add(Ammunation["Label"][3])
	Ammunation["Window"]:add(Ammunation["Label"][4])
	Ammunation["Window"]:add(Ammunation["List"][1])
	Ammunation["Window"]:add(Ammunation["Button"][1])
	Ammunation["Window"]:add(Ammunation["Button"][2])

	Ammunation["Window"]:show()
end
addEvent("showAmmunationGui", true)
addEventHandler("showAmmunationGui", getRootElement(), showAmmunationGui)

function hideAmmunationGui()
	if (Ammunation["Window"]) then
		Ammunation["Window"]:hide()
		delete(Ammunation["Window"])
		Ammunation["Window"] = false
	end
end
addEvent("hideAmmunationGui", true)
addEventHandler("hideAmmunationGui", getRootElement(), hideAmmunationGui)

function refreshAmmunationGui()
	setTimer(
		function()
		end
	, 1000, 1
	)
end
addEvent("refreshAmmunationGui", true)
addEventHandler("refreshAmmunationGui", getRootElement(), refreshAmmunationGui)
