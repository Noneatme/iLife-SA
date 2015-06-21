--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CBurgershot = inherit(CShop)

function CBurgershot:constructor(dim, iFilliale, iChain)
	self.Dim = dim

	self.Ped = createPed ( 205, 376.5,-65.69999694824,1001.200012207, 180, false)
	setElementRotation(self.Ped,0,0,180)
	setElementInterior(self.Ped, 10)
	setElementDimension(self.Ped, self.Dim)
	setElementRotation(self.Ped, 0,0,180)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, dim, self.Ped)

	self.Ped2 = createPed ( 205, 375.2910156250, -65.193359375, 1001.5078125, 90, false)
	setElementRotation(self.Ped2,0,0,180)
	setElementInterior(self.Ped2, 10)
	setElementDimension(self.Ped2, self.Dim)
	setElementRotation(self.Ped2, 0,0,90)
	setElementData(self.Ped2, "EastereggPed", true)

	ItemShops[4].addMarker(ItemShops[4], 10, dim, 373.6962890625, -65.1884765625, 1001.5151367188)

	self.Marker = createMarker(376.5322265625,-67.5,1001.5078125, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 10)
	setElementDimension(self.Marker, self.Dim)

	self.Menus = {
		[1] = createObject(2213, 377.5, -66.599998474121, 1001.599755859, 335.21862792969, 24.501129150391, 78.483306884766),
		[2] = createObject(2214, 378.20001220703, -66.599998474121, 1001.599755859, 335.21862792969, 24.501129150391, 78.483306884766),
		[3] = createObject(2217, 378.89999389648, -66.599998474121, 1001.5903930664, 335.21484375, 24.49951171875, 78.480834960938)
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
		setElementInterior(v, 10)
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

	self.iFilliale 	= iFilliale;
	self.iChain		= iChain;

	self.ID = dim-20000
	CShop.constructor(self, "Burgershot", self.ID)
end

function CBurgershot:destructor()

end

function CBurgershot:onMarkerHit(theElement, matchDimension)
	if (matchDimension) then
		if (getElementType(theElement) == "player") then
			self:start(theElement)
		end
	end
end

function CBurgershot:start(thePlayer)
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

function CBurgershot:stop(thePlayer)
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

function CBurgershot:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Menus) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CBurgershot:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Menus
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end
	textItemSetText(self.Texts[getPlayerName(thePlayer)]["Menu"], self.Names[self.State[getPlayerName(thePlayer)]].." - "..self.Prices[self.State[getPlayerName(thePlayer)]].."$")

	local lx,ly,lz = getElementPosition(self.Menus[self.State[getPlayerName(thePlayer)]])
	setCameraMatrix(thePlayer, lx-0.2, ly-0.5, lz+0.5, lx-0.2, ly, lz)
end

function CBurgershot:buy(thePlayer)
	local choose = self.State[getPlayerName(thePlayer)]
	if (thePlayer:payMoney(self.Prices[choose])) then
		thePlayer:eat(self.Hunger[self.State[getPlayerName(thePlayer)]])
		local preis = self.Prices[choose];
		local chainID = self.iChain;
		if(BusinessChains[chainID]) and (BusinessChains[chainID][self.iFilliale]) then
			BusinessChains[chainID][self.iFilliale]:DepotMoney(preis, "Burger Gekauft");
		end
	end
end
