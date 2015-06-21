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
-- Date: 26.12.2014
-- Time: 22:09
-- Project: MTA iLife
--

cFireworkChassic_Abschussrohr = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFireworkChassic_Abschussrohr:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// launch      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkChassic_Abschussrohr:launch()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkChassic_Abschussrohr:constructor(iX, iY, iZ)
	-- Klassenvariablen --
	self.m_uAbschuss        = createObject(3675, iX, iY+0.25, iZ-2, 0, 180, 0);
	setObjectScale(self.m_uAbschuss, 0.3);
	setElementCollisionsEnabled(self.m_uAbschuss, false);
	
	-- Funktionen --
	
	
	-- Events --
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFireworkChassic_Abschussrohr:destructor(iX, iY, iZ)
	destroyElement(self.m_uAbschuss);

end
-- EVENT HANDLER --

