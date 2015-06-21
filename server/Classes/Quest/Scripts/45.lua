--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 45
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Finde die Tatwaffe!",
	["Finished"] = "Bring die Waffe zum Officer im LSPD zur\\ueck!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Weapon_Clicked") then
				Quest:playerFinish(client)
			end
		end
	end
)

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[28]) ) then
			return true
		end
		return false
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 0, 2308.5380859375, -1646.048828125, 14.827047348022
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Officer: Wir m\\uessen dringend die Tatwaffe finden.", thePlayer, 255, 255, 255)
		outputChatBox("Officer: Melde dich falls du weitere Hinweise findest!", thePlayer, 255, 255, 255)
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
		outputChatBox("Officer: Wir werden die Waffe nun untersuchen.", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")