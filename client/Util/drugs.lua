--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- Muss bei Zeiten neu geschrieben werden, in eine Managerklasse integrieren und ein Screensource fuer jeden Shader benutzen

local drugShader, drugTec
local screenWidth, screenHeight = guiGetScreenSize()
local myScreenSource = dxCreateScreenSource(screenWidth, screenHeight)
local centerX, centerY = 0.5, 0.5
local centerRotation = 0
local centerDistance = 0
local isPlayerHigh = false

-- Alkohol
local effectDuration = 120000 -- Länge des Rausches in Millisekunden

local showVignette = true -- Vignette am Rand
local vignetteRadius = 0.7 -- wie groß soll Vignette angezeigt werden
local vignetteStrength = 0.3 -- wie stark soll Vignette angezeigt werden

local invertedColors = false -- Negativ farben
local switchColors = false -- Farben vertauschen
local increaseColors = false -- Farben verstärken

local singleColorEffect = false -- Bild einfärben
local singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

local shakingEnabled = true -- wackelndes Bild
local maxShakingStrength = 0.2 -- wie stark soll Bild wackeln(0 - 1)

local blurEnabled = true -- Bild verschwommen
local maxBlurStrength = 2 -- wie stark soll Bild verschwommen sein (0 - ?)
-- --]]

--[[ Shroom
local effectDuration = 120000 -- Länge des Rausches in Millisekunden

local showVignette = true -- Vignette am Rand
local vignetteRadius = 0.7 -- wie groß soll Vignette angezeigt werden
local vignetteStrength = 0.3 -- wie stark soll Vignette angezeigt werden

local invertedColors = false -- Negativ farben
local switchColors = true -- Farben vertauschen
local increaseColors = false -- Farben verstärken

local singleColorEffect = false -- Bild einfärben
local singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

local shakingEnabled = false -- wackelndes Bild
local maxShakingStrength = 0.0 -- wie stark soll Bild wackeln(0 - 1)

local blurEnabled = true -- Bild verschwommen
local maxBlurStrength = 0.5 -- wie stark soll Bild verschwommen sein (0 - ?)
-- --]]

--[[ Meth
local effectDuration = 120000 -- Länge des Rausches in Millisekunden

local showVignette = true -- Vignette am Rand
local vignetteRadius = 0.7 -- wie groß soll Vignette angezeigt werden
local vignetteStrength = 0.5 -- wie stark soll Vignette angezeigt werden

local invertedColors = false -- Negativ farben
local switchColors = false -- Farben vertauschen
local increaseColors = true -- Farben verstärken

local singleColorEffect = false -- Bild einfärben
local singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

local shakingEnabled = true -- wackelndes Bild
local maxShakingStrength = 0.1 -- wie stark soll Bild wackeln(0 - 1)

local blurEnabled = true -- Bild verschwommen
local maxBlurStrength = 0.1 -- wie stark soll Bild verschwommen sein (0 - ?)
-- --]]

--[[ Kokain
local effectDuration = 120000 -- Länge des Rausches in Millisekunden

local showVignette = true -- Vignette am Rand
local vignetteRadius = 0.7 -- wie groß soll Vignette angezeigt werden
local vignetteStrength = 0.5 -- wie stark soll Vignette angezeigt werden

local invertedColors = false -- Negativ farben
local switchColors = false -- Farben vertauschen
local increaseColors = true -- Farben verstärken

local singleColorEffect = false -- Bild einfärben
local singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

local shakingEnabled = true -- wackelndes Bild
local maxShakingStrength = 0.1 -- wie stark soll Bild wackeln(0 - 1)

local blurEnabled = true -- Bild verschwommen
local maxBlurStrength = 0.2 -- wie stark soll Bild verschwommen sein (0 - ?)
-- --]]

--[[ XTC
local effectDuration = 120000 -- Länge des Rausches in Millisekunden

local showVignette = true -- Vignette am Rand
local vignetteRadius = 0.7 -- wie groß soll Vignette angezeigt werden
local vignetteStrength = 0.5 -- wie stark soll Vignette angezeigt werden

local invertedColors = false -- Negativ farben
local switchColors = true -- Farben vertauschen
local increaseColors = true -- Farben verstärken

local singleColorEffect = true -- Bild einfärben
local singleColorR, singleColorG, singleColorB, singleColorA = 100, 100, 180, 255 -- Farbe zum einfärben

local shakingEnabled = true -- wackelndes Bild
local maxShakingStrength = 0.1 -- wie stark soll Bild wackeln(0 - 1)

local blurEnabled = true -- Bild verschwommen
local maxBlurStrength = 0.2 -- wie stark soll Bild verschwommen sein (0 - ?)
-- --]]

local count =
{
	[9]=0,
	[10]=0,
	[11]=0,
	[12]=0,
	[14]=0
}

local Enton = {}
local EntonSounds = {}

local constructors ={
[11] = function()
		if (isTimer(Entontimer)) then
			killTimer(Entontimer)
		end
		Entontimer = setTimer(function()
				local px,py,pz = getElementPosition(getLocalPlayer())

				if (#Enton > 40) then
					for k,v in ipairs(Enton) do
						destroyElement(v)
					end
					Enton = {}
				end

				table.insert(Enton, createPed(2, px+1, py, pz, math.random(1,359)))
				for k,v in ipairs(Enton) do
					if (isElement(v)) then
						local x,y,z = getElementPosition(v)
						if (getDistanceBetweenPoints3D(px,py,pz,x,y,z) < 15) then
							setTimer(
							function()
								if (isElement(Enton[k])) then
									EntonSounds[k] = playSound3D("http://rewrite.ga/iLife/enton.mp3", x,y,z, false)
									attachElements(EntonSounds[k], Enton[k])
								end
							end, math.random(100,1600), 1)
						end
						setPedControlState ( v, "forwards", (math.random(1,2) == 2) )
						setPedControlState ( v, "backwards", (math.random(1,2) == 2) )
						setPedControlState ( v, "left", (math.random(1,2) == 2) )
						setPedControlState ( v, "right", (math.random(1,2) == 2) )

						setPedControlState ( v, "jummp", (math.random(1,2) == 2) )
						setPedControlState ( v, "sprint", (math.random(1,2) == 2) )
						setPedControlState ( v, "walk", (math.random(1,2) == 2) )
						if (count[11] == 0) then
							destructors[11]()
						end
					end
				end
			end, 2000, -1)
	end
}

local destructors ={
[11] = function(bool)
	for k,v in ipairs(Enton) do
		if (isElement(v)) then
			destroyElement(v)
		end
	end
	setWindVelocity(0,0,0)
	if not(bool) then
		if (isTimer(Entontimer)) then
			killTimer(Entontimer)
		end
	end
end
}

function setDrugVariables(ID)
	if (ID == 9) then
		-- Meth
		effectDuration = 120000*count[ID] -- Länge des Rausches in Millisekunden
		showVignette = true -- Vignette am Rand
		vignetteRadius = 0.7-(count[ID]*0.05) -- wie groß soll Vignette angezeigt werden
		vignetteStrength = 0.5-(count[ID]*0.05) -- wie stark soll Vignette angezeigt werden

		invertedColors = false -- Negativ farben
		switchColors = false -- Farben vertauschen
		increaseColors = true -- Farben verstärken

		singleColorEffect = false -- Bild einfärben
		singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

		shakingEnabled = true -- wackelndes Bild
		maxShakingStrength = 0.1+(count[ID]*0.02) -- wie stark soll Bild wackeln(0 - 1)

		blurEnabled = true -- Bild verschwommen
		maxBlurStrength = 0.1+(count[ID]*0.05) -- wie stark soll Bild verschwommen sein (0 - ?)
		-- --]]
		return true
	end
	if (ID == 10) then
		-- Weed
		effectDuration = 120000*count[ID] -- Länge des Rausches in Millisekunden

		showVignette = true -- Vignette am Rand
		vignetteRadius = 0.9-(count[ID]*0.05) -- wie groß soll Vignette angezeigt werden
		vignetteStrength = 0.2+(count[ID]*0.03) -- wie stark soll Vignette angezeigt werden

		invertedColors = false -- Negativ farben
		switchColors = false -- Farben vertauschen
		increaseColors = true -- Farben verstärken

		singleColorEffect = false -- Bild einfärben
		singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

		shakingEnabled = true -- wackelndes Bild
		maxShakingStrength = 0.0+(count[ID]*0.03) -- wie stark soll Bild wackeln(0 - 1)

		blurEnabled = true -- Bild verschwommen
		maxBlurStrength = 0.05+(count[ID]*0.025) -- wie stark soll Bild verschwommen sein (0 - ?)
		-- --]]
	end
	if (ID == 11) then
		-- Mushrooms
		setWindVelocity(100, 100, 100)
		effectDuration = 120000*count[ID] -- Länge des Rausches in Millisekunden

		showVignette = true -- Vignette am Rand
		vignetteRadius = 0.7-(count[ID]*0.05) -- wie groß soll Vignette angezeigt werden
		vignetteStrength = 0.3+(count[ID]*0.1) -- wie stark soll Vignette angezeigt werden

		invertedColors = (count[ID] > 2) -- Negativ farben
		switchColors = true -- Farben vertauschen
		increaseColors = true -- Farben verstärken

		singleColorEffect = true -- Bild einfärben
		singleColorR, singleColorG, singleColorB, singleColorA = 50, 50, 125, 125 -- Farbe zum einfärben

		shakingEnabled = false -- wackelndes Bild
		maxShakingStrength = 0.0 -- wie stark soll Bild wackeln(0 - 1)

		blurEnabled = true -- Bild verschwommen
		maxBlurStrength = 0.5+(count[ID]*0.1) -- wie stark soll Bild verschwommen sein (0 - ?)
	else
		setWindVelocity(0, 0, 0)
	end
	if (ID == 12) then
		-- XTC
		effectDuration = 120000*count[ID] -- Länge des Rausches in Millisekunden

		showVignette = true -- Vignette am Rand
		vignetteRadius = 0.8-(count[ID]*0.05) -- wie groß soll Vignette angezeigt werden
		vignetteStrength = 0.2+(count[ID]*0.03) -- wie stark soll Vignette angezeigt werden

		invertedColors = false -- Negativ farben
		switchColors = false -- Farben vertauschen
		increaseColors = true -- Farben verstärken

		singleColorEffect = false -- Bild einfärben
		singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

		shakingEnabled = true -- wackelndes Bild
		maxShakingStrength = 0.0+(count[ID]*0.03) -- wie stark soll Bild wackeln(0 - 1)

		blurEnabled = true -- Bild verschwommen
		maxBlurStrength = 0.2+(count[ID]*0.05) -- wie stark soll Bild verschwommen sein (0 - ?)
		-- --]]
	end
	if (ID == 14) then
		--Kokain
		effectDuration = 120000*count[ID] -- Länge des Rausches in Millisekunden

		showVignette = true -- Vignette am Rand
		vignetteRadius = 0.7-(count[ID]*0.05) -- wie groß soll Vignette angezeigt werden
		vignetteStrength = 0.5-(count[ID]*0.05) -- wie stark soll Vignette angezeigt werden

		invertedColors = false -- Negativ farben
		switchColors = false -- Farben vertauschen
		increaseColors = true -- Farben verstärken

		singleColorEffect = false -- Bild einfärben
		singleColorR, singleColorG, singleColorB, singleColorA = 190, 190, 190, 255 -- Farbe zum einfärben

		shakingEnabled = true -- wackelndes Bild
		maxShakingStrength = 0.1+(count[ID]*0.02) -- wie stark soll Bild wackeln(0 - 1)

		blurEnabled = true -- Bild verschwommen
		maxBlurStrength = 0.1+(count[ID]*0.05) -- wie stark soll Bild verschwommen sein (0 - ?)
		-- --]]
	end
end

addEvent("onClientStartDrugEffect", true)
addEventHandler("onClientStartDrugEffect", getRootElement(),
	function(ID)
		for k,v in pairs(count) do
			if (tostring(k) ~= tostring(ID)) then
				if (v > 0) then
					if (destructors[ID]) then
						destructors[ID]()
					end
				end
				count[k] = 0
			end
		end
		count[ID]=count[ID]+1
		setDrugVariables(ID)

		setIsPlayerHigh("true")
		if (constructors[ID]) then
			constructors[ID]()
		end


		if (isTimer(cooldownTimer)) then
			killTimer(cooldownTimer)
		end

		cooldownTimer = setTimer(
			function(ID)
				count[ID] = count[ID]-1
				setDrugVariables(ID)
				if (count[ID] == 0) then
					setWindVelocity(0, 0, 0)
				end
				if (destructors[ID]) then
					destructors[ID]()
				end
			end, 120000, count[ID], ID
		)
		return
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if getVersion ().sortable < "1.3.1" then
			return
		else
			drugShader, drugTec = dxCreateShader("res/shader/drug.fx")

			if (not drugShader) then
			else
				if (rainbowColorsEnabled == "true") then
					setRandomColor()
				end
			end
		end
	end
)


addEventHandler("onClientResourceStop", resourceRoot,
function()
	if (drugShader) then
		destroyElement(drugShader)
		drugShader = nil
	end
end)


-- // start & stop effect // --
function setIsPlayerHigh(bool)
	if (bool == "true") then
		if (isTimer(DrugTimer)) then
			killTimer(DrugTimer)
		end
		if ( not ((effectDuration) or (effectDuration < 50))) then
			effectDuration = 120000
		end
		DrugTimer = setTimer(setIsPlayerHigh, effectDuration, 1, "false")
	end
	isPlayerHigh = bool
end

function getIsPlayerHigh()
	return isPlayerHigh
end


-- // update and render shader // --
local currentBlur = 0
local fadeValue = 1

addEventHandler("onClientPreRender", root,
function()
    if (drugShader) then
		if (getIsPlayerHigh() == "true") then
			if (blurEnabled == true) then
				currentBlur = currentBlur + maxBlurStrength/250

				if (currentBlur >= maxBlurStrength) then
					currentBlur = maxBlurStrength
				end
			end

			if (shakingEnabled == true) then
				centerRotation = centerRotation + 1

				if (centerRotation >= 360) then
					centerRotation = 0
				end

				centerDistance = centerDistance + maxShakingStrength/250

				if (centerDistance >= maxShakingStrength) then
					centerDistance = maxShakingStrength
				end

				centerX, centerY = getDistanceRotation(0.5, 0.5, centerDistance, centerRotation)
			end

			fadeValue = fadeValue - maxBlurStrength/250

			if (fadeValue <= 0) then
				fadeValue = 0
			end
		else
			if (blurEnabled == true) then
				currentBlur = currentBlur - maxBlurStrength/100

				if (currentBlur <= 0) then
					currentBlur = 0
				end
			end

			if (shakingEnabled == true) then
				centerRotation = centerRotation - 1

				if (centerRotation <= 0) then
					centerRotation = 0
				end

				centerDistance = centerDistance - maxShakingStrength/100

				if (centerDistance <= 0) then
					centerDistance = 0
				end

				centerX, centerY = getDistanceRotation(0.5, 0.5, centerDistance, centerRotation)
			end

			fadeValue = fadeValue + 0.01

			if (fadeValue >= 1) then
				fadeValue = 1
			end
		end
    end
	if (drugShader) then
		if (getIsPlayerHigh() == "true") then
			dxUpdateScreenSource(myScreenSource)

			dxSetShaderValue(drugShader, "screenSource", myScreenSource)
			dxSetShaderValue(drugShader, "shaderColor", {singleColorR/255, singleColorG/255, singleColorB/255, singleColorA/255})
			dxSetShaderValue(drugShader, "uvCenter", {centerX, centerY})
			dxSetShaderValue(drugShader, "blurEnabled", blurEnabled)
			dxSetShaderValue(drugShader, "blurStrength", currentBlur/10)
			dxSetShaderValue(drugShader, "fadeValue", fadeValue)
			dxSetShaderValue(drugShader, "invertedColors", invertedColors)
			dxSetShaderValue(drugShader, "singleColorEffect", singleColorEffect)
			dxSetShaderValue(drugShader, "showVignette", showVignette)
			dxSetShaderValue(drugShader, "vignetteRadius", vignetteRadius)
			dxSetShaderValue(drugShader, "vignetteStrength", vignetteStrength)
			dxSetShaderValue(drugShader, "increaseColors", increaseColors)
			dxSetShaderValue(drugShader, "switchColors", switchColors)

			dxDrawImage(0, 0, screenWidth, screenHeight, drugShader)
		end
    end
end)

--[[
addEventHandler("onClientRender", root,
function()

end)]]
