--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 23
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Bring dem Regisseur ein Holzbett!",
	["Finished"] = "Du hast das Holzbett \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				local QuestState = thePlayer:isQuestActive(Quest)
				if (QuestState and not(QuestState == "Finished")) then
					if (thePlayer:getInventory():removeItem(Items[164], 1)) then
						thePlayer:refreshInventory()
						Quest:playerFinish(thePlayer)
					else
						thePlayer:showInfoBox("error", "Du besitzt kein Holzbett!")
					end
				end
			end
		end
	)
end

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		return true
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 0, 392.310546875, -1819.76953125, 7.8414235115051
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Regisseur: Wir brauchen dringend ein neues Holzbett f\uer unseren neuen Film!", thePlayer, 255,255,255)
		outputChatBox("Regisseur: Das alte Holzbett ist leider vor wenigen Minuten zerbrochen..", thePlayer, 255,255,255)
		outputChatBox("Regisseur: Kannst du schnell ein Neues besorgen?", thePlayer, 255,255,255)
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
		outputChatBox("Regisseur: Super, du hast das Holzbett dabei.", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[164], 1)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")