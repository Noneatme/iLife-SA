--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 44
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
			QuestFunctions.spawnBike()
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

QuestFunctions.spawnBike = function()
	QuestElements["Bike"] = createVehicle(481, -2079.8000488281, -1687, 180.19999694824, 0, 90, 0)
	setElementFrozen(QuestElements["Bike"], true)
	addEventHandler("onClientClick", getRootElement(), QuestFunctions.BikeClick)
end

QuestFunctions.despawnBike = function()
	removeEventHandler("onClientClick", getRootElement(), QuestFunctions.BikeClick)
end

QuestFunctions.BikeClick = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left" and state == "down") then
		if (clickedElement == QuestElements["Bike"]) then
			triggerServerQuestScript(QuestID, "Bike_Clicked", nil)
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
	QuestFunctions.despawnBike()
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
	
	--Unloading done!
end

outputDebugString("Loaded Questscript: client/Quests/Scripts/"..tostring(QuestID)..".lua")