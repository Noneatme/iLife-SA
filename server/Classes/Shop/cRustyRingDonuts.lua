--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CRustyRingDonuts = inherit(CShop)

function CRustyRingDonuts:constructor(dim)
	self.Dim = dim

	self.Ped = createPed ( 168, 380.658203125, -188.90625, 1000.6328125, 180, false)
	setElementInterior(self.Ped, 17)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Ped2 = createPed ( 168, 380.6630859375, -185.9365234375, 1000.6328125, 73, false)
	setElementInterior(self.Ped2, 17)
	setElementDimension(self.Ped2, self.Dim)
	setElementData(self.Ped2, "EastereggPed", true)

	self.Marker = createMarker(379.3515625, -190.4814453125, 1000.6328125, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 17)
	setElementDimension(self.Marker, self.Dim)

	ItemShops[6].addMarker(ItemShops[6], 17, dim, 379.0107421875, -185.4541015625, 1000.6328125)

	self.Menus = {
		[1] = createObject(2221, 379.89999389648, -186.89999389648, 1000.799987793, 0, 0, 0),
		[2] = createObject(2223, 379.89999389648, -187.95999389648, 1000.799987793, 0, 0, 0),
		[3] = createObject(2222, 379.89999389648, -188.89999389648, 1000.799987793, 0, 0, 0)
	}

	self.Names = {
		[1] = "Muffin&Donut",
		[2] = "Donut Surprise",
		[3] = "Double Donut"
	}

	self.Prices = {
		[1] = 3,
		[2] = 7,
		[3] = 12
	}

	self.Hunger = {
		[1] = 20,
		[2] = 45,
		[3] = 80
	}

	for k,v in ipairs(self.Menus) do
		setElementInterior(v, 17)
		setElementDimension(v, self.Dim)
	end

	self.eOnMarkerHit = bind(self.onMarkerHit, self)
	addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

	self.bStop = bind(self.stop, self)
	self.bNext = bind(self.next, self)
	self.bBack = bind(self.back, self)
	self.bBuy = bind(self.buy, self)

	self.Display = {}
	self.Texts = {}
	self.State = {}

	self.ID = dim-20000
	CShop.constructor(self, "RustyRingDonuts", self.ID)
end

function CRustyRingDonuts:destructor()

end

function CRustyRingDonuts:onMarkerHit(theElement, matchDimension)
	if (matchDimension) then
		if (getElementType(theElement) == "player") then
			self:start(theElement)
		end
	end
end

function CRustyRingDonuts:start(thePlayer)
	self.Display[getPlayerName(thePlayer)] = textCreateDisplay()

	self.Texts[getPlayerName(thePlayer)] = {}

	self.State[getPlayerName(thePlayer)] = 1

	self.Texts[getPlayerName(thePlayer)]["Menu"] = textCreateTextItem(self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$", 0.05, 0.8)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Menu"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Menu"])

	self.Texts[getPlayerName(thePlayer)]["Control1"] = textCreateTextItem("Links/Rechts - Vor/Zurück", 0.05, 0.85)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control1"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control1"])

	self.Texts[getPlayerName(thePlayer)]["Control2"] = textCreateTextItem("Leertaste - Kaufen", 0.05, 0.9)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control2"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control2"])

	self.Texts[getPlayerName(thePlayer)]["Control3"] = textCreateTextItem("Enter - Verlassen", 0.05, 0.95)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control3"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control3"])

	textDisplayAddObserver(self.Display[getPlayerName(thePlayer)], thePlayer)

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.5, ly, lz+0.5, lx, ly, lz)

	toggleAllControls(thePlayer, false)

	bindKey(thePlayer, "enter", "down", self.bStop)
	bindKey(thePlayer, "space", "down", self.bBuy)
	bindKey(thePlayer, "left", "down", self.bBack)
	bindKey(thePlayer, "right", "down", self.bNext)

end

function CRustyRingDonuts:stop(thePlayer)
	textDestroyDisplay(self.Display[getPlayerName(thePlayer)])
	self.Display[getPlayerName(thePlayer)] = nil

	textDestroyTextItem(self.Texts[getPlayerName(thePlayer)]["Menu"])
	self.Texts[getPlayerName(thePlayer)]["Menu"] = nil

	textDestroyTextItem(self.Texts[getPlayerName(thePlayer)]["Control1"])
	self.Texts[getPlayerName(thePlayer)]["Control1"] = nil

	textDestroyTextItem(self.Texts[getPlayerName(thePlayer)]["Control2"])
	self.Texts[getPlayerName(thePlayer)]["Control2"] = nil

	textDestroyTextItem(self.Texts[getPlayerName(thePlayer)]["Control3"])
	self.Texts[getPlayerName(thePlayer)]["Control3"] = nil

	self.State[getPlayerName(thePlayer)] = nil

	unbindKey(thePlayer, "enter", "down", self.bStop)
	unbindKey(thePlayer, "space", "down", self.bBuy)
	unbindKey(thePlayer, "left", "down", self.bBack)
	unbindKey(thePlayer, "right", "down", self.bNext)

	toggleAllControls(thePlayer, true)

	setCameraTarget(thePlayer, thePlayer)
end

function CRustyRingDonuts:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Menus) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.5, ly, lz+0.5, lx, ly, lz)
end

function CRustyRingDonuts:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Menus
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.5, ly, lz+0.5, lx, ly, lz)
end

function CRustyRingDonuts:buy(thePlayer)
	local choose = self.State[getPlayerName(thePlayer)]
	if (thePlayer:payMoney(self.Prices[choose])) then
		thePlayer:eat(self.Hunger[self.State[getPlayerName(thePlayer)]])
	end
end
