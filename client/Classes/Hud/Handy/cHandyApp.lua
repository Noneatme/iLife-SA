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
-- ## Name: HandyApp.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --


HandyApp = {};
HandyApp.__index = HandyApp;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HandyApp:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// BeginDrawing		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:BeginDrawing(iPage, bBool, sMethod)
	if not(self.currentlyDrawing) then
		self.currentlyDrawing 	= true;
		self.drawingRotation	= bBool; -- False or nil: Normal, true: flipped
		self.currentPage		= iPage;

		dxSetRenderTarget(self:GetCurrentRenderTarget(), true);
	end
	
	self.oHandy					= hud.hudObjects["handy"];
	
	if(sMethod) then
		dxSetBlendMode(sMethod);
	end
end

-- ///////////////////////////////
-- ///// GetCurrentRenderTarget///
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:GetCurrentRenderTarget()
	return self.renderTargets[self.currentPage][self.flipped];
end

-- ///////////////////////////////
-- ///// EndDrawing			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:EndDrawing()
	if(self.currentlyDrawing == true) then
		self.currentlyDrawing = false;
		dxSetRenderTarget();
	end
	dxSetBlendMode("blend");
end

-- ///////////////////////////////
-- ///// DrawString			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:DrawText(...)
	if(self.currentlyDrawing == true) then
		dxDrawText(...);
	end
end

-- ///////////////////////////////
-- ///// DrawImage			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:DrawImage(...)
	if(self.currentlyDrawing == true) then
		dxDrawImage(...);
	end
end

-- ///////////////////////////////
-- ///// DrawRectangle		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:DrawRectangle(...)
	if(self.currentlyDrawing == true) then
		dxDrawRectangle(...);
	end
end

-- ///////////////////////////////
-- ///// DrawBackgroundImage//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:DrawBackgroundImage()
	if(self.currentlyDrawing == true) then
		local w, h;
		if(self.flipped == false) then
			w, h = self.handyW, self.handyH;
		else
			w, h = self.handyWF, self.handyHF;
		end

		local file = self.pfade.handyimages..self.app_settings["background-image"];
		if(fileExists(self.pfade.handyimages..self.app_settings["background-image-custom"])) then
			file = self.pfade.handyimages..self.app_settings["background-image-custom"]
		end
		
		self:DrawImage(0, 0, w, h, file, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end

-- ///////////////////////////////
-- ///// DrawButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:DrawButtons(handy)
	if(self.currentlyDrawing == true or isCursorShowing()) then
		if(self.appButtons[self.m_iSelectedPage]) and (self.appButtons[self.m_iSelectedPage][self.flipped]) then
			for button, _ in pairs(self.appButtons[self.m_iSelectedPage][self.flipped]) do
				if(button.Render) then
					button:Render(handy);
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// GetAllButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:GetAllButtons()
	local buttons = {}
	for i = 1, self.iPages, 1 do
		for button, _ in pairs(self:GetPageButtons(i)) do
			buttons[button] = button;
		end
	end
	return buttons;
end

-- ///////////////////////////////
-- ///// GetPageButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:GetPageButtons(iPage)
	local tbl = {}
	if(self.appButtons[iPage]) then
		for boolean, tbl2 in pairs(self.appButtons[iPage]) do
			if(tbl2) then
				for button, _ in pairs(tbl2) do
					tbl[button] = button;
				end
			end
		end
	end
	return tbl;
end

-- ///////////////////////////////
-- ///// CreateButton		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:CreateButton(iPage, bFlipped, iX, iY, iW, iH, sName, sImage)
	if not(self.appButtons[iPage]) then
		self.appButtons[iPage] = {};
		
		if not(self.appButtons[iPage][bFlipped]) then
			self.appButtons[iPage][bFlipped] = {}
		end
	end
	
	local button = new(CHandyApp_Button, iX, iY, iW, iH, sName, sImage);
	self.appButtons[iPage][bFlipped][button] = button;
	return button;
end

-- ///////////////////////////////
-- ///// HideButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:HideButtons(iPage)
	for index, button in pairs(self:GetPageButtons(iPage)) do
		button:SetVisible(false)
	end
end

-- ///////////////////////////////
-- ///// HideAllButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:HideAllButtons()
	for i = 1, self.iPages, 1 do
		self:HideButtons(i)
	end
end

-- ///////////////////////////////
-- ///// ShowButtons		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:ShowButtons(iPage)
	for index, button in pairs(self:GetPageButtons(iPage)) do
		button:SetVisible(true);
	end
end

-- ///////////////////////////////
-- ///// OpenPage			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:OpenPage(iPage)
	if(self.m_iSelectedPage ~= iPage) then
		assert(iPage >= 1 and iPage <= self.iPages, "Unknow Page");
		self:HideButtons(self.m_iSelectedPage);
		self:ShowButtons(iPage);

		self.m_iSelectedPage = iPage;
	end
end

-- ///////////////////////////////
-- ///// Open				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:Open(...)
	if not(self.bOpened) then

		self:Load();
		self.bOpened = true;
		if(self.DoOpenCallback) then
			self:DoOpenCallback();
		end
		
		self:ShowButtons(self.m_iSelectedPage)
	end
end

-- ///////////////////////////////
-- ///// Close				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:Close(...)
	if(self.bOpened == true) then
		self:Save();
		self.bOpened = false;
		if(self.DoCloseCallback) then
			self:DoCloseCallback();
		end
		self:HideAllButtons(self.m_iSelectedPage)

	end
end

-- ///////////////////////////////
-- ///// CanDraw			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:CanDraw(...)
	if(self.bOpened == false or self.currentlyDrawing == false) then
		return false;
	end
end

-- ///////////////////////////////
-- ///// SetAppSetting		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:SetAppSetting(sSetting, sValue)
	-- Funktioniert irgendwie scheisse, muss nochmal verbessert werden. Geht aber noch. ---

	self.settings[sSetting] = sValue;
end

-- ///////////////////////////////
-- ///// GetAppSetting		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:GetAppSetting(sSetting)
	return (self.settings[sSetting] or false);
end

-- ///////////////////////////////
-- ///// Save				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:Save()
	local file = EasyIni:LoadFile(self.app_settings["config-file"]);

	for settingname, value in pairs(self.settings) do
		file:Set("settings", settingname, tostring(value));
	end

	file:Save()
end

-- ///////////////////////////////
-- ///// Load				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:Load()
	local file = EasyIni:LoadFile(self.app_settings["config-file"]);
	if not(file:GetNamesFromSelection("settings")) then
		file:Set("settings", "placeholder", "baum")
		file:Save()
	end
	for settingname, value in pairs(file:GetNamesFromSelection("settings")) do
		self:SetAppSetting(settingname, value);
	end
end


-- ///////////////////////////////
-- ///// SetBackgroundImage	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:SetBackgroundImage(sString)
	if(fileExists(sString)) then
		self:SetAppSetting("background-image", self.pfade.images..sString);
		self:Save();
	end
end

-- ///////////////////////////////
-- ///// GetHandyAlpha 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:GetHandyAlpha()
	return hud.hudObjects["handy"].alpha;
end

---------------
-- CALLBACKS --
---------------

-- ///////////////////////////////
-- ///// OnOpen		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:OnOpen()
	self:Open()
end

-- ///////////////////////////////
-- ///// OnClose		 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:OnClose()
	self:Close();
end

-- ///////////////////////////////
-- ///// OnWoshLeftCallback //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:OnWoshLeftCallback()
	if(self.OnWoshLeft) then
		self:OnWoshLeft();
	end

	if(self.m_bPageSwitchingEnabled) then
		if(self.m_iSelectedPage < self.iPages) then
			self:OpenPage(self.m_iSelectedPage+1)
		end
	end
end
-- ///////////////////////////////
-- ///// OnWoshRightCallback //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:OnWoshRightCallback()
	if(self.OnWoshRight) then
		self:OnWoshRight();
	end

	if(self.m_bPageSwitchingEnabled) then

		if(self.m_iSelectedPage > 1) then
			self:OpenPage(self.m_iSelectedPage-1)
		end
	end
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HandyApp:constructor(sName, sAuthor, iPages, sVersion, sDisplayName, handyW, handyH, bDraging)
	-- Klassenvariablen
	self.handyW, self.handyH 	= handyW, handyH
	self.handyWF, self.handyHF 	= handyW*2, handyH/1.5	-- Flipped
	
	self.sName					= sName;
	self.sAuthor				= sAuthor;
	self.iPages					= iPages;
	self.sVersion				= sVersion;
	self.sDisplayName			= sDisplayName;

	self.bOpened				= false;
	self.bDragingEnabled        = (bDraging or false);
	self.m_bPageSwitchingEnabled = false;

	self.m_iSelectedPage		= 1;
	self.m_iSelectedSwitchToPage = 1;


	self.appButtons				= {};
	
	
	self.pfade					= {};
	self.pfade.images			= "res/images/hud/component_handy/apps/"..sName.."/";
	self.pfade.handyimages		= "res/images/hud/component_handy/";
	self.pfade.iconimages		= self.pfade.handyimages.."icons/";
	self.pfade.settings			= "savedfiles/appsettings/";
	
	
	self.app_settings				=
	{
		["background-image"] 	= "background/homescreen-1.jpg",
		["config-file"]			= self.pfade.settings..sName..".cfg",
		["background-image-custom"] = "background/homescreen-custom.jpg",
	};

	self.settings               = {}            -- USER SETTINGS!
	
	self.handyName				= "handy";
	self.currentPage			= 1;
	self.flipped				= false;


	self.renderTargets			= {}

	self.currentlyDrawing		= false;
	
	for i = 1, iPages, 1 do
		self.renderTargets[i] = {}
		for bool = 1, 2, 1 do
			local boolean = false;
			local x, y = self.handyW, self.handyH;
			
			if(bool == 2) then
				boolean = true;
				x, y = self.handyWF, self.handyHF;
			end
			self.renderTargets[i][boolean] 	= dxCreateRenderTarget(x, y, true); -- Globales RenderTarget

			-- Ueberpruefung, denn es sind grosse Rendertargets fuer jede Page --
			if not(self.renderTargets[i][boolean]) then
				outputChatBox("[ERROR] Out of Video Memory!", 255, 0, 0)
			end
		end
		
	end

	outputConsole("Added new instance, App: "..self.sName);
-- 	outputDebugString("[CALLING] HudComponent_Clock: Constructor");
end

---------------
-- Overrides --
---------------
_dxSetRenderTarget = dxSetRenderTarget

function dxSetRenderTarget(target, bool)
	current_rendertarget = target;
	--outputChatBox(debug.traceback(1))
	return _dxSetRenderTarget(target, bool)
end


--
-- EVENT HANDLER --
