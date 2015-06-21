--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA Slotmachine Resource	##
-- ## Name: Texture_Importer.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Texture_Importer = {};
Texture_Importer.__index = Texture_Importer;

addEvent("onSlotmachinesGet", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Texture_Importer:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ImportSlotmachine	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Texture_Importer:ImportSlotmachine(slotMachines)
	local shader = dxCreateShader("res/shader/texture.fx");
	dxSetShaderValue(shader, "Tex", dxCreateTexture("res/textures/slotmachine/slot5_ind_1.jpg"));
	engineApplyShaderToWorldTexture(shader, "slot5_ind");
		
	for index, slotmachine in pairs(slotMachines) do
		local shader = dxCreateShader("res/shader/texture.fx");
		dxSetShaderValue(shader, "Tex", dxCreateTexture("res/textures/slotmachine/slot5_ind_"..math.random(1, self.textures)..".jpg"));
		
		engineApplyShaderToWorldTexture(shader, "slot5_ind", slotmachine);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Texture_Importer:Constructor(...)
	self.importFunc = function(...) self:ImportSlotmachine(...) end;

	self.textures = 3;				-- Define the max custom textures of the slot machine (file in the meta.xml)

	addEventHandler("onSlotmachinesGet", getLocalPlayer(), self.importFunc)
	
	--outputDebugString("[CALLING] Texture_Importer: Constructor");
end

-- EVENT HANDLER --


