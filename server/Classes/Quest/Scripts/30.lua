--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 30
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Besorge deiner Gang die Waffen.",
	["Finished"] = "Das gen\\uegt."
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
					local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						if (thePlayer:getInventory():removeItem(Items[245], 3)) then
							thePlayer:refreshInventory()
							Quest:playerFinish(thePlayer)
						else
							thePlayer:showInfoBox("error", "Ey Dude! Du brauchst noch mehr Waffen!")
						end
					end
				end
			end
		end
	)
end

Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if (thePlayer:getFaction():getID() == 4) then
			return true
		end
		return false
	end

Quest.getTaskPosition = 
	function()
		--Should return int, dim, x, y, z
		return 0, 0, 963.3486328125, -929.556640625, 42.696311950684
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Mac the Knife: Jetzt geh und besorge die Waffen! Go Homie!", thePlayer, 255,255,255)
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
		outputChatBox("Mac the Knife: Danke Homie! Damit werden wir die Vagos klatschen. ", thePlayer, 255,255,255)
		outputChatBox("Mac the Knife: Komm gerne jeden Tag wieder vorbei. Wir brauchen noch viel mehr Waffen! ", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[245], 3)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")