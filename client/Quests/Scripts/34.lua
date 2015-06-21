--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 34
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
			QuestFunctions.spawnBankrobCase()
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

QuestFunctions.spawnBankrobCase = function()
	QuestElements["BankrobCase"] = createObject(1210, -123.69999694824, 2257.1999511719, 27.799999237061, 90, 270, 0)
	setObjectScale(QuestElements["BankrobCase"],3)
	addEventHandler("onClientClick", getRootElement(), QuestFunctions.BankrobCaseClick)
end

QuestFunctions.despawnBankrobCase = function()
	removeEventHandler("onClientClick", getRootElement(), QuestFunctions.BankrobCaseClick)
end

QuestFunctions.BankrobCaseClick = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left" and state == "down") then
		if (clickedElement == QuestElements["BankrobCase"]) then
			if (getDistanceBetweenElements3D(clickedElement,localPlayer) < 5) then
				triggerServerQuestScript(QuestID, "BankrobCase_Clicked", nil)
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
	QuestFunctions.despawnBankrobCase()
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