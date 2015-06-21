--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 38
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
			QuestFunctions.spawnBears()
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
QuestFunctions.spawnBears = function()
	QuestElements["Bear1"] = createPed(10, 1047.33203125, -305.88671875, 77.359375, 80)
	QuestElements["Bear2"] = createPed(10, 1047.1240234375, -297.46484375 ,77.359375, 146)
	QuestElements["Bear3"] = createPed(10, 1043.72265625, -302.90625, 77.359375, 187)
	QuestElements["Bear4"] = createPed(10, 1021.13671875, -305.8798828125, 77.359375, 91)
	QuestElements["Bear5"] = createPed(10, 1017.84765625, -297.3359375, 77.359375, 185)
	QuestElements["Bear6"] = createPed(10, 1021.18359375, -298.8271484375, 77.359375, 160)
	addEventHandler("onClientPedWasted", QuestElements["Bear1"], QuestFunctions.PedKill)
	addEventHandler("onClientPedWasted", QuestElements["Bear2"], QuestFunctions.PedKill)
	addEventHandler("onClientPedWasted", QuestElements["Bear3"], QuestFunctions.PedKill)
	addEventHandler("onClientPedWasted", QuestElements["Bear4"], QuestFunctions.PedKill)
	addEventHandler("onClientPedWasted", QuestElements["Bear5"], QuestFunctions.PedKill)
	addEventHandler("onClientPedWasted", QuestElements["Bear6"], QuestFunctions.PedKill)
end

QuestFunctions.PedKill = function(theKiller, weapon, bodypart)
	triggerServerQuestScript(QuestID, "Bear_Killed", nil)
end

--[[
	OWN LOGIC END
]]


QuestFunctions.clearQuestScript = function()
	outputDebugString("Unloading Questscript: client/Quests/Scripts/"..tostring(QuestID)..".lua")
	
	--Lock Script
	QuestLocked = true
	
	--Unload Script
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