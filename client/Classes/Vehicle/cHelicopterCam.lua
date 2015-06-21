--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 26.01.2015
-- Time: 16:07
-- To change this template use File | Settings | File Templates.
--

cHelicopterCam = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cHelicopterCam:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// Enable     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:enable(uVehicle)
    if not(self.m_bEnabled) then
        clientBusy                  = true;
        self.m_bEnabled             = true;
        self.m_uCurrentVehicle      = uVehicle;


        addEventHandler("onClientRender", getRootElement(), self.m_funcRender);
        addEventHandler("onClientCursorMove", getRootElement(), self.m_funcMouseMove);

        bindKey("mouse_wheel_down", "down", self.m_zoomInFunc)
        bindKey("mouse_wheel_up", "down", self.m_zoomOutFunc)


        showChat(false);
        if(hud) then
            hud:Toggle(false);
        end
    end
end

-- ///////////////////////////////
-- ///// Disablee     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:disable()
    if(self.m_bEnabled) then
        clientBusy      = false;
        self.m_bEnabled = false;

        removeEventHandler("onClientRender", getRootElement(), self.m_funcRender);
        removeEventHandler("onClientCursorMove", getRootElement(), self.m_funcMouseMove);

        unbindKey("mouse_wheel_down", "down", self.m_zoomInFunc)
        unbindKey("mouse_wheel_up", "down", self.m_zoomOutFunc)

        setCameraTarget(localPlayer)

        showChat(true);
        if(hud) then
            hud:Toggle(true);
        end
    end
end


-- ///////////////////////////////
-- ///// Render     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

-- state variables
local speed = 0
local strafespeed = 0
local rotX, rotY = 0,0
local velocityX, velocityY, velocityZ

function cHelicopterCam:render()
    if(self.m_bEnabled) then
        local camPosX, camPosY, camPosZ = getElementPosition(localPlayer)
        camPosZ     = camPosZ-0.8

        local angleZ = math.sin(self.rotY)
        local angleY = math.cos(self.rotY) * math.cos(self.rotX)
        local angleX = math.cos(self.rotY) * math.sin(self.rotX)

        local camTargetX = camPosX + ( angleX ) * 100
        local camTargetY = camPosY + angleY * 100
        local camTargetZ = camPosZ + angleZ * 100

        local cameraAngleX = rotX
        local cameraAngleY = rotY

        local freeModeAngleZ = math.sin(cameraAngleY)
        local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
        local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

        if(self.m_bUseFreecam) then
            camPosX, camPosY, camPosZ = getCameraMatrix()

            angleZ = math.sin(self.rotY)
            angleY = math.cos(self.rotY) * math.cos(self.rotX)
            angleX = math.cos(self.rotY) * math.sin(self.rotX)

            camTargetX = camPosX + ( angleX ) * 100
            camTargetY = camPosY + angleY * 100
            camTargetZ = camPosZ + angleZ * 100

            cameraAngleX = rotX
            cameraAngleY = rotY

            freeModeAngleZ = math.sin(cameraAngleY)
            freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
            freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

            local mspeed = self.options.normalMaxSpeed
               if getKeyState ( self.options.key_fastMove ) then
                   mspeed = self.options.fastMaxSpeed
               elseif getKeyState ( self.options.key_slowMove ) then
                   mspeed = self.options.slowMaxSpeed
               end

               if self.options.smoothMovement then
                   local acceleration = self.options.acceleration
                   local decceleration = self.options.decceleration

                   -- Check to see if the forwards/backwards keys are pressed
                   local speedKeyPressed = false
                   if getKeyState ( self.options.key_forward ) then
                       speed = speed + acceleration
                       speedKeyPressed = true
                   end
                   if getKeyState ( self.options.key_backward ) then
                       speed = speed - acceleration
                       speedKeyPressed = true
                   end

                   -- Check to see if the strafe keys are pressed
                   local strafeSpeedKeyPressed = false
                   if getKeyState ( self.options.key_right ) then
                       if strafespeed > 0 then -- for instance response
                           strafespeed = 0
                       end
                       strafespeed = strafespeed - acceleration / 2
                       strafeSpeedKeyPressed = true
                   end
                   if getKeyState ( self.options.key_left ) then
                       if strafespeed < 0 then -- for instance response
                           strafespeed = 0
                       end
                       strafespeed = strafespeed + acceleration / 2
                       strafeSpeedKeyPressed = true
                   end

                   -- If no forwards/backwards keys were pressed, then gradually slow down the movement towards 0
                   if speedKeyPressed ~= true then
                       if speed > 0 then
                           speed = speed - decceleration
                       elseif speed < 0 then
                           speed = speed + decceleration
                       end
                   end

                   -- If no strafe keys were pressed, then gradually slow down the movement towards 0
                   if strafeSpeedKeyPressed ~= true then
                       if strafespeed > 0 then
                           strafespeed = strafespeed - decceleration
                       elseif strafespeed < 0 then
                           strafespeed = strafespeed + decceleration
                       end
                   end

                   -- Check the ranges of values - set the speed to 0 if its very close to 0 (stops jittering), and limit to the maximum speed
                   if speed > -decceleration and speed < decceleration then
                       speed = 0
                   elseif speed > mspeed then
                       speed = mspeed
                   elseif speed < -mspeed then
                       speed = -mspeed
                   end

                   if strafespeed > -(acceleration / 2) and strafespeed < (acceleration / 2) then
                       strafespeed = 0
                   elseif strafespeed > mspeed then
                       strafespeed = mspeed
                   elseif strafespeed < -mspeed then
                       strafespeed = -mspeed
                   end
               else
           		speed = 0
           		strafespeed = 0
           		if getKeyState ( options.key_forward ) then speed = mspeed end
           		if getKeyState ( options.key_backward ) then speed = -mspeed end
           		if getKeyState ( options.key_left ) then strafespeed = mspeed end
           		if getKeyState ( options.key_right ) then strafespeed = -mspeed end
               end
                   -- Work out the distance between the target and the camera (should be 100 units)
                local camAngleX = camPosX - camTargetX
                local camAngleY = camPosY - camTargetY
                local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

                -- Calulcate the length of the vector
                local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

                -- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
                local camNormalizedAngleX = camAngleX / angleLength
                local camNormalizedAngleY = camAngleY / angleLength
                local camNormalizedAngleZ = 0

                -- We use this as our rotation vector
                local normalAngleX = 0
                local normalAngleY = 0
                local normalAngleZ = 1

                -- Perform a cross product with the rotation vector and the normalzied angle
                local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
                local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
                local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

                -- Update the camera position based on the forwards/backwards speed
                camPosX = camPosX + freeModeAngleX * speed
                camPosY = camPosY + freeModeAngleY * speed
                camPosZ = camPosZ + freeModeAngleZ * speed

                -- Update the camera position based on the strafe speed
                camPosX = camPosX + normalX * strafespeed
                camPosY = camPosY + normalY * strafespeed
                camPosZ = camPosZ + normalZ * strafespeed

                if(getKeyState("pgup")) then
                    camPosZ = camPosZ+0.1
                end
                if(getKeyState("pgdn")) then
                    camPosZ = camPosZ-0.1
                end
        end



        local veh = getPedOccupiedVehicle ( getLocalPlayer() )

        if(self.currentMoveValueX ~= 0) or (self.currentMoveValueY ~= 0) then

            self.rotX = self.rotX + self.currentMoveValueX * self.mouseSensitivity * 0.01745
            self.rotY = self.rotY - self.currentMoveValueY * self.mouseSensitivity * 0.01745

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

            local value = 0.1;

            if(self.currentMoveValueX > 0) then
                self.currentMoveValueX = self.currentMoveValueX-value;
            else
                self.currentMoveValueX = self.currentMoveValueX+value;
            end

            if(self.currentMoveValueY > 0) then
                self.currentMoveValueY = self.currentMoveValueY-value;
            else
                self.currentMoveValueY = self.currentMoveValueY+value;
            end

            -- ZOOM --

            if(self.m_iCurZoomValue > 0.1) or (self.m_iCurZoomValue < -0.1) then
                self.m_iCurZoom = self.m_iCurZoom+self.m_iCurZoomValue;
            end

            if(self.m_iCurZoom > 100) then
                self.m_iCurZoom         = 100;
                self.m_iCurZoomValue    = 0;
            end

            if(self.m_iCurZoom < 10) then
                self.m_iCurZoom         = 10;
                self.m_iCurZoomValue    = 0;
            end

            if(self.m_iCurZoomValue >= 0) then
                self.m_iCurZoomValue = self.m_iCurZoomValue-0.01;
            else
                self.m_iCurZoomValue = self.m_iCurZoomValue+0.01;
            end

        end

        --[[
        if(veh) then

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


            -- MOVE MOUSE VALUE --
        end]]

        setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, 0, self.m_iCurZoom )
    end
end


-- ///////////////////////////////
-- ///// freecamMouse     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function cHelicopterCam:mouseMove(cX,cY,aX,aY)
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

    self.currentMoveValueX = self.currentMoveValueX+(aX*self.mouseSensitivity);
    self.currentMoveValueY = self.currentMoveValueY+(aY*self.mouseSensitivity);


    if(self.currentMoveValueY > 100) then
        self.currentMoveValueY = 100;
    end
    if(self.currentMoveValueY < -100) then
        self.currentMoveValueY = -100;
    end
    if(self.currentMoveValueX > 100) then
        self.currentMoveValueX = 100;
    end
    if(self.currentMoveValueX < -100) then
        self.currentMoveValueX = -100;
    end
    -- Animation --

end

-- ///////////////////////////////
-- ///// ZoomIn          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:zoomIn()
    if(self.m_iCurZoomValue > 1) then
        self.m_iCurZoomValue = 1;
    else
        self.m_iCurZoomValue = self.m_iCurZoomValue+0.1;
    end
end

-- ///////////////////////////////
-- ///// ZoomOut          	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:zoomOut()
    if(self.m_iCurZoomValue < -1) then
        self.m_iCurZoomValue = -1;
    else
        self.m_iCurZoomValue = self.m_iCurZoomValue-0.1;
    end
end

-- ///////////////////////////////
-- ///// bindKeys 		    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:bindKeys(bBool)
    if(bBool) then
        bindKey(self.m_sControlName, "down", self.m_funcToggleCam);
    else
        unbindKey(self.m_sControlName, "down", self.m_funcToggleCam);
    end
end

-- ///////////////////////////////
-- ///// EnterVehicle 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:enterVehicle(uPlayer, iSeat)
    if(uPlayer == localPlayer) and (iSeat == 1) then
        if(self.m_tblValidModels[getElementModel(source)]) then
            outputChatBox("Benutze STRG um die Flugzeugkamera zu bedienen!", 0, 200, 0);
            self:bindKeys(true);
        end
    end
end

-- ///////////////////////////////
-- ///// ExitVehicle 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:exitVehicle(uPlayer, iSeat)
    if(uPlayer == localPlayer) and (iSeat == 1) then
        if(self.m_tblValidModels[getElementModel(source)]) then
            self:bindKeys(false);
            self:disable();
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHelicopterCam:constructor(...)
    -- Klassenvariablen --
    self.m_bEnabled         = false;

    self.m_funcRender       = function(...) self:render(...) end
    self.m_funcMouseMove    = function(...) self:mouseMove(...) end

    self.m_zoomInFunc       = function(...) self:zoomIn(...) end
    self.m_zoomOutFunc       = function(...) self:zoomOut(...) end

    self.m_funcEnterVehicle = function(...) self:enterVehicle(...) end
    self.m_funcExitVehicle  = function(...) self:exitVehicle(...) end

    self.m_funcDisableFunc  = function(...) self:bindKeys(false) self:disable() end;

    self.m_funcToggleCam    = function(...)
        if(self.m_bEnabled) then
            self:disable()
        else
            self:enable();
        end
    end


    -- Funktionen --

    self.m_tblValidModels = {[497] = true, [488] = true};

    self.rotX   = 0;
    self.rotY   = 0;
    self.rotZ   = 0;


    self.m_iCurZoomValue    = 0;
    self.m_iCurZoom         = 80;

    self.currentMoveValueX   = 0;
    self.currentMoveValueY   = 0;


    self.delay              = 5;
    self.mouseSensitivity   = 0.025;
    self.PI                 = math.pi


    self.m_sControlName     = "lctrl";
    self.m_bUseFreecam      = false;


    self.options =
    {
    	invertMouseLook = false,
    	normalMaxSpeed = 0.7,
    	slowMaxSpeed = 0.2,
    	fastMaxSpeed = 12,
    	smoothMovement = true,
    	acceleration = 0.05,
    	decceleration = 0.01,
    	mouseSensitivity = 0.3,
    	maxYAngle = 188,
    	key_fastMove = "lshift",
    	key_slowMove = "lalt",
    	key_forward = "w",
    	key_backward = "s",
    	key_left = "a",
    	key_right = "d"
    }



    -- Events --

    addEventHandler("onClientVehicleEnter", getRootElement(), self.m_funcEnterVehicle);
    addEventHandler("onClientVehicleExit", getRootElement(), self.m_funcExitVehicle);
    addEventHandler("onClientPlayerWasted", getLocalPlayer(), self.m_funcDisableFunc);


    addCommandHandler("freecam", function()
        if(getElementData(localPlayer, "Adminlevel") > 2) then
            self.m_funcToggleCam()

            self.m_bUseFreecam      =  not(self.m_bUseFreecam)
        end
    end)
end


-- EVENT HANDLER --
