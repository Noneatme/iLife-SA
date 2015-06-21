--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Quests = {}

CQuest = {}

function CQuest:constructor(iID, sName, sText, iType, QuestReward)
	self.ID = iID
	self.Name = parseString(sName)
	self.Text = parseString(sText)
	
	self.Type = iType
	-- 1: normal quest
	-- 2: repatable quest
	-- 3: daily quest
	
	self.Reward = QuestReward
	
	self.Peds = {
		["Accept"] = {},
		["TurnIn"] = {}
	}
	
	-------------------------------------------
	--Following methods should be overwritten--
	-------------------------------------------
	self.playerReachedRequirements = 
	function(thePlayer)
		return true
	end

	self.getTaskPosition = 
	function()
		--should return int, dim, x, y, z
		return 0,0,0,0,0
	end

	self.onResume = 
	function(thePlayer)
		return true
	end
	
	self.onAccept = 
	function(thePlayer)
		return true
	end

	self.onProgress = 
	function(thePlayer)
		return true
	end

	self.onFinish = 
	function(thePlayer)
		return true
	end

	self.onTurnIn = 
	function(thePlayer)
		return true
	end
	
	self.onAbort = 
	function(thePlayer)
		return true
	end
	-------------------------------------------
	-------------------------------------------
	
	Quests[self.ID] = self
	
	self.clientScript = 'outputDebugString("There is no Questscript: client/Quests/Scripts/'..tostring(self.ID)..'.lua")'
	
	if (fileExists("client/Quests/Scripts/"..tostring(self.ID)..".lua")) then
		local script = fileOpen("client/Quests/Scripts/"..tostring(self.ID)..".lua", true)
		local length = (fileGetSize(script) or 0)
        if(length > 0) then
		    self.clientScript = fileRead(script, length)
        end
		fileClose(script)
	end
end

function CQuest:destructor()

end

function CQuest:getID()
	return self.ID
end

function CQuest:getName()
	return self.Name
end

function CQuest:getType()
	return self.Type
end

function CQuest:getReward()
	return self.Reward
end

function CQuest:addPed(Type, thePed)
	if (Type == 1) then
		table.insert( self.Peds["Accept"], thePed)
		table.insert( self.Peds["TurnIn"], thePed)
	end
	if (Type == 2) then
		table.insert( self.Peds["Accept"], thePed)
	end
	if (Type == 3) then
		table.insert( self.Peds["TurnIn"], thePed)
	end
end

function CQuest:getPeds(Type)
	if (Type == 1) then
		local tab = {}
		local ins = {}
		for k,v in ipairs(self.Peds["Accept"]) do
			if not(ins[v]) then
				ins[v] = true
				table.insert(tab, v)
			end
		end
		for k,v in ipairs(self.Peds["TurnIn"]) do
			if not(ins[v]) then
				ins[v] = true
				table.insert(tab, v)
			end
		end
		return tab
	end
	if (Type == 2) then
		return self.Peds["Accept"]
	end
	if (Type == 3) then
		return self.Peds["TurnIn"]
	end
end

function CQuest:executeClientScript(thePlayer)
	triggerClientEvent(thePlayer, "onServerRequestClientQuestScript", getRootElement(), self.clientScript)
end

function CQuest:triggerClientScript(thePlayer, State, Data)
	triggerClientEvent(thePlayer, "onClientQuestScript", getRootElement(), self.ID, State, Data)
end

function CQuest:playerAccept(thePlayer)
	if (thePlayer:isQuestActive(self)) then
		thePlayer:showInfoBox("error", "Diese Quest hast du bereits angenommen!")
		return false
	end
		
	if (thePlayer:isQuestFinished(self)) then
		if (self.Type == 1) then
			thePlayer:showInfoBox("error", "Du kannst diese Quest nur einmal abschließen!")
			return false
		end
		if (self.Type == 3) then
			local time = getRealTime()
			if (thePlayer:isQuestFinished(self) + 79200 > time["timestamp"] ) then
				thePlayer:showInfoBox("error", "Du kannst diese Quest nur alle 22 Stunden abschließen!")
				return false
			end
		end
	end
	
	-- output-handling through method
	if not (self.playerReachedRequirements(thePlayer)) then
		return false
	end
	
	self:executeClientScript(thePlayer)
	if  not ( thePlayer:addQuestToLog(self) ) then
		self:triggerClientScript(thePlayer, "Aborted", false)
		return false
	end
	
	thePlayer:incrementStatistics("Quests", "Angenommen", 1)
	triggerClientEvent(thePlayer, "onServerPlaySavedSound", getRootElement(), "/res/sounds/wow/quest_accept.mp3", "quest_accept", false)
	
	-- onAccept call
	return self.onAccept(thePlayer)
end

function CQuest:playerProgress(thePlayer, Progressvalue)
	thePlayer:setQuestState(self, Progressvalue)

	-- onProgress call
	return self.onProgress(thePlayer)
end

function CQuest:playerFinish(thePlayer)
	thePlayer:setQuestState(self, "Finished")
	
	-- onFinish call
	return self.onFinish(thePlayer)
end

function CQuest:playerAbort(thePlayer)
	-- onAbort call
	local returnValue = self.onAbort(thePlayer)
	
	thePlayer:setQuestState(self, "Aborted")
	
	return returnValue
end

function CQuest:playerResume(thePlayer)
	--Execute ClientScript
	self:executeClientScript(thePlayer)
	
	-- onResume call
	return self.onResume(thePlayer)
end

addEvent("onPlayerAcceptQuest", true)
addEvent("onPlayerTurnInQuest", true)
addEvent("onPlayerAbortQuest", true)
addEvent("onClientCallsServerQuestScript", true)

addEventHandler("onPlayerAcceptQuest", getRootElement(),
	function(id) 
		Quests[tonumber(id)]:playerAccept(client)
	end
)

addEventHandler("onPlayerTurnInQuest", getRootElement(),
	function(id) 
		client:removeQuestFromLog(Quests[tonumber(id)], true)
	end
)

addEventHandler("onPlayerAbortQuest", getRootElement(),
	function(id) 
		client:removeQuestFromLog(Quests[tonumber(id)], false)
	end
)

addCommandHandler("dumpjsonpos", 
	function(thePlayer) 
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		local _,_,rot = getElementRotation(thePlayer)
		local x,y,z = getElementPosition(thePlayer)
		outputChatBox(toJSON({["Int"]=int,["Dim"]=dim,["X"]=x,["Y"]=y,["Z"]=z,["Rot"]=rot}), thePlayer)
	end
)