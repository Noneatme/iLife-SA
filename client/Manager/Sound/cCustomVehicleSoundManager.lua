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
-- ## Name: CustomVehicleSoundManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomVehicleSoundManager = {};
CustomVehicleSoundManager.__index = CustomVehicleSoundManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomVehicleSoundManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// DoExplosion 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:DoExplosion(uVehicle)
	local iX, iY, iZ = getElementPosition(uVehicle);
	local int, dim = getElementInterior(uVehicle), getElementDimension(uVehicle);

	local s = playSound3D(self.pfade.sounds.."explosions/explode_"..math.random(1, self.randomExplodeSounds)..".mp3", iX, iY, iZ);

	setElementInterior(s, int);
	setElementDimension(s, dim);

	setSoundMaxDistance(s, 100);

end

-- ///////////////////////////////
-- ///// onVehicleEnter 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:onVehicleEnter(uVehicle)

end

-- ///////////////////////////////
-- ///// onVehicleExit 	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:onVehicleEnter(uVehicle)

end

-- ///////////////////////////////
-- ///// bindSirenKeys	    //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:bindSirenKeys()

end

-- ///////////////////////////////
-- ///// unbindSirenKeys	 //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:unbindSirenKeys()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleSoundManager:Constructor(...)
	-- Klassenvariablen --
	self.randomExplodeSounds	= 6;

	self.pfade					= {};
	self.pfade.sounds			= "res/sounds/"

    self.soundsToDisable        =
    {
        [17] = {9, 10}          -- SIRENEN
    }

    for group, index in pairs(self.soundsToDisable) do
        for _, id in pairs(index) do
    --        setWorldSoundEnabled(group, id, false)
        end
    end
	
	-- Methoden --
	self.vehicleExplosionFunc	= function(...) self:DoExplosion(source, ...) end;
    self.vehicleEnterFunc       = function(...) self:onVehicleEnter(source, ...) end
    self.vehicleExitFunc       = function(...) self:onVehicleExit(source, ...) end

	-- Events --
    addEventHandler("onClientVehicleEnter", getRootElement(), self.vehicleEnterFunc)
    addEventHandler("onClientVehicleExit", getRootElement(), self.vehicleEnterFunc)

    addEventHandler("onClientVehicleExplode", getRootElement(), self.vehicleExplosionFunc)

	
	--logger:OutputInfo("[CALLING] CustomVehicleSoundManager: Constructor");
end

-- EVENT HANDLER --
