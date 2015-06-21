--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 35
local Quest = Quests[QuestID]

local DamagedVehicle = createVehicle(411, 1425.6171875, -933.970703125, 35.998378753662, 0, 0, 83.296691894531)
setElementFrozen(DamagedVehicle, true)
setElementHealth(DamagedVehicle, 350)
setVehicleDamageProof(DamagedVehicle, true)
setVehicleLocked(DamagedVehicle, true)
setVehicleDoorOpenRatio(DamagedVehicle, 0, 0.8)
setVehicleEngineState(DamagedVehicle, false)

Quest.Texts = {
	["Accepted"] = "Besorge 2 Reparaturkits!",
	["Finished"] = "Du hast 2 Reparaturkits \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
				local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						if (thePlayer:getInventory():removeItem(Items[261], 2)) then
							thePlayer:refreshInventory()
							Quest:playerFinish(thePlayer)
						else
							thePlayer:showInfoBox("error", "Du hast zu wenig Reparaturkits!")
						end
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
		return 0, 0, 1425.251953125, -933.9306640625, 36.000198364258
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Autofahrer: Ich bin versehentlich gegen eine Wand gefahren.", thePlayer, 255,255,255)
		outputChatBox("Autofahrer: Kannst du mir bitte 2 Reparaturkits besorgen?", thePlayer, 255,255,255)
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
		return true
	end
	
Quest.onTurnIn =
	function(thePlayer)
		outputChatBox("Autofahrer: Vielen Dank!", thePlayer, 255,255,255)
		outputChatBox("Autofahrer: Ich habe hier noch 3 Benzinkanister. Vielleicht kannst du damit etwas anfangen!", thePlayer, 255,255,255)
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[261], 2)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")