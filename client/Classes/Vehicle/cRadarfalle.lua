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
-- Date: 27.01.2015
-- Time: 19:34
-- To change this template use File | Settings | File Templates.
--

cRadarfalle = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cRadarfalle:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// Disable     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:disable()
    if(self.m_bEnabled) then
        removeEventHandler("onClientRender", getRootElement(), self.m_funcRender)
        self.m_bEnabled     = false;

        if(isTimer(self.m_iTimer)) then
            killTimer(self.m_iTimer)
        end
    end
end


-- ///////////////////////////////
-- ///// render     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:render()
    if(self.m_bEnabled) then
        if(self.m_renderTarget) then
            --   setCameraTarget(localPlayer)
            local imgW, imgH        = self.w/3, self.h/3;
            dxDrawImage((self.w/2)-(imgW/2), 0, imgW, imgH, self.m_renderTarget);
        end
    else
        self:disable();
    end
end

-- ///////////////////////////////
-- ///// saveImage     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:saveImage(uImage)
    local pixels	= dxGetTexturePixels(uImage);

    local image		= dxConvertPixels(pixels, "jpeg", 80);
    local date		= self:getTime();

    local file		= fileCreate("screenshots/blitzer/"..date..".jpg");

    fileWrite(file, image);
    fileFlush(file);
    fileClose(file);

    local enabled = toBoolean(config:getConfig("upload_blitzer_images"));

    if(enabled) then
        triggerLatentServerEvent("onBlitzerfotoSend", 5000, false, localPlayer, image);
    end
end

-- ///////////////////////////////
-- ///// doBlitz     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:doBlitz(uObject, iSpeed, iMaxKMH, iUeberschreitung, iGeld)
    if(self.m_bEnabled) then
        self:disable();
    end
    self.m_uImage       = false;

    local x, y, z       = getElementPosition(uObject);
    local x2, y2, z2    = getElementPosition(localPlayer);

    setElementAlpha(uObject, 0)

    fadeCamera(false, 0, 255, 255, 255)
    setGameSpeed(0.1);

    setTimer(function()
        fadeCamera(true, 0.5, 255, 255, 255)
    end, 50, 1)

    local fov       = 50-getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);

    if(fov < 5) then
        if(fov < 3) then
            fov = 3;
        end
    end

    setCameraMatrix(x, y, z, x2, y2, z2, 0, fov)
    setTimer(dxUpdateScreenSource, 50, 1, self.m_screenSource);
    setTimer(setCameraTarget, 150, 1, localPlayer)

    setTimer(function()
        dxSetRenderTarget(self.m_renderTarget, true);

        local date      = self:getDate();
        local w, h = self.w/3, self.h/3

        dxDrawImage(0, 0, w, h, self.m_screenSource)

        dxDrawLine(0, 0, 0, h, tocolor(0, 0, 0, 255), 5);
        dxDrawLine(0, 0, w, 0, tocolor(0, 0, 0, 255), 5);
        dxDrawLine(w, 0, w, h, tocolor(0, 0, 0, 255), 5);
        dxDrawLine(0, h, w, h, tocolor(0, 0, 0, 255), 5);

        dxDrawText("Geschw.: "..math.floor(iSpeed).."km/h | Erlaubt: "..iMaxKMH.."km/h", 50/self.aesx*w, 50/self.aesy*h, 250/self.aesx*w, 250/self.aesy*h, tocolor(200, 200, 200, 255), (5/(self.aesx+self.aesy)*(w+h)), "default-bold")
        dxDrawText("Bussgeld: $"..iGeld, 50/self.aesx*w, 720/self.aesy*h, 250/self.aesx*w, 720/self.aesy*h, tocolor(200, 200, 200, 255), (5/(self.aesx+self.aesy)*(w+h)), "default-bold")
        dxDrawText("Ueberschreitung: "..math.floor(iUeberschreitung).."km/h", 50/self.aesx*w, 800/self.aesy*h, 250/self.aesx*w, 800/self.aesy*h, tocolor(200, 200, 200, 255), (5/(self.aesx+self.aesy)*(w+h)), "default-bold")

        dxDrawText("Datum: "..date, 50/self.aesx*w, 130/self.aesy*h, 250/self.aesx*w, 130/self.aesy*h, tocolor(200, 200, 200, 255), (5/(self.aesx+self.aesy)*(w+h)), "default-bold")

        dxSetRenderTarget(nil);

        self:saveImage(self.m_renderTarget);

        setElementAlpha(uObject, 255);
        setGameSpeed(1);
    end, 150, 1);


    setTimer(function()
        self:disable()

        self.m_bEnabled     = true;

        addEventHandler("onClientRender", getRootElement(), self.m_funcRender)

        if(isTimer(self.m_iTimer)) then
            killTimer(self.m_iTimer)
        end

        self.m_iTimer = setTimer(function() self:disable() end, 7500, 1);
    end, 1000, 1)

    playSound("res/sounds/misc/blitzer.ogg", false);
end

-- ///////////////////////////////
-- ///// getDate    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:getDate()
    local weekdays 	= {[0] = "So", [1] = "Mo", [2] = "Di", [3] = "Mi", [4] = "Do", [5] = "Fr", [6] = "Sa", [7] = "So"};
    local months	= {"Januar", "Februar", "Maerz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"};

    local string = "";

    local time = getRealTime();

    local x, y, z = getElementPosition(localPlayer)

    local hour  = time.hour;
    if(hour < 10) then hour = "0"..hour end

    local minute    = time.minute;
    if(minute < 10) then minute = "0"..minute end

    local second    = time.second
    if(second < 10) then second = "0"..second; end

    string	= string..weekdays[time.weekday].."., "..time.monthday..". "..months[time.month+1].." "..(time.year+1900).." "..hour..":"..minute..":"..second

    return string
end

-- ///////////////////////////////
-- ///// getTime    		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:getTime()
    local time = getRealTime()
    local day = time.monthday
    local month = time.month+1
    local year = time.year+1900
    local hour = time.hour
    local minute = time.minute
    local second = time.second;

    if(hour < 10) then
        hour = "0"..hour;
    end

    if(minute < 10) then
        minute = "0"..minute;
    end

    if(second < 10) then
        second = "0"..second;
    end
    return day.."-"..month.."-"..year.." "..hour.."-"..minute.."-"..second;
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cRadarfalle:constructor(...)
    -- Klassenvariablen --

    self.aesx, self.aesy    = 1600, 900;
    self.w, self.h          = guiGetScreenSize()

    self.m_screenSource     = dxCreateScreenSource(self.w, self.h);
    self.m_renderTarget     = dxCreateRenderTarget(self.w/3, self.h/3);

    self.b_Enabled          = false;

    self.m_iTimer           = false;

    -- Funktionen --
    self.m_funcGeblitzt     = function(...) self:doBlitz(...) end

    self.m_funcRender       = function(...) self:render(...) end

    -- Events --
    addEvent("onRadarfalleGeblitzt", true)
    addEventHandler("onRadarfalleGeblitzt", getLocalPlayer(), self.m_funcGeblitzt);

    addEvent("onRadarfallenGuiOpen", true)
    addEventHandler("onRadarfallenGuiOpen", localPlayer, function(uElement, iValue)

        local function absenden()
            local value = tonumber(confirmDialog.guiEle["edit"]:getText())
            if(value) and (value > 20) and (value < 1000) then
                triggerServerEvent("onRadarfalleBearbeite", localPlayer, uElement, value)
            end
        end
        confirmDialog:showConfirmDialog("Bitte gebe die maximale Geschwindigkeit in KM/h an!", absenden, nil, false, true)
        confirmDialog.guiEle["edit"]:setText(iValue);
    end)
end

-- EVENT HANDLER --

