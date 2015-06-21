--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

QuestPeds = {}

CQuestPed = {}

function CQuestPed:constructor(iID, iType, tblQuests)
	self.ID = iID
	
	self.Type = iType
	-- 1: Beides (Standard)
	-- 2: Nur annehmen
	-- 3: Nur abgeben
	
	self.Quests = tblQuests

	for k,v in pairs(self.Quests) do
		Quests[tonumber(k)]:addPed(tonumber(v), self)
	end
	
	setElementData(self, "Questped", true)
	setElementData(self, "Quests", self.Quests)
	
	setElementFrozen(self, true)
	setElementData(self, "EastereggPed", true)
	
	addEventHandler("onElementClicked", self, bind(CQuestPed.onClick, self))
	
	addEvent("onClientRequestAvaiablePedQuests", true)
	addEventHandler("onClientRequestAvaiablePedQuests", self,
		function()
			triggerClientEvent(client, "onClientRecieveNewPedQuests", getRootElement(), self, self:getAcceptedQuestsForPlayer(client), self:getAcceptableQuestsForPlayer(client))
		end
	)
	
	QuestPeds[self.ID] = self
end

function CQuestPed:onClick(button, state, thePlayer)
	if (button == "right" and state == "up") then
		triggerClientEvent(thePlayer, "onClientOpenQuestDialog", getRootElement(), self:getAcceptedQuestsForPlayer(thePlayer), self:getAcceptableQuestsForPlayer(thePlayer))
	end
end

function CQuestPed:destructor()

end

function CQuestPed:getAcceptableQuestsForPlayer(thePlayer)
	local quests = {}
	for k,v in pairs(self.Quests) do
		if (v == 1 or v == 2) then
			if thePlayer:isQuestAcceptable(Quests[tonumber(k)]) then
				quests[k] = v
			end
		end
	end
	return quests
end

function CQuestPed:getAcceptedQuestsForPlayer(thePlayer)
	local quests = {}
	for k,v in pairs(self.Quests) do
		if (v == 1 or v == 3) then
			if thePlayer:isQuestActive(Quests[tonumber(k)]) then
				quests[k] = v
			end
		end
	end
	return quests
end