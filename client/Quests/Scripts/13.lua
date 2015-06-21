--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]


local QuestID = 13
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
            QuestFunctions.spawnWeed()
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

QuestFunctions.spawnWeed = function()
	QuestElements["Weed"] = createObject(3409 ,2531.1000976563, -1987.5999755859, 12.10000038147, 0, 0, 314)
	QuestElements["WeedMarker"] = createMarker (2531.1000976563, -1987.5999755859, 12.10000038147, "cylinder", 2.5, 255, 255, 255, 0)
	addEventHandler("onClientMarkerHit", QuestElements["WeedMarker"], QuestFunctions.weedhit)
end

QuestFunctions.despawnWeed = function()
    removeEventHandler("onClientMarkerHit", QuestElements["WeedMarker"], QuestFunctions.weedhit)
end

QuestFunctions.weedhit = function(hitElement, matching)
    if (hitElement == localPlayer) and matching then
		triggerServerQuestScript(QuestID, "Weed_Clicked", nil)
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
	QuestFunctions.despawnWeed()
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