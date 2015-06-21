--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

new(CJob, 4, "Busfahrer", "2110.8283|-2154.702|15.269")

local function createDummyBus(...)
	local v = createVehicle(...)
	setVehicleDamageProof(v, true)
	setElementFrozen(v, true)

	addEventHandler("onVehicleStartEnter", v, function()
		cancelEvent()
	end
	)
end
createDummyBus(431, 2153.8562, -2143.7244, 13.76121, 0, 0, 45)
createDummyBus(431, 2150.2251, -2147.3237, 13.76121, 0, 0, 45)
createDummyBus(431, 2146.7656, -2150.7949, 13.76121, 0, 0, 45)
createDummyBus(437, 2141.5928, -2156.6604, 13.79688, 0, 0, 45)
createDummyBus(437, 2137.9395, -2160.2805, 13.79688, 0, 0, 45)
createDummyBus(437, 2134.584, -2163.8225, 13.79688, 0, 0, 45)

--[[
createMarker(1328.500 , -1728.7 , 12.4)
createMarker(1360.900 , -1316.5 , 12.4)
createMarker(1324.400 , - 921.1 , 36.1)
createMarker(1086.600 , - 944.2 , 41.6)
createMarker( 958.900 , -1084.2 , 23.6)
createMarker( 913.900 , -1449.7 , 12.4)
createMarker( 914.100 , -1754.5 , 12.4)
createMarker(1083.000 , -1855.9 , 12.4)
createMarker(1573.400 , -1762.3 , 12.4)
createMarker(1533.200 , -1610.5 , 12.4)



createMarker(1840.099 ,-1616.2 ,12.4)
createMarker(1938.000 ,-1736.9 ,12.4)
createMarker(1958.099 ,-1998.4 ,12.4)
createMarker(1826.699 ,-2128.6 ,12.4)
createMarker(1965.099 ,-2003.8 ,12.4)
createMarker(2085.199 ,-1869.6 ,12.4)
createMarker(2116.399 ,-1492.1 ,22.8)
createMarker(1873.900 ,-1457.1 ,12.4)
createMarker(1476.199 ,-1437.0 ,12.4)
createMarker(1426.099 ,-1704.1 ,12.4)
]]


local busjobActive = true
local busSpawnX, busSpawnY, busSpawnZ, busSpawnRotX, busSpawnRotY, busSpawnRotZ = 2112.6292, -2133.4604, 13.76121, 0, 0, 0
local busjobPickup = createPickup(2110.8283, -2154.702, 13.269, 3, 1274, 0)

addEventHandler("onPickupHit", busjobPickup, function(e)
	if (busjobActive) then
		if (getElementType(e) == "player") and not (isPedInVehicle(e)) then
			if (getPlayerWantedLevel(e) == 0) then
				triggerClientEvent(e, "onBJStartMarkerHit", e)
			else
				e:showInfoBox("info", "Du wirst derzeit von der Polizei gesucht, solche Leute wollen wir bei uns nicht.")
			end
		end
	end
end
)

local lines = {
	[1] = {
		[1] = {x = 1459.81, y = -1729.55, z = 13.48, "Commerce"},
		[2] = {x = 1457.34, y = -1267.05, z = 13.49, "Downtown Los Santos"},
		[3] = {x = 1299.06, y = -1278.09, z = 13.49, "Market"},
		[4] = {x = 794.74, y = -1345.06, z = 13.48, "Market Station"},
		[5] = {x = 626.99, y = -1658.52, z = 15.81, "Rodeo"},
		[6] = {x = 114.91, y = -1609.39, z = 10.53, "Santa Maria Beach West"},
		[7] = {x = 409.07, y = -1775.64, z = 5.38, "Santa Maria Beach (iLife Baumarkt)"},
		[8] = {x = 642.34, y = -1630.26, z = 15.2, "Rodeo"},
		[9] = {x = 819.46, y = -1330.15, z = 13.44, "Market Station"},
		[10] = {x = 1308.32, y = -1283.95, z = 13.52, "Market"},
		[11] = {x = 1451.78, y = -1277.51, z = 13.54, "Downtown Los Santos"},
		[12] = {x = 1492.87, y = -1594.86, z = 13.56, "Pershing Square"},
	},
	[2] = {
		[1] = {x = 1491.5, y = -1729.49, z = 13.47, "Commerce"},
		[2] = {x = 1330.1, y = -1729.35, z = 13.47, "Commerce"},
		[3] = {x = 1361.04, y = -1316.79, z = 13.47, "Ammu Nation Market"},
		[4] = {x = 1324.74, y = -921.4, z = 37.19, "LS Planning Center"},
		[5] = {x = 1087.35, y = -945.32, z = 42.7, "Temple Einkaufszentrum"},
		[6] = {x = 959.98, y = -1082.04, z = 24.88, "Friedhof"},
		[7] = {x = 914.69, y = -1448.24, z = 13.39, "Marina"},
		[8] = {x = 915.06, y = -1753.38, z = 13.39, "Verona Beach"},
		[9] = {x = 1081.34, y = -1855.24, z = 13.39, "Konferenzzentrum"},
		[10] = {x = 1572.48, y = -1763.38, z = 13.39, "Commerce"},
	},
	[3] = {
		[1] = {x = 1449.04, y = -1735.14, z = 13.13, "Commerce"},
		[2] = {x = 1835.09, y = -1615.6, z = 13.47, "Idlewood West"},
		[3] = {x = 1938.65, y = -1733.95, z = 13.48, "Idlewood Sued"},
		[4] = {x = 1958.61, y = -1997.52, z = 13.48, "El Corona Nord"},
		[5] = {x = 1826.14, y = -2127.87, z = 13.48, "El Corona Sued"},
		[6] = {x = 1964.8, y = -2004.19, z = 13.48, "El Corona Nord"},
		[7] = {x = 2084.2, y = -1869.35, z = 13.41, "Willowfield"},
		[8] = {x = 2115.97, y = -1492.49, z = 23.9, "Idlewood Ost"},
		[9] = {x = 1874.47, y = -1458.16, z = 13.48, "Idlewood Nord"},
		[10] = {x = 1476.93, y = -1437.98, z = 13.52, "Commerce"},
		},
}



local data = {}

--Source is the player
addEvent("onClientBJStartPressed", true)
addEventHandler("onClientBJStartPressed", getRootElement(), function()
	if not (clientcheck(source, client)) then
		return false
	end

	local x,y,z = getElementPosition(source)
	local xp,yp, zp = getElementPosition(busjobPickup)
	local line = math.random(1, #lines)

	if not (getDistanceBetweenPoints3D(x, y, z, xp, yp, zp) < 2) and not (isPedInVehicle(source)) then
		source:showInfoBox("error", "Du bist am falschen Ort!")
		return false
	end

	Achievements[5]:playerAchieved(source)
	data[source] = {}
	data[source].line = line
	data[source].point = 1
	data[source].v = createVehicle(431, busSpawnX, busSpawnY, busSpawnZ, busSpawnRotX, busSpawnRotY, busSpawnRotZ)
	data[source].m = createMarker(lines[line][data[source].point].x, lines[line][data[source].point].y, lines[line][data[source].point].z, "checkpoint", 2, 0, 0, 255, 255, source)
	data[source].b = createBlipAttachedTo(data[source].m, 41, 2, 0, 0, 255, 255, 0, 1337, source)
	data[source].x = busSpawnX -- used for range calculation
	data[source].y = busSpawnY -- used for range calculation
	data[source].range = 0
	data[source].firstPoint = true
	data[data[source].v] = {}
	data[data[source].v].p = source
	data[data[source].m] = {}
	data[data[source].m].v = data[source].v
	warpPedIntoVehicle(source, data[source].v)
	data[source].v:setEngineState(true)
	local skins = {[265] = true, [266] = true, [267] = true, [312] = true, [280] = true, [281] = true, [282] = true, [283] = true, [284] = true, [285] = true, [286] = true, [287] = true, [288] = true}

	addEventHandler("onVehicleStartEnter", data[source].v, function(p, seat)
		if (seat == 0) then
			if not (skins[getElementModel(p)]) then
				cancelEvent()
			end
		end
	end
	)

	--When the source is deleted, event wont be triggered
	addEventHandler("onVehicleStartExit", data[source].v, function(p, seat)
		if (seat == 0) then
			--kill Timer if exists
			if (isTimer(data[source].timer)) then killTimer(data[source].timer) end

			--kill radio
			for k, v in ipairs(getVehicleOccupants(source)) do
				triggerClientEvent(v, "onCustomClientPlayerRadioSwitch", getRootElement(), 0)
			end

			--Vehicle delete
			data[source] = nil
			destroyElement(source)

			--Marker + Blip delete
			if(data[data[p].m]) then
				data[data[p].m] = nil
			end
			destroyElement(data[p].m)
			destroyElement(data[p].b)

			--deletes the player data
			data[p] = nil
		end
	end
	)

	--When the source is deleted, event wont be triggered
	addEventHandler("onVehicleExplode", data[source].v, function()
		local p = data[source].p

		--kill Timer if exists
		if (isTimer(data[source].timer)) then killTimer(data[source].timer) end

		--kill radio
		for k, v in ipairs(getVehicleOccupants(source)) do
			triggerClientEvent(v, "onCustomClientPlayerRadioSwitch", getRootElement(), 0)
		end

		--Vehicle delete
		data[source] = nil
		destroyElement(source)

		--Marker + Blip delete
		if(data[data[p].m]) then
			data[data[p].m] = nil
		end
		destroyElement(data[p].m)
		destroyElement(data[p].b)

		--deletes the player data
		data[p] = nil
	end
	)

	source:showInfoBox("info", "Fahre zur Stadthalle und lasse dir eine Linie zuweisen!")

end
)

addEventHandler("onMarkerHit", getRootElement(), function(e)
	if	(type(data[source]) == "table") then --when the table exists, the job is going on
		if (getElementType(e) == "vehicle") and (data[source].v == e) then
			if (getElementRealSpeed(e) <= 40) then
				local x, y, z = getElementPosition(source)
				local l = data[data[e].p].line
				local p = data[data[e].p].point
				data[data[e].p].range = data[data[e].p].range + getDistanceBetweenPoints2D(x, y, data[data[e].p].x, data[data[e].p].y)
				data[data[e].p].x = x
				data[data[e].p].y = y
				setElementFrozen(e, true)
				data[e].timer = setTimer(function(v) setElementFrozen(v, false) end, 5000, 1, e)

				local journal = "Linie: " .. data[data[e].p].line .. "\n"

				local station = ""
				if (#lines[l] == data[data[e].p].point) then
					if (lines[l] and lines[l][ p + 1] and lines[l][p + 1][1]) then
						journal = journal .. "Nächste Station: " .. lines[l][1][1] .. "\n"
						station = lines[l][p + 1][1]
					else
						journal = journal .. "Nächste Station: " .. "Endstelle" .. "\n"
						station = "Endstelle"
					end
				else
					if (lines[l] and lines[l][p + 1] and lines[l][p + 1][1]) then
						journal = journal .. "Nächste Station: " .. lines[l][p + 1][1] .. "\n"
						station = lines[l][p + 1][1]
					else
						journal = journal .. "Nächste Station: " .. "Endstelle" .. "\n"
						station "Endstelle"
					end
				end

				if (station ~= "") then
					for k,v in pairs(getVehicleOccupants(e)) do
						triggerClientEvent(v, "onServerPlaySavedSound", getRootElement(), "http://translate.google.com/translate_tts?tl=de&q=Naechste%20Station:%20"..station, "Busansage", false)
					end
					if #getVehicleOccupants(e) > 0 then
						data[e].p:incrementStatistics("Job", "Spieler_befoerdert", #getVehicleOccupants(e))
					end
				end

				createMessageSphere(x, y, z, 10, journal)

				if (data[data[e].p].point == 1) then
					if not (data[data[e].p].firstPoint) then
						local money = math.floor((data[data[e].p].range / 6) * 1.35 *getEventMultiplicator())
						data[e].p:addMoney(money)
						data[e].p:incrementStatistics("Job", "Geld_erarbeitet", money)
						data[e].p:checkJobAchievements()
						data[e].p:showInfoBox("info", "Für den Job hast du "..money.." $ erhalten.")
					end
					data[data[e].p].range = 0
					data[data[e].p].point = data[data[e].p].point + 1
					data[data[e].p].firstPoint = false
				elseif (data[data[e].p].point == #lines[data[data[e].p].line]) then
					data[data[e].p].point = 1
				else
					data[data[e].p].point = data[data[e].p].point + 1
				end

				setElementPosition(source, lines[data[data[e].p].line][data[data[e].p].point].x, lines[data[data[e].p].line][data[data[e].p].point].y, lines[data[data[e].p].line][data[data[e].p].point].z)
				triggerClientEvent(data[e].p, "onHudBlipRefresh", data[e].p)
			end
		end
	end
end
)

addEventHandler("onPlayerWasted", getRootElement(), function()
	if (type(data[source]) == "table") then --when the table exists, the job is going on
		--kill Timer if exists
		if (isTimer(data[data[source].v].timer)) then killTimer(data[data[source].v].timer) end

		--Vehicle delete
		data[data[source].v] = nil
		destroyElement(data[source].v)

		--Marker + Blip delete
		data[data[source].m] = nil
		destroyElement(data[source].m)
		destroyElement(data[source].b)

		--deletes the player data
		data[source] = nil
	end
end
)

addEventHandler("onPlayerQuit", getRootElement(), function()
	if (type(data[source]) == "table") then --when the table exists, the job is going on
		--kill Timer if exists
		if (isTimer(data[data[source].v].timer)) then killTimer(data[data[source].v].timer) end

		--Vehicle delete
		data[data[source].v] = nil
		destroyElement(data[source].v)

		--Marker + Blip delete
		data[data[source].m] = nil
		destroyElement(data[source].m)
		destroyElement(data[source].b)

		--deletes the player data
		data[source] = nil
	end
end
)
