--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CAchievementManager = inherit(cSingleton)

function CAchievementManager:constructor()
	local start = getTickCount()
	--Categories
	local result = CDatabase:getInstance():query("SELECT * FROM achievement_category")
	if (#result > 0) then
		for k,v in ipairs(result) do
			new(CAchievementCategory, v["ID"], v["Name"], v["Description"])
		end
	end
	outputServerLog("Es wurden "..#result.." Achievement Kategorien gefunden! (" .. getTickCount() - start .. "ms)")
	
	start = getTickCount()
	--Rewards
	local result = CDatabase:getInstance():query("SELECT * FROM achievement_reward")
	if (#result > 0) then
		for k,v in ipairs(result) do
			new(CAchievementReward, v["ID"], v["Points"], v["Social_State"], v["Items"] or "[]")
		end
	end
	outputServerLog("Es wurden "..#result.." Achievement Rewards gefunden! (" .. getTickCount() - start .. "ms)")
	
	start = getTickCount()
	--Achievements
	local result = CDatabase:getInstance():query("SELECT * FROM achievement")
	if (#result > 0) then
		for k,v in ipairs(result) do
			new(CAchievement, v["ID"], v["Name"], v["Description"], v["Category"], v["Reward"])
		end
	end
	outputServerLog("Es wurden "..#result.." Achievements gefunden! (" .. getTickCount() - start .. "ms)")
end

function CAchievementManager:destructor()

end