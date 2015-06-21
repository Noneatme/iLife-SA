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
-- Date: 31.12.2014
-- Time: 00:25
-- Project: MTA iLife
--
cScrollImageShader = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cScrollImageShader:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// render      		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cScrollImageShader:render()
	local distanz               = self.iY/self.iCount

	local multiplier            = 1/(1/(distanz/2)*self.iY)

	local prog1                 = getTickCount()-self.iScrollCount;

	if(prog1 > self.iTimeToScroll) then
		prog1 = self.iTimeToScroll;
	end

	local progress              = (getEasingValue((prog1)/self.iTimeToScroll, "InOutQuad")*2)

	local val = ((multiplier*2) * self.iCurCount) + (-multiplier+((multiplier)*progress))

--	dxDrawText(progress, 50, 500, 50, 50)
	if(isElement(self.uShader)) then
		dxSetShaderValue(self.uShader, "gUVPosition", 1, val );
		dxSetShaderValue(self.uShader, "gUVScale", 1, 1/(self.iCount) );

		if(getTickCount()-self.iTickCount > self.iTimeNextImage) then
			self.iTickCount         = getTickCount();
			self.iScrollCount       = getTickCount();
			self.iCurCount          = self.iCurCount+1;

			if(self.iCurCount == self.iCount+1) then
				self.iCurCount = 1;
			end
		end
	end
end


-- ///////////////////////////////
-- ///// init        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cScrollImageShader:init()
	dxSetShaderValue(self.uShader, "CUSTOMTEX0", dxCreateTexture(self.sImage))
--	dxSetShaderValue(self.uShader, "gTimeU", 0)
--	dxSetShaderValue(self.uShader, "gTimeV", 111555)
	engineApplyShaderToWorldTexture(self.uShader, self.sWorldTexture)
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cScrollImageShader:constructor(sWorldTexture, sImage, uObject, iX, iY, iCount)
	-- Klassenvariablen --
	self.iTimeToScroll      = 2500;
	self.iTimeNextImage     = 7000;

	self.sWorldTexture      = sWorldTexture;

	self.sImage             = sImage;
	self.uObject            = uObject;

	self.iX                 = iX;
	self.iY                 = iY;

	self.iCount             = iCount;

	self.iCurCount          = 1;

	self.iTickCount         = getTickCount();
	self.iScrollCount       = getTickCount();

	self.uShader            = dxCreateShader("res/shader/scrolltex.fx");

	-- Funktionen --
	self:init();

	self.m_funcRender       = function(...) self:render(...) end

	-- Events --
	addEventHandler("onClientRender", getRootElement(), self.m_funcRender)
end

-- EVENT HANDLER --
