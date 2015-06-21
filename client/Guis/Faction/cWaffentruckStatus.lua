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
-- Date: 05.02.2015
-- Time: 23:32
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 05.02.2015
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cWaffentruckStatusGUI = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:show(uVehicle, tick)
    if not(self.enabled) then
        if(isTimer(self.updateTimer)) then
            killTimer(self.updateTimer);
        end
        self.curVehicle     = uVehicle;
        self:createElements()
        self.enabled        = true
        self.curTick        = tick

        self.datTick        = getTickCount();

        self.updateTimer = setTimer(function() self:updateTime() end, 1000, -1);


        self:updateTime();
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])

        self.guiEle["window"]   = false;
        self.enabled            = false;
        self.curVehicle         = nil;


        if(isTimer(self.updateTimer)) then
            killTimer(self.updateTimer);
        end
    end
end

-- ///////////////////////////////
-- ///// updateTime 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:updateTime()
    if(isElement(self.curVehicle)) then
        local curTime           = ((self.curTick-(tonumber(getElementData(self.curVehicle, "startTick"))))+(getTickCount()-self.datTick))+(tonumber(getElementData(self.curVehicle, "startTick")))

        local endTime           = tonumber(getElementData(self.curVehicle, "endTick"))

        local globRemain        = endTime-(tonumber(getElementData(self.curVehicle, "startTick")))

        local remain            = curTime - endTime;

        local dif               = remain / globRemain;

        local time              = math.abs(math.ceil((remain/1000/60)))..":"..math.abs(math.floor(math.fmod((remain/1000), 60)))

        local progress          = 1+dif;

        self.guiEle["label2"]:setText("Verbleibende Zeit: "..time);
        self.guiEle["progressbar"]:setProgress(progress)
        self.guiEle["progressbar"]:setText(math.floor(progress*100).."%");

        if(progress > 1) then
            self:hide();
        end
    else
        self:hide()
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	    = new(CDxWindow, "Waffentruck", 336, 167, true, false, "Center|Top", 0, 0, {tocolor(125, 125, 255, 255), false, "Waffentruckabgabe"})

        self.guiEle["label"]	    = new(CDxLabel, "Status der Waffentruckabgabe:", 10, -25, 318, 93, tocolor(255,255,255,255), 1.25, "default-bold", "center", "center", self.guiEle["window"])
        self.guiEle["progressbar"]  = new(CDxProgressbar, 0.0, 5, 55, 318, 35, tocolor(125, 125, 255, 150), self.guiEle["window"], "0%" )
        self.guiEle["label2"]	    = new(CDxLabel, "Minuten verbleibend: -:-", 10, 75, 318, 93, tocolor(255,255,255,255), 1.25, "default-bold", "center", "center", self.guiEle["window"])

        self.guiEle["window"]:add(self.guiEle["label"]);
        self.guiEle["window"]:add(self.guiEle["progressbar"]);
        self.guiEle["window"]:add(self.guiEle["label2"]);

        self.guiEle["window"].ReadOnly = true;
        self.guiEle["window"]:show()


    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckStatusGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --
