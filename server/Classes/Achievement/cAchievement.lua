--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Achievements = {}

CAchievement = {}


clientAchievements = {
	[25]=true,
	[12]=true,
	[74]=true,
	[42]=true
}

addEvent("onClientUnlockedAchievement", true)
addEventHandler("onClientUnlockedAchievement", getRootElement(),
	function(ID)
		if clientAchievements[ID] then
			Achievements[ID]:playerAchieved(client)
		end
	end
)

function CAchievement:constructor(iID, sName, sDescription, iCategory, iReward)
	self.ID = iID
	self.Name = sName
	self.Description = sDescription
	self.Category = AchievementCategories[iCategory]
	self.Reward = AchievementRewards[iReward]
	
	self.Category:addAchievement(self)
	
	local pic = fileExists("res/images/achievements/"..tostring(self.ID)..".png")
	if (pic) then
		downloadManager:AddFile("res/images/achievements/"..tostring(self.ID)..".png")
	end

	Achievements[self.ID] = self
end

function CAchievement:destructor()

end

function CAchievement:playerAchieved(thePlayer)
	if thePlayer:addAchievement(self) then
		self.Reward:execute(thePlayer)
	end
end

function CAchievement:getID()
	return self.ID
end

function CAchievement:getName()
	return self.Name
end

function CAchievement:getDescription()
	return self.Description
end

function CAchievement:getCategory()
	return self.Category
end

function CAchievement:getReward()
	return self.Reward
end

addEvent("onClientRequestAchievementData", true)
addEventHandler("onClientRequestAchievementData", getRootElement(),
	function()
		local Data = {}
		for k,v in pairs(Achievements) do
			Data[k] = {["ID"]=v:getID(),["Name"]=v:getName(), ["Description"]=v:getDescription(), ["Category"]=v:getCategory():getID(), ["Reward"]={["Points"]=v:getReward():getPoints(),["Status"]=v:getReward():getStatus(), ["Items"]=v:getReward():getItems()}}
		end
		triggerClientEvent(client, "onClientAchievementDataRecieve", getRootElement(), Data)
	end
)