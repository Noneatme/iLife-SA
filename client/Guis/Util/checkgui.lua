--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CheckGui = {
	["Window"] = false,
	["Button"] = {},
	["Label"] = {},
	["Edit"] = {},
	["Image"] = {}
}

local name = "?"
local register = "?"
local login = "?"
local geld = "?"
local bank = "?"
local banned = "?"
local online = "?" 
local skinid = 0

function showCheckGui()
	hideCheckGui()
	CheckGui["Window"] = new(CDxWindow, "Spieler prüfen", 303, 264, true, true, "Center|Middle")
	
	CheckGui["Button"][1] = new(CDxButton, "Suchen", 160, 60, 75, 23, tocolor(255,255,255,255), CheckGui["Window"])
	
	CheckGui["Edit"][1] = new(CDxEdit, "", 130, 30, 161, 21, "normal", tocolor(0,0,0,255), CheckGui["Window"])
	
	CheckGui["Button"][1]:addClickFunction(
		function()
			if (CheckGui["Edit"][1]:getText() ~= "") then
				triggerServerEvent("getPlayerCheckInformation",localPlayer,CheckGui["Edit"][1]:getText())
				
			else
				showInfoBox("error", "Du musst etwas eingeben!")
			end
		end
	)
	
	CheckGui["Label"][1] = new(CDxLabel, "Name: "..name, 10, 90, 111, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][2] = new(CDxLabel, "Registriert: "..register, 10, 110, 131, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][3] = new(CDxLabel, "Letzter Login: "..login, 10, 130, 181, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][4] = new(CDxLabel, "Geld: "..geld.."$", 10, 150, 131, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][5] = new(CDxLabel, "Bankgeld: "..bank.."$", 10, 170, 131, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][6] = new(CDxLabel, "Gebannt: "..banned, 10, 190, 81, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	CheckGui["Label"][7] = new(CDxLabel, "Online: "..online, 10, 210, 71, 16, tocolor(255,255,255,255), 1, "default", "left", "top", CheckGui["Window"])
	
	CheckGui["Image"][1] = new(CDxImage, 0, 0, 121, 81, "res/images/hud/skins/"..skinid..".jpg",tocolor(255,255,255,255), CheckGui["Window"])
	
	CheckGui["Window"]:add(CheckGui["Button"][1])
	
	CheckGui["Window"]:add(CheckGui["Label"][1])
	CheckGui["Window"]:add(CheckGui["Label"][2])
	CheckGui["Window"]:add(CheckGui["Label"][3])
	CheckGui["Window"]:add(CheckGui["Label"][4])
	CheckGui["Window"]:add(CheckGui["Label"][5])
	CheckGui["Window"]:add(CheckGui["Label"][6])
	CheckGui["Window"]:add(CheckGui["Label"][7])
	
	CheckGui["Window"]:add(CheckGui["Image"][1])
	
	CheckGui["Window"]:add(CheckGui["Edit"][1])
	
	CheckGui["Window"]:show()
end
addEvent("showCheckGui", true)
addEventHandler("showCheckGui", getRootElement(), showCheckGui)

function hideCheckGui()
	if (CheckGui["Window"]) then
		CheckGui["Window"]:hide()
		delete(CheckGui["Window"])
		CheckGui["Window"] = false
	end
end
addEvent("closeCheckGui", true)
addEventHandler("closeCheckGui", getRootElement(), hideCheckGui)

addEvent("givePlayerCheckInformation1",true)
addEvent("givePlayerCheckInformation2",true)
addEvent("givePlayerCheckInformation3",true)

addEventHandler("givePlayerCheckInformation1",getRootElement(),
function(result1)
	
	name = result1[1]["Name"]
	register = result1[1]["Register_Date"]
	login = result1[1]["Last_Login"]
	
	online = "Nein"
	for i,v in ipairs(getElementsByType("player")) do
		if getPlayerName(v) == name then
			online = "Ja"
		end
	end
	
end)

addEventHandler("givePlayerCheckInformation2",getRootElement(),
function(result2)
	
	geld = result2[1]["Geld"]
	bank = result2[1]["Bankgeld"]
	skinid = tonumber(result2[1]["Skin"])
end)

addEventHandler("givePlayerCheckInformation3",getRootElement(),
function(result3)
	
	banned = result3
	showCheckGui()
end)