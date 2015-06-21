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
-- ## Name: MoveableObjectExtraManager.lua##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

MoveableObjectExtraManager = {};
MoveableObjectExtraManager.__index = MoveableObjectExtraManager;

addEvent("onClientObjectAction", true)
--[[


]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function MoveableObjectExtraManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// PlayObjectSound	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectExtraManager:PlayObjectSound(sFilepath, uObject, iMaxDistance)
	local iInt, iDim	= getElementInterior(uObject), getElementDimension(uObject);
	local x, y, z		= getElementPosition(uObject);
		
	local sound = playSound3D(self.pfade.sounds..sFilepath, x, y, z, false);
	setSoundMaxDistance(sound, (iMaxDistance or 50));
	
	setElementInterior(sound, iInt);
	setElementDimension(sound, iDim);
	attachElements(sound, uObject);
end

-- ///////////////////////////////
-- ///// ObjectAction		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectExtraManager:ObjectAction(iExtra, uObject)
	if(isElement(uObject)) then
		if(iExtra == 4) then	--- Toilet Flush
			self:PlayObjectSound("toilet_flush.mp3", uObject);
			local x, y, z = getElementPosition(uObject);
			setTimer(fxAddFootSplash, 50, 20, x, y, z+getElementDistanceFromCentreOfMassToBaseOfModel(uObject));
		elseif(iExtra == 3) then
			self:PlayObjectSound("vending_use.mp3", uObject);
			
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MoveableObjectExtraManager:Constructor(...)
	-- Klassenvariablen --
	self.pfade			= {}
	self.pfade.sounds	= "res/sounds/object/";
	
	-- Methoden --
	self.objectAction 	= function(...) self:ObjectAction(...) end;

	-- Events --
	addEventHandler("onClientObjectAction", getRootElement(), self.objectAction)
	--logger:OutputInfo("[CALLING] MoveableObjectExtraManager: Constructor");
end

-- EVENT HANDLER --
