--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 26
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Besorge eine Zeitung f\\uer die alte Dame!",
	["Finished"] = "Du hast der alten Dame die Zeitung \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				local QuestState = thePlayer:isQuestActive(Quest)
				if (QuestState and not(QuestState == "Finished")) then
					if (thePlayer:getInventory():removeItem(Items[199], 1)) then
						thePlayer:refreshInventory()
						Quest:playerFinish(thePlayer)
					else
						thePlayer:showInfoBox("error", "Du besitzt keine Zeitung!")
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
		return 0, 0, 951.5244140625, -981.3466796875, 39.07177734375
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Alte Dame: Kannst du mir bitte die Zeitung von heute besorgen? Ich w\\aere dir sehr dankbar.", thePlayer, 255,255,255)
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
		outputChatBox("Alte Dame: Vielen Dank f\\uer die Zeitung. Endlich habe ich was zum lesen.", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[199], 1)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")