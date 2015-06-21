--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ShopRobs = {}

PlayerShopRobs = {}

CShopRob = {}

ShopRobActive = 0

function CShopRob:constructor(iID, eElement)
	self.ID = iID --Dimension of the Shop
	self.Element = eElement
	self.LastAttacked = 0

	local x,y,z = getElementPosition(self.Element)
	local sphere = createColSphere(x,y,z, 50)

	self.Shop = ""
	self.Location = ""

	for k,v in ipairs(getElementsWithinColShape(sphere, "marker")) do
		if (getElementDimension(v) == self.ID) then
			if (getElementData(v, "Type") == "PortOut") then
				self.Shop = getElementData(v, "PortType")
				self.Location = getElementData(v, "Location")
				break;
			end
		end
	end

	self.GangArea = false
	if GangAreas[self.Location] then
		self.GangArea = GangAreas[self.Location]
	end

	addEventHandler("onElementClicked", self.Element,
		function(mouseButton, buttonState, thePlayer)
			if (mouseButton == "right") and (buttonState == "down") then
				self:start(thePlayer)
			end
		end
	)
	self:clear()
	ShopRobs[self.ID] = self
end

function CShopRob:destructor()

end

function CShopRob:start(thePlayer)
	if (thePlayer:getFaction():getType() == 2) then
		if not(self.UnderAttack) then
			if (not (self.GangArea) or self.GangArea:getFaction() ~= thePlayer:getFaction()) then
				if ((getTickCount() - self.LastAttacked > 10800000) or (self.LastAttacked == 0)) then
					if ( not(PlayerShopRobs[getPlayerName(thePlayer)]) or (getTickCount() - tonumber(PlayerShopRobs[getPlayerName(thePlayer)]) > 10800000) ) then
						if (ShopRobActive >= 1) then
							thePlayer:showInfoBox("error", "Es kann immer nur ein Überfall stattfinden!")
							return false
						end

						
						--[[
						if (WaffentruckActive) then
							thePlayer:showInfoBox("error", "Es findet gerade ein Waffentruck statt!")
							return false
						end]]
						CFaction:sendTypeMessage(1, "Ein Raubüberfall findet statt: "..self.Shop.." in "..self.Location, 180,0,0)
					--	if (self.GangArea) then self.GangArea:getFaction():sendMessage("Ein Raubüberfall findet statt: "..self.Shop.." in "..self.Location, 180,0,0) end

						for k,v in ipairs(getElementsNearElement(self.Element, 30, "ped")) do
							if (getElementDimension(v) == getElementDimension(self.Element)) then
								setPedAnimation(v, "shop", "SHP_Rob_HandsUp", -1, true, false, false, true)
							end
						end

						ShopRobActive = ShopRobActive +1
						--[[
						self.Robber = thePlayer:getFaction()
						self.Robber:sendMessage("Ein Raub wurde gestartet. ("..self.Shop..": "..self.Location..")")]]

						local faction		= thePlayer:getFaction();
						self.Robber			= thePlayer;

						local factionName	= faction.Name;

						CFaction:sendTypeMessage(2, "Ein Shoprob wurde von der Fraktion "..factionName.." gestartet! Ort: "..self.Location, 200, 50, 50);


						self.UnderAttack = true
						self.LastAttacked = getTickCount()
						PlayerShopRobs[getPlayerName(thePlayer)] = getTickCount()
						self.Timer = setTimer(bind(CShopRob.TimerFunc, self), 30000, 1, thePlayer)
						self.LastEndTimer = setTimer(bind(CShopRob.EndTimerFunc, self), 480000, 1)

						local faccount = 0
						for k,v in ipairs(getElementsByType("player")) do
							if (getElementData(v, "online") and (v.Fraktion) and v.Fraktion:getType() == 1) then
								faccount = faccount+1
							end
						end

						if (faccount < 3 )then
							thePlayer:setWanteds(thePlayer:getWanteds()+2)
							thePlayer:showInfoBox("warning", "Du wurdest auf einer Überwachungskamera gesehen.")
							CFaction:sendTypeMessage(1, "Der Spieler "..getPlayerName(thePlayer).." wurde auf einer Überwachungskamera gesehen.", 0,120,0)
						end
					else
						thePlayer:showInfoBox("error", "Du solltest damit warten!")
					end
				else
					thePlayer:showInfoBox("error", "Der Shop wurde bereits ausgeraubt!")
				end
			else
				--Schutzgeld
			end
		end
	end
end

function CShopRob:TimerFunc(thePlayer)
	if (getElementDimension(thePlayer) == getElementDimension(self.Element)) and (getDistanceBetweenElements3D(thePlayer, self.Element) < 30 ) then
		self.Race = new(CBriefcaseRace, self.Robber:getFaction(), Factions[1], 1000, thePlayer, bind(CShopRob.finish, self))
	else
		self:finish(Factions[1])
	end
end

function CShopRob:EndTimerFunc()
	self.Race:teamWon(self.Robber)
end

function CShopRob:finish(theWinner)
	local money = math.random(8000,15000)
	if (theWinner == self.Robber:getFaction()) then
		local robmoney = math.floor(money*(self.Race.Tickets/1000))
		local copmoney = money-robmoney
		self.Robber:getFaction():sendMessage("Der Überfall ("..self.Shop..": "..self.Location..") war erfolgreich! Beute: "..tostring(robmoney).."$")
		self.Robber:getFaction():addDepotMoney(robmoney)
		Factions[1]:sendMessage("Der Überfall ("..self.Shop..": "..self.Location..") war erfolgreich!")
		Factions[1]:sendMessage("Vereitelte Beute: "..tostring(copmoney).."$")
		Factions[1]:addDepotMoney(copmoney)
	else
		self.Robber:getFaction():sendMessage("Der Überfall ("..self.Shop..": "..self.Location..") ist fehlgeschlagen!")
		Factions[1]:sendMessage("Der Überfall ("..self.Shop..": "..self.Location..") ist fehlgeschlagen!")
		Factions[1]:sendMessage("Vereitelte Beute: "..tostring(money).."$")
		Factions[1]:addDepotMoney(money)
	end
	self:clear()
	ShopRobActive = ShopRobActive-1
end

function CShopRob:clear()
	self.Counter = 0
	self.Robber = false
	self.UnderAttack = false

	if isTimer(self.Timer) then
		killTimer(self.Timer)
	end

	if isTimer(self.LastEndTimer) then
		killTimer(self.LastEndTimer)
	end

	if (self.Race) then
		delete(self.Race)
		self.Race = nil
	end

	for k,v in ipairs(getElementsNearElement(self.Element, 30, "ped")) do
		if (getElementDimension(v) == getElementDimension(self.Element)) then
			setPedAnimation(v, "shop", "SHP_Rob_HandsUp", -1, true, false, false, true)
		end
	end
end
