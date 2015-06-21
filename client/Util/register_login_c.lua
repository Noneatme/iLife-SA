--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--[[x,y = guiGetScreenSize()

LoginWin = guiCreateWindow(x/2 - 150,y/2 - 110,300,220,"Willkommen",false)

TabPanel = guiCreateTabPanel(17,30,261,152,false,LoginWin)

TabLogin = guiCreateTab("Login",TabPanel)
LblUsername = guiCreateLabel(11,27,70,16,"Benutzername",false,TabLogin)
LoginUsername = guiCreateEdit(76,26,171,21,"",false,TabLogin)
LblPassword = guiCreateLabel(11,60,70,16,"Passwort",false,TabLogin)
LoginPassword = guiCreateEdit(76,58,171,21,"",false,TabLogin)
guiEditSetMasked(LoginPassword,true)

TabRegister = guiCreateTab("Register",TabPanel)
LblRegisterUsername = guiCreateLabel(11,27,70,16,"Benutzername",false,TabRegister)
EditRegisterUsername = guiCreateEdit(76,26,171,21,"",false,TabRegister)
LblRegisterPassword = guiCreateLabel(11,60,70,16,"Passwort",false,TabRegister)
EditRegisterPassword = guiCreateEdit(76,58,171,21,"",false,TabRegister)
guiEditSetMasked(EditRegisterPassword,true)
LblRegisterEmail = guiCreateLabel(35,92,35,16,"Email",false,TabRegister)
EditRegisterEmail = guiCreateEdit(76,90,171,21,"",false,TabRegister)

BtnAction = guiCreateButton(182,188,95,19,"LOS",false,LoginWin)

guiSetVisible ( LoginWin, false )
]]--


-- Muss Beizeiten mal komplett neu gemacht werden, sehr statisch geschrieben und nicht OOP

--[[
local usingNewLogin		= true;
local x,y 				= guiGetScreenSize()

Login =
{
	["Window"] 	= false,
	["Label"] 	= {},
	["Image"] 	= {},
	["Button"] 	= {},
	["Edit"] 	= {},
}

Login["Window"] 		= new(CDxWindow, getLocalizationString("GUI_loginpanel_window_title"), 370, 270, true, false, "Center|Middle", 0, 0, {tocolor(100, 255, 100, 200), false, getLocalizationString("GUI_loginpanel_window_header")}, getLocalizationString("GUI_loginpanel_window_helptext"))
Login["Image"][1] 		= new(CDxImage, 0, 0, 368, 270-29, "/res/images/bg.png",tocolor(255,255,255,255), Login["Window"])
Login["Label"][1] 		= new(CDxLabel, getLocalizationString("GUI_loginpanel_label_password"), 222, 103, 136, 30, tocolor(255,255,255,255), 2, "default", "left", "center", Login["Window"])
Login["Edit"][1] 		= new(CDxEdit, "Text", 220, 139, 139, 38, "Masked", tocolor(0,0,0,255), Login["Window"])
Login["Button"][1] 		= new(CDxButton, getLocalizationString("GUI_loginpanel_button_login"), 220, 186, 139, 38, tocolor(255,255,255,255), Login["Window"])
Login["Button"][2] 		= new(CDxButton, getLocalizationString("GUI_loginpanel_button_password_lost"), 10, 190, 170, 30, tocolor(255,255,255,255), Login["Window"])

LoginAttempt = false

Login["Edit"][1]:addClickFunction(
function ( button, state )
	if (Login["Edit"][1]:getText() == "Text") then
		Login["Edit"][1]:setText("")
	end
end
)

Login["Button"][1]:addClickFunction(
function ( button, state )
	if (not (LoginAttempt)) then
		LoginAttempt = true
        local pw = teaDecode(_Gsettings.currentPassword, tostring(config:getConfig("password_key")))
        local sha = true;

        if not(pw) or (Login["Edit"][1]:getText() ~= "Text") then
            pw = Login["Edit"][1]:getText()
            sha = false;
            config:setConfig("password_key", generateSalt(pw))
            _Gsettings.currentPasswordNew = teaEncode(pw, config:getConfig("password_key"))
        end

		triggerServerEvent ( "onPlayerLoginS", getLocalPlayer(), pw)
		loadingSprite:setEnabled(true);
	end
end
)
Login["Button"][2]:addClickFunction(
	function ( button, state )
		Login["Window"]:hide()
		confirmDialog:hideConfirmDialog()

		local function yes()
			triggerServerEvent("onPlayerPasswortVergessen", localPlayer, confirmDialog.guiEle["edit"]:getText())
		end

		local function no()
			Login["Window"]:hide();
			Login["Window"]:show();
		end

		confirmDialog:showConfirmDialog(getLocalizationString("GUI_loginpanel_confirm_forget_password_text"), yes, no, true, true)
	end
)
addEvent("enableLoginAgain", true)
addEventHandler("enableLoginAgain", getRootElement(),
function()
	LoginAttempt = false
	loadingSprite:setEnabled(false);
end
)

Login["Window"]:add(Login["Image"][1])
Login["Window"]:add(Login["Label"][1])
Login["Window"]:add(Login["Edit"][1])
Login["Window"]:add(Login["Button"][1])
Login["Window"]:add(Login["Button"][2])




	dxDrawText("Passwort:",222.0,103.0,358.0,132.0,tocolor(255,255,255,255),2.0,"default","left","top",false,false,true)
        dxDrawImage(220.0,186.0,139.0,38.0,"images/bg.png",0.0,0.0,0.0,tocolor(255,255,255,255),true)
        dxDrawImage(220.0,139.0,139.0,38.0,"images/bg.png",0.0,0.0,0.0,tocolor(255,255,255,255),true)
        dxDrawImage(0.0,0.0,368.0,241.0,"images/bg.png",0.0,0.0,0.0,tocolor(255,255,255,255),false)
    end

dxDrawText("Passwort",678.0,391.0,812.0,414.0,tocolor(255,255,255,255),1.0,"default","left","top",false,false,true)




addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			Register_Button = {}
			Register_Label = {}
			Register_Edit = {}
			Register_Radio = {}
			Register_Image = {}

			Register_Image[1] = guiCreateStaticImage(0.17685,0.18945,0.6463,0.6211,"res/images/Perso.png",true)
			Register_Radio[1] = guiCreateRadioButton(0.3627,0.8664,0.1799,0.0393,"Männlich",true,Register_Image[1])
			guiRadioButtonSetSelected(Register_Radio[1],true)
			guiSetFont(Register_Radio[1],"default-bold-small")
			Register_Radio[2] = guiCreateRadioButton(0.4507,0.8664,0.1799,0.0393,"Weiblich",true,Register_Image[1])
			guiSetFont(Register_Radio[2],"default-bold-small")
			Register_Edit[1] = guiCreateEdit(0.353,0.3019,0.3298,0.0692,getPlayerName(getLocalPlayer()),true,Register_Image[1])
			guiEditSetReadOnly(Register_Edit[1],true)
			guiEditSetMaxLength(Register_Edit[1],16)
			Register_Edit[2] = guiCreateEdit(0.353,0.4167,0.3298,0.0692,"",true,Register_Image[1])
			Register_Edit[3] = guiCreateEdit(0.353,0.5299,0.3298,0.0692,"",true,Register_Image[1])
			guiEditSetMasked(Register_Edit[3],true)
			guiEditSetMaxLength(Register_Edit[3], 16)
			Register_Edit[4] = guiCreateEdit(0.353,0.6494,0.3298,0.0692,"",true,Register_Image[1])
			guiEditSetMasked(Register_Edit[4],true)
			guiEditSetMaxLength(Register_Edit[4], 16)
			Register_Edit[5] = guiCreateEdit(0.3946,0.7563,0.0493,0.0692,"12",true,Register_Image[1])
			guiEditSetMaxLength(Register_Edit[5],2)
			Register_Label[1] = guiCreateLabel(0.3598,0.772,0.0348,0.0393,getLocalizationString("GUI_registerpanel_label_day"),true,Register_Image[1])
			guiLabelSetColor(Register_Label[1],0,0,0)
			guiSetFont(Register_Label[1],"default-bold-small")
			Register_Label[2] = guiCreateLabel(0.4584,0.772,0.0426,0.0393,getLocalizationString("GUI_registerpanel_label_month"),true,Register_Image[1])
			guiLabelSetColor(Register_Label[2],0,0,0)
			guiSetFont(Register_Label[2],"default-bold-small")
			Register_Edit[6] = guiCreateEdit(0.5029,0.7563,0.0493,0.0692,"12",true,Register_Image[1])
			Register_Label[3] = guiCreateLabel(0.5677,0.772,0.0426,0.0393,getLocalizationString("GUI_registerpanel_label_year"),true,Register_Image[1])
			guiLabelSetColor(Register_Label[3],0,0,0)
			guiSetFont(Register_Label[3],"default-bold-small")
			Register_Edit[7] = guiCreateEdit(0.6054,0.7563,0.0996,0.0692,"1995",true,Register_Image[1])
			Register_Button[1] = guiCreateButton(0.6925,0.8428,0.1654,0.0865,getLocalizationString("GUI_registerpanel_label_submit"),true,Register_Image[1])
			guiSetVisible ( Register_Image[1], false)
		end
	end
)



function requestServer(startedResource)
	if (startedResource == getThisResource()) then
		triggerServerEvent("onClientJoin", getLocalPlayer())
	end
end
addEventHandler("onClientResourceStart", getRootElement(), requestServer)

function dxDrawClick(btn, state, X, Y)
	local screenX,screenY = guiGetScreenSize()
	if (isPointInRectangle(X,Y,screenX-200, screenY-200,175,175)) then
		if ( (btn == "left") and (state=="down") ) then
			hideLoginWindow()
			Intro:setEndFunc(
				function()
					Login["Window"]:show()
					loginCamDrive ()
					guiSetInputEnabled(true)
					showCursor ( true )
					fadeCamera ( false,0,0,0,0)
					fadeCamera ( true, 5)
					showPlayerHudComponent ( "all", false)
				    hud:Toggle(false)
					_G["Loginsound"] = playSound("http://www.vio-race.de/servermusic/mapmusic/realsteel-ft-banana_dark-time.mp3",true)
					--_G["Loginsound"] = playSound("http://rewrite.ga/iLife/intro.mp3",true)
					setGameSpeed(1)
					addEventHandler("onClientClick", getRootElement(), dxDrawClick)
				end
			)
			Intro:start()
		end
	end
end

function joinHandler(status, n_, tblSounds, sKey)
	loadingSprite:setEnabled(false);

	if (status == 0) then
		-- Nicht registriert ! Intro + Register Window !
		Intro:setEndFunc(
			function()
				guiSetVisible ( Register_Image[1], true)
				guiBringToFront ( Register_Image[1] )
				loginCamDrive ()
				guiSetInputEnabled(true)
				showCursor ( true )
				fadeCamera ( false,0,0,0,0)
				fadeCamera ( true, 5)
				showPlayerHudComponent ( "all", false)
				hud:Toggle(false)
				_G["Loginsound"] = playSound("http://www.vio-race.de/servermusic/mapmusic/realsteel-ft-banana_dark-time.mp3",true)
				--_G["Loginsound"] = playSound("http://rewrite.ga/iLife/intro.mp3",true)
				setGameSpeed(1)
				addEventHandler("onClientRender", getRootElement(), dxDraw)
			end
		)
		Intro:start()
	else
		if(usingNewLogin == false) then

			Login["Window"]:show()
			loginCamDrive ()
			guiSetInputEnabled(true)
			showCursor ( true )
			fadeCamera ( false,0,0,0,0)
			fadeCamera ( true, 5)
			showPlayerHudComponent ( "all", false)
		    hud:Toggle(false)
			--_G["Loginsound"] = playSound("http://rewrite.ga/iLife/intro.mp3",true)
			_G["Loginsound"] = playSound("http://www.vio-race.de/servermusic/mapmusic/realsteel-ft-banana_dark-time.mp3",true)
			addEventHandler("onClientRender", getRootElement(), dxDraw)
			addEventHandler("onClientClick", getRootElement(), dxDrawClick)
			setGameSpeed(1)
			guiSetInputEnabled(true);

		else
			mainMenu:Start(tblSounds, sKey);
		end

	end
end
addEvent("playerJoin", true)
addEventHandler("playerJoin", getRootElement(), joinHandler)

function onRegisterClickBtn ( button, state )
	if (button == "left" and state == "up") then
		if (source == Register_Button[1]) then

			-- Gui Daten abfangen
			name = guiGetText( Register_Edit[1] )
			email = guiGetText( Register_Edit[2] )
			password = guiGetText( Register_Edit[3] )
			geburtsdatum = guiGetText( Register_Edit[7] ).."-"..guiGetText( Register_Edit[6] ).."-"..guiGetText( Register_Edit[5] )

			if (guiRadioButtonGetSelected(Register_Radio[2]) == true) then
				geschlecht = 1
			else
				geschlecht = 0
			end

			--Validation
			fehler = false
			if (name ~= getPlayerName(getLocalPlayer())) then
				fehler = true
				fehlertext = "Du kannst dich nicht mit einem anderen Namen registrieren!"
			end
			if (#name <3 or #name>16) then
				fehler = true
				fehlertext = "Dein Benutzername ist zu lang oder zu kurz!"
			end

			if (guiGetText(Register_Edit[4]) ~= password) then
				fehler = true
				fehlertext = "Die eingegebenen Passwörter stimmen nicht überein!"
			end

			if ( (gettok ( email, 2, "@" ) == false) or (gettok ( gettok ( email, 2, "@" ), 2, "." ) == false) or (gettok ( gettok ( email, 2, "@" ), 1, "." ) == "trashmail" )) then
				fehler = true
				fehlertext = "Es wurde eine ungültige E-Mail Adresse eingegeben!"
			end

			if (#password <5 or #password >16) then
				fehler = true
				fehlertext = "Ihr gewähltes Passwort ist zu lang oder zu kurz!"
			end
			if ( (tonumber(guiGetText(Register_Edit[7])) < 1950) or (tonumber( guiGetText(Register_Edit[7] )) > 2012) or (tonumber( guiGetText(Register_Edit[6])) > 12) or (tonumber(guiGetText(Register_Edit[6]))<1) or  (tonumber(guiGetText(Register_Edit[5]))<1) or (tonumber(guiGetText(Register_Edit[6]))>31)) then
				fehler = true
				fehlertext = "Geben sie bitte ein gültiges Geburtsdatum an!"
			end
			if (LoginAttempt) then
				fehler = true
				fehlertext = "Bitte warten...!"
			end

			if (fehler == true) then
				showInfoBox("error",fehlertext)
			else
				-- Registration triggern
				password = string.gsub(password, '<', '')
				password = string.gsub(password, '>', '')
				password = string.gsub(password, '|', '')
				password = string.gsub(password, '°', '')
				password = string.gsub(password, '^', '')
				triggerServerEvent ( "onPlayerRegister", getLocalPlayer(),string.gsub(name, '#%x%x%x%x%x%x', ''), email, password, geburtsdatum, geschlecht)
				LoginAttempt = true
			end

		end
	end
end



addEventHandler("onClientResourceStart", getRootElement(),
	function(startedResource)
		if (startedResource == getThisResource()) then
			addEventHandler( "onClientGUIClick",Register_Button[1], onRegisterClickBtn, false )
		end
	end
)


function onEnterLogin ( button, state, LoginUsername )
	triggerServerEvent ( "onPlayerLogin", getLocalPlayer(),guiGetText(Login_Edit[1]) )
end
addEventHandler( "onClientGUIAccepted",Login_Edit[1], onEnterLogin,false)


LoggedIn = false

function hideLoginWindow(register, justvisual)

	if (justvisual) then
		if (isElement(_G["Loginsound"])) then
			destroyElement(_G["Loginsound"])
		end
		showPlayerHudComponent ( "all", false)
		guiSetInputEnabled(false)
		Login["Window"]:hide()
		destroy(Login["Window"])
		guiSetVisible ( Register_Image[1], false )
		showCursor ( false )
		removeEventHandler ( "onClientRender", getRootElement(), camRender )
		cancelCameraIntro ()
		removeEventHandler("onClientRender", getRootElement(), dxDraw)
		removeEventHandler("onClientClick", getRootElement(), dxDrawClick)
		setGameSpeed(1)
		hud:Toggle(false);
		return true
	end
	if(usingNewLogin == false) or register then

		if (isElement(_G["Loginsound"])) then
			destroyElement(_G["Loginsound"])
		end
		showPlayerHudComponent ( "all", false)
		guiSetInputEnabled(false)
		--guiSetVisible ( Login_Window[1], false )
		Login["Window"]:hide()
		destroy(Login["Window"])
		guiSetVisible ( Register_Image[1], false )
		showCursor ( false )
		removeEventHandler ( "onClientRender", getRootElement(), camRender )
		cancelCameraIntro ()
		removeEventHandler("onClientRender", getRootElement(), dxDraw)
		removeEventHandler("onClientClick", getRootElement(), dxDrawClick)
		setGameSpeed(1)
	    showPlayerHudComponent ( "crosshair", true)
		hud:Toggle(true);


	else
		mainMenu:Stop();
		showPlayerHudComponent ( "crosshair", true)


    end

    if(toboolean(config:getConfig("save_password"))) then
        if(_Gsettings.currentPasswordNew) then
            config:setConfig("saved_password", _Gsettings.currentPasswordNew)
        end
    end
	hud:Toggle(true);

	showCursor ( false )
	Login["Window"]:hide()
	guiSetVisible ( Register_Image[1], false )

	LoggedIn = true
end
addEvent( "hideLoginWindow", true )
addEventHandler( "hideLoginWindow", getRootElement(), hideLoginWindow )

--]]
