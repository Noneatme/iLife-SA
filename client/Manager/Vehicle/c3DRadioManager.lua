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
-- ## Name: c3DRadioManager.lua		        	##
-- ## Author: Noneatme(Gunvarrel)		##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

c3DRadioManager = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function c3DRadioManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- /////stopVehicleRadio 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:stopVehicleRadio(uElement)
    if(isElement(self.m_tblVehicleRadios[uElement])) then
        destroyElement(self.m_tblVehicleRadios[uElement]);
    end
end

-- ///////////////////////////////
-- /////startVehicleRadio 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:startVehicleRadio(uElement)
    self:stopVehicleRadio(uElement)

    local radioURL      = uElement:getData("radio:URL")

    if(radioURL) and (tonumber(radioURL) ~= 0) then
        local x, y, z = uElement:getPosition()
        self.m_tblVehicleRadios[uElement]   = Sound3D.create(radioURL, x, y, z, true);
        self.m_tblVehicleRadios[uElement]:attach(uElement);
        setSoundMaxDistance(self.m_tblVehicleRadios[uElement], 20);
        setSoundVolume(self.m_tblVehicleRadios[uElement], 0.5);
        setSoundEffectEnabled(self.m_tblVehicleRadios[uElement], "chorus", true)

        addEventHandler("onClientSoundChangedMeta", self.m_tblVehicleRadios[uElement], function(sTitle)
            if((source:getPosition()-localPlayer:getPosition()).length < 10) and not (isPedInVehicle(localPlayer))  then
                showInfoBox("radio", sTitle, 5000, "none")
            end
        end)

    end
end


-- ///////////////////////////////
-- ///// onElementStreamIn 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:onElementStreamIn(uElement)
    if(uElement) and (getElementType(uElement) == "vehicle") then
        if(toboolean(cConfig_RadioConfig:getInstance():getConfig("radenabled_vehicle"))) then
            if(uElement:getData("radio:URL")) then
                self:stopVehicleRadio(uElement)
                self:startVehicleRadio(uElement)
            end
        end
    end
end

-- ///////////////////////////////
-- ///// onElementStreamOut	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:onElementStreamOut(uElement)
    if(uElement) and (getElementType(uElement) == "vehicle") then
        if(toboolean(cConfig_RadioConfig:getInstance():getConfig("radenabled_vehicle"))) then
            self:stopVehicleRadio(uElement)
        end
    end
end

-- ///////////////////////////////
-- ///// checkElementDestroy	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:checkElementDestroy(uElement)
    self:stopVehicleRadio(uElement);
end
-- ///////////////////////////////
-- ///// onElementDataChange//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:onElementDataChange(uElement, sData, sOldValue)
    if(uElement) and (getElementType(uElement) == "vehicle") and (isElementStreamedIn(uElement)) then
        if(sData == "radio:NAME")  then
            if(toboolean(cConfig_RadioConfig:getInstance():getConfig("radenabled_vehicle"))) then
                self:startVehicleRadio(uElement)
            end
        end
    end
end

-- ///////////////////////////////
-- ///// onRender    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:onRender()
    for veh, sound in pairs(self.m_tblVehicleRadios) do
        if(isElement(veh)) and (isElement(sound)) then
            local totalSound    = 0.1;

            for i = 1, 5, 1 do
                totalSound = totalSound+(getVehicleDoorOpenRatio(veh, i)/3)
            end
            if(totalSound > 1) then
                totalSound = 1
            end
            setSoundVolume(sound, totalSound)
        else
            if(isElement(sound)) then
                destroyElement(sound)
            end
            self.m_tblVehicleRadios[veh] = nil;
        end
    end
end

-- ///////////////////////////////
-- ///// checkResetVehicleSound///
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:checkResetVehicleSound(uVehicle)
    self:stopVehicleRadio(uVehicle)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function c3DRadioManager:constructor(...)
    -- Klassenvariablen --
    self.m_tblVehicleRadios             = {}

    -- Funktionen --
    self.m_funcOnElementStreamIn        = function(...) self:onElementStreamIn(source, ...) end
    self.m_funcOnElementStreamOut       = function(...) self:onElementStreamOut(source, ...) end
    self.m_funcCheckElementDestroy      = function(...) self:checkElementDestroy(source, ...) end

    self.m_funcCheckElementChange       = function(...) self:onElementDataChange(source, ...) end

    for index, vehicle in pairs(getElementsByType("vehicle", getRootElement(), true)) do
        self:onElementStreamIn(vehicle)
    end

    self.m_funcResetVehicleSound        = function(...) self:checkResetVehicleSound(source, ...) end

    -- Events --
    addEventHandler("onClientElementStreamIn", getRootElement(), self.m_funcOnElementStreamIn)
    addEventHandler("onClientElementStreamOut", getRootElement(), self.m_funcOnElementStreamOut)
    addEventHandler("onClientElementDestroy", getRootElement(), self.m_funcCheckElementDestroy)
    addEventHandler("onClientVehicleRespawn", getRootElement(), self.m_funcResetVehicleSound)

    addEventHandler("onClientElementDataChange", getRootElement(), self.m_funcCheckElementChange)
    setTimer(function() self:onRender() end, 1000, 0);

end

-- EVENT HANDLER --
