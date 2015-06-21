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
-- ## Name: FactionNameRenderer.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

FactionNameRenderer = {};
FactionNameRenderer.__index = FactionNameRenderer;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function FactionNameRenderer:New(...)
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

function FactionNameRenderer:Render()
	if(self.enabled) then
		local Factions = getElementData(localPlayer, "p:visitedFaction");
		if(Factions) then
			for index, Faction in pairs(Factions) do
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
								-- DRAW --
								local name		= getElementData(Faction, "faction:Name");
								local leader	= getElementData(Faction, "faction:Leader");
								local coLeader	= getElementData(Faction, "faction:CoLeader");
								local od		= getElementData(Faction, "faction:Distanz");

								if(od == 0) then
									od = "Nein"
								else
									od = "Ja("..od..")";
								end

								dxDrawText("Fraktion: "..name.."\nFraktionsleiter: "..leader.."\nStellv. Leiter: "..coLeader.."\nObjekt Distanz: "..od, sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 200), fontbig, "default-bold", "center")
								dxDrawText("Fraktion: "..name.."\nFraktionsleiter: "..leader.."\nStellv. Leiter: "..coLeader.."\nObjekt Distanz: "..od, sx, sy, sx, sy, tocolor(255, 255, 255, 200), fontbig, "default-bold", "center")

							end
						end
					end
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FactionNameRenderer:Constructor(...)
	-- Klassenvariablen --
	self.renderFunc		= function(...) self:Render(...) end;
	self.enabled		= toBoolean(config:getConfig("render_3dtext"))

	-- Methoden --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	-- Events --

	--logger:OutputInfo("[CALLING] FactionNameRenderer: Constructor");
end

-- EVENT HANDLER --
