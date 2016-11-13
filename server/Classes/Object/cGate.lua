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
-- ## Name: Gate.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Gate = {};
Gate.__index = Gate;


Gates = {}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Gate:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Refresh	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:Refresh()
	-- Elemente & Dim
	for _, ele in pairs(self.uElements) do
		setElementInterior(ele, self.iInt);
		setElementDimension(ele, self.iDim);
	end
end

-- ///////////////////////////////
-- ///// HasUserPermission	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:HasUserPermission(uPlayer)
	if(uPlayer.LoggedIn) then
		if(self.usingJSON[self.sAuthType]) then
			if(self.tblPermissions) then
				for _, id in pairs(self.tblPermissions) do
					id = tonumber(id)

					-- HAUSGATE --
					if(self.iType == 0) then
						if(Houses[id]) then
							local house = Houses[id];

							if(tonumber(house.Owner) == tonumber(uPlayer:getID())) or ((tonumber(house.Owner) == 0) and (house.m_iCorporation == 0)) then
								return true;
							else
								-- Tenands
								if(house:hasPlayerKey(getPlayerName(uPlayer))) then
									return true;
								end

								if(house.m_iCorporation ~= 0) then
									if(uPlayer:getCorporation() ~= 0) and (uPlayer:getCorporation():getID() == house.m_iCorporation) then
										return true;
									end
								end
							end
						end
					end
					-- FRAKTIONSGATE
					if(self.iType == 1) then
						if(tonumber(uPlayer:getFaction():getID()) == tonumber(id)) then
							return true;
						end
					end
				end
			else
				error("Gate_HasUserPermissions")
			end
		else
			if(self.sAuthType == "noauth") then
				return true;
			end
		end
	end
	return false;

end

-- ///////////////////////////////
-- ///// CreateAuthType		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:CreateAuthElements()

	if(self.sOpenType) then
		-- Automatic --
		if(self.sOpenType == "automatic") then

			self.iUsersInCol	= 0;

			function Gate:RefreshUsersInCol()
				self.iUsersInCol = 0;
				local elements = getElementsWithinColShape(self.colShape, "player");
				for index, ele in pairs(elements) do
					if(ele.LoggedIn) and (self:HasUserPermission(ele)) then
						self.iUsersInCol = self.iUsersInCol+1;
					end
				end

			end

			self.enterColFunc	= function(uElement)
				if(getElementType(uElement) == "player") then
					if(self:HasUserPermission(uElement)) then
						self:RefreshUsersInCol();
						
						if(self.iUsersInCol > 0) then
							if(self.gateState ~= "down") then
								self:MoveDown();
							end
						end
					end
				end
			end

			self.leaveColFunc	= function(uElement)
				if(getElementType(uElement) == "player") then
					if(self:HasUserPermission(uElement)) then
						self:RefreshUsersInCol();

						if(self.iUsersInCol < 1) then
							if(self.gateState ~= "up") then
								self:MoveUp();
							end
						end
					end
				end
			end

			self.colShape	= createColSphere(self.tblPos[1], self.tblPos[2], self.tblPos[3], 15);


			addEventHandler("onColShapeHit", self.colShape, self.enterColFunc)
			addEventHandler("onColShapeLeave", self.colShape, self.leaveColFunc)
			
		elseif(self.sOpenType == "automatic-vehicle") then

			self.iVehiclesInCol	= 0;

			function Gate:RefreshVehiclesInCol()
				self.iVehiclesInCol = 0;
				local elements = getElementsWithinColShape(self.colShape, "vehicle");
				for index, ele in pairs(elements) do
					ele = getVehicleController(ele)
					if ele and (ele.LoggedIn) and (self:HasUserPermission(ele)) then
						self.iVehiclesInCol = self.iVehiclesInCol+1;
					end
				end

			end

			self.enterColFunc	= function(uElement)
				if(getElementType(uElement) == "vehicle") then
				uElement = getVehicleController(uElement)
					if(uElement and self:HasUserPermission(uElement)) then
						self:RefreshVehiclesInCol();

						if(self.iVehiclesInCol > 0) then
							if(self.gateState ~= "down") then
								self:MoveDown();
							end
						end
					end
				end
			end

			self.leaveColFunc	= function(uElement)
				if(getElementType(uElement) == "vehicle") then
				uElement = getVehicleController(uElement)
					if(uElement and self:HasUserPermission(uElement)) then
						self:RefreshVehiclesInCol();

						if(self.iVehiclesInCol < 1) then
							if(self.gateState ~= "up") then
								self:MoveUp();
							end
						end
					end
				end
			end

			self.colShape	= createColSphere(self.tblPos[1], self.tblPos[2], self.tblPos[3], 25);
			
			addEventHandler("onColShapeHit", self.colShape, self.enterColFunc)
			addEventHandler("onColShapeLeave", self.colShape, self.leaveColFunc)
			
		elseif(self.sOpenType == "click") then
			addEventHandler("onElementClicked", self.uGate, function(btn, state, uPlayer)
				if(btn == "left") and (state == "down") then
					if(self:HasUserPermission(uPlayer)) then
						if(self.gateState ~= "moving") then
							if(self.gateState == "down") then
								self:MoveUp();
							else
								self:MoveDown();
							end
						end
					end
				end
			end)
		end
	end
end

-- ///////////////////////////////
-- ///// SetPermission	 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:SetPermission(tblPermissions)
	assert(tblPermissions);
	self.tblPermissions = tblPermissions;

	self:Refresh();
end

-- ///////////////////////////////
-- ///// MoveUp		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:MoveUp()

	if(self.gateState ~= "up") then
		if(isTimer(self.moveTimer)) then
			killTimer(self.moveTimer);
		end

		local reset_func = function(x, y, z, rx, ry, rz)
			self.gateState = "up";
			stopObject(self.uGate);
			setElementPosition(self.uGate, x, y, z);
			setElementRotation(self.uGate, rx, ry, rz);
		end

		stopObject(self.uGate);

		local x, y, z, rx, ry, rz = unpack(self.tblPos);
		local x2, y2, z2, rx2, ry2, rz2 = unpack(self.tblPosTo);

		rx2, ry2, rz2 = getElementRotation(self.uGate)

		local zx, zy, zz, rzx, rzy, rzz = x, y, z, rx-rx2, ry-ry2, rz-rz2;


		self.gateState = "moving";

		moveObject(self.uGate, self.iMoveTime, zx, zy, zz, rzx, rzy, rzz, self.sOutFunction);

		self.moveTimer = setTimer(reset_func, self.iMoveTime, 1, zx, zy, zz, rx, ry, rz);
	end
end

-- ///////////////////////////////
-- ///// MoveDown	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:MoveDown()

	if(self.gateState ~= "down") then
		if(isTimer(self.moveTimer)) then
			killTimer(self.moveTimer);
		end

		local reset_func = function(x, y, z, rx, ry, rz)
			self.gateState = "down";
			stopObject(self.uGate);
			setElementPosition(self.uGate, x, y, z);
			setElementRotation(self.uGate, rx, ry, rz);
		end

		stopObject(self.uGate);

		local x, y, z, rx, ry, rz = unpack(self.tblPos);
		local x2, y2, z2, rx2, ry2, rz2 = unpack(self.tblPosTo);

		rx, ry, rz = getElementRotation(self.uGate)

		local zx, zy, zz, rzx, rzy, rzz = x2, y2, z2, rx-rx2, ry-ry2, rz-rz2;

		self.gateState = "moving";

		moveObject(self.uGate, self.iMoveTime, zx, zy, zz, -rzx, -rzy, -rzz, self.sInFunction);

		self.moveTimer = setTimer(reset_func, self.iMoveTime, 1, zx, zy, zz, rx2, ry2, rz2);
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Gate:Constructor(iID, sName, sModell, iMoveTime, tblPos, tblPosTo, tblMisc, sAuthType, tblPermissions, sOpenType, iType, sInFunction, sOutFunction)
	-- Klassenvariablen --

	-- Gates
	self.defaultGates	=
	{
		["airportgate"] = 980,
	}

	-- Valid Types
	self.validTypes		=
	{
		[0]		= true, -- Hausgate
		[1]		= true, -- Fraktionsgate
		[2]		= true, -- Offenes Gate
	}

	-- Auth Types
	self.validAuthTypes	=
	{
		["name"]		= true,
		["id"]			= true,
		["serial"]		= true,
		["noauth"]		= true,
		["password"] 	= true,
		["faction"]		= true,
	}

	-- JSON Loading
	self.usingJSON		=
	{
		["name"]		= true,
		["id"]			= true,
		["serial"]		= true,
		["faction"]		= true;
	}

	-- Open Types
	self.validOpenTypes	=
	{
		["click"]		= true,
		["command"]		= true,
		["automatic"]	= true,
		["automatic-vehicle"]	= true,
		["keypads"]		= true,
	}

	-- Assertion --
	if(type(sModell) == "string") then
		assert(self.defaultGates[sModell], "Gate:Constructor - Gate ID not found");
		sModell = self.defaultGates[sModell];
	else
		assert(tonumber(sModell), "Gate:Constructor - Gate ID not found (nil)");
		sModell	= tonumber(sModell);
	end

	sAuthType	= (sAuthType or "id");
	assert(self.validAuthTypes[sAuthType], "Gate:Constructor - No valid auth type found");
	assert(self.validOpenTypes[sOpenType], "Gate:Constructor - No valid open type found")
	assert(self.validTypes[iType], "Gate:Constructor - No valid type found");

	-- Variables --
	self.iID			= iID;
	self.sName			= sName;
	self.iType			= tonumber(iType);

	self.tblPos			= tblPos;
	self.tblPosTo		= tblPosTo;

	self.tblMisc		= tblMisc;

	self.sInFunction	= (sInFunction or "InOutQuad")
	self.sOutFunction	= (sOutFunction or "InOutQuad")

	-- Interior and DIM --
	if(tblMisc["int"]) then
		self.iInt			= tonumber(tblMisc["int"]);
	else
		self.iInt			= 0;
	end
	if(tblMisc["dim"]) then
		self.iDim			= tonumber(tblMisc["dim"]);
	else
		self.iDim			= 0;
	end
	self.sAuthType		= sAuthType;
	self.sOpenType		= sOpenType;

	if(self.usingJSON[self.sAuthType]) then
		-- JSON --
		self.tblPermissions = fromJSON(tblPermissions);
	end

	self.iMoveTime		= tonumber(iMoveTime)
	self.uGate			= createObject(sModell, unpack(tblPos));
	self.uElements		= {self.uGate};
	self.gateState		= "up";
	-- Methoden --


	-- Refresh --
	self:Refresh();
	self:CreateAuthElements();
	-- Events --

	--logger:OutputInfo("[CALLING] Gate: Constructor");
	Gates[tonumber(self.iID)] = self;
end

-- EVENT HANDLER --
