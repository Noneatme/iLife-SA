--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CWellStackedPizza = inherit(CShop)

function CWellStackedPizza:constructor(dim)
	self.Dim = dim

	self.Ped = createPed ( 155, 376.6845703125, -117.2783203125, 1001.4921875, 180, false)
	setElementInterior(self.Ped, 5)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Marker = createMarker(376.681640625,-118.94140625,1001.4995117188, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 5)
	setElementDimension(self.Marker, self.Dim)

	self.Ped2 = createPed ( 155, 372.91796875, -117.27734375, 1001.4921875, 180, false)
	setElementInterior(self.Ped2, 5)
	setElementDimension(self.Ped2, self.Dim)
	setElementData(self.Ped2, "EastereggPed", true)

	ItemShops[7].addMarker(ItemShops[7], 5, dim, 373.1552734375, -118.8056640625, 1001.4921875)


	self.Menus = {
		[1] = createObject(2218, 377.79998779297, -118.09999847412, 1001.5999755859, 336, 21, 72.25),
		[2] = createObject(2219, 378.70001220703, -118.09999847412, 1001.5992431641, 336, 21, 72.25),
		[3] = createObject(2220, 379.60000610352, -118.09999847412, 1001.5999755859, 336, 21, 72.25)
	}

	self.Names = {
		[1] = "Menu Small",
		[2] = "Menu Medium",
		[3] = "Menu Large"
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
		setElementInterior(v, 5)
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
	CShop.constructor(self, "WellStackedPizza", self.ID)
end

function CWellStackedPizza:destructor()

end

function CWellStackedPizza:onMarkerHit(theElement, matchDimension)
	if (matchDimension) then
		if (getElementType(theElement) == "player") then
			self:start(theElement)
		end
	end
end

function CWellStackedPizza:start(thePlayer)
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

function CWellStackedPizza:stop(thePlayer)
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

function CWellStackedPizza:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Menus) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CWellStackedPizza:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Menus
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CWellStackedPizza:buy(thePlayer)
	local choose = self.State[getPlayerName(thePlayer)]
	if (thePlayer:payMoney(self.Prices[choose])) then
		thePlayer:eat(self.Hunger[self.State[getPlayerName(thePlayer)]])
	end
end
