--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 25
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Bring dem Regisseur einen Doominator!",
	["Finished"] = "Du hast den Doominator \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				local QuestState = thePlayer:isQuestActive(Quest)
				if (QuestState and not(QuestState == "Finished")) then
					if (thePlayer:getInventory():removeItem(Items[18], 1)) then
						thePlayer:refreshInventory()
						Quest:playerFinish(thePlayer)
					else
						thePlayer:showInfoBox("error", "Du besitzt keinen Doominator!")
					end
				end
			end
		end
	)
end

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[24]) ) then
			return true
		end
		return false
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 0, 1478.9609375, -1684.9755859375, 14.046875
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Regisseur: Nun haben wir fast alles hier was wir beim Dreh ben\\oetigen.", thePlayer, 255,255,255)
		outputChatBox("Regisseur: Aber mir f\\aellt gerade ein..", thePlayer, 255,255,255)
		outputChatBox("Regisseur: Es fehlt noch ein Doominator! Ich w\\aere dir sehr dankbar wenn du diesen besorgen k\\oenntest.", thePlayer, 255,255,255)
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
		outputChatBox("Regisseur: Du bist wirklich Spitze! Nun k\\oennen wir endlich den Film drehen!", thePlayer, 255,255,255)
		return true
	end

Quest.onTurnIn =
    function(thePlayer)
	outputChatBox("Regisseur: Ich danke dir wirklich sehr f\\uer deine Hilfe. Machs gut!", thePlayer, 255,255,255)
	Achievements[129]:playerAchieved(thePlayer)
       return true
    end	

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[18], 1)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")