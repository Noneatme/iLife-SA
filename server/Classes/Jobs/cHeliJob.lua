--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]


CHeliJob = {}

new(CJob, 3, "Helikopterpilot", "1730.25390625|-2335.4970703125|13.546875")

function CHeliJob:constructor()
end

function CHeliJob:destructor()
end


local divisor = 6

addEventHandler("onMarkerHit", createMarker(1730.25390625, -2335.4970703125, 13.546875, "corona", 1, 255, 255, 255, 255), function(e)
	if (getElementType(e) == "player") then
		if not (isPedInVehicle(e)) then
			fadeCamera(e, false)
			toggleAllControls(e, false)
			setTimer(
				function(p)
					setElementPosition(p, 1455.0999755859, -2369.8999023438, 1731.9000244141)
					setElementInterior(p, 1)
					fadeCamera(p, true)
					toggleAllControls(p, true)
				end
			, 2000, 1, e)
		else
			e:showInfoBox("error", "Steig aus deinem Fahrzeug aus.")
		end
	end
end
)

local outMarker = createMarker(1454.9000244141, -2372.6999511719, 1731.6999511719, "corona", 1, 255, 255, 255, 255)
setElementInterior(outMarker, 1)

addEventHandler("onMarkerHit", outMarker, function(e)
	if (getElementType(e) == "player") then
		if not (isPedInVehicle(e)) then
			fadeCamera(e, false)
			toggleAllControls(e, false)
			setTimer(
				function(p)
					setElementPosition(p, 1730.568359375, -2328.7822265625, 13.546875)
					setElementInterior(p, 0)
					setElementRotation(p, 0, 0, 90)
					toggleAllControls(p, true)
					fadeCamera(p, true)
				end
			, 2000, 1, e)
		else
			e:showInfoBox("error","Steig aus deinem Fahrzeug aus.")
		end
	end
end
)

local data = {}
local routes = {
	get = {
		[1] = {x = 2778.5, y = -2350.1999511719, z = 16.10000038147}
	},
	set = {
		[1] = {x = 1544.1999511719, y = -1353.4000244141, z = 329.5},
		[2] = {x = -1186, y = 25.799999237061, z = 14.10000038147},
		[3] = {x = -2023.1999511719, y = 440.60000610352, z = 139.69999694824},
		[4] = {x = -2227.8999023438, y = 2326.6000976563, z = 7.5},
		[5] = {x = 365.39999389648, y = 2536.8999023438, z = 16.700000762939},
		[6] = {x = 2094, y = 2415.1999511719, z = 74.599998474121},
		[7] = {x = 2618.3999023438, y = 2721.3999023438, z = 36.5}
	}
}
local teiler = 10

local startMarker = createMarker(1449.9000244141, -2369.3000488281, 1732, "corona", 1, 255, 255, 255)
setElementInterior(startMarker, 1)

addEventHandler("onMarkerHit", startMarker, function(e)
	if (e:hasLicense("helicopter")) then
		if (getPlayerWantedLevel(e) == 0) then
			toggleAllControls(e, false)
			triggerClientEvent(e, "onHJMarkerHit", e)
		else
			e:showInfoBox("error", "Du wirst von der Polizei gesucht, solche Leute können wir nicht gebrauchen.")
		end
	else
		e:showInfoBox("error", "Leider besitzt du keine gültige\nFluglizenz, komm wieder wenn du eine hast!")
	end
end
)

addEvent("onClientHJStartPressed", true)
addEventHandler("onClientHJStartPressed", getRootElement(), function()
	if (clientcheck(source, client)) then
		if (not (isElementWithinMarker(client, startMarker))) then
			client:showInfoBox("error", "Du bist am falschen Ort!")
			return false
		end
		Achievements[5]:playerAchieved(source)
		fadeCamera(source, false)
		toggleAllControls(source, false)

		setTimer(function(p)
			local index = math.random(1, #routes.get)
			data[p] = {}
			data[p].Dimension = 0 --getEmptyDimension()
			data[p].v = createVehicle(548, 1765.5999755859, -2286.3000488281, 27)
			data[p].v:enableGhostmode(10000)
			setElementDimension(p, data[p].Dimension)
			setElementDimension(data[p].v, data[p].Dimension)
			data[p].o = createObject(1299, 0, 0, 0)
			setElementDimension(data[p].o, data[p].Dimension)
			data[p].m = createMarker(routes.get[index].x, routes.get[index].y, routes.get[index].z, "corona", 3, 0, 0, 255, 255, p)
			setElementDimension(data[p].m, data[p].Dimension)
			data[p].b = createBlipAttachedTo(data[p].m, 41, 2, 0, 0, 255, 255, 0, 1337, p)
			setElementDimension(data[p].b, data[p].Dimension)
			data[p].uGhostCol = createColSphere(routes.get[index].x, routes.get[index].y, routes.get[index].z, 30)

			triggerClientEvent(p, "onHudBlipRefresh", p)

			data[p].markerType = "get"
			data[p].lastSetIndex = 0
			data[data[p].v] = p
			setVehicleDamageProof(data[p].v, true)
			setElementInterior(p, 0)
			warpPedIntoVehicle(p, data[p].v)
			setVehicleEngineState(data[p].v, true)
			attachElements(data[p].o, data[p].v, -0.5, -1.5, -1)
			setElementAlpha(data[p].o, 0)

			addEventHandler("onVehicleExplode", data[p].v, function()
				local p = data[source].p
				if (isTimer(data[p].timer)) then killTimer(data[p].timer) end
				destroyElement(data[p].b)
				destroyElement(data[p].m)
				destroyElement(data[p].o)
				destroyElement(data[source].uGhostCol)
				data[p] = nil
				data[source] = nil
				destroyElement(source)
			end
			)

			addEventHandler("onVehicleStartExit", data[p].v, function(p)
				if (isTimer(data[p].timer)) then killTimer(data[p].timer) end
				data[source] = nil
				destroyElement(source)
				destroyElement(data[p].m)
				destroyElement(data[p].b)
				destroyElement(data[p].o)
				data[p] = nil
				setElementPosition(p, 1455.0999755859, -2369.8999023438, 1732.9000244141)
				setElementDimension(p, 0)
				setElementInterior(p, 1)
			end
			)

			addEventHandler("onVehicleStartEnter", data[p].v, function()
				cancelEvent()
			end
			)

			addEventHandler("onMarkerHit", data[p].m, function(e)
				if (type(data[e] == "table")) and (getElementType(e) == "vehicle") then

					local p = getVehicleOccupant(e)
					if (source == data[p].m) then
						setElementFrozen(e, true)
						data[p].timer = setTimer(function(v)
							setElementFrozen(v, false)
							if (data[p].markerType == "set") then
								p:showInfoBox("info", "Bringe die Ware nach "..getZoneName(routes.set[data[p].lastSetIndex].x, routes.set[data[p].lastSetIndex].y, routes.set[data[p].lastSetIndex].z))
							end
					end, 2000, 1, e)
						if (data[p].markerType == "get") then
							if (data[p].lastSetIndex ~= 0) then
								local money = math.floor(math.ceil( (getDistanceBetweenPoints3D(routes.set[data[p].lastSetIndex].x, routes.set[data[p].lastSetIndex].y, routes.set[data[p].lastSetIndex].z, getElementPosition(source)) / divisor) *1.87)*getEventMultiplicator())
								p:showInfoBox("info", "Du hast für den Flug "..tostring(money).."$ erhalten!")
								p:setMoney(p:getMoney()+money)
								p:incrementStatistics("Job", "Geld_erarbeitet", money)
								p:incrementStatistics("Job", "Ware_abgeliefert", 1)
								p:checkJobAchievements()
							end
							setElementAlpha(data[p].o, 255)
							data[p].lastSetIndex = math.random(1, #routes.set)
							setElementPosition(source, routes.set[data[p].lastSetIndex].x, routes.set[data[p].lastSetIndex].y, routes.set[data[p].lastSetIndex].z)
							setElementPosition(data[p].uGhostCol, routes.set[data[p].lastSetIndex].x, routes.set[data[p].lastSetIndex].y, routes.set[data[p].lastSetIndex].z)
							data[p].markerType = "set"
							triggerClientEvent(p, "onHudBlipRefresh", p)
						elseif (data[p].markerType == "set") then
							local index = math.random(1, #routes.get)
							setElementAlpha(data[p].o, 0)
							setElementPosition(source, routes.get[index].x, routes.get[index].y, routes.get[index].z)
							setElementPosition(data[p].uGhostCol, routes.get[index].x, routes.get[index].y, routes.get[index].z)
							p:showInfoBox("info", "Hol dir nun die neue Ladung.\n Dann bekommst du deinen Lohn!")
							data[p].markerType = "get"
							triggerClientEvent(p, "onHudBlipRefresh", p)
						end
					end
				end
			end
			)
			addEventHandler("onColShapeHit", 	data[p].uGhostCol, function(uHitElement, dim)
				if uHitElement == data[p].v and dim then
					data[p].v:enableGhostmode(1)
				end
			end)
			addEventHandler("onColShapeLeave", 	data[p].uGhostCol, function(uLeaveElement, dim)
				if uLeaveElement == data[p].v and dim then
					data[p].v:enableGhostmode(0)
				end
			end)

			setTimer(function(p) fadeCamera(p, true) toggleAllControls(p, true) end, 2000, 1, p)

		end, 2000, 1, source)
	end
end
)

addEventHandler("onPlayerQuit", getRootElement(), function()
	if (type(data[source]) == "table") then
		if (isTimer(data[source].timer)) then killTimer(data[source].timer) end
		data[data[source].v] = nil
		destroyElement(data[source].v)
		destroyElement(data[source].o)
		destroyElement(data[source].b)
		destroyElement(data[source].uGhostCol)
		data[source] = nil
	end
end
)

addEventHandler("onPlayerWasted", getRootElement(), function()
	if (type(data[source]) == "table") then
		if (isTimer(data[source].timer)) then killTimer(data[source].timer) end
		data[data[source].v] = nil
		destroyElement(data[source].v)
		destroyElement(data[source].o)
		destroyElement(data[source].b)
		destroyElement(data[source].m)
		destroyElement(data[source].uGhostCol)
		data[source] = nil
	end
end
)
