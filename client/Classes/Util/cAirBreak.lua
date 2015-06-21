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
-- Time: 23:33
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 09.02.2015
-- Time: 23:31
-- To change this template use File | Settings | File Templates.
--

cAirBreak = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cAirBreak:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// ToggleAirbreak		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAirBreak:toggleAirbreak()
    self.m_bAirbreakEnabled = not(self.m_bAirbreakEnabled);

    if(self.m_bAirbreakEnabled) then
        addEventHandler("onClientRender", getRootElement(), self.m_funcRender);

        for index, ctrl in pairs(self.m_tblControlsToBind) do
            bindKey(ctrl, "both", self.m_funcRegisterKey)
            self.m_tblStates[ctrl] = "false"
        end

        self.startTick  = getTickCount()

        if(getControlState("forwards")) then
            self.m_tblStates["forwards"] = "down"
        end
        if(getControlState("accelerate")) then
            self.m_tblStates["accelerate"] = "down"
        end
    else
        removeEventHandler("onClientRender", getRootElement(), self.m_funcRender);

        for index, ctrl in pairs(self.m_tblControlsToBind) do
            unbindKey(ctrl, "both", self.m_funcRegisterKey)
        end

        local uElement  = localPlayer

        if(isPedInVehicle(localPlayer)) then
            uElement = getPedOccupiedVehicle(localPlayer)
        end
        setElementFrozen(uElement, false)
        setElementCollisionsEnabled(uElement, true)

        local x, y = self.lastVX/1.5, self.lastVY/1.5

        setElementVelocity(uElement, x*1/getGameSpeed(), y*1/getGameSpeed(), self.lastVZ/1000)
    end
end

-- ///////////////////////////////
-- ///// registerKey		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAirBreak:registerKey(key, state)
    self.m_tblStates[key] = state;
end

-- ///////////////////////////////
-- ///// isAnyKeyPressed		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAirBreak:isAnyKeyPressed()
    for index, state in pairs(self.m_tblStates) do
        if(state == "down") then
            return true;
        end
    end
    return false;
end

-- ///////////////////////////////
-- ///// render     		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAirBreak:render()
    if(self.m_bAirbreakEnabled) then
        local uElement  = localPlayer

        if(isPedInVehicle(localPlayer)) then
            uElement = getPedOccupiedVehicle(localPlayer)
        end

        local x, y, z = getElementPosition(uElement);
        local rx, ry, rot = getElementRotation(getCamera())
        local addx, addy = 0, 0;


        local value     = 5

        if not(self:isAnyKeyPressed()) then
            self.startTick  = getTickCount()
        end

        local val = (getTickCount()-self.startTick)/1000;
        if(val > 1) then val = 1 end
        local progress = getEasingValue(val, "OutQuad");
        if(progress > 1) then progress = 1 end

        value = value*progress;

        if(self.m_tblStates["forwards"] == "down") or (self.m_tblStates["accelerate"] == "down") then
            local x1, y1 = getPointFromDistanceRotation(x, y, value, (rot*-1)+180)
            addx, addy = addx+x-x1, addy+y-y1;
        end

        if(self.m_tblStates["backwards"] == "down") or (self.m_tblStates["brake_reverse"] == "down") then
            local x1, y1 = getPointFromDistanceRotation(x, y, -value, (rot*-1)+180)
            addx, addy = addx+x-x1, addy+y-y1;
        end

        if(self.m_tblStates["left"] == "down") or (self.m_tblStates["vehicle_left"] == "down") then
            local x1, y1 = getPointFromDistanceRotation(x, y, value, (rot*-1)+90)
            addx, addy = addx+x-x1, addy+y-y1;
        end

        if(self.m_tblStates["right"] == "down") or (self.m_tblStates["vehicle_right"] == "down") then
            local x1, y1 = getPointFromDistanceRotation(x, y, value, (rot*-1)+270)
            addx, addy = addx+x-x1, addy+y-y1;
        end

        if(self.m_tblStates["lshift"] == "down") then
            z = z+value
        end
        if(self.m_tblStates["lctrl"] == "down") then
            z = z-value
        end

        x, y = x+addx, y+addy
        setElementFrozen(uElement, true)
        setElementPosition(uElement, x, y, z)

        if(getElementType(uElement) == "player") then
            setElementRotation(uElement, 0, 0, (rot*-1))
        else
            setElementRotation(uElement, 0, 0, rot)
        end

        self.lastVX, self.lastVY, self.lastVZ = addx, addy, z
        --   setElementCollisionsEnabled(uElement, false)
    else
        self:toggleAirbreak();
    end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAirBreak:constructor(...)
    -- Klassenvariablen --
    addEvent("onAirbreakToggle", true)

    self.m_bAirbreakEnabled         = false;
    self.m_tblStates                = {}

    self.m_tblControlsToBind =
    {
        "forwards", "backwards", "left", "right", "lshift", "lctrl", "accelerate", "brake_reverse", "vehicle_left", "vehicle_right"
    }


    -- Funktionen --
    self.m_funcToggleAirbreak       = function(...) self:toggleAirbreak(...) end
    self.m_funcRender               = function(...) self:render(...) end

    -- KEYS --
    self.m_funcRegisterKey           = function(key, state) self:registerKey(key, state) end

    -- Events --
    addEventHandler("onAirbreakToggle", getLocalPlayer(), self.m_funcToggleAirbreak)

end



-- EVENT HANDLER --
