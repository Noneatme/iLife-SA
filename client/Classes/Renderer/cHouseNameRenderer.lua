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
-- ## Name: HouseNameRenderer.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HouseNameRenderer = {};
HouseNameRenderer.__index = HouseNameRenderer;

addEvent("onHouseShapeLeave", true);
addEvent("onHouseShapeEnter", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HouseNameRenderer:New(...)
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

function HouseNameRenderer:Render()
	if(self.enabled) then
		local houses = self.houses;
		if(houses) then
			for index, house in pairs(houses) do
				if(isElement(house)) then
					local x, y, z = getElementPosition(house)
					local x2, y2, z2 = getElementPosition(localPlayer)
					if(isLineOfSightClear(x, y, z, x2, y2, z2, true, false, false, false)) then
						z = z+0.5
						local sx, sy = getScreenFromWorldPosition(x, y, z)
						if(sx) and (sy) then
							local x5, y5, z5 = getElementPosition(house);
							local x6, y6, z6 = getCameraMatrix();

							local distance = getDistanceBetweenPoints3D(x5, y5, z5, x6, y6, z6)

							if(distance < 20) then
								local fontbig = 2-(distance/10)
								-- DRAW --
								local owner 	= getElementData(house, "h:iOwner")
								local ownerColor = "#FFFFFF"
								if (getElementData(house, "h:iFactionID") ~= 0) then
									owner = getElementData(house, "h:sFactionName")
								elseif (getElementData(house, "h:iCorporationID") ~= 0) then
									owner = getElementData(house, "h:sCorporationName")
									ownerColor	= string.sub(getElementData(house, "h:sCorporationColor"), 0, #getElementData(house, "h:sCorporationColor")-2)
								end

								local price 	= getElementData(house, "h:iCost")
								local locked 	= getElementData(house, "h:bLocked")
								local houseid 	= getElementData(house, "h:iID")
								local od		= getElementData(house, "h:iObjektDistanz");

								if(od == 0) then
									od = "Nein"
								else
									od = "Ja("..od..")";
								end

								local lockedstate = "aufgeschlossen"
								if(locked == true) then lockedstate = "verschlossen" end
								if not(owner) or (owner == 0) then owner = "Niemand"; end

								local zone = getZoneName(x, y, z, false)
								dxDrawText("Haus: "..houseid.." ("..zone..")\nBesitzer: "..owner.."\nPreis: $"..price.."\nObjekt Distanz: "..od.."\nStatus: "..lockedstate..".", sx+2, sy+2, sx, sy, tocolor(0, 0, 0, 200), fontbig, "default-bold", "center")
								dxDrawText("Haus: "..houseid.." ("..zone..")\nBesitzer: "..ownerColor..owner.."\n#FFFFFFPreis: $"..price.."\nObjekt Distanz: "..od.."\nStatus: "..lockedstate..".", sx, sy, sx, sy, tocolor(255, 255, 255, 200), fontbig, "default-bold", "center", "top", false, false, false, true)

							end
						end
					end
				end
			end
		end
	end
end

-- ///////////////////////////////
-- ///// LeaveCol	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HouseNameRenderer:LeaveCol(uCol)
	local newTBL = {}
	for index, da in pairs(self.houses) do
		if not(index == uCol) then
			newTBL[index] = da;
		end
	end

	self.houses = newTBL;
end

-- ///////////////////////////////
-- ///// EnterCol	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HouseNameRenderer:EnterCol(uCol)
	self.houses[uCol] = uCol;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HouseNameRenderer:Constructor(...)
	-- Klassenvariablen --
	self.renderFunc		= function(...) self:Render(...) end;
	self.leaveFunc		= function(...) self:LeaveCol(...) end;
	self.enterFunc		= function(...) self:EnterCol(...) end;

	self.houses			= {}
	self.enabled		= toBoolean(config:getConfig("render_3dtext"))

	-- Methoden --
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)


	-- Events --

	addEventHandler("onHouseShapeLeave", getLocalPlayer(), self.leaveFunc)
	addEventHandler("onHouseShapeEnter", getLocalPlayer(), self.enterFunc)
	--logger:OutputInfo("[CALLING] HouseNameRenderer: Constructor");
end

-- EVENT HANDLER --
