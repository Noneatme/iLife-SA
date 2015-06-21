--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

function attachElementsInCorrectWay ( element1, element2 )
	local x1, y1, z1 = getElementPosition ( element1 )
	local x2, y2, z2 = getElementPosition ( element2 )
	attachElements ( element1, element2, x1-x2, y1-y2, z1-z2 )
end

addEventHandler( 'onClientResourceStart',resourceRoot,
	function( )
		--local veh = createVehicle(520, 2498,-1659,12)
		--local sound = playSound3D( 'http://listen.technobase.fm/tunein-dsl-pls',2498,-1659,12 ) 
		--attachElements(sound,veh,0,0,0)
		--setSoundMaxDistance( sound,50 )
	end
)

function addRadio(thePlayer, stream)
		thePlayer = source
		local x,y,z = getElementPosition( getPedOccupiedVehicle ( thePlayer ) )
		if (stream == 1) then
			sound = playSound3D( 'http://78.159.105.243:29082',x,y,z ) 
		end
		if (stream == 2) then
			sound = playSound3D( 'http://listen.technobase.fm/tunein-dsl-pls',x,y,z ) 
		end
		
		attachElements(sound,getPedOccupiedVehicle ( thePlayer ),0,0,0)
		setSoundMaxDistance( sound,75 )	
		setSoundVolume ( sound, 0.6 )
		
end
--addCommandHandler("1337", addRadio)
addEvent("Radio", true)
addEventHandler("Radio", getRootElement(),addRadio)

function realisticWeaponSounds(weapon)
	local x, y, z = getElementPosition(getLocalPlayer())
	local tX, tY, tZ = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, tX, tY, tZ)
	
	if distance < 25 and weapon >= 22 and weapon <= 34 then
		local randSound = math.random(27, 30)
		playSoundFrontEnd(randSound)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), realisticWeaponSounds)

function savePosDataCMD ( player, command, ... )
	player = getLocalPlayer();
   	 local xfloat,yfloat,zfloat = getElementPosition ( player )
   	 local rotstring = tostring ( getPedRotation ( player ) )
   	 local intstring = tostring ( getElementInterior ( player ) )
   	 local xstring = tostring ( xfloat )
   	 local ystring = tostring ( yfloat )
   	 local zstring = tostring ( zfloat )
   	 local note = table.concat({...}, " ")
   	 outputChatBox ( "SavePos Record: " .. note, player )
   	 outputChatBox ( "Position: " .. xstring .. ", " .. ystring .. ", " .. zstring, player )
   	 outputChatBox ( "Rotation: " .. rotstring, player )
   	 outputChatBox ( "Interior: " .. intstring, player )
   		 if ( isPedInVehicle ( player ) ) then
   			 local vx, vy, vz = getElementRotation ( getPedOccupiedVehicle ( player ) )
   			 outputChatBox ( "Veh Rot XYZ: " .. tostring ( vx ) .. ", " .. tostring ( vy ) .. ", " .. tostring ( vz ), player )
   		 end
   	 outputChatBox ( "-----------------------------", player )
end
--addCommandHandler ( "recordpos", savePosDataCMD )

function ped(command, skin, block, anim)
	localPlayer = getLocalPlayer()
	local x,y,z = getElementPosition(localPlayer)
	local rx,ry,rz = getElementRotation(localPlayer)
	thePed = createPed ( skin, x, y, z , rz)
	setPedAnimation ( thePed ,block, anim)

	outputChatBox("thePed = createPed ( "..skin..", "..x..", "..y..", "..z.." , "..rz..")")
	outputChatBox("setPedAnimation ( thePed ,"..block..", "..anim..")")

end
--addCommandHandler("ped", ped)

function dim(comd,dima)
	setElementDimension(getLocalPlayer(), dima)

end
--addCommandHandler("dim", dim)

addEvent("nimmDieScheissCollWeg",true)
addEvent("nimmDieScheissCollWeg",getRootElement(),
function()
setElementCollidableWith(source,getPedOccupiedVehicle(getPlayerFromName("Dawi")),false)
end)
