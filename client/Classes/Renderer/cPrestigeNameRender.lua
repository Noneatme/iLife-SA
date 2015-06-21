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
-- ## Name: PrestigeNameRenderer.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

PrestigeNameRenderer = {};
PrestigeNameRenderer.__index = PrestigeNameRenderer;

addEvent("onPrestigeColToggle", true)

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function PrestigeNameRenderer:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeNameRenderer:Render()
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

								local sName 	= getElementData(Faction, "Title")
								local sOwner 	= getElementData(Faction, "OwnerName")

								dxDrawText("Prestige: "..sName.."\nBesitzer: "..sOwner, sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 200), fontbig, "default-bold", "center")
								dxDrawText("Prestige: "..sName.."\nBesitzer: "..sOwner, sx, sy, sx, sy, tocolor(255, 255, 255, 200), fontbig, "default-bold", "center")
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

function PrestigeNameRenderer:ToggleD(uCol, b)
	if(b) then
		self.prestiges[uCol] = uCol;
	else
		local newTBL = {}
		for index, da in pairs(self.prestiges) do
			if not(index == uCol) then
				newTBL[index] = da;
			end
		end
		self.prestiges = newTBL;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function PrestigeNameRenderer:Constructor(...)
	self.prestiges		= {}
	self.enabled		= toBoolean(config:getConfig("render_3dtext"))

	-- Klassenvariablen --
	self.renderFunc		= function(...) self:Render(...) end;
	self.toggleFunc		= function(...) self:ToggleD(...) end;
	-- Methoden --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	-- Events --
	addEventHandler("onPrestigeColToggle", getLocalPlayer(), self.toggleFunc)

	--logger:OutputInfo("[CALLING] PrestigeNameRenderer: Constructor");
end

-- EVENT HANDLER --
