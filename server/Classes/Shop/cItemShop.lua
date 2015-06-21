--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

ItemShops = {}

ClientItemShops = {}

CItemShop = {}

ACOverrideItemShops = {
	[4]=true,
	[5]=true,
	[6]=true,
	[7]=true
}


addEvent("onClientRequestItemShops", true)
addEvent("onClientBuyItemFromShop", true)

addEventHandler("onClientBuyItemFromShop", getRootElement(),
	function(ID, ItemID, Count)
		ItemShops[ID]:buy(client, ItemID, Count)
	end
)

addEventHandler("onClientRequestItemShops", getRootElement(),
    function()
        triggerClientEvent(source, "onClientItemShopsRecieve", source, toJSON(ClientItemShops))
    end
)

function CItemShop:constructor(iID, sName, sDesc, JSONItems, iCurrency, iSell, iFiliale)
	self.ID 			= iID
	self.Name 			= sName
	self.Description 	= sDesc
	self.Items 			= fromJSON(JSONItems)
	self.Currency 		= iCurrency
	self.iSell			= (iSell or 0)
	self.iFiliale		= (iFiliale or 0)

	self.Marker = {}

	ItemShops[self.ID] = self

	ClientItemShops[self.ID] = {
		["ID"] 			= self.ID,
		["Name"] 		= self.Name,
		["Description"] = self.Description,
		["Items"] 		= self.Items,
		["Currency"] 	= self.Currency
	}

	local pic = fileExists("res/images/shops/"..tostring(self.ID)..".png")
	if (pic) then
		downloadManager:AddFile("res/images/shops/"..tostring(self.ID)..".png")
	end
end

function CItemShop:destructor()

end

function CItemShop:addMarker(int, dim, x, y, z)

	local marker = createMarker(x, y, z, "corona", 0.5, 0, 125, 0, 255, getRootElement())
	setElementInterior(marker, int)
	setElementDimension(marker, dim)

	addEventHandler("onMarkerHit", marker,
		function(hitElement, matching)
				if(hitElement) and (getElementType(hitElement) == "player") then
				if (matching) then
					if(self.ID ~= 19) then
						triggerClientEvent(hitElement, "onItemShopOpen", hitElement, self.ID, self.iSell)
					else
						-- Fraktionshop
						if(hitElement:getFaction():getID() ~= 0) and (hitElement:getRank() >= 4) or (hitElement:getCorporation() ~= 0) then
							triggerClientEvent(hitElement, "onItemShopOpen", hitElement, self.ID)
						else
							hitElement:showInfoBox("error", "Dieser Shop ist nur f\uer Fraktionsleader!");
						end
					end
				end
			end
		end
	)

	table.insert(self.Marker, marker)

	return marker
end

function CItemShop:buy(thePlayer, ItemID, count)
	--Anti-Cheat
	if(ItemID) and (count) then
		if (#self.Marker > 0 and (not(ACOverrideItemShops[self.ID])) ) then
			local mindist = 99999999
			for k,v in ipairs(self.Marker) do
				local distance = getDistanceBetweenElements3D(v, thePlayer)
				if (distance < mindist) then
					mindist = distance
				end
			end
			if (mindist > 20) then
				outputServerLog("Manipulation: Client "..thePlayer:getName().." tried to buy Item "..ItemID.." but was too far away from Shop "..self.ID.." !")
				cheatBan(thePlayer, 5)
			end
		end

		if (self.Items[tostring(ItemID)]) then
			if(self.iSell ~= 1) then
				if((thePlayer:getInventory():canItemBeAdded(Items[ItemID], count, true))) then
					local validPayed 	= false
					local canPay		= true;
					-- Money
					if (self.Currency == 1) then
						local intID = thePlayer.m_iCurIntID;
						local biz;

						if(intID ~= 0) and (InteriorShops[intID]) and (InteriorShops[intID].m_iBusinessID) then
							if(tonumber(self.iFiliale) == 0) or not(tonumber(self.iFiliale)) then
								biz = cBusinessManager:getInstance().m_uBusiness[tonumber(InteriorShops[intID].m_iBusinessID)];
							end
						end
						if(tonumber(self.iFiliale) ~= 0) and (tonumber(self.iFiliale)) then
							biz = cBusinessManager:getInstance().m_uBusiness[self.iFiliale];
						end
						if(biz) then
							if(biz:getLagereinheiten() < biz:getLagereinheitenMultiplikator()) then

								canPay = false;
							end
						end
						if(canPay) then
							local cost = Items[ItemID]:getCost()*count;
							if (thePlayer:payMoney(cost)) then
								validPayed = true

								if(biz) then
									local LEBIZ = tonumber(cost/500)
									if(LEBIZ < 0) or ( not LEBIZ) then
										LEBIZ = 0
									end
									biz:addLagereinheiten(-LEBIZ)
									if(biz:getCorporation() ~= 0) then
										biz:getCorporation():addSaldo(math.floor(cost*0.50));
									end
								end
							end
						else
							thePlayer:showInfoBox("error", "Dieser Gegenstand ist nicht mehr Vorraetig! Die Corporation muss diesen Laden erst wieder auffuellen.")
						end
					end
					-- Bonuspoints (Itemprice / 1000)
					if (self.Currency == 2) then
						if (thePlayer:payBonuspoints(math.round((Items[ItemID]:getCost()*count)/1000))) then
							validPayed = true
						end
					end
					-- Gewinnmünzen
					if (self.Currency == 3) then
						--Todo
					end
					-- Add the items if the Payment was valid!
					if (validPayed) then
						thePlayer:getInventory():addItem(Items[ItemID], count)
						thePlayer:showInfoBox("info", "Du hast dir folgendes Item gekauft: "..Items[ItemID]["Name"])
						thePlayer:refreshInventory()

						local cost      = Items[ItemID]:getCost()*count;
						local bizMoney  = math.floor((Items[ItemID]:getCost()*count)/4);        -- 25% des Preises

						--	if(fillialen[self.ID]) then
						--		local Business = Businesses[fillialen[self.ID]]
						--		if(Business) then
						--			Business:DepotMoney(bizMoney, "Bought Item: "..ItemID);
						--		end
						--	end
					end
				else
					thePlayer:showInfoBox("error", "Davon kannst du nicht mehr tragen!")
				end
			else
				if not(thePlayer:getInventory():getCount(Items[ItemID])-count < 0) then
					local validPayed = false
					if (self.Currency == 1) then
						local cost = math.floor((Items[ItemID]:getCost()*count)/2)
						if (thePlayer:addMoney(cost)) then
							validPayed = true
						end
						if (validPayed) then
							thePlayer:getInventory():removeItem(Items[ItemID], count)
							thePlayer:showInfoBox("info", "Du hast folgendes Item verkauft: "..Items[ItemID]["Name"].." und $"..cost.." erhalten!")
							thePlayer:refreshInventory()
						end
					end
				else
					thePlayer:showInfoBox("error", "Soviel von diesem Item besitzt du nicht!")
				end
			end
		else
			outputServerLog("Manipulation: Client "..thePlayer:getName().." tried to buy Item "..ItemID.." in Shop "..self.ID.." !")
			cheatBan(thePlayer, 4)
		end
	end
end
