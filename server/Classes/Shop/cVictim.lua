--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CVictim = inherit(CShop)

function CVictim:constructor(iDim)
	self.Dim = iDim
	self.Price = 700

	self.Skins = { 44,55,72,73,94,95,133,135,136,151,202,206,207,210,215,225,229,234,258,259,261}

	self.bStop = bind(self.stop, self)
	self.bNext = bind(self.next, self)
	self.bBack = bind(self.back, self)
	self.bBuy = bind(self.buy, self)

	self.Display = {}
	self.Texts = {}
	self.State = {}

	self.Ped = createPed ( 147, 204.84765625, -7.2724609375, 1001.2109375, 270, false)
	setElementInterior(self.Ped, 5)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, iDim, self.Ped)

	self.Marker = createMarker(206.5986328125, -7.3056640625, 1001.2109375, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 5)
	setElementDimension(self.Marker, self.Dim)

	self.eOnMarkerHit = bind(self.onMarkerHit, self)
	addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

	self.ID = iDim-20000
	CShop.constructor(self, "Victim", self.ID)

end

function CVictim:destructor()

end

function CVictim:onMarkerHit(hitElement, matchingDimensions)
	if (matchingDimensions) then
		if ( (getElementType(hitElement) == "player") and (not (isPedInVehicle(hitElement))) ) then
			if (not (hitElement:isDuty())) then
				self:start(hitElement)
			end
		end
	end
end

function CVictim:start(thePlayer)
	setCameraMatrix(thePlayer, 211.337890625, -7.1318359375, 1005.2109375, 209.3798828125, -9.0888671875, 1005.2109375)
	thePlayer:setPosition(209.3798828125, -9.0888671875, 1005.2109375)
	thePlayer:setRotation(0,0,310)

	self.Display[getPlayerName(thePlayer)] = textCreateDisplay()
	self.Texts[getPlayerName(thePlayer)] = {}
	self.State[getPlayerName(thePlayer)] = 1

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])

	self.Texts[getPlayerName(thePlayer)]["Price"] = textCreateTextItem("Kosten - "..self.Price.."$", 0.05, 0.8)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Price"], 2 )
	if (thePlayer:getMoney() > self.Price) then
		textItemSetColor ( self.Texts[getPlayerName(thePlayer)]["Price"], 50,255,50,255 )
	else
		textItemSetColor ( self.Texts[getPlayerName(thePlayer)]["Price"], 255,50,50,255 )
	end
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Price"])

	self.Texts[getPlayerName(thePlayer)]["Control1"] = textCreateTextItem("Links/Rechts - Vor/Zurück", 0.05, 0.85)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control1"], 2 )
	textItemSetColor ( self.Texts[getPlayerName(thePlayer)]["Control1"], 255,50,50,255 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control1"])

	self.Texts[getPlayerName(thePlayer)]["Control2"] = textCreateTextItem("Leertaste - Kaufen", 0.05, 0.9)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control2"], 2 )
	textItemSetColor ( self.Texts[getPlayerName(thePlayer)]["Control2"], 255,50,50,255 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control2"])

	self.Texts[getPlayerName(thePlayer)]["Control3"] = textCreateTextItem("Enter - Verlassen", 0.05, 0.95)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control3"], 2 )
	textItemSetColor ( self.Texts[getPlayerName(thePlayer)]["Control3"], 255,50,50,255 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control3"])
	textDisplayAddObserver(self.Display[getPlayerName(thePlayer)], thePlayer)

	toggleAllControls(thePlayer, false)

	bindKey(thePlayer, "enter", "down", self.bStop)
	bindKey(thePlayer, "space", "down", self.bBuy)
	bindKey(thePlayer, "left", "down", self.bBack)
	bindKey(thePlayer, "right", "down", self.bNext)

	thePlayer:setDimension(getEmptyDimension())
end

function CVictim:stop(thePlayer)
	textDestroyDisplay(self.Display[getPlayerName(thePlayer)])
	self.Display[getPlayerName(thePlayer)] = nil

	textDestroyTextItem(self.Texts[getPlayerName(thePlayer)]["Price"])
	self.Texts[getPlayerName(thePlayer)]["Price"] = nil

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

	thePlayer:setPosition(219, -8.10546875, 1001.2109375)
	thePlayer:setRotation(0, 0, 270)
	thePlayer:setModel(thePlayer:getSkin())
	setCameraTarget(thePlayer, thePlayer)

	thePlayer:setDimension(self.Dim)
end

function CVictim:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Skins) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CVictim:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Skins
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CVictim:buy(thePlayer)

		local validPayed 	= false
		local canPay		= true;
		local intID 		= self.ID;
		local biz;

		biz = cBusinessManager:getInstance().m_uBusiness[tonumber(InteriorShops[intID].m_iBusinessID)];
		if(biz) then
			canPay = (biz:getLagereinheiten() >= 0)
		end

		if(canPay) then
			local cost = self.Price
			if (thePlayer:payMoney(cost)) then
				validPayed = true
				thePlayer:setSkin(self.Skins[self.State[getPlayerName(thePlayer)]])
				self:stop(thePlayer)
				if(biz) then
					biz:removeOneLagereinheit()
					if(biz:getCorporation() ~= 0) then
						biz:getCorporation():addSaldo(math.floor(cost*0.50));
					end
				end
			end
		else
			thePlayer:showInfoBox("error", "Dieses Kleidungsstueck ist nicht mehr Vorraetig! Die Corporation muss diesen Laden erst wieder auffuellen.")
		end
end
