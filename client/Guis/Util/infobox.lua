--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

sX,sY = guiGetScreenSize()

Infobox = {
["Window"] = false,
["Label"] = {},
["Image"] = {},
}

Infobox["Window"] = new(CDxWindow, "Information", 310, 137, true, false, "Center|Top")
Infobox["Image"][1] = new(CDxImage, 5, 5, 95, 95, "res/images/infobox/info.png",tocolor(255,255,255,255), Infobox["Window"])
Infobox["Label"][1] = new(CDxLabel, "", 105, 0, 190, 110, tocolor(255,255,255,255), 1.2, "default", "center", "center", Infobox["Window"])

Infobox["Window"]:add(Infobox["Image"][1])
Infobox["Window"]:add(Infobox["Label"][1])

Infobox["Window"]:setReadOnly(true)

function destroyInfoBox()
	Infobox["Window"]:hide()
end

function showInfoBox(action, text, iTime, sSound)
	Infobox["Window"]:hide()
	Infobox["Image"][1]:loadImage("res/images/infobox/"..action..".png")

    local sound = "res/sounds/hud/info_"..action..".ogg";

	if(sSound) then
		sound = "res/sounds/hud/info_"..sSound..".ogg";
	end

    if not(fileExists(sound)) then
        sound = nil;
    end

	if(toboolean(config:getConfig("use_old_plop_sound"))) then
		sound = "res/sounds/poke.ogg";
	end
	-- Text --

	text = string.gsub(text, "\\ae", "ä")
	text = string.gsub(text, "\\ue", "ü")
	text = string.gsub(text, "\\oe", "ö")

	outputConsole(action..": "..text)

	Infobox["Label"][1]:setText(text)
	if (not (isTimer(Infobox["Timer"])) ) then
		Infobox["Window"]:show(sound)
		Infobox["Timer"] = setTimer(destroyInfoBox, iTime or 5000, 1)
	else
		killTimer(Infobox["Timer"])
		Infobox["Window"]:show(sound)
		Infobox["Timer"] = setTimer(destroyInfoBox, iTime or 5000, 1)
	end
end
addEvent("infoBoxShow", true)
addEventHandler("infoBoxShow", getLocalPlayer(), showInfoBox)
