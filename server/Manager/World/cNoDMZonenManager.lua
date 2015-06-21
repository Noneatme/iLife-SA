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
-- ## Name: NoDMZonenManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

NoDMZonenManager = {};
NoDMZonenManager.__index = NoDMZonenManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NoDMZonenManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadZonen	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:LoadZonen()
	local start = getTickCount()
	
	local zonen = 0;
	local result = CDatabase:getInstance():query("SELECT * FROM nodmzonen;")
	if(result) then
		for index, tbl in pairs(result) do
			zonen = zonen+1;
			self.noDMZonen[zonen] = NoDMZone:New(tbl["ID"], tbl["PosX"], tbl["PosY"], tbl["PosZ"], tbl["Length"], tbl["Width"], tbl["Height"], tbl["Name"]);
		end
	end
	outputServerLog("Es wurden "..zonen.." no-DM Zonen in "..(getTickCount() - start).." MS gefunden!")
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NoDMZonenManager:Constructor(...)
	-- Klassenvariablen --
	self.noDMZonen	= {}
	
	-- Methoden --
	self:LoadZonen();
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] NoDMZonenManager: Constructor");
end

-- EVENT HANDLER --
