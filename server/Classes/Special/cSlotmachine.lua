--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA Slotmachine Resource	##
-- ## Name: Slotmachine.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Slotmachine = {};
Slotmachine.__index = Slotmachine;

addEvent("onSlotmachineStartPlayer", true)
addEvent("onClientSlotmachinesGet", true)

slot_machines = {}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Slotmachine:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Reset		 		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Slotmachine:Reset()
	if(self.canSpin == false) then
		self.canSpin = true
		
		return true;
	end
end

-- ///////////////////////////////
-- ///// CalculateSpin 		//////
-- ///// Returns: int, string/////
-- ///////////////////////////////

function Slotmachine:CalculateSpin()
	local rnd = tonumber(math.random(1, 9))
	local grad = 0
	if(rnd == 1) then
		if(math.random(0, 5) == 5) then
			grad = 1100					-- 69
		else
			grad = 1300					-- Gold 1
		end
	elseif(rnd == 2) then
		if(math.random(0, 5) == 5) then
			grad = 1100					-- 69
		else
			grad = 2300					-- Weintraube
		end
	elseif(rnd == 3) then
		grad = 1600						-- Glocke
	elseif(rnd == 4) then
		grad = 2140						-- Kirsche
	elseif(rnd == 5) then
		grad = 1800						-- Gold 2
	elseif(rnd == 6) then
		grad = 1900						-- Weintraube
	elseif(rnd == 7) then
		grad = 1800						-- Glocke
	elseif(rnd == 8) then
		grad = 2140						--  -- Kische
	elseif(rnd == 9) then
		grad = 2140						-- Kirsche
	end
	
	return grad, self.settings.iconNames[grad];
end

-- ///////////////////////////////
-- ///// MoveLever	 		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Slotmachine:MoveLever(thePlayer)
	local x, y, z = getElementPosition(self.objects.hebel)
	local _, _, _, rx, ry, rz = getElementAttachedOffsets(self.objects.hebel)
--	local rx, ry, rz = getElementRotation(cSetting["slotmachine_hebel"][id])
	local _, _, rz = getElementRotation(self.objects.slotmachine)
	detachElements(self.objects.hebel)
	
	setElementPosition(self.objects.hebel, x, y, z)
	setElementRotation(self.objects.hebel, rx, ry, rz)
	
	
	moveObject(self.objects.hebel, 450, x, y, z, 50, 0, 0, "InQuad")
	
	setTimer(function()
		moveObject(self.objects.hebel, 450, x, y, z, -50, 0, 0, "InQuad")
	end, 450, 1)
	
	local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
	setTimer(triggerClientEvent, 150, 1, getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "start_machine", int, dim)
	
	
	setTimer(function() self:Spin(thePlayer) end, 500, 1, thePlayer)
	
	return true;
end

-- ///////////////////////////////
-- ///// Spin		 		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Slotmachine:Spin(thePlayer)
	local ergebnis = {}
	for i = 1, 3, 1 do
		local grad, icon = self:CalculateSpin()
		--	grad, icon = 900, "69"
		local x, y, z = getElementPosition(self.objects.rolls[i])
		local _, _, _, rx, ry, rz = getElementAttachedOffsets(self.objects.rolls[i])
		--if(rx == 0) then
		rx, _, _ = getElementRotation(self.objects.rolls[i])
		--end
		local _, _, rz = getElementRotation(self.objects.slotmachine)
		if(isElementAttached(self.objects.rolls[i])) then
			detachElements(self.objects.rolls[i])
			
			setElementPosition(self.objects.rolls[i], x, y, z)
			setElementRotation(self.objects.rolls[i], rx, ry, rz)
				
		end
		--	outputChatBox(grad-rx)
			
		--	outputChatBox(rx-grad)
		local s = moveObject(self.objects.rolls[i], 2500+(i*600), x, y, z, grad, 0, 0, "InQuad")
			
		ergebnis[i] = icon
	end
	setTimer(self.resultFunc, 4100, 1, ergebnis, thePlayer)
	return true;
end

-- ///////////////////////////////
-- ///// CheckRolls	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:CheckRolls()
	for i = 1, 3, 1 do
		local x, y, z = getElementPosition(self.objects.rolls[i])
		if not(isElementAttached(self.objects.rolls[i])) then
			local rx, ry, _ = getElementRotation(self.objects.rolls[i])
			
			moveObject(self.objects.rolls[i], 100, x, y, z, -rx, 0, 0, "InQuad")
		end
	end
end

-- ///////////////////////////////
-- ///// Start		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:Start(thePlayer)
	if(self.canSpin == true) then
		self.canSpin = false;
		self:CheckRolls()
		setTimer(function()
			self:MoveLever(thePlayer)
		end, 100, 1)
	end
end

-- ///////////////////////////////
-- ///// GiveWin	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:GiveWin(thePlayer, name, x, y, z, id)

	if(name == "explosion") then
		setTimer(function()
			createExplosion(x, y, z, 1)
		end, 1000, 1)

	elseif(name == "normal") then
		local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_stuff", int, dim)
		local rnd = math.random(0, self.prices.maxNormalRandomPrice)
		thePlayer:addMoney(self.prices.normalPrice+rnd)
		thePlayer:showInfoBox("info", "Du hast $"..(self.prices.normalPrice+rnd).." gewonnen!");
		
	elseif(name == "win") then
		local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_stuff", int, dim)
		local rnd = math.random(0, self.prices.maxNormalRandomPrice2);
		thePlayer:addMoney(self.prices.normalPrice2+rnd)
		thePlayer:showInfoBox("info", "Du hast $"..self.prices.normalPrice2.." gewonnen!");
		
	elseif(name == "jackpot") then
		local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_jackpot", int, dim)
		thePlayer:addMoney(self.prices.jackpot)
		thePlayer:showInfoBox("info", "Du hast $"..self.prices.jackpot.." gewonnen!");
		
		triggerClientEvent(getRootElement(), "onSlotmachineJackpot", getRootElement(), x, y, z)
	elseif(name == "rare") then
		local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_jackpot", int, dim)
		triggerClientEvent(getRootElement(), "onSlotmachineJackpot", getRootElement(), x, y, z)
		outputChatBox(getPlayerName(thePlayer).." WON THE RARE JACKPOT!!!", getRootElement(), 0, 255, 0)
		thePlayer:showInfoBox("info", "Du hast $"..self.prices.rareJackpot.." gewonnen!");
		thePlayer:addMoney(self.prices.rareJackpot)
	elseif(name == "drogen") then
		thePlayer:showInfoBox("info", "Du hast eine Wundertüte gewonnen!");
		thePlayer:getInventory():addItem(Items[13], 1)
		thePlayer:refreshInventory()
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_stuff", int, dim)
	elseif(name == "drogenselten") then
		thePlayer:showInfoBox("info", "Du hast einen Magic Mushroom gewonnen!");
		thePlayer:getInventory():addItem(Items[11], 1)
		thePlayer:refreshInventory()
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_stuff", int, dim)
	end
end

-- ///////////////////////////////
-- ///// DoResult	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:DoResult(ergebnis, thePlayer)
	local x, y, z = getElementPosition(self.objects.slotmachine)
--	cSetting["can_play"][id] = true
	local kirschen = 0
	local glocken = 0
	local weintrauben = 0
	local gold1 = 0
	local gold2 = 0
	local rare = 0
	
	for index, data in pairs(ergebnis) do
		if(data == "69") then
			rare = rare+1
		end
		if(data == "Glocke") then
			glocken = glocken+1
		end
		if(data == "Gold 1") then
			gold1 = gold1+1
			
		end
		if(data == "Gold 2") then
			gold2 = gold2+1
		end
		if(data == "Weintraube") then
			weintrauben = weintrauben+1
		end
		if(data == "Kirsche") then
			kirschen = kirschen+1
		end
	end

	local restart = true

	if(glocken == 2) or (weintrauben == 2) or (gold1 == 2) or(kirschen == 2) then
		self:GiveWin(thePlayer, "normal", x, y, z ,id)
	elseif(glocken == 3) then
		self:GiveWin(thePlayer, "win", x, y, z, id)
		self:GiveWin(thePlayer, "drogen", x, y, z, id)

	elseif(kirschen == 3) or (gold2 == 2) then
		self:GiveWin(thePlayer, "drogen", x, y, z, id)

	elseif(gold2 == 2) then
		restart = false
		self:GiveWin(thePlayer, "drogenselten", x, y, z, id)
	elseif(gold2 == 3) then
		self:GiveWin(thePlayer, "jackpot", x, y, z, id)
		self:GiveWin(thePlayer, "drogen", x, y, z, id)

	elseif(weintrauben == 3) then
		self:GiveWin(thePlayer, "explosion", x, y, z, id)
	elseif(rare == 3) then
		self:GiveWin(thePlayer, "rare", x, y, z, id)
	elseif(rare == 2) then
		self:GiveWin(thePlayer, "jackpot", x, y, z, id)
	else
		local int, dim = getElementInterior(self.objects.slotmachine), getElementDimension(self.objects.slotmachine)
		triggerClientEvent(getRootElement(), "onSlotmachineSoundPlay", getRootElement(), x, y, z, "win_nothing", int, dim)
	end
--	self:GiveWin(thePlayer, "waffen", x, y, z, id)
	if(restart == true) then
		setTimer(self.resetFunc, 1500, 1, id)
	end
end

-- ///////////////////////////////
-- ///// StartPlayer 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:StartPlayer(player)
	if(player:getMoney() >= self.prices.bet) then
		if(self.canSpin == true) then
			player:addMoney(-self.prices.bet)
		--	triggerClientEvent(player, "onSlotmachineWintext", player, "#FF0000-$"..self.prices.bet)
			player:showInfoBox("info", "-$"..self.prices.bet);
			
			self:Start(player)
		end
	else
	--	triggerClientEvent(player, "onSlotmachineWintext", player, "#FF0000You need $"..self.prices.bet.." to play on this machine")
		player:showInfoBox("error", "Dir fehlen $"..self.prices.bet.." um an dieser Slotmachine zu spielen!");
			
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Slotmachine:Constructor(x, y, z, rx, ry, rz, int, dim)
	if not(int) then
		int = 0
	end
	if not(dim) then
		dim = 0
	end
	
	-- Instances 
	self.prices = {}
	
	-- PRICES --
	-- Here you can change the winning things --
	self.prices.bet 					= 500;			-- Bet amount	
	
	self.prices.normalPrice 			= 5; 		-- Minimum Win Ammount (2 Right icons)			-- Info: This ammount will be there in ANY case
	self.prices.maxNormalRandomPrice 	= 700;			-- Maximum Random Win-add Ammount (2 Right icons)
								-- Maximum Win Ammount: normalPrice + maxNormalRandomPrice
	
	self.prices.normalPrice2 			= 5;			-- Minimum Win Ammount 2 (2 Right Rare Icons)	-- This too
	self.prices.maxNormalRandomPrice2 	= 700;			-- Maximum Random Win-add Ammount 2 (2 Right Rare Icons)
								-- Maximum Win Ammount: normalPrice + maxNormalRandomPrice
								
	self.prices.jackpot 				= 5000;		-- Jackpot Price
	self.prices.rareJackpot 			= 13370;		-- Rare Jackpot Price
	
	--  {5, 1, false}
	-- Definition:
	-- {iWeaponID, iWeaponAmmo}
		
	self.settings = {}
	
	
	-- Methods
	self.resultFunc = function(...) self:DoResult(...) end;
	self.resetFunc = function(...) self:Reset() end;
	self.startFunc = function(player) self:StartPlayer(player) end;
	self.hebelClickFunc	= function(btn, state, player) 
		if(btn == "left") and (state == "down") then 
			self:StartPlayer(player) 
		end 
	end;
	-- Instances
		
	self.objects = {}
	
	self.objects.rolls = {}
	-- self.hebel
	-- self.wood
	-- self.gun
	self.canSpin = true

	self.settings.iconNames = {
		[900] = "69",
		[1100] = "69",
		[1300] = "Gold 1",
		[1400] = "Glocke",
		[1500] = "Glocke",
		[1600] = "Glocke",
		[1700] = "Weintraube",
		[1800] = "Gold 2",
		[1900] = "Weintraube",
		[2000] = "Glocke",
		[2100] = "Weintraube",
		[2300] = "Weintraube",
		[2140] = "Kirsche",
	}
	
	-- Objects
	-- Slotmachine

	
	self.objects.slotmachine = createObject(2325, x, y, z, rx, ry, rz)
	setObjectScale(self.objects.slotmachine, 2)
	
	slot_machines[self.objects.slotmachine] = self.objects.slotmachine;
	-- Rolls
	
	for i = 1, 3, 1 do
		self.objects.rolls[i] = createObject(2347, x, y, z)
		setObjectScale(self.objects.rolls[i], 2)
		attachElements(self.objects.rolls[i], self.objects.slotmachine, -0.45+i/4, 0, 0)
	end
	
	-- Lever ( Hebel )
	
	self.objects.hebel = createObject(1319, x, y, z)
	attachElements(self.objects.hebel, self.objects.slotmachine, 0.9, -0.3, 0, 50, 0, rz*(360)/90)
	setElementFrozen(self.objects.hebel, true)
	setElementData(self.objects.hebel, "SLOTMACHINE:LEVER", true)
	
	-- Wood
	
	self.objects.wood = createObject(3260, x, y, z)
	setObjectScale(self.objects.wood, 0.7)
	attachElements(self.objects.wood, self.objects.slotmachine, 0, 0.5, -0.5)
	
	
	-- Dimension and Interior
	
	for index, object in pairs(self.objects) do
		if(type(object) == "table") then
			for index, e1 in pairs(object) do
				setElementInterior(e1, int)
				setElementDimension(e1, dim)
			end
		else
			setElementInterior(object, int)
			setElementDimension(object, dim)
		end
	end
	
--	outputDebugString("[CALLING] Slotmachine: Constructor");
	
	-- Events --
	addEventHandler("onElementClicked", self.objects.hebel, self.hebelClickFunc)
	addEventHandler("onSlotmachineStartPlayer", self.objects.hebel, self.startFunc)
	setElementData(self.objects.hebel, "SLOTMACHINE:ID", self) -- Store the Object in the element data
end

-- EVENT HANDLER --

-- DEVELOPMENT

function createSlotmachine(...)
	return Slotmachine:New(...);
end

addEventHandler("onClientSlotmachinesGet", getRootElement(), function() triggerClientEvent(source, "onSlotmachinesGet", source, slot_machines) end)


--local sl = Slotmachine:New(968.63092041016, 2074.1145019531, 11.22031211853, 0, 0, 0)
