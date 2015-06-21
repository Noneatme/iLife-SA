--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 57
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Kaufe 5 Gramm Cannabis und bring es nach Creek!",
	["Finished"] = "Du hast 5 Gramm Cannabis \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(3)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
					local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						if (thePlayer:getInventory():removeItem(Items[10], 5)) then
							thePlayer:refreshInventory()
							Quest:playerFinish(thePlayer)
						else
							thePlayer:showInfoBox("error", "Du besitzt zu wenig Cannabis!")
						end
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
		return 0, 0, 2841.013671875, 2410.203125, 11.068956375122
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Dealer: Ich habe eine Bestellung aus Creek.", thePlayer, 255,255,255)
		outputChatBox("Dealer: Es handelt sich um 5 Gramm Cannabis.", thePlayer, 255,255,255)
		outputChatBox("Dealer: Wenn du willst kannst du das \\uebernehmen!", thePlayer, 255,255,255)
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
		outputChatBox("K\\aeufer: Danke! ich hoffe die Ware ist  von guter Qualit\\aet!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[10], 5)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")