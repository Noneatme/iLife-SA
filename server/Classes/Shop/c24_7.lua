--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

C24_7 = inherit(CShop)

function C24_7:constructor(dim)

	self.Peds = {
		[1]= createPed(219,-27.3, -91.8, 1003.5)
	}
	self.Marker = {
		[1]= createMarker(-20.9, -91.6, 1003.5, "corona", 0.5, 255, 0, 0, 255, getRootElement()),
		[2]= createMarker(-22.3, -91.6, 1003.5, "corona", 0.5, 255, 0, 0, 255, getRootElement()),
		[3]= ItemShops[1].addMarker(ItemShops[1], 18, dim, -27.5 ,-89.94 ,1003.5)
	}
	self.Objects = {
		[1] = createObject(962, -20.9, -92.4, 1003.59998, 90, 180, 0),
		[2] = createObject(962, -22.3, -92.4, 1003.59998, 90, 180, 0)
	}
	self.PfandTimer = {
	}

	new(CShopRob, dim, self.Peds[1])

	for k,v in ipairs(self.Peds) do
		setElementInterior(v, 18)
		setElementDimension(v, dim)
		setElementData(v, "EastereggPed", true)
	end
	for k,v in ipairs(self.Marker) do
		setElementInterior(v, 18)
		setElementDimension(v, dim)
	end
	for k,v in ipairs(self.Objects) do
		setElementInterior(v, 18)
		setElementDimension(v, dim)
	end

	addEventHandler("onMarkerHit", self.Marker[1],
		function(hit, match)
			if (match) then
				if (getElementType(hit) == "player") then
					self.PfandTimer[getPlayerName(hit)] = setTimer(
						function()
							if (hit and isElement(hit)) then
								if (hit:getInventory():hasItem(Items[2], 1)) then
									if (isElementWithinMarker(hit, self.Marker[1])) then
										if (hit:getInventory():removeItem(Items[2], 1)) then
											hit:addMoney(5)
											hit:showInfoBox("info", "Du hast noch "..hit:getInventory():getCount(Items[2]).." Pfandflaschen!")
										end
										hit:refreshInventory()
									end
								else
									triggerClientEvent(hit, "onClientStopPfandautomat", hit)
								end
							end
						end, 1000, -1
					)
					if (hit:getInventory():hasItem(Items[2], 1)) then
						local x,y,z = getElementPosition(source)
						triggerClientEvent(hit, "onClientStartPfandautomat", hit, x, y, z)
					end
				end
			end
		end
	)

	addEventHandler("onMarkerLeave", self.Marker[1],
		function(hit, match)
			if (match) then
				if (getElementType(hit) == "player") then
					if (isTimer(self.PfandTimer[getPlayerName(hit)])) then
						killTimer(self.PfandTimer[getPlayerName(hit)])
						self.PfandTimer[getPlayerName(hit)] = nil
					end
					triggerClientEvent(hit, "onClientStopPfandautomat", hit)
				end
			end
		end
	)
	addEventHandler("onMarkerHit", self.Marker[2],
		function(hit, match)
			if (match) then
				if (hit and getElementType(hit) == "player") then
					self.PfandTimer[getPlayerName(hit)] = setTimer(
						function()
							if (isElement(hit)) then
								if (hit:getInventory():hasItem(Items[2], 1)) then
									if (isElementWithinMarker(hit, self.Marker[2])) then
										if (hit:getInventory():removeItem(Items[2], 1)) then
											hit:addMoney(5)
											hit:showInfoBox("info", "Du hast noch "..hit:getInventory():getCount(Items[2]).." Pfandflaschen!")
										end
										hit:refreshInventory()
									end
								else
									triggerClientEvent(hit, "onClientStopPfandautomat", hit)
								end
							end
						end, 1000, -1
					)
					if (hit:getInventory():hasItem(Items[2], 1)) then
						local x,y,z = getElementPosition(source)
						triggerClientEvent(hit, "onClientStartPfandautomat", hit, x, y, z)
					end
				end
			end
		end
	)
	addEventHandler("onMarkerLeave", self.Marker[2],
		function(hit, match)
			if (match) then
				if (getElementType(hit) == "player") then
					if (isTimer(self.PfandTimer[getPlayerName(hit)])) then
						killTimer(self.PfandTimer[getPlayerName(hit)])
						self.PfandTimer[getPlayerName(hit)] = nil
					end
					triggerClientEvent(hit, "onClientStopPfandautomat", hit)
				end
			end
		end
	)

	setTimer(function() for k,v in pairs(self.PfandTimer) do if ( (not getPlayerFromName(k)) or (getElementDimension(getPlayerFromName(k)) == 0)) then killTimer(v) end end end, 300000, 0)

	self.ID = dim-20000
	CShop.constructor(self, "Supermarkt", self.ID)
end

function C24_7:destructor()

end
