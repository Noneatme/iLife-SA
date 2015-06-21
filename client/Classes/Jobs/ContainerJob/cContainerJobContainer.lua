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
-- ## Name: ContainerJobContainer.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

ContainerJobContainer = {};
ContainerJobContainer.__index = ContainerJobContainer;

--[[
for index, object in pairs(getElementsByType("object")) do
	if(getElementModel(object) == 2935) then
		x, y, z = getElementPosition(object)
		rx, ry, rz = getElementRotation(object)
		outputChatBox("{"..x..", "..y..", "..z..", "..rx..", "..ry..", "..rz.."},");
	end
end
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ContainerJobContainer:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ContainerJobContainer:Constructor(iType, iX, iY, iZ, rX, rY, rZ, iDim)
	-- Klassenvariablen --
	
	self.models		= 
	{
		[1] = 2934, -- Roter Container
		[2] = 2935,	-- Gelber Container
		[3] = 2932,	-- Blauer Container
	
	}
	
	self.position 	= {iX, iY, iZ};
	self.rotation 	= {rX, rY, rZ};
	
	self.modell		= (self.models[iType] or 2943)
	
	
	self.uObject	= createObject(self.modell, iX, iY, iZ, rX, rY, rZ)
	self.marker		= createMarker(iX, iY, iZ, "arrow", 2.0, 0, 255, 255, 255);
	
	attachElements(self.marker, self.uObject, 0, 0, 3+getElementDistanceFromCentreOfMassToBaseOfModel(self.uObject))

	
	setElementDimension(self.uObject, (iDim) or 0)
	setElementData(self.uObject, "cj:crate", true)
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] ContainerJobContainer: Constructor");
end

-- EVENT HANDLER --
