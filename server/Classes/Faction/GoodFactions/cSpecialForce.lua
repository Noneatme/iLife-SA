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
-- Date: 16.02.2015
-- Time: 17:38
-- To change this template use File | Settings | File Templates.
--

cSpecialForce = inherit(cSingleton)


function cSpecialForce:constructor()
    -- Klassenvariablen --
    self.m_iDimension               = 25254;
    self.m_iInterior                = 3;

    self.m_uInteriorOutMarker       = createMarker(288.68511962891, 167.24078369141, 1007.171875, "corona", 1.0, 255, 255, 255);
    -- Davor: 288.65158081055, 170.43637084961, 1007.1794433594

    self.m_uInteriorOutMarker2      = createMarker(238.63232421875, 139.03332519531, 1003.0234375, "corona", 1.0, 255, 255, 255);
    -- Davor: 238.5132598877, 140.66781616211, 1003.0234375


    self.m_uInteriorInMarker        = createMarker(1942.6281738281, -1585.6071777344, 13.785817146301, "corona", 1.0, 255, 255, 255);
    -- Davor: 1940.640625, -1585.5018310547, 13.665749549866

    self.m_uInteriorInMarker2       = createMarker(1996.7763671875, -1591.0463867188, 13.666749954224, "corona", 1.0, 255, 255, 255); -- Bei den Zellen
    -- Davor: 1996.6958007813, -1587.9826660156, 13.666749954224

    self.m_uExitMarkerOut           = createMarker(273.10110473633, 185.97761535645, 1007.171875, "corona", 1.0, 255, 255, 255);
    -- Davor: 1795.7192382813, -1553.8502197266, 22.922264099121

    self.m_uExitMarkerIn            = createMarker(1988.8005371094, -1595.0627441406, 29.000009536743, "corona", 1.0, 255, 255, 255)
    -- Davor: 1990.6229248047, -1595.4636230469, 29.000009536743

    self.m_uDoor                    = createObject(1533, 272.70001220703, 185.19999694824, 1006.200012207, 0, 0, 90);


    self.m_uDutyPickup              = createPickup(252.2155456543, 184.82316589355, 1008.171875, 3, 1275, 100);
    self.m_uWeaponPickup            = createPickup(246.09803771973, 185.50978088379, 1008.171875, 3, 1242, 100);

    self.m_uStellPed                = createPed(286, 293.73098754883, 182.11433410645, 1007.171875, 145);
    self.m_uStellPed:setFrozen(true)
    self.m_uStellPed:setData("inv", true)

    self.m_uSwatPickup	            = createPickup(262.66159057617, 185.43704223633, 1008.171875, 3, 1252, 100)

    self.m_tblInteriorElements  =
    {
        self.m_uInteriorOutMarker,
        self.m_uInteriorOutMarker2,
        self.m_uDutyPickup,
        self.m_uStellPed,
        self.m_uExitMarkerOut,
        self.m_uDoor,
        self.m_uWeaponPickup,
        self.m_uSwatPickup,
    }

    for index, ele in pairs(self.m_tblInteriorElements) do
        ele:setInterior(self.m_iInterior);
        ele:setDimension(self.m_iDimension);
    end


    addEventHandler("onPickupHit", self.m_uWeaponPickup,
        function(thePlayer)
            if (thePlayer:getFaction():getID() == 2)  then
                if (thePlayer:isDuty()) and not(thePlayer:isSWAT()) then
                    thePlayer:resetWeapons()
                    setElementHealth(thePlayer, 100);
                    if (thePlayer:getRank() == 1) then
                        thePlayer:addWeapon(23, 150, false) 	-- Tazer
                        thePlayer:addWeapon(29, 540, false)     -- MP5
                    end
                    if (thePlayer:getRank() == 2) then
                        thePlayer:addWeapon(23, 30, false) 	-- Tazer
                        thePlayer:addWeapon(27, 150, false) -- Shotgun
                        thePlayer:addWeapon(29, 250, false) -- MP5
                    end
                    if (thePlayer:getRank() == 3) then
                        thePlayer:addWeapon(23, 30, false) -- Tazer
                        thePlayer:addWeapon(31, 540, false) -- M4
                        thePlayer:addWeapon(27, 150, false) -- Shotgun
                        thePlayer:addWeapon(29, 540, false) -- MP5
                        thePlayer:addWeapon(17, 1, false) -- Tear Gas
                    end
                    if (thePlayer:getRank() == 4) then
                        thePlayer:addWeapon(23, 30, false) -- Tazer
                        thePlayer:addWeapon(31, 540, false) -- M4
                        thePlayer:addWeapon(27, 150, false) -- Shotgun
                        thePlayer:addWeapon(17, 3, false) -- Tear Gas
                        thePlayer:addWeapon(29, 540, false) -- MP5
                        thePlayer:addWeapon(34, 10, false) -- Sniper
                    end
                    if (thePlayer:getRank() > 4) then
                        thePlayer:addWeapon(23, 30, false) -- Tazer
                        thePlayer:addWeapon(31, 540, false) -- M4
                        thePlayer:addWeapon(17, 3, false) -- Tear Gas
                        thePlayer:addWeapon(27, 150, false) -- Shotgun
                        thePlayer:addWeapon(34, 10, false) -- Sniper
                        thePlayer:addWeapon(29, 540, false) -- MP5
                    end

                    thePlayer:addWeapon(3, 1, false)
                    thePlayer:showInfoBox("info", "Du bist nun ausgerüstet!")
                    setPedArmor(thePlayer, 100)
                else
                    thePlayer:showInfoBox("error", "Du bist nicht im Dienst! / Bereits im SWAT Modus!")
                end
            else
                thePlayer:showInfoBox("error", "Du bist kein Beamter bei den SpF!")
            end
        end
    )

    addEventHandler("onPickupHit", self.m_uDutyPickup,
        function(thePlayer)
            if (thePlayer:getFaction():getID() == 2) then
                thePlayer:setSWAT(false)
                if (thePlayer:isDuty()) then
                    thePlayer:setDuty(false)
                    thePlayer:setSkin(thePlayer:getSkin())
                    thePlayer:showInfoBox("info", "Du hast deinen Dienst beendet!")
                    thePlayer:resetWeapons()
                else
                    thePlayer:setDuty(true)
                    thePlayer:setSkin(Factions[2]:getRankSkin(thePlayer:getRank()), true)
                    thePlayer:showInfoBox("info", "Du bist nun in Dienst!")
                end
            else
                thePlayer:showInfoBox("error", "Du bist kein Beamter beim LSPD!")
            end
        end
    )

    addEventHandler("onMarkerHit", self.m_uExitMarkerIn, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                if(uElement:getFaction():getType() == 1) then
                    uElement:fadeInPosition(275.14144897461, 186.13055419922, 1007.171875, self.m_iDimension, self.m_iInterior);
                else
                    uElement:showInfoBox("error", "Es ist abgeschlossen!")
                end
            end
        end
    end)

    addEventHandler("onMarkerHit", self.m_uExitMarkerOut, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                if(uElement:getFaction():getType() == 1) then
                    uElement:fadeInPosition(1990.2333984375, -1594.9860839844, 29.000009536743, 0, 0, 0);
                else
                    uElement:showInfoBox("error", "Es ist abgeschlossen!")
                end
            end
        end
    end)

    addEventHandler("onMarkerHit", self.m_uInteriorOutMarker, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                uElement:fadeInPosition(1940.640625, -1585.5018310547, 13.665749549866, 0, 0);
            end
        end
    end)

    addEventHandler("onMarkerHit", self.m_uInteriorOutMarker2, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                uElement:fadeInPosition(1996.6958007813, -1587.9826660156, 13.666749954224, 0, 0);
            end
        end
    end)

    addEventHandler("onMarkerHit", self.m_uInteriorInMarker, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                uElement:fadeInPosition(288.65158081055, 170.43637084961, 1007.1794433594, self.m_iDimension, self.m_iInterior);
            end
        end
    end)

    addEventHandler("onMarkerHit", self.m_uInteriorInMarker2, function(uElement, dim)
        if(dim) then
            if(getElementType(uElement) == "player") and not(isPedInVehicle(uElement)) then
                uElement:fadeInPosition(238.5132598877, 140.66781616211, 1003.0234375, self.m_iDimension, self.m_iInterior);
            end
        end
    end)


    addEventHandler("onPickupHit", self.m_uSwatPickup,
        function(thePlayer)
            local function giveSwatWeapons()
                thePlayer:addWeapon(3, 1, false) -- Nightstick
                thePlayer:addWeapon(23, 30, false) -- Tazer
                thePlayer:addWeapon(31, 540, false) -- M4
                thePlayer:addWeapon(17, 3, false) -- Tear Gas
                thePlayer:addWeapon(29, 540, false) -- MP5
                thePlayer:addWeapon(45, 1, false) -- Infrarotgeraet
            end


            if (thePlayer:getFaction():getID() == 2) then
                if (thePlayer:isDuty()) then
                    if(thePlayer:getRank() >= 3) then
                        if(thePlayer.m_bLSPD_SWAT == nil) then thePlayer.m_bLSPD_SWAT = false end;

                        local swat      = thePlayer:isSWAT();

                        if(swat) then
                            thePlayer:setSkin(Factions[2]:getRankSkin(thePlayer:getRank()), true)
                            thePlayer:showInfoBox("info", "Du hast den SWAT Modus verlassen.")
                            thePlayer:resetWeapons()
                        else
                            thePlayer:setSkin(285, true);
                            thePlayer:showInfoBox("info", "Du hast den SWAT Modus betreten.")
                            thePlayer:getInventory():addItem(Items[198], 1);
                            giveSwatWeapons()
                        end
                        thePlayer:setSWAT(not(swat))
                    end
                else
                    thePlayer:showInfoBox("error", "Du bist nicht im Dienst!")
                end
            else
                thePlayer:showInfoBox("error", "Du bist kein Beamter bei den Special Forces!")
            end

        end)

    addEventHandler("onElementClicked", self.m_uStellPed,
        function(btn, state, thePlayer)
            if  ((btn == "left") and (state == "down")) then
                outputChatBox("Officer: Klicke mich mit Rechtsklick an um dich zu stellen! (8 Minuten für jedes Wanted)", thePlayer, 255,255,255)
            end
            if  ((btn == "right") and (state == "down")) then
                if thePlayer:getWanteds() > 0 then
                    toggleAllControls (thePlayer, false)
                    thePlayer:showInfoBox("info","Du wirst in 10 Sekunden eingesperrt!")
                    setTimer(
                        function()
                            if thePlayer:getWanteds() > 3 then
                                Factions[2]:addDepotMoney(thePlayer:getWanteds()*100)
                                toggleAllControls (thePlayer, true)
                                for k2,v2 in ipairs( getElementsByType("player")) do
                                    if (getElementData(v2, "online")) and (v2:getFaction():getType() == 1) then
                                        if (thePlayer:getFaction():getType() == 2) then
                                            outputChatBox("Der Spieler "..thePlayer:getName().." hat sich gestellt und wurde für "..tostring(thePlayer:getWanteds()*4).." Minuten eingesperrt!", v2, 0, 255, 0)
                                        else
                                            outputChatBox("Der Spieler "..thePlayer:getName().." hat sich gestellt und wurde für "..tostring(thePlayer:getWanteds()*8).." Minuten eingesperrt!", v2, 0, 255, 0)
                                        end
                                    end
                                end
                                thePlayer:jail(thePlayer:getWanteds()*8, true, 2)
                            end
                        end, 10000, 1
                    )
                else
                    outputChatBox("Officer: Sie werden nicht gesucht!", thePlayer, 255,255,255)
                end
            end
        end
    )

    self.m_uJailmarker1 = createColSphere(1864.9403076172, -1605.5716552734, 13.539081573486, 5)

    local function einknasten(hitElement, matching)
        jailFunction(hitElement, matching, 2)
    end

    addEventHandler("onColShapeHit", self.m_uJailmarker1, einknasten)


    --3114, 1770.0999755859, -1572, 21.39999961853, 0, 0, 266
    -- 37.400001525879
    self.m_lift = Gate:New(0.5, "Lift der Special Force", 3114, 3000, {1977.5, -1569.5, 12.300000190735, 0, 0, 0}, {1977.5, -1569.5, 32.900001525879, 0, 0, 0}, {}, "faction", toJSON({1, 2}), "click", 1, "InOutQuad", "InOutQuad")

    -- Funktionen --


    -- Events --
end


function cSpecialForce:destructor()
    -- Klassenvariablen --


    -- Funktionen --


    -- Events --
end
