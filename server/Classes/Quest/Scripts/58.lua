--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 58
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Kaufe 10 Gramm Crystal Meth und bring es nach Angel Pine!",
	["Finished"] = "Du hast 10 Gramm Crystal Meth \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(3)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
					local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						if (thePlayer:getInventory():removeItem(Items[9], 10)) then
							thePlayer:refreshInventory()
							Quest:playerFinish(thePlayer)
						else
							thePlayer:showInfoBox("error", "Du besitzt zu wenig Crystal Meth!")
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
		return 0, 0, -2088.75390625, -2468.4716796875, 30.625
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Dealer: Ich habe eine Bestellung aus Angel Pine.", thePlayer, 255,255,255)
		outputChatBox("Dealer: Es handelt sich um 10 Gramm Crystal Meth.", thePlayer, 255,255,255)
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
			thePlayer:getInventory():addItem(Items[9], 10)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")