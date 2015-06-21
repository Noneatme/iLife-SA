--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 33
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Hole die Sprunk-Bestellung ab!",
	["Finished"] = "Bringe die Sprunk-Bestellung zum Burger-Shot Nord!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Sprunk_Clicked") then
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
		return 0, 0, 1327.1999511719, 292.60000610352, 19
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Mitarbeiter: Guten Tag.", thePlayer, 255, 255, 255)
		outputChatBox("Mitarbeiter: Wir haben ein gro\\szes Problem. Uns ist leider der Sprunk-Vorrat ausgegangen.", thePlayer, 255, 255, 255)
		outputChatBox("Mitarbeiter: Wir w\\aeren sehr dankbar wenn du den Nachschub von der Sprunk-Fabrik in Montgomery abholen k\\oenntest!", thePlayer, 255, 255, 255)
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
		outputChatBox("Mitarbeiter: Vielen Dank! Nun k\\oennen wir endlich wieder Sprunk anbieten.", thePlayer, 255, 255, 255)
		outputChatBox("Mitarbeiter: Hier ist deine Belohnung. Viel Spa\\sz damit!", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")