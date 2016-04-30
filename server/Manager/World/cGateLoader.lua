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
-- ## Name: GateLoader.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

GateLoader = {};
GateLoader.__index = GateLoader;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function GateLoader:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoadGates			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GateLoader:LoadGates()
	local result 	= CDatabase:getInstance():query("SELECT * FROM gates;");
	local start		= getTickCount();
	local count 	= 0;
	if(result) then
		for index, row in pairs(result) do
			local rowData = {}
			
			-- Load Rowdata
			for index, data in pairs(row) do
				if(tonumber(data) ~= nil) then
					rowData[index] = tonumber(data);
				else
					rowData[index] = data;
				end
			end
			
			count = count+1;
			self.gates[count] = Gate:New(rowData["GateID"], rowData["Name"], rowData["Modell"], rowData["MoveTime"], fromJSON(rowData["Position"]), fromJSON(rowData["ZielPosition"]), fromJSON(rowData["Misc"]), rowData["Permission"], rowData["Permissions"], rowData["OpenType"], rowData["Type"], rowData["InFunction"], rowData["OutFunction"])
			
		end
	end
	
	outputServerLog("Es wurden "..count.." Gates in "..getTickCount()-start.." MS gefunden!");
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function GateLoader:Constructor(...)
	-- Klassenvariablen --
	self.gates	= {}
	
	-- Methoden --
	self:LoadGates();
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] GateLoader: Constructor");
end

-- EVENT HANDLER --
