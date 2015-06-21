--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 36
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Betrete die Kirche!",
	["Finished"] = "Betrete die Kirche!"
}

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[18]) ) then
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
		outputChatBox("Priester: Erf\\uelle deinen Geist!", thePlayer, 255,255,255)
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