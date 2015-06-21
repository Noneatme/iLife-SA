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
-- Date: 01.02.2015
-- Time: 21:16
-- To change this template use File | Settings | File Templates.
--
-- onDrugPlaceValid


addEvent("onDrugPlaceValid", true)
addEvent("onDrugPlantClick", true);

cDrugManager = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cDrugManager:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end

-- ///////////////////////////////
-- ///// checkGround   		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrugManager:checkGround(itemID)
    local x, y, z = getElementPosition(localPlayer)
    local sucess    = false;

    if not(getElementData(localPlayer, "drugplacing")) then
        if not(isPedInVehicle(localPlayer)) then
            if not(getPedContactElement(localPlayer)) then
                local _, _, _, _, _, _, _, _, mat = processLineOfSight(x, y, z, x, y, z-3, true, false, false, false, false);

                if(mat) then
                    if(self.gMats[mat]) then
                        if not (testLineAgainstWater(x, y, z-500, x, y, z+500)) then
                            sucess = true;
                        end
                    end
                end
            end
        end
    end

    if(sucess) then
        triggerServerEvent("onPlayerDrugPlace", localPlayer, itemID);
    else
        triggerServerEvent("onItemPlaceFailure", localPlayer, itemID);
    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cDrugManager:constructor(...)
    -- Klassenvariablen --
    self.grassMats      = {
        9, 10, 11, 12, 13, 14, 15, 16, 17, 20, 80, 81, 82, 115, 116, 117, 118, 119, 120, 121, 122, 125,
        146, 147, 148, 149, 150, 151, 152, 153, 160, 6, 85, 101, 134, 140, 19, 21, 22, 24, 25, 26, 27,
        40, 83, 84, 87, 88, 100, 110, 123, 124, 126, 128, 129, 130, 132, 133, 141, 142, 145, 155, 156,
        28, 29, 30, 31, 32, 33, 74, 75, 76, 77, 78, 79, 86, 96, 97, 98, 99, 131, 143, 157,
    }

    self.gMats          = {}

    self.m_uVerkaeufer  = createPed(73, 160.67868041992, -159.69627380371, 1.578125, 180);


    for i = 1, #self.grassMats, 1 do
        self.gMats[self.grassMats[i]] = true;
    end

    self.clickGuiShow   = false;

    -- Funktionen --
    self.checkGroundFunc         = function(...) self:checkGround(...) end
    self.drugClickFunc          = function(iId, iGramm)
        if not(self.clickGuiShow) and not(clientBusy) then
            self.clickGuiShow = true;

            local function reset()
                setTimer(function() self.clickGuiShow = false; end, 1000, 1)
            end

            local function accept()
                reset()
                triggerServerEvent("onDrugErnte", localPlayer, iId)
            end

            confirmDialog:showConfirmDialog("Bist du sicher dass du diese Droge ernten moechtest? Du wirst "..iGramm.." Gramm erhalten.", accept, reset, false, false)

        end
    end

    -- Events --
    addEventHandler("onDrugPlaceValid", getLocalPlayer(), self.checkGroundFunc)
    addEventHandler("onDrugPlantClick", getLocalPlayer(), self.drugClickFunc)
end

-- EVENT HANDLER --

