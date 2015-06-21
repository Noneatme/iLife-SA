
--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 56
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
			QuestFunctions.spawnRaceStartMarker()
		end
		if (State == "Finished") or (State == "Aborted") then
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

QuestFunctions.spawnRaceStartMarker = function()
	QuestElements["RaceStartMarker"] = createMarker(1346.1611328125, -2356.0732421875, 13.375, "checkpoint", 5, 0, 0, 255)
	addEventHandler("onClientMarkerHit", QuestElements["RaceStartMarker"], QuestFunctions.hitRaceStartMarker)
end

QuestFunctions.hitRaceStartMarker = function(hitElement, matching)
	if ( hitElement == localPlayer ) and matching then
		if isPedInVehicle(hitElement) then
			removeEventHandler("onClientMarkerHit", QuestElements["RaceStartMarker"], QuestFunctions.hitRaceStartMarker)
			destroyElement(QuestElements["RaceStartMarker"])
			QuestElements["RaceFinishMarker"] = createMarker(-2466.0625, 2249.146484375, 4.7998533248901, "checkpoint", 5, 0, 255, 0)
			addEventHandler("onClientMarkerHit", QuestElements["RaceFinishMarker"], QuestFunctions.hitRaceFinishMarker)
			QuestElements["RaceStartTick"] = getTickCount()
			outputChatBox("Fahre zum Parkplatz am Leuchtturm in BaySide!", 0, 180, 0)
		else
			outputChatBox("Du ben\\oetigst ein Fahrzeug!", 180, 0, 0)
		end
	end
end

QuestFunctions.hitRaceFinishMarker = function(hitElement, matching)
	if ( hitElement == localPlayer ) and matching then
		removeEventHandler("onClientMarkerHit", QuestElements["RaceFinishMarker"], QuestFunctions.hitRaceFinishMarker)
		destroyElement(QuestElements["RaceFinishMarker"])
		QuestElements["RaceFinishTick"] = getTickCount()
		QuestElements["RaceTickDiff"] = QuestElements["RaceFinishTick"] - QuestElements["RaceStartTick"]
		if ( QuestElements["RaceTickDiff"] <= 240000 ) then
			outputChatBox("Du hast es geschafft!", 0, 180, 0)
			if ( QuestElements["RaceTickDiff"] <= 160000 ) then
				triggerServerQuestScript(QuestID, "RaceFinishedFast", nil)
			else
				triggerServerQuestScript(QuestID, "RaceFinished", nil)
			end
		else
			QuestElements["RaceStartTick"] = nil
			QuestElements["RaceFinishTick"] = nil
			QuestElements["RaceTickDiff"] = nil
			outputChatBox("Du warst leider zu langsam. Versuche es noch einmal!", 180, 0, 0)
			QuestFunctions.spawnRaceStartMarker()
		end
	end
end

QuestFunctions.clearEventHandler = function()
	if isElement(QuestElements["RaceStartMarker"]) then
		removeEventHandler("onClientMarkerHit", QuestElements["RaceStartMarker"], QuestFunctions.hitRaceStartMarker)
	end
	if isElement(QuestElements["RaceFinishMarker"]) then
		removeEventHandler("onClientMarkerHit", QuestElements["RaceFinishMarker"], QuestFunctions.hitRaceFinishMarker)
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
	QuestFunctions.clearEventHandler()
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