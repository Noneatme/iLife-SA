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
-- Date: 08.02.2015
-- Time: 13:29
-- To change this template use File | Settings | File Templates.
--

cGamemodeMap_Derby2 = inherit(cGamemodeMap);


-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cGamemodeMap_Derby2:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cGamemodeMap_Derby2:constructor(...)
    self.m_iStandartVehicle = getVehicleModelFromName("Bloodring Banger");

    -- Funktionen --
    self.m_sSpawnType           = "vehicle";
    self.m_iInterior            = 0;
    self.m_tblGuestPosition     = {1409.1242675781, 2124.2719726563, 18.1015625}
    self.m_tblSpawnPositions    =
    {
        {1305.6, 2110.3999, 11, 0, 0, 270},
        {1305.7, 2115.3, 11, 0, 0, 270},
        {1305.9, 2120, 11, 0, 0, 270},
        {1306, 2124.8, 11, 0, 0, 270},
        {1306.1, 2129.3999, 11, 0, 0, 270},
        {1306.2, 2134.7, 11, 0, 0, 270},
        {1306.2, 2140.2, 11, 0, 0, 270},
        {1306.4, 2145.7, 11, 0, 0, 270},
        {1306.2, 2152, 11, 0, 0, 270},
        {1306.3, 2158, 11, 0, 0, 270},
        {1306.2, 2164.5, 11, 0, 0, 270},
        {1306.5, 2171.3, 11, 0, 0, 270},
        {1306.8, 2177.7, 11, 0, 0, 270},
        {1307, 2183.3, 11, 0, 0, 270},
        {1307.2, 2189.1001, 11, 0, 0, 270},
        {1389.4, 2108.3999, 11, 0, 0, 90},
        {1389.2, 2112.3, 11, 0, 0, 90},
        {1389.2, 2116.6001, 11, 0, 0, 90},
        {1389.4, 2121.7, 11, 0, 0, 90},
        {1389.4, 2126.5, 11, 0, 0, 90},
        {1389.4, 2131.8999, 11, 0, 0, 90},
        {1389.5, 2137.3, 11, 0, 0, 90},
        {1389.4, 2142.3, 11, 0, 0, 90},
        {1389.5, 2148, 11, 0, 0, 90},
        {1389.3, 2152.8, 11, 0, 0, 90},
        {1387, 2159, 11, 0, 0, 90},
        {1386.9, 2164.5, 11, 0, 0, 90},
        {1386.7, 2169.3, 11, 0, 0, 90},
        {1386.8, 2174.3, 11, 0, 0, 90},
        {1386.7, 2179.3, 11, 0, 0, 90},
        {1386.8, 2184.8999, 11, 0, 0, 90},
    }

    -- Events --
    cGamemodeMap.constructor(self, 1, 12, ...);


end

-- EVENT HANDLER --

