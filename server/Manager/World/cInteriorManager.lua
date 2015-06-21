--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CInteriorManager = inherit(cSingleton)

blips = {
[1] = 10,
[2] = 45,
[3] = 36,
[4] = 18,
[5] = 14,
[6] = 21,
[7] = 29,
[8] = 45,
[9] = 45,
[10] = 48,
[11] = 17,
[12] = 54,
[13] = 45,
[14] = 12,
[15] = 48,
[16] = 50,
[17] = 0,
[18] = 24,
[19] = 45,
[20] = 25,
[21] = 25,
[22] = 25,
[23] = 45,
[24] = 56,
[25] = 46,
[26] = 30,
[27] = 30,
[28] = 30,
[29] = 30,
[30] = 62
}

Typenames = {
	[1] = "Burgershot",
	[2] = "Zip",
	[3] = "24-7",
	[4] = "AmmuNation",
	[5] = "CluckingBell",
	[6] = "iRotics",
	[7] = "Well Stacked Pizza",
	[8] = "Victim",
	[9] = "Binco",
	[13] = "DidierSachs",
	[16] = "Restaurant",
	[18] = "RustyRingDonuts",
	[19] = "SubUrban",
	[22] = "Casino",
	[23] = "Pro Laps",
	[24] = "City Department",
	[30] = "Doneasty"
}

function CInteriorManager:spawnInteriorFuncs(typ, dim, ...)

	if (typ == 1) then
		new(CBurgershot, dim, ...)
	end
	if (typ == 2) then
		new(CZip, dim, ...)
	end
	if (typ == 3) then
		new(C24_7, dim, ...)
	end
	if (typ == 4) then
		new(CAmmuNation, 1,dim, ...)
	end
	if (typ == 5) then
		new(CCluckinBell, dim, ...)
	end
	if (typ == 6) then
		new(CSexshop, dim, ...)
	end
	if (typ == 7) then
		new(CWellStackedPizza, dim, ...)
	end
	if (typ == 8) then
		new(CVictim, dim, ...)
	end
	if (typ == 9) then
		new(CBinco, dim, ...)
	end
	if (typ == 13) then
		new(CDidierSachs, dim, ...)
	end
	if (typ == 16) then
		new(CRestaurant, dim, ...)
	end
	if (typ == 18) then
		new(CRustyRingDonuts, dim, ...)
	end
	if (typ == 19) then
		new(CSubUrban, dim, ...)
	end
	if (typ == 22) then
		new(CCasino, dim, ...)
	end
	if (typ == 23) then
		new(CProLaps, dim, ...)
	end
	if (typ == 24) then
		new(CCityDepartment, dim, ...)
	end
	if (typ == 30) then
		new(CDoneasty, dim, ...)
		
	end
end

function CInteriorManager:createMarkers()
	local start = getTickCount()
	
	local types = CDatabase:getInstance():query("SELECT * FROM interior_type")
	local intTypes = {}
	for i, v in ipairs(types) do
		intTypes[tonumber(v['ID'])] = v
	end
	
	
	local result = CDatabase:getInstance():query("SELECT * FROM  `interiors`")
	if(#result > 0) then
		for res,value in pairs(result) do
			if (not blips[tonumber(value["IntType"])]) then
				outputServerLog("Es ist ein Fehler aufgetreten. Code: Marker3 ||"..value["IntType"])
				return false
			end
			local port = createMarker(value["X"], value["Y"], value["Z"], value["type"], value["size"], gettok(value["color"],1,"|"), gettok(value["color"],2,"|"), gettok(value["color"],3,"|"))
			enew(port, CIntMarker, value["id"], value["Name"], value["IntType"], value["Interior"], value["Dimension"])
			if (port) then
				if (intTypes[port:getType()]) then
					-- Destination vom Außenmarker
					port:setPortData(intTypes[port:getType()]["Int"],value["id"]+20000, tonumber(gettok(intTypes[port:getType()]["DestX"],1,"|")), intTypes[port:getType()]["DestY"], intTypes[port:getType()]["DestZ"],tonumber(gettok(intTypes[port:getType()]["DestX"],2,"|")))
					
					-- Innenmarker deklaration
					local port2 = createMarker(intTypes[port:getType()]["X"], intTypes[port:getType()]["Y"], intTypes[port:getType()]["Z"], "corona", intTypes[port:getType()]["size"], gettok(value["color"],1,"|"), gettok(value["color"],2,"|"), gettok(value["color"],3,"|"))
					enew(port2, CIntMarker, value["id"], "Backport: "..value["Name"], 0, intTypes[port:getType()]["Int"], value["id"]+20000)
					local x,y,z = getElementPosition(port)
					setElementData(port2, "Type", "PortOut")
					setElementData(port2, "PortType", Typenames[value["IntType"]])
					setElementData(port2, "Location", getZoneName(x,y,z))
				
					-- Destination vom Innenmarker
					port2:setPortData(value["DestInterior"], value["DestDimension"], value["DestX"], value["DestY"], value["DestZ"],value["DestRotation"])

					self:spawnInteriorFuncs(value["IntType"], value["id"]+20000, value["Filliale"], value["Chain"])
				else
					outputServerLog("Interior nicht geaddet. Code: Marker2")
				end
			else
				outputServerLog("Es ist ein Fehler aufgetreten. Code: Marker1")
			end
			
			if (value["Blip"] ~= 0) then
				createBlip (value["X"], value["Y"], value["Z"], value["Blip"], 2, 0, 0, 0, 255,0,150, getRootElement() )
			end	
		end
	end
	-- Sorry Rewrite, kein Interior da :D
	new(CBaumarkt, 0)

	outputServerLog("Es wurde(n) "..tostring(#result).." Teleportmarker gefunden! (" .. getTickCount() - start .. "ms)")
end

--[[

Adminfunktionen

function CInterriorManager:getPosOut(thePlayer, cmd)
	if (isAdmin(thePlayer) > 1) then
		local x,y,z = getElementPosition(thePlayer)
		local dim = getElementDimension(thePlayer)
		local int = getElementInterior(thePlayer)
		local rx,ry,rz = getPedRotation(thePlayer)
		setElementData(thePlayer, "Tempoutx", x)
		setElementData(thePlayer, "Tempouty", y)
		setElementData(thePlayer, "Tempoutz", z)
		setElementData(thePlayer, "Tempoutdim", dim)
		setElementData(thePlayer, "Tempoutint", int)
		setElementData(thePlayer, "Tempoutrotx", rx)
		showInfoBox(thePlayer,"info", "Koordinaten erfolgreich aufgenommen!")
	else
		showInfoBox(thePlayer,"error", "Für diesen Vorgang besitzt du nicht die nötigen Rechte!")
	end
end
addCommandHandler("posout", getPosOut)

function CInterriorManager:getPosIn(thePlayer, cmd)
	if (isAdmin(thePlayer) > 1) then
		local x,y,z = getElementPosition(thePlayer)
		local dim = getElementDimension(thePlayer)
		local int = getElementInterior(thePlayer)
		local rx,ry,rz = getPedRotation(thePlayer)
		setElementData(thePlayer, "Tempinx", x)
		setElementData(thePlayer, "Tempiny", y)
		setElementData(thePlayer, "Tempinz", z)
		setElementData(thePlayer, "Tempindim", dim)
		setElementData(thePlayer, "Tempinint", int)
		setElementData(thePlayer, "Tempinrotx", rx)
		showInfoBox(thePlayer,"info", "Koordinaten erfolgreich aufgenommen!")
	else
		showInfoBox(thePlayer,"error", "Für diesen Vorgang besitzt du nicht die nötigen Rechte!")
	end
end
addCommandHandler("posin", getPosIn)

function CInterriorManager:createIntPort(thePlayer, cmd, name, inttype)
	if (not size) then
		size = 1
	end
	if (not color) then
		color= "255|255|255"
	end
	
	if (isAdmin(thePlayer) > 1) then
		local xin = getElementData(thePlayer, "Tempinx")
		local yin = getElementData(thePlayer, "Tempiny")
		local zin = getElementData(thePlayer, "Tempinz")
		local dimin = getElementData(thePlayer, "Tempindim")
		local intin = getElementData(thePlayer, "Tempinint")
		local xout = getElementData(thePlayer, "Tempoutx")
		local rotxout = getElementData(thePlayer, "Tempoutrotx")
		local yout = getElementData(thePlayer, "Tempouty")
		local zout = getElementData(thePlayer, "Tempoutz")
		local dimout = getElementData(thePlayer, "Tempoutdim")
		local intout = getElementData(thePlayer, "Tempoutint")
		
		if (not (xin and yin and zin and dimin and intin and xout and yout and zout and dimout and intout and rotxout) ) then  -- !(m1#m2#m3...#mn) - returns false;
			showInfoBox(thePlayer,"error", "Die Markerkoordinaten müssen festgelegt werden!")
			return false
		end
		
		local size = 1
		local color= "125|125|0"
		
		local query = "INSERT INTO `rl`.`Interiors` (`id` ,`Name` ,`Interior` ,`Dimension` ,`X` ,`Y` ,`Z` ,`DestInterior` ,`DestDimension` ,`DestX` ,`DestY` ,`DestZ` ,`DestRotation` ,`type` ,`size` ,`color` ,`IntType` ,`Blip`)VALUES (NULL ,'"..name.."', '"..getElementData(thePlayer, "Tempinint").."', '"..getElementData(thePlayer, "Tempindim").."', '"..getElementData(thePlayer, "Tempinx").."', '"..getElementData(thePlayer, "Tempiny").."', '"..getElementData(thePlayer, "Tempinz").."', '"..getElementData(thePlayer, "Tempoutint").."', '"..getElementData(thePlayer, "Tempoutdim").."', '"..getElementData(thePlayer, "Tempoutx").."', '"..getElementData(thePlayer, "Tempouty").."', '"..getElementData(thePlayer, "Tempoutz").."', '"..getElementData(thePlayer, "Tempoutrotx").."', 'corona', '"..size.."', '"..color.."', '"..tonumber(inttype).."', '"..bliptable[tonumber(inttype)].."');"
		
		if (CDatabase:getInstance():query(query)) then
			showInfoBox(thePlayer,"info", "Der Marker wurde erfolgreich hinzugefügt!") 
			restartResource(getThisResource ( ))
		else
			showInfoBox(thePlayer,"error", "Der konnte nicht erstellt werden Fehlercode: Create1")
		end	
	
	else
		showInfoBox(thePlayer,"error", "Für diesen Vorgang besitzt du nicht die nötigen Rechte!")
	end
end
addCommandHandler("createint", createIntPort)

function CInterriorManager:createIntType(thePlayer, cmd, func) --Dim ergibt sich aus der ID des Teleportmarkers
	if (isAdmin(thePlayer) > 2) then
	
		local xin = getElementData(thePlayer, "Tempinx")
		local yin = getElementData(thePlayer, "Tempiny")
		local zin = getElementData(thePlayer, "Tempinz")
		local dimin = getElementData(thePlayer, "Tempindim")
		local intin = getElementData(thePlayer, "Tempinint")
		local xout = getElementData(thePlayer, "Tempoutx")
		local rotxout = getElementData(thePlayer, "Tempoutrotx")
		local yout = getElementData(thePlayer, "Tempouty")
		local zout = getElementData(thePlayer, "Tempoutz")
		local dimout = getElementData(thePlayer, "Tempoutdim")
		local intout = getElementData(thePlayer, "Tempoutint")
		
		if (not (xin and yin and zin and dimin and intin and xout and yout and zout and dimout and intout and rotxout) ) then  -- !(m1#m2#m3...#mn) - returns false;
			showInfoBox(thePlayer,"error", "Die Markerkoordinaten müssen festgelegt werden!")
			return false
		end
	
		local size = 1
		local color= "125|125|0"
		local query = "INSERT INTO `rl`.`Interior_type` (`ID` ,`Int` ,`X` ,`Y` ,`Z` ,`DestX` ,`DestY` ,`DestZ` ,`color` ,`size` ,`func`)VALUES (NULL , '"..getElementData(thePlayer, "Tempinint").."', '"..getElementData(thePlayer, "Tempoutx").."', '"..getElementData(thePlayer, "Tempouty").."', '"..getElementData(thePlayer, "Tempoutz").."', '"..getElementData(thePlayer, "Tempinx").."|"..getElementData(thePlayer, "Tempoutrotx").."', '"..getElementData(thePlayer, "Tempiny").."', '"..getElementData(thePlayer, "Tempinz").."', '"..color.."', '"..size.."', '"..func.."');"
		if (CDatabase:getInstance():query(query)) then
			showInfoBox(thePlayer,"info", "Der Marker wurde erfolgreich hinzugefügt!") 
		else
			showInfoBox(thePlayer,"error", "Der konnte nicht erstellt werden Fehlercode: Create1")
		end
	else
		showInfoBox(thePlayer,"error", "Für diesen Vorgang besitzt du nicht die nötigen Rechte!")
	end
end
addCommandHandler("createinttype", createIntType)

]]