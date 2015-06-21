--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 43
local Quest = Quests[QuestID]
local QuestFunctions = {}
local QuestElements = {}
--Set this true to lock this script.
local QuestLocked = false

--[[
	ACCEPT TRIGGERS HERE
]]

-- ID: QuestID
-- State = Aktueller Queststatus
-- tblData = Zu übertragende Daten
local CallClientQuestScript = function(ID, State, Data)
	if (ID == QuestID) and (not QuestLocked) then
		if (State == "Accepted") then
			QuestFunctions.spawnCameras()
		end
		if (State == "Finished") or (State == "Aborted") then
			--Clean up
			QuestFunctions.clearQuestScript()
		end
	end
end
addEventHandler("onClientQuestScript", getRootElement(), CallClientQuestScript)

--[[
	TRIGGERS END
]]

--[[
	INSERT OWN LOGIC HERE
]]

local cameraSpawns = {
	[1]="Creek|20065",
	[2]="BaySide|20081",
	[3]="Queens|20156",
	[4]="Juniper Hill|20025"
}

QuestFunctions.spawnCameras = function()
	local cameraRandom = math.random(1, #cameraSpawns)
	local camShopLocation = gettok(cameraSpawns[cameraRandom], 1, string.byte("|"))
	local camShopDimension = tonumber(gettok(cameraSpawns[cameraRandom], 2, string.byte("|")))
	outputChatBox("Redakteur: Hey "..getPlayerName(localPlayer)..", k\\oenntest du die bestellten Kameras abholen?", 255, 255, 255)
	outputChatBox("Redakteur: Diesmal haben wir sie beim 24/7 in "..camShopLocation.." bestellt.", 255, 255, 255)
	QuestElements["Cameras"] = createObject(1221, -26.10000038147, -90.900001525879, 1003, 0, 0, 0)
	setElementInterior(QuestElements["Cameras"], 18)
	setElementDimension(QuestElements["Cameras"], camShopDimension)
	setObjectScale(QuestElements["Cameras"], 0.5)
	addEventHandler("onClientClick", getRootElement(), QuestFunctions.CamerasClick)
end

QuestFunctions.despawnCameras = function()
	removeEventHandler("onClientClick", getRootElement(), QuestFunctions.CamerasClick)
end

QuestFunctions.CamerasClick = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left" and state == "down") then
		if (clickedElement == QuestElements["Cameras"]) then
			triggerServerQuestScript(QuestID, "Cameras_Clicked", nil)
		end
	end
end

--[[
	OWN LOGIC END
]]

QuestFunctions.clearQuestScript = function()
	outputDebugString("Unloading Questscript: client/Quests/Scripts/"..tostring(QuestID)..".lua")
	
	--Lock Script
	QuestLocked = true
	
	--Unload Script
	QuestFunctions.despawnCameras()
	removeEventHandler("onClientQuestScript", getRootElement(), CallClientQuestScript)
	CallClientQuestScript = nil
	Quest = nil
	QuestID = nil
	
	for k,v in pairs(QuestFunctions) do
		QuestFunctions[k] = nil
	end
	
	QuestFunctions = nil
	
	for k,v in pairs(QuestElements) do
		if (isElement(v)) then
			destroyElement(v)
		end
		QuestElements[k] = nil
	end
	QuestElements = nil

	QuestFunctions = nil
	QuestLocked = nil
	
	cameraSpawns = nil
	cameraRandom = nil
	camShopLocation = nil
	camShopDimension = nil
	
	--Unloading done!
end

outputDebugString("Loaded Questscript: client/Quests/Scripts/"..tostring(QuestID)..".lua")