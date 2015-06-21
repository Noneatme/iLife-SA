--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 40
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Spreche mit dem Mann vor der H\\oehle!",
	["Finished"] = "Spreche mit dem Mann vor der H\\oehle!"
}

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[39]) ) then
			return true
		end
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0,25000, 5094.080078125, -2728.30078125, 73.818511962891
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Verwalter: Er braucht bestimmt wieder Hilfe...", thePlayer, 255,255,255)
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