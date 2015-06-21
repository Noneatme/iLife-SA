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
-- ## Name: CO_Grill.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CO_Grill = {};
CO_Grill.__index = CO_Grill;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Grill:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// AddRauch	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Grill:AddRauch(uObject)
	if not(isElement(self.rauch[uObject])) then
		local x, y, z = getElementPosition(uObject)
		self.rauch[uObject] = createObject(2415, x, y, z, 0, 0, 0)
		attachElements(self.rauch[uObject], uObject, 0, 0, -0.5);
		setElementCollisionsEnabled(self.rauch[uObject], false);
		setElementAlpha(self.rauch[uObject], 0);
	end
end

-- ///////////////////////////////
-- ///// RemoveRauch 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Grill:RemoveRauch(uObject)
	if(isElement(self.rauch[uObject])) then
		destroyElement(self.rauch[uObject]);
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Grill:Constructor(...)
	-- Klassenvariablen --
	self.rauch = {}
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] CO_Grill: Constructor");
end

-- EVENT HANDLER --
