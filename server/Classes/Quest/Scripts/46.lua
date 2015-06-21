--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 46
local Quest = Quests[QuestID]


Quest.Texts = {
	["Accepted"] = "Bringe die Ware zum Lieferort!",
	["Finished"] = "Erstatte deinem Auftraggeber bericht!"
}

function deliverp (thePlayer)
    Marker_Johnny = createMarker (2232.2470703125, -1333.1533203125, 22.981527328491, "cylinder",3,0,0,0,0)
	addEventHandler("onMarkerHit", Marker_Johnny, deliverfin)
end

function deliverfin (thePlayer)
	if (getElementType(thePlayer) == "player") then
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and not(QuestState == "Finished")) then
			Quest:playerFinish(thePlayer)
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
		return 0, 0, 2232.759765625, -1333.4404296875, 23.981597900391
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Dealer: Jetzt mach hinne! Sonst wird der Holy-Johnny mich noch umbringen!", thePlayer, 255,255,255)
		deliverp()
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
		outputChatBox("Priester: Oh, ist das f\\uer uns? Ungew\\oehnliche Uhrzeit und wie der Postbote sehen sie auch nicht aus.", thePlayer, 255,255,255)
		outputChatBox("Priester: Ach jetzt wei\\sz ich es wieder! Sie sind nett. Gerne jeden Tag wieder.", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort =
    function(thePlayer)
        return true
    end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")