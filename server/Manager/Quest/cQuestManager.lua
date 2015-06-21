--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CQuestManager = inherit(cSingleton)

function CQuestManager:constructor()
	local start = getTickCount()
	
	self.PersistentClasses = {}
	
	--QuestRewards
	local result = CDatabase:getInstance():query("SELECT * FROM quest_reward")
	if(#result > 0) then
		for key, value in pairs(result) do
			new(CQuestReward, value["ID"], value["Points"], value["Social_State"], fromJSON((value["Items"]) or "{ [ ] }"), value["Money"])
		end
		outputServerLog("Es wurden "..tostring(#result).." Quest Rewards gefunden!")
	else
		outputServerLog("Es wurden keine Quest Rewards gefunden!")
	end
	
	--Quests (Dependency -> CQuestReward)
	local result = CDatabase:getInstance():query("SELECT * FROM quest")
	if(#result > 0) then
		for key, value in pairs(result) do
			new(CQuest, value["ID"], value["Name"], value["Description"], value["Type"], QuestRewards[value["Reward"]])
		end
		outputServerLog("Es wurden "..tostring(#result).." Quests gefunden!")
	else
		outputServerLog("Es wurden keine Quests gefunden!")
	end
	
	--QuestPeds (Dependency -> CQuest)
	local result = CDatabase:getInstance():query("SELECT * FROM quest_npc")
	if(#result > 0) then
		for key, value in pairs(result) do
			local pos = fromJSON(value["Position"])
			local ped = createPed(value["Skin"], pos["X"], pos["Y"], pos["Z"], pos["Rot"], false)
			setElementInterior(ped, pos["Int"])
			setElementDimension(ped, pos["Dim"])
			enew(ped, CQuestPed, value["ID"] ,value["Type"], fromJSON(value["Quests"]))
		end
		outputServerLog("Es wurden "..tostring(#result).." QuestPeds gefunden!")
	else
		outputServerLog("Es wurden keine QuestPeds gefunden!")
	end
	
	for k,v in pairs(Quests) do
		if (fileExists("server/Classes/Quest/Scripts/"..tostring(v:getID())..".lua")) then
			local script = fileOpen("server/Classes/Quest/Scripts/"..tostring(v:getID())..".lua", true)
			local length = fileGetSize(script)
			local code = fileRead(script, (length or 0))
			loadstring(code)()
			fileClose(script)
		end
	end
	
	self:loadPersistentScripts()
	
	outputServerLog("CQuestManager completed! (" .. getTickCount() - start .. "ms)")
	
	addEvent("onClientRequestQuestData", true)
	addEventHandler("onClientRequestQuestData", getRootElement(),
		function()
			triggerClientEvent(client, "onClientRecieveQuestData", getRootElement(), Quests, QuestPeds)
		end
	)
end

function CQuestManager:destructor()

end

function CQuestManager:loadPersistentScripts()
	--Johnnytum
	self.PersistentClasses["Johnnytum"] = new(CJohnnytum)
end