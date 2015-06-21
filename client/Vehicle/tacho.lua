--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

local dsdigi = dxCreateFont("res/fonts/DS-DIGI.ttf",8)

local sx,sy = guiGetScreenSize()

function renderTacho()
	if isPedInVehicle(getLocalPlayer()) then
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		dxDrawImage(sx-300, sy-300, 300, 300, "res/images/tacho/Background.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
		local color
		if getVehicleEngineState(theVehicle) then
			color = tocolor(255, 255, 255, 255)
		else
			color = tocolor(0, 0, 0, 125)
		end
		dxDrawImage(sx-200, sy-220, 40, 30, "res/images/tacho/Engine.png", 0, 0, 0, color, false)
			
		if (getVehicleOverrideLights(theVehicle) == 2) then
			color = tocolor(255, 255, 255, 255)
		else	
			color = tocolor(0, 0, 0, 125)
		end
		dxDrawImage(sx-150, sy-220, 30, 30, "res/images/tacho/Light.png", 0, 0, 0, color, false)
			
		dxDrawText(math.round(getElementSpeed(theVehicle)), sx-155, sy-145, sx-100, sy-100, tocolor(255, 255, 255, 255), 3.60, dsdigi, "right", "top", false, false, true, false, false)
		
		local npos = 0
		if (getElementSpeed(theVehicle)>182) then
			npos= 183+((getTickCount()%2)-1)
		else
			npos = getElementSpeed(theVehicle) - 3
		end
		
		dxDrawImage(sx-250, sy-160, 200, 6, "res/images/tacho/Nadel.png", npos, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(sx-300, sy-300, 300, 300, "res/images/tacho/Punkt.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end

addEventHandler("onClientVehicleEnter", getRootElement(), function(enterer)
	if (enterer == getLocalPlayer()) then
		addEventHandler("onClientRender",getRootElement(), renderTacho)
	end
end
)

addEventHandler("onClientVehicleExit", getRootElement(), function(exiter)
	if (exiter == getLocalPlayer()) then
		removeEventHandler("onClientRender",getRootElement(), renderTacho)
	end
end
)