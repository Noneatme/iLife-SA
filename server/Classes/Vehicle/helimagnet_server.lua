--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--------------------------
------- (c) 2010 ---------
-- by Zipper & MrCrunch --
-- and Vio MTA:RL Crew ---
--------------------------

-- Attaches a magnet to it if its a Leviathan
function setVehicleAsMagnetHelicopter ( veh )

	if getElementModel ( veh ) == 417 then
		local x, y, z = getElementPosition ( veh )
		local magnet = createObject ( 1301, x, y, z-1.5)
		attachElements ( magnet, veh, 0, 0, -1.5 )
		setElementData ( veh, "magpos", -1.5 )
		setElementData ( veh, "magnet", magnet )
		setElementData ( veh, "magnetic", true )
		setElementData ( veh, "hasmagnetactivated", false )
	end
end

-- When the helicopter is destroyed, kill the magnet
function destroyMagnet ( veh )

	if veh then
		source = veh
	end
	if getElementData ( source, "magnetic" ) then
		local magnet = getElementData ( veh, "magnet" )
		destroyElement ( magnet )
	end
end
addEventHandler ( "onVehicleExplode", getRootElement(), destroyMagnet )

-- Moves the magnet up/down
function magnetUp ( player )
	if not source then return false end
	
	if not (getElementData ( source, "magnetic" )) then
		return false
	end

	local veh = getPedOccupiedVehicle ( player )
	if veh then
		local magpos = getElementData ( veh, "magpos" )
		if magpos < -1.5 then
			local magnet = getElementData ( veh, "magnet" )
			detachElements ( magnet )
			local magpos = magpos+0.1
			attachElements ( magnet, veh, 0, 0, magpos, 0, 0, 0 )
			setElementData ( veh, "magpos", magpos )
		end
	end
end
function magnetDown ( player )
	if not source then return false end
	
	if not (getElementData ( source, "magnetic" )) then
		return false
	end

	local veh = getPedOccupiedVehicle ( player )
	if veh then
		local magpos = getElementData ( veh, "magpos" )
		if magpos > -15 then
			local magnet = getElementData ( veh, "magnet" )
			detachElements ( magnet )
			local magpos = magpos-0.1
			attachElements ( magnet, veh, 0, 0, magpos, 0, 0, 0 )
			setElementData ( veh, "magpos", magpos )
		end
	end
end

-- (un)Bind the keys
function bindTrigger ()
	if not(getElementType(source) == "player") then return end
	if not isKeyBound ( source, "lctrl", "down", magnetVehicleCheck ) then
		bindKey ( source, "lctrl", "down", magnetVehicleCheck )
		bindKey ( source, "rctrl", "down", magnetVehicleCheck )
		bindKey ( source, "num_sub", "down", magnetUp )
		bindKey ( source, "num_add", "down", magnetDown )
	end
end
function unbindTrigger ()
	if not(getElementType(source) == "player") then return end
	if isKeyBound ( source, "lctrl", "down", magnetVehicleCheck ) then
		unbindKey ( source, "lctrl", "down", magnetVehicleCheck )
		unbindKey ( source, "rctrl", "down", magnetVehicleCheck )
		unbindKey ( source, "num_sub", "down", magnetUp )
		unbindKey ( source, "num_add", "down", magnetDown )
	end
end
addEventHandler ( "onPlayerVehicleEnter", getRootElement(), bindTrigger )
addEventHandler ( "onPlayerVehicleExit", getRootElement(), unbindTrigger )
addEventHandler ( "onPlayerWasted", getRootElement(), unbindTrigger )

-- When Ctrl is pressed, attach / detatch the helicopter
function magnetVehicleCheck ( player )

	local veh = getPedOccupiedVehicle ( player )
	if veh then
		if getElementData ( veh, "magnetic" ) then
			if getElementData ( veh, "hasmagnetactivated" ) then
				setElementData ( veh, "hasmagnetactivated", false )
				detachElements ( getElementData ( veh, "magneticVeh" ) )
			else
				local magnet = getElementData ( veh, "magnet" )
				local x, y, z = getElementPosition ( magnet )
				local magpos = getElementData ( veh, "magpos" )
				local marker = createColSphere ( x , y , z, 2 )
				local vehs = getElementsWithinColShape ( marker, "vehicle" )
				destroyElement ( marker )
				grabveh = false
				for key, vehitem in ipairs(vehs) do
					if vehitem ~= veh then
						local grabveh = vehitem
						attachElements ( grabveh, magnet, 0, 0, -1, 0, 0, getVehicleRotation(grabveh) )
						setElementData ( veh, "hasmagnetactivated", true )
						setElementData ( veh, "magneticVeh", grabveh )
						break
					end
				end
			end
		end
	end
end