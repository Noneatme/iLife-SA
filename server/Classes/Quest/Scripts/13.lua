--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 13
local Quest = Quests[QuestID]

Quest.Texts = {
    ["Accepted"] = "Besorge Ryder sein Weed!",
    ["Finished"] = "Du hast das Weed! Kehre nun zu Ryder zur\\ueck!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(),
    function(ID, Status, Data)
        if (ID == QuestID) then
            if (Status == "Weed_Clicked") then
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
        return 0,0, 2531.1000976563, -1987.5999755859, 12.10000038147
    end

Quest.onAccept =
    function(thePlayer)
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

Quest.onAbort =
    function(thePlayer)
        return true
    end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")