--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Trades = {}

CTrade = {}

function CTrade:constructor(playerOne, playerTwo)
	self.playerOne = playerOne
	self.playerTwo = playerTwo
	
	self.playerOneItems = {}
	self.playerTwoItems = {}
	
	self.playerOneAccept = false
	self.playerTwoAccept = false
	
	Trades[playerOne] = self
	Trades[playerTwo] = self
	
	self:refreshElementDatas()
	
	triggerClientEvent(self.playerOne, "showTradeGui", self.playerOne, self.playerTwo)
	triggerClientEvent(self.playerTwo, "showTradeGui", self.playerTwo, self.playerOne)
end

function CTrade:destructor(success)
	if (success) then
		self.playerOne:showInfoBox("info", "Du hast erfolgreich gehandelt!")
		self.playerTwo:showInfoBox("info", "Du hast erfolgreich gehandelt!")
		triggerClientEvent(self.playerOne, "hideTradeGui", self.playerOne, true)
		triggerClientEvent(self.playerTwo, "hideTradeGui", self.playerTwo, true)
	else
		self.playerOne:showInfoBox("error", "Der Handel wurde abgebrochen!")
		self.playerTwo:showInfoBox("error", "Der Handel wurde abgebrochen!")
		triggerClientEvent(self.playerOne, "hideTradeGui", self.playerOne, true)
		triggerClientEvent(self.playerTwo, "hideTradeGui", self.playerTwo, true)
	end
	Trades[self.playerOne] = nil
	Trades[self.playerTwo] = nil
end

function CTrade:addAnItem(thePlayer, ItemID, count)
	if (thePlayer == self.playerOne) then
		if (not (self.playerOneItems[ItemID])) then
			if (thePlayer:getInventory():hasItem(Items[ItemID], count)) then
				self.playerOneItems[ItemID] = {["Name"]=Items[ItemID]["Name"],["Count"]= count}
				self.playerOneAccept = false
				self.playerTwoAccept = false
			else
				thePlayer:showInfoBox("error", "Du kannst nur Items tauschen, die du besitzt!")
			end
		else
			if (thePlayer:getInventory():hasItem(Items[ItemID], self.playerOneItems[ItemID]["Count"]+count)) then
				self.playerOneItems[ItemID]["Count"] = self.playerOneItems[ItemID]["Count"]+count
				self.playerOneAccept = false
				self.playerTwoAccept = false
			else
				thePlayer:showInfoBox("error", "Du kannst nur Items tauschen, die du besitzt!")
			end
		end
	elseif (thePlayer == self.playerTwo) then
		if (not (self.playerTwoItems[ItemID])) then
			if (thePlayer:getInventory():hasItem(Items[ItemID], count)) then
				self.playerTwoItems[ItemID] = {["Name"]=Items[ItemID]["Name"],["Count"]= count}
				self.playerOneAccept = false
				self.playerTwoAccept = false
			else
				thePlayer:showInfoBox("error", "Du kannst nur Items tauschen, die du besitzt!")
			end
		else
			if (thePlayer:getInventory():hasItem(Items[ItemID], self.playerTwoItems[ItemID]["Count"]+count)) then
				self.playerTwoItems[ItemID]["Count"] = self.playerTwoItems[ItemID]["Count"]+count
				self.playerOneAccept = false
				self.playerTwoAccept = false
			else
				thePlayer:showInfoBox("error", "Du kannst nur Items tauschen, die du besitzt!")
			end
		end
	end
	self:refreshElementDatas()
end

function CTrade:resetItems(thePlayer)
	if (thePlayer == self.playerOne) then
		self.playerOneItems = {}
	elseif (thePlayer == self.playerTwo) then
		self.playerTwoItems = {}
	end
	self.playerOneAccept = false
	self.playerTwoAccept = false
	
	self:refreshElementDatas()
end

function CTrade:changeAccept(thePlayer)
	if (thePlayer == self.playerOne) then
		self.playerOneAccept = true
	else
		self.playerTwoAccept = true
	end
	self:refreshElementDatas()
	
	if (self.playerOneAccept) then
		if (self.playerOneAccept == self.playerTwoAccept) then
			self:execute()
		end
	end
end

function CTrade:execute()
	local addTwo = {}
	for k,v in pairs(self.playerOneItems) do
		if (self.playerOne:getInventory():removeItem(Items[k], v["Count"])) then
			addTwo[k] = v
		end
	end
	
	local addOne = {}
	for k,v in pairs(self.playerTwoItems) do
		if (self.playerTwo:getInventory():removeItem(Items[k], v["Count"])) then
			addOne[k] = v
		end
	end
	
	for k,v in pairs(addOne) do
		self.playerOne:getInventory():addItem(Items[k], v["Count"], true)
	end
	
	for k,v in pairs(addTwo) do
		self.playerTwo:getInventory():addItem(Items[k], v["Count"], true)
	end
	
	self.playerOne:refreshInventory()
	self.playerTwo:refreshInventory()
	
	delete(self, true)
end

function CTrade:refreshElementDatas()
	self.playerOne:setData("Trade",{["Items"] = self.playerOneItems,["Accept"] = self.playerOneAccept } )
	self.playerTwo:setData("Trade",{["Items"] = self.playerTwoItems,["Accept"] = self.playerTwoAccept } )
end

addEvent("onPlayerAddTradeItem", true)
addEvent("onPlayerResetTradeItems", true)
addEvent("onPlayerAcceptTrade", true)
addEvent("onPlayerDeclineTrade", true)
addEvent("onTradeStart", true)


addEventHandler("onPlayerAddTradeItem", getRootElement(),
	function(ItemID, count)
		if not(clientcheck(source, client)) then return end
		if (Trades[source]) then
			if (isElement(Trades[source].playerOne) and isElement(Trades[source].playerOne)) then
				Trades[source]:addAnItem(source, ItemID, count)
			else
				delete(Trades[source], false)
			end
		end
	end
)

addEventHandler("onPlayerResetTradeItems", getRootElement(),
	function()
		if not(clientcheck(source, client)) then return end
		if (Trades[source]) then
			if (isElement(Trades[source].playerOne) and isElement(Trades[source].playerOne)) then
				Trades[source]:resetItems(source)
			else
				delete(Trades[source], false)
			end
		end
	end
)

addEventHandler("onPlayerAcceptTrade", getRootElement(),
	function()
		if not(clientcheck(source, client)) then return end
		if (Trades[source]) then
			if (isElement(Trades[source].playerOne) and isElement(Trades[source].playerOne)) then
				Trades[source]:changeAccept(source)
			else
				delete(Trades[source], false)
			end
		end
	end
)

addEventHandler("onPlayerDeclineTrade", getRootElement(),
	function()
		if not(clientcheck(source, client)) then return end
		if (Trades[source]) then
			if (isElement(Trades[source].playerOne) and isElement(Trades[source].playerOne)) then
				delete(Trades[source], false)
			else
				delete(Trades[source], false)
			end
		end
	end
)

addEventHandler("onTradeStart", getRootElement(), 
	function(thePlayer)
		if not(clientcheck(source, client)) then return end
		if (not (Trades[source]) and not(Trades[thePlayer])) then
			new(CTrade, source, thePlayer)
		else
			source:showInfoBox("error", "Man kann nur einen Handel gleichzeitig betreiben!")
		end
	end
)