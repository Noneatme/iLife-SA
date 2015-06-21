vlocal QuestID = 12
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
            QuestFunctions.spawnTurtle()
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

QuestFunctions.spawnTurtle = function()
    QuestElements["Turtle"] = createObject(1609, 403.60001, -1908, 0, 0, 0, 332)
	QuestElements["TurtleMarker"] = createMarker(403.60001, -1908, 0, "corona", 2, 0, 0, 0, 0 )
	addEventHandler("onClientMarkerHit", QuestElements["TurtleMarker"], QuestFunctions.TurtleMarkerHit)
end

QuestFunctions.despawnTurtle = function()
	removeEventHandler("onClientMarkerHit", QuestElements["TurtleMarker"], QuestFunctions.TurtleMarkerHit)
end

QuestFunctions.TurtleMarkerHit = function(hitElement, matching)
	if (hitElement == localPlayer) and matching then
		triggerServerQuestScript(QuestID, "Turtle_Hit", nil)
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
	QuestFunctions.despawnTurtle()
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