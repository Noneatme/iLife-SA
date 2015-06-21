--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 		 iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: cTruckerJob.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

cTruckerJob = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// clearPlayerElement	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:clearPlayerElement(uPlayer, bReset)
    if(isElement(self.m_uPlayerTrailers[uPlayer])) then
        self.m_uPlayerTrailers[uPlayer]:destroy()
        self.m_uPlayerTrucks[uPlayer]:destroy()

        if(bReset) and (uPlayer) and (isElement(uPlayer)) then
            local x3, y3, z3 = unpack(self.m_tblPosFinish);
            uPlayer:removeFromVehicle()
            uPlayer:setPosition(x3, y3, z3)
        end
    end

    if(isElement(uPlayer)) then
        triggerClientEvent(uPlayer, "onClientPlayerTruckerjobStop", uPlayer)

        uPlayer.m_bTruckerjob               = false;
        uPlayer.m_bTruckerjobAblade         = false;

    end
end

-- ///////////////////////////////
-- ///// getRandomPos    	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:getRandomPos()
    if not(self.m_tblPos) then
        self.m_tblPos =
        {
            {253.05815124512, 13.876224517822, 3.0577020645142},
            {823.80578613281, 849.46069335938, 13.234528541565},
            {1411.2966308594, 1050.2846679688, 12.272633552551},
            {-863.51947021484, 1556.0473632813, 24.95849609375},
            {-1259.4642333984, 476.11441040039, 8.6198511123657},
            {-1022.2796630859, -656.7392578125, 33.366382598877},
            {-1049.5931396484, -1201.4587402344, 130.37065124512},
            {-1944.8322753906, -1074.3707275391, 32.218231201172},
            {-2082.236328125, -21.24100112915, 35.993015289307},
            {-2266.8537597656, 532.25543212891, 36.195709228516},
            {-2661.4304199219, 589.21600341797, 15.633574485779},
            {-2514.7641601563, 2326.6652832031, 6.0442900657654},
            {-2262.6020507813, 2298.8366699219, 5.8120732307434},
            {-1934.7322998047, 2379.5837402344, 50.932991027832},
            {-1809.5065917969, 2045.5062255859, 10.234303474426},
            {-1966.1617431641, 1382.8913574219, 8.1465854644775},
            {-1698.4024658203, 408.15023803711, 8.0394592285156},
            {-1856.5043945313, -1678.3409423828, 22.856275558472},
            {-2006.9621582031, -2424.4213867188, 32.060176849365},
            {-2216.2375488281, -2378.3442382813, 32.872325897217},
            {-2156.8349609375, -2520.0234375, 31.321830749512},
            {-2688.4311523438, 1377.62890625, 7.6548852920532},
            {85.293815612793, 1172.9276123047, 19.380676269531},
            {595.70135498047, 1226.5776367188, 14.253141403198},
            {643.56927490234, 1249.5006103516, 14.254421234131},
            {322.11410522461, 868.23907470703, 21.335601806641},
            {-33.335201263428, 78.587348937988, 4.7666358947754},
            {206.7001953125, -148.0037689209, 3.0296170711517},
            {1433.3513183594, 1908.3804931641, 10.8203125},
            {104.93320465088, 2589.4965820313, 16.506227493286},
            {-530.81353759766, 2568.384765625, 53.4140625},
            {-1655.2332763672, 2538.6665039063, 85.276824951172},
        }
    end
    return self.m_tblPos[math.random(1, #self.m_tblPos)]
end

-- ///////////////////////////////
-- ///// generateMarker 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:generateMarker()
    self:getRandomPos(www)
    self.m_tblMarker        = {}

    for index, pos in pairs(self.m_tblPos) do
        self.m_tblMarker[index] = Marker(pos[1], pos[2], pos[3], "checkpoint", 5.0, 0, 255, 0, 255, uPlayer)
        self.m_tblMarker[index]:setDimension(1337)

        addEventHandler("onMarkerHit", self.m_tblMarker[index], function(uElement)
            if(uElement) and (getElementType(uElement) == "player") then
                if(uElement.m_bTruckerjob) and not(uElement.m_bTruckerjobAblade) then
                    if (uElement:getOccupiedVehicle():getTowedByVehicle() == self.m_uPlayerTrailers[uElement]) then
                        uElement.m_bTruckerjobAblade        = true;
                        uElement.m_tblTruckerjobMarker      = pos;
                        uElement:showInfoBox("info", "Begebe dich nun zum Abladepunkt! (Blauer Marker beim Truckerjob)");
                        setElementVisibleTo(self.m_uAbladeMarker, uElement, true) -- OOP-Methode funktioniert nicht

                        triggerClientEvent(uElement, "onClientPlayerTruckerjobStop", uElement)
                    else
                        uElement:showInfoBox("error", "Du hast deinen Anhänger nicht dabei!");
                    end
                end
            end
        end)
    end

    self.m_uAbladeMarker        = Marker(self.m_tblPosAblade[1], self.m_tblPosAblade[2], self.m_tblPosAblade[3], "checkpoint", 5.0, 0, 255, 255);
    setElementVisibleTo(self.m_uAbladeMarker, getRootElement(), false) -- OOP-Methode funktioniert nicht
    addEventHandler("onMarkerHit", self.m_uAbladeMarker, function(uElement)
        if(uElement) and (getElementType(uElement) == "player") then
            if(uElement.m_bTruckerjob) and (uElement.m_bTruckerjobAblade) then
                if (uElement:getOccupiedVehicle():getTowedByVehicle() == self.m_uPlayerTrailers[uElement]) then
                    uElement.m_bTruckerjobAblade        = false;

                    local x, y, z       = self.m_uAbladeMarker:getPosition().x, self.m_uAbladeMarker:getPosition().y, self.m_uAbladeMarker:getPosition().z
                    local x2, y2, z2    = uElement.m_tblTruckerjobMarker[1], uElement.m_tblTruckerjobMarker[2], uElement.m_tblTruckerjobMarker[3];

                    local dist          = math.floor((getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)/100));
                    local lohn          = math.floor(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)/2)*getEventMultiplicator()

                    uElement:showInfoBox("sucess", "Du hast die Ware abgeliefiert und erhaelst $"..lohn.."!");
                    triggerClientEvent(uElement, "onClientPlayerTruckerjobStart", uElement, self.m_tblPos, self.m_tblMarker)
                    uElement:addMoney(lohn)
                    uElement:incrementStatistics("Job", "Geld_erarbeitet", lohn)
                    uElement:incrementStatistics("Job", "Ware_abgeliefert", 1)
                    uElement:checkJobAchievements()
                    uElement.m_tblTruckerjobMarker = false;
                    setElementVisibleTo(self.m_uAbladeMarker, uElement, false) -- OOP-Methode funktioniert nicht
                else
                    uElement:showInfoBox("error", "Du hast deinen Anhänger nicht dabei!");
                end
            end
        end
    end)

end

-- ///////////////////////////////
-- ///// startPlayerJob 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:startPlayerJob(uPlayer)
    self:clearPlayerElement(uPlayer)

    if not(uPlayer:getOccupiedVehicle()) then
        Achievements[5]:playerAchieved(uPlayer)

        local models    =
        {
            [1] = 584,
            [2] = 435,
            [3] = 591,
            [4] = 450,
        }

        self.m_uPlayerTrucks[uPlayer]       = Vehicle(getVehicleModelFromName("Roadtrain"), -69.130630493164, -1129.6350097656, 2.1839621067047, 0, 0, 70);
        enew(self.m_uPlayerTrucks[uPlayer], CBasicVehicle);
        self.m_uPlayerTrailers[uPlayer]     = Vehicle(models[math.random(1, #models)], -69.130630493164, -1129.6350097656, 10.1839621067047, 0, 0, 70);
        self.m_uPlayerTrailers[uPlayer].JobTruck = true;
        self.m_uPlayerTrucks[uPlayer].JobTruck = true;


        self.m_uPlayerTrucks[uPlayer]:enableGhostmode(10000)
        self.m_uPlayerTrailers[uPlayer]:enableGhostmode(10000)

        self.m_uPlayerTrucks[uPlayer]:setEngineState(true)

        attachTrailerToVehicle(self.m_uPlayerTrucks[uPlayer], self.m_uPlayerTrailers[uPlayer])

        addEventHandler("onTrailerDetach", self.m_uPlayerTrailers[uPlayer], function(uVehicle)
            if(uVehicle == self.m_uPlayerTrucks[uPlayer]) then
                if(uVehicle:getOccupant()) then
                    uVehicle:getOccupant():showInfoBox("error", "Du hast deinen Anhaenger verloren!")
                end
            end
        end)

        addEventHandler("onTrailerAttach", self.m_uPlayerTrailers[uPlayer], function(uVehicle)
            if(uVehicle == self.m_uPlayerTrucks[uPlayer]) then
                if(uVehicle:getOccupant()) then
                    uVehicle:getOccupant():showInfoBox("sucess", "Weiter gehts!")
                end
            end
        end)

        local function explode()
            uPlayer:removeFromVehicle()
            self:clearPlayerElement(uPlayer, true)
            uPlayer:showInfoBox("error", "Dein Fahrzeug ist explodiert!")
        end

        uPlayer.m_bTruckerjob               = true;
        uPlayer.m_bTruckerjobAblade         = false;

        addEventHandler("onVehicleExplode", self.m_uPlayerTrailers[uPlayer], explode)
        addEventHandler("onVehicleExplode", self.m_uPlayerTrucks[uPlayer], explode)

        addEventHandler("onVehicleStartExit", self.m_uPlayerTrucks[uPlayer], function(uPlayer) self:clearPlayerElement(uPlayer, true) end)

        triggerClientEvent(uPlayer, "onClientPlayerTruckerjobStart", uPlayer, self.m_tblPos, self.m_tblMarker)

        warpPedIntoVehicle(uPlayer, self.m_uPlayerTrucks[uPlayer])
        --[[
        local x, y, z       = unpack(self:getRandomPos())
        local x2, y2, z2    = uPlayer:getPosition()
        local ort           = getZoneName(x, y, z, false)..", "..getZoneName(x, y, z);
        local dist          = math.floor((getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)/100));
        local lohn          = math.floor(getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)/2)
        --]]
        uPlayer:showInfoBox("info", "Bring die Ware zu einem Ort deiner Wahl! Die Bezahlung haengt von der Distanz ab.");
    --    outputChatBox("Die Ware muss zu "..ort..". Distanz: "..dist.." km, Bezahlung: $"..lohn, uPlayer, 0, 0, 255)
        --[[
        addEventHandler("onMarkerHit", self.m_uPlayerMarker[uPlayer], function(uPlayer2)
            if(uPlayer2) and (isElement(uPlayer2)) and (getElementType(uPlayer2) == "vehicle") then
                uPlayer2 = uPlayer2:getOccupant()
                if(uPlayer2) and (uPlayer == uPlayer2) and (uPlayer2:getOccupiedVehicle():getTowedByVehicle() == self.m_uPlayerTrailers[uPlayer]) then
                    self:clearPlayerElement(uPlayer2, true)
                    uPlayer2:showInfoBox("sucess", "Du hast die Ware abgeliefiert und erhaelst $"..lohn.."!");
                    uPlayer2:addMoney(lohn)
                    if(isElement(source)) then
                        destroyElement(source)
                    end
                else
                    if(uPlayer2) and (isElement(uPlayer2)) then
                        uPlayer2:showInfoBox("error", "Du hast keinen Anhaenger dabei!");
                    end

                    if not(isElement(uPlayer)) then
                        destroyElement(source)
                    end
                end
            end
        end)
        --]]
    end

end

-- ///////////////////////////////
-- ///// onPickupHit 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:onPickupHit(uHit, Dim)
    if((uHit) and getElementType(uHit) == "player") then
        if (getPlayerWantedLevel(uHit) == 0) then
            triggerClientEvent(uHit, "onTruckerStartMarkerHit", uHit)
        else
            uHit:showInfoBox("info", "Du wirst derzeit von der Polizei gesucht, solche Leute wollen wir bei uns nicht.")
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cTruckerJob:constructor(...)
    addEvent("onTruckerStartMarkerHitDo", true)

    -- Klassenvariablen --
    self.m_sPickup          = Pickup(-77.178802490234, -1135.9713134766, 1.078125, 3, 1239, 50)

    self.m_tblPosFinish     = {-85.425231933594, -1135.2625732422, 1.078125}

    self.m_tblPosAblade     = {-79.694305419922, -1194.2185058594, 1.8538074493408}

    self.m_uPlayerTrailers      = {}
    self.m_uPlayerTrucks        = {}

    self:generateMarker()
    -- Funktionen --
    self.m_funcPickupHit        = function(...) self:onPickupHit(...) end
    self.m_funcOnPlayerStart    = function(...) self:startPlayerJob(client, ...) end

    self.truckjobStadthalleRow			= new(CJob, 10, "Trucker", "-77.178802490234|-1135.9713134766|1.078125")

    -- Events --

    addEventHandler("onPickupHit", self.m_sPickup, self.m_funcPickupHit)
    addEventHandler("onTruckerStartMarkerHitDo", getRootElement(), self.m_funcOnPlayerStart)
end

-- EVENT HANDLER --
