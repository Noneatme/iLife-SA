--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 55
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
            QuestFunctions.spawnAirportMarker()
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

QuestFunctions.spawnAirportMarker = function()
	QuestElements["AirportMarker"] = createMarker( 1683.69140625, 1439.2294921875, 10.771226882935, "corona", 15, 0, 0, 0, 0)
	addEventHandler("onClientMarkerHit", QuestElements["AirportMarker"], QuestFunctions.AirportMarkerHit)
end

QuestFunctions.despawnAirportMarker = function()
	removeEventHandler("onClientMarkerHit", QuestElements["AirportMarker"], QuestFunctions.AirportMarkerHit)
end

QuestFunctions.AirportMarkerHit = function(hitElement, matching)
	if (hitElement == localPlayer) and matching then
		triggerServerQuestScript(QuestID, "AirportMarker_Hit", nil)
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
	QuestFunctions.despawnAirportMarker()
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