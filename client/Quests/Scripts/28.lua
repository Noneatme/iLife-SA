--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 28
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
			QuestFunctions.spawnDeadman()
		end
		if (State == "GoBackToPD") then
			QuestFunctions.spawnOfficerMarker()
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

QuestFunctions.spawnDeadman = function()
	QuestElements["Deadman"] = createPed(34, 489.1474609375, -82.3525390625, 998.76507568359, 270)
	QuestElements["DeadmanMarker"] = createMarker(489.1474609375, -82.3525390625, 998.76507568359, "corona", 3, 0, 0, 0, 0)
	setElementFrozen (QuestElements["Deadman"], true)
	setElementInterior (QuestElements["Deadman"], 11)
	setElementInterior (QuestElements["DeadmanMarker"], 11)
	setElementDimension (QuestElements["Deadman"], 20004)
	setElementDimension (QuestElements["DeadmanMarker"], 20004)
	setElementHealth (QuestElements["Deadman"], 0)
	addEventHandler("onClientMarkerHit", QuestElements["DeadmanMarker"], QuestFunctions.DeadmanMarkerHit)
end

QuestFunctions.unhandleDeadman = function()
	removeEventHandler("onClientMarkerHit", QuestElements["DeadmanMarker"], QuestFunctions.DeadmanMarkerHit)
end

QuestFunctions.DeadmanMarkerHit = function(hitElement, matching)
	if (hitElement == localPlayer) and matching then
		triggerServerQuestScript(QuestID, "Deadman_Clicked", false)
	end
end

QuestFunctions.spawnOfficerMarker = function()
	QuestElements["OfficerMarker"] = createMarker(1556.0712890625, -2938.4921875, 219.09289550781, "corona", 2, 0, 0, 0, 0)
	setElementInterior(QuestElements["OfficerMarker"], 10)
	setElementDimension(QuestElements["OfficerMarker"], 20141)
	addEventHandler("onClientMarkerHit", QuestElements["OfficerMarker"], QuestFunctions.OfficerMarkerHit)
end

QuestFunctions.unhandleOfficerMarker = function()
	removeEventHandler("onClientMarkerHit", QuestElements["OfficerMarker"], QuestFunctions.OfficerMarkerHit)
end

QuestFunctions.OfficerMarkerHit = function(hitElement, matching)
	if (hitElement == localPlayer) and matching then
		QuestFunctions.unhandleOfficerMarker()
		triggerServerQuestScript(QuestID, "ReadyToTurnIn", false)
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
	QuestFunctions.unhandleDeadman()
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