--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

FactionPeds = {}

CFactionPed = {}

addEvent("onClientInsertGangPedItem", true)
addEvent("onClientBuyGangPedItem", true)

function CFactionPed:constructor(iID, tItems)
	self.ID = iID
	
	self.Items = tItems
	--{["ID"]=ID, ["Count"]= Count, ["Price"]= Price}
	
	local x,y,z = getElementPosition(self)
	local zone = getZoneName(x,y,z)
	
	if GangAreas[zone] then
		GangAreas[zone]:addPed(self)
		setElementData(self, "FactionPed", true)
		setElementData(self, "FactionID", GangAreas[zone]:getFaction():getID())
	end
	
	self.Zone = getZoneName(x,y,z)
	
	self.Gangped = true
	
	setElementFrozen(self, true)
	
	addEventHandler("onClientInsertGangPedItem", self, bind(CFactionPed.insertItem, self))
	addEventHandler("onClientBuyGangPedItem", self, bind(CFactionPed.buyItem, self))
	
	addEventHandler("onElementClicked", self, bind(CFactionPed.onClick, self))
	--addEventHandler("onPlayerTarget", getRootElement(), bind(CFactionPed.playerAim, self ))
	
	FactionPeds[self.ID] = self
end

function CFactionPed:destructor()

end

function CFactionPed:onClick(mouseButton, buttonState, playerWhoClicked)
	if (getDistanceBetweenElements3D(self, playerWhoClicked) > 5) then
		return nil
	end
	if (buttonState == "down") then
		return nil
	end
	
	if (mouseButton == "left") then
		if ((playerWhoClicked:getFaction():getType() ~= 1)) then
			if (table.size(self.Items) ~= 0) then
				triggerClientEvent(playerWhoClicked, "onClientOpenGangPedBuyMenu", self, self.Items)
			else
				outputChatBox("Zivilist: Ich hab nichts für dich!", playerWhoClicked, 255,255,255)
			end
		end
	else
		if (type(GangAreas[self.Zone]) == "table") then
			if ((playerWhoClicked:getFaction():getType() == 2)) then
				if ( playerWhoClicked:getFaction():getID() ~= GangAreas[self.Zone]:getFaction():getID() ) then
					triggerClientEvent(playerWhoClicked, "onClientStartGW", self)
				else
					if (playerWhoClicked:getRank() > 2) then
						triggerClientEvent(playerWhoClicked, "onClientOpenGangPedConfiguration", self)
					else
						outputChatBox("Mitglied: Von dir nehme ich keine Befehle!", playerWhoClicked, 255,255,255)
					end
				end
			end
		end
	end
end

function CFactionPed:insertItem(itemID, count, price)
	local Item = Items[itemID]
	if (not Item.Tradeable) then
		client:showInfoBox("info", "Dieses Item kann nicht verkauft werden.")
	end
	if (client:getInventory():hasItem(Item, count)) then
		if (client:getInventory():removeItem(Item, count) ) then
			self.Items = {["ID"]=itemID, ["Count"]= count, ["Price"]= price}
			client:showInfoBox("info", "Dieses Item wird nun verkauft.")
			client:incrementStatistics("Fraktion", "Gangpeds_ausger\uestet", 1)
			self:save()
			client:refreshInventory()
		end		
	end
end

function CFactionPed:buyItem(count)
	if (count > 0 and count <= tonumber(self.Items["Count"])) then
		if (client:getInventory():getCount(Items[tonumber(self.Items["ID"])])+count <=  Items[tonumber(self.Items["ID"])]:getStacksize()) then
			if client:payMoney(count*self.Items["Price"]) then
				GangAreas[self.Zone]:getFaction():addDepotMoney(math.floor(count*self.Items["Price"]*0.8))
				client:getInventory():addItem(Items[tonumber(self.Items["ID"])], count)
				self.Items["Count"] = self.Items["Count"]-count
				if (self.Items["Count"] <= 0) then
					self.Items = {}
				end
				self:save()
				client:refreshInventory()
				outputChatBox("Zivilist: Viel Spaß damit!", client, 255,255,255)
				client:showInfoBox("info", "Du hast ein Item gekauft.")
			end
		else
			client:showInfoBox("error", "Davon kannst du nicht so viel tragen!")
		end
	else
		client:showInfoBox("error", "Ungültige Anzahl!")
	end
end

function CFactionPed:save()
	CDatabase:getInstance():query("UPDATE  faction_ped SET Items = ? WHERE  ID =?", toJSON(self.Items), self.ID)
end

function CFactionPed:playerAim(theTarget)
	--[[if (theTarget == self) then
		if (getPedWeapon(source) ~= 0) and (not (isPedInVehicle(source))) then
			giveWeapon(self, 30, 5000, true)
			triggerClientEvent(getRootElement(), "onGangPedStartFire", self, source)
		end
	end]]
end

--[[
addCommandHandler("cped", 
	function(thePlayer, cmd)
		local x,y,z = getElementPosition(thePlayer)
		local rx,ry,rz = getElementRotation(thePlayer)
		
		local ped = createPed(0,x,y,z,rz,true)
		setElementCollisionsEnabled(ped, false)
		
		enew(ped, CFactionPed, 0, "[ [ ] ]") 
		
		CDatabase:getInstance():query("INSERT INTO faction_ped (ID, Position, Items) VALUES (NULL, ?, ?)", toJSON({["X"]=x,["Y"]=y,["Z"]=z,["RZ"]=rz}),toJSON({}))
	end
)

]]