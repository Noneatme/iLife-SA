--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: MTA iLife				##
-- ## Name: BusinessNameRenderer.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

BusinessNameRenderer = inherit(cSingleton)

--[[

]]


-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessNameRenderer:render()
	if(self.enabled) then
		local Prestiges = self.prestiges;
		if(Prestiges) then
			for index, Faction in pairs(Prestiges) do

				if(isElement(Faction)) then
					local x, y, z = getElementPosition(Faction)
					local x2, y2, z2 = getElementPosition(localPlayer)
					if(isLineOfSightClear(x, y, z, x2, y2, z2, true, false, false, false)) then
						z = z+0.5
						local sx, sy = getScreenFromWorldPosition(x, y, z)
						if(sx) and (sy) then
							local x5, y5, z5 = getElementPosition(Faction);
							local x6, y6, z6 = getCameraMatrix();

							local distance = getDistanceBetweenPoints3D(x5, y5, z5, x6, y6, z6)

							if(distance < 20) then
								local fontbig = 2-(distance/10)

								local sName 	= getElementData(Faction, "Title") or "-"
								local sOwner 	= getElementData(Faction, "OwnerName") or "-"
								local cost		= getElementData(Faction, "Cost") or 0;
								local sEinkommen	= getElementData(Faction, "Einkommen") or "-";
								local iID		= getElementData(Faction, "ID") or 0
								dxDrawText("ID: "..iID.."\nFilliale: "..sName.."\nFillialleiter: "..sOwner.."\nEinkommen: $"..sEinkommen.."\nKosten: $"..cost, sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 200), fontbig, "default-bold", "center")
								dxDrawText("ID: "..iID.."\nFilliale: "..sName.."\nFillialleiter: "..sOwner.."\nEinkommen: $"..sEinkommen.."\nKosten: $"..cost, sx, sy, sx, sy, tocolor(0, 155, 255, 200), fontbig, "default-bold", "center")
							end
						end
					end
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// ToggleD	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessNameRenderer:toggleD(uCol, b)
	if(b) then
		self.prestiges[uCol] = uCol;
	else
		self.prestiges[uCol] = nil;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BusinessNameRenderer:constructor(...)
	addEvent("onBusinessColToggle", true)

	self.prestiges		= {}

	-- Klassenvariablen --
	self.renderFunc		= function(...) self:render(...) end;
	self.toggleFunc		= function(...) self:toggleD(...) end;

	self.enabled		= toBoolean(config:getConfig("render_3dtext"))


	-- Methoden --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	-- Events --
	addEventHandler("onBusinessColToggle", getLocalPlayer(), self.toggleFunc)

	--logger:OutputInfo("[CALLING] BusinessNameRenderer: Constructor");
end

-- EVENT HANDLER --
