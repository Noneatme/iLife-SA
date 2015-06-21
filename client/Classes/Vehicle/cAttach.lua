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
-- Date: 29.01.2015
-- Time: 16:34
-- To change this template use File | Settings | File Templates.
--

cAttach = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cAttach:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// detach         	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAttach:detach(...)
    if(isElementAttached(localPlayer)) and (self.enabled) then
        self.enabled    = false;
        triggerServerEvent("onPlayerVehicleAttach", localPlayer, false);
    end
end

-- ///////////////////////////////
-- ///// CheckAttachFunc	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAttach:checkAttach(...)
    if(isElementAttached(localPlayer)) and (self.enabled) then
        self.enabled    = false;
        triggerServerEvent("onPlayerVehicleAttach", localPlayer, false);
    else
        if not(getPedOccupiedVehicle(localPlayer)) then
            local vehicle = getPedContactElement(localPlayer)
            if(vehicle) and (getElementType(vehicle) == "vehicle") then
                if(self.allowedModels[getElementModel(vehicle)]) or (getVehicleType(vehicle) == "Boat") or (getVehicleType(vehicle) == "Plane") then
                    triggerServerEvent("onPlayerVehicleAttach", localPlayer, vehicle);
                    self.enabled    = true;
                end
            end
        end
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cAttach:constructor(...)
    -- Klassenvariablen --
    self.checkAttachFunc        = function(...) self:checkAttach(...) end
    self.detachFunc             = function(...) self:detach(...) end

    self.allowedModels      =
    {
        [406] = "Dumper",
        [422] = "Bobcat",
        [443] = "Packer",
        [444] = "Monster",
        [449] = "Tram",
        [455] = "Flatbed",
        [470] = "Patriot",
        [478] = "Walton",
        [500] = "Mesa",
        [525] = "Towtruck",
        [535] = "Slamvan",
        [554] = "Yosemite",
        [556] = "Monster A",
        [557] = "Monster B",
        [569] = "Freight Trailer A",
        [578] = "DTF-300",
        [582] = "Newsvan",
        [590] = "Zug Container",
        [607] = "Baggage Trailer",
        [543] = "Sadler",
        [530] = "Forklift",
    }

    -- Funktionen --
    bindKey("x", "down", self.checkAttachFunc)
    bindKey("jump", "down", self.detachFunc);

    -- Events --
end

-- EVENT HANDLER --

