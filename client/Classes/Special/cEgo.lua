--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA:The Walking Death	##
-- ## Name: Ego							##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Ego = {};
Ego.__index = Ego;

--[[

]]
local curVehRot = 0
local oldVehRot = 0
-- ///////////////////////////////
-- ///// New 				//////
-- ///////////////////////////////

function Ego:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// FreecamFrame		//////
-- ///////////////////////////////

function Ego:FreecamFrame()
	if(isPedAiming(localPlayer) ~= true) then

		if(self.egoState == true) then
			local camPosX, camPosY, camPosZ = getPedBonePosition ( getLocalPlayer(), 8 )

			local angleZ = math.sin(self.rotY)
			local angleY = math.cos(self.rotY) * math.cos(self.rotX)
			local angleX = math.cos(self.rotY) * math.sin(self.rotX)

			local camTargetX = camPosX + ( angleX ) * 100
			local camTargetY = camPosY + angleY * 100
			local camTargetZ = camPosZ + angleZ * 100

			local veh = getPedOccupiedVehicle ( getLocalPlayer() )
			if veh then

				local rx, ry, curVehRot = getElementRotation ( veh )
				local changedRotation = oldVehRot - curVehRot

				oldVehRot = curVehRot

				if not totalRot then
					totalRot = curVehRot
				end

				totalRot = changedRotation * 2 + totalRot

				local rotX = ( ( self.rotX * 360 / self.PI ) + totalRot ) / 360 * self.PI
				if rotX > self.PI then
					rotX = rotX - 2 * self.PI
				elseif rotX < -self.PI then
					rotX = rotX + 2 * self.PI
				end

				camTargetX = camPosX + ( math.cos(self.rotY) * math.sin(rotX) ) * 100
				camTargetY = camPosY + ( math.cos(self.rotY) * math.cos(rotX) ) * 100
			end
			setGameSpeed(1)
			setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, 0, 80 )

		else
			local cameraAngleX = self.rotX
			local cameraAngleY = self.rotY
			local freeModeAngleZ = math.sin(cameraAngleY)
			local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
			local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)
			local camPosX, camPosY, camPosLastZ = getPedBonePosition(localPlayer, 5)



			local zoom = self.zoom;


			if(isPedInVehicle(localPlayer)) then
				camPosX, camPosY, camPosLastZ = getElementPosition(getPedOccupiedVehicle(localPlayer))
				camPosLastZ = camPosLastZ + 0.5

				zoom = self.vehicleZoom;
			end


			local zOffset = 3
			local camPosZ = camPosLastZ + zOffset
			local mspeed = 2
			local speed = 0

			local ratio = 3


			-- Update the camera position based on the forwards/backwards speed
			PosX = camPosX + freeModeAngleX * speed
			PosY = camPosY + freeModeAngleY * speed
			camPosZ = camPosLastZ + freeModeAngleZ * speed
			-- calculate a target based on the current position and an offset based on the angle
			local camTargetX = PosX + freeModeAngleX * zoom
			local camTargetY = PosY + freeModeAngleY * zoom
			local camTargetZ = camPosZ + freeModeAngleZ * zoom
			camPosX = PosX - ( camTargetX - PosX ) / ratio
			camPosY = PosY - ( camTargetY - PosY ) / ratio
			camPosZ = camPosZ - ( camTargetZ - camPosZ ) / ratio


			local rotX, rotY, rotZ = self.rotX, self.rotY, freeModeAngleZ

			local rx, ry, rz = math.rad(rotX), math.rad(rotY), math.rad(rotZ)
			local matrix = {}
			matrix[1] = {}
			matrix[1][1] = math.cos(rz)*math.cos(ry) - math.sin(rz)*math.sin(rx)*math.sin(ry)
			matrix[1][2] = math.cos(ry)*math.sin(rz) + math.cos(rz)*math.sin(rx)*math.sin(ry)
			matrix[1][3] = -math.cos(rx)*math.sin(ry)

			matrix[2] = {}
			matrix[2][1] = -math.cos(rx)*math.sin(rz)
			matrix[2][2] = math.cos(rz)*math.cos(rx)
			matrix[2][3] = math.sin(rx)

			matrix[3] = {}
			matrix[3][1] = math.cos(rz)*math.sin(ry) + math.cos(ry)*math.sin(rz)*math.sin(rx)
			matrix[3][2] = math.sin(rz)*math.sin(ry) - math.cos(rz)*math.cos(ry)*math.sin(rx)
			matrix[3][3] = math.cos(rx)*math.cos(ry)

			matrix[4] = {}
			matrix[4][1], matrix[4][2], matrix[4][3] = getPedBonePosition(localPlayer, 31)


			if not (isLineOfSightClear(PosX, PosY, camPosLastZ, camPosX, camPosY, camPosZ, true, false, false, false, false, false, false)) then
				_,camPosX,camPosY,camPosZ = processLineOfSight(PosX, PosY, camPosLastZ, camPosX, camPosY, camPosZ, true, false, false, false, false, false, false)
			end
			setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )

		end
		-- Roll --




	else
		if(getCameraTarget() ~= localPlayer) then
			setCameraTarget(localPlayer);
		end
	end
end

-- ///////////////////////////////
-- ///// FreecamMouse		//////
-- ///////////////////////////////

function Ego:FreecamMouse(cX,cY,aX,aY)
	if isCursorShowing() or isMTAWindowActive() then
		self.delay = 5
		return
	elseif self.delay > 0 then
		self.delay = self.delay - 1
		return
	end

	local width, height = guiGetScreenSize()
	local aX = aX - width / 2
	local aY = aY - height / 2

	self.rotX = self.rotX + aX * self.mouseSensitivity * 0.01745
	self.rotY = self.rotY - aY * self.mouseSensitivity * 0.01745

	if self.rotX > self.PI then
		self.rotX = self.rotX - 2 * self.PI
	elseif self.rotX < -self.PI then
		self.rotX = self.rotX + 2 * self.PI
	end

	if self.rotY > self.PI then
		self.rotY = self.rotY - 2 * self.PI
	elseif self.rotY < -self.PI then
		self.rotY = self.rotY + 2 * self.PI
	end

	if self.rotY < -self.PI / 2.05 then
		self.rotY = -self.PI / 2.05
	elseif self.rotY > self.PI / 2.05 then
		self.rotY = self.PI / 2.05
	end

	-- Animation --

	local _, _, _, x1, y1, z1 = getCameraMatrix();

	local x2, y2, z2 = getElementPosition(localPlayer);


	if(x1 and y1 and z1 and x2 and y2 and z2) and (isElementMoving(localPlayer) ~= true) and (getPedSimplestTask(localPlayer) == "TASK_SIMPLE_PLAYER_ON_FOOT") then
		local oldrot = getPedRotation(localPlayer);

		local rot = math.atan2(y2 - y1, x2 - x1) * 180 / math.pi

		rot = rot+90
		--[[setPedRotation(localPlayer, rot);

		outputChatBox(oldrot-rot)
		if(math.floor(oldrot-rot) > 0) then
		if(getPedAnimation(localPlayer) == false) then
		setPedAnimation(localPlayer, "ped", "Turn_R", 50, false, false, true);
		end
		elseif(math.floor(oldrot-rot) < 0) then
		if(getPedAnimation(localPlayer) == false) then
		setPedAnimation(localPlayer, "ped", "Turn_L", 50, false, false, true);
		end
		elseif(math.floor(oldrot-rot) == 0) then
		if(getPedAnimation(localPlayer) ~= false) then
		setPedAnimation(localPlayer)
		end
		end]]


	end
end


-- ///////////////////////////////
-- ///// Start		 		//////
-- ///////////////////////////////

function Ego:Start()
	if(self.state == false) then
		self.state = true;

		addEventHandler("onClientPreRender", getRootElement(), self.freecamFrameFunc)
		addEventHandler("onClientRender", getRootElement(), self.freecamFrameFunc)
		addEventHandler("onClientCursorMove",getRootElement(), self.freecamMouseFunc)

	end
end

-- ///////////////////////////////
-- ///// Stop		 		//////
-- ///////////////////////////////

function Ego:Stop()
	if(self.state == true) then
		self.state = false;
		removeEventHandler("onClientPreRender", getRootElement(), self.freecamFrameFunc)
		removeEventHandler("onClientRender", getRootElement(), self.freecamFrameFunc)
		removeEventHandler("onClientCursorMove",getRootElement(), self.freecamMouseFunc)
		setCameraTarget(localPlayer);
		setGameSpeed(1.0);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///////////////////////////////

function Ego:Constructor(...)
	self.freecamFrameFunc = function(...) self:FreecamFrame(...) end;
	self.freecamMouseFunc = function(...) self:FreecamMouse(...) end;

	self.toggleCharFunc = function()
		if(self.egoState == false) then
			self.egoState = true;
		--self:Stop()

		--setCameraTarget(localPlayer);
		else
			self.egoState = false;
		--self:Start()
		end
	end;

	self.resetFunc = function(key, state)
		if(state == "down") then
			self:Stop()

			setCameraTarget(localPlayer);
		else
			self:Start()
		end
	end

	self.rotX, self.rotY = 0, 0
	self.camVehRot = 0
	self.rot = 0

	self.curVehRot = 0
	self.oldVehRot = 0

	self.state = false
	self.egoState = true;

	self.mouseSensitivity = 0.1

	self.delay = 0

	self.PI = math.pi


	self.maxroll = 0;

	self.zoom = 15;
	self.vehicleZoom = 35;

	self.currentroll = 0;

	self.rollstate = false;

end

-- EVENT HANDLER --


function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function isElementMoving(theElement)
	if isElement(theElement)then --First check if the given argument is an element
		local x, y, z = getElementVelocity(theElement) --Get the velocity of the element given in our argument

		if x ~= 0 and y ~= 0 and z ~= 0 then --When there is a movement on X, Y or Z return true because our element is moving
			return true
		end
	end
	return false
end


addCommandHandler("designer", function()
	if(ego.state == true) then
		ego:Stop();
		ego.state = false;
	else
		ego:Start();
		ego.state = true;
	end
end)