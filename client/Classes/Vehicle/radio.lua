--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local RadioChannels = {}
local SelectedRadioChannel = 0
local RadioSound = false
local RadioStartRender = 0
local sx,sy = guiGetScreenSize()
local radioFont = dxCreateFont("/res/fonts/DS-DIGI.ttf", 30, true)


local function recieveRadioChannels(Channeldata)
	RadioChannels = Channeldata
end

addEvent("onRadioChannelsRecieve", true)
addEventHandler("onRadioChannelsRecieve", getRootElement(), recieveRadioChannels)


function stopRadioRendering()
    RadioStartRender = 0
    removeEventHandler("onClientRender", getRootElement(), radioRendering)
end


function radioRendering()
    if (getTickCount()-RadioStartRender > 4000) then
        stopRadioRendering()
    end
    if (SelectedRadioChannel ~= 0) then
        dxDrawText(RadioChannels[SelectedRadioChannel]["NAME"], 0, 0, sx, sy, tocolor(184,134,11,255), 1, radioFont, "center", "top")
    else
        dxDrawText("Radio aus", 0, 0, sx, sy, tocolor(255,0,0,255), 1, radioFont, "center", "top")
    end
end

function startRadioRendering()
    RadioStartRender = getTickCount()
    addEventHandler("onClientRender", getRootElement(), radioRendering)
end



local function callServer()
	triggerServerEvent("requestRadioChannels", getRootElement())
end
addEventHandler("onClientResourceStart", getRootElement(), callServer)

local function radioDisable(thePlayer,  seat)
    if (not (thePlayer) or thePlayer == getLocalPlayer() or getLocalPlayer() == source) then
        if (RadioSound and isElement(RadioSound)) then
            destroyElement(RadioSound)
        end
        stopRadioRendering()
    end
end

local function vehHasRadio(theVehicle)
	if (isElement(theVehicle) and getElementType(theVehicle) == "vehicle") then
		--if (getElementData(theVehicle,"hasRadio")== 1) then
			return true
		else
			return false
		--end
	end
end

local function radioSwitch(dir)
	if (getKeyState("tab")) or (clientBusy) then
		cancelEvent()
		return false
	end
	local vehicle = getPedOccupiedVehicle(source)
	if (not vehicle) then
		radioDisable()
		return true
	end
	if (vehicle and vehHasRadio(vehicle)) then
		if (dir ==1)  then
			if (SelectedRadioChannel < #RadioChannels) then
				SelectedRadioChannel = SelectedRadioChannel+1
			else
				SelectedRadioChannel = 0
			end
		end
		if (dir ==12)  then
			if (SelectedRadioChannel <= 0) then
				SelectedRadioChannel = #RadioChannels
			else
				SelectedRadioChannel = SelectedRadioChannel-1
			end
		end
	end
	radioDisable()
	if (SelectedRadioChannel ~= 0) then
		RadioSound = playSound(RadioChannels[SelectedRadioChannel]["URL"])
	end
	stopRadioRendering()
	startRadioRendering()
	if (dir ~= 0) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerRadioSwitch", getRootElement(), radioSwitch)
addEvent("onCustomClientPlayerRadioSwitch", true)
addEventHandler("onCustomClientPlayerRadioSwitch", getRootElement(), radioSwitch)

local function onEnterRadioEnable(thePlayer, seat)
	if (thePlayer == getLocalPlayer()) then
		vehicle = getPedOccupiedVehicle(thePlayer)
		if (vehicle and vehHasRadio(vehicle)) then
			setRadioChannel(0)
			if (SelectedRadioChannel ~= 0) then
				RadioSound = playSound(RadioChannels[SelectedRadioChannel]["URL"])
			end
		end
	end
end

addEventHandler("onClientVehicleEnter", getRootElement(), onEnterRadioEnable)

addEventHandler("onClientVehicleExit", getRootElement(), radioDisable)
addEventHandler("onClientVehicleStartExit", getRootElement(), radioDisable)
addEventHandler("onClientPlayerWasted", getLocalPlayer(), radioDisable)

