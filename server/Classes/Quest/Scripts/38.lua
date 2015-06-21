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

Quest.Texts = {
	["Accepted"] = "Besorge etwas B\\aerenblut!",
	["Finished"] = "Bringe es dem Hohenpriester!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Bear_Killed") then
				Quest:playerFinish(client)
			end
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[37]) ) then
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

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")