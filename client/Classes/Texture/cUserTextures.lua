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
-- ## Name: UserTextures.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

UserTextures = {};
UserTextures.__index = UserTextures;

addEvent("onClientDownloadFinnished", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function UserTextures:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ApplyTexture 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function UserTextures:ApplyTextures()

	for index, tex in pairs(self.userTex) do
		if(getPlayerFromName(index)) then
			local ped = getPlayerFromName(index);

			if not(self.userShaders[ped]) then

				if(fileExists(self.pfade.textures..index..".png")) then

					self.userShaders[ped] = dxCreateShader(self.pfade.shaders.."texture.fx", 0, 0, false, "ped");
					dxSetShaderValue(self.userShaders[ped], "Tex", dxCreateTexture(self.pfade.textures..index..".png"));
					engineApplyShaderToWorldTexture(self.userShaders[ped], tex, ped);
				end

				if(self.userExtraTex[index]) then
					-- Extra Texture
					for Name, Texturename in pairs(self.userExtraTex[index]) do
						local texName = index.."_"..Texturename
						if(fileExists(self.pfade.textures..texName..".png")) then
							self.userExtraShaders[ped] = dxCreateShader(self.pfade.shaders.."texture.fx", 0, 0, false, "ped");
							dxSetShaderValue(self.userExtraShaders[ped], "Tex", dxCreateTexture(self.pfade.textures..texName..".png"));
							engineApplyShaderToWorldTexture(self.userExtraShaders[ped], Texturename, ped);
						end

					end
				end

			else
				engineApplyShaderToWorldTexture(self.userShaders[ped], tex, ped);
			end
		end
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function UserTextures:Constructor(...)
	-- Klassenvariablen --
	self.userTex	=
	{
		["Gunvarrel"] 		= "omyst",
		["Dawi"] 			= "wmypizz",
		["Marcelsius"]  	= "hmycr",
		["Samy"]			= "fam1",
		["Johnny"]			= "dwmolc2",
		["TheFirstGamer"]	= "fam2",
	}

	self.userExtraTex =
	{
		["Marcelsius"] = {"neckcross"},
	}

	self.userShaders	= {}
	self.userExtraShaders = {}

	self.pfade			= {}
	self.pfade.shaders	= "res/shader/";
	self.pfade.textures	= "res/textures/peds/"

	-- Methoden --
	self.checkUserTex		= function(...) self:ApplyTextures(...) end;

	-- Events --
	addEventHandler("onClientPlayerSpawn", getRootElement(), self.checkUserTex)
	--logger:OutputInfo("[CALLING] UserTextures: Constructor");
	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), self.checkUserTex)
end

-- EVENT HANDLER --
