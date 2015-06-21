--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 39
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Betrete das Hauptquartier!",
	["Finished"] = "Betrete das Hauptquartier!"
}

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[19]) ) then
			return true
		end
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0,25000, 2247.4008789062, -1357.8142089844, 24.5625
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Priester: Erfahre alles \\ueber uns!", thePlayer, 255,255,255)
		Quest:playerProgress(thePlayer, "Finished")
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

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")