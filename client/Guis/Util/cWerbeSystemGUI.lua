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
-- Time: 13:38
-- To change this template use File | Settings | File Templates.
--

cWerbeSystemGUI = inherit(cSingleton);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cWerbeSystemGUI:new(...)
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

function cWerbeSystemGUI:show()
    if not(self.enabled) and not(clientBusy) then
        self:createElements()
        self.enabled = true
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWerbeSystemGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy      = self.enabled
    end
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWerbeSystemGUI:createElements()
    if not(self.guiEle["window"]) then

        local X, Y = 450, 450
        self.guiEle["window"] 	= new(CDxWindow, "Werbesystem", X, Y, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Werbesystem"})

        self.guiEle["label1"]   = new(CDxLabel, "Je mehr User du wirbst, desto mehr Sachen kannst du Erhalten! Hier siehst du eine Auswahl an verschiedene Sachen, welche du Erhalten kannst. Um deinen Fortschritt zu verbessern, muss ein User deinen Namen bei der Registrierung angegeben haben und mindestens 75 Spielstunden erreichen!", 15, 10, Y-20, 160, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle["window"])

        self.guiEle["progressbar"]  = new(CDxProgressbar, 0, 5, 100, 430, 25, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["progressbar"]:setText("Fortschritt: 0/10 User")

        self.guiEle["list1"]    = new(CDxList, 5, 140, 430, 280, tocolor(255, 255, 255, 255), self.guiEle["window"])
        self.guiEle["list1"]:addColumn("Anzahl Spieler Geworben", false, true)
        self.guiEle["list1"]:addColumn("Belohnung", false, false)


        for i = 1, #_Gsettings.userWerbenUserBelohnunugen, 1 do
            self.guiEle["list1"]:addRow(i.."|".._Gsettings.userWerbenUserBelohnunugen[i])
        end

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWerbeSystemGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --
