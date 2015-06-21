--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: CHandyApp_Button.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

CHandyApp_Button    = {};

CHandyApp_Button    = inherit(cHandyAppElement, CHandyApp_Button);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CHandyApp_Button:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetHandyDatas 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:GetHandyDatas(handy)
	if(handy) then
		self.zoom 	= handy.zoom;
		self.hX		= handy.renderTargetPos[1];
		self.hY		= handy.renderTargetPos[2];
		self.alpha	= handy.alpha
	end
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:Render(handy, rt)

	self:GetHandyDatas(handy);

--	dxDrawRectangle(self.iX, self.iY, self.iW, self.iH, tocolor(255,0, 0, 10));
	local curX, curY, curW, curH = ((self.hX)+self.iX*self.zoom), ((self.hY)+self.iY*self.zoom), (self.iW)*self.zoom, (self.iH)*self.zoom;
	
	-- Hover Interpolate --
	local Wadd, Hadd = self:GetInterpolateSize();
	
	curX = curX-Wadd/2
	curY = curY-Hadd/2
	curW = curW+Wadd
	curH = curH+Hadd
	
	if not(self.drawCustom) then
		if(type(self.sImage) == "table") then
			local r, g, b = unpack(self.sImage)
			dxDrawRectangle(curX, curY, curW, curH, tocolor(r, g, b, self.alpha));
		else
	
			dxDrawImage(curX, curY, curW, curH, self.sImage, 0, 0, 0, tocolor(255, 255, 255, self.alpha))

			if(self.bDrawName) then
				dxDrawText(self.sName, curX, curY-20, curW, curH)
			end
		end
	else
		if(self.customRenderFunc) then
			self.customRenderFunc();
		end
	end
	
	local cX,cY = getCursorPosition ()
	if(self:IsPointInRectangle(cX, cY, curX, curY, curW, curH)) then
		if(self.hover == false) then
			self.hover = true;
			self:OnEnter();
		end
	else
		if(self.hover == true) then
			self.hover = false;
			self:OnLeave();
		end
	end
end

-- ///////////////////////////////
-- ///// GetInterpolateSize	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:GetInterpolateSize()
	local x, y = 0, 0;
	if(self.sHoverMethod == "size") then
		if(self.hoverOut == true) then
			x, y = interpolateBetween(0, 0, 0, self.maxInterpolateSizeX, self.maxInterpolateSizeY, 0,  ((getTickCount()-self.currentTimestamp)/self.hoverTime), "InQuad")
		elseif(self.hoverIn == true) then
			x, y = interpolateBetween(self.maxInterpolateSizeX, self.maxInterpolateSizeY, 0, 0, 0, 0,  ((getTickCount()-self.currentTimestamp)/self.hoverTime), "OutQuad")
		end
	end
	
	return x, y;
end

-- ///////////////////////////////
-- ///// IsCursorOverRectangle////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:IsCursorOverRectangle(cX,cY,rX,rY,width,height)
	if isCursorShowing() then
		return ((cX*self.sx > rX) and (cX*self.sy < rX+width)) and ( (cY*self.sx > rY) and (cY*self.sx < rY+height))
	else
		return false
	end
end

-- ///////////////////////////////
-- ///// IsPointOverRectangle/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:IsPointInRectangle(cX,cY,rX,rY,width,height)
	if isCursorShowing() then
		return ((cX*self.sx > rX) and (cX*self.sx < rX+width)) and ( (cY*self.sy > rY) and (cY*self.sy < rY+height))
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:constructor(iX, iY, iW, iH, sName, sImage, sHoverMethod, bCustom, bDrawName)

	self.sImage = sImage; -- Kann auch tocolor() sein

	self.maxInterpolateSizeX = 10;
	self.maxInterpolateSizeY = 10;

	self.hoverIn		= false;
	self.hoverOut		= false;

	self.bDrawName      = (bDrawName or false);

	self.hoverTime		= 100; -- 100 MS

	cHandyAppElement.constructor(self, iX, iY, iW, iH, sName, sHoverMethod, bCustom)

	-- Klassenvariablen

end

-- EVENT HANDLER --
