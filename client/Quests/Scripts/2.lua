--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 2
local Quest = Quests[QuestID]
local QuestFunctions = {}
local QuestElements = {}
--Set this true to lock this script.
local QuestLocked = false

--[[
	ACCEPT TRIGGERS HERE
]]

-- ID: QuestID
-- State = Aktueler Queststatus
-- tblData = Zu übertragende Daten
local CallClientQuestScript = function(ID, State, Data)
	if (ID == QuestID) and (not QuestLocked) then
		if (State == "Accepted") then
			QuestFunctions.spawnCase()
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

-- Funktion um den Koffer zu spawnen
QuestFunctions.spawnCase = function()
	QuestElements["Case"] = createObject(1210, 919.5, -1259.5999755859, 14.800000190735, 0, 0, 270)
	addEventHandler("onClientClick", getRootElement(), QuestFunctions.CaseClick)
end

-- Funktion um den Koffer unzuhandlen
QuestFunctions.despawnCase = function()
	removeEventHandler("onClientClick", getRootElement(), QuestFunctions.CaseClick)
end

QuestFunctions.CaseClick = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left" and state == "down") then
		if (clickedElement == QuestElements["Case"]) then
			if (getDistanceBetweenElements3D(clickedElement,localPlayer) < 5) then
				triggerServerQuestScript(QuestID, "Case_Clicked", nil)
			end
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
	QuestFunctions.despawnCase()
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