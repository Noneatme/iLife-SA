--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

PayNSprays = {}

CPayNSpray = inherit(CMarker)

function CPayNSpray:constructor(iID, iGaragenID, sPos, sBPos, Chain, iOwner, iFilliale)

	self.ID 		= iID
	self.Garage 	= iGaragenID
	self.Pos 		= sPos
	self.BPos 		= sBPos
	self.iChain 	= Chain;
	self.iFilliale 	= iFilliale;


	self.Blip = createBlip(gettok(self.BPos, 1, "|"), gettok(self.BPos, 2, "|"), gettok(self.BPos, 3, "|"), 63, 2, 0, 0, 0, 255,0,150, getRootElement())

	self.eOnHit = bind(self.onHit,self)
	addEventHandler("onMarkerHit", self, self.eOnHit)

	setGarageOpen(self.Garage, true)

	PayNSprays[self.ID] = self
end

function CPayNSpray:destructor()

end

function CPayNSpray:onHit(theElement, matchingDimension)
	if ( matchingDimension ) then
		if (getElementType(theElement) == "vehicle") then
			if (theElement:getOccupant(0)) then
				if (isGarageOpen(self.Garage)) then
					local thePlayer = theElement:getOccupant(0)

					local maxHealth	= theElement:getMaxHealth()

					if not(maxHealth) or (theElement:getHealth() > maxHealth) then
						maxHealth = 1000
					end

					local price 	= math.round(interpolateBetween(25,0,0,500,0,0, ((maxHealth-theElement:getHealth())/maxHealth), "Linear"))

					if(price < 0) then price = 0 end
					local canPay 		= false;
					local validPayed 	= false;
					biz = cBusinessManager:getInstance().m_uBusiness[tonumber(self.iFilliale)];

					if(biz) then
						canPay = (biz:getLagereinheiten() >= 0)
						validPayed = false;
					end

					if(canPay) then
						if (thePlayer:payMoney(price)) then
							validPayed = true
							if(biz) then
								biz:removeOneLagereinheit()
								if(biz:getCorporation() ~= 0) then
									biz:getCorporation():addSaldo(math.floor(price*0.50));
								end
							end
						end
					else
						thePlayer:showInfoBox("error", "Diese Lackiererei muss erst wieder aufgefuellt werden!")
					end

					if(validPayed) then
						setGarageOpen(self.Garage, false)
						theElement:setFrozen(true)
						setTimer(
						function()
							thePlayer:showInfoBox("info","Die Reperatur hat "..tostring(price).."$ gekostet.")
							theElement:fix()
							setGarageOpen(self.Garage, true)
							playSoundFrontEnd(thePlayer, 46)
							theElement:setFrozen(false)
						end, 4000, 1)
					end

					--[[
					if (thePlayer:payMoney(money) ) then
						setGarageOpen(self.Garage, false)
						theElement:setFrozen(true)
						if(BusinessChains[self.iChain]) and (BusinessChains[self.iChain][self.iFilliale]) then
							BusinessChains[self.iChain][self.iFilliale]:DepotMoney(math.floor(money/100*10), "Auto repariert");
						end
						setTimer(
						function()
							thePlayer:showInfoBox("info","Die Reperatur hat "..tostring(money).."$ gekostet.")
							theElement:fix()
							setGarageOpen(self.Garage, true)
							playSoundFrontEnd(thePlayer, 46)
							theElement:setFrozen(false)
						end
						, 4000, 1)
					end
					]]

				end
			end
		end
	end
end
