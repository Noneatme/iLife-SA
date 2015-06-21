--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 47
local Quest = Quests[QuestID]
 
local QuestData = {}
 
local ChatTexts = {
        [1] = "Commerce",
}
 
Quest.Texts = {
    ["Accepted"] = "Sage dem Attentaeter deine Antwort.",
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
	if (getDistanceBetweenElements3D(Quest:getPeds(2)[1],thePlayer) < 5) then
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
        return true
    end
 
Quest.getTaskPosition =
    function()
        --Should return int, dim, x, y, z
        return 0,0, 2232.759765625, -1333.4404296875, 23.981597900391
    end
 
Quest.onAccept =
    function(thePlayer)
                outputChatBox("Attent\\aeter: Jetzt raus mit der Sprache!", thePlayer, 255,255,255)
                addEventHandler("onPlayerChat", thePlayer, playerChat)
        return true
    end
 
Quest.onResume =
    function(thePlayer)
                outputChatBox("Attent\\aeter: Jetzt aber mal z\\uegig!", thePlayer, 255,255,255)
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
                outputChatBox("Attent\\aeter: Wenn du Zeit hast habe ich noch was f\\uer dich!", thePlayer, 255,255,255)
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