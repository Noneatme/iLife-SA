--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 34
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Finde die Beute des Bankraubs!",
	["Finished"] = "Zahle die Kaution f\\uer den Gefangenen im LSPD!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "BankrobCase_Clicked") then
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
		return 0,0, -123.69999694824, 2257.1999511719, 27.799999237061
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("H\\aeftling: Na du, hab geh\\oert du kommst bald raus. K\\oenntest du mir einen Gefallen tun?", thePlayer, 255, 255, 255)
		outputChatBox("H\\aeftling: Ich hab eine Bank ausgeraubt, die Beute hab ich jedoch in einem Loch vergraben bevor ich gefasst wurde.", thePlayer, 255, 255, 255)		
		outputChatBox("H\\aeftling: Bitte hol die Beute und zahle die Kaution für mich, den Rest der Beute darfst du behalten!", thePlayer, 255, 255, 255)
		outputChatBox("H\\aeftling: Ach ja, bevor ich es vergesse.. das Loch ist \\oestlich von El Castillo del Diablo!", thePlayer, 255, 255, 255)
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
		outputChatBox("Officer: Der Gefangene wird noch heute freigelassen!", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")