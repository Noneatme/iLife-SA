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

cEinstellungsGUI = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cEinstellungsGUI:new(...)
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

function cEinstellungsGUI:show()
    if not(self.enabled) then
        self:createElements()
        self.enabled = true
    end
end

-- ///////////////////////////////
-- ///// hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellungsGUI:hide()
    if(self.guiEle["window"]) then
        self.guiEle["window"]:hide();
        delete(self.guiEle["window"])
        self.guiEle["window"] = false;
        self.enabled = false;
        clientBusy = false;
    end
end

-- ///////////////////////////////
-- ///// updateTime 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellungsGUI:updateTime()
    self.guiEle["label2"]:setText(self.Time);
end

-- ///////////////////////////////
-- ///// createElements		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellungsGUI:createElements()
    if not(self.guiEle["window"]) then

        self.guiEle["window"] 	    = new(CDxWindow, "Einstellungen", 320, 250, true, true, "Center|Middle", 0, 0, {tocolor(125, 125, 155, 255), false, "Einstellungen"}, "Hier kannst du erweiterte Einstellungen vornehmen.")
        self.guiEle["window"]:setHideFunction(function() self:hide() end)

        local addX, addY = 155, 35
        local curX, curY = 0, 0
        for i = 1, self.m_iMaxButtons/2, 1 do
            curX = 0;
            for i2 = 1, 2, 1 do
                self.guiEle["button_"..i..i2]     = new(CDxButton, "Button "..i..i2, 5+curX, 5+curY, 150, 30, tocolor(255, 255, 255, 255), self.guiEle["window"])

                curX = curX+addX

                local index = tonumber(i..i2)
                if not(self.m_tblButtonFunctions[index]) then
                    self.guiEle["button_"..i..i2]:setDisabled(true)
                else

                    local name = self.m_tblButtonFunctions[index][1];

                    self.guiEle["button_"..i..i2]:setText(name)
                    self.guiEle["button_"..i..i2]:addClickFunction(self.m_tblButtonFunctions[index][2])
                end
            end
            curY = curY+addY
        end

        for index, ele in pairs(self.guiEle) do
            if(index ~= "window") then
                self.guiEle["window"]:add(ele)
            end
        end

        self.guiEle["window"]:show();

        clientBusy = true;
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cEinstellungsGUI:constructor(...)
    -- Klassenvariablen --
    self.guiEle         = {}
    self.enabled        = false;

    -- Events --
    self.m_iMaxButtons  = 12

    self.m_tblButtonFunctions   =
    {
        [11] = {"Passwort aendern", function()
            self:hide()
            local curPW = "";
            local newPW = "";

            local function accept()
                curPW = confirmDialog.guiEle["edit"]:getText();
                setTimer(function()
                    local function accept_2()
                        newPW = confirmDialog.guiEle["edit"]:getText();
                        setTimer(function()
                            local function accept_3()

                                if(confirmDialog.guiEle["edit"]:getText() == newPW) then
                                    triggerServerEvent("onPlayerChangePassword", localPlayer, curPW, newPW);
                                else
                                    setTimer(function()
                                        confirmDialog:showConfirmDialog("Deine Passwörter stimmen nicht überein!", false, false, false, false)
                                    end, 50, 1)
                                end

                            end
                            confirmDialog:showConfirmDialog("Bitte gebe das neues Passwort erneut ein:", accept_3, reset_3, false, true)
                        end, 50, 1)
                    end
                    confirmDialog:showConfirmDialog("Bitte gebe dein neues Passwort ein:", accept_2, reset_2, false, true)
                end, 50, 1)
            end

            confirmDialog:showConfirmDialog("Bitte gebe dein zurzeitiges Passwort ein:", accept, reset, false, true)

        end},

        [12] = {"Modliste", function() self:hide() cEinstellung_ModlisteGUI:new():show() end},
        [21] = {"User werben User", function() self:hide() cWerbeSystemGUI:getInstance():show() end},
    }

end

-- EVENT HANDLER --



--cEinstellungsGUI:new():show()
