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
-- ## Name: HudComponent_Handy.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HudComponent_Handy = {};
HudComponent_Handy.__index = HudComponent_Handy;


HudComponent_Handy.DEFAULT_WIDTH	= 712;
HudComponent_Handy.DEFAULT_HEIGHT	= 1074;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Handy:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:Render()
	
	local x, y = hud.components["handy"].sx, hud.components["handy"].sy;

	self.sx	= x;
	self.sy = y;

	local w2, h2 = hud.components["handy"].width*hud.components["handy"].zoom, hud.components["handy"].height*hud.components["handy"].zoom;

	local alpha = hud.components["handy"].alpha
	self.alpha = alpha;
	local zoom 	= hud.components["handy"].zoom
	self.zoom = zoom;

	-- UPDATE --

	self:Update();

	------------

	local rx, ry, rw, rh = x+(28*zoom), y+(100*zoom), 344*zoom, 620*zoom;
	local RT = self.renderTarget;

	-- Render Buttons


	local function drawAppImage()
		dxSetBlendMode("blend");
		if(self.currentApp) then
			local thatRenderTarget, thatRenderTarget2;

			local x, y, x2, y2 = 0, 0, 0, 0;

			local w, h = 0, 0

			if(self.currentApp) and (self.currentApp.Render) then
				self.currentApp:Render(self);	-- Render the F4CK! out of it

				w, h = self.currentApp.handyW, self.currentApp.handyH;
				local renderTarget = self.currentApp.renderTargets[self.currentApp.m_iSelectedPage][self.currentApp.flipped];
				if(isElement(renderTarget)) then
					thatRenderTarget = renderTarget;
				end

				-- SWIPE FUNCTION --
				if(self.m_bDragStarted) and (self.currentApp.bDragingEnabled) then
					local cx = (self.m_currentEndCX*self.gX)

					if(cx > 10 or cx < -10) then


						--x2 	= x-cx*2;

						local page		= self.currentApp.m_iSelectedPage;

						x 	= x+(cx*((w/500)/(hud.components[self.componentName].zoom*100)*100))

						if(cx > 0) then
							page = page-1;
						else
							page = page+1;
						end

						if(self.currentApp.renderTargets[page]) then
							thatRenderTarget2 	= self.currentApp.renderTargets[page][self.currentApp.flipped];
							local left			= 0;

							if(x > 0) then
								x2 = x-w
								if(x2 > 0) then
									x2 = 0;
								end

								left = math.abs(x-w)
							else
								x2 = x+w
								if(x2 < 0) then
									x2 = 0;
								end

								left = math.abs(x +w)
							end

							self.m_iSwipeLastLeft		= left;
							self.m_uSwipeRenderTarget	= thatRenderTarget2;
						else
							x = 0;
							x2 = 0;
						end
					end
				end

			end

			if(self.flipped) then
				w, h = self.currentApp.handyWF, self.currentApp.handyHF;
				RT = self.renderTargetF;
			end

			dxSetRenderTarget(RT)
			dxSetTextureEdge(RT, "border", tocolor(0, 0, 0, 0))

			if(isElement(thatRenderTarget)) then

				dxDrawImage(x, y, w, h, thatRenderTarget);
			end

			-- RENDER TARGET 2 --
			-- VERSUCH, einene GLATTEN UEBERGANG ZWISCHEN DEN WISCH SACHEN ZU ERHALTEN
			-- OFFIZIEL GESCHEITERT AM 12. JANURAR 2015 00:49 - FUCK THIS SHIT
			--[[
			if(self.m_bDragLeftout) and not(thatRenderTarget2) and (self.m_bSwitchSucess) then

				local function reset()
					self.m_bDragLeftout 		= false;
					self.m_uSwipeRenderTarget 	= nil;
					self.m_bSwitchSucess 		= false;
				end

				if(isElement(self.m_uSwipeRenderTarget)) then
					thatRenderTarget2 = self.m_uSwipeRenderTarget;

				--	outputChatBox(self.m_iSwipeLastLeft)

					local maxTime		= 1000;

					local ammount = getEasingValue((getTickCount()-self.m_iDragoutDick)/maxTime, "OutQuad")

					if(getTickCount()-self.m_iDragoutDick > maxTime) then
						reset();
					end
					if(x > 0 )then
						x2 = x-ammount*self.m_iSwipeLastLeft;
					else
						x2 = x2+ammount*self.m_iSwipeLastLeft;

					end
					outputChatBox(ammount..", "..x)
				end
			end]]
			if(isElement(thatRenderTarget2)) then

				dxDrawImage(x2, y2, w, h, thatRenderTarget2);
			end
			dxSetRenderTarget(nil);
		end
	end

	local curX, curY, curW, curH;

	-- Draw Utils
	-- Oben die Leiste
	local function drawUtils()

		dxSetRenderTarget(RT);
		dxSetBlendMode("add");

		-- IMMER ANGEZEIGT
		-- Oberers Background
		curX, curY, curW, curH = HudComponent_Handy.DEFAULT_WIDTH-110, 5, HudComponent_Handy.DEFAULT_WIDTH, 20;

		if not(self.flipped) then
			dxDrawRectangle(0, 0, HudComponent_Handy.DEFAULT_WIDTH, 50, tocolor(0, 0, 0, alpha/2));
		else
			dxDrawRectangle(0, 0, HudComponent_Handy.DEFAULT_WIDTH*2, 50, tocolor(0, 0, 0, alpha/2));

			curX = curX+curW-40;
		end

		-- INHALT --
		-- Time --
		local time = self:GetTime();
		dxDrawText(time, curX, curY, curW, curH, tocolor(255, 255, 255, alpha), 0.40, hud.fonts.droidsans)

		-- Battery --
		curX, curY, curW, curH = curX-65, curY+10, curW, curH;
		dxDrawImage(curX, curY, 48, 24, self.pfade.images.."util/battery-"..self.batteryStatus..".png", 0, 0, 0, tocolor(255, 255, 255, alpha));

		curX, curY, curW, curH = curX-105, curY-10, curW, curH;
		dxDrawText(self.batteryText, curX, curY, curW, curH, tocolor(255, 255, 255, alpha), 0.40, hud.fonts.droidsans)

		-- Empfang --
		curX, curY, curW, curH = curX-45, curY+7, curW, curH;
		dxDrawImage(curX, curY, 33, 27, self.pfade.images.."util/empfang-"..self.empfangStatus..".png", 0, 0, 0, tocolor(255, 255, 255, alpha));
		-- Empfang --
		--	end
		dxSetRenderTarget(nil);
	end

	local rotation = 0;
	if(self.flipped) then
		rotation = 90;
		-- Original: 498/2
		-- 342*2.1*zoom
		rx, ry, rw, rh = x-92*zoom, y+(498/2)*zoom, 620*zoom, (342*1.5)*zoom;
	end

	self.renderTargetPos = {rx, ry, rw, rh};

	drawAppImage();

	drawUtils();

	-- RenderTarget --

	dxDrawImage(rx, ry, rw, rh, RT, 0, 0, 0, tocolor(255, 255, 255, alpha));

	dxSetBlendMode("blend");
	if(self.currentApp) then
		self.currentApp:DrawButtons(self)
	end

	self:CheckMouseDragPosition()

	-- Image --
	dxDrawImage(x, y, w2, h2, hud.pfade.images.."component_handy/renderbackgrounds/1.png", rotation, 0, 0, tocolor(255, 255, 255, alpha))

	-- Browser

	self.history_back_button:Render(self);
	self.home_button:Render(self);
-- Text
--dxDrawText(self:GetTime(), x, y, x+w, y+h, tocolor(255, 255, 255, alpha), 0.3*hud.components["handy"].zoom, hud.fonts.handy, "center", "center")
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Handy:Toggle(bBool)
	local component_name = self.componentName;

	if (bBool == nil) then
		hud.components[component_name].enabled = toBinary(not (hud.components[component_name].enabled));
	else
		hud.components[component_name].enabled = toBinary(bBool);
	end


	hud.hudSaver:UpdateComponent(component_name, hud.components);
end

-- ///////////////////////////////
-- ///// DoToggleHandy 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:DoToggleHandy(sKey, bBool, bForceEnabled)
	if(hud.hudModifier) then
		if(hud.hudModifier.state == true) then
			return;
		end
	end
	local int = hud.components[self.componentName].enabled;

	if(bForceEnabled) then
		int = 0;
	end
	local bool;

	if(tonumber(int) == 0) then
		int = 1;
		bool = true;
		self:TriggerHandyStatus(true);
	else
		int = 0;
		bool = false;
		self:TriggerHandyStatus(false);
	end

	self:Toggle(bool);

	if(isPedInVehicle(localPlayer)) then
		showCursor(bool, false);
	else
		showCursor(bool);
	end
	self.inputActivated = bool;
end

-- ///////////////////////////////
-- ///// TriggerHandyStatus	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:TriggerHandyStatus(bBool)
	if(bBool) then
		if(self.currentApp) then
			self:OpenApp(self.currentApp);
		end
		addEventHandler("onClientClick", getRootElement(), self.m_funcClick)
	else
		if(self.currentApp) then
			self:CloseApp(self.currentApp);
		end
		removeEventHandler("onClientClick", getRootElement(), self.m_funcClick)
	end

	self.history_back_button:SetVisible(bBool);
	self.home_button:SetVisible(bBool);
end

-- ///////////////////////////////
-- ///// GenerateDefaultApps//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:GenerateDefaultApps()

	self:OpenApp(self:GetAppInstance(self.defaultApp));
end

-- ///////////////////////////////
-- ///// GenerateButtons	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:GenerateButtons()
	self.history_back_button	= CHandyApp_Button:New(50, HudComponent_Handy.DEFAULT_HEIGHT+150, 100, 100, "History_Back", {255, 255, 255}, "none", true)
	self.home_button			= CHandyApp_Button:New(500, HudComponent_Handy.DEFAULT_HEIGHT+150, 100, 100, "Home", {255, 255, 255}, "none", true)


	self.home_button:AddOnClickFunction(self.goHomeButtonFunc);
	self.history_back_button:AddOnClickFunction(self.goHistoryBackButtonFunc);

end

-- ///////////////////////////////
-- ///// DoGoHomeButton		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:DoGoHomeButton()
	if(self.bUnlocked) then
		self:OpenApp(self:GetAppInstance("app_homescreen"))
--	outputChatBox("Home");
	end
end

-- ///////////////////////////////
-- ///// DoGoHistoryBackButton	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:DoGoHistoryBackButton()
	if(self.bUnlocked) then
		outputChatBox("History Back");
	end
end

-- ///////////////////////////////
-- ///// OpenApp	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HudComponent_Handy:OpenApp(cApp, bTransition)

	if(self.currentApp) then
		self:CloseApp(self.currentApp, bTransition);
	end

	self.currentApp = cApp;

--	self.lastApp	= self.currentApp;

	cApp:OnOpen();

	outputDebugString("Opened App: "..cApp.sName);
end

-- ///////////////////////////////
-- ///// CloseApp	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:CloseApp(cApp, bTransition)
	self.lastApp	= self.currentApp;
	self.currentApp = self.apps[self.defaultApp];

	cApp:OnClose();

end

-- ///////////////////////////////
-- ///// GetAppInstance		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:GetAppInstance(sName)
	if(self.apps[sName]) then
		return self.apps[sName];
	else
		self:AddApp(new(self.tblAppNames[sName]));
		return self:GetAppInstance(sName);
	end
end

-- ///////////////////////////////
-- ///// AddApp				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:AddApp(cApp)
	if(self.apps[cApp.sName]) then
		outputDebugString("Warning: cApp exitsts, deleting object");

		if(cApp.Destructor) then
			cApp:Destructor();
		end
	else

		self.apps[cApp.sName] = cApp;

		outputConsole("Adding App to Handy: "..tostring(cApp.sName));
	end
end

-- ///////////////////////////////
-- ///// SetFlipped			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:SetFlipped(bBool)
	self.flipped			= bBool
end


-- ///////////////////////////////
-- ///// Update				//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function HudComponent_Handy:Update()
	-- Update Things
	self.currentApp.flipped	= self.flipped;
end

-- ///////////////////////////////
-- ///// SetInfoleisteEnabled/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:SetInfoleisteEnabled(bBool)
	self.drawInfoLeiste = bBool;
end

-- ///////////////////////////////
-- ///// GetTime	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:GetTime()
	local hour, min = getTime();

	if(hour < 10) then
		hour = "0"..hour
	end
	if(min < 10) then
		min = "0"..min
	end
	return hour..":"..min
end

-- ///////////////////////////////
-- ///// SetBatteryStatus	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:SetBatteryStatus(iStatus, sAmmount)
	assert(iStatus >= 0 and iStatus <= 5, "Bad Battery Status");

	self.batteryText	= sAmmount;
	self.batteryStatus	= iStatus;
end

-- ///////////////////////////////
-- ///// SetEmpfangStatus	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:SetEmpfangStatus(iStatus)
	assert(iStatus >= 0 and iStatus <= 4, "Bad Empfang Status");

	self.empfangStatus	= iStatus;
end

-- ///////////////////////////////
-- ///// setBrowser     	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:SetBrowser(uBrowser)
	self.m_uBrowser     = uBrowser;
end

-- ///////////////////////////////
-- /////CheckMouseDragPosition //
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:CheckMouseDragPosition()
	if(self.m_bDragStarted) then
		local cX, cY = getCursorPosition()

		self.m_currentEndCX    = cX-self.m_currentStartCX;
		self.m_currentEndCY    = cY-self.m_currentStartCX;


	--	outputChatBox(self.m_currentEndCX..", "..self.m_currentEndCY);
	end
end

-- ///////////////////////////////
-- ///// DoClickCheck        	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:DoClickCheck(button, state)
	local cX,cY = getCursorPosition ()
	local x, y, w, h = unpack(self.renderTargetPos)

	if(self:IsPointInRectangle(cX, cY, x, y, w, h)) then
		if(button == "left") and (state == "down") then
			self.m_bDragStarted = true;
			self.m_currentStartCX    = cX;
			self.m_currentStartCY    = cY;

			self.m_currentEndCX			= 0;
			self.m_currentEndCY			= 0;
		end
	end

	if(button == "left") and (state == "up") and (self.m_bDragStarted == true) then
		self.m_bDragStarted = false;
		self.m_bDragLeftout	= true;

		self.m_iDragoutDick	= getTickCount();

		self.m_currentStartCX    = 0;
		self.m_currentStartCY    = 0;


		if(self.currentApp) and (self.currentApp.bDragingEnabled) then

			if((self.m_currentEndCX*self.gX)*self.zoom >= w/5) then   -- Haelfte des Bildschrims
				if(self.currentApp.OnWoshRightCallback) then
					self.currentApp:OnWoshRightCallback()

					self.m_bSwitchSucess	= true;
				end
			end
			if((self.m_currentEndCX*self.gX)*self.zoom <= -(w/5)) then   -- Haelfte des Bildschrims
				if(self.currentApp.OnWoshLeftCallback) then
					self.currentApp:OnWoshLeftCallback()

					self.m_bSwitchSucess	= true;
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// IsPointOverRectangle/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:IsPointInRectangle(cX,cY,rX,rY,width,height)
	if isCursorShowing() then
		return ((cX*self.gX > rX) and (cX*self.gX < rX+width)) and ( (cY*self.gY > rY) and (cY*self.gY < rY+height))
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Handy:Constructor(...)
	-- Klassenvariablen

	self.currentApp		= nil;
	self.componentName	= "handy";
	self.inputActivated	= false;

	self.defaultApp		= "app_lockscreen";

	self.tblAppNames    =
	{
		-- SYSTEM APPS --
		["app_lockscreen"]          = HandyApp_LockScreen,
		["app_homescreen"]          = HandyApp_HomeScreen,

		-- BROWSER BASED --
		["app_browser_reddit"]      = HandyApp_Reddit,
		["app_chat"]                = HandyApp_Chat,

		-- HARDCODED APPS --
	}
	-- Apps --

	self.apps			= {};
	self.flipped		= false;
	self.drawInfoLeiste = true;

	self.pfade			= {}
	self.pfade.images	= "res/images/hud/component_handy/";

	self.batteryStatus	= 5;
	self.empfangStatus 	= 4;
	self.batteryText	= "100%";

	self.bUnlocked          = false;
	self.m_bCanBeClicked    = false;


	self.m_currentEndCX	= 0;
	self.m_currentEndCY	= 0;



	self.gX, self.gY        = guiGetScreenSize();

	self.renderTargetPos = {}

	self.handyW, self.handyH = HudComponent_Handy.DEFAULT_WIDTH, HudComponent_Handy.DEFAULT_HEIGHT;

	self.renderTarget	= dxCreateRenderTarget(self.handyW, self.handyH, true); -- Globales RenderTarget
	self.renderTargetF	= dxCreateRenderTarget(self.handyW*2, self.handyH, true); -- Globales RenderTarget

	self.m_funcClick    = function(...) self:DoClickCheck(...) end
	-- Functions --

	self.toggleHandyFunc 	= function(...) self:DoToggleHandy(...) end;
	self.goHomeButtonFunc	= function(...) self:DoGoHomeButton(...) end;
	self.goHistoryBackButtonFunc	= function(...) self:DoGoHistoryBackButton(...) end;



	--bindKey("1", "down", self.toggleHandyFunc)

	-- System --
	self:GenerateDefaultApps();
	self:GenerateButtons();

	bindKey(_Gsettings.keys.Handy, "down", function()

	--	self:DoToggleHandy();
	end)

	self:DoToggleHandy(false, false, false)
	self:DoToggleHandy(false, false, false)
--	self:DoToggleHandy();
--	self:DoToggleHandy();
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");
end

