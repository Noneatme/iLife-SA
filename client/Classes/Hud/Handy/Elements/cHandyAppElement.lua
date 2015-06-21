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
-- Date: 05.01.2015
-- Time: 22:24
-- Project: MTA iLife
--

cHandyAppElement = {};

--[[

]]

local valid_hovermethods =
{
	["size"] = true,
	["none"] = true,
}

-- ///////////////////////////////
-- ///// OnClick	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:OnClick()
	if(self.enabled) then
		for _, func in pairs(self.onClickFunctions) do
			if(func) then
				func();
			end
		end
	end
end

-- ///////////////////////////////
-- ///// DoClick	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:DoClick(button, state)
	if(button == "left") and (state == "down") then
		if(self.canBeClicked) then
			self:OnClick();
		end
	end
end

-- ///////////////////////////////
-- ///// OnEnter	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:OnEnter()
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

function cHandyAppElement:OnLeave()
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

function cHandyAppElement:AddHoverStartFunction(func)
	self.hoverStartFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStartFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:RemoveHoverStartFunction(func)
	self.hoverStartFunctions[func] = nil;
	table.remove(self.hoverStartFunctions, func);
end

-- ///////////////////////////////
-- ///// AddHoverStopFunction///
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:AddHoverStopFunction(func)
	self.hoverStopFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStopFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:RemoveHoverStopFunction(func)
	self.hoverStopFunctions[func] = nil;
	table.remove(self.hoverStopFunctions, func);
end

-- ///////////////////////////////
-- ///// AddOnClickFunction///
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:AddOnClickFunction(func)
	self.onClickFunctions[func] = func;
end

-- ///////////////////////////////
-- ///// RemoveHoverStopFunction/
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:RemoveOnClickFunction(func)
	self.onClickFunctions[func] = nil;
	table.remove(self.onClickFunctions, func);
end

-- ///////////////////////////////
-- ///// SetVisible			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:SetVisible(bBool)
	self.visible 		= bBool;
	self.canBeClicked 	= false;


end

-- ///////////////////////////////
-- ///// SetEnabled			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:SetEnabled(bBool)
	self.enabled 		= bBool;
end

-- ///////////////////////////////
-- ///// RegisterCustomRenderEvent
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:RegisterCustomRenderEvent(func)
	self.customRenderFunc 	= func;
	self.drawCustom			= true;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHandyAppElement:constructor(iX, iY, iW, iH, sName, sHoverMethod, bCustom)
	-- Klassenvariablen --
	
	self.hover			= false;
	self.canBeClicked 	= false;

	self.visible		= true;
	self.drawCustom		= (bCustom) or false;

	self.enabled        = true;

	self.sName          = sName;

	if not(sHoverMethod) then
		sHoverMethod 	= "size"
	end

	assert(valid_hovermethods[sHoverMethod], "Bitte gueltige Hovermethode benutzen")


	self.sHoverMethod 	= sHoverMethod;

	self.currentTimestamp = getTickCount()

	self.zoom = 1;


	self.sx, self.sy = guiGetScreenSize();

	self.iX = iX/2;
	self.iY = iY/2;
	self.iW = iW/2;
	self.iH = iH/2;

	self.hX	= 0;
	self.hY	= 0;
	self.hW = HudComponent_Handy.DEFAULT_WIDTH;
	self.hH	= HudComponent_Handy.DEFAULT_HEIGHT;


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

