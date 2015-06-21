--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

AchievementQueue = {}

addEvent("onClientAchievementRecieve", true)
addEventHandler("onClientAchievementRecieve", getRootElement(),
	function(ID, Name, Points)
		Name = parseString(Name)
		table.insert(AchievementQueue, {["ID"]=ID,["Name"]=Name,["Points"]=Points})
		if (#AchievementQueue == 1) then
			AchievementDisplay:refresh()
		end
	end
)

CAchievementDisplay = {}

function CAchievementDisplay:constructor()
	self.Template = dxCreateTexture("res/images/achievements/achievement_template.png")
	self.Icon = "res/images/achievements/none.png"
	self.Duration = 6000
	self.onRender = bind(CAchievementDisplay.render, self)
end

function CAchievementDisplay:destructor()

end

function CAchievementDisplay:refresh()
	if (#AchievementQueue > 0) then
		if fileExists("res/images/achievements/"..tostring(AchievementQueue[1]["ID"])..".png") then
			self.Icon = "res/images/achievements/"..tostring(AchievementQueue[1]["ID"])..".png"
		else
			self.Icon = "res/images/achievements/none.png"
		end
		addEventHandler("onClientRender", getRootElement(), self.onRender)
	end
end

function CAchievementDisplay:render()
	if (not self.Starttick) then
		self.Starttick = getTickCount()
		playSound("res/sounds/achievement.mp3", false)
	end

	local alpha = 255
	if (getTickCount()-self.Starttick < 500) then
		alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount()-self.Starttick)/500, "OutQuad")
	end
	if (getTickCount()-self.Starttick > 5500) then
		alpha = interpolateBetween(0,0,0,255,0,0, 1-(((getTickCount()-self.Starttick)-5500)/500), "InQuad")
	end

	local sx, sy = guiGetScreenSize()
	local startx, starty = (sx/2)-160, ((sy/8)*7)-45
	dxDrawImage(startx, starty, 320, 90, self.Template, 0, 0, 0, tocolor(255,255,255,alpha), false)
	dxDrawImage(startx+19,starty+23, 44, 44, self.Icon, 0, 0, 0, tocolor(255,255,255,alpha), false)
	dxDrawText(tostring(AchievementQueue[1]["Points"]), startx+264, starty+37, (startx+264)+23, (starty+37)+20, tocolor(255,255,255,alpha), 1, "default-bold", "center", "center", false, false, true, false, false)
	dxDrawText(tostring(AchievementQueue[1]["Name"]), startx+78, starty+35, (startx+78)+167, (starty+35)+19, tocolor(255,255,255,alpha), 1, "default-bold", "center", "center", false, false, true, false, false)

	--shine
	if (getTickCount()-self.Starttick < 1000) then
		local posadd = interpolateBetween(0,0,0,270,0,0, (getTickCount()-self.Starttick)/1000, "InQuad")
		dxDrawImage(startx+posadd,starty+11, 50, 68, "res/images/achievements/shine.png")
	end

	if ( (getTickCount()-self.Starttick) > self.Duration) then
		self:renderFinished()
	end
end

function CAchievementDisplay:renderFinished()
	removeEventHandler("onClientRender", getRootElement(), self.onRender)
	table.remove(AchievementQueue, 1)
	self.Starttick = false
	self:refresh()
end
AchievementDisplay = new(CAchievementDisplay)

CMedalDisplay = {}

function CMedalDisplay:constructor()
	self.Duration = 6000
	self.Name = "Niemand"
	self.onRender = bind(CMedalDisplay.render, self)
end

function CMedalDisplay:destructor()
	MedalDisplay:refresh(getPlayerName(source))
end

addEvent("onPlayerGetMedal", true)
addEventHandler("onPlayerGetMedal", getRootElement(),
	function(sName)
		MedalDisplay:refresh(sName)
	end
)

function CMedalDisplay:refresh(sName)
	self.Name = sName
	self:renderFinished()
	addEventHandler("onClientRender", getRootElement(), self.onRender)
end

function CMedalDisplay:render()
	if (not self.Starttick) then
		self.Starttick = getTickCount()
		playSound("res/sounds/achievement.mp3", false)
	end

	local alpha = 255
	if (getTickCount()-self.Starttick < 500) then
		alpha = interpolateBetween(0,0,0,255,0,0, (getTickCount()-self.Starttick)/500, "OutQuad")
	end
	if (getTickCount()-self.Starttick > 5500) then
		alpha = interpolateBetween(0,0,0,255,0,0, 1-(((getTickCount()-self.Starttick)-5500)/500), "InQuad")
	end

	local sx, sy = guiGetScreenSize()

	local startx, starty = (sx/2)-162, 30
	dxDrawImage(startx, starty, 324, 322, "res/images/achievements/medal.png", 0, 0, 0, tocolor(255,255,255,alpha), false)

	dxDrawText(tostring(self.Name), startx+64, starty+180, (startx)+260, (starty)+218, tocolor(255,255,255,alpha), 2, "default-bold", "center", "center", false, false, true, false, false)

	--shine
	if (getTickCount()-self.Starttick < 1000) then
		local posadd = interpolateBetween(0,0,0,171,0,0, (getTickCount()-self.Starttick)/1000, "InQuad")
		dxDrawImage(startx+posadd+39,starty+180, 50, 38, "res/images/achievements/shine.png")
	end

	if ( (getTickCount()-self.Starttick) > self.Duration) then
		self:renderFinished()
	end
end

function CMedalDisplay:renderFinished()
	removeEventHandler("onClientRender", getRootElement(), self.onRender)
	self.Starttick = false
end
MedalDisplay = new(CMedalDisplay)


--ID, Name, Description
AchievementCategories = {}
AchievementsByCategory = {}
addEvent("onClientAchievementCategoriesRecieve", true)
addEventHandler("onClientAchievementCategoriesRecieve", getRootElement(),
	function(Data)
		AchievementCategories = Data
		for k,v in pairs(Data) do
			AchievementsByCategory[k] = {}
		end
		AchievementBrowser:prepare()
	end
)

--ID, Name, Description, Category,Reward
Achievements = {}
AchievementsByCategory = {}
addEvent("onClientAchievementDataRecieve", true)
addEventHandler("onClientAchievementDataRecieve", getRootElement(),
	function(Data)
		Achievements = Data
		for k,v in pairs(Data) do
			v.Name = parseString(v.Name)
			v.Description = parseString(v.Description)
			table.insert(AchievementsByCategory[v["Category"]], v)
		end
	end
)

CAchievementBrowser = {}

function CAchievementBrowser:constructor()
	self.enabled = false;
	self.SelectedCategory = 0
	self.Scroll = 0

	self.Width, self.Height = 800,600

	local sx,sy = guiGetScreenSize()
	self.StartX, self.StartY = (sx/2)-(self.Width/2), (sy/2)-(self.Height/2)

	self.SelectedCategory = 1

	self.Window = new(CDxWindow, "Achievements ("..tostring(getElementData(localPlayer, "Bonuspoints")).." Punkte vorhanden!)", 755, 600, true, true, "Center|Middle")
	self.Window:setHideFunction(
		function()
			self.Window:hide()
			unbindKey("mouse_wheel_up", "down", self.ScrollUpFunc)
			unbindKey("mouse_wheel_down", "down", self.ScrollDownFunc)
			self.enabled = false;
		end
	)
	self.dxList = new(CDxList, 10, 20, 200, 480, tocolor(125,125,125,200), self.Window, false)
	self.dxButton =new(CDxButton, "Statistiken", 10, 510, 200, 40, tocolor(255,255,255,255), self.Window)

	self.Images = {
		[1]= new(CDxImage, 220, 20, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window),
		[2]= new(CDxImage, 220, 108, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window),
		[3]= new(CDxImage, 220, 196, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window),
		[4]= new(CDxImage, 220, 284, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window),
		[5]= new(CDxImage, 220, 372, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window),
		[6]= new(CDxImage, 220, 460, 504, 88, "res/images/achievements/achievementLong_undone.png",tocolor(255,255,255,255), self.Window)
	}

	self.Scrollbar = new(CDxImage, 730, 20, 20, 528, "res/images/achievements/none.png",tocolor(255,255,255,255), self.Window)

	self.Rendertargets = {
		[1] = dxCreateRenderTarget(504, 88, true),
		[2] = dxCreateRenderTarget(504, 88, true),
		[3] = dxCreateRenderTarget(504, 88, true),
		[4] = dxCreateRenderTarget(504, 88, true),
		[5] = dxCreateRenderTarget(504, 88, true),
		[6] = dxCreateRenderTarget(504, 88, true),
		[7] = dxCreateRenderTarget(20, 528, true)
	}

	self.dxList:addColumn("Kategorie")

	self.dxList:addClickFunction(
		function()
			if (self.SelectedCategory ~= self.dxList:getSelectedRow()) then
				self.SelectedCategory = self.dxList:getSelectedRow()
				self.Scroll = 0
				self:refresh()
			end
		end
	)

	self.dxButton:addClickFunction(
		function()
			self:toggle()
			showStatisticGui()
		end
	)


	self.Window:add(self.dxList)
	self.Window:add(self.dxButton)
	self.Window:add(self.Images[1])
	self.Window:add(self.Images[2])
	self.Window:add(self.Images[3])
	self.Window:add(self.Images[4])
	self.Window:add(self.Images[5])
	self.Window:add(self.Images[6])
	self.Window:add(self.Scrollbar)

	bindKey("n", "down",
		function()
			if (LoggedIn) then
				AchievementBrowser:toggle()
			end
		end
	)

	self.ScrollUpFunc = bind(CAchievementBrowser.scrollUp, self)
	self.ScrollDownFunc = bind(CAchievementBrowser.scrollDown, self)

end

function CAchievementBrowser:destructor()

end

function CAchievementBrowser:scrollUp()
	if (self.Scroll > 0) then
		self.Scroll = self.Scroll-1
		self:refresh()
	end
end

function CAchievementBrowser:scrollDown()
	if (self.SelectedCategory ~= 0) then
		if (self.Scroll < (table.size(AchievementsByCategory[self.SelectedCategory])-6)) then
			self.Scroll = self.Scroll+1
			self:refresh()
		end
	end
end


function CAchievementBrowser:toggle()
	if not (clientBusy) or (self.enabled) then
		if not(self.enabled) then
			self:refresh()
			self.Window:show()
			bindKey("mouse_wheel_up", "down", self.ScrollUpFunc)
			bindKey("mouse_wheel_down", "down", self.ScrollDownFunc)
			self.enabled = true;
			playSound("res/sounds/wow/achievement_open.ogg")
		else
			self.Window:hide()
			unbindKey("mouse_wheel_up", "down", self.ScrollUpFunc)
			unbindKey("mouse_wheel_down", "down", self.ScrollDownFunc)
			self.enabled = false;
			playSound("res/sounds/wow/achievement_close.ogg")
		end
	end
end

function CAchievementBrowser:prepare()
	self.dxList:clearRows()
	for k,v in pairs(AchievementCategories) do
		self.dxList:addRow(v["Name"])
	end
end

function CAchievementBrowser:refresh()
	self.Window:setTitle("Achievements ("..tostring(getElementData(localPlayer, "Bonuspoints")).." Punkte vorhanden!)")
	if self.SelectedCategory ~= 0 then
		for k,v in ipairs(self.Images) do
			dxSetRenderTarget(self.Rendertargets[k], true)
				local image = "res/images/achievements/achievementLong_undone.png"
				local acv = AchievementsByCategory[self.SelectedCategory][k+self.Scroll]
				local ID = false
				local name = ""
				local desc = ""
				local points = 10
				local status = ""
				local icon = "res/images/achievements/none.png"
				local date = ""
				if (type(acv)== "table") then
					ID = acv["ID"]

					if fileExists("res/images/achievements/"..tostring(ID)..".png") then
						icon = "res/images/achievements/"..tostring(ID)..".png"
					end

					name = acv["Name"]
					desc = acv["Description"]
					points = acv["Reward"]["Points"]
					if type(acv["Reward"]["Status"]) == "string" then
						status = "Status: "..acv["Reward"]["Status"]
					end
				end
				if (ID) then
					if (getElementData(localPlayer, "Achievements")[tostring(ID)]) then
						image = "res/images/achievements/achievementLong_done.png"
						local time = getRealTime(getElementData(localPlayer, "Achievements")[tostring(ID)])
						date = tostring(time["monthday"]).."."..tostring(time["month"]+1).."."..tostring(time["year"]+1900)
					end
				end
				dxDrawImage(0, 0, 504, 88, image)
				dxDrawText(name, 73, 7, 358+73, 19+7, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true, true)
				dxDrawText(desc, 75, 27, 361+75, 40+27, tocolor(255,255,255,255), 1, "default", "center", "center", true, true)
				dxDrawText(status, 88, 69, 330+88, 17+69, tocolor(255,255,255,255), 1, "default-bold", "center", "center", true, true)
				dxDrawText(tostring(points), 451, 28, 21+451, 17+28, tocolor(255,255,255,255), 1, "default-bold", "center", "center")
				dxDrawText(date,8,69, 8+61, 69+16, tocolor(255,255,255,255), 1, "default", "center", "center")
				dxDrawImage(16, 16, 44, 44, icon, 0, 0, 0, tocolor(255,255,255,alpha), false)
			dxSetRenderTarget()
			v:setImage(self.Rendertargets[k])
		end
		-- Scrollbar
		dxSetRenderTarget(self.Rendertargets[7], true)
		dxDrawRectangle(0,0,20,528, tocolor(50,50,50,255))
		local pos = interpolateBetween(26,0,0,500,0,0, self.Scroll/(table.size(AchievementsByCategory[self.SelectedCategory])-6), "Linear")
		if not(pos) then pos = 0 end
		dxDrawRectangle(0,pos-26,20,52, tocolor(200,200,200,255))
		dxSetRenderTarget()
		self.Scrollbar:setImage(self.Rendertargets[7])
	end
end

AchievementBrowser = new(CAchievementBrowser)

addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			triggerServerEvent("onClientRequestAchievementData", getRootElement())
		end
	end
)

Statistic = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}


Statistic_CurrentSelectedCategory = 1
StatisticCategories = {}

function showStatisticGui()
	if (not clientBusy) then
		hideStatisticGui()

		StatisticCategories = {}

		for k,v in pairs(getElementData(localPlayer, "Statistics")) do
			table.insert(StatisticCategories, {["Name"]=k})
		end


		Statistic["Window"] = new(CDxWindow, "Statistiken", 502, 427, true, true, "Center|Middle")
		Statistic["Window"]:setHideFunction(function() Statistic["Window"] = nil end)

		Statistic["Image"][1] = new(CDxImage, 10, 24, 30, 30, "/res/images/left.png",tocolor(255,255,255,255), Statistic["Window"])
		Statistic["Image"][2] = new(CDxImage, 460, 24, 30, 30, "/res/images/right.png",tocolor(255,255,255,255), Statistic["Window"])

		Statistic["Label"][1] = new(CDxLabel, StatisticCategories[Statistic_CurrentSelectedCategory]["Name"],45, 18, 410, 56, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", Statistic["Window"])

		Statistic["List"][1] = new(CDxList, 10, 57, 480, 280, tocolor(125,125,125,200), Statistic["Window"])

		Statistic["Button"][1] = new(CDxButton, "Zurueck", 10, 340, 480, 42, tocolor(255,255,255,255), Statistic["Window"])

		Statistic["List"][1]:addColumn("Bezeichnung")
		Statistic["List"][1]:addColumn("Wert")

		for k,v in pairs(getElementData(localPlayer, "Statistics")[StatisticCategories[Statistic_CurrentSelectedCategory]["Name"]]) do
			Statistic["List"][1]:addRow(formatStatisticString(k).."|"..v)
		end

		Statistic["Button"][1]:addClickFunction(
			function ()
				hideStatisticGui()
				AchievementBrowser:toggle()
			end
		)

		Statistic["Image"][1]:addClickFunction(
			function()
				if (Statistic_CurrentSelectedCategory ~= 1) then
					Statistic_CurrentSelectedCategory = Statistic_CurrentSelectedCategory-1
				else
					Statistic_CurrentSelectedCategory = #StatisticCategories
				end
				refreshStatistic()
			end
		)

		Statistic["Image"][2]:addClickFunction(
			function()
				if (Statistic_CurrentSelectedCategory ~= #StatisticCategories) then
					Statistic_CurrentSelectedCategory = Statistic_CurrentSelectedCategory+1
				else
					Statistic_CurrentSelectedCategory =  1
				end
				refreshStatistic()
			end
		)

		Statistic["Window"]:add(Statistic["Image"][1])
		Statistic["Window"]:add(Statistic["Image"][2])

		Statistic["Window"]:add(Statistic["Label"][1])

		Statistic["Window"]:add(Statistic["List"][1])

		Statistic["Window"]:add(Statistic["Button"][1])

		Statistic["Window"]:show()
	end
end

function refreshStatistic()
    if (Statistic["Window"]) then
        Statistic["List"][1]:clearRows()
        Statistic["Label"][1]:setText(StatisticCategories[Statistic_CurrentSelectedCategory]["Name"])
        for k,v in pairs(getElementData(localPlayer, "Statistics")[StatisticCategories[Statistic_CurrentSelectedCategory]["Name"]]) do
			Statistic["List"][1]:addRow(formatStatisticString(k).."|"..v)
		end
	end
end

addEvent("toggleStatisticGui", true)
addEventHandler("toggleStatisticGui", getRootElement(),
    function()
		if(Statistic["Window"]) then
			hideStatisticGui()
		else
			showStatisticGui()
		end
    end
)

function hideStatisticGui()
	if (Statistic["Window"]) then
		Statistic["Window"]:hide()
		Statistic["Window"] = nil
	end
end
addEvent("hideStatisticGui", true)
addEventHandler("hideStatisticGui", getRootElement(), hideStatisticGui)

function formatStatisticString(sString)
	return string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(sString, "_", " "), "\u0007e", "ä"), "Getoetet", "Getötet"),"\\u0007e", "ä"), "Haueser", "Häuser")
end
