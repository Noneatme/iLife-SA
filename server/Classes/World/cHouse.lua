--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Houses = {}

CHouse = inherit(CElement)

function CHouse:constructor(iID, iCost, iCost2, iOwner, sKoords, bLocked, tInterior, iObjektDistanz, iFaction, tKeys, iCorp)
	self.ID 			= iID
	self.Cost 			= iCost
	self.XtraCost		= iCost2;
	self.DefaultCost	= iCost;
	self.Cost			= self.Cost+self.XtraCost
	self.Owner 			= iOwner
	self.Koords 		= sKoords
	self.m_iCorporation	= (tonumber(iCorp) or 0);


	--Koordianten nicht synchronisieren
	if (self.Owner == 0) and (iFaction == 0) and (self.m_iCorporation == 0) then
		self.Locked = false
	else
		if (bLocked == 0) then
			self.Locked = false
		else
			self.Locked = true
		end
	end

	self.m_iX, self.m_iY, self.m_iZ	= tonumber(gettok(self.Koords, 3, "|")), tonumber(gettok(self.Koords, 4, "|")), tonumber(gettok(self.Koords, 5, "|"))

	self.colShapeHitFunc	= bind(self.colShapeHit, self);
	self.colShapeLeaveFunc	= bind(self.colShapeLeave, self);


	self.iObjektDistanz = iObjektDistanz;

	self.Interior 		= tInterior

	self.Marker = createMarker(self.Interior[1], self.Interior[2], self.Interior[3], "corona", 1, 125, 125, 125)
	enew(self.Marker, CIntMarker, 10000+self.ID, "House:"..self.ID, "House", self.Interior[4], 10000+self.ID)

	self.Marker:setPortData(gettok(self.Koords,1,"|"), gettok(self.Koords,2,"|"), gettok(self.Koords,3,"|"), gettok(self.Koords,4,"|"), gettok(self.Koords,5,"|"), 0)

	self.colShape	= createColSphere(gettok(self.Koords,3,"|"), gettok(self.Koords,4,"|"), gettok(self.Koords,5,"|"), 20);

	-- Datas

	self.elements =
	{
		self.colShape,
		self.Marker
	}


	--self:updateElements();


	self.FactionID = 0
	self:setFaction(iFaction)
	self:setCorporation(iCorp)

	addEventHandler("onColShapeHit", self.colShape, self.colShapeHitFunc)
	addEventHandler("onColShapeLeave", self.colShape, self.colShapeLeaveFunc)

	self.Keys = tKeys or {}

	self.eOnHit = bind(self.onHit, self)
	addEventHandler("onPickupHit", self, self.eOnHit)

	Houses[self.ID] = self
end

function CHouse:updateInterior()
	destroyElement(self.Marker);
	self.Marker = createMarker(self.Interior[1], self.Interior[2], self.Interior[3], "corona", 1, 125, 125, 125)
	enew(self.Marker, CIntMarker, 10000+self.ID, "House:"..self.ID, "House", self.Interior[4], 10000+self.ID)
end

function CHouse:updateElements()
	for index, ele in pairs(self.elements) do
		setElementData(ele, "h:iOwner", PlayerNames[self.Owner]);
		setElementData(ele, "h:iID", self.ID);
		setElementData(ele, "h:iCost", self.Cost);
		setElementData(ele, "h:bLocked", self.Locked);
		setElementData(ele, "h:iObjektDistanz", self.iObjektDistanz);
		setElementData(ele, "h:iOwner2", self.Owner);
		setElementData(ele, "h:iFactionID", self.FactionID);
		setElementData(ele, "h:sFactionName", self.FactionName);
		setElementData(ele, "h:iCorporationID", self.m_iCorporation);
		setElementData(ele, "h:sCorporationName", self:getCorporationName());
		setElementData(ele, "h:sCorporationColor", self:getCorporationColor());
	end

	setElementData(self, "h:iOwner", PlayerNames[self.Owner]);
	setElementData(self, "h:iID", self.ID);
	setElementData(self, "h:iCost", self.Cost);
	setElementData(self, "h:bLocked", self.Locked);
	setElementData(self, "h:iObjektDistanz", self.iObjektDistanz);
	setElementData(self, "h:iOwner2", self.Owner);
	setElementData(self, "h:iFactionID", self.FactionID);
	setElementData(self, "h:sFactionName", self.FactionName);
	setElementData(self, "h:iCorporationID", self.m_iCorporation);
	setElementData(self, "h:sCorporationName", self:getCorporationName());
	setElementData(self, "h:sCorporationColor", self:getCorporationColor());

end

function CHouse:colShapeHit(uElement, dim)
	if(uElement) and (isElement(uElement)) and (getElementType(uElement) == "player") then
		triggerClientEvent(uElement, "onHouseShapeEnter", uElement, self.colShape)
	--[[
		local tbl = getElementData(uElement, "p:visitedHouse");
		if not(tbl) then
			tbl = {}
		end
		tbl[self.colShape] = self.colShape;
		setElementData(uElement, "p:visitedHouse", tbl)]]
	end
end

function CHouse:colShapeLeave(uElement, dim)
	if(getElementType(uElement) == "player") then
		triggerClientEvent(uElement, "onHouseShapeLeave", uElement, self.colShape)
		--[[
		local tbl = getElementData(uElement, "p:visitedHouse");
		if not(tbl) then
			tbl = {}
		end
		tbl[self.colShape] = nil;
		setElementData(uElement, "p:visitedHouse", tbl)]]
	end
end
function CHouse:getCorporationColor()
	if(Corporations[self.m_iCorporation]) then
		return Corporations[self.m_iCorporation].m_sColor
	end
	return "#FFFFFF"
end
function CHouse:getCorporation()
	if(Corporations[self.m_iCorporation]) then
		return Corporations[self.m_iCorporation]
	end
	return self.m_iCorporation;
end

function CHouse:getCorporationName()
	if(Corporations[self.m_iCorporation]) then
		return Corporations[self.m_iCorporation].m_sFullName.." ["..Corporations[self.m_iCorporation].m_sShortName.."]";
	end
	return "nil"
end

function CHouse:setCorporation(iCorp)
	iCorp	= (tonumber(iCorp) or 0)
	if(iCorp == 0) then
		if(CorporationHouses[self.m_iCorporation]) then
			CorporationHouses[self.m_iCorporation][self.ID] = nil;
		end
	else
		if not(CorporationHouses[iCorp]) then
			CorporationHouses[iCorp] = {}
		end
		if(self.m_iCorporation) and (CorporationHouses[self.m_iCorporation]) then
			if(CorporationHouses[self.m_iCorporation][self.ID]) then
				CorporationHouses[self.m_iCorporation][self.ID] = nil;
			end
		end
		CorporationHouses[iCorp][self.ID] = self;
	end
	self.m_iCorporation = iCorp;
	self:updateElements()
end

function CHouse:destructor()
	destroyElement(self.Marker);
	destroyElement(self.colShape);
end

function CHouse:isLocked()
	return self.Locked
end

function CHouse:setLocked(state)
	self.Locked = state
	self:save()
end

function CHouse:getInteriorData()
	return self.Interior
end

function CHouse:getCost()
	return self.Cost
end

function CHouse:getID()
	return self.ID
end

function CHouse:getFactionID()
	return self.FactionID
end

function CHouse:setFaction(FactionID)
	if (FactionID == 0) then
		if (self.FactionID ~= 0) then
			FactionHouses[self.FactionID][self.ID] = nil
		end
		self.FactionID = 0
		self.Faction = false
		self.FactionName = "None"
	else
		self.FactionID = FactionID
		self.Faction = Factions[FactionID]
		self.FactionName = Factions[FactionID]:getName()

		if not(type(FactionHouses[self.FactionID]) == "table") then
			FactionHouses[self.FactionID] = {}
		end
		FactionHouses[self.FactionID][self.ID] = self
	end
	--self:save()
	self:updateElements()
end

function CHouse:getOwnerID()
	return self.Owner
end

function CHouse:setOwnerID(iOwner)
	self.Owner = iOwner
	self:save()
end

function CHouse:hasPlayerKey(sName)
	return self.Keys[sName]
end

function CHouse:addKey(iID, sName)
	self.Keys[sName] = true
	table.insert(self.Keys, {["Name"]=sName})
	self:save()
end

function CHouse:removeKey(sName)
	self.Keys[sName] = false
	for i,v in ipairs(self.Keys) do
		if (v["Name"] == sName) then
			table.remove(self.Keys, i)
			break
		end
	end
	self:save()
end

function CHouse:setNewOwner(OwnerID)
	self.Owner = OwnerID
	self.Locked = true
	setPickupType ( self, 3, 1272)
	if ( isElement(self.Blip) ) then
		setBlipIcon(self.Blip, 32)
	end
	self:updateElements();
	self:save()
end

function CHouse:reset()
	self.Owner = 0
	self.Locked = false
	setPickupType ( self, 3, 1273)
	if ( isElement(self.Blip) ) then
		setBlipIcon(self.Blip, 31)
	end
	CDatabase:getInstance():query("DELETE FROM House_Keys WHERE HID=?", self.ID)

	self:setFaction(0)

	self:updateElements();
	self.Keys = {}
	self:save()
end

function CHouse:save()
	if (self.Locked) then
		iLocked = 1
	else
		iLocked = 0
	end
	CDatabase:getInstance():query("UPDATE houses SET Owner=?, Locked=?, Objektdistanz=?, Faction=?, Corporation=?, Cost=? WHERE ID=?", tonumber(self.Owner), tonumber(iLocked), tonumber(self.iObjektDistanz), tonumber(self.FactionID), self.m_iCorporation, self.XtraCost, self.ID)

	self.Cost = self.DefaultCost+self.XtraCost;
	self:updateElements();
end

function CHouse:setBlip(theBlip)
	self.Blip = theBlip
end

function CHouse:toggleLocked()
	if (self:isLocked()) then
		self.Locked = false
	else
		self.Locked = true
	end
	self:updateElements();
end

function CHouse:onHit(thePlayer)
	if not isPedInVehicle(thePlayer) then
		if (self.Owner ~= 0) then
			OwnerName = PlayerNames[self.Owner]
		else
			OwnerName = ""
		end
		triggerClientEvent(thePlayer, "showHouseGui", self, self.ID ,OwnerName, self.Locked, self.Cost, self.Keys, self.FactionID, self.FactionName, self.m_iCorporation, self:getCorporationName())
	end
end

addEvent("onLeaderAddRevokeHouse", true)
addEventHandler("onLeaderAddRevokeHouse", getRootElement(),
	function(HouseID)
		local Faction = client:getFaction()
		local Rank = client:getRank()
		local House = Houses[HouseID]
		if not(House) then
			client:showInfoBox("error", "Dieses Haus existiert nicht!")
		else
			if (Rank ~= 5) then
				client:showInfoBox("error", "Dazu bist du nicht autorisiert!")
			else
				if (Faction:getType() ~= 2) then
					client:showInfoBox("error", "Dies ist mit deiner Fraktion nicht möglich!")
				else
					if (not(House:getOwnerID() == client:getID()) and (House:getFactionID() == 0)) then
						client:showInfoBox("error", "Dieses Haus gehört dir nicht!")
					else
						if (House:getFactionID() == 0) then
							local valid = false
							for k,v in ipairs(Houses) do
								if (v:getFactionID() == Faction:getID()) then
									if (getDistanceBetweenElements3D(v, House) < 30) and (v ~= House) then
										valid = true
										break;
									end
								end
							end
							if (not (valid)) and (table.size(FactionHouses[Faction:getID()]) > 0) then
								client:showInfoBox("error", "Dieses Haus liegt nicht im Fraktionsgebiet!")
							else
								House:setOwnerID(0)
								House:setLocked(true)
								House:setFaction(client:getFaction():getID())
								House:save()
								client:showInfoBox("info", "Haus hinzugefügt!")
							end
						else
							if (House:getFactionID() == Faction:getID()) then
								House:reset()
								client:showInfoBox("info", "Haus entfernt!")
							else
								client:showInfoBox("error", "Dieses Haus gehört dir nicht!")
							end
						end
					end
				end
			end
		end
	end
)
