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
-- Time: 17:56
-- To change this template use File | Settings | File Templates.
--
--[[
local x, y, z = 2766.4509277344, 305.17666625977, 8.2681865692139

local trails =
{
    [1] = 537,
    [2] = 569,
    [2] = 569,
    [3] = 590,
    [4] = 590,
    [5] = 590,
    [6] = 590,
    [7] = 590,
    [8] = 569,
    [9] = 569,
    [10] = 569,
    [11] = 569,
    [12] = 569,
    [13] = 569,
    [14] = 569,
    [15] = 569,
}

local train     = {}
local curAdd    = 50;

for index, id in ipairs(trails) do
    setTimer(function()
        train[index] = createVehicle(id, x, y, z);
        setVehicleLocked(train[index], true)
        setTrainDerailable(train[index], false)
        if(train[index-1]) and (isElement(train[index-1])) then
            attachTrailerToVehicle(train[index-1], train[index])

        else
            local ped = createPed(60, x, y, z)
            warpPedIntoVehicle(ped, train[index]);
            setTimer(setTrainSpeed, 1000, -1, train[index], -0.7)
        end
    end, curAdd*index, 1)
end]]