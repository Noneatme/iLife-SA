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
-- ## Name: HudComponent_Radar.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

gBlipSet = false

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HudComponent_Radar = {};
HudComponent_Radar.__index = HudComponent_Radar;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Radar:New(...)
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

function HudComponent_Radar:Toggle(bBool)
	local component_name = "radar"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end

-- ///////////////////////////////
-- ///// RefreshALShape		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function HudComponent_Radar:RefreshALShape()
	self:RefreshGlobalBlips()
	self:refreshRadarAreas()
	gBlipSet = true
end

function HudComponent_Radar:refreshBlips()
	if(not isElement(self.blipTarget)) then return; end
	dxSetRenderTarget(self.blipTarget, true);

	if (self.globalBlips) then
		for _, blip in pairs(self.globalBlips) do
			local model    = getBlipIcon(blip);
			local r, g, b  = 255, 255, 255;
			local x, y, _  = getElementPosition(blip);
			local mapX     = (x/2)+1500;
			local mapY     = 3000-((y/2)+1500);
			local width 	= 32
			if(model < 2) then
				r, g, b = getBlipColor(blip);
				width 	= 16
			end

			dxDrawImage(mapX-(width/2), mapY-(width/2), width, width, ('%sblips/%d.png'):format(self.imgPath, model), 0, 0, 0, tocolor(r, g, b, 255));
		end
	end
	for _, blip in pairs(getElementsByType('blip')) do
		if (getElementDimension(blip) == getElementDimension(localPlayer)) then
			local model    = getBlipIcon(blip);
			local r, g, b  = 255, 255, 255;
			local x, y, _  = getElementPosition(blip);
			local mapX     = (x/2)+1500;
			local mapY     = 3000-((y/2)+1500);
			local width 	= 32
			if(model < 2) then
				r, g, b = getBlipColor(blip);
				width 	= 16
			end

			dxDrawImage(mapX-(width/2), mapY-(width/2), width, width, ('%sblips/%d.png'):format(self.imgPath, model), 0, 0, 0, tocolor(r, g, b, 255));
		end
	end

	dxSetTextureEdge(self.blipTarget, "clamp");
	dxSetRenderTarget();
end

function HudComponent_Radar:refreshRadarAreas()
	if(not isElement(self.radarTarget)) then return; end
	dxSetRenderTarget(self.radarTarget, true);
	dxSetBlendMode("overwrite")
	for _, zone in pairs(getElementsByType('radararea')) do
		if(getElementDimension(zone) == getElementDimension(localPlayer)) then
			--[[
			local r, g, b, a    = getRadarAreaColor(zone);
			local sizeX, sizeY  = getRadarAreaSize(zone);
			local x, y, _       = getElementPosition(zone);
			dxDrawRectangle((x/2)+1500, 3000-((y/2)+1500), sizeX, sizeY, tocolor(r, g, b, a));]]

			local r, g, b, a    = getRadarAreaColor(zone);
			local sizeX, sizeY  = getRadarAreaSize(zone);
			local x, y, _       = getElementPosition(zone);
			local mapX    			= (x/2)+1500;
			local mapY     			= 3000-((y/2)+1500);
			local width, height 	= getRadarAreaSize(zone);
			dxDrawRectangle(mapX-width/2, mapY-height/2, width, height, tocolor(r, g, b, 255));
			--[[
			local r, g, b, a    = getRadarAreaColor(zone);
			local sizeX, sizeY  = getRadarAreaSize(zone);
			local x, y, _       = getElementPosition(zone);
			dxDrawRectangle((x/2)+1500, 3000-((y/2)+1500), sizeX, sizeY, tocolor(r, g, b, 255));]]
		end
	end
	dxSetBlendMode("blend")
	dxSetRenderTarget();
end

-- ///////////////////////////////
-- ///// MoveIn		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:MoveIn()
	local curZoom = self.targetZoom;

	if(curZoom-self.zoomLevel > self.minZoom) and (self.canZoom) then
		self.targetZoom = self.targetZoom-self.zoomLevel;
		hud.hudSaver:SetComponentSetting("radar", "custom_settings", "zoom", self.targetZoom);

		self.moveType = true;
		self.hudZoomStartTick = getTickCount()
		self.canZoom = false;

		-- Anti-Lag
		self:RefreshALShape();
		self:refreshRadarAreas()
	end
end

-- ///////////////////////////////
-- ///// MoveOut		 	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:MoveOut()
	local curZoom = self.targetZoom;

	if(curZoom+self.zoomLevel < self.maxZoom) and (self.canZoom) then
		self.targetZoom = self.targetZoom+self.zoomLevel;
		hud.hudSaver:SetComponentSetting("radar", "custom_settings", "zoom", self.targetZoom);

		self.moveType = false;
		self.hudZoomStartTick = getTickCount();
		self.canZoom = false;

		-- Anti-Lag
		self:RefreshALShape();
		self:refreshRadarAreas()
	end
end



-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:Render()
	local component_name = "radar"

	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;

	local alpha = hud.components[component_name].alpha

	-- Map

	local mapX, mapY = self.sizeX, self.sizeY;
	local pX, pY, pZ = getElementPosition(localPlayer);
	local nX, nY = (mapX+pX)/((mapX*2))*mapX,(mapY-pY)/((mapY*2))*mapY;

	local original_zoom = tonumber(hud.comSettings["radar"]["zoom"]);

	local target_zoom = self.targetZoom;
	local current_zoom = self.currentZoom;

	if(isPedInVehicle(localPlayer)) then
		local speed = getElementSpeed(getPedOccupiedVehicle(localPlayer))

		if(speed) then
			speed = speed*getGameSpeed()

			target_zoom = target_zoom+(speed/2);
		end
	end

	if(self.moveType == true) then
		self.currentZoom = interpolateBetween(target_zoom+self.zoomLevel, 0, 0, target_zoom, 0, 0, (getTickCount()-self.hudZoomStartTick)/500, "InOutQuad", 0, 0, 2)

	else
		self.currentZoom = interpolateBetween(target_zoom-self.zoomLevel, 0, 0, target_zoom, 0, 0, (getTickCount()-self.hudZoomStartTick)/500, "InOutQuad", 0, 0, 2)
	end

	if((getTickCount()-self.hudZoomStartTick)/500 > 1) and (self.canZoom == false) then
		self.canZoom = true;
	end

	original_zoom = current_zoom;

	if(nX > mapX) then
		nX = mapX
	elseif(nX < 0) then
		nX = 0;
	end

	if(nY > mapY) then
		nY = mapY
	elseif(nY < 0) then
		nY = 0;
	end


	local original_zoom_alt_x = original_zoom/256*w
	local original_zoom_alt_y = original_zoom/(256+20)*h

	local genau_y = self.radarTypH-20;

	-- Interior Block
	if(getElementInterior(localPlayer) ~= 0) then
		dxDrawImage(x, y, self.radarTypW*hud.components[component_name].zoom, genau_y*hud.components[component_name].zoom, hud.pfade.images.."component_radar/interior_alt.jpg", 0, 0, 0, tocolor(255, 255, 255, alpha))
	else
		dxDrawImageSection(x, y, self.radarTypW*hud.components[component_name].zoom, genau_y*hud.components[component_name].zoom, nX-original_zoom_alt_x/2, nY-original_zoom_alt_y/2, original_zoom_alt_x, original_zoom_alt_y, self.texture, 0, 0, 0, tocolor(255, 255, 255, alpha))
	end

	-- Leben Vorhanden

	local leben_w = 174/100*getElementHealth(localPlayer)
	dxDrawRectangle(x+2*hud.components[component_name].zoom, ((y+h)+((-30+12))*hud.components[component_name].zoom), leben_w*hud.components[component_name].zoom, (25-8)*hud.components[component_name].zoom, tocolor(20, 100, 20, alpha/1.5))



	-- Luft
	dxDrawRectangle(x+(2+174)*hud.components[component_name].zoom, ((y+h)+((-30+12))*hud.components[component_name].zoom), 175*hud.components[component_name].zoom, (25-8)*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha/2))


	-- Luft vorhanden
	leben_w = 175/(getPedStat ( localPlayer, 225 )+1000)*getPedOxygenLevel(localPlayer)
	dxDrawRectangle(x+(2+174)*hud.components[component_name].zoom, ((y+h)+((-30+12))*hud.components[component_name].zoom), leben_w*hud.components[component_name].zoom, (25-8)*hud.components[component_name].zoom, tocolor(0, 50, 75, alpha/1.5))

	leben_w = 174/100*getPedArmor(localPlayer)
	dxDrawRectangle(x+(2+174)*hud.components[component_name].zoom, ((y+h)+((-30+12))*hud.components[component_name].zoom), leben_w*hud.components[component_name].zoom, (25-8)*hud.components[component_name].zoom, tocolor(65, 65, 65, alpha/1.5))

	-- Blips
	dxDrawImageSection(x, y, self.radarTypW*hud.components[component_name].zoom, genau_y*hud.components[component_name].zoom, nX-original_zoom_alt_x/2, nY-original_zoom_alt_y/2, original_zoom_alt_x, original_zoom_alt_y, self.radarTarget, 0, 0, 0, tocolor(255, 255, 255, alpha/3))
	dxDrawImageSection(x, y, self.radarTypW*hud.components[component_name].zoom, genau_y*hud.components[component_name].zoom, nX-original_zoom_alt_x/2, nY-original_zoom_alt_y/2, original_zoom_alt_x, original_zoom_alt_y, self.blipTarget, 0, 0, 0, tocolor(255, 255, 255, alpha))

	-- Ich
	dxDrawImage(x+(w/2)-((16/current_zoom*512)*hud.components[component_name].zoom)/2, y+(h/2)-(((16/2)/current_zoom*512+28)*hud.components[component_name].zoom)/2, (16/current_zoom*512)*hud.components[component_name].zoom, (16/current_zoom*512)*hud.components[component_name].zoom, hud.pfade.images.."component_radar/icon_me.png", (getPedRotation(localPlayer)+180)*-1, 0, 0, tocolor(255, 255, 255, alpha));

	-- Zoom Level
	local percent = 0;

	local max = self.maxZoom-64;
	local min = self.minZoom+64;
	local cur = current_zoom;

	percent = ((cur - max)/(min - max) * 101)

	if(percent <= 0) then
		percent = 0;
	elseif(percent >= 100) then
		percent = 100;
	end
	dxDrawRectangle(x+2*hud.components[component_name].zoom, y+h-35*hud.components[component_name].zoom, w-2*hud.components[component_name].zoom, 18*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha/3))
	dxDrawText("Zoom level: "..math.floor(percent).."%", x, (y+h)-35*hud.components[component_name].zoom, x+w, y+h, tocolor(200, 200, 200, alpha), 1*hud.components[component_name].zoom, "default-bold", "center", "top")

	-- Ort
	-- Text

	local zoneText = getZoneName(pX, pY, pZ, false)..", "..getZoneName(pX, pY, pZ, true)

	if(getElementInterior(localPlayer) ~= 0) then
		zoneText = "Interior";
	end


	dxDrawRectangle(x+2*hud.components[component_name].zoom, y, w-2*hud.components[component_name].zoom, 20*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha/3))
	dxDrawText(zoneText, x, y+2*hud.components[component_name].zoom, x+w, y+h, tocolor(200, 200, 200, alpha), 1*hud.components[component_name].zoom, "default-bold", "center", "top")

	--Blips & Gangareas

	if (#self.globalBlips > 0) then
		gBlipSet = true
		dxDrawImage(x, y, w, h, hud.pfade.images.."component_radar/background_alt.png", 0, 0, 0, tocolor(255, 255, 255, alpha));
		for k,v in ipairs(self.globalBlips) do
			if ( v and isElement(v)) then
				local bx,by,_ = getElementPosition(v)
				if not(isPointInRectangle((bx/2)+1500,3000-((by/2)+1500),nX-original_zoom_alt_x/2,nY-original_zoom_alt_y/2, original_zoom_alt_x,original_zoom_alt_y)) then
					local px,py,_ = getElementPosition(localPlayer)
					local rot = findRotation(px,py,bx,by)
					local distance = math.sqrt( (x+(w/2)^2), (y+(h/2)^2) )
					local xx,yy = getPointFromDistanceRotation( x+(w/2), y+(h/2), distance, 360-rot)

					if (xx > x+w) then
						xx = tonumber(x+w)
					end
					if (xx < tonumber(x)) then
						xx = tonumber(x)
					end
					if (yy > y+h) then
						yy = tonumber(y)
					end
					if (yy < tonumber(y)) then
						yy = tonumber(y+w)
					end
					dxDrawImage( xx-16, yy-16, 32, 32, ('%sblips/%d.png'):format(self.imgPath, getBlipIcon(v)), 0, 0, 0, tocolor(255, 255, 255, 255))
					local walk_distance = getDistanceBetweenPoints2D(px, py, bx, by)
					dxDrawText(math.round(walk_distance).."m", xx, yy+35, xx, yy+35, tocolor(255, 255, 255, 255), 0.8, "default-bold", "center", "bottom")
				else
					setBlipVisibleDistance(v, 1000)
					self:RefreshALShape()
				end
			else
				self:RefreshALShape();
			end
		end
	else
		if (gBlipSet) then
			self:RefreshALShape()
			gBlipSet = false
		end
		dxDrawImage(x, y, w, h, hud.pfade.images.."component_radar/background_alt.png", 0, 0, 0, tocolor(255, 255, 255, alpha));
	end
end

-- ///////////////////////////////
-- ///// RefreshGlobalBlips //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:RefreshGlobalBlips(blip)
	self.globalBlips = {}
	for k,v in ipairs(getElementsByType("blip")) do
		if (getBlipVisibleDistance(v) == 1337) then
			table.insert(self.globalBlips, v)
		end
	end
	self:refreshBlips()
end

-- ///////////////////////////////
-- ///// IsPointInRectangle //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:IsPointInRectangle(cX,cY,rX,rY,width,height)
	local was = 0;
	if((cX > rX)) then
		was = 1
	end
	if(cX < rX+width) then
		was = 2;
	end
	if(cY > rY) then
		was = 3;
	end
	if(cY < rY+height) then
		was = 4;
	end
	return was
end
-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Radar:Constructor(zoom, sizeX, sizeY, antilag, typ, typew, typeh)
	-- Instanzen
	self.moveOutKey = "num_sub";
	self.moveInKey = "num_add";


	self.currentZoom = 256;
	self.targetZoom = zoom;


	self.zoomLevel = 128;
	self.minZoom = 64;
	self.maxZoom = 1024;

	self.hudZoomStartTick = getTickCount();
	self.canZoom = true;

	self.sizeX = sizeX;
	self.sizeY = sizeY;

	self.antiLag = antilag;

	self.radarTyp = typ;
	self.radarTypW = typew;
	self.radarTypH = typeh;


	self.isRain = {
		[4] = true,
		[16] = true,
	}

	-- Funktionen
	self.moveOutFunc = function() self:MoveOut() end;
	self.moveInFunc = function() self:MoveIn() end;

	local name, hudklasse = debug.getlocal(3, 1)

	self.imgPath = hudklasse.pfade.images.."component_radar/"

	if(fileExists(hudklasse.pfade.images.."component_radar/custom_radar.jpg")) then
		self.texture 		= dxCreateTexture(hudklasse.pfade.images.."component_radar/custom_radar.jpg", "argb", true, "clamp", "2d");
		outputConsole("Custom radar loaded, size: "..sizeX.." x "..sizeY);
	else
		self.texture 		= dxCreateTexture(hudklasse.pfade.images.."component_radar/radar.jpg", "argb", true, "clamp", "2d");
		outputConsole("Custom radar not found - using default");
	end


	self.renderTarget 		= dxCreateRenderTarget (256, 256, true);

	if(toboolean(config:getConfig("lowrammode"))) then
		self.radarRenderTarget	= dxCreateRenderTarget (self.sizeX/2, self.sizeY/2, true);
	else
		self.radarRenderTarget	= dxCreateRenderTarget (self.sizeX, self.sizeY, true);
    end


	local mapWidth, mapHeight = 3000, 3000
	if(toboolean(config:getConfig("lowrammode"))) then
		mapWidth, mapHeight = mapWidth, mapHeight
	end
	self.blipTarget   = dxCreateRenderTarget(mapWidth, mapHeight, true);
    self.radarTarget  = dxCreateRenderTarget(mapWidth, mapHeight, true);

	self:RefreshALShape()

	-- Event
	bindKey(self.moveOutKey, "down", self.moveOutFunc)
	bindKey(self.moveInKey, "down", self.moveInFunc)

	self.globalBlips = {}

	local _createBlip = createBlip
	function createBlip(...)
		local blip = _createBlip(...)
		self:RefreshGlobalBlips(blip);
		return blip;
	end

end



-- EVENT HANDLER --
