--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 27
local Quest = Quests[QuestID]

Quest.Texts = {
	["Accepted"] = "Beschaffe die Pl\\aene des Caligulas Casino aus der Stadthalle!",
	["Finished"] = "Bring die Pl\\aene zu Wu Zi Mu!"
}

addEventHandler("onClientCallsServerQuestScript", getRootElement(), 
	function(ID, Status, Data) 
		if (ID == QuestID) then
			if (Status == "Plans_Hit") then
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
		return 0, 0, 1481.251953125, -1770.1982421875, 18.795755386353
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Wu Zi Mu: Hey "..thePlayer:getName().."!", thePlayer, 255, 255, 255 )
		outputChatBox("Wu Zi Mu: CJ hat es wieder mal nicht geschafft. Und so lange kann ich einfach nicht mehr warten, bis der in 6 Stunden aus dem Krankenhaus entlassen wird. K\\oenntest du mir einen Gefallen tun? Ich brauch dringend die Pl\\aene vom Caligula's Casino.", thePlayer, 255, 255, 255 )
		outputChatBox("Wu Zi Mu: Kannst du mir die Pl\\aene bitte beschaffen? Die Pl\\aene findest du in der Stadthalle. Ich w\\uerde das ja selber erledigen jedoch bin ich ja bli.. ich meine ich hab noch was zu erledigen..", thePlayer, 255, 255, 255 )
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
		outputChatBox("Wu Zi Mu: Ahh, danke für die Pl\\aene, endlich k\\oennen wir mit dem \\Ueberfa.. ich meine nat\\uerlich mit der Renovierung anfangen..", thePlayer, 255, 255, 255 )
		outputChatBox("Wu Zi Mu: Ich danke dir sehr f\\uer die Hilfe. Hier, nimm deine Belohnung!", thePlayer, 255, 255, 255 )
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")