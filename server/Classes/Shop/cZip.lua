--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CZip = inherit(CShop)

function CZip:constructor(iDim)

	self.Dim = iDim
	self.Price = 830

	self.Skins = { 9,17,46,59,60,93,98,117,118,126,127,148,169,170,184,186,189,192,211,224,229,240,241,242,249,263 }

	self.bStop = bind(self.stop, self)
	self.bNext = bind(self.next, self)
	self.bBack = bind(self.back, self)
	self.bBuy = bind(self.buy, self)

	self.Display = {}
	self.Texts = {}
	self.State = {}

	self.Ped = createPed ( 72, 162.2880859375, -81.1884765625, 1001.8046875, 180, false)
	setElementInterior(self.Ped, 18)
	setElementDimension(self.Ped, self.Dim)
	setElementData(self.Ped, "EastereggPed", true)
	new(CShopRob, iDim, self.Ped)

	self.Marker = createMarker(162.4736328125, -83.5263671875, 1001.8046875, "corona", 1, 255, 255, 255, 125, getRootElement())
	setElementInterior(self.Marker, 18)
	setElementDimension(self.Marker, self.Dim)

	self.eOnMarkerHit = bind(self.onMarkerHit, self)
	addEventHandler("onMarkerHit", self.Marker, self.eOnMarkerHit)

	self.ID = iDim-20000
	CShop.constructor(self, "Zip", self.ID)
end

function CZip:destructor()

end

function CZip:onMarkerHit(hitElement, matchingDimensions)
	if (matchingDimensions) then
		if ( (getElementType(hitElement) == "player") and (not (isPedInVehicle(hitElement))) ) then
			if (not (hitElement:isDuty())) then
				self:start(hitElement)
			end
		end
	end
end

function CZip:start(thePlayer)
	setCameraMatrix(thePlayer, 180.12890625, -89.125, 1002.0234375, 182.02734375, -87.83203125, 1002.0234375)
	thePlayer:setPosition(182.02734375, -87.83203125,1002.0234375)
	thePlayer:setRotation(0,0,110)

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
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control1"])

	self.Texts[getPlayerName(thePlayer)]["Control2"] = textCreateTextItem("Leertaste - Kaufen", 0.05, 0.9)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control2"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control2"])

	self.Texts[getPlayerName(thePlayer)]["Control3"] = textCreateTextItem("Enter - Verlassen", 0.05, 0.95)
	textItemSetScale ( self.Texts[getPlayerName(thePlayer)]["Control3"], 2 )
	textDisplayAddText (self.Display[getPlayerName(thePlayer)], self.Texts[getPlayerName(thePlayer)]["Control3"])
	textDisplayAddObserver(self.Display[getPlayerName(thePlayer)], thePlayer)

	toggleAllControls(thePlayer, false)

	bindKey(thePlayer, "enter", "down", self.bStop)
	bindKey(thePlayer, "space", "down", self.bBuy)
	bindKey(thePlayer, "left", "down", self.bBack)
	bindKey(thePlayer, "right", "down", self.bNext)

	thePlayer:setDimension(getEmptyDimension())
end

function CZip:stop(thePlayer)
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

	thePlayer:setPosition(161.3232421875, -90.0498046875, 1001.8046875)
	thePlayer:setRotation(0, 0, 180)
	thePlayer:setModel(thePlayer:getSkin())
	setCameraTarget(thePlayer, thePlayer)

	thePlayer:setDimension(self.Dim)
end

function CZip:next(thePlayer)
	if (self.State[getPlayerName(thePlayer)] >= #self.Skins) then
		self.State[getPlayerName(thePlayer)] = 1
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]+1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CZip:back(thePlayer)
	if (self.State[getPlayerName(thePlayer)] <= 1) then
		self.State[getPlayerName(thePlayer)] = #self.Skins
	else
		self.State[getPlayerName(thePlayer)] = self.State[getPlayerName(thePlayer)]-1
	end

	thePlayer:setModel(self.Skins[self.State[getPlayerName(thePlayer)]])
end

function CZip:buy(thePlayer)

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
