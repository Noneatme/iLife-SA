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

-- Shows a rope between the helicopter and the magnet for the driver / passanger of the helicopter
function clientRenderMagnet ()

	local vehitem = getPedOccupiedVehicle ( getLocalPlayer() )
	if vehitem then
		local mv = getElementData ( vehitem, "magnet" )
		if mv then
			local x1, y1, z1 = getElementPosition ( mv )
			local x2, y2, z2 = getElementPosition ( vehitem )
			dxDrawLine3D ( x1, y1, z1, x2, y2, z2, tocolor ( 100, 100, 100, 255 ), 10 )
		end
	end
end
addEventHandler ( "onClientRender", getRootElement(), clientRenderMagnet )