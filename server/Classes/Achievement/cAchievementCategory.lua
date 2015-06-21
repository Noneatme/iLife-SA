--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

AchievementCategories = {}

CAchievementCategory = {}

function CAchievementCategory:constructor(iID, sName, sDescription)
	self.ID = iID
	self.Name = sName
	self.Description = sDescription
	
	self.Achievements = {}
	
	AchievementCategories[self.ID] = self
end

function CAchievementCategory:destructor()

end

function CAchievementCategory:getID()
	return self.ID
end


function CAchievementCategory:getName()
	return self.Name
end

function CAchievementCategory:getDescription()
	return self.Description
end

function CAchievementCategory:addAchievement(Achievement)
	self.Achievements[Achievement:getID()] = true
end

addEvent("onClientRequestAchievementData", true)
addEventHandler("onClientRequestAchievementData", getRootElement(),
	function()
		local Data = {}
		for k,v in pairs(AchievementCategories) do
			Data[k] = {["Name"]=v:getName(), ["Description"]=v:getDescription()}
		end
		triggerClientEvent(client, "onClientAchievementCategoriesRecieve", getRootElement(), Data)
	end
)