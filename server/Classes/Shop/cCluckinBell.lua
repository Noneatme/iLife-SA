--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CCluckinBell = inherit(CShop)

function CCluckinBell:constructor(dim)
	self.Dim = dim

	self.Ped = createPed ( 167, 370.9169921875,-4.4921875,1001.8588867188, 180, false)
	setElementInterior(self.Ped, 9)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Ped2 = createPed ( 167, 367.287109375, -4.4921875, 1001.8515625, 180, false)
	setElementInterior(self.Ped2, 9)
	setElementDimension(self.Ped2, self.Dim)
	setElementData(self.Ped2, "EastereggPed", true)

	self.Marker = createMarker(370.8994140625, -6.0166015625, 1001.8588867188, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 9)
	setElementDimension(self.Marker, self.Dim)

	ItemShops[5].addMarker(ItemShops[5], 9, dim, 367.4052734375, -6.0166015625, 1001.8515625)

	self.Menus = {
		[1] = createObject(2215, 368.89999389648, -5.3000001907349, 1001.950012207, 335.216796875, 20.748168945313, 69.84814453125),
		[2] = createObject(2216, 369.70001220703, -5.3000001907349, 1001.950012207, 335.21484375, 20.747680664063, 69.845581054688),
		[3] = createObject(2217, 370.5, -5.3000001907349, 1001.950012207, 335.21484375, 20.747680664063, 69.845581054688)
	}

	self.Names = {
		[1] = "Cluckin Kid",
		[2] = "Burger Bell",
		[3] = "Clukin Xtreme"
	}

	self.Prices = {
		[1] = 5,
		[2] = 10,
		[3] = 15
	}

	self.Hunger = {
		[1] = 30,
		[2] = 60,
		[3] = 100
	}

	for k,v in ipairs(self.Menus) do
		setElementInterior(v, 9)
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

	CShop.constructor(self, "CluckinBell", self.ID)
end

function CCluckinBell:destructor()

end

function CCluckinBell:onMarkerHit(theElement, matchDimension)
	if (matchDimension) then
		if (getElementType(theElement) == "player") then
			self:start(theElement)
		end
	end
end

function CCluckinBell:start(thePlayer)
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
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)

	toggleAllControls(thePlayer, false)

	bindKey(thePlayer, "enter", "down", self.bStop)
	bindKey(thePlayer, "space", "down", self.bBuy)
	bindKey(thePlayer, "left", "down", self.bBack)
	bindKey(thePlayer, "right", "down", self.bNext)

end

function CCluckinBell:stop(thePlayer)
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

function CCluckinBell:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Menus) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CCluckinBell:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Menus
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CCluckinBell:buy(thePlayer)
	local choose = self.State[getPlayerName(thePlayer)]
	if (thePlayer:payMoney(self.Prices[choose])) then
		thePlayer:eat(self.Hunger[self.State[getPlayerName(thePlayer)]])
	end
end
