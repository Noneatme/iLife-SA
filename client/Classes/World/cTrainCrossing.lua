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
-- ## Name: TrainCrossing.lua					##
-- ## Author: Noneatme	(edit by MasterM)				##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

TrainCrossing = {};
TrainCrossing.__index = TrainCrossing;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function TrainCrossing:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Close		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainCrossing:Close()
	if(self.state == false) then
		if(self.moving) then
			killTimer(self.movingTimer)
		end
		for i = 1, self.maxSchranken, 1 do
			if(self.moving) then
				stopObject(self.schranke[i])
				setElementPosition(self.schranke[i], self.standardPos[i][1], self.standardPos[i][2], self.standardPos[i][3])
				setElementRotation(self.schranke[i], 0, 90, self.standardPos[i][6])
			end
			local x, y, z = getElementPosition(self.schranke[i])
			local rx, ry, rz = getElementRotation(self.schranke[i])
			local iAimRotY = 90-ry
			local iAimRotZ = 0--self.standardPos[i][6]-rz
			moveObject(self.schranke[i], self.moveTime, x, y, z, 0, iAimRotY, iAimRotZ);


			if(isElement(self.crossSound[i])) then
				destroyElement(self.crossSound[i])
			end

			self.crossSound[i] = playSound3D("res/sounds/train/railroad.mp3", self.standardPos[i][1], self.standardPos[i][2], self.standardPos[i][3], true);
			setSoundMaxDistance(self.crossSound[i], 100)
		end
		self.moving = true;
		self.movingTimer = setTimer(function() self.moving = false end, self.moveTime, 1);

		self.state = not (self.state);
	end
end

-- ///////////////////////////////
-- ///// Open	 			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainCrossing:Open()
	if(self.state == true) then
		if(self.moving) then
			killTimer(self.movingTimer)
		end
		for i = 1, self.maxSchranken, 1 do
			if(self.moving) then
				stopObject(self.schranke[i])
				setElementPosition(self.schranke[i], self.standardPos[i][1], self.standardPos[i][2], self.standardPos[i][3])
				setElementRotation(self.schranke[i], 0, 10, self.standardPos[i][6])
			end
			local x, y, z = getElementPosition(self.schranke[i])
			local rx, ry, rz = getElementRotation(self.schranke[i])
			local iAimRotY = 10-ry
			local iAimRotZ = 0--self.standardPos[i][6]-rz
			moveObject(self.schranke[i], self.moveTime, x, y, z, 0, iAimRotY, iAimRotZ);

			if(isElement(self.crossSound[i])) then
				destroyElement(self.crossSound[i])
			end
		end
		self.moving = true;
		self.movingTimer = setTimer(function() self.moving = false end, self.moveTime, 1);

		self.state = not (self.state);


	end
end

-- ///////////////////////////////
-- ///// ColShapeHit 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainCrossing:ColShapeHit(element, dim)
	if(dim == true) then
		if(self.state == false) then
			if(isElement(element)) and (getElementType(element) == "vehicle") and (self.trainHelper:IsTrain(getElementModel(element))) or getElementData(element, "IsServerTrain") then -- getElementData für das Sync-Fahrzeug
				self:Close();
			end
		end
	end
end
-- ///////////////////////////////
-- ///// ColShapeLeave		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainCrossing:ColShapeLeave(element, dim)
	if(dim == true) then
		if(self.state == true) then
			local Open = true;
			local counter = 0
			for index, vehicle in pairs(getElementsWithinColShape(self.colShape, "vehicle")) do
				if(self.trainHelper:IsTrain(getElementModel(vehicle))) or getElementData(vehicle,"IsServerTrain") then
					counter = counter+1
					if counter > 1 then
						Open = false;
						break;
					end
				end
			end

			if(Open) then
				self:Open();
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function TrainCrossing:Constructor(iObjectID, tblSchranke, iRadius)
	-- Klassenvariablen --

	self.schranke = {}
	self.schranke[1] 			= createObject(iObjectID, tblSchranke[1], tblSchranke[2], tblSchranke[3], 0, 90, tblSchranke[4]);
	self.schranke[2] 			= createObject(iObjectID, tblSchranke[5], tblSchranke[6], tblSchranke[7], 0, 90, tblSchranke[8]);


	self.standardPos = {}
	self.standardPos[1]			= {tblSchranke[1], tblSchranke[2], tblSchranke[3], 0, 90, tblSchranke[4]};
	self.standardPos[2]			= {tblSchranke[5], tblSchranke[6], tblSchranke[7], 0, 90, tblSchranke[8]};

	self.crossSound 			= {}

	self.moving 				= false;
	self.movingTimer			= nil;

	self.maxSchranken 			= #self.schranke;

	self.radius 				= iRadius or 50;

	self.state 					= true;	-- Ist Oben
	self.moveTime 				= 3000;

	self.colShape 				= createColSphere(tblSchranke[1], tblSchranke[2], tblSchranke[3], self.radius)
	self.trainHelper			= TrainHelper:New();

	-- Methoden --
	--self.moveUpFunc 			= function() self:Close() end;
	--self.moveDownFunc 			= function() self:Open() end;
	self.resetMoveStateFunc 	= function() self:ResetMoveState() end;


	self.ColShapeHitFunc		= function(...) self:ColShapeHit(...) end;
	self.ColShapeLeaveFunc		= function(...) self:ColShapeLeave(...) end;

	-- Events --

	addEventHandler("onClientColShapeHit", self.colShape, self.ColShapeHitFunc)
	addEventHandler("onClientColShapeLeave", self.colShape, self.ColShapeLeaveFunc)

	self:Open();
--logger:OutputInfo("[CALLING] TrainCrossing: Constructor");
end

-- EVENT HANDLER --
