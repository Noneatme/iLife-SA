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
-- Date: 08.02.2015
-- Time: 23:53
-- To change this template use File | Settings | File Templates.
--

cOOCChat = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cOOCChat:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// sendMessage     	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOOCChat:sendMessage(msg)
    for index, player in pairs(getElementsByType("player")) do
        if(player.Rank) then
            triggerClientEvent(player, "onOOCChatReceive", player, msg);
        end
    end
end

-- ///////////////////////////////
-- ///// OCC         		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOOCChat:ooc(uPlayer, cmd, ...)
    if not(isTimer(self.m_tblWaitTimer[uPlayer])) or (uPlayer:getAdminLevel() > 3) then
        local msg       = table.concat({...}, " ")
        msg             = cWortFilter:getInstance():applyCensoreFilter(msg);
        local wort      = cWortFilter:getInstance():hasBadWordIn(msg);
        if not(wort) then
            if(string.len(msg) > 0) then
                local color     = "#D6D6D6"
                if(uPlayer:getFaction():getID() ~= 0) then
                    color = RGBToHex(Factions[uPlayer:getFaction():getID()]:getColors());
                end
                for i = 1, 5, 1 do
                    msg = string.gsub(msg, '#%x%x%x%x%x%x', '') -- 5 mal wegen Dopppler Effekt
                end
                local msg2 = msg;

                msg = "#FFFFFF[[ "..color..uPlayer:getName().."#FFFFFF: "..msg.." ]]";
                self:sendMessage(msg);

                logger:OutputPlayerLog(uPlayer, "Schrieb OOC Chatnachricht", msg2);
                self.m_tblWaitTimer[uPlayer] = setTimer(function() end, 5000, 1);
            else
                uPlayer:showInfoBox("error", "Du kannst keinen leeren Text senden!")
            end
        else
            uPlayer:showInfoBox("error", "Du versuchst, ein verbotenes Wort zu umgehen: "..wort.."!")
        end
    else
        uPlayer:showInfoBox("error", "Du kannst nur alle 5 Sekunden einen Text schreiben!")
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOOCChat:constructor(...)
    -- Klassenvariablen --
    self.m_tblWaitTimer     = {}
    self.m_bEnabled         = true;

    -- Funktionen --
    self.m_funcOOCChat = function(uPlayer, ...)
        if(self.m_bEnabled) then
            self:ooc(uPlayer, ...)
        else
            uPlayer:showInfoBox("error", "Der OOC Chat wurde deaktiviert!")
        end
    end


    self.m_funcToggleOOC    = function(uPlayer)
        if(uPlayer:getAdminLevel() > 2) then
            self.m_bEnabled = not(self.m_bEnabled);
            if(self.m_bEnabled) then
                self:sendMessage("* Der OOC Chat wurde aktiviert.");
            else
                self:sendMessage("* Der OOC Chat wurde deaktiviert.");
            end
        end
    end
    -- Events --
    addCommandHandler("ooc", self.m_funcOOCChat)
    addCommandHandler("serverooc", self.m_funcToggleOOC)
end

-- EVENT HANDLER --
