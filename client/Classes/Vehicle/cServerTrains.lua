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
-- Time: 18:28
-- To change this template use File | Settings | File Templates.
--

cServerTrains = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cServerTrains:new(...)
    local obj = setmetatable({}, {__index = self});
    if obj.constructor then
        obj:constructor(...);
    end
    return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cServerTrains:constructor(...)
    -- Klassenvariablen --
    local trainAccelerationInfo = {}

    addEvent("trainSyncPulse", true)
    addEventHandler("trainSyncPulse", root,
        function(x, y, z, speed)
            if not isElementStreamedIn(source) then
                setElementPosition(source, x, y, z)
            else
                if not trainAccelerationInfo[source] then
                    trainAccelerationInfo[source] = {}
                end
                trainAccelerationInfo[source].speed = speed
                setTrainSpeed(source, speed)
            end
        end
    )


    addEventHandler("onClientElementStreamIn", root,
        function()
            if getElementData(source, "IsServerTrain") then
                local x, y, z = getElementPosition(source)

                if not trainAccelerationInfo[source] then
                    trainAccelerationInfo[source] = {}
                end

                trainAccelerationInfo[source].timer = setTimer(
                    function(train)
                        if trainAccelerationInfo[train].speed then
                            setTrainSpeed(train, trainAccelerationInfo[train].speed)
                        end
                    end,
                    200,
                    0,
                    source
                )

                -- Set a default speed to skip the small interval where trainSyncPulse will not be triggered (also depends on the serverside setting)
                setTrainSpeed(source, 0.7)
            end
        end
    )

    addEventHandler("onClientElementStreamOut", root,
        function()
            -- Do some cleanups
            if getElementData(source, "IsServerTrain") then
                if trainAccelerationInfo[source].timer and isTimer(trainAccelerationInfo[source].timer) then
                    killTimer(trainAccelerationInfo[source].timer)
                end
                trainAccelerationInfo[source] = nil
            end
        end
    )

    -- Funktionen --


    -- Events --
end

-- EVENT HANDLER --
