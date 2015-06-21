--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HUD iLife				##
-- ## For MTA: San Andreas				##
-- ## Name: HudComponent_Development.lua		##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudComponent_Development = {};
HudComponent_Development.__index = HudComponent_Development;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Development:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Development:Toggle(bBool)
	local component_name = "development"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end

-- ///////////////////////////////
-- ///// getMinMaxColor		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Development:getMinMaxColor(iMin, iMax, iValue)
	local v     = iValue/iMax

	if(v < 0.25) then
		return "#00FF00"
	end
	if(v < 0.5) then
		return "#FCF800"
	end
	if(v < 0.75) then
		return "#FF6A00"
	end
	if(v <= 1) or (v >= 1) then
		return "#FF0000"
	end
end


-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Development:Render()

	local component_name = "development"


	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;

	local alpha = hud.components[component_name].alpha


	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, alpha/3))


	if not(ligh) then
		ligh = "-"
	end

	if not(woid) then
		woid = "-"
	end

	if not(mat) then
		mat = "-"
	end

	if not(wlod) then
		wlod = "-"
	end

	if(getTickCount()-self.lastTick >= 1000) then
		self.fps		= self.curFPS
		self.lastTick	= getTickCount();
		self.curFPS		= 0;
		self:RefreshDatas();
	else
		self.curFPS		= self.curFPS	+1;
	end
	-- Der Groessete Scheiss den ich jemals gemacht habe

	dxDrawText("Position: "..self.m_hColorBlue..""..math.floor(self.xl)..self.m_hColorReset..", "..self.m_hColorBlue..math.floor(self.yl)..self.m_hColorReset..", "..self.m_hColorBlue..math.floor(self.zl)..self.m_hColorReset.."\nInterior: "..self.m_hColorBlue..self.interior..self.m_hColorReset.."\nDimension: "..self.m_hColorBlue..self.dimension..self.m_hColorReset.."\n\nLight Level: "..self.m_hColorBlue..self.ligh..self.m_hColorReset.."\nMaterial ID: "..self.m_hColorBlue..self.mat..self.m_hColorReset.."\nWorld Model ID: "..self.m_hColorBlue..self.woid..self.m_hColorReset.."\nWorld Model LOD: "..self.m_hColorBlue..self.wlod..self.m_hColorReset.."\n\nStreamed in elements:\nObjects: "..self:getMinMaxColor(1, 500, self.m_iObjects)..self.m_iObjects..self.m_hColorReset.."\nPeds: "..self:getMinMaxColor(1, 140, self.m_iPeds)..self.m_iPeds..self.m_hColorReset.."\nVehicles: "..self:getMinMaxColor(1, 64, self.m_iVehicles)..self.m_iVehicles..self.m_hColorReset.."\nPlayers: "..self:getMinMaxColor(1, 120, self.m_iPlayers)..self.m_iPlayers..self.m_hColorReset.."\nSounds: "..self:getMinMaxColor(1, 500, self.m_iSounds)..self.m_iSounds..self.m_hColorReset.."\nColshapes: "..self:getMinMaxColor(1, 5000, self.m_iColshapes)..self.m_iColshapes..self.m_hColorReset.."\nMarker: "..self:getMinMaxColor(1, 32, self.m_iMarkers)..self.m_iMarkers..self.m_hColorReset.."\n\nFPS: "..self.m_hColorBlue..self.fps..self.m_hColorReset.."\nPing: "..self.m_hColorBlue..getPlayerPing(localPlayer), x+10, y+5, w-10, h-5, tocolor(255, 255, 255, alpha), 1*hud.components[component_name].zoom, "default-bold", "left", "top", false, false, false, true)
end


-- ///////////////////////////////
-- ///// RefreshDatas 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Development:RefreshDatas()
	local component_name = "development"

	self.m_iObjects		= 0
	self.m_iPeds		= 0
	self.m_iVehicles	= 0
	self.m_iPlayers		= 0
	self.m_iSounds		= 0
	self.m_iColshapes	= 0
	self.m_iMarkers		= 0

	if(hud.adminComponents[component_name]) then
		if(getElementData(localPlayer, "Adminlevel")) and (tonumber(getElementData(localPlayer, "Adminlevel")) > 2) then
			self.m_iObjects		= #getElementsByType("object", getRootElement(), true);
			self.m_iPeds		= #getElementsByType("ped", getRootElement(), true);
			self.m_iVehicles	= #getElementsByType("vehicle", getRootElement(), true);
			self.m_iPlayers		= #getElementsByType("player", getRootElement(), true);
			self.m_iSounds		= #getElementsByType("sound", getRootElement(), true);
			self.m_iColshapes	= #getElementsByType("colshape", getRootElement(), true);
			self.m_iMarkers		= #getElementsByType("marker", getRootElement(), true);
		else
			self.m_iObjects		= 0
			self.m_iPeds		= 0
			self.m_iVehicles	= 0
			self.m_iPlayers		= 0
			self.m_iSounds		= 0
			self.m_iColshapes	= 0
			self.m_iMarkers		= 0
		end
	end


	local xl, yl, zl 	= getElementPosition(localPlayer);
	local int			= getElementInterior(localPlayer);
	local hit, x1, y1, z1, element, nx, ny, nz, mat, ligh, piece, woid, wx, wy, wz, wlod = processLineOfSight(xl, yl, zl+getElementDistanceFromCentreOfMassToBaseOfModel(localPlayer), xl, yl, zl-10, true, true, false, true, true, false, false, false, nil, true);


	if not(ligh) then
		ligh = "-"
	end

	if not(woid) then
		woid = "-"
	end

	if not(mat) then
		mat = "-"
	end

	if not(wlod) then
		wlod = "-"
	end


	self.xl, self.yl, self.zl = xl, yl, zl

	self.ligh			= ligh;
	self.mat			= mat;
	self.woid			= woid;
	self.wlod			= wlod;

	self.interior		= getElementInterior(localPlayer)
	self.dimension		= getElementDimension(localPlayer);
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Development:Constructor(...)
	self.lastTick 	= getTickCount();
	self.fps 		= 0;
	self.curFPS		= 0;

	self.m_hColorBlue   = "#00FFFF"
	self.m_hColorReset  = "#FFFFFF"

	self:RefreshDatas()
-- 	outputDebugString("[CALLING] HudComponent_Development: Constructor");
end

-- EVENT HANDLER --
