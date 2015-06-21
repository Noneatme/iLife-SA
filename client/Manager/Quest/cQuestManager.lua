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
	self.PersistentClasses = {}
	self:loadPersistentScripts()
end

function CQuestManager:destructor()

end

function CQuestManager:loadPersistentScripts()
	--Johnnytum
	self.PersistentClasses["Johnnytum"] = new(CJohnnytum)
end

QuestManager = CQuestManager
