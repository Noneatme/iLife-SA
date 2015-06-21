--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 24
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Bring dem Regisseur 5 Ecstasy!",
	["Finished"] = "Du hast die Pillen \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				local QuestState = thePlayer:isQuestActive(Quest)
				if (QuestState and not(QuestState == "Finished")) then
					if (thePlayer:getInventory():removeItem(Items[12], 5)) then
						thePlayer:refreshInventory()
						Quest:playerFinish(thePlayer)
					else
						thePlayer:showInfoBox("error", "Du besitzt zu wenig Ecstasy!")
					end
				end
			end
		end
	)
end

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[23]) ) then
			return true
		end
		return false
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 0, 392.310546875, -1819.76953125, 7.8414235115051
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Regisseur: Ich h\\aette da noch eine kleine Bitte..", thePlayer, 255,255,255)
		outputChatBox("Regisseur: Wir br\\aeuchten noch 5 Ecstasy Pillen.", thePlayer, 255,255,255)
		outputChatBox("Regisseur: K\\oenntest du uns das noch besorgen?", thePlayer, 255,255,255)
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
		outputChatBox("Regisseur: Wow, du hast es wirklich geschafft 5 Pillen aufzutreiben. Du bist unsere Rettung!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[12], 5)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")