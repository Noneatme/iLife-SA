--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDidierSachs = inherit(CShop)

function CDidierSachs:constructor(iDim)

	--Playerpos: 14|20129|215.232421875|-155.158203125|1000.5234375|0|0|114.82260131836

	self.Dim = iDim
	self.Price = 980

	self.Skins = { 11,12,57,76,91,111,113,120,141,147,150,171,172,194,214,216,219,227,228,233}

	self.bStop = bind(self.stop, self)
	self.bNext = bind(self.next, self)
	self.bBack = bind(self.back, self)
	self.bBuy = bind(self.buy, self)

	self.Display = {}
	self.Texts = {}
	self.State = {}

	self.Ped = createPed ( 147, 204.408203125, -157.5810546875, 1000.5234375, 180, false)
	setElementInterior(self.Ped, 14)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, iDim, self.Ped)

	self.Marker = createMarker(204.5205078125, -159.5068359375, 1000.5234375, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 14)
	setElementDimension(self.Marker, self.Dim)

	self.eOnMarkerHit = bind(self.onMarkerHit, self)
	addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

	self.ID = iDim-20000
	CShop.constructor(self, "DidierSachs", self.ID)
end

function CDidierSachs:destructor()

end

function CDidierSachs:onMarkerHit(hitElement, matchingDimensions)
	if (matchingDimensions) then
		if ( (getElementType(hitElement) == "player") and (not (isPedInVehicle(hitElement))) ) then
			if (not (hitElement:isDuty())) then
				self:start(hitElement)
			end
		end
	end
end

function CDidierSachs:start(thePlayer)
	setCameraMatrix(thePlayer, 213.4072265625,-156.626953125,1001.5234375, 215.232421875,-155.158203125,1000.5234375)
	thePlayer:setPosition(215.7041015625, -155.138671875, 1000.5234375)
	thePlayer:setRotation(0,0,129)

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

function CDidierSachs:stop(thePlayer)
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

	thePlayer:setPosition(204.5439453125,-162.900390625,1000.5234375)
	thePlayer:setRotation(0, 0, 180)
	thePlayer:setModel(thePlayer:getSkin())
	setCameraTarget(thePlayer, thePlayer)

	thePlayer:setDimension(self.Dim)
end

function CDidierSachs:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Skins) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CDidierSachs:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Skins
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CDidierSachs:buy(thePlayer)

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
