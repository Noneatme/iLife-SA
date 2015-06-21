--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

addEvent("onClientStartPfandautomat", true)
addEvent("onClientStopPfandautomat", true)
addEvent("onClientPlayerHitsoundPlay", true);

addEvent("onClientGhostmodeElement", true)

local PfandautomatenSound = false

addEventHandler("onClientStartPfandautomat", getRootElement(),
	function(x,y,z)
		PfandautomatenSound = playSound3D("http://rewrite.ga/iLife/Pfandflaschenautomat.mp3", x, y, z, true)
		local int = getElementInterior(getLocalPlayer())
		local dim = getElementDimension(getLocalPlayer())
		setElementInterior(PfandautomatenSound, int)
		setElementDimension(PfandautomatenSound, dim)
	end
)

addEventHandler("onClientStopPfandautomat", getRootElement(),
	function()
		if (PfandautomatenSound) then
			stopSound(PfandautomatenSound)
			PfandautomatenSound = false
		end
	end
)

addCommandHandler("getpos", function(cmd, sTypes)
	if(localPlayer:getData("Adminlevel") >= 3) or (DEFINE_DEBUG) then
		local element = localPlayer
		if(localPlayer.vehicle) then
			element = localPlayer.vehicle
		end

		local x, y, z, rx, ry, rz
		if(element == localPlayer) then
			x, y, z 		= element:getPosition().x, element:getPosition().y, element:getPosition().z
			rx, ry, rz		= element:getRotation().x, element:getRotation().y, element:getRotation().z
		else
			x, y, z 		= element:getPosition()
			rx, ry, rz		= element:getRotation()
		end
		local sString		= x..", "..y..", "..z
		if(gettok(sTypes, 1, ",") == "strich") then
			sString = x.."|"..y.."|"..z

			if(gettok(sTypes, 2, ",") == "rot") then
				sString = sString.."|"..rx.."|"..ry.."|"..rz;
			end
		else
			sString = x..", "..y..", "..z

			if(gettok(sTypes, 2, ",") == "rot") then
					sString = sString..", "..rx..", "..ry..", "..rz;
			end
		end

		setClipboard(sString)
	end
end)

addEventHandler("onClientGhostmodeElement", getLocalPlayer(), function(uElement, iTime)
	if(uElement) and (isElement(uElement)) then
		if(isTimer(uElement.m_uGhostTimer)) then
			killTimer(uElement.m_uGhostTimer)
		end
		local alpha	= uElement:getAlpha()
		if iTime <= 1 then -- immer
			if iTime == 1 then -- anschalten
				setElementCollidableWith(uElement, getRootElement(), false)
				uElement:setAlpha(alpha >= 100 and alpha-100 or 0)
			elseif iTime == 0 then -- ausschalten
				setElementCollidableWith(uElement, getRootElement(), true)
				uElement:setAlpha(alpha <= 155 and alpha+100 or 255)
			end
			return true
		end

		setElementCollidableWith(uElement, getRootElement(), false)
		uElement:setAlpha((alpha > 0 and alpha-100) or 255)

		local function doTimerAgain()
			if(isElement(uElement)) then
				if(isTimer(uElement.m_uGhostTimer)) then
					killTimer(uElement.m_uGhostTimer)
				end
					uElement.m_uGhostTimer = setTimer(function()
						if(isElement(uElement)) then
							setElementCollidableWith(uElement, getRootElement(), true)

							uElement:setAlpha(alpha)
						end
					end, iTime or 5000, 1)
			end
		end

		doTimerAgain()
	end
end)

-- Doof, aber was solls --
addEventHandler("onClientRender", getRootElement(), function()
	if(getElementData(localPlayer, "jailed") == true) then
		toggleControl("enter_exit", false)
		toggleControl("jump", false)
		clientBusy = true;
	end

	if(config) then
		local free = tonumber(dxGetStatus()["VideoMemoryFreeForMTA"]);

		if(free) and (free < 1) then
			if not(toboolean(config:getConfig("lowrammode"))) then
				config:setConfig("lowrammode", true)
				outputChatBox("[Info] Da kein Videospeicher mehr verfuegbar ist, wurde der Low-Memory Modus aktiviert.", 255, 0, 0)
			end
		end
	end
end)

addEventHandler("onClientExplosion", getRootElement(), function(x, y, z, iType)
	if(iType == 9) then									-- Objekt (Washgaspump)
		if(localPlayer:getDimension() == 0) then		-- Aussenwelt
			cancelEvent()								-- Keine Explosion
		end
	end
end)

addEvent("onClientPlayerJailControlsActivate", true)
addEventHandler("onClientPlayerJailControlsActivate", getLocalPlayer(), function()
	toggleControl("enter_exit", true)
	toggleControl("jump", true)
	clientBusy = false;
end)

--addEventHandler("onClientObjectBreak", getRootElement(), function() cancelEvent() end )

addEventHandler ( "onClientPlayerWeaponSwitch", getRootElement(),
	function( prevSlot, newSlot )
		if getKeyState("tab") then
			setPedWeaponSlot (localPlayer, prevSlot)
		end
	end
)

addEventHandler("onClientPedWasted", getRootElement(),
	function(killer)
		if (killer == getLocalPlayer()) then
			if (getElementModel(source) == 2) then
				triggerServerEvent("onClientUnlockedAchievement", getRootElement(), 42)
			end
		end
	end
)
addEventHandler("onClientPedDamage", getRootElement(),
	function()
		if(getElementData(source, "inv") == true) then
			cancelEvent()
		end
	end
)
addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon)
	if(getElementData(localPlayer, "zuschauer")) then
		cancelEvent()
	end
	if(getElementData(localPlayer, "m_bLSPD_SWAT") == true) or (getElementData(localPlayer, "crack") == true) then
		if(weapon == 17) then	-- Teargas
			cancelEvent()
		end
	end
end
)

addEventHandler("onClientPlayerChoke", localPlayer, function()
	if(getElementData(localPlayer, "m_bLSPD_SWAT") == true) then
		cancelEvent()
	end
end)
function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
	if (weapon and getElementModel(source) == 601) then
		-- A weapon was used and the vehicle model ID is that of the SWAT tank so cancel the damage.
		cancelEvent()
	end
end
addEventHandler("onClientVehicleDamage", getRootElement(), function(attacker, weapon, loss, x, y, z, tyre)
	if(tyre) then
		if not(getVehicleOccupant(source)) then
			cancelEvent()
		end
	end
end)

addEventHandler("onClientVehicleExplode", getRootElement(), function()
	local x, y, z	= source:getPosition()
	createExplosion(x, y, z, 7, false, -1.0, false)
	source:setTurnVelocity(math.random(-100, 100)/1000, math.random(-100, 100)/1000, math.random(-100, 100)/1000)
end)
--[[
addEventHandler("onClientVehicleCollision", getRootElement(),
	function (theElement)
		if (theElement) then
			if (source == getPedOccupiedVehicle(getLocalPlayer())) and (theElement ~= source) then
				if (getElementType(theElement) == "vehicle") and (getVehicleOccupants(theElement)) then
					for k,v in pairs(getVehicleOccupants(theElement)) do
						if (getElementData(v, "CaseHolder")) and (v ~= localPlayer) and (getElementData(v, "CaseHolder") == true) then
							triggerServerEvent("onBriefcaseCarHit", localPlayer)
							return true
						end
					end
				end
			end
		end
	end
)
]]

addEventHandler("onClientPlayerHitsoundPlay", getLocalPlayer(), function(uPlayer, iLoss)
	if(hitsoundEnabled) then
		local sPfad     = "res/sounds/hitmarker.ogg";
		local s         = playSound(sPfad, false);

		setSoundVolume(s, 0.5);

		local x, y, z 		= getElementPosition(uPlayer)
		local x2, y2, z2	= getElementPosition(localPlayer)
		z = z+1;

		local timestamp	= getTickCount();
		local curAddY	= 1;

		local function renderThis()
			curAddY	= curAddY+0.5;
			local sx, sy = getScreenFromWorldPosition(x, y, z);

			if(sx) and (sy) then
				local distance		= getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);
				local fontbig = 3-(distance/10)
				dxDrawText("-"..iLoss, sx+2, sy+2-curAddY, sx, sy-curAddY, tocolor(0, 255, 0, 200), fontbig, "default-bold", "center")
			end

			if(getTickCount()-timestamp > 2000) then
				removeEventHandler("onClientRender", root, renderThis)
			end
		end

		addEventHandler("onClientRender", root, renderThis)
	end
end)


addEvent("onJSONResultGet", true)
addEventHandler("onJSONResultGet", getLocalPlayer(), function(result)
	local file = fileCreate("json.json");
	fileWrite(file, toJSON(result))
	fileFlush(file)
	fileClose(file);
end)


_engineLoadDFF = engineLoadDFF
function engineLoadDFF(sF, ...)
	return _engineLoadDFF(string.lower(sF), ...)
end

_engineLoadCOL = engineLoadCOL
function engineLoadCOL(sF, ...)
	return _engineLoadCOL(string.lower(sF), ...)
end

_engineLoadTXD = engineLoadTXD
function engineLoadTXD(sF, ...)
	return _engineLoadTXD(string.lower(sF), ...)
end

_dxCreateTexture = dxCreateTexture
function _dxCreateTexture(tex, ...)
	return _dxCreateTexture(string.lower(tex), ...)
end


function writeDumpFile()
	local file 		= fileCreate("dump.txt")
	local status	= dxGetStatus()
	table.sort(status, function(a, b) return tostring(a) < tostring(b) end)

	fileWrite(file, "// ".._Gsettings.serverName.." DUMP //\n")
	fileWrite(file, "Playername: "..getPlayerName(localPlayer).."\n")
	fileWrite(file, "Date: "..getCurrentDateWithTime().."\n")
	fileWrite(file, "LOC: "..getLocalization()["code"]..", "..getLocalization()["name"].."\n")

	fileWrite(file, "\n\n// DirectX Status //\n");

	for index, v in next, status do
		fileWrite(file, index..": "..tostring(v).."\n");
	end

	local columns, rows = getPerformanceStats("")

	fileWrite(file, "\n\n// Performance Status //\n");
	fileWrite(file, table.concat(columns, "  ").."\n");

	for i, row in ipairs(rows) do
		fileWrite(file, table.concat(row, "  ").."\n");
	end

	fileWrite(file, "\n\n// Network Status //\n");

	for index, v in pairs(getNetworkStats ( )) do
		fileWrite(file, index..": "..tostring(v).."\n");
	end
	fileWrite(file, "\n\n// Network Usage  //\n");

	for index, v in pairs(getNetworkUsageData ( )) do
		fileWrite(file, index..": "..tostring(v).."\n");
		for in2, b2 in pairs(v) do
			fileWrite(file, in2..": "..tostring(b2).."\n");
			for in3, b3 in pairs(b2) do
				fileWrite(file, in3..": "..tostring(b3).." ");
			end
		end
	end

	fileFlush(file)
	fileClose(file)

	if(toboolean(config:getConfig("allow_dump_upload"))) then

	end
end

addCommandHandler("dump", writeDumpFile)



_dxCreateRenderTarget = dxCreateRenderTarget

function dxCreateRenderTarget(...)
	local rt = _dxCreateRenderTarget(...)

	return rt;
end


if((tonumber(dxGetStatus()["VideoCardRAM"]) or 1024) <= 512) then
	outputChatBox("[Warnung] Deine Grafikkarte besitzt weniger/gleich 512MB Grafikspeicher.", 255, 255, 0)
	outputChatBox("Es werden mindestens 1024 MB benoetigt. Manche Funktionen werden nicht richtig Laufen!", 255, 255, 0)
end

if(dxGetStatus()["Setting32BitColor"] == false) then
	outputChatBox("[Warnung] Du spielst in einer 16 Bit Farbtiefe. 32-Bit ist in den MTA Grafikoptionen vorhanden.", 255, 255, 0)
end


-- PlaySound April 1st --
DEFINE_APRILSCHERZ		= true;

local function activateApril1st()
	_playSound	= playSound

	function playSound(...)
		local s = _playSound(...)
		setSoundEffectEnabled(s, "i3dl2reverb", true)
		return s
	end

		local lampIndex	= 1
		local lampTimerFunc		= function()
			if(lampIndex == 1) then
				setTrafficLightState("green", "green")
				lampIndex = 2
			elseif(lampIndex == 2) then
				setTrafficLightState("yellow", "yellow")
				lampIndex = 3
			elseif(lampIndex == 3) then
				setTrafficLightState("red", "red")
				lampIndex = 1

			end
		end

		local lampTimer		= setTimer(lampTimerFunc, 100, -1)

	local skyIndex	= 1;
	setTimer(function()
	--	if(skyIndex < 10) then
			setSkyGradient(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
			setWindVelocity(math.random(2, 10), math.random(2, 10), math.random(0, 10))
			setWaterColor(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255)
	--	else
	--		resetSkyGradient()
	--		resetWaterColor()
	--		resetWindVelocity()
	--	end

		skyIndex = skyIndex+1
	end, 60000, -1)


	addEventHandler("onClientPlayerVehicleExit", localPlayer, function(uVehicle)
		local x, y, z = getElementVelocity(uVehicle)
		setElementVelocity(uVehicle, x, y, z+0.15)
	end)
	addEventHandler("onClientVehicleStartEnter", root, function(lp, uVehicle)
		if(lp == localPlayer) then
			uVehicle = source
			local x, y, z = getElementVelocity(uVehicle)
			setElementVelocity(uVehicle, x+math.random(-200, 200)/1000, y+math.random(-200, 200)/1000, z+math.random(-200, 200)/1000)
		end
	end)
	setTimer(function()
		local uVehicle	= localPlayer.vehicle
		if(uVehicle) and (isElement(uVehicle)) then

			local randdoor	= math.random(0, 5)
			setVehicleDoorOpenRatio(uVehicle, randdoor, math.random(1, 100)/100, math.random(500, 2000))
		end
	end, 5000, -1)
end

if(DEFINE_APRILSCHERZ) then
	if(getRealTime) then
		if(getRealTime().monthday == 1) and (getRealTime().month+1 == 4) then
			activateApril1st()
		end
	end
end
