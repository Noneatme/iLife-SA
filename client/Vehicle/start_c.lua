--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

sx, sy = guiGetScreenSize()

setAmbientSoundEnabled( "gunfire", false )

function formNumberToMoneyString ( value )
	if tonumber ( value ) then
		value = tostring ( value )
		if string.sub ( value, 1, 1 ) == "-" then
			return "-"..setDotsInNumber ( string.sub ( value, 2, #value ) ).." $"
		else
			return setDotsInNumber ( value ).." $"
		end
	end
	return false
end

function setDotsInNumber ( value )
	if #value > 3 then
		return setDotsInNumber ( string.sub ( value, 1, #value - 3 ) ).."."..string.sub ( value, #value - 2, #value )
	else
		return value
	end
end

function playServerSound(x,y,z,url)
	playSound3D (url, x, y, z, false)
end
addEvent("onServerPlaySound", true)
addEventHandler("onServerPlaySound", getRootElement(), playServerSound)

local playedSounds = {}

function playServerSavedSound(url, name, looped)
	if (playedSounds[name] and isElement(playedSounds[name])) then
		destroyElement(playedSounds[name])
	end
	playSound(url,looped)
end
addEvent("onServerPlaySavedSound", true)
addEventHandler("onServerPlaySavedSound", getRootElement(), playServerSavedSound)

function stopServerSavedSound(name)
	if (playedSounds[name] and isElement(playedSounds[name])) then
		destroyElement(playedSounds[name])
	end
end
addEvent("onServerStopSavedSound", true)
addEventHandler("onServerStopSavedSound", getRootElement(), stopServerSavedSound)


screenX,screenY = guiGetScreenSize()

function isCursorOverRectangle(cX,cY,rX,rY,width,height)
	if isCursorShowing() then
		return ((cX*screenX > rX) and (cX*screenX < rX+width)) and ( (cY*screenY > rY) and (cY*screenY < rY+height))
	else
		return false
	end
end

addEventHandler("onClientPlayerVoiceStart", getRootElement(),
function()
	local x1,y1,z1 = getElementPosition(localPlayer)
	local x2,y2,z2 = getElementPosition(source)
	if ( getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) > 20) then
		cancelEvent()
	end	
end
)

addEventHandler("onClientElementDataChange", getLocalPlayer(),
	function(theName)
		if (theName == "Geld") then
			setPlayerMoney(getElementData(source, "Geld"))
		end
	end
)

--[[
local billboardSmall = dxCreateShader("res/shader/texture.fx")
dxSetShaderValue(billboardSmall,"Tex",dxCreateTexture("res/images/bg.png"))
engineApplyShaderToWorldTexture(billboardSmall,"diderSachs01")
engineApplyShaderToWorldTexture(billboardSmall,"homies_2")
--heat_02,diderSachs01, cokopos_1, eris_2, homies_2, hardon_1, eris_1, diderSachs01, homies_2, prolaps01, bobo_2
--]]

addEvent("ghostElement", true)
addEventHandler("ghostElement", getRootElement(),
	function()
		for k,v in ipairs(getElementsByType("vehicle")) do
			setElementCollidableWith(source, v, false)
		end
		
	end
)

addEvent("onHudBlipRefresh", true)
addEventHandler("onHudBlipRefresh",getRootElement(),
	function() 
		if (hud) and (hud.hudObjects) and (hud.hudObjects["radar"]) then
		hud.hudObjects["radar"]:RefreshALShape() 
		setTimer(function() hud.hudObjects["radar"]:RefreshALShape() end, 500,1)
		end
	end
)

--[[
escapePressed = false

function playerPressedKey(button, press)
    if ( (button == "escape") and (press) ) then
        if ( not (escapePressed) ) then
			cancelEvent()
			escapePressed = true
			--Show Menu
			showMainMenu()
			outputChatBox("Show")
		else
			escapePressed = false
			--Hide Menu
			destroyMainMenu()
			outputChatBox("Hide")
		end
	else
	
    end
end
addEventHandler("onClientKey", root, playerPressedKey)
]]

Sounds = {}
Sounds["Loopsounds"] = {}

function playClientSound(path, volume, loop)
	if (loop) then
		if (not (Sounds["Loopsounds"][path])) then
			Sounds["Loopsounds"][path] = playSound(path, true)
			setSoundVolume(Sounds["Loopsounds"][path], volume)
		end
	else
		playSound(path, false)
	end
end
addEvent("onClientPlaySound", true)
addEventHandler("onClientPlaySound", getRootElement(), playClientSound)

function stopClientSound(path)
	if ((Sounds["Loopsounds"][path])) then
		stopSound(Sounds["Loopsounds"][path])
		Sounds["Loopsounds"][path] = nil
	end
end
addEvent("onClientStopSound", true)
addEventHandler("onClientStopSound", getRootElement(), stopClientSound)

function playClientSound3D(path, x, y, z, volume, loop)
	if (loop) then
		Sounds["Loopsounds"][path] = playSound3D(path, x, y, z, true)
		setSoundVolume(Sounds["Loopsounds"][path])
	else
		playSound3D(path, x, y, z, false)
	end
end
addEvent("onClientPlaySound3D", true)
addEventHandler("onClientPlaySound3D", getRootElement(), playClientSound3D)


addEvent("pedCanBeKnockedOffBike",true)
addEventHandler("pedCanBeKnockedOffBike",getRootElement(),
function()
	   if canPedBeKnockedOffBike ( source ) then
        setPedCanBeKnockedOffBike ( source, false )
    else
        setPedCanBeKnockedOffBike ( source, true )

    end
end)

addEventHandler("onClientPedDamage", getRootElement(), function(attacker, weapon, bodypart, loss)
	if (getElementData(source, "EastereggPed")) then
		cancelEvent()
	end
end
)

addEventHandler("onClientPedDamage", getRootElement(), function(attacker, weapon, bodypart, loss)
	if (getElementData(source, "FactionPed")) then
		cancelEvent()
	end
end
)



local getroffen = false


weaponDamages = {}
weaponDamages[8] = 30
weaponDamages[22] = 9
weaponDamages[23] = 9
weaponDamages[24] = 22.5
weaponDamages[25] = 18
weaponDamages[26] = 9
weaponDamages[27] = 7.2
weaponDamages[28] = 13.5
weaponDamages[29] = 9
weaponDamages[32] = 13.5
weaponDamages[30] = 7.2
weaponDamages[31] = 5.4
weaponDamages[33] = 18
weaponDamages[34] = 45
weaponDamages[35] = 45
weaponDamages[36] = 40.5	
weaponDamages[51] = 9
--auch in Server anpassen


function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	if hitElement then
		local hx, hy, hz = getElementPosition(hitElement)
		if math.sqrt((hitX-hx)^2) <= 0.42 and math.sqrt((hitY-hy)^2) <= 0.42 and math.sqrt((hitZ-hz)^2) <= 1.05 then
			getroffen = true
		else
			getroffen = false
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFireFunc)

--[[
function cancelAllDamage ( attacker, weapon, bodypart, loss )
	if attacker == localPlayer then
		if attacker and weapon and bodypart and loss then
			if weaponDamages[weapon] then
				setTimer(sendData, 50, 1, localPlayer, attacker, weapon, bodypart, loss, source)
				cancelEvent ()
			end
		end
	elseif localPlayer == source then
		if attacker and weapon and bodypart and loss then
			if weaponDamages[weapon] then
				cancelEvent ()
			end
		end
	end
end
addEventHandler ( "onClientPlayerDamage", getRootElement(), cancelAllDamage )

function sendData (a,b,c,d,e,f,g)
	if getroffen then
		triggerServerEvent ( "qwertz", a, b, c, d, e, f, g)
		getroffen = false
	end
end]]