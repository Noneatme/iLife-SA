--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--setModelHandling ( 503, "maxVelocity", 10)


local pos={}

load_commands_func = function()
	if(DEFINE_DEBUG) then
		addCommandHandler("int", function (thePlayer,cmd, int)

			if (tonumber(int) == 0) then
				thePlayer:setPosition(pos[thePlayer:getName()]["X"],pos[thePlayer:getName()]["Y"], pos[thePlayer:getName()]["Z"])
				thePlayer:setInterior(0)
				thePlayer:setDimension(0)
			else
				if (thePlayer:getDimension() ~= 0) then

				else
					x,y,z = thePlayer:getPosition()
					pos[thePlayer:getName()]={}
					pos[thePlayer:getName()]["X"] = x
					pos[thePlayer:getName()]["Y"] = y
					pos[thePlayer:getName()]["Z"] = z
				end

				thePlayer:setFrozen(true)
				result = CDatabase:getInstance():query("SELECT * FROM House_Interiors WHERE ID="..tonumber(int))

				local int = result[1]["Int"]
				local x = result[1]["X"]
				local y = result[1]["Y"]
				local z = result[1]["Z"]

				outputChatBox(tostring(result[1]["Int"]).." | "..tostring(result[1]["X"]).." | "..tostring(result[1]["Y"]).." | "..tostring(result[1]["Z"]))

				thePlayer:setInterior(int)
				thePlayer:setPosition(x,y,z)
				thePlayer:setDimension(1)
				thePlayer:setFrozen(false)
			end
		end
		)

		--[[
		addCommandHandler("houseremove", function(thePlayer, cmd, ID)
			local X,Y,Z = thePlayer:getPosition()
			CDatabase:getInstance():query("DELETE FROM Houses WHERE ID=?", tonumber(ID))
			if (Houses[tonumber(ID)]) then
				destroyElement(Houses[tonumber(ID)])
			end
		end
		)]]


		--[[
		addCommandHandler("houseadd", function(thePlayer, cmd, int, cost)
			local X,Y,Z = thePlayer:getPosition()
			CDatabase:getInstance():query("INSERT INTO  `rl`.`Houses` (`ID` , `Cost` , `Owner` , `Koords` , `Locked` , `Interior` ) VALUES ( NULL , ?,  '0', ?,  '0', ?);", tonumber(cost), tostring(thePlayer:getInterior()).."|"..tostring(thePlayer:getDimension()).."|"..tostring(X).."|"..tostring(Y).."|"..tostring(Z),tonumber(int))
			thePickup = createPickup(X,Y,Z, 3, 1273, 1)
			result2 = CDatabase:getInstance():query("SELECT * FROM House_Interiors WHERE ID =?", int)
			enew(thePickup, CHouse, 1337, result2[1]["Price"]+cost, 0, 0,0, toJSON(result2[1]))
			thePickup:setBlip(createBlip(X,Y,Z, 31, 1, 0, 0, 0, 255,0,150, getRootElement()))
		end
		)]]

		addCommandHandler("pos",
		function(thePlayer)
			local i = thePlayer:getInterior()
			local d = thePlayer:getDimension()
			local x,y,z = thePlayer:getPosition()
			local rx, ry, rz = thePlayer:getRotation()
			outputChatBox(tostring(i).."|"..tostring(d).."|"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz))
		end
		)

		addCommandHandler("vpos",
		function(thePlayer)
			local i = thePlayer:getVehicle():getInterior()
			local d = thePlayer:getVehicle():getDimension()
			local x,y,z = thePlayer:getVehicle():getPosition()
			local rx, ry, rz = thePlayer:getVehicle():getRotation()
			outputChatBox(tostring(i).."|"..tostring(d).."|"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz))
		end
		)

		function toggleCursor(thePlayer)
			showCursor(thePlayer, not (isCursorShowing(thePlayer)))
		end

		addCommandHandler("geld", function(uPlayer)
			uPlayer:addMoney(100000)
		end)

		addCommandHandler("hunger", function(tp)
			tp:setHunger(100);
		end)
		addCommandHandler("trash",
		function(thePlayer, cmd)
			local x,y,z = thePlayer:getPosition()
			local int = thePlayer:getInterior()
			local dim = thePlayer:getDimension()

			-- U wot m8??
			-- Das Schlimmste was man in Lua machen kann, MTA Schrott in den Debugtable von der Lua VM Integrieren
		--	_G["Trash"..getPlayerName(thePlayer)] = createObject(1359, x+1,y,z)
			--1549 innen
			--[[
			setElementInterior(_G["Trash"..getPlayerName(thePlayer)], int)
			setElementDimension(_G["Trash"..getPlayerName(thePlayer)], dim)
			setElementCollisionsEnabled(_G["Trash"..getPlayerName(thePlayer)], false)
			attachElements(_G["Trash"..getPlayerName(thePlayer)], thePlayer, 0, 0, -0.35, 0, 0, 0)]]
		end
		)

		addCommandHandler("tadd",
		function(thePlayer, cmd)
			local x,y,z = getElementPosition(_G["Trash"..getPlayerName(thePlayer)])
			local int = getElementInterior(_G["Trash"..getPlayerName(thePlayer)])
			local dim = getElementDimension(_G["Trash"..getPlayerName(thePlayer)])
			local rx,ry,rz = getElementRotation(thePlayer)

			local Kords = int.."|"..dim.."|"..x.."|"..y.."|"..z.."|"..rx.."|"..ry.."|"..rz

			CDatabase:getInstance():query("INSERT INTO `Trashcan` (`ID` ,`Pos`)VALUES (NULL ,  '"..Kords.."');")

			local can = createObject(1359, x,y,z,rx,ry,rz, false)
			enew(can, CTrashcan, #Trashcans+1, Kords)
		end
		)

		addCommandHandler("sound",
		function (thePlayer, cmd, sid)
			playSoundFrontEnd(thePlayer, tonumber(sid))
		end
		)

		addCommandHandler("r", function()
			restartResource(getThisResource())
		end)

		addCommandHandler("garage", function(thePlayer, cmd, gid)
			setGarageOpen(tonumber(gid), not(isGarageOpen(tonumber(gid))))
		end)


		addCommandHandler("hunger", function(thePlayer, cmd, hunger)
			thePlayer:setHunger(tonumber(hunger))
		end)

		addCommandHandler("cam", function(thePlayer, cmd)
			outputChatBox(tostring(getCameraMatrix(thePlayer)))
			local x,y,z,lx,ly,lz,roll,fov = getCameraMatrix(thePlayer)
			outputChatBox(x..","..y..","..z..","..lx..","..ly..","..lz)
		end
		)


		addCommandHandler("ringthatshit", function(player, cmd, ...)
			triggerClientEvent(getRootElement(), "onChurchbellEvent", getRootElement(), ...)
		end)

		addCommandHandler("addInfopickup",
		function(player,cmd,...)
			local parametersTable = {...}
			local stringWithAllParameters = table.concat( parametersTable, " " )
			if stringWithAllParameters ~= nil then
				local x,y,z = getElementPosition(player)
				local int = getElementInterior(player)
				local dim = getElementDimension(player)
				CDatabase:getInstance():query("INSERT INTO `Infopickups`(`X`, `Y`, `Z`, `Int`, `Dim`, `Text`) VALUES (?,?,?,?,?,?)",x,y,z,int,dim,stringWithAllParameters)
				outputChatBox("Info erstellt!",player,0,255,0)

				local infopickup = createPickup(x,y,z,3,1239,0)
				setElementInterior(infopickup,int)
				setElementDimension(infopickup,dim)
				enew(infopickup,CInfoPickup,math.random(15000,100000), x, y, z, int, dim, stringWithAllParameters)
			else
				outputChatBox("Kein Text angegeben!",player,255,0,0)
			end
		end
		)

		addCommandHandler("addDrivein",
		function(player, cmd, theType)
			if ( (tonumber(theType) > 0) and (tonumber(theType)<=5)) then
				local x,y,z = getElementPosition(player)
				CDatabase:getInstance():query("INSERT INTO `DriveIn`(`Type`, `X`, `Y`, `Z`) VALUES (?,?,?,?)", tonumber(theType),x,y,z)
				outputChatBox("Drivein erstellt",player,0,255,0)

				local drivein = createMarker(x, y, z, "corona", 4, 255, 0, 0)
				enew(drivein, CDriveIn, math.random(500,25000000), theType, x, y, z)
			else
				outputChatBox("Bitte Typ angeben!",player,0,255,0)
			end
		end
		)

		addCommandHandler("addNPC",
		function(player)
			local x,y,z = getElementPosition(player)
			local _,_,rz = getElementRotation(player)
			CDatabase:getInstance():query("INSERT INTO `Npc`(`X`, `Y`, `Z`, `Rot`) VALUES (?,?,?,?)",x,y,z,rz)
			outputChatBox("NPC erstellt",player,0,255,0)
			local zahl = math.random(1,6)
			if zahl == 1 then
				local npc = createPed(14,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			elseif zahl == 2 then
				local npc = createPed(28,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			elseif zahl == 3 then
				local npc = createPed(79,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			elseif zahl == 4 then
				local npc = createPed(168,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			elseif zahl == 5 then
				local npc = createPed(135,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			elseif zahl == 6 then
				local npc = createPed(143,x,y,z,rz)
				enew(npc,CNPC,math.random(500,25000000),x,y,z,rz,zahl)

			end
		end
		)

		addCommandHandler("addNoobcar",
		function(player, cmd, model)
			local theVehicle = getPedOccupiedVehicle(player)
			if theVehicle then
				if model then
					local x,y,z = getElementPosition(theVehicle)
					local rx,ry,rz = getElementRotation(theVehicle)
					CDatabase:getInstance():query("INSERT INTO `Noobcars`(`Model`, `X`, `Y`, `Z`,`RX`, `RY`, `RZ`) VALUES (?,?,?,?,?,?,?)", tonumber(model),x,y,z,rx,ry,rz)
					outputChatBox("Noobcar erstellt",player,0,255,0)

					local noobcar = createVehicle(model,x, y, z,rx,ry,rz,"NOOBCAR")
					setElementFrozen(noobcar,true)
					enew(noobcar, CNoobcars, math.random(500,25000000), model, x, y, z,rx,ry,rz)
				else
					outputChatBox("Keine Model ID angegeben!",player,255,0)
				end
			else
				outputChatBox("Du bist in keinem Auto",player,0,255,0)
			end
		end
		)

		addCommandHandler("addParachute",
		function(player)
			local x,y,z = getElementPosition(player)
			CDatabase:getInstance():query("INSERT INTO `Parachutes`(`X`, `Y`, `Z`) VALUES (?,?,?)", x,y,z)
			outputChatBox("Parachute erstellt",player,0,255,0)

			local parachute = createMarker(x,y,z-0.8,"cylinder")
			enew(parachute, CParachute, math.random(500,25000000), x,y,z)
		end
		)
--[[
		addCommandHandler("houseadd", function(thePlayer, cmd, int, cost)
			local X,Y,Z = thePlayer:getPosition()
			CDatabase:getInstance():query("INSERT INTO  `rl`.`Houses` (`ID` , `Cost` , `Owner` , `Koords` , `Locked` , `Interior` ) VALUES ( NULL , ?,  '0', ?,  '0', ?);", tonumber(cost), tostring(thePlayer:getInterior()).."|"..tostring(thePlayer:getDimension()).."|"..tostring(X).."|"..tostring(Y).."|"..tostring(Z),tonumber(int))
			thePickup = createPickup(X,Y,Z, 3, 1273, 1)
			result2 = CDatabase:getInstance():query("SELECT * FROM House_Interiors WHERE ID =?", int)
			enew(thePickup, CHouse, 1337, result2[1]["Price"]+cost, 0, 0,0, toJSON(result2[1]))
			thePickup:setBlip(createBlip(X,Y,Z, 31, 1, 0, 0, 0, 255,0,150, getRootElement()))
		end
		)]]

	end

	addCommandHandler("fveh",
	function(thePlayer, cmd, FID)
		if ((getElementData(thePlayer, "online")) and (thePlayer:getAdminLevel() >= 4)) then
			local veh = thePlayer:getVehicle()
			local x,y,z = veh:getPosition()
			local rx,ry,rz = veh:getRotation()
			local c1,c2,c3,c4,c5,c6 = veh:getColor(true)

			outputChatBox("INSERT INTO  `Faction_Vehicle` (`ID` ,`VID` ,`FID` ,`Int` ,`Dim` ,`Koords` ,`Color` ,`Tuning` ,`KM` ,`Type` ,`Left`)VALUES (NULL ,  '"..veh:getModel().."',  '"..tonumber(FID).."',  '"..veh:getInterior().."',  '"..veh:getDimension().."',  '"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz).."',  '"..tostring(c1).."|"..tostring(c2).."|"..tostring(c3).."|"..tostring(c4).."',  '0|0|0|0|0|0|0',  '0',  '1',  '-1');")
			CDatabase:getInstance():query("INSERT INTO  `Faction_Vehicle` (`ID` ,`VID` ,`FID` ,`Int` ,`Dim` ,`Koords` ,`Color` ,`Tuning` ,`KM` ,`Type` ,`Left`)VALUES (NULL ,  '"..veh:getModel().."',  '"..tonumber(FID).."',  '"..veh:getInterior().."',  '"..veh:getDimension().."',  '"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz).."',  '"..tostring(c1).."|"..tostring(c2).."|"..tostring(c3).."|"..tostring(c4).."|"..tostring(c5).."|"..tostring(c6).."',  '0|0|0|0|0|0|0',  '0',  '1',  '-1');")
		end
	end
	)
end

function createAbsoluteColCuboid(fX, fY, fZ, lX, lY, lZ)
	return createColCuboid(fX,fY,fZ, lX-fX, lY-fY, lZ-fZ)
end

--[[
addCommandHandler("cadd",
	function(thePlayer, cmd, ShopID, Type, Stock, Price)
		local veh = thePlayer:getVehicle()
		local x,y,z = veh:getPosition()
		local rx,ry,rz = veh:getRotation()
		local c1,c2,c3,c4 = veh:getColor(true)

		outputChatBox("INSERT INTO `rl`.`Shop_Vehicle_Data` (`ID`, `VID`, `ShopID`, `Int`, `Dim`, `Koords`, `Color`, `Tuning`, `KM`, `Type`, `Stock`, `Price`) VALUES (NULL, '"..veh:getModel().."', '"..tonumber(ShopID).."', '"..veh:getInterior().."', '"..veh:getDimension().."', '"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz).."', '"..tostring(c1).."|"..tostring(c2).."|"..tostring(c3).."|"..tostring(c4).."', '0|0|0|0|0|0|0', '0', '"..tonumber(Type).."', '"..tonumber(Stock).."', '"..tonumber(Price).."');")
		CDatabase:getInstance():query("INSERT INTO `rl`.`Shop_Vehicle_Data` (`ID`, `VID`, `ShopID`, `Int`, `Dim`, `Koords`, `Color`, `Tuning`, `KM`, `Type`, `Stock`, `Price`) VALUES (NULL, '"..veh:getModel().."', '"..tonumber(ShopID).."', '"..veh:getInterior().."', '"..veh:getDimension().."', '"..tostring(x).."|"..tostring(y).."|"..tostring(z).."|"..tostring(rx).."|"..tostring(ry).."|"..tostring(rz).."', '"..tostring(c1).."|"..tostring(c2).."|"..tostring(c3).."|"..tostring(c4).."', '0|0|0|0|0|0|0', '0', '"..tonumber(Type).."', '"..tonumber(Stock).."', '"..tonumber(Price).."');")
	end
)
]]
