--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: MoveableObject.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

MoveableObject = inherit(CObject);


addEvent("onMoveableObjectExtraToggle", true)


--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MoveableObject:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RemoveAllExtras	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObject:RemoveAllExtras()
	for i = 1, self.maxExtras, 1 do
		self.extraEnabled[i] = true;
		self:ToggleExtra(false, i, false, false)
	end
end


-- ///////////////////////////////
-- ///// ToggleExtra 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObject:ToggleExtra(uPlayer, iExtra, sExtra, bDontUpdate)
	local attribut = false
	if not(self.extraEnabled[iExtra]) then
		if(iExtra == 1) then	-- Feuer
			objectMover.co.Holz:AddFire(self.uObject);
		elseif(iExtra == 2) then -- Rauch
			objectMover.co.Grill:AddRauch(self.uObject);
		elseif(iExtra == 3) then -- Automat
			objectMover.co.Sodaautomat:TrinkCola(uPlayer, self.uObject);
		elseif(iExtra == 4) then -- Toilette
			objectMover.co.Toilette:FlushToilet(uPlayer, self.uObject);
		elseif(iExtra == 5) then -- Radarfalle
			if(uPlayer:getFaction():getType() == 1) then
				triggerClientEvent(uPlayer, "onRadarfallenGuiOpen", uPlayer, self.uObject, (self.uObject:GetWAData("maxKMH") or 999));
			end
		end
	else
		if(iExtra == 1) then	-- Feuer
			objectMover.co.Holz:RemoveFire(self.uObject);
		elseif(iExtra == 2) then -- Rauch
			objectMover.co.Grill:RemoveRauch(self.uObject);
		elseif(iExtra == 3) then -- Automat
			objectMover.co.Sodaautomat:TrinkCola(uPlayer, self.uObject);
		elseif(iExtra == 4) then	-- Toilette
			objectMover.co.Toilette:FlushToilet(uPlayer, self.uObject);
		elseif(iExtra == 5) then -- Radarfalle
			if(uPlayer:getFaction():getType() == 1) then
				triggerClientEvent(uPlayer, "onRadarfallenGuiOpen", uPlayer, self.uObject, (self.uObject:GetWAData("maxKMH") or 999));
			end
		end

	end

	local function moveGarage()

	end

	-- GARAGE
	if(iExtra == 6) then
		if not(self.uObject.doorMoving) then
			self.uObject.doorMoving = true;

			local pos = self.uObject.door:getPosition()
			local rx, ry, rz = self.uObject:getRotation()

			self.uObject.door:detach()
			self.uObject.door:setPosition(pos.x, pos.y, pos.z);
			self.uObject.door:setRotation(rx, ry, rz+90);

			if(self.uObject.doorState) then -- Zumachen
				local pos  = self.uObject.door:getPosition()
				self.uObject.door:move(2000, pos.x, pos.y, pos.z+4, 0, 0, 0, "OutBounce")

				setTimer(function()
					if(isElement(self.uObject) and (isElement(self.uObject.door))) then
						self.uObject.door:attach(self.uObject, 0, 4.3, -0.4, 0, 0, 90)
						self.uObject.doorMoving = false;
					end
				end, 2000, 1)
			else	-- Aufnmachen
				local pos  = self.uObject.door:getPosition()
				self.uObject.door:move(2000, pos.x, pos.y, pos.z-4, 0, 0, 0, "OutBounce")

				setTimer(function()
					if(isElement(self.uObject) and (isElement(self.uObject.door))) then
						self.uObject.door:attach(self.uObject, 0, 4.3, -4.4, 0, 0, 90)
						self.uObject.doorMoving = false;
					end
				end, 2000, 1)
			end

			self.uObject.doorState = not(self.uObject.doorState)
		end
	end

	self.extraEnabled[iExtra] = not(self.extraEnabled[iExtra]);

	if(sExtra) then
		self.uObject:SetWAData(sExtra, self.extraEnabled[iExtra], bDontUpdate);
	end

end

-- ///////////////////////////////
-- ///// CheckWerteAttribute/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObject:CheckWerteAttribute()

	if(self.uObject:GetWAData("rauch")) then
		self:ToggleExtra(nil, 2, "rauch", true)
	end

	if(self.uObject:GetWAData("feuer")) then
		self:ToggleExtra(nil, 1, "feuer", true)
	end


	if(self.uObject:GetWAData("radio_url") ~= false) then

		objectMover.co.Radio.radioPlayed[self.uObject] = true;
		setElementData(self.uObject, "wa:radio_url", self.uObject:GetWAData("radio_url"));
		setElementData(self.uObject, "wa:radio_looped", self.uObject:GetWAData("radio_looped"));

	end


	-- Geld --

	if(getElementModel(self.uObject) == 3013) then
		if not(self.uObject:GetWAData("geld")) then
			self.uObject:SetWAData("geld", 0, true);
			self.uObject:SetWAData("permissions", {}, true)
		end
	end

	if(getElementModel(self.uObject) == 2046) then -- Waffenschrank
		if not(self.uObject:GetWAData("weapons")) then
			self.uObject:SetWAData("weapons", {}, true);
		end
	end

	if(getElementModel(self.uObject) == 2969) then -- StorageBox
		if not(self.uObject:GetWAData("items")) then
			self.uObject:SetWAData("items", {}, true);
		end
	end

	if(getElementModel(self.uObject) == 1772) then -- Radarfalle
		CO_Radarfalle:new(self.uObject, (self.uObject:GetWAData("maxKMH") or math.huge));
	end

	if(getElementModel(self.uObject) == 17950) then -- Garage
		self.uObject.door		= createObject(17951, self.uObject:getPosition())
		self.uObject.door:attach(self.uObject, 0, 4.3, -0.4, 0, 0, 90);

		self.uObject.doorState	= false;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObject:Constructor(iModell, iX, iY, iZ, iRX, iRY, iRZ, sFaction, sOwner, bSave, iID, bNewInsert, iInt, iDim, sWerteAttribut)

	-- Klassenvariablen --
	self.uObject 		= createObject(iModell, iX, iY, iZ, iRX, iRY, iRZ);
	--enew(self.uObject, CObject)

	if not(bNewInsert) then
		setElementCollisionsEnabled(self.uObject, true);
	else
		setElementCollisionsEnabled(self.uObject, false);
	end
	enew(self.uObject, CObject);

	self.bSave			= bSave;
	self.sOwner			= sOwner;

	self.uObject.iID	= iID;
	self.uObject.sOwner	= sOwner;

	self.modelID		= iModell;


	self.extraEnabled	= {};

	self.extraObjects	= {};


	self.tblPos			= {iX, iY, iZ};

	self.toiletFlush	= false;

	self.maxExtras		= 4;

	self.uObject.werteAttribut = {};

	if(sWerteAttribut) then
		if(fromJSON(sWerteAttribut)) then
			self.uObject.werteAttribut = fromJSON(sWerteAttribut);
		end
	end


	setElementDoubleSided(self.uObject, true);

	setElementData(self.uObject, "wa:CurrentMoving", false);
	setElementData(self.uObject, "wa:MovingAllowed", (sFaction or "-"));

	setElementData(self.uObject, "wa:Owner", sOwner);
	setElementData(self.uObject, "wa:OwnerName", PlayerNames[tonumber(sOwner)]);

	setElementInterior(self.uObject, iInt);
	setElementDimension(self.uObject, iDim);
	setElementDoubleSided(self.uObject, true);

	--[[
	local url, looped	= gettok(sSonstiges, 1, "|"), tonumber(gettok(sSonstiges, 2, "|"));

	self.uObject.sSonstiges	= sSonstiges;
	self.uObject.sExtras	= sExtras or "0|0|0|0|0";

	if(url) and (looped) then
	setElementData(self.uObject, "om:RadioURL", url);
	setElementData(self.uObject, "om:RadioLooped", looped);

	if(#url > 5) then
	objectMover.radioPlayed[self.uObject] = true;
	end
	end

	if(self.sExtras) and (#self.sExtras > 0) then
	local tbl		= split(self.sExtras, "|");
	for index, value in pairs(tbl) do
	value = tonumber(value)
	if(value == 1) then
	self:ToggleExtra(nil, index);
	end
	end
	end
	]]
	-- Methoden --

	if(bNewInsert == true) then
		self.uObject:CreateNewEntry();
	end

	self:CheckWerteAttribute();


	self.destructorFunc		= function(...) self:Destructor(...) end;
	self.extraFunc			= function(uObject, ...) if(uObject == self.uObject) then self:ToggleExtra(client, ...) end end;

	addEventHandler("onMoveableObjectExtraToggle", getRootElement(), self.extraFunc)
	addEventHandler("onElementDestroy", self.uObject, self.destructorFunc)


	-- Events --

	--logger:OutputInfo("[CALLING] MoveableObject: Constructor");
	self.uObject.moClass = self;
end

function MoveableObject:Destructor()
	objectMover.co.Holz:RemoveFire();
	objectMover.co.Grill:RemoveRauch();

	if(getElementModel(self.uObject) == 1772) then -- Radarfalle
		Radarfallen[self.uObject]:destructor();
	end
	-- FALLS VERBUGGT, RAUSNEHMEN!
	if(self.uObject) then
--  	destroyElement(self.uObject);
	end

	if(isElement(self.uObject.door)) then
		destroyElement(self.uObject.door)
	end
end



-- EVENT HANDLER --
