--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 44
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Finde das Bike!",
	["Finished"] = "Kehre zum Biker zur\\ueck!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Bike_Clicked") then
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
		return 0,0, -2079.8000488281, -1687, 180.19999694824
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Biker: Hey du!", thePlayer, 255, 255, 255)
		outputChatBox("Biker: Ich bin gest\\uerzt und finde mein Bike nicht mehr.", thePlayer, 255, 255, 255)
		outputChatBox("Biker: Leider habe ich starke Schmerzen beim Gehen.. k\\oenntest du bitte mein Bike suchen?", thePlayer, 255, 255, 255)
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
		outputChatBox("Biker: Du hast mein Bike tats\\aechlich gefunden?", thePlayer, 255, 255, 255)
		outputChatBox("Biker: Ich danke dir sehr! Hier, nimm deine Belohnung.", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")