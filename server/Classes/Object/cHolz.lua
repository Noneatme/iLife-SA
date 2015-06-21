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
-- ## Name: CO_Holz.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CO_Holz = {};
CO_Holz.__index = CO_Holz;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CO_Holz:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// AddFire	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Holz:AddFire(uObject)
	if not(isElement(self.Fire[uObject])) then
		local x, y, z = getElementPosition(uObject)
		self.Fire[uObject] = createObject(3461, x, y, z, 0, 0, 0)
		attachElements(self.Fire[uObject], uObject, 0, 0, -1);
		setElementCollisionsEnabled(self.Fire[uObject], false);
		setElementAlpha(self.Fire[uObject], 0);
	end
end

-- ///////////////////////////////
-- ///// RemoveFire 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Holz:RemoveFire(uObject)
	if(isElement(self.Fire[uObject])) then
		destroyElement(self.Fire[uObject]);
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CO_Holz:Constructor(...)
	-- Klassenvariablen --
	self.Fire			= {}
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] CO_Holz: Constructor");
end

-- EVENT HANDLER --
