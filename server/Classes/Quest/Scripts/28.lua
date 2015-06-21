--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 28
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Finde den Gesuchten!",
	["GoBackToPD"] = "Kehre zum Officer zur\\ueck!",
	["Finished"] = "Informiere den Officer \\ueber deinen Fund!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Deadman_Clicked") then
				Quest:playerProgress(client, "GoBackToPD")
			end
			if (Status == "ReadyToTurnIn") then
				Quest:playerFinish(client)
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
		return 0,0, 917.79638671875, -1256.8568115234, 15.6640625
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Officer: Guten Tag, Sir.", thePlayer, 255, 255, 255)
		outputChatBox("Officer: Wir suchen einen seit Tagen vermissten Mann. Er wurde zuletzt in Ganton gesehen.", thePlayer, 255, 255, 255)
		outputChatBox("Officer: Falls Sie den Mann sehen sagen Sie ihm bitte er soll sich bei der Polizei melden.", thePlayer, 255, 255, 255)	
		return true
	end
		
Quest.onResume = 
	function(thePlayer)
		if ( thePlayer:isQuestActive(Quest) == "GoBackToPD" ) then
			Quest:triggerClientScript(thePlayer, "GoBackToPD", false)		
		elseif ( thePlayer:isQuestActive(Quest) ~= "Finished" ) then
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
		outputChatBox("Officer: Haben Sie neue Informationen f\\uer mich?", thePlayer, 255, 255, 255)
		return true
	end
	
Quest.onTurnIn =
	function(thePlayer)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")