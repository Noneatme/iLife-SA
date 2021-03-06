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
-- ## Name: FurnitureRemover.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

FurnitureRemover = {};
FurnitureRemover.__index = FurnitureRemover;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function FurnitureRemover:New(...)
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

function FurnitureRemover:Constructor(...)
	-- Klassenvariablen --
	self.furni	= {
		1763,
		2236,
		2315,
		1719,
		2318,
		2103,
		2346,
		2090,
		2095,
		2330,
		2301,
		2322,
		2346,
		2141,
		2341,
		2340,
		2132,
		2339,
		2133,
		2149,
		2028,
		2318,
		2108,
		2083,
		2523,
		2528,
		2522,
		2520,
		1705,
		1702,
		2312,
		2235,
		1794,
		2317,
		2101,
		2102,
		2117,
		1739,
		2239,
		2316,
		1762,
		1761,
		1818,
		2335,
		2334,
		2338,
		2170,
		2336,
		2147,
		2337,
		2158,
		1735,
		2330,
		1741,
		1793,
		2346,
		2095,
		2522,
		2528,
		2523,
		2520,
		2011,
		1724,
		1723,
		1819,
		2311,
		2129,
		2294,
		2304,
		2130,
		2127,
		2128,
		1743,
		2291,
		1817,
		2290,
		2140,
		2136,
		2303,
		2305,
		2135,
		2137,
		2138,
		1798,
		2306,
		2517,
		2739,
		2514,
		2516,
		2525,
		2527,
		2526,
		1728,
		1709,
		2099,
		2112,
		1720,
		2134,
		1744,
		2084,
		2302,
		15039,
		2298,
		2030,
		2868,
		2225,
		2811,
		2828,
		2227,
		1822,
		1742,
		2333,
		2331,
		15032,
		1764,
		15032,
		15036,
		15040,
		2126,
		1717,
		1818,
		1702,
		2121,
		2115,
		2131,
		15040,
		2108,
		2526,
		2523,
		15040,
		2241,
		1760,
		2235,
		2252,
		2240,
		2319,
		2109,
		2135,
		2305,
		2138,
		2249,
		2136,
		2138,
		2109,
		2297,
		2248,
		15026,
		1768,
		2023,
		15035,
		1822,
		2108,
		2078,
		2079,
		2203,
		2115,
		1714,
		2165,
		2165,
		2295,
		2096,
		2240,
		2194,
		2812,
		2822,
		2829,
		2830,
		2831,
		2832,
		2862,
		2863,
		2864,
		2865,
		2820,
		2819,
		2824,
		2826,
		2827,
		2852,
		2853,
		2854,
		2855,
		2868,
		2869,
		2870,
		2843,
		2844,
		2845,
		2846,
		2124,
		2029,
		2292,
		14719,
		14720,
		2140,
		1815,
		1747,
		2125,
		1703,
		2087,
		15037,
		2100,
		2069,
		2244,
		2088,
		2328,
		2249,
		2299,
		1816,
		2247,
		2109,
		2139,
		2224,
		2229,
		2104,
		2243,
		1755,
		2242,
		2123,
		2086,
		2106,
		2105,
		2107,
		2077,
		2070,
		15037,
		2867,
		2866,
		2861,
		2860,
		2859,
		2858,
		2857,
		2856,
		2840,
		2839,
		2838,
		2837,
		2823,
		2821,
		2814,
		2318,
		2315,
		1719,
		1759,
		1763,
		2236,
		2103,
		2346,
		2090,
		2095,
		2330,
	};


	-- Methoden --
	
	for i = 0, 20, 1 do
		for id, v in pairs(self.furni) do
			removeWorldModel(v, 9999, 0, 0, 0, i)
			removeWorldModel(v, 9999, 0, 0, 0, 13)
			removeWorldModel(v, 9999, 0, 0, 1000, 0)
		end
	end

	-- Events --

	--logger:OutputInfo("[CALLING] FurnitureRemover: Constructor");
end

-- EVENT HANDLER --
