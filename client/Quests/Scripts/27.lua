--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 27
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
			QuestFunctions.spawnPlans()
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

QuestFunctions.spawnPlans = function()
	QuestElements["Plans"] = createObject(3017, 344.72, 162.10001, 1025.5, 0, 0, 90)
	QuestElements["PlansMarker"] = createMarker ( 344.72, 162.10001, 1025.5, "corona", 2, 0, 0, 0, 0 )
	setElementDimension(QuestElements["Plans"], 20088)
	setElementDimension(QuestElements["PlansMarker"], 20088)
	setElementInterior(QuestElements["Plans"], 3)
	setElementInterior(QuestElements["PlansMarker"], 3)
	addEventHandler("onClientMarkerHit", QuestElements["PlansMarker"], QuestFunctions.PlansMarkerHit)
end

QuestFunctions.despawnPlans = function()
	removeEventHandler("onClientMarkerHit", QuestElements["PlansMarker"], QuestFunctions.PlansMarkerHit)
end

QuestFunctions.PlansMarkerHit = function(hitElement, matching)
	if (hitElement == localPlayer) and matching then
		triggerServerQuestScript(QuestID, "Plans_Hit", nil)
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
	QuestFunctions.despawnPlans() 
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