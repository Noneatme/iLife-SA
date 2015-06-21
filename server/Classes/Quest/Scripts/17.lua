--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 17
local Quest = Quests[QuestID]

local QuestData = {}

local ChatTexts = {
	[1] = "Beschwere dich immer, auch wenn du einen Ban in Kauf nehmen musst.",
	[2] = "Wenn dich ein Gast bei dir zuhause nervt, behandle ihn grausam und ohne Gnade.",
	[3] = "Erlege keine nicht-menschlichen Tiere, solange du nicht angegriffen wirst oder Essen brauchst.",
	[4] = "Respektiere die Kraft der Bugs, Glitches und Trolls.",
	[5] = "Verletze keine Pflanzen.",
}

Quest.Texts = {
    ["Accepted"] = "Spreche dem Priester nach!",
    ["Finished"] = "Kehre zum Priester zur\ueck!"
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
			if (ChatTexts[QuestData[thePlayer]] == message) then
				if (QuestData[thePlayer] == 5) then
					QuestData[thePlayer] = nil
					Quest:playerFinish(thePlayer)
				else
					QuestData[thePlayer] = QuestData[thePlayer] +1
					outputChatBox("Prieser: "..ChatTexts[QuestData[thePlayer]], thePlayer, 255,255,255)
				end
			end
		end
	end
end

Quest.playerReachedRequirements =
    function(thePlayer, bOutput)
		if ( thePlayer:isQuestFinished(Quests[16]) ) then
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
		outputChatBox("Prieser: "..ChatTexts[1], thePlayer, 255,255,255)
		QuestData[thePlayer] = 1
		addEventHandler("onPlayerChat", thePlayer, playerChat)
        return true
    end

Quest.onResume =
    function(thePlayer)
		outputChatBox("Prieser: "..ChatTexts[1], thePlayer, 255,255,255)
        QuestData[thePlayer] = 1
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
		outputChatBox("Prieser: Du bist nun Johnny Level 1!", thePlayer, 255,255,255)
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