--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 55
local Quest = Quests[QuestID]

Quest.Texts = {
    ["Accepted"] = "Bringe den Koffer zu schnell wie m\\oeglich zum Haupteingang des LV Airport!",
    ["Finished"] = "Spreche mit der Dame!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
    function(ID, Status, Data) 
        if (ID == QuestID) then
            if (Status == "AirportMarker_Hit") then
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
        return 0, 0, 403.60001, -1908, 0
    end

Quest.onAccept = 
    function(thePlayer)
		outputChatBox("Mann: Ich sollte meiner Frau die Koffer zum Airport bringen, leider bin ich jedoch am falschen Airport.", thePlayer, 255, 255, 255)
		outputChatBox("Mann: Kannst du die Koffer bitte schnell zum Las Venturas Airport bringen? Meine Frau wartet am Haupteingang.", thePlayer, 255, 255, 255)
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
	
Quest.onTurnIn =
	function(thePlayer)
		outputChatBox("Dame: Super. Danke das du mir die Koffer gebracht hast denn mein Flug geht gleich. Hier ist eine kleine Belohnung!", thePlayer, 255, 255, 255)
		return true
	end

Quest.onAbort = 
    function(thePlayer)
        return true
    end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")