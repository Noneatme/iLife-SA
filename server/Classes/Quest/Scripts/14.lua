--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 14
local Quest = Quests[QuestID]

Quest.Texts = {
    ["Accepted"] = "Gebe dem Priester den Antrag zur\ueck!",
    ["Finished"] = "Kehre zum Priester zur\ueck!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(),
    function(ID, Status, Data)
        if (ID == QuestID) then
            return true
        end
    end
)

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
        return 0,0, 2232.759765625, -1333.4404296875, 23.981597900391
    end

Quest.onAccept =
    function(thePlayer)
		outputChatBox("Prieser: Hab sogar schon alle Antworten eingetragen!", thePlayer, 255,255,255)
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
		outputChatBox("Prieser: So, nun zu den formellen Sachen!", thePlayer, 255,255,255)
        return true
    end

Quest.onTurnIn =
    function(thePlayer)
        return true
    end	
	
Quest.onAbort =
    function(thePlayer)
        return true
    end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")