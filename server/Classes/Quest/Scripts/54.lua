--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]


local QuestID = 54
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Klicke den Quest NPC mit Linksklick an.",
	["Finished"] = "Super gemacht!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
					local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						Quest:playerFinish(thePlayer)
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
		return 0, 0, 963.3486328125, -929.556640625, 42.696311950684
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Quest-NPC: Jetzt ganz einfach (m) und dann Linksklick auf mich!", thePlayer, 255,255,255)
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
		outputChatBox("Quest-NPC: Sehr gut gemacht!", thePlayer, 255,255,255)
		outputChatBox("Quest-NPC: Wenn du bei einem NPC ein Item abgeben musst, dann kannst du wie grade eben", thePlayer, 255,255,255)
		outputChatBox("Quest-NPC: ganz einfach mit Linksklick auf ihn klicken.", thePlayer, 255,255,255)
		outputChatBox("Quest-NPC: Am besten schaust du dich mal hier in der Nähe um. Es gibt sehr viele Aufgaben in Los Santos!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			outputChatBox("Quest-NPC: Du h\\aettest das Quest nicht abbrechen m\\uessen. Versuch es doch bitte noch einmal erneut!", thePlayer, 255,255,255)
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")