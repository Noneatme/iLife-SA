--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CQuestLog = {}

function CQuestLog:constructor()
	self.enabled = false;

	self.Window = new(CDxWindow, "Quest Log", 755, 600, true, true, "Center|Middle")
	self.Window:setHideFunction(
		function()
			self.Window:hide()
			self.enabled = false;
		end
	)

	self.dxList = new(CDxList, 10, 20, 320, 530, tocolor(125,125,125,200), self.Window, false)

	self.dxList:addColumn("Quest")

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

	self.TargetLabel = new(CDxLabel, "Aktuelles Ziel:",350, 290, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Target = new(CDxLabel, "",350, 320, 400, 25, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)

	self.RewardLabel = new(CDxLabel, "Belohnung:",350, 360, 400, 25, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", self.Window)
	self.Reward = new(CDxLabel, "",350, 390, 400, 110, tocolor(255,255,255,255), 1.0, "default", "left", "top", self.Window)

	self.AbortButton = new(CDxButton, "Abbrechen", 340, 500, 200, 42, tocolor(255,255,255,255), self.Window)
	self.FollowButton = new(CDxButton, "Verfolgen", 545, 500, 200, 42, tocolor(255,255,255,255), self.Window)

	self.AbortButton:addClickFunction(
		function()

			confirmDialog:showConfirmDialog("Bist du sicher, dass du diese Quest abbrechen möchtest?",
				function()
					triggerServerEvent("onPlayerAbortQuest", getRootElement(), self.ID)
					self.enabled = false;
					self.Window:hide()
				end, false, false)
		end
	)

	self.AbortButton:setVisible(false)
	self.FollowButton:setVisible(false)
	self.AbortButton:setDisabled(true)
	self.FollowButton:setDisabled(true)

	self.Window:add(self.dxList)
	self.Window:add(self.NameLabel)
	self.Window:add(self.Name)
	self.Window:add(self.DescLabel)
	self.Window:add(self.Desc)
	self.Window:add(self.TargetLabel)
	self.Window:add(self.Target)
	self.Window:add(self.RewardLabel)
	self.Window:add(self.Reward)
	self.Window:add(self.AbortButton)
	self.Window:add(self.FollowButton)

	bindKey("j", "down",
		function()
			if (LoggedIn) then
				QuestLog:toggle()
			end
		end
	)

end

function CQuestLog:destructor()

end

function CQuestLog:toggle()
	if not (clientBusy) or (self.enabled) then
		if not(self.enabled) then
			self:refreshQuests()
			self:refresh()
			self.Window:show()
			self.enabled = true;
			playSound("res/sounds/wow/questlog_open.ogg")
		else
			self.Window:hide()
			self.enabled = false;
			playSound("res/sounds/wow/questlog_close.ogg")
		end
	end
end

function CQuestLog:refreshQuests()
	self.dxList:clearRows()
	self.IDS = {}
	for k,v in pairs(PlayerActiveQuests) do
		if(tonumber(k)) then
			table.insert(self.IDS, tonumber(k))
			self.dxList:addRow(Quests[tonumber(k)].Name)
		end
	end
end

function CQuestLog:refresh()
	if (self.dxList.SelectedRow > 0) then
		self.ID = self.IDS[self.dxList.SelectedRow]

		self.NameLabel:setText("Name:")
		self.Name:setText(Quests[self.ID].Name)

		self.DescLabel:setText("Beschreibung:")
		self.Desc:setText(Quests[self.ID].Text)

		self.TargetLabel:setText("Aktuelles Ziel:")
		self.Target:setText(parseString(Quests[self.ID].Texts[PlayerActiveQuests[tostring(self.ID)]]))

		self.RewardLabel:setText("Belohnung:")

		self.Reward:setText(formQuestRewardString(self.ID))

		self.AbortButton:setVisible(true)
		self.FollowButton:setVisible(true)
		self.AbortButton:setDisabled(false)
		self.FollowButton:setDisabled(true)
	else
		self.NameLabel:setText("Bitte wähle eine Quest aus!")
		self.Name:setText("")

		self.DescLabel:setText("")
		self.Desc:setText("")

		self.TargetLabel:setText("")
		self.Target:setText("")

		self.RewardLabel:setText("")
		self.Reward:setText("")

		self.AbortButton:setVisible(false)
		self.FollowButton:setVisible(false)
		self.AbortButton:setDisabled(true)
		self.FollowButton:setDisabled(true)
	end
end

QuestLog = new(CQuestLog)
