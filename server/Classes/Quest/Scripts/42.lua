--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 42
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Finde die \\aermliche H\\uette des Kirchenpatrons!",
	["Finished"] = "Finde die \\aermliche H\\uette des Kirchenpatrons!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[41]) ) then
			return true
		end
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 25000, 5145.4004, -2850.8994, 81.3
	end

Quest.onAccept = 
	function(thePlayer)
		Quest:playerFinish(thePlayer)
		return true
	end
		
Quest.onResume = 
	function(thePlayer)
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
		outputChatBox("Frau: Du bist aber nicht der Kirchenpatron! Tripper Activated!", thePlayer, 255,255,255)
		killPed(thePlayer)
		Achievements[130]:playerAchieved(thePlayer)
		return true
	end
	
Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")