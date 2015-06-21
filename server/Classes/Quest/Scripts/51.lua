--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local QuestID = 51
local Quest = Quests[QuestID]

local EmptyVehicle = createVehicle(429, 1814.12890625, -1918.7626953125, 13.224563598633, 0, 0, 180)
setElementFrozen(EmptyVehicle, true)
setElementHealth(EmptyVehicle, 1000)
setVehicleDamageProof(EmptyVehicle, true)
setVehicleLocked(EmptyVehicle, true)
setVehicleEngineState(EmptyVehicle, false)

Quest.Texts = {
	["Accepted"] = "Besorge 2 Benzinkanister!",
	["Finished"] = "Du hast 2 Benzinkanister \\uebergeben!"
}

for k,v in ipairs(Quest:getPeds(2)) do
	addEventHandler("onElementClicked", v,
		function(button, state, thePlayer)
			if (button == "left") and (state == "down") then
				if (getDistanceBetweenElements3D(v,thePlayer) < 5) then
				local QuestState = thePlayer:isQuestActive(Quest)
					if (QuestState and not(QuestState == "Finished")) then
						if (thePlayer:getInventory():removeItem(Items[260], 2)) then
							thePlayer:refreshInventory()
							Quest:playerFinish(thePlayer)
						else
							thePlayer:showInfoBox("error", "Du hast zu wenig Benzinkanister!")
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
		return 0, 0, 1814.12890625, -1918.7626953125, 13.224563598633
	end

Quest.onAccept = 
	function(thePlayer)
		outputChatBox("Autofahrer: Mein geliebtes Fahrzeug f\\aehrt nicht mehr.", thePlayer, 255,255,255)
		outputChatBox("Autofahrer: Kannst du mir bitte 2 Benzinkanister besorgen?", thePlayer, 255,255,255)
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
		return true
	end

Quest.onAbort = 
	function(thePlayer)
		local QuestState = thePlayer:isQuestActive(Quest)
		if (QuestState and (QuestState == "Finished")) then
			thePlayer:getInventory():addItem(Items[260], 2)
			thePlayer:refreshInventory()
		end
		return true
	end

--outputDebugString("Loaded Questscript: server/Classes/Quest/Scripts/"..tostring(QuestID)..".lua")