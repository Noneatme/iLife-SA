--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CAdManager = inherit(cSingleton)

addEvent("onClientRequestAds", true)
addEvent("onClientSubmitAd", true)

function CAdManager:constructor()

	addEventHandler("onClientRequestAds", getRootElement(), bind(self.Request, self))
	addEventHandler("onClientSubmitAd", getRootElement(), bind(self.Submit, self))
	
	self.tUpdate = bind(self.Update, self)
	setTimer(self.tUpdate, 60000, 0)
	
	self.Advertisments = {}
	self:Update()
end

function CAdManager:destructor()

end

function CAdManager:Update()
	self.Advertisments = {}
	local result = CDatabase:getInstance():query("SELECT * FROM advertisments WHERE Expire>NOW();")
	if(result) and (#result > 0) then
		for k,v in ipairs(result) do
			table.insert(self.Advertisments, v)
		end
	end
end

function CAdManager:Request(thePlayer)
	triggerClientEvent(thePlayer, "onClientRecieveAd", thePlayer, self.Advertisments)
end

function CAdManager:Submit(duration, text)
	local thePlayer = client
	
	local addTime = "00:00:00"
	local valid = false
	if (duration == 1) then
		addTime = "01:00:00"
		valid = thePlayer:getInventory():removeItem(Items[33], 1)
	end
	if (duration == 2) then
		addTime = "02:00:00"
		valid = thePlayer:getInventory():removeItem(Items[34], 1)
	end
	if (duration == 3) then
		addTime = "05:00:00"
		valid = thePlayer:getInventory():removeItem(Items[35], 1)
	end
	if (duration == 4) then
		addTime = "24:00:00"
		valid = thePlayer:getInventory():removeItem(Items[36], 1)
	end
	if (duration == 5) then
		addTime = "168:00:00"
		valid = thePlayer:getInventory():removeItem(Items[37], 1)
	end
	thePlayer:refreshInventory()
	
	if (valid) then
		CDatabase:getInstance():query("INSERT INTO advertisments(ID, Name, Telephone, Text, Expire) VALUES (NULL, ?, ?, ?, ADDTIME(NOW(), ?));", getPlayerName(thePlayer), 0, text, addTime)
		thePlayer:showInfoBox("info", "Deine Werbung wurde geschaltet!")
	else
		thePlayer:showInfoBox("error", "Die Werbeagentur hat einen Fehler gemeldet!")
	end
end