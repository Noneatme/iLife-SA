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
-- Date: 09.02.2015
-- Time: 00:03
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
-- ///// ooc         		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOOCChat:ooc(msg)
    if(toboolean(config:getConfig("ooc_chat"))) then
        outputChatBox(msg, 255, 255, 255, true);
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cOOCChat:constructor(...)
    -- Klassenvariablen --
    addEvent("onOOCChatReceive", true)

    -- Funktionen --
    self.m_funcReceiveOOC       = function(...) self:ooc(...) end

    -- Events --
    addEventHandler("onOOCChatReceive", getLocalPlayer(), self.m_funcReceiveOOC);
    addCommandHandler("toggleooc", function()
        config:setConfig("ooc_chat", not(toboolean(config:getConfig("ooc_chat"))))
        if not(toboolean(config:getConfig("ooc_chat"))) then
            showInfoBox("sucess", "OOC Chat Lokal deaktiviert!")
        else
            showInfoBox("sucess", "OOC Chat Lokal aktiviert!")
        end
    end)
end

-- EVENT HANDLER --

