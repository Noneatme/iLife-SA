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

CHandyApp_Button = {};

local valid_hovermethods = 
{
	["size"] = true,
	["none"] = true,
}

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CHandyApp_Button:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
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
-- ///// OnClick	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:OnClick()
	for _, func in pairs(self.onClickFunctions) do
		if(func) then
			func();
		end
	end
end

-- ///////////////////////////////
-- ///// DoClick	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:DoClick(button, state)
	if(self.visible) then
		if(button == "left") and (state == "down") then
			if(self.canBeClicked) then
				self:OnClick();
			end
		end
	end
end

-- ///////////////////////////////
-- ///// OnEnter	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:OnEnter()
	if(self.visible) then
		for _, func in pairs(self.hoverStartFunctions) do
			if(func) then
				func();
			end
		end
		
		self.canBeClicked = true;
		self.currentTimestamp = getTickCount();
		
		self.hoverIn		= false;
		self.hoverOut		= true;
	end
end


-- ///////////////////////////////
-- ///// OnLeave	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:OnLeave()
	if(self.visible) then
		for _, func in pairs(self.hoverStopFunctions) do
			if(func) then
				func();
			end
		end
		
		self.canBeClicked = false;
		self.currentTimestamp = getTickCount();
		
		self.hoverIn		= true;
		self.hoverOut		= false;
	end
end

-- ///////////////////////////////
-- ///// AddHoverStartFunction///
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:AddHoverStartFunction(func)
	self.hoverStartFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStartFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:RemoveHoverStartFunction(func)
	self.hoverStartFunctions[func] = nil;
	table.remove(self.hoverStartFunctions, func);
end

-- ///////////////////////////////
-- ///// AddHoverStopFunction///
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:AddHoverStopFunction(func)
	self.hoverStopFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStopFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:RemoveHoverStopFunction(func)
	self.hoverStopFunctions[func] = nil;
	table.remove(self.hoverStopFunctions, func);
end

-- ///////////////////////////////
-- ///// AddOnClickFunction///
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:AddOnClickFunction(func)
	self.onClickFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStopFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:RemoveOnClickFunction(func)
	self.onClickFunctions[func] = nil;
	table.remove(self.onClickFunctions, func);
end

-- ///////////////////////////////
-- ///// SetVisible			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:SetVisible(bBool)
	self.visible 		= bBool;
	self.canBeClicked 	= false;
end

-- ///////////////////////////////
-- ///// RegisterCustomRenderEvent
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:RegisterCustomRenderEvent(func)
	self.customRenderFunc 	= func;	
	self.drawCustom			= true;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CHandyApp_Button:Constructor(iX, iY, iW, iH, sName, sImage, sHoverMethod, bCustom)
	-- Klassenvariablen
	self.sx, self.sy = guiGetScreenSize();
	
	self.iX = iX/2;
	self.iY = iY/2;
	self.iW = iW/2;
	self.iH = iH/2;
	
	self.hX	= 0;
	self.hY	= 0;
	self.hW = HudComponent_Handy.DEFAULT_WIDTH;
	self.hH	= HudComponent_Handy.DEFAULT_HEIGHT;
	
	self.sImage = sImage; -- Kann auch tocolor() sein

	self.zoom = 1;
	
	self.hover			= false;
	self.canBeClicked 	= false;
	
	self.visible		= true;
	self.drawCustom		= (bCustom) or false;
	
	if not(sHoverMethod) then
		sHoverMethod 	= "size"
	end
	
	assert(valid_hovermethods[sHoverMethod], "Bitte gueltige Hovermethode benutzen")
	
	self.sHoverMethod 	= sHoverMethod;
	
	self.currentTimestamp = getTickCount()
	self.hoverIn		= false;
	self.hoverOut		= false;
	
	self.hoverTime		= 100; -- 100 MS
	
	self.maxInterpolateSizeX = 10;
	self.maxInterpolateSizeY = 10;
	
	-- Apps --

	-- Functions --

	self.hoverStartFunctions 	= {}
	self.hoverStopFunctions		= {}
	self.onClickFunctions		= {}
	-- System --
	
	self.clickFunc				= function(...) self:DoClick(...) end;
	
	addEventHandler("onClientClick", getRootElement(), self.clickFunc)
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");
end

-- EVENT HANDLER --
