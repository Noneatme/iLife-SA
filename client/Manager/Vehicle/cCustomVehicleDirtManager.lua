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
-- ## Name: CustomVehicleDirtManager			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomVehicleDirtManager = {};
CustomVehicleDirtManager.__index = CustomVehicleDirtManager;

addEvent("onClientDownloadFinnished", true)
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomVehicleDirtManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// UpdateDirtLevel	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleDirtManager:UpdateDirtLevel(uVehicle, iNumber)
	self.vehicleDirtLevel[uVehicle] = iNumber;

	for i = 0, 3, 1 do
		engineRemoveShaderFromWorldTexture(self.vehicleDirtShader[i], "vehiclegrunge256", uVehicle);
	end
	engineApplyShaderToWorldTexture(self.vehicleDirtShader[iNumber], "vehiclegrunge256", uVehicle);

end

-- ///////////////////////////////
-- /////  CheckVehicle		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleDirtManager:CheckVehicle(uVehicle, sData)
	if(getElementType(uVehicle) == "vehicle") then
		if(self.enabled == true) then
			if(sData) and (sData == "DirtLevel") or not(sData) then
				if(getElementData(uVehicle, "DirtLevel") and (tonumber(getElementData(uVehicle, "DirtLevel")) >= 0 ) and (tonumber(getElementData(uVehicle, "DirtLevel")) < 4) ) then
					local iNumber = tonumber(getElementData(uVehicle, "DirtLevel"));
					self:UpdateDirtLevel(uVehicle, iNumber)

				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Enable				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleDirtManager:Enable()
	self.enabled = true;
	self.vehicleDirtTextures	=
	{
		[0] = dxCreateTexture(self.pfade.textures.."0.png"),
		[1] = dxCreateTexture(self.pfade.textures.."1.png"),
		[2] = dxCreateTexture(self.pfade.textures.."2.png"),
		[3] = dxCreateTexture(self.pfade.textures.."3.png"),
	};

	self.vehicleDirtShader	=
	{
		[0] = dxCreateShader(self.pfade.shaders.."texture.fx"),
		[1] = dxCreateShader(self.pfade.shaders.."texture.fx"),
		[2] = dxCreateShader(self.pfade.shaders.."texture.fx"),
		[3] = dxCreateShader(self.pfade.shaders.."texture.fx"),

	};

	for i = 1, #self.vehicleDirtTextures, 1 do
		dxSetShaderValue(self.vehicleDirtShader[i], "Tex", self.vehicleDirtTextures[i]);
	end

	if(cConfiguration:getInstance():getConfig("lowrammode"):toboolean() == true) then
		self.enabled = false;
		outputConsole("Lowrammode activated, deactivated custom vehicle dirt");
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomVehicleDirtManager:Constructor(...)
	-- Klassenvariablen --
	self.vehicleDirtLevel		= {}

	self.pfade					= {};
	self.pfade.shaders			= "res/shader/"
	self.pfade.textures			= "res/textures/dirtlevel/";

	self.enabled				= false;


	-- Methoden --
	self.checkVehicleDirt		= function(...) self:CheckVehicle(source, ...) end;

	-- Events --
	addEventHandler("onClientElementStreamIn", getRootElement(), self.checkVehicleDirt)
	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function() self:Enable() end)

	addEventHandler("onClientElementDataChange", getRootElement(), self.checkVehicleDirt);
--logger:OutputInfo("[CALLING] CustomVehicleDirtManager: Constructor");
end

-- EVENT HANDLER --
