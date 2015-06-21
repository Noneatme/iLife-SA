--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

QuestRewards = {}

CQuestReward = {}

function CQuestReward:constructor(iID, iPoints, sSocialState, tblItems, iMoney)
	self.ID = iID
	
	self.Points = iPoints
	self.SocialState = sSocialState
	self.Items = tblItems
	self.Money = iMoney
	
	QuestRewards[self.ID] = self
end

function CQuestReward:destructor()

end

function CQuestReward:execute(thePlayer)
	outputChatBox("Erhalten: ", thePlayer, 255,0,0)
	if (self.Points > 0) then
		thePlayer:addBonuspoints(self.Points)
		thePlayer:incrementStatistics("Quests", "Bonuspunkte_erhalten", self.Points)
		outputChatBox(self.Points.." Bonuspunkte", thePlayer, 125,0,0)
	end
	if (type(self.SocialState) == "string") then
		thePlayer:addStatus(self.SocialState)
		outputChatBox("Status: "..self.SocialState, thePlayer, 125,0,0)
	end
	if (type(self.Items) == "table") then
		local ItemString = "Items: "
		for k,v in pairs(self.Items) do
			ItemString = ItemString..tostring(v).."x "..Items[tonumber(k)].Name.."   "
			thePlayer:getInventory():addItem(Items[tonumber(k)], v)
		end
		thePlayer:refreshInventory()
		outputChatBox(ItemString, thePlayer, 125,0,0)
	end
	if (self.Money > 0) then
		thePlayer:addMoney(self.Money)
		thePlayer:incrementStatistics("Quests", "Geld_erhalten", self.Money)
		outputChatBox("Geld: "..self.Money, thePlayer, 125,0,0)
	end
	logger:OutputPlayerLog(thePlayer, "Erhielt Questbelohnung", self.ID)
end