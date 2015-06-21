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

local DealerVehicle1 = createVehicle(411, -2453.7763671875, 2244.328125, 4.4989547729492, 0, 0, 90)
setElementFrozen(DealerVehicle1, true)
setElementHealth(DealerVehicle1, 1000)
setVehicleDamageProof(DealerVehicle1, true)
setVehicleLocked(DealerVehicle1, true)
setVehicleEngineState(DealerVehicle1, false)

local DealerVehicle2 = createVehicle(411, 1365.2314453125, -2365.6025390625, 13.273998260498, 0, 0, 90)
setElementFrozen(DealerVehicle2, true)
setElementHealth(DealerVehicle2, 1000)
setVehicleDamageProof(DealerVehicle2, true)
setVehicleLocked(DealerVehicle2, true)
setVehicleEngineState(DealerVehicle2, false)

Quest.Texts = {
	["Accepted"] = "Fahre in die blaue Startmarkierung!",
	["Finished"] = "\\Uebergebe die Ware!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "RaceFinished") then
				Quest:playerFinish(client)
			end
			if (Status == "RaceFinishedFast") then
				Quest:playerFinish(client)
				Achievements[131]:playerAchieved(client)
			end
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		return true
	end

Quest.getTaskPosition = 
	function()
		return 0, 0, -2453.7763671875, 2244.328125, 4.4989547729492
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Mann: Hey, du siehst schnell aus.", thePlayer, 255, 255, 255)
		outputChatBox("Mann: Kannst du ein P\\aeckchen zum Parkplatz am Leuchtturm in BaySide bringen?", thePlayer, 255, 255, 255)
		outputChatBox("Mann: Du wirst dort bereits erwartet. Aber bitte beeile dich, der Empf\\aenger hat nur noch 4 Minuten Zeit!", thePlayer, 255, 255, 255)
		return true
	end
		
Quest.onResume = 
	function(thePlayer)
		if ( thePlayer:isQuestActive(Quest) ~= "Finished" ) then
			Quest:triggerClientScript(thePlayer, "Accepted", false)
		end
		return true
	end

Quest.onProgress = 
	function(thePlayer)
		return true
	end

Quest.onFinish = 
	function(thePlayer)
		return true
	end
	
Quest.onTurnIn =
	function(thePlayer)
		outputChatBox("Mann: Das war knapp aber okay, danke f\\uer die schnelle Lieferung!", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")