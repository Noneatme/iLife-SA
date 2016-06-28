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
-- Date: 21.12.2014
-- Time: 21:49
-- Made for MTA: iLife
--

cWaffentruckTruck = {};

--[[
    Kiste: 944
    Zaun: 983

1344
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cWaffentruckTruck:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// ApplyObjects 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:applyObjects()
    if(type(self.m_uKisten) ~= "table") then
        -- FENCES --
        self.m_uFences          = {};
        self.m_uKisten          = {};
        self.m_uSigns           = {};

        self.m_uFences[1]       = createObject(self.m_iFenceID, unpack(self.m_tblPosition));
        self.m_uFences[2]       = createObject(self.m_iFenceID, unpack(self.m_tblPosition));

        -- ATTACH FENCES --
        self.m_uFences[1]:attach(self.m_uVehicle, 1.45, -0.85, 0.42);
        self.m_uFences[2]:attach(self.m_uVehicle, -1.45, -0.85, 0.42);

        -- ATTACH SIGNS --
        self.m_uSigns[1]        = createObject(self.m_iSignID, unpack(self.m_tblPosition));
        self.m_uSigns[2]        = createObject(self.m_iSignID, unpack(self.m_tblPosition));

        for _, sign in pairs(self.m_uSigns) do
            sign:setScale(self.m_iSignScale);
            sign:setCollisionsEnabled(false);
        end

        self.m_uSigns[1]:attach(self.m_uFences[1], 0, 0, 0, 0, 0, 90);
        self.m_uSigns[2]:attach(self.m_uFences[2], 0, 0, 0, 0, 0, -90);

        -- CRATES --
        local kisten = 1;
        local z = 0;
        local increment = 1;
        -- UNTERE SEITE --
        for i = 0, math.floor(self.m_iMAX_KISTEN/2), 1 do
            if(kisten < self.m_iMAX_KISTEN) then
                if(i ~= 0) and ((((i)*2) % 10) == 0) then
                    z = z+(1.4*2)
                    increment = 1;
                end

                self.m_uKisten[kisten]       = createObject(self.m_iKistID, unpack(self.m_tblPosition));
                self.m_uKisten[kisten]:attach(self.m_uVehicle, -0.02, 3-(increment*1.5), z+0.6);
                self.m_uKisten[kisten+1]      = createObject(self.m_iKistID, unpack(self.m_tblPosition));
                self.m_uKisten[kisten+1]:attach(self.m_uVehicle, -0.02, 3-(increment*1.5), z+2);
                increment = increment+1;
                kisten = kisten+2;
            end
        end

        -- OBERE SEITE --
        --[[
        for i = 1, 5, 1 do
            if(kisten < self.m_iMAX_KISTEN) then
                self.m_uKisten[5+i]    = createObject(self.m_iKistID, unpack(self.m_tblPosition));
                self.m_uKisten[5+i]:attach(self.m_uVehicle, -0.02, 3-(i*1.5), 2);
                kisten = kisten+1;
            end
        end]]

        -- Ungerade Zahl?
        if(self.m_iMAX_KISTEN % 2 ~= 0) then
            if(kisten % 10 == 1) and (kisten > 10) then
                z = z+(1.4*2)
                increment = 1;
            end

            self.m_uKisten[kisten] = createObject(self.m_iKistID, unpack(self.m_tblPosition));
            self.m_uKisten[kisten]:attach(self.m_uVehicle, -0.02, 3-(increment*1.5), z+0.6);
        end


        for _, kiste in pairs(self.m_uKisten) do
           kiste:setDoubleSided(true);
        end
    end
end

-- ///////////////////////////////
-- ///// createDummyBomb	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:createDummyBomb(i)

    local vX, vY, vZ     = self.m_uVehicle:getVelocity();

    local pos            = self.m_uKisten[i]:getPosition();
    local rot            = self.m_uKisten[i]:getRotation();

    self.m_uDummyObjects[i]  = createObject(1344, pos:getX(), pos:getY(), pos:getZ(), rot:getX(), rot:getY(), rot:getZ());

    local dummy_object = self.m_uDummyObjects[i];

    dummy_object:setScale(0);
    dummy_object:setFrozen(false);
    dummy_object:setData("wt:muelltonne", true);
    dummy_object:setData("wt:uVehicle", self.m_uVehicle);
    dummy_object:setData("wt:i", i);

    local right_object  = createObject(self.m_iKistID, pos:getX(), pos:getY(), pos:getZ());
    right_object:setDoubleSided(true);
    right_object:attach(dummy_object);
    right_object:setCollisionsEnabled(false);

 --[[   local vehicle   = createVehicle(594, pos:getX(), pos:getY(), pos:getZ()+1, rot:getX(), rot:getY(), rot:getZ())
    vehicle:setAlpha(0);
    vehicle:setVelocity(vX, vY, vZ-0.5)
    vehicle:setHandling("mass", 10000)
    setTimer(destroyElement, 100, 1, vehicle);
    ]]

    dummy_object:setVelocity(vX, vY, vZ)

    -- COLSHAPE --

    triggerClientEvent(getRootElement(), "onClientWaffentruckKisteDrop", dummy_object, self.m_uVehicle, i);
    --[[
        self.m_uColShapes[i] = createColSphere(pos:getX(), pos:getY(), pos:getZ(), 5);
        self.m_uColShapes[i]:setData("wt:i", i);
        self.m_uColShapes[i]:attach(dummy_object);

        addEventHandler("onColShapeHit", self.m_uColShapes[i], self.m_funcKistenPickup);
    ]]

    addEventHandler("onWaffentruckKistePickup", dummy_object, self.m_funcKistenPickup);

    -- TIMER --
    self.m_uKistenTimer[i] = setTimer(self.m_funcDeleteDummyObject, self.m_iKistenTimeout, 1, dummy_object, true)
end

-- ///////////////////////////////
-- ///// kistePickupByPlayer//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:event_kistePickupByPlayer(uElement, iID)
    if(uElement) and (uElement:getType() == "player") then
        local uKiste = self.m_uDummyObjects[iID];
        if(uKiste) and (uKiste:getData("wt:muelltonne")) then
            -- FRAKTIONSABFRAGE: TODOO!!!

            -- GivePlayerMoney

            -- uElement:addMoney(math.random(self.m_iMIN_KISTEN_CASH, self.m_iMAX_KISTEN_CASH));


        --[[    local i = tonumber(uKiste:getData("wt:i"));
            if(self.m_uKistenTimer[i]) then
                killTimer(self.m_uKistenTimer[i]);
            end

           self.m_funcDeleteDummyObject(self.m_uDummyObjects[i], false);--]]
        end
    end
end


-- ///////////////////////////////
-- ///// removeCrates  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:removeCrates(iAmmount, dummy)
    for i = self.m_iCurrentCrates, self.m_iCurrentCrates-iAmmount+1, -1 do
        if(i >= 1) then
            if(dummy ~= true) then
                self:createDummyBomb(i);
            end
            self.m_uKisten[i]:destroy();
        end
    end
end

-- ///////////////////////////////
-- ///// TuneCar     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:tuneCar()
    self.m_uVehicle:setColor(0, 0, 0, 0, 0, 0);
    self.m_uVehicle:setHealth(self.m_iBASE_VEHICLE_HP);

    --[[ OLD
    self.m_uVehicle:removeSirens()
    self.m_uVehicle:addSirens(1, 2, true, true, true, true)
    self.m_uVehicle:setSirens(1, -0.7, 3.9, 1.4, 255, 0, 0, 255, 132.6)
    self.m_uVehicle:setSirensOn(true);
    --]]

    self.m_uVehicle:removeSirens();
    self.m_uVehicle:addSirens(5, 5, true, false, true, true);
    self.m_uVehicle:setSirens(1, -0.7, 3.9, 1.4, 255, 0, 0, 200, 255);
    self.m_uVehicle:setSirens(2, 1.4, 2.3, -0.3, 0, 255, 0, 200, 255);
    self.m_uVehicle:setSirens(3, -1.4, 2.3, -0.3, 0, 255, 0, 200, 255);
    self.m_uVehicle:setSirens(4, -1.4, -5.6, -0.3, 0, 255, 0, 200, 255);
    self.m_uVehicle:setSirens(5, 1.4, -5.6, -0.3, 0, 255, 0, 200, 255);
    self.m_uVehicle:setSirensOn(true);

    -- HANDLING --
    local hdl = getModelHandling(getVehicleModelFromName("Flatbed"))
    -- self.m_uVehicle:setHandling("collisionDamageMultiplier", -20.0);
    for index, val in pairs(hdl) do
        self.m_uVehicle:setHandling(index, val);
    end
end

-- ///////////////////////////////
-- ///// recheckCrrates     //////
-- ///// Returns: void		//////
-- ///////////////////////////////
-- 10 = 2100
-- 1 = ?

function cWaffentruckTruck:recheckCrates(hp)
    if not(hp) then
        hp = self.m_uVehicle:getHealth();
    end
    local cratesAvailable = math.floor((hp) / (self.m_iBASE_CRATES_HP / self.m_iMAX_KISTEN));

    if(cratesAvailable < self.m_iCurrentCrates) then
        local cratesLost = self.m_iCurrentCrates-cratesAvailable;
        self:removeCrates(cratesLost);
        self.m_iCurrentCrates = self.m_iCurrentCrates-cratesLost;
    end
end

-- ///////////////////////////////
-- ///// event_vehicleDamage//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:event_vehicleDamage(dmg)
    -- Make Ressistent
    self.m_uVehicle:setHealth(self.m_uVehicle:getHealth()+dmg/5);

    self:recheckCrates();
end

-- ///////////////////////////////
-- ///// ExplodeVehicle		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:event_explodeVehicle()
    self:recheckCrates(0);
    setTimer(self.func_destructor, self.m_iKistenTimeout, 1);
end


-- ///////////////////////////////
-- ///// ExitVehicle 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:event_exitVehicle(uPlayer)
    local uVehicle = self.m_uVehicle;

    local pos = uVehicle:getPosition();
    local rot = uVehicle:getRotation();

    local newx, newy = self:getPointFromDistanceRotation(pos:getX(), pos:getY(), 5, rot:getZ()*-1);
    local newz = pos:getZ();

    uPlayer:setPosition(Vector3(newx, newy, newz));
end


    -- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:destructor()
    self:removeCrates(self.m_iMAX_KISTEN);

    for i = 1, self.m_iMAX_FENCES, 1 do
        self.m_uFences[i]:destroy();
        self.m_uSigns[i]:destroy();
    end

    self.m_uVehicle:destroy();

    for id, ob in pairs(self.m_uDummyObjects) do
        if(ob) then

           self.m_uDummyObjects[id] = nil;
           if(isElement(ob)) then
               for _, object in pairs(ob:getAttachedElements()) do
                   if(object) then
                       object:destroy();
                   end
               end
               ob:destroy();
           end
        end
    end
end


function cWaffentruckTruck:getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);

    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;

    return x+dx, y+dy;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckTruck:constructor(iFactionID, iX, iY, iZ, iRX, iRY, iRZ, iKisten)
    -- Klassenvariablen --
    self.m_iFactionID       = (iFactionID or 0);
    self.m_tblPosition      = {iX, iY, iZ};
    self.m_tblRotation      = {(iRX or 0), (iRY or 0), (iRZ or 0)};

    self.m_uVehicle         = createVehicle(578, iX, iY, iZ, iRX, iRY, iRZ);

    self.m_uKisten          = false;
    self.m_uFences          = false;
    self.m_uSigns           = false;

    self.m_iFenceID         = 983;
    self.m_iKistID          = 944;
    self.m_iSignID          = 8330;

    self.m_iSignScale       = 0.2;

    self.m_iMAX_FENCES      = 2;
    self.m_iMAX_KISTEN      = iKisten;

    self.m_iBASE_VEHICLE_HP = 2000;
    self.m_iBASE_CRATES_HP  = 2000;

    self.m_iCurrentCrates   = self.m_iMAX_KISTEN;

    self.m_iCurrentDamage   = 0;
    self.m_iResistentDamage = 100;

    self.m_uColShapes       = {};
    self.m_uKistenTimer     = {};
    self.m_uDummyObjects    = {};

    self.m_iKistenTimeout   = 60000; -- 1 Minute

    self.m_iMIN_KISTEN_CASH = 500;      -- Minimaler Reward fuer das Aufsammeln der Kisten
    self.m_iMAX_KISTEN_CASH = 5000;     -- Maximaler Reward fuer das Aufsammeln der Kisten

    -- Funktionen --

    self:tuneCar();
    self:applyObjects();

    self.m_funcVehicleDamage        = function(...) self:event_vehicleDamage(...) end
    self.m_funcDeleteDummyObject    = function(uObject, expl)
        if(uObject) and (isElement(uObject)) then
            for i, object in pairs(uObject:getAttachedElements()) do
                if(object) then
                    object:destroy();
                end
            end

            local pos = uObject:getPosition();
            if(expl) then createExplosion(pos:getX(), pos:getY(), pos:getZ(), 5) end
            uObject:destroy()
        end
    end;


    self.m_funcKistenPickup         = function(...) self:event_kistePickupByPlayer(client, ...) end
    self.m_funcExplodeVehicle       = function(...) self:event_explodeVehicle(source, ...) end
    self.func_destructor            = function(...) self:destructor(...) end;
    self.m_funcExitVehicle          = function(...) self:event_exitVehicle(...) end;

    -- Events --
    addEvent("onWaffentruckKistePickup", true);

    addEventHandler("onVehicleDamage", self.m_uVehicle, self.m_funcVehicleDamage);
    addEventHandler("onVehicleExplode", self.m_uVehicle, self.m_funcExplodeVehicle);
    addEventHandler("onVehicleExit", self.m_uVehicle, self.m_funcExitVehicle);
end

-- EVENT HANDLER --
