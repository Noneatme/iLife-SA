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
-- ## Name: FrameTextur.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

FrameTextur = {};
FrameTextur.__index = FrameTextur;

addEvent("onClientDownloadFinnished", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function FrameTextur:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ApplyShader 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FrameTextur:ApplyShader()
	self.uShader	= dxCreateShader(self.path.shader.."texture.fx");
	if not(DEFINE_DEBUG) then
		self.uTexture	= dxCreateTexture(self.path.textures..self.sTexturePath, "dxt5", true);
	else
		self.uTexture	= dxCreateTexture(self.path.textures..self.sTexturePath);
	end
	dxSetShaderValue(self.uShader, "Tex", self.uTexture);

	-- Apply Shader --
	engineApplyShaderToWorldTexture(self.uShader, self.sTextureName, self.uFrame);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FrameTextur:Constructor(uFrame, sTextureName, sTexturePath, bApplyNow)
	-- Klassenvariablen --
	self.uFrame				= uFrame;
	self.sTextureName		= sTextureName;
	self.sTexturePath		= sTexturePath;

	self.path				= {};
	self.path.shader		= "res/shader/";
	self.path.textures		= "res/textures/";

	-- Methoden --
	if not(bApplyNow) then
		addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()
			self:ApplyShader()
		end)
	else
		self:ApplyShader()
	end
	-- Events --

	--logger:OutputInfo("[CALLING] FrameTextur: Constructor");
	end

	-- EVENT HANDLER --
