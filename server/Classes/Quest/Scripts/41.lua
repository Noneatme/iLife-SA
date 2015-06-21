--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 41
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "K\\uemmer dich um den Freidenker!",
	["Finished"] = "Kehre zum Auftraggeber zur\\ueck!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Person_Killed") then
				outputChatBox("Freidenker: Sieh zu, dass du hier raus kommst!", client, 255,255,255)
				client:showInfoBox("info", "Du hast 1.000$ gefunden!")
				Quest:playerFinish(client)
			end
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[40]) ) then
			return true
		end
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0,0, 1033.8779296875, -316.9296875, 73.9921875
	end

Quest.onAccept = 
	function(thePlayer)
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
		outputChatBox("W\\aechter: Die 1.000$ nehme ich dir ab. Hilft deinem Seelenfrieden!", client, 255,255,255)
		return true
	end
	
Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")