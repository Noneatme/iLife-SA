--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 4
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Erf\\uelle ihm seinen Wunsch!",
	["Finished"] = "Kehre zum Mann zur\\ueck!"
}

addCommandHandler("wank", 
	function(thePlayer)	
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and not(QuestState == "Finished")) then
			Quest:playerFinish(thePlayer)
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		return true
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0,0, 1480.763671875, -1740.1015625, 13.546875
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Sympathischer Typ: Fang an!", thePlayer, 255,255,255)
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
		outputChatBox("Sympathischer Typ: Whoah... Du hast es drauf!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

----outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")