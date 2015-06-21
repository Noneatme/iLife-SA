--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

function toggleBlips(id)
	triggerServerEvent("onClientUnlockedAchievement", getRootElement(), 74)
	local Blips = getElementsByType("blip")
	if tonumber(id) then
		for k,v in ipairs(Blips) do
			if (getBlipIcon(v) == tonumber(id)) then
				if getElementDimension(v) == 0 then
					setElementDimension(v, 65535)
				else
					setElementDimension(v, 0)
				end
			end
		end
	else
		for k,v in ipairs(Blips) do
			if getElementDimension(v) == 0 then
				setElementDimension(v, 65535)
			else
				setElementDimension(v, 0)
			end
		end
	end
end

BlipManager = {
	["Window"] = false,
	["Image"] = {},
	["Checkbox"] = {}
}


blips = {
	[1] = createBlip(7000, 7000, 0, 10, 2, 0, 0, 0, 0, 0, 0),
	[2] = createBlip(7000, 7000, 0, 12, 2, 0, 0, 0, 0, 0, 0),
	[3] = createBlip(7000, 7000, 0, 18, 2, 0, 0, 0, 0, 0, 0),
	[4] = createBlip(7000, 7000, 0, 14, 2, 0, 0, 0, 0, 0, 0),
	[5] = createBlip(7000, 7000, 0, 21, 2, 0, 0, 0, 0, 0, 0),
	[6] = createBlip(7000, 7000, 0, 24, 2, 0, 0, 0, 0, 0, 0),
	[7] = createBlip(7000, 7000, 0, 25, 2, 0, 0, 0, 0, 0, 0),
	[8] = createBlip(7000, 7000, 0, 29, 2, 0, 0, 0, 0, 0, 0),
	[9] = createBlip(7000, 7000, 0, 30, 2, 0, 0, 0, 0, 0, 0),
	[10] = createBlip(7000, 7000, 0, 36, 2, 0, 0, 0, 0, 0, 0),
	[11] = createBlip(7000, 7000, 0, 45, 2, 0, 0, 0, 0, 0, 0),
	[12] = createBlip(7000, 7000, 0, 46, 2, 0, 0, 0, 0, 0, 0),
	[13] = createBlip(7000, 7000, 0, 48, 2, 0, 0, 0, 0, 0, 0),
	[14] = createBlip(7000, 7000, 0, 17, 2, 0, 0, 0, 0, 0, 0),
	[15] = createBlip(7000, 7000, 0, 50, 2, 0, 0, 0, 0, 0, 0),
	[16] = createBlip(7000, 7000, 0, 52, 2, 0, 0, 0, 0, 0, 0),
	[17] = createBlip(7000, 7000, 0, 55, 2, 0, 0, 0, 0, 0, 0),
	[18] = createBlip(7000, 7000, 0, 9, 2, 0, 0, 0, 0, 0, 0),
	[19] = createBlip(7000, 7000, 0, 63, 2, 0, 0, 0, 0, 0, 0),
	[20] = createBlip(7000, 7000, 0, 56, 2, 0, 0, 0, 0, 0, 0),
	[21] = createBlip(7000, 7000, 0, 54, 2, 0, 0, 0, 0, 0, 0)
}

Blip(-18.72013092041, -298.52111816406, 5.4296875, 51)

addEvent("BlipManagerOpen",true)
addEventHandler("BlipManagerOpen", getLocalPlayer(), function()
	if(BlipManager["Window"]) then
		triggerEvent("BlipManagerClose", localPlayer)
		BlipManager["Window"]:hide()
		delete(BlipManager["Window"]);
		BlipManager["Window"] = nil;
		clientBusy = false;
	end
		BlipManager["Window"] = new(CDxWindow, "Legende & Filter", 200, 460, true, false, "Left|Middle")

		BlipManager["Checkbox"][1] = new(CDxCheckbox, "Burgershot", 1, 10, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[1])==0 , BlipManager["Window"])
		BlipManager["Checkbox"][2] = new(CDxCheckbox, "Strip-Club", 1, 30, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[2])==0, BlipManager["Window"])
		BlipManager["Checkbox"][3] = new(CDxCheckbox, "Ammu-Nation", 1, 50, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[3])==0, BlipManager["Window"])
		BlipManager["Checkbox"][4] = new(CDxCheckbox, "Cluckin' Bell", 1, 70, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[4])==0, BlipManager["Window"])
		BlipManager["Checkbox"][5] = new(CDxCheckbox, "Sexshop", 1, 90, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[5])==0, BlipManager["Window"])
		BlipManager["Checkbox"][6] = new(CDxCheckbox, "Donutladen", 1, 110, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[6])==0, BlipManager["Window"])
		BlipManager["Checkbox"][7] = new(CDxCheckbox, "Casino", 1, 130, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[7])==0, BlipManager["Window"])
		BlipManager["Checkbox"][8] = new(CDxCheckbox, "Well Stacked Pizza", 1, 150, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[8])==0, BlipManager["Window"])
		BlipManager["Checkbox"][9] = new(CDxCheckbox, "Police Department", 1, 170, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[9])==0, BlipManager["Window"])
		BlipManager["Checkbox"][10] = new(CDxCheckbox, "Supermarkt", 1, 190, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[10])==0, BlipManager["Window"])
		BlipManager["Checkbox"][11] = new(CDxCheckbox, "Kleidungsladen", 1, 210, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[11])==0, BlipManager["Window"])
		BlipManager["Checkbox"][12] = new(CDxCheckbox, "Wettbüro", 1, 230, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[12])==0, BlipManager["Window"])
		BlipManager["Checkbox"][13] = new(CDxCheckbox, "Disco", 1, 250, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[13])==0, BlipManager["Window"])
		BlipManager["Checkbox"][14] = new(CDxCheckbox, "Bar", 1, 270, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[14])==0, BlipManager["Window"])
		BlipManager["Checkbox"][15] = new(CDxCheckbox, "Restaurant", 1, 290, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[15])==0, BlipManager["Window"])
		BlipManager["Checkbox"][16] = new(CDxCheckbox, "Bankautomat", 1, 310, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[16])==0, BlipManager["Window"])
		BlipManager["Checkbox"][17] = new(CDxCheckbox, "Autohaus", 1, 330, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[17])==0, BlipManager["Window"])
		BlipManager["Checkbox"][18] = new(CDxCheckbox, "Boot Club", 1, 350, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[18])==0, BlipManager["Window"])
		BlipManager["Checkbox"][19] = new(CDxCheckbox, "Pay'n Spray", 1, 370, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[19])==0, BlipManager["Window"])
		BlipManager["Checkbox"][20] = new(CDxCheckbox, "Stadthalle", 1, 390, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[20])==0, BlipManager["Window"])
		BlipManager["Checkbox"][21] = new(CDxCheckbox, "Fitness-Studio", 1, 410, 199, 20, tocolor(255,255,255,255), getElementDimension(blips[21])==0, BlipManager["Window"])


		BlipManager["Checkbox"][1]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[1]))
		end
		)
		BlipManager["Checkbox"][2]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[2]))
		end
		)
		BlipManager["Checkbox"][3]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[3]))
		end
		)
		BlipManager["Checkbox"][4]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[4]))
		end
		)
		BlipManager["Checkbox"][5]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[5]))
		end
		)
		BlipManager["Checkbox"][6]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[6]))
		end
		)
		BlipManager["Checkbox"][7]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[7]))
		end
		)
		BlipManager["Checkbox"][8]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[8]))
		end
		)
		BlipManager["Checkbox"][9]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[9]))
		end
		)
		BlipManager["Checkbox"][10]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[10]))
		end
		)
		BlipManager["Checkbox"][11]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[11]))
		end
		)
		BlipManager["Checkbox"][12]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[12]))
		end
		)
		BlipManager["Checkbox"][13]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[13]))
		end
		)
		BlipManager["Checkbox"][14]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[14]))
		end
		)
		BlipManager["Checkbox"][15]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[15]))
		end
		)
		BlipManager["Checkbox"][16]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[16]))
		end
		)
		BlipManager["Checkbox"][17]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[17]))
		end
		)
		BlipManager["Checkbox"][18]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[18]))
		end
		)
		BlipManager["Checkbox"][19]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[19]))
		end
		)
		BlipManager["Checkbox"][20]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[20]))
		end
		)
		BlipManager["Checkbox"][21]:addClickFunction(
		function ()
			toggleBlips(getBlipIcon(blips[21]))
		end
		)

		BlipManager["Window"]:add(BlipManager["Checkbox"][1])
		BlipManager["Window"]:add(BlipManager["Checkbox"][2])
		BlipManager["Window"]:add(BlipManager["Checkbox"][3])
		BlipManager["Window"]:add(BlipManager["Checkbox"][4])
		BlipManager["Window"]:add(BlipManager["Checkbox"][5])
		BlipManager["Window"]:add(BlipManager["Checkbox"][6])
		BlipManager["Window"]:add(BlipManager["Checkbox"][7])
		BlipManager["Window"]:add(BlipManager["Checkbox"][8])
		BlipManager["Window"]:add(BlipManager["Checkbox"][9])
		BlipManager["Window"]:add(BlipManager["Checkbox"][10])
		BlipManager["Window"]:add(BlipManager["Checkbox"][11])
		BlipManager["Window"]:add(BlipManager["Checkbox"][12])
		BlipManager["Window"]:add(BlipManager["Checkbox"][13])
		BlipManager["Window"]:add(BlipManager["Checkbox"][14])
		BlipManager["Window"]:add(BlipManager["Checkbox"][15])
		BlipManager["Window"]:add(BlipManager["Checkbox"][16])
		BlipManager["Window"]:add(BlipManager["Checkbox"][17])
		BlipManager["Window"]:add(BlipManager["Checkbox"][18])
		BlipManager["Window"]:add(BlipManager["Checkbox"][19])
		BlipManager["Window"]:add(BlipManager["Checkbox"][20])
		BlipManager["Window"]:add(BlipManager["Checkbox"][21])
		BlipManager["Window"]:setReadOnly(true)
		BlipManager["Window"]:show()

end
)


addEvent("BlipManagerClose",true)
addEventHandler("BlipManagerClose", getLocalPlayer(), function()
	if (BlipManager["Window"]) then
		BlipManager["Window"]:hide()
		delete(BlipManager["Window"]);
		BlipManager["Window"] = nil;
	end
end
)


bindKey("F11" , "down",
	function()
		if (BlipManager["Window"]) then
			BlipManager["Window"]:hide()
			delete(BlipManager["Window"]);
			BlipManager["Window"] = nil;
		end
		if(isPlayerMapVisible()) then
			triggerEvent("BlipManagerOpen", getLocalPlayer())
		else
			triggerEvent("BlipManagerClose", getLocalPlayer())
		end
	end
)
