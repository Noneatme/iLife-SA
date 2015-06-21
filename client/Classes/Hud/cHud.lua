--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

-- #######################################
-- ## Project: 	HungerLeiste iLife		##
-- ## For MTA: San Andreas				##
-- ## Name: Hud.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Hud = {};
Hud.__index = Hud;


DEBUG       = false;


addEvent("onClientDownloadFinnished", true)
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Hud:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// HideDefaultHud		//////
-- ///// Returns: bool		//////
-- ///////////////////////////////

function Hud:HideDefaultHud()
	for index, component in pairs(self.hudsToHide) do
		showPlayerHudComponent(component, false);
	end

	return true;
end



-- ///////////////////////////////
-- ///// RenderClickedElement/////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:RenderClickedElement()
	local component_name = self.elementClicked

	if(component_name ~= "selection") then
		local x, y = self.components[component_name].sx, self.components[component_name].sy;
		local w, h = self.components[component_name].width*self.components[component_name].zoom, self.components[component_name].height*self.components[component_name].zoom;

		local alpha = self.components[component_name].alpha

		dxDrawRectangle(x, y, w, h, tocolor(255, 255, 255, 100))
	else
		-- Lines

		local datColor = tocolor(255, 255, 255, 255)
		local width = 2;
		-- Nach Rechts
		dxDrawLine(self.selectionStartX, self.selectionStartY, self.selectionStartX+self.selectionWidth, self.selectionStartY, datColor, width)
		-- Nach Rechts Oben
		dxDrawLine(self.selectionStartX+self.selectionWidth, self.selectionStartY, self.selectionStartX+self.selectionWidth, self.selectionStartY+self.selectionHeight, datColor, width)

		-- Nach Oben
		dxDrawLine(self.selectionStartX, self.selectionStartY+self.selectionHeight, self.selectionStartX, self.selectionStartY, datColor, width)

		-- Oben nach Rechts
		dxDrawLine(self.selectionStartX, self.selectionStartY+self.selectionHeight, self.selectionStartX+self.selectionWidth, self.selectionStartY+self.selectionHeight, datColor, width)

	end
end

-- ///////////////////////////////
-- ///// RenderBadElement	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:RenderBadElement()
	local x, y = getCursorPosition()
	if(x and y) then
		dxDrawImage(self.sx*x-64/2, self.sy*y-64/2, 64, 64, self.pfade.images.."misc/nope.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	end
end
-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:Render()
	if(self.enabled == true) then
		for index, component in ipairs(self.renderReihenfolge) do
			if(self.components[component]) and (self.components[component].enabled ~= 0) then
				local render = false;

				if(self.hudObjects[component].forceRender == false) then

					if(self.hudModifier.state == true) then
						render = true
					else
						render = false;
					end
				else
					render = true;
				end


				if(render == true) then
					dxSetBlendMode("blend");
					self.hudObjects[component]:Render()

					dxSetBlendMode("blend");

				end
			else
				if not(self.components[component]) then
					outputConsole("Render Error: "..component)
				end
			end
		end
		if(self.elementClicked) then
			self:RenderClickedElement();
		end
		if(self.componentOutOfRange) then
			self:RenderBadElement();
		end


	end
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function Hud:Toggle(bBool)
	if (bBool == nil) then
		self.enabled = not (self.enabled);
	else
		self.enabled = bBool;
	end
end


-- ///////////////////////////////
-- ///// AddComponent		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:AddComponent(sName, posX, posY, width, height, alpha, moveable, enabled, zoom)
	self.components[sName] 			= {};

	self.components[sName].sx 		= posX;
	self.components[sName].sy 		= posY;

	self.components[sName].width 	= width;
	self.components[sName].height 	= height;

	self.components[sName].alpha 	= alpha;

	self.components[sName].moveable = tonumber(moveable)

	self.components[sName].enabled 	= tonumber(enabled);

	self.components[sName].zoom		= (zoom or 1);

-- Sachen

--	outputDebugString("Adding Component: "..sName)
end

-- ///////////////////////////////
-- ///// LoadComponentSettings////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:LoadCustomComponentSettings()
	local timestamp = getRealTime().timestamp
	self.customComponentSettings = {
		["hungerbar"] = {
			["speed"] = 20,
		},
		["radar"] = {
			["zoom"] = 256,
			["sizex"] = 3000,
			["sizey"] = 3000,
			["antilag"] = 2,
			["radartype"] = 2,
			["radartypew"] = 353,
			["radartypeh"] = 215,
		},
		["speedo"] =
		{
			["type"] = 1,
			["typew"] = 300,
			["typeh"] = 300,

		},
	}

	self.comSettings = {}


	for component, settingsTable in pairs(self.customComponentSettings) do
		self.comSettings[component] = {}

		for setting, standartValue in pairs(settingsTable) do
			local setting2 = self.hudLoader:GetComponentSetting(component, "custom_settings", setting);

			if not(setting2) then
				self.hudSaver:SetComponentSetting(component, "custom_settings", setting, standartValue);
				setting2 = standartValue;
			end

			self.comSettings[component][setting] = setting2;


		end
	end
	
	--[[
	if(tonumber(self.comSettings["radar"]["radartype"]) == 2) then
		self.components["radar"].width 	= self.comSettings["radar"]["radartypew"];
		self.components["radar"].height	= self.comSettings["radar"]["radartypeh"];
	end]]
	
	for component, setting in pairs(self.customComponentSettings) do
		if(component == "radar") then
		
			self.components[component].width = setting["radartypew"];
			self.components[component].height = setting["radartypeh"];
			
		end
		if(component == "speedo") then
			self.components[component].width = setting["typew"];
			self.components[component].height = setting["typeh"];
		end
	end
	outputDebugString("[HUD] Loaded "..table.getn(self.components).." components in "..((timestamp-getRealTime().timestamp)/1000).." seconds");
end

-- ///////////////////////////////
-- ///// LoadComponents		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:LoadComponents()
	-- Clock
	self:AddComponent("clock", 1333/self.aesx*self.sx, 14/self.aesy*self.sy, 256, 64, 200, 1, 1)
	self:AddComponent("crosshair", 0, 0, 0, 0, 255, 0, 1);
	self:AddComponent("heartclock", 1270/self.aesx*self.sx, 764/self.aesy*self.sy, 366/1.2, 105/1.2, 200, 1, 1)
	self:AddComponent("breath", 0, 0, self.sx, self.sy, 255, 0, 1)
	self:AddComponent("wanteds", 1224/self.aesx*self.sx, 119/self.aesy*self.sy, 1002/10, 1200/10, 255, 1, 0)
	self:AddComponent("money", 1194/self.aesx*self.sx, 221/self.aesy*self.sy, 363, 67, 255, 1, 0)
	self:AddComponent("netstats", self.sx/2, self.sy/2, 271, 278, 255, 1, 0);
	self:AddComponent("development", self.sx/2, self.sy/2, 271, 308, 255, 1, 0);
	
	self:AddComponent("handy", self.sx-200, self.sy-700, 400, 839, 255, 1, 0, 0.5);
	self:AddComponent("hungerbar", 64, self.sy/2, 64, 64, 255, 1, 1);
	self:AddComponent("weather", self.sx/2, self.sy/2, 312, 99, 255, 1, 1);
	self:AddComponent("ping", self.sx/2, self.sy/2, 256, 64, 255, 1, 1);

	self:AddComponent("radar", self.sx-353, self.sy-215, 353, 215, 255, 1, 1);
	self:AddComponent("speedo", 3, self.sy-300, 300, 300, 300, 1, 1);
	self:AddComponent("scoreboard", (self.sx/2)-(800/2), (self.sy/2)-(427/2), 800, 427, 255, 1, 0);

	self:AddComponent("weapons", self.sx/2, self.sy/2, 282, 162, 255, 1, 0);
	self:AddComponent("postit", self.sx/2, self.sy/2, 556/2, 560/2, 255, 1, 0);


	self:LoadCustomComponentSettings();

	-- Render Reihenfolge

	local render_reihenfolge = self.hudLoader:LoadRenderReihenfolge()
	if(render_reihenfolge) and (#render_reihenfolge == #self.renderReihenfolge) then
		self.renderReihenfolge =  render_reihenfolge;
	else
		outputConsole("Render Reihenfolge mismatch, using default")
	end
end


-- ///////////////////////////////
-- ///// LoadComponentSettings////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:LoadComponentSettings()
	-- Settings --
	local timestamp = getRealTime().timestamp
	for component, table in pairs(self.components) do
		local tbl = self.hudLoader:LoadComponentFile(component);

		if(tbl) then
			self.components[component].sx 		= tbl.sx;
			self.components[component].sy 		= tbl.sy;

			--	self.components[component].width = tbl.width;
			--	self.components[component].height = tbl.height;

			self.components[component].alpha 	= tbl.alpha;

			self.components[component].enabled 	= tonumber(tbl.enabled);

			self.components[component].zoom		= tbl.zoom;

		--		outputDebugString("Loading Settings for Component: "..component)
		end
	end

	self.components["scoreboard"].enabled		= 0;		-- Override
end

-- ///////////////////////////////
-- ///// LoadFonts			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:LoadFonts()
	self.fonts 				= {}
	self.fonts.clock 		= dxCreateFont(self.pfade.fonts.."clock.ttf", 60);
	self.fonts.money 		= dxCreateFont(self.pfade.fonts.."blohm.ttf", 60);
	self.fonts.agency 		= dxCreateFont(self.pfade.fonts.."agency.ttf", 64);
	self.fonts.audirmg 		= dxCreateFont(self.pfade.fonts.."audirmg.ttf", 64);
	self.fonts.droidsans	= dxCreateFont(self.pfade.fonts.."droidsans.ttf", 64);
	self.fonts.oswald		= dxCreateFont(self.pfade.fonts.."oswald.ttf", 64);
	self.fonts.nunito		= dxCreateFont(self.pfade.fonts.."nunito.ttf", 32);


end

-- ///////////////////////////////
-- ///// MouseClick			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:MouseClick(button, state, x, y)
	if(button == "left" and state == "down") and (self.hudModifier.state == true) then
		local element = false;
		local ele_index = 0;

		outputConsole("--------- mouse click ----------")
		for index, component in ipairs(self.renderReihenfolge) do
			outputConsole(index..", "..component)
			local tbl = self.components[component];


			local x2, y2 = tonumber(tbl.sx), tonumber(tbl.sy)
			local width, height = tbl.width*tbl.zoom, tbl.height*tbl.zoom;

			local horiCheck = x > x2 and x < x2 + width;
			local vertiCheck = y > y2 and y < y2 + height;

			if(horiCheck and vertiCheck) and (component ~= "breath") and (component ~= "crosshair") and (tbl.enabled ~= 0) then
				element = component;
				ele_index = index;

				self.elementOffsetX = tbl.sx-x;
				self.elementOffsetY = tbl.sy-y;

			end

		end


		if(type(element) == "string") then
			self.elementClicked = element;

			playSound(self.pfade.sounds.."component_hover_start.mp3", false)

			-- Sortierung

			self.renderReihenfolge = table.insertOnTop(self.renderReihenfolge, self.elementClicked, ele_index)

		else
			self.selectionStartX = x;
			self.selectionStartY = y;

			self.selectionWidth = 0;
			self.selectionHeight = 0;
			self.elementClicked = "selection";

		end
	else
		if(type(self.elementClicked) == "string") and (self.elementClicked ~= "selection")  then
			self.hudSaver:UpdateComponent(self.elementClicked, self.components);

			playSound(self.pfade.sounds.."component_hover_stop.mp3", false)

			self.componentOutOfRange = false;
			self.elementClicked = false;
		else

			self.elementClicked = false;
		end


	end
end

-- ///////////////////////////////
-- ///// WarnComponentOutOfRange//
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:WarnComponentOutOfRange()
	self.componentOutOfRange = true;

	if(self.componentOutOfRangeSoundPlayed == false) then
		if(isElement(self.warnComponentSound)) then
			destroyElement(self.warnComponentSound);
		else
			self.componentOutOfRangeSoundPlayed = true;
			self.warnComponentSound = playSound(self.pfade.sounds.."component_warning.mp3", false);
		end
	end
end

-- ///////////////////////////////
-- ///// MouseMove	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:MouseMove()

	if(self.elementClicked) and(type(self.elementClicked) == "string") and (self.elementClicked ~= "selection") then

		local w, h = self.components[self.elementClicked].width*self.components[self.elementClicked].zoom, self.components[self.elementClicked].height*self.components[self.elementClicked].zoom;

		local x, y = getCursorPosition();
		if(x and y) then
			if(self.sx*x+self.elementOffsetX < 0 or self.sx*x+self.elementOffsetX > self.sx-w or self.sy*y+self.elementOffsetY < 0 or self.sy*y+self.elementOffsetY > self.sy-h) then
				self:WarnComponentOutOfRange();
			end
				x = self.sx*x;
				y = self.sy*y;

				x = x+self.elementOffsetX;
				y = y+self.elementOffsetY;

				self.components[self.elementClicked].sx = x;
				self.components[self.elementClicked].sy = y;

				self.componentOutOfRange = false;

				self.componentOutOfRangeSoundPlayed = false;
		--	end
		end
	end

	local x, y = getCursorPosition();
	local sx, sy = guiGetScreenSize();
	if(self.elementClicked == "selection") then

		self.selectionWidth = ((self.selectionStartX)-x*sx)*-1;
		self.selectionHeight = ((self.selectionStartY)-y*sy)*-1;

	end
end

-- ///////////////////////////////
-- ///// SetCustomComponentSkin	//
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:SetCustomComponentSkin(sComponent, iID)
	if(self.customComponentSkins[sComponent]) then
		if(self.customComponentSkins[sComponent][tonumber(iID)]) then
			
			self.components[sComponent].width 	= self.customComponentSkins[sComponent][tonumber(iID)][1];
			self.components[sComponent].height 	= self.customComponentSkins[sComponent][tonumber(iID)][2];
			
			self.hudSaver:SetComponentSetting(sComponent, "custom_settings", "type", iID);
			self.hudSaver:SetComponentSetting(sComponent, "custom_settings", "typew", self.components[sComponent].width);
			self.hudSaver:SetComponentSetting(sComponent, "custom_settings", "typeh", self.components[sComponent].height);
			
			self.hudSaver:SetComponentSetting(sComponent, "custom_settings", "width", self.components[sComponent].width);
            self.hudSaver:SetComponentSetting(sComponent, "custom_settings", "height", self.components[sComponent].height);
			
			self.hudObjects[sComponent]:SetType(tonumber(iID));
		end
	end
end

-- ///////////////////////////////
-- ///// getHandy           //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:getHandy()
	return self.hudObjects["handy"];
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////


function Hud:Constructor(...)
	-- Instanzen
	self.components = {}

	self.hudsToHide = {
		"health", "money", "ammo", "breath", "clock", "weapon", "wanted", "radar", "armour",
	}

	self.renderReihenfolge =
	{
		"scoreboard",
		"clock",
		"development",
		"handy",
		"heartclock",
		"hungerbar",
		"money",
		"netstats",
		"ping",
		"radar",
		"wanteds",
		"weather",
		"weapons",
		"postit",
		"speedo",
		"breath",
	}
	
	self.customComponentSkins	=
	{
		["speedo"] = 
		{
			[1] = {300, 300},
			[2] = {292, 256},
		},
	
	}
	self.defaultHidden =
	{
		["speedo"] = true,
	}
	self.adminComponents	=
	{
		["development"]		= true,
	}
	self.enabled 		= toBoolean(config:getConfig("hud_enabled"));            -- AUF FALSE STELLEN

	self.aesx, self.aesy = 1600, 900;
	self.sx, self.sy = guiGetScreenSize();

	self.elementClicked = false;
	self.elementOffsetX = 0;
	self.elementOffsetY = 0;


	self.selectionStartX = 0;
	self.selectionStartY = 0;
	self.selectionWidth = 0;
	self.selectionHeight = 0;

	self.startTick = getTickCount()

	self.pfade = {}

	self.pfade.sounds = "res/sounds/hud/";
	self.pfade.images = "res/images/hud/";
	self.pfade.fonts = "res/fonts/";
	self.pfade.shaders = "res/shader/";

	-- Loader und Saver
	self.hudLoader = HudComponentLoader:New();
	self.hudSaver = HudComponentSaver:New();


	-- Methoden
	self:HideDefaultHud();


	self.global_zoom = tonumber(self.hudLoader:GetComponentSetting("global", "global", "zoom"));

	if not(self.global_zoom) then
		self.global_zoom = 1;
	end



	-- Funktionen
	self.renderFunc 			= function() self:Render() end;
	self.mouseClickFunc 		= function(...) self:MouseClick(...) end;
	self.mouseMoveFunc 			= function(...) self:MouseMove(...) end;
	self.hideHudFunc 			= function() self.enabled = not(self.enabled) end;
	self.resetComponentsFunc 	= function() self.hudModifier:ResetAll() end;
	self.deleteHudFunc			= function() self.hudSaver:HardReset() end;
	self.customHudSkinFunc		= function(cmd, sComponent, iID) self:SetCustomComponentSkin(sComponent, iID) end

	-- Components

	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()
		-- Components:
		self:LoadFonts();
		self:LoadComponents();
		self:LoadComponentSettings();
				
	
		self.hudObjects = {
			["breath"]              = HudComponent_Breath:New(),
			["clock"]               = HudComponent_Clock:New(),
			["crosshair"]           = HudComponent_Crosshair:New(),
			["development"]         = HudComponent_Development:New(),
			["handy"]               = HudComponent_Handy:New(),
			["heartclock"]          = HudComponent_HeartClock:New(),
			["hungerbar"]           = HudComponent_Hungerbar:New(),
			["money"]               = HudComponent_Money:New(),
			["netstats"]            = HudComponent_Netstats:New(),
			["ping"]                = HudComponent_Ping:New(),
			["radar"]               = HudComponent_Radar:New(tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "zoom")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "sizex")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "sizey")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "antilag")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "radartype")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "radartypew")), tonumber(self.hudLoader:GetComponentSetting("radar", "custom_settings", "radartypeh"))),
			["speedo"]              = HudComponent_Speedo:New(tonumber(self.hudLoader:GetComponentSetting("speedo", "custom_settings", "type"))),
			["scoreboard"]			= HudComponent_Scoreboard:New(),
			["wanteds"]             = HudComponent_Wanteds:New(),
			["weather"]             = HudComponent_Weather:New(),
			["weapons"]             = HudComponent_Weapons:New(),
			["postit"]              = HudComponent_Postit:New(),
		};


		-- Modifier
		self.hudModifier = HudModifier:New(self.components);

		self.hudSaver:CheckForSavedComponents(self.components);
		self:LoadComponentSettings();
		
		--[[
		if (self.enabled == nil) then
			if (getElementData(localPlayer, "online")) then
				self.enabled = true
			else
				self.enabled = false
			end
		end
		]]

		addEventHandler("onClientRender", getRootElement(), self.renderFunc)
		addEventHandler("onClientClick", getRootElement(), self.mouseClickFunc)
		addEventHandler("onClientCursorMove", getRootElement(), self.mouseMoveFunc)
		
		
		addCommandHandler("hidehud", self.hideHudFunc)
		addCommandHandler("resetcomponents", self.resetComponentsFunc)
		addCommandHandler("fuckthishud", self.deleteHudFunc);
	--	addCommandHandler("customhudskin", self.customHudSkinFunc)
	end)
	outputDebugString("[CALLING] Hud: Constructor");
end

-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Hud:Destructor()

	removeEventHandler("onClientPreRender", getRootElement(), self.renderFunc)
	removeEventHandler("onClientClick", getRootElement(), self.mouseClickFunc)
	removeEventHandler("onClientCursorMove", getRootElement(), self.mouseMoveFunc)

	outputDebugString("[CALLING] Hud: Destructor");

	-- Garbage Collector loescht automatisch die anderen Objekte... Hoffentlich...

	self = nil;
end

-- EVENT HANDLER --
function setDotsInNumber ( value )

	if #value > 3 then
		return setDotsInNumber ( string.sub ( value, 1, #value - 3 ) ).."."..string.sub ( value, #value - 2, #value )
	else
		return value
	end
end

function math.round(number, decimals, method)
	decimals = decimals or 0
	local factor = 10 ^ decimals
	if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
	else return tonumber(("%."..decimals.."f"):format(number)) end
end


function getRot() --function extracted from customblips resource
	local camRot
	local cameraTarget = getCameraTarget()
	if not cameraTarget then
		local px,py,_,lx,ly = getCameraMatrix()
		camRot = getVectorRotation(px,py,lx,ly)
	else
		if vehicle then
			if getControlState'vehicle_look_behind' or ( getControlState'vehicle_look_left' and getControlState'vehicle_look_right' ) or ( getVehicleType(vehicle)~='Plane' and getVehicleType(vehicle)~='Helicopter' and ( getControlState'vehicle_look_left' or getControlState'vehicle_look_right' ) ) then
				camRot = -math.rad(getPedRotation(getLocalPlayer()) or 0)
			else
				local px,py,_,lx,ly = getCameraMatrix()
				camRot = getVectorRotation(px,py,lx,ly)
			end
		elseif getControlState('look_behind') then
			camRot = -math.rad(getPedRotation(getLocalPlayer()) or 0)
		else
			local px,py,_,lx,ly = getCameraMatrix()
			camRot = getVectorRotation(px,py,lx,ly)
		end
	end
	return camRot
end

function getVectorRotation(px,py,lx,ly)
	local rotz=6.2831853071796-math.atan2(lx-px,ly-py)%6.2831853071796
	return -rotz
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

function table.insertOnTop(tbl, value, value_index)
	local datas = {}

	for i, d in ipairs(tbl) do
		if(i ~= value_index) then
			table.insert(datas, d);
		end
	end
	table.insert(datas, value)
	return datas;
end

function toBinary(bool)
	if(bool) then
		return 1;
	end
	return 0;
end