--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CQuestDialog = {}

function CQuestDialog:constructor()
	self.Window = new(CDxWindow, "Quest Dialog", 755, 600, true, true, "Center|Middle")
	self.Window:setHideFunction(
		function() 
			self.Window:hide()
			self.enabled = false;
		end
	)
	
	self.dxList = new(CDxList, 10, 20, 320, 530, tocolor(125,125,125,200), self.Window, false)
	
	self.dxList:addColumn("Name")
	self.dxList:addColumn("Status")
	
	self.dxList:addClickFunction(
		function()
			self:refresh()
		end
	)
	
	self.IDS = {}
	
	self.NameLabel = new(CDxLabel, "Name:",350, 20, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Name = new(CDxLabel, "",350, 50, 400, 25, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)
	
	self.DescLabel = new(CDxLabel, "Beschreibung:",350, 90, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Desc = new(CDxLabel, "",350, 120, 400, 150, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)
	
	self.TargetLabel = new(CDxLabel, "Erstes Ziel:",350, 290, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Target = new(CDxLabel, "",350, 320, 400, 25, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)
	
	self.RewardLabel = new(CDxLabel, "Belohnung:",350, 360, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Reward = new(CDxLabel, "",350, 390, 400, 110, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)
	
	self.AcceptButton = new(CDxButton, "Annehmen", 340, 500, 400, 42, tocolor(255,255,255,255), self.Window)
	
	self.AcceptButton:addClickFunction(
		function()
			if (self.dxList:getRowData(2) == "Warte auf Annahme") then
				triggerServerEvent("onPlayerAcceptQuest", getRootElement(), self.ID)
			end
			if (self.dxList:getRowData(2) == "Fertig") then
				triggerServerEvent("onPlayerTurnInQuest", getRootElement(), self.ID)
			end
			self:close()
		end
	)
	
	self.AcceptButton:setVisible(false)
	self.AcceptButton:setDisabled(true)
	
	self.Window:add(self.dxList)
	self.Window:add(self.NameLabel)
	self.Window:add(self.Name)
	self.Window:add(self.DescLabel)
	self.Window:add(self.Desc)
	self.Window:add(self.TargetLabel)
	self.Window:add(self.Target)
	self.Window:add(self.RewardLabel)
	self.Window:add(self.Reward)
	self.Window:add(self.AcceptButton)
end

function CQuestDialog:destructor()
	
end

function CQuestDialog:open(acceptedQuests, acceptableQuests)
	if not (clientBusy) then
		if ( (table.size(acceptedQuests) + table.size(acceptableQuests)) == 0) then
			showInfoBox("info", "Hier gibt es nichts mehr zutun!")
			return false
		end
	
		self:refreshQuests(acceptedQuests, acceptableQuests)
		self:refresh()
		self.Window:show()
	end
end

function CQuestDialog:close()
	self.Window:hide()
end

function CQuestDialog:refreshQuests(acceptedQuests, acceptableQuests)
	self.dxList:clearRows()
	self.IDS = {}
	for k,v in pairs(acceptedQuests) do
		table.insert(self.IDS, tonumber(k))
		local Status = "Angenommen"
		if (PlayerActiveQuests[k] == "Finished") then
			Status = "Fertig"
		end
		self.dxList:addRow(Quests[tonumber(k)].Name.."|"..Status)
	end
	
	for k,v in pairs(acceptableQuests) do
		table.insert(self.IDS, tonumber(k))
		self.dxList:addRow(Quests[tonumber(k)].Name.."|Warte auf Annahme")
	end
end

function CQuestDialog:refresh()
	if (self.dxList.SelectedRow > 0) then
		self.ID = self.IDS[self.dxList.SelectedRow]
		
		self.NameLabel:setText("Name:")
		self.Name:setText(Quests[self.ID].Name)

		self.DescLabel:setText("Beschreibung:")
		self.Desc:setText(Quests[self.ID].Text)

		self.TargetLabel:setText("Erstes Ziel:")
		self.Target:setText(parseString(Quests[self.ID].Texts["Accepted"]))

		self.RewardLabel:setText("Belohnung:")
		
		self.Reward:setText(formQuestRewardString(self.ID))
	
		self.AcceptButton:setText("Quest Abgeben")
		self.AcceptButton:setVisible(true)
		self.AcceptButton:setDisabled(true)
		
		if (self.dxList:getRowData(2) == "Fertig") then
			self.AcceptButton:setDisabled(false)
		end
		if (self.dxList:getRowData(2) == "Warte auf Annahme") then
			self.AcceptButton:setText("Quest Annehmen")
			self.AcceptButton:setDisabled(false)
		end
	else
		self.NameLabel:setText("Bitte wähle eine Quest aus!")
		self.Name:setText("")

		self.DescLabel:setText("")
		self.Desc:setText("")

		self.TargetLabel:setText("")
		self.Target:setText("")

		self.RewardLabel:setText("")
		self.Reward:setText("")
	
		self.AcceptButton:setVisible(false)
		self.AcceptButton:setDisabled(true)
	end
end

QuestDialog = new(CQuestDialog)

addEvent("onClientOpenQuestDialog", true)
addEventHandler("onClientOpenQuestDialog", getRootElement(),
	function(acceptedQuests, acceptableQuests)
		QuestDialog:open(acceptedQuests, acceptableQuests)
	end
)
