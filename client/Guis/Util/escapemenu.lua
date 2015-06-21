--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[
addEventHandler("onClientRender", root,
    function()
        dxDrawRectangle(0, 0, 250, 319, tocolor(255, 255, 255, 255), true)
        dxDrawImage(5, 39, 240, 70, ":ilife/res/images/Radio.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
        dxDrawImage(5, 112, 240, 70, ":ilife/res/images/Radio.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
        dxDrawImage(5, 186, 240, 70, ":ilife/res/images/Radio.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
    end
)]]

sX,sY = guiGetScreenSize()

Mainmenu = {
	["Window"] = false,
	["Label"] = {},
	["Image"] = {},
}

function destroyMainMenu()
	if ( (Mainmenu["Window"] == nil) or (Mainmenu["Window"] == false) ) then
		Mainmenu["Window"]:hide()
		delete(Mainmenu["Window"], true)
	end
end

function showMainMenu()
	Mainmenu["Window"] = new(CDxWindow, "Menü", 250, 320, true, true, "Center|Middle")
	Mainmenu["Image"][1] = new(CDxImage, 5, 20, 240, 70,  "res/images/Radio.png",tocolor(255,255,255,255), Mainmenu["Window"])
	Mainmenu["Image"][2] = new(CDxImage, 5, 100, 240, 70, "res/images/Radio.png",tocolor(255,255,255,255), Mainmenu["Window"])
	Mainmenu["Image"][3] = new(CDxImage, 5, 180, 240, 70, "res/images/Radio.png",tocolor(255,255,255,255), Mainmenu["Window"])

	Mainmenu["Window"]:add(Mainmenu["Image"][1])
	Mainmenu["Window"]:add(Mainmenu["Image"][2])
	Mainmenu["Window"]:add(Mainmenu["Image"][3])
	
	Mainmenu["Window"]:show()
end