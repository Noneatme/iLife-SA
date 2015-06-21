--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Quests = {}
QuestRewards = {}
QuestPeds = {}

PlayerActiveQuests = {}
PlayerFinishedQuests = {}

addEvent("onClientRecieveQuestData", true)
addEventHandler("onClientRecieveQuestData", getRootElement(),
	function(tblQuests, tblQuestPeds)
		Quests = tblQuests
		QuestPeds = tblQuestPeds
		
		for k,v in ipairs(QuestPeds) do
			local x,y,z = getElementPosition(v)
			local int = getElementInterior(v)
			local dim = getElementDimension(v)
			local shape = createColSphere(x,y,z, 20)
			setElementInterior(shape, int)
			setElementDimension(shape, dim)
			
			addEventHandler("onClientColShapeHit", shape, 
				function(theElement, matching) 
					if (theElement == localPlayer and matching) then
						QuestRenderer:addPed(v)
					end
				end
			)
			
			addEventHandler("onClientColShapeLeave", shape, 
				function(theElement, matching) 
					if (theElement == localPlayer and matching) then
						QuestRenderer:removePed(v)
					end
				end
			)
			
		end
	end
)

addEvent("onClientRecievePlayerQuestData", true)
addEventHandler("onClientRecievePlayerQuestData", getRootElement(),
	function(tblActiveQuests, tblFinishedQuests)
		PlayerActiveQuests = tblActiveQuests
		PlayerFinishedQuests = tblFinishedQuests
		
		QuestLog:refreshQuests()
		setTimer( function() QuestRenderer:refreshIconStatus() end, 400, 1)
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		QuestRenderer = new(CQuestRenderer)
		triggerServerEvent("onClientRequestQuestData", getRootElement())
	end
)

CQuestRenderer = {}

function CQuestRenderer:constructor()
	self.Peds = {}
	
	self.Icons = {
		["Normal_Accept"] = "/res/images/quests/normal_accept.png",
		["Daily_Accept"] = "/res/images/quests/daily_accept.png",
		["Repeatly_Accept"] = "/res/images/quests/repeatable_accept.png",
		["Unfinished"] = "/res/images/quests/unfinished.png",
		["Finished"] = "/res/images/quests/normal_finished.png",
	}
	
	self.AvaiablePedQuests = {}

	self.PedIcons = {}
	
	self.onRender = bind(CQuestRenderer.render, self)
	
	addEvent("onClientRecieveNewPedQuests", true)
	addEventHandler("onClientRecieveNewPedQuests", getRootElement(), bind(CQuestRenderer.recieveNewPedQuests, self))
end

function CQuestRenderer:destructor()

end

function CQuestRenderer:recieveNewPedQuests(thePed, AcceptedQuests, AcceptableQuests)
	local tblQuests = {}
	
	for k,v in pairs(AcceptedQuests) do
		tblQuests[k] = true
	end
	
	for k,v in pairs(AcceptableQuests) do
		tblQuests[k] = true
	end
	
	self.AvaiablePedQuests[thePed] = tblQuests
	self:checkQuestIcon(thePed)
end


function CQuestRenderer:render()
	for index, ped in ipairs(self.Peds) do
		if(isElement(ped)) then
			local x, y, z = getPedBonePosition(ped, 6)
			local x2, y2, z2 = getElementPosition(localPlayer)
			if(isLineOfSightClear(x, y, z, x2, y2, z2, true, true, false, true, false, false, false)) then
				local sx, sy = getScreenFromWorldPosition(x, y, z+0.7)
				local sx2, sy2 = getScreenFromWorldPosition(x, y, z+0.2)
				if (sx) and (sy) and (sx2) and (sy2) then
					local x3, y3, z3 = getCameraMatrix()
					if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 20.2) then
						local icon = self.Icons[self.PedIcons[ped]]
						if (icon and (fileExists(icon))) then
							dxDrawImage(sx-((sy2-sy)/2), sy, sy2-sy, sy2-sy, icon, 0, 0, 0, tocolor(255,255,255,255), false)
						end
					else
						self:removePed(ped)
					end
				end
			end
		end
	end
end

function CQuestRenderer:addPed(thePed)
	table.insert(self.Peds, thePed)

	self:refreshIconStatus()
	
	if (#self.Peds == 1 ) then
		addEventHandler("onClientRender", getRootElement(), self.onRender)
	end
end

function CQuestRenderer:removePed(thePed)
	for k,v in ipairs(self.Peds) do
		if (v == thePed) then
			table.remove(self.Peds, k)
		end
	end
	
	self.PedIcons[thePed] = nil
	
	if (#self.Peds == 0 ) then
		removeEventHandler("onClientRender", getRootElement(), self.onRender)
	end
end

function CQuestRenderer:refreshIconStatus()
	for k,v in ipairs(self.Peds) do
		triggerServerEvent("onClientRequestAvaiablePedQuests", v)
	end
end

function CQuestRenderer:checkQuestIcon(v)
	local quests = self.AvaiablePedQuests[v]
	for kk,vv in pairs(quests) do
		if (PlayerActiveQuests[kk] == "Finished") then
			self.PedIcons[v] = "Finished"
			return true
		end
	end
	for kk,vv in pairs(quests) do
		if ( (Quests[tonumber(kk)].Type == 1) and (not PlayerActiveQuests[kk]) and (not PlayerFinishedQuests[kk])) then
			self.PedIcons[v] = "Normal_Accept"
			return true
		end
	end
	local timestamp = getRealTime()["timestamp"]
	for kk,vv in pairs(quests) do
		if ( (Quests[tonumber(kk)].Type == 3) and (not PlayerActiveQuests[kk]) and ( (not PlayerFinishedQuests[kk]) or ( not (PlayerFinishedQuests[kk]+79200 > timestamp)) ) ) then
			self.PedIcons[v] = "Daily_Accept"
			return true
		end
	end
	for kk,vv in pairs(quests) do
		if ( (Quests[tonumber(kk)].Type == 2) and (not PlayerActiveQuests[kk])) then
			self.PedIcons[v] = "Repeatly_Accept"
			return true
		end
	end
	for kk,vv in pairs(quests) do
		if ( (PlayerActiveQuests[kk])) then
			self.PedIcons[v] = "Unfinished"
			return true
		end
	end
	self:removePed(v)
end

function formQuestRewardString(QuestID)
	local RewardString = ""
		
	if (Quests[QuestID].Reward.Points > 0) then
		RewardString = RewardString.."Bonuspunkte: "..tostring(Quests[QuestID].Reward.Points).."\n"
	end
	if (Quests[QuestID].Reward.Money > 0) then
		RewardString = RewardString.."Geld: "..tostring(Quests[QuestID].Reward.Money).."$\n"
	end
	if (type(Quests[QuestID].Reward.SocialState) == "string") then
		RewardString = RewardString.."Sozialer Status: "..tostring(Quests[QuestID].Reward.SocialState).."\n"
	end
	if (type(Quests[QuestID].Reward.Items) == "table") then
		RewardString = RewardString.."Items: "
		for k,v in pairs(Quests[QuestID].Reward.Items) do
			RewardString = RewardString..tostring(v).."x "..Items[tonumber(k)].Name.."   "
		end
		RewardString = RewardString.."\n"
	end
	return RewardString
end

addEvent("onClientQuestScript", true)

function loadQuestScript(sourceCode)
	loadstring(sourceCode)()
end
addEvent("onServerRequestClientQuestScript", true)
addEventHandler("onServerRequestClientQuestScript", getRootElement(), loadQuestScript)

function triggerServerQuestScript(ID, Status, Data)
	triggerServerEvent("onClientCallsServerQuestScript", getRootElement(), ID, Status, Data)
end