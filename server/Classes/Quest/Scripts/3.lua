--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 3
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Gehe \\ueber die Stra\\sze!",
	["Finished"] = "Kehre zum Mann zur\\ueck!"
}

local finShape = createColSphere(1480.763671875, -1740.1015625, 13.546875,5)

addEventHandler("onColShapeHit", finShape, 
	function(theElement, matching)
		if (getElementType(theElement) == "player" and matching) then
			local QuestState = theElement:isQuestActive(Quest)
			if (QuestState and not(QuestState == "Finished")) then
				Quest:playerFinish(theElement)
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
		--Should return int, dim, x, y, z
		return 0,0, 1480.763671875, -1740.1015625, 13.546875
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Alter Mann: Danke, Junge!", thePlayer, 255,255,255)
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
		outputChatBox("Alter Mann: Wow, das hast du toll gemacht! Komm wieder her!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

----outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")