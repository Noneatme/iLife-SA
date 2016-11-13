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
-- Date: 25.01.2015
-- Time: 14:33
-- To change this template use File | Settings | File Templates.
--

cThread = {}
cThread.__index     = cThread;


Threads     = {}

_coroutine_resume = coroutine.resume
function coroutine.resume(...)
	local state,result = _coroutine_resume(...)
	if not state then
		outputDebugString( tostring(result), 1 )	-- Output error message
	end
	return state,result
end

function cThread:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

function cThread:constructor(sName, func, iAmmounts)
    assert(Threads[sName] == nil);
    self.name = sName
    self.func = func

    self.iAmmounts = iAmmounts or 1;
    outputConsole("[TRHEAD: "..sName.."] Constructor");

    Threads[sName]  = self;
end

function cThread:start(iMS)
    self.thread = coroutine.create(self.func)
    self.yields = 0;

    self.lastTickCount  = getTickCount();

    self:resume()

    self.timer  = setTimer(function()
        if(self:status() == "suspended") then
            if(getTickCount()-self.lastTickCount > 5000) then
                self.lastTickCount = getTickCount();
                outputConsole("[THREAD: "..self.name.."] Current Yields: "..self.yields);
            end
            for i = 1, self.iAmmounts, 1 do
				if(self:status() == "suspended") then
	                self.yields = self.yields+1;
	                local result = self:resume();
	                if(result) and (type(result) ~= "boolean") then
	                    outputDebugString(tostring(result), 1)
	                end
				end
            end
        end

        if(self:status() == "dead") then
            killTimer(self.timer);
            self:stop()
        end
    end, iMS, 0)
end

function cThread:resume()
    return coroutine.resume(self.thread)
end

function cThread:stop()
    self.thread = nil

    outputConsole("[THREAD: "..self.name.."] Completed, Yields: "..self.yields);
end

function cThread:status()
    return coroutine.status(self.thread)
end
