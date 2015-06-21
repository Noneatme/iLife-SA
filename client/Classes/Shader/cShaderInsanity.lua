--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: Insanity Shader iLife	##
-- ## For MTA: San Andreas				##
-- ## Name: Insanity_Shader.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Insanity_Shader = {};
Insanity_Shader.__index = Insanity_Shader;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Insanity_Shader:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:PreRender()
	dxUpdateScreenSource(self.screenSource);  
			
	dxSetShaderValue(self.shader, "screenSource", self.screenSource)
	
	dxDrawImage(0, 0, self.sx, self.sy, self.shader)
end

-- ///////////////////////////////
-- ///// Reset	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Reset(bAlcohol)
	if(bAlcohol) then
		self.globalStrength		= 0;
		self.insanityStrength	= 0.0;
		self.iTime				= 0.01;
		self.iMore				= 0;

		setPedAnimation(localPlayer)
		toggleControl("jump", true)
	else
		self.globalStrength		= -1.0;
		self.insanityStrength	= 1.0;
		self.iTime				= 0.01;
		self.iMore				= 0;
	end

	dxSetShaderValue(self.shader, "insanityStrength", self.insanityStrength)
	dxSetShaderValue(self.shader, "globalStrength", self.globalStrength)

	dxSetShaderValue(self.shader, "wobblingStrength", 23)
	dxSetShaderValue(self.shader, "refractonStrength", 30.0)
	dxSetShaderValue(self.shader, "blurStrength", 0.05)
	dxSetShaderValue(self.shader, "timeA", 0.01)

end

-- ///////////////////////////////
-- ///// ApplyAlcohol	 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:ApplyAlcohol(iMore)
	iMore = (iMore or 0)
	if(self.iMore < 20) then
		self.globalStrength		= self.globalStrength-(iMore/4);
		self.insanityStrength	= self.insanityStrength+((iMore/4) or 0);
		self.iTime				= self.iTime+(iMore/25);

		self.iMore				= self.iMore + iMore;

		dxSetShaderValue(self.shader, "insanityStrength", self.insanityStrength)
		dxSetShaderValue(self.shader, "globalStrength", self.globalStrength)

		dxSetShaderValue(self.shader, "wobblingStrength", self.iMore*2)
		dxSetShaderValue(self.shader, "refractonStrength", self.iMore*30)
		dxSetShaderValue(self.shader, "blurStrength", 1.0+(self.iMore/10))
		dxSetShaderValue(self.shader, "timeA", self.iTime)

		if(iMore > 10) then
			setPedAnimation(localPlayer, "ped", "WALK_drunk", -1, true, true, true)
			toggleControl("jump", false)
		end
	end
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Render()
	dxSetShaderValue(self.shader, "insanityStrength", self.insanityStrength)
	dxSetShaderValue(self.shader, "globalStrength", self.globalStrength)


	if not(self.enabled) then
		local value = ((getTickCount()-self.startTick)/self.m_iFadeTime)

		if(value > 1) then
			removeEventHandler("onClientPreRender", getRootElement(), self.preRenderFunc)
			removeEventHandler("onClientRender", getRootElement(), self.renderFunc)
		end

		self.globalStrength = 0-(value);
	else
		local value = ((getTickCount()-self.startTick)/self.m_iFadeTime)

		if(value > 1) then
			value = 1
		end

		self.globalStrength = -1+(value);
	end


end

-- ///////////////////////////////
-- ///// Startup			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Startup()
	self.insanityStrength = 1.0;
	dxSetShaderValue(self.shader, "negative", dxCreateTexture("res/images/shader/insanity/negative.png"))
end
-- ///////////////////////////////
-- ///// Disable			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Disable()
	if(self.enabled) then
		self.enabled	= false;

		self.startTick	= getTickCount()
	end
end

-- ///////////////////////////////
-- ///// Enable				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Enable(bAlcohol)
	if not(bAlcohol) then
		self:Disable()
	end
	if not(self.enabled) then
		self.enabled	= true;

		self:Reset(bAlcohol)

		removeEventHandler("onClientPreRender", getRootElement(), self.preRenderFunc)
		removeEventHandler("onClientRender", getRootElement(), self.renderFunc)

		addEventHandler("onClientPreRender", getRootElement(), self.preRenderFunc)
		addEventHandler("onClientRender", getRootElement(), self.renderFunc)

		self.startTick	= getTickCount();

		if(bAlcohol) then
			self:ApplyAlcohol(1);
		end
	end

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Insanity_Shader:Constructor(...)
	self.sx, self.sy 		= guiGetScreenSize()
	-- Instanzen
	self.shader 			= dxCreateShader("res/shader/insanity.fx");
	self.screenSource 		= dxCreateScreenSource(self.sx, self.sy)
	self.enabled			= false;
	
	-- Funktionen
	
	self.preRenderFunc 		= function() self:PreRender() end;
	self.renderFunc 		= function() self:Render() end;
	self.m_iFadeTime		= 3000;

	self.globalStrength		= 0.0;
	self.insanityStrength	= 0.0;
	self.iTime				= 0.01;
	self.iMore				= 0;

	-- Events
	self:Startup()

	outputDebugString("[CALLING] Insanity_Shader: Constructor");
end

-- EVENT HANDLER --
