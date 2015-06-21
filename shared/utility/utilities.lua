--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end



function getEmptyDimension()
	local players = getElementsByType("player")
	local vehicles = getElementsByType("vehicle")
	local peds = getElementsByType("ped")

	for k,v in ipairs(vehicles) do
		if (getElementDimension(v) ~= 0) then
			table.insert(players, v)
		end
	end

	for k,v in ipairs(peds) do
		if (getElementDimension(v) ~= 0) then
			table.insert(players, v)
		end
	end

	local full = false
	for i=1, 9999, 1 do
		local full = false
		for k,v in ipairs(players) do
			if getElementDimension(v) == i then
				full = true
				break;
			end
		end
		if (full == false) then
			return i
		end
	end
	return 9999
end

function getVehicleFreeSeat(veh)
	local max = getVehicleMaxPassengers(veh);
	for i = 1, max, 1 do
		if not(getVehicleOccupant(veh, i)) then
			return i
		end
	end
	return false
end

function table.rewriteIntegerIndexes(uTable)
    local newTBL    = {}
    for index, data in pairs(uTable) do
        if(tonumber(index)) then
            newTBL[tonumber(index)] = data;
        end
    end
    return newTBL;
end

function escapeString(sString)
    local chars     = {"'", '"', "\\"};
    local sString2  = sString;
    for _, char in pairs(chars) do
        sString2 = string.gsub(sString2, char, "");
    end
    return sString2;
end

function string.removeInvalidSonderzeichen(sString)
    local chars     = {"ä", "ö", "ü", "ß"};
    local sString2  = sString;
    for _, char in pairs(chars) do
        sString2 = string.gsub(sString2, char, "");
    end
    return sString2;
end

-- ///////////////////////////////
-- ///// GetDayString		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function getCurrentDateWithTime(arg2)
	local datum     = getRealTime(arg1);

	local time      = datum.monthday.."."..(datum.month+1).."."..(datum.year+1900).." "..(datum.hour)..":"..datum.minute..":"..datum.second;

	return time
end

function table.merge(t1, t2)
	for k,v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function table.length(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function getElementRealSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return ((x^2 + y^2 + z^2) ^ 0.5 * 100)*0.75
		else
			return ((x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100)*0.75
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

function setElementRealSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementRealSpeed(element, unit)
	if (acSpeed~=false) then -- if true - element is valid, no need to check again
		local diff = speed/acSpeed
		if diff ~= diff then return end -- if the number is a 'NaN' return end.
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	end

	return false
end

function transformNumberInBool(iNumber)
	if (iNumber == 0) then
		return false
	else
		return true
	end
end

function transformBoolInNumber(bState)
	if (bState == true) then
		return 1
	else
		return 0
	end
end

function isLeapYear(year)
    if year then
		year = math.floor(year)
    else
		year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end

    return timestamp
end
function generateSalt(password)
    local randWert	= math.random(1, 5);
    return string.sub(hash("sha512", getRealTime().timestamp.."|"..password.."|"), randWert, randWert+10);
end

function getDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist

	return x + dx, y + dy
end

local function setDotsInNumber ( value )
	if (#value > 3) then
		return setDotsInNumber ( string.sub ( value, 1, #value - 3 ) ).."."..string.sub ( value, #value - 2, #value )
	else
		return value
	end
end

function _setDotsInNumber(...)
	return setDotsInNumber(...)
end

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

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end

	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

function getTableSize(tbl)
    tbl = tbl or {}
	local i = 0
	for k,v in pairs(tbl) do
		i = i+1
	end
	return i
end

function getNumericIndexTable(tbl)
	local temp = {}

	for k,v in pairs(tbl) do
		table.insert(temp, k)
	end

	table.sort(temp)

	return temp
end

function clientcheck(pl, cl)
	if (triggerClientEvent ~= nil) then
		if ((cl == pl) or (not isElement(cl))) then
			return true
		else
			cheatBan(cl, 1)
			return false
		end
	end
end

function cheatBan(cl, iNumber)
	if (triggerClientEvent ~= nil) and (cl.getName) and (cl.getSerail) then
		local query = "INSERT INTO  `rl`.`Bans` (`id` ,`Name` ,`Serial` ,`IP` ,`Date` ,`banned_by` ,`Grund` ,`expire_timestamp`)VALUES (NULL ,  ?,  ?,  ?,  NOW(),  ?,  ?,  ?);"
		CDatabase:getInstance():query(query, cl:getName(), cl:getSerial(), cl:getIP(), "AntiCheat", "Cheat #"..tostring(iNumber), getRealTime()["timestamp"]+93312000)
		outputChatBox("Der Spieler "..cl:getName().." wurde vom AntiCheat gebannt. Grund: Cheat "..tostring(iNumber), getRootElement(), 255, 0, 0)
		kickPlayer(cl,"Du wurdest gebannt. Grund: Cheat #"..tostring(iNumber))
		return true
	end
	return false
end

function table.size(tbl)

	local count=0
	for k,v in pairs(tbl) do
		count = count+1
	end
	return count
end

function moveString(theString)
	theString = string.sub(theString, 2)..string.sub(theString,1,1)
	return theString
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);

    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;

    return x+dx, y+dy;
end

function findRotation(x1,y1,x2,y2)

  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;

end

function getDistanceBetweenElements3D(e1,e2)
    local x,y,z = getElementPosition(e1)
	local x2,y2,z2 = getElementPosition(e2)
    return getDistanceBetweenPoints3D(x,y,z, x2,y2,z2)
end

function getDistanceBetweenElements2D(e1,e2)
    local x,y,z = getElementPosition(e1)
	local x2,y2,z2 = getElementPosition(e2)
    return getDistanceBetweenPoints2D(x,y, x2,y2)
end

function isPointInRectangle(cX,cY,rX,rY,width,height)
	return ((cX > rX) and (cX < rX+width)) and ( (cY > rY) and (cY < rY+height))
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if
		type( sEventName ) == 'string' and
		isElement( pElementAttachedTo ) and
		type( func ) == 'function'
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end

	return false
end

function getElementsNearElement(theElement, fRadius, sType)
	local x,y,z = getElementPosition(theElement)
	local sphere = createColSphere(x,y,z, fRadius)
	local Elements = getElementsWithinColShape(sphere, sType)
	destroyElement(sphere)
	return Elements
end

function getPlayerFromPartialName(name)
	local found = {}
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                table.insert(found, player)
            end
        end
    end
	if (#found == 1) then
		return found[1]
	else
		return false
	end
end

--RPC
RPC = {
["registeredFuncs"] = {}
}

addEvent("RPC_Call", true)
addEventHandler("RPC_Call", getRootElement(),
    function(rpcName, ...)
        if RPC.registeredFuncs[rpcName] then
            if triggerServerEvent then
				RPC.registeredFuncs[rpcName](...)
            else
                RPC.registeredFuncs[rpcName](client, ...)
            end
		else
			outputDebugString("Unregistered RPC Call: "..rpcName.."!")
        end
    end
)

function RPCRegister(rpcName, theFunc)
    RPC.registeredFuncs[rpcName] = theFunc
end

function RPCCall(rpcName, ...)
	if triggerServerEvent then
		triggerServerEvent("RPC_Call", getRootElement(), rpcName, ...)
	else
		triggerClientEvent("RPC_Call", getRootElement(), rpcName, ...)
	end
end

function parseString(sString)
	sString = tostring(sString);
		sString = string.gsub(sString, "\\oe", "ö")
		sString = string.gsub(sString, "\\ae", "ä")
		sString = string.gsub(sString, "\\ue", "ü")
		sString = string.gsub(sString, "\\Oe", "Ö")
		sString = string.gsub(sString, "\\Ae", "Ä")
		sString = string.gsub(sString, "\\Ue", "Ü")
		sString = string.gsub(sString, "\\sz", "ß")
		return sString
end

_outputChatBox = outputChatBox
function outputChatBox(Text, ...)
	_outputChatBox(parseString(Text), ...)
end

function createMessageSphere(x, y, z, r, message)
	local sphere = createColSphere(x, y, z, r)
	local players = getElementsWithinColShape(sphere, "player")
	destroyElement(sphere)

	if triggerServerEvent then
		outputDebugString("Outputspheres machen Clientseitig keinen Sinn, biatches!")
	else
		for index, player in pairs(players) do
			player:showInfoBox("info", message)
		end
	end
end

function isPlayerOnline(iID)
	if(type(iID) == "number") then
		if(Players[iID]) and (getPlayerFromName(Players[iID].Name)) then
			return true;
		end
	else
		if(getPlayerFromName(iID)) then
			return true;
		end
	end
	return false;
end


function add(var, val)
	return var+val
end

function createAbsoluteColCuboid(fX, fY, fZ, lX, lY, lZ, Name)
	local shape = createColCuboid(fX,fY,fZ, lX-fX, lY-fY, lZ-fZ)
	setElementData(shape, "Name", Name)

	createRadarArea(fX, fY, lX-fX, lY-fY, math.random(0,255), math.random(0,255), math.random(0,255), 80, getRootElement())

	return shape
end

function isVehicleEmpty( vehicle )
	if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
		return true
	end

	local passengers = getVehicleMaxPassengers( vehicle )
	if type( passengers ) == 'number' then
		for seat = 0, passengers do
			if getVehicleOccupant( vehicle, seat ) then
				return false
			end
		end
	end
	return true
end

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

function formatTimestamp(iTimestamp)
	local time 	= getRealTime(iTimestamp);
	local day 	= time.monthday;
	local month = time.month+1;
	local year 	= time.year+1900;

	local hour 	= time.hour
	local min 	= time.minute
	local sec 	= time.second


	if(hour < 10) 	then hour = "0"..hour end
	if(min < 10) 	then min = "0"..min end
	if(sec < 10) 	then sec = "0"..sec end

	if(day < 10) 	then day = "0"..day end
	if(month < 10) 	then month = "0"..month end

	return day.."."..month.."."..year.." "..hour..":"..min..":"..sec
end


function toBoolean(sString)
	if(type(sString) == "string") then
		sString = string.lower(sString);
		if(sString == "true") or (sString == 'true') then
			return true;
		elseif(sString == "false") or (sString == 'false') then
			return false;
		end
	else
		return sString;
	end
	return false;
end

toboolean = toBoolean

function scrambleWord(sWord)
	local length 	= string.len(sWord);
	local tbl		= {}
	local indexDone	= {}

	for i = 0, length, 1 do
		tbl[i] = string.sub(sWord, i, i);
	end

	local function findFreeChar()
		local rand = math.random(0, length)
		if not(indexDone[rand]) then
			indexDone[rand] = true;
			return tbl[rand];
		else
			return findFreeChar();
		end
	end

	local sString	= ""
	for i = 0, length, 1 do
		sString = sString..findFreeChar();
	end

	return sString;
end

function getPointFromDistanceRotation(x, y, dist, angle)

	local a = math.rad(90 - angle);

	local dx = math.cos(a) * dist;
	local dy = math.sin(a) * dist;

	return x+dx, y+dy;

end

function table.removeindex(table, index)
	local newtbl = {}
	for k, v in pairs(table) do
		if(k ~= index) then
			newtbl[k] = v;
		end
	end
	return newtbl;
end

function getRandomVehicleModel(sVehicleType)
	local randVeh		= math.random(411, 611)
	if(sVehicleType) then
		if(string.lower(getVehicleType(randVeh)) == string.lower(sVehicleType)) then
			return randVeh;
		else
			return getRandomVehicleModel(sVehicleType)
		end
	end
	return randVeh;
end

function isEmailCorrect(email)
	if ( (gettok ( email, 2, "@" ) == false) or (gettok ( gettok ( email, 2, "@" ), 2, "." ) == false) or (gettok ( gettok ( email, 2, "@" ), 1, "." ) == "trashmail" )) then
		return false;
	end
	return true;
end

_setWeather 		= setWeather
local lastWeather	= 0;
function setWeather(iWeather, ...)
	lastWeather = getWeather();
	_setWeather(iWeather, ...)
end

function resetWeather()
	_setWeather(lastWeather);
end

-- modifiers: v - verbose (all subtables), n - normal, s - silent (no output), dx - up to depth x, u - unnamed
function var_dump(...)
	-- default options
	local verbose = false
	local firstLevel = true
	local outputDirectly = true
	local noNames = false
	local indentation = "\t\t\t\t\t\t"
	local depth = nil

	local name = nil
	local output = {}
	for k,v in ipairs(arg) do
		-- check for modifiers
		if type(v) == "string" and k < #arg and v:sub(1,1) == "-" then
			local modifiers = v:sub(2)
			if modifiers:find("v") ~= nil then
				verbose = true
			end
			if modifiers:find("s") ~= nil then
				outputDirectly = false
			end
			if modifiers:find("n") ~= nil then
				verbose = false
			end
			if modifiers:find("u") ~= nil then
				noNames = true
			end
			local s,e = modifiers:find("d%d+")
			if s ~= nil then
				depth = tonumber(string.sub(modifiers,s+1,e))
			end
			-- set name if appropriate
		elseif type(v) == "string" and k < #arg and name == nil and not noNames then
			name = v
		else
			if name ~= nil then
				name = ""..name..": "
			else
				name = ""
			end

			local o = ""
			if type(v) == "string" then
				table.insert(output,name..type(v).."("..v:len()..") \""..v.."\"")
			elseif type(v) == "userdata" then
				local elementType = "no valid MTA element"
				if isElement(v) then
					elementType = getElementType(v)
				end
				table.insert(output,name..type(v).."("..elementType..") \""..tostring(v).."\"")
			elseif type(v) == "table" then
				local count = 0
				for key,value in pairs(v) do
					count = count + 1
				end
				table.insert(output,name..type(v).."("..count..") \""..tostring(v).."\"")
				if verbose and count > 0 and (depth == nil or depth > 0) then
					table.insert(output,"\t{")
					for key,value in pairs(v) do
						-- calls itself, so be careful when you change anything
						local newModifiers = "-s"
						if depth == nil then
							newModifiers = "-sv"
						elseif  depth > 1 then
							local newDepth = depth - 1
							newModifiers = "-svd"..newDepth
						end
						local keyString, keyTable = var_dump(newModifiers,key)
						local valueString, valueTable = var_dump(newModifiers,value)

						if #keyTable == 1 and #valueTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>\t"..valueString)
						elseif #keyTable == 1 then
							table.insert(output,indentation.."["..keyString.."]\t=>")
							for k,v in ipairs(valueTable) do
								table.insert(output,indentation..v)
							end
						elseif #valueTable == 1 then
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							table.insert(output,indentation.."\t=>\t"..valueString)
						else
							for k,v in ipairs(keyTable) do
								if k == 1 then
									table.insert(output,indentation.."["..v)
								elseif k == #keyTable then
									table.insert(output,indentation..v.."]")
								else
									table.insert(output,indentation..v)
								end
							end
							for k,v in ipairs(valueTable) do
								if k == 1 then
									table.insert(output,indentation.." => "..v)
								else
									table.insert(output,indentation..v)
								end
							end
						end
					end
					table.insert(output,"\t}")
				end
			else
				table.insert(output,name..type(v).." \""..tostring(v).."\"")
			end
			name = nil
		end
	end
	local string = ""
	for k,v in ipairs(output) do
		if outputDirectly then
			outputConsole(v)
		end
		string = string..v
	end
	return string, output
end
