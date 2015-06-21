--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 45
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
			QuestFunctions.spawnWeapon()
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

QuestFunctions.spawnWeapon = function()
	QuestElements["Weapon"] = createObject(346, 510, -84.4, 998.89996, 90, 0, 0)
	QuestElements["WeaponCollision"] = createObject(2358, 510, -84.5, 999.00012, 0, 0, 0)
	setElementDimension(QuestElements["Weapon"], 20004)
	setElementDimension(QuestElements["WeaponCollision"], 20004)
	setElementInterior(QuestElements["Weapon"], 11)
	setElementInterior(QuestElements["WeaponCollision"], 11)
	setElementAlpha(QuestElements["WeaponCollision"], 0)
	addEventHandler("onClientClick", getRootElement(), QuestFunctions.WeaponClick)
end

QuestFunctions.despawnWeapon = function()
	removeEventHandler("onClientClick", getRootElement(), QuestFunctions.WeaponClick)
end

QuestFunctions.WeaponClick = function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if (button == "left" and state == "down") then
		if (clickedElement == QuestElements["WeaponCollision"]) then
			triggerServerQuestScript(QuestID, "Weapon_Clicked", nil)
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
	QuestFunctions.despawnWeapon()
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