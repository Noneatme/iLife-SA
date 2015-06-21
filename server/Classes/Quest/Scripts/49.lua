--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 49
local Quest = Quests[QuestID]
 
local QuestData = {}
 
local ChatTexts = {
        [1] = "Reazon",
}
 
Quest.Texts = {
    ["Accepted"] = "Sage dem Attent\\aeter deine Antwort.",
    ["Finished"] = "Richtige Antwort! Kehre zum Auftraggeber zurueck!"
}
 
addEventHandler("onClientCallsServerQuestScript", getRootElement(),
    function(ID, Status, Data)
        if (ID == QuestID) then
            return true
        end
    end
)
 
local playerChat = function(message, typ)
	local thePlayer = source
	if (getDistanceBetweenElements3D(Quest:getPeds(2)[1],thePlayer) < 10) then
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and not(QuestState == "Finished")) then
			if (ChatTexts[1] == message) then
				Quest:playerFinish(thePlayer)
			end
		end
	end
end
 
Quest.playerReachedRequirements = 
	function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[48]) ) then
			return true
		end
		return false
	end
 
Quest.getTaskPosition =
    function()
        --Should return int, dim, x, y, z
        return 0,0, 2232.759765625, -1333.4404296875, 23.981597900391
    end
 
Quest.onAccept =
    function(thePlayer)
                outputChatBox("Attent\\aeter: W\uerde mich wirklich interessieren!", thePlayer, 255,255,255)
                addEventHandler("onPlayerChat", thePlayer, playerChat)
        return true
    end
 
Quest.onResume =
    function(thePlayer)
                outputChatBox("Attent\\aeter: Jetzt aber mal zuegig!", thePlayer, 255,255,255)
                addEventHandler("onPlayerChat", thePlayer, playerChat)
        return true
    end
 
Quest.onProgress =
    function(thePlayer)
        return true
    end
 
Quest.onFinish =
    function(thePlayer)
                removeEventHandler("onPlayerChat", thePlayer, playerChat)
                outputChatBox("Attent\\aeter: Wenn du Zeit hast gibt es noch mehr.", thePlayer, 255,255,255)
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