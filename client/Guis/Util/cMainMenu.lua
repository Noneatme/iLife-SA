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
-- ## Name: MainMenu.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

MainMenu = inherit(cSingleton);

--[[

]]



-- ///////////////////////////////
-- ///// RenderShader 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:RenderShader()
	if(self.shaderEnabled == true) then
		dxSetShaderValue(self.shader, "BlurAmount", 0.0008+(self.endAlpha/10000));
		dxSetShaderValue(self.shader, "Angle", 180)

		dxSetRenderTarget();
		dxUpdateScreenSource(self.screenSource);
		dxDrawImage( 0, 0, self.sx+100, self.sy+100, self.shader);
	end
end

-- ///////////////////////////////
-- ///// RenderMainMenu		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:RenderMainMenu()
	if(self.mainMenuEnabled == true) then

		-- Logo --
		local x, y, sx, sy
		-- TICK --
		if(getTickCount()-self.startTick > 6000) then
			if not(self.logoTick) then
				self.logoTick	= getTickCount();

				self.logoX				= self.logoX+self.logoSizeX/2;
				self.logoY				= self.logoY+self.logoSizeY/2;

				self.logoUmrissX		= self.logoUmrissX+self.logoUmrissSizeX/2;
				self.logoUmrissY		= self.logoUmrissY+self.logoUmrissSizeY/2;

			end
			-- Logo --
			x, y = interpolateBetween(self.logoX, self.logoY, 0, self.logoX, self.logoY-(350/(self.aesx+self.aesy)*(self.sx+self.sy)), 0, ((getTickCount()-self.logoTick)/2000), "InOutQuad")
			sx, sy = interpolateBetween(self.logoSizeX, self.logoSizeY, 0, self.logoSizeX/2, self.logoSizeY/2, 0, ((getTickCount()-self.logoTick)/2000), "InOutQuad")

			x = x-sx/2
			y = y-sy/2

			x2, y2 = interpolateBetween(self.logoUmrissX, self.logoUmrissY, 0, self.logoUmrissX, self.logoUmrissY-(350/(self.aesx+self.aesy)*(self.sx+self.sy)), 0, ((getTickCount()-self.logoTick)/2000), "InOutQuad")
			sx2, sy2 = interpolateBetween(self.logoUmrissSizeX, self.logoUmrissSizeY, 0, self.logoUmrissSizeX/2, self.logoUmrissSizeY/2, 0, ((getTickCount()-self.logoTick)/2000), "InOutQuad")

			x2 = x2-sx2/2
			y2 = y2-sy2/2
		else
			x, y = self.logoX, self.logoY;
			sx, sy = self.logoSizeX, self.logoSizeY;

			x2, y2 = self.logoUmrissX, self.logoUmrissY;
			sx2, sy2 = self.logoUmrissSizeX, self.logoUmrissSizeY;

		end

		-- Logo Rendern --
		dxDrawImage(x2, y2, sx2, sy2, self.logoUmrissPNG, getTickCount()/15);
		dxDrawImage(x, y, sx, sy, self.logoPNG);

		--Kamera smooth animieren
		local x,y,z,lx,ly,lz = getCameraMatrix()
		local xx = interpolateBetween (-0.05, 0, 0, 0.05, 0, 0, (getTickCount()%60000)/30000, "SineCurve")

		setCameraMatrix(x+xx,y,z,lx,ly,lz)

		-- Menu Items --
		if(getTickCount()-self.startTick > 8000) then

			if not(self.menuTick) then
				self.menuTick	= getTickCount();

			end
			local rectangle_interpolate	=
			{
				{interpolateBetween(-455/self.aesx*self.sx, 256/self.aesy*self.sy, 0, 0, 256/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween((985+455)/self.aesx*self.sx, 256/self.aesy*self.sy, 0, 985/self.aesx*self.sx, 256/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween(-455/self.aesx*self.sx, 509/self.aesy*self.sy, 0, 0, 509/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween((985+455)/self.aesx*self.sx, 509/self.aesy*self.sy, 0, 985/self.aesx*self.sx, 509/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},

			}

			local image_interpolate		=
			{
				{interpolateBetween(-100/self.aesx*self.sx, 513/self.aesy*self.sy, 0, 10/self.aesx*self.sx, 513/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween((1440+100)/self.aesx*self.sx, 513/self.aesy*self.sy, 0, (1440-110)/self.aesx*self.sx, 513/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween(-100/self.aesx*self.sx, 260/self.aesy*self.sy, 0, 10/self.aesx*self.sx, 260/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},
				{interpolateBetween((1440+100)/self.aesx*self.sx, 260/self.aesy*self.sy, 0, (1440-110)/self.aesx*self.sx, 260/self.aesy*self.sy, 0, ((getTickCount()-self.menuTick)/2000), "OutQuad")},

			}

			local images	=
			{
				[1] = "icon_news",
				[2] = "icon_exit",
				[3] = "icon_login",
				[4] = "icon_options",
			}

			for i = 1, 4, 1 do
				local color	= tocolor(0, 0, 0, 97);
				if(self.hover[i] == true) then
					color = tocolor(0, 0, 0, 150);
				end
				dxDrawRectangle(rectangle_interpolate[i][1], rectangle_interpolate[i][2], 455/self.aesx*self.sx, 108/self.aesy*self.sy, color, false)
			end

			-- In einer anderen Schleife zeichen, da es sonst von dem Rechteck uebermalt wird

			for i = 1, 4, 1 do
				dxDrawImage(image_interpolate[i][1], image_interpolate[i][2], 100/self.aesx*self.sx, 100/self.aesy*self.sy, self.pfade.images..images[i]..".png");
			end

			dxDrawText(getLocalizationString("GUI_mainmenu_button_login"), 127/self.aesx*self.sx, 267/self.aesy*self.sy, 446/self.aesx*self.sx, 356/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText(getLocalizationString("GUI_mainmenu_button_impressum"), 121/self.aesx*self.sx, 519/self.aesy*self.sy, 440/self.aesx*self.sx, 608/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText(getLocalizationString("GUI_mainmenu_button_intro"), 992/self.aesx*self.sx, 265/self.aesy*self.sy, 1311/self.aesx*self.sx, 354/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText(getLocalizationString("GUI_mainmenu_button_gotoirace"), 992/self.aesx*self.sx, 517/self.aesy*self.sy, 1311/self.aesx*self.sx, 606/self.aesy*self.sy, tocolor(255, 255, 255, self.alpha), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "pricedown", "center", "center", false, false, true, false, false)


			local tick = (getTickCount()-self.menuTick);
			if(tick > 2000) then
				tick = 2000
			end
			self.alpha		= 255/2000*tick;
			--[[

			dxDrawText("Einloggen", 127, 267, 446, 356, tocolor(255, 255, 255, 255), 1, "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText("News", 121, 519, 440, 608, tocolor(255, 255, 255, 255), 1, "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText("Optionen", 992, 265, 1311, 354, tocolor(255, 255, 255, 255), 1, "pricedown", "center", "center", false, false, true, false, false)
			dxDrawText("Verlassen", 992, 517, 1311, 606, tocolor(255, 255, 255, 255), 1, "pricedown", "center", "center", false, false, true, false, false)
			--]]

			-- Gui --
			if(getTickCount()-self.startTick > 5000) then
				if not(self.guiCreated) then
					self:BuildGui();
				end
			end
		end

		if(self.fadeIn == true) then
			local tick = (getTickCount()-self.endTick);
			if(tick > 1000) then
				tick = 1000
			end
			self.endAlpha		= 255/1000*tick;

			dxDrawRectangle(0, 0, self.sx, self.sy, tocolor(0, 0, 0, self.endAlpha), true)

		end

		setSoundVolume(self.loginSound, self.musicVolume);

		if(self.music == false) then
			if(self.musicVolume > 0) then
				self.musicVolume = self.musicVolume-0.01;
			end
		else
			if(self.musicVolume < 1) then
				self.musicVolume = self.musicVolume+0.01;
			end
		end

		if(self.fadeIn ~= true) then
			showCursor(true);
		end
	end
end

-- ///////////////////////////////
-- ///// DestroyGUI	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:DestroyGui()
	for index, g in pairs(self.guiEle) do
		if(isElement(g)) then
			destroyElement(g)
		end
	end
end

-- ///////////////////////////////
-- ///// BuildGUI	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:BuildGui()
	if not(self.guiCreated) then
		self.guiEle		= {};

		-- Buttons --
		self.guiEle["btn_1"] = guiCreateButton(0, 256/self.aesy*self.sy, 455/self.aesx*self.sx, 108/self.aesy*self.sy, "-", false);
		self.guiEle["btn_2"] = guiCreateButton(985/self.aesx*self.sx, 256/self.aesy*self.sy, 455/self.aesx*self.sx, 108/self.aesy*self.sy, "-", false);
		self.guiEle["btn_3"] = guiCreateButton(0, 509/self.aesy*self.sy, 455/self.aesx*self.sx, 108/self.aesy*self.sy, "-", false);
		self.guiEle["btn_4"] = guiCreateButton(985/self.aesx*self.sx, 509/self.aesy*self.sy, 455/self.aesx*self.sx, 108/self.aesy*self.sy, "-", false);


		--[[

		dxDrawRectangle(0, 256, 455, 108, tocolor(0, 0, 0, 97), true)
		dxDrawRectangle(750, 256, 455, 108, tocolor(0, 0, 0, 97), true)
		dxDrawRectangle(0, 509, 455, 108, tocolor(0, 0, 0, 97), true)
		dxDrawRectangle(754, 509, 455, 108, tocolor(0, 0, 0, 97), true)

		--]]

		for i = 1, 4, 1 do
			addEventHandler("onClientMouseEnter", self.guiEle["btn_"..i], function()
				self.hover[i] = true;
				playSound(self.pfade.sounds.."mainmenu/menu_focus.mp3", false)
			end)
			addEventHandler("onClientMouseLeave", self.guiEle["btn_"..i], function()
				self.hover[i] = false;
			end)


			guiSetAlpha(self.guiEle["btn_"..i], 0)
		end

		addEventHandler("onClientGUIClick", self.guiEle["btn_1"], self.buttonLoginClickFunc); -- Einloggen
		addEventHandler("onClientGUIClick", self.guiEle["btn_2"], self.buttonOptionClickFunc);	-- Optionen
		addEventHandler("onClientGUIClick", self.guiEle["btn_3"], self.buttonNewsClickFunc);	-- News
		addEventHandler("onClientGUIClick", self.guiEle["btn_4"], self.buttonLeaveClickFunc);	-- Verlassen

		self.guiCreated = true;
	end
end

-- ///////////////////////////////
-- ///// BuildShaders 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:BuildShaders()
	self.shader			= dxCreateShader(self.pfade.shaders.."motion.fx");
	self.screenSource	= dxCreateScreenSource(self.sx+100, self.sy+100);

	if(self.shader and self.screenSource) then
		dxSetShaderValue(self.shader, "ScreenTexture", self.screenSource);

		self.shaderEnabled = true;
	else
		outputConsole("Konnte MainMenu Shader nicht erstellen!");
	end
end

-- ///////////////////////////////
-- ///// Start				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:Start(tblSounds, sKey)
	local login_sounds = tblSounds;

	for index, s in pairs(login_sounds) do
		login_sounds[index] = teaDecode(s, sKey);
	end

	self.loginSound			= playSound(login_sounds[math.random(1, #login_sounds)], true);

	self:BuildShaders()

	self.randomCamPosID		= math.random(1, #self.randomCamPos);

	setCameraMatrix(unpack(self.randomCamPos[self.randomCamPosID]));

	showChat(false)

	self.mainMenuEnabled	= true;

	showCursor(true);

	hud:Toggle(false);
end

-- ///////////////////////////////
-- ///// ShowNewsPage		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:showNewsPage()
	if not(isElement(self.infoGuiEle.window[1])) then

		local file 	= fileOpen("res/txt/lizenzen.txt");
		local text	= fileRead(file, fileGetSize(file))
		fileClose(file);

		self.infoGuiEle.window[1] = guiCreateWindow(524, 300, 562, 335, getLocalizationString("GUI_mainmenu_impressum_news_title"), false)
		guiWindowSetSizable(self.infoGuiEle.window[1], false)

		self.infoGuiEle.memo[1] = guiCreateMemo(9, 22, 543, 278, text, false, self.infoGuiEle.window[1])
		guiMemoSetReadOnly(self.infoGuiEle.memo[1], true)
		self.infoGuiEle.button[1] = guiCreateButton(11, 305, 159, 20, getLocalizationString("GUI_mainmenu_button_impressum_OK"), false, self.infoGuiEle.window[1])
		guiSetProperty(self.infoGuiEle.button[1], "NormalTextColour", "FFAAAAAA")

		local saved		= isCursorShowing();

		showCursor(not(saved))

		addEventHandler("onClientGUIClick", self.infoGuiEle.button[1], function()
			destroyElement(self.infoGuiEle.window[1]);
			showCursor(saved)
		end, false)
	end
end

-- ///////////////////////////////
-- ///// LoginWindow		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:PerformAction(iInt)
	if(isElement(self.infoGuiEle.window[1])) then
		destroyElement(self.infoGuiEle.window[1]);
	end
	if(iInt == 1) then		-- Login
        local bPasswordSaved    = toboolean(config:getConfig("save_password"))
        if(bPasswordSaved) then
            _Gsettings.currentPassword  = config:getConfig("saved_password")
        end

		if(self.menusOpened[iInt] == true) then
			self:hideLoginpanel()
		else
			self:showLoginpanel()
		end

	elseif(iInt == 2) then	-- Intro
		hideLoginWindow(false, true)
		self:Stop();
		Intro:setEndFunc(
			function()
				 mainMenu = MainMenu:New()
				 mainMenu:Start()
			end
		)
		Intro:start();
		hud:Toggle(false);
	elseif(iInt == 3) then	-- News
		self:showNewsPage()

	elseif(iInt == 4) then  -- iRace
		triggerServerEvent("onClientMainMenuPerformAction", localPlayer, 4)
	end

	self.menusOpened[iInt] = not(self.menusOpened[iInt]);

	showCursor(true)
end

-- ///////////////////////////////
-- ///// Stop				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:Stop()
	if(toboolean(config:getConfig("save_password"))) then
        if(_Gsettings.currentPasswordNew) then
            config:setConfig("saved_password", _Gsettings.currentPasswordNew)
        end
    end
	cRegisterWindowGUI:getInstance():hide();

	hud:Toggle(true);
	self:destructor();

end
-- ///////////////////////////////
-- ///// hideLoginpanel		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:hideLoginpanel()
	if(self.guiEleLogin["Window"]) then
		self.guiEleLogin["Window"]:hide()
		delete(self.guiEleLogin["Window"])
		self.guiEleLogin["Window"] = nil
	end
end

-- ///////////////////////////////
-- ///// showLoginpanel		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:showLoginpanel()
	if not(self.guiEleLogin["Window"]) then
		self.guiEleLogin["Window"] 		= new(CDxWindow, getLocalizationString("GUI_loginpanel_window_title"), 370, 270, true, false, "Center|Middle", 0, 0, {tocolor(100, 255, 100, 200), false, getLocalizationString("GUI_loginpanel_window_header")}, getLocalizationString("GUI_loginpanel_window_helptext"))
		self.guiEleLogin["Image"][1] 		= new(CDxImage, 0, 0, 368, 270-29, "/res/images/bg.png",tocolor(255,255,255,255), self.guiEleLogin["Window"])
		self.guiEleLogin["Label"][1] 		= new(CDxLabel, getLocalizationString("GUI_loginpanel_label_password"), 222, 103, 136, 30, tocolor(255,255,255,255), 2, "default", "left", "center", self.guiEleLogin["Window"])
		self.guiEleLogin["Edit"][1] 		= new(CDxEdit, "Text", 220, 139, 139, 38, "Masked", tocolor(0,0,0,255), self.guiEleLogin["Window"])
		self.guiEleLogin["Button"][1] 		= new(CDxButton, getLocalizationString("GUI_loginpanel_button_login"), 220, 186, 139, 38, tocolor(255,255,255,255), self.guiEleLogin["Window"])
		self.guiEleLogin["Button"][2] 		= new(CDxButton, getLocalizationString("GUI_loginpanel_button_password_lost"), 10, 190, 170, 30, tocolor(255,255,255,255), self.guiEleLogin["Window"])


		local LoginAttempt = false

		self.guiEleLogin["Edit"][1]:addClickFunction( function ( button, state )
			if (self.guiEleLogin["Edit"][1]:getText() == "Text") then
				self.guiEleLogin["Edit"][1]:setText("")
			end
		end
		)

		self.guiEleLogin["Button"][1]:addClickFunction(function ( button, state )
			if not(LoginAttempt) then
				LoginAttempt = true
				local pw;
				if(_Gsettings.currentPassword) then
		        	pw = teaDecode(_Gsettings.currentPassword, tostring(config:getConfig("password_key")))
				end
		        local sha = true;

		        if not(pw) or (self.guiEleLogin["Edit"][1]:getText() ~= "Text") then
		            pw = self.guiEleLogin["Edit"][1]:getText()
		            sha = false;
		            config:setConfig("password_key", generateSalt(pw))
		            _Gsettings.currentPasswordNew = teaEncode(pw, config:getConfig("password_key"))
		        end

				triggerServerEvent ( "onPlayerLoginS", getLocalPlayer(), pw)
				loadingSprite:setEnabled(true);
				LoggedIn = true -- Vorsichtsmaßname (da keine Client-GUIs)
			end
		end
		)
		self.guiEleLogin["Button"][2]:addClickFunction( function ( button, state )
			self.guiEleLogin["Window"]:hide()
			confirmDialog:hideConfirmDialog()

			local function yes()
				triggerServerEvent("onPlayerPasswortVergessen", localPlayer, confirmDialog.guiEle["edit"]:getText())
			end

			local function no()
				self.guiEleLogin["Window"]:hide();
				self.guiEleLogin["Window"]:show();
			end

			confirmDialog:showConfirmDialog(getLocalizationString("GUI_loginpanel_confirm_forget_password_text"), yes, no, true, true)
		end)
		addEvent("enableLoginAgain", true)
		addEventHandler("enableLoginAgain", getRootElement(),function()
			LoginAttempt = false
			LoggedIn = false -- Loginstatus rückgängig machen (dummes Event-System lässt es nicht anders zu)
			loadingSprite:setEnabled(false);
		end)

		self.guiEleLogin["Window"]:add(self.guiEleLogin["Image"][1])
		self.guiEleLogin["Window"]:add(self.guiEleLogin["Label"][1])
		self.guiEleLogin["Window"]:add(self.guiEleLogin["Edit"][1])
		self.guiEleLogin["Window"]:add(self.guiEleLogin["Button"][1])
		self.guiEleLogin["Window"]:add(self.guiEleLogin["Button"][2])


		self.guiEleLogin["Window"]:show()
	end
end

-- ///////////////////////////////
-- ///// onJoin				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:onJoin(status, n_, tblSounds, sKey)
	loadingSprite:setEnabled(false);
	hud:Toggle(false);

	if(status == 0) then	-- Unregistriert
		setCameraMatrix(unpack(self.m_registerCamPos));
		cRegisterWindowGUI:getInstance():showRegister();

		self:BuildShaders()
	else
		mainMenu:Start(tblSounds, sKey);
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:constructor(...)

	addEvent("onClientPlayerJoinBack", true)
	addEvent("hideLoginWindow", true)
	-- Klassenvariablen --

	self.randomCamPos		=
	{
		{785.73107910156, -1223.0246582031, 16.090045928955, 706.72875976563, -1284.251953125, 12.949562072754},
		{1485.7933349609, -1643.8516845703, 184.57516479492, 1485.6892089844, -1661.7205810547, 86.184661865234},
		{1898.8765869141, -1552.7631835938, 13.975973129272, 1983.2464599609, -1606.3985595703, 16.206865310669},
		{2890.6525878906, -1266.3715820313, 99.091369628906, 2814.5871582031, -1316.29296875, 57.595333099365},
		{1514.4927978516, -2156.4838867188, 58.669185638428, 1589.9927978516, -2221.0656738281, 47.313808441162},
		{1316.0611572266, -2095.0573730469, 100.4381942749, 1234.7449951172, -2049.0895996094, 64.735862731934},
		{1068.7115478516, -1039.2719726563, 33.080997467041, 968.72735595703, -1039.7657470703, 34.788494110107},
		{1123.1721191406, -1348.8687744141, 50.625965118408, 1125.6633300781, -1446.2270507813, 27.928588867188},
	};

	self.m_registerCamPos	= {166.15821838379, -1877.9868164063, 68.480010986328, 233.47451782227, -1804.7602539063, 58.165466308594};


	self.pfade				= {};
	self.pfade.shaders		= "res/shader/"
	self.pfade.images		= "res/images/mainmenu/"
	self.pfade.sounds		= "res/sounds/";

	self.sx, self.sy		= guiGetScreenSize();
	self.aesx, self.aesy	= 1440, 900

	self.shaderEnabled		= false;
	self.mainMenuEnabled	= false;

	self.logoPNG			= dxCreateTexture(self.pfade.images.."logo.png", "argb", true, "clamp");
	self.logoUmrissPNG		= dxCreateTexture(self.pfade.images.."logo_umriss.png", "argb", true, "clamp");

	self.logoSizeX			= (976/2)/(self.aesx+self.aesy)*(self.sx+self.sy)
	self.logoSizeY			= (769/2)/(self.aesx+self.aesy)*(self.sx+self.sy)

	self.logoX				= (self.sx/2)-self.logoSizeX/2;
	self.logoY				= (self.sy/2)-self.logoSizeY/2;

	self.logoUmrissSizeX	= (512)/(self.aesx+self.aesy)*(self.sx+self.sy);
	self.logoUmrissSizeY	= (512)/(self.aesx+self.aesy)*(self.sx+self.sy);

	self.logoUmrissX		= (self.sx/2)-self.logoUmrissSizeX/2;
	self.logoUmrissY		= ((self.sy/2)-self.logoUmrissSizeY/2)-(10/self.aesy*self.sy);

	self.startTick			= getTickCount();

	self.alpha				= 0;

	self.hover				= {};
	self.guiEle				= {};
	self.guiCreated			= false;


	self.infoGuiEle			=
	{
		button = {},
		window = {},
		memo = {}
	}

	self.menusOpened		= {};

	self.endAlpha			= 0;

	self.musicVolume		= 1;
	self.music				= true;

	-- Functions --
	self.renderFunc			= function()
		self:RenderShader();
		self:RenderMainMenu();
	end

	self.guiEleLogin =
	{
		["Window"] 	= false,
		["Label"] 	= {},
		["Image"] 	= {},
		["Button"] 	= {},
		["Edit"] 	= {},
	}

	self.buttonLoginClickFunc	= function(...) self:PerformAction(1) end;
	self.buttonOptionClickFunc	= function(...) self:PerformAction(2) end;
	self.buttonNewsClickFunc	= function(...) self:PerformAction(3) end;
	self.buttonLeaveClickFunc	= function(...) self:PerformAction(4) end;

	self.toggleMusicFunc		= function(...) self.music = not (self.music) end;
	self.m_funcOnJoin			= function(...) self:onJoin(...) end
	self.m_funcOnLoginHide		= function(...) self:Stop(...) end
	-- Methoden --


	-- Events --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
	bindKey("m", "down", self.toggleMusicFunc)

	addCommandHandler("impressum", function() self:showNewsPage() end);
	--logger:OutputInfo("[CALLING] MainMenu: Constructor");

	addEventHandler("onClientPlayerJoinBack", getLocalPlayer(), self.m_funcOnJoin)
	addEventHandler("hideLoginWindow", getLocalPlayer(), self.m_funcOnLoginHide)
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function MainMenu:destructor()
	fadeCamera(false);

	self.fadeIn		= true;
	self.endTick	= getTickCount();
	self:DestroyGui();

	setTimer(function()
		removeEventHandler("onClientRender", getRootElement(), self.renderFunc)
		destroyElement(self.loginSound);

		destroyElement(self.shader);
		destroyElement(self.screenSource);

		showChat(true);
		showCursor(false);

		setCameraTarget(localPlayer)
	end, 1000, 1)
	unbindKey("m", "down", self.toggleMusicFunc)

	self:hideLoginpanel()
end

-- EVENT HANDLER --

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	triggerServerEvent("onClientJoin", getLocalPlayer())
end)
