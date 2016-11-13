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
-- ## Name: HudModifier.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HudModifier = {};
HudModifier.__index = HudModifier;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudModifier:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

--[[

GUIEditor.checkbox[1] = guiCreateCheckBox(174, 562, 177, 32, "Enabled?", true, false)
guiSetFont(GUIEditor.checkbox[1], "default-bold-small")


GUIEditor.scrollbar[1] = guiCreateScrollBar(3, 597, 349, 21, true, false)
guiScrollBarSetScrollPosition(GUIEditor.scrollbar[1], 100.0)
]]

function HudModifier:Render()
	if(self.state == true) then
		local sx, sy = guiGetScreenSize()
		
		local aesx, aesy = 1600, 900;

		dxDrawRectangle(0, 499, 393, 401, tocolor(0, 0, 0, 125), false)
		dxDrawRectangle(4, 506, 351, 45, tocolor(0, 0, 0, 125), true)
		dxDrawText("Enable / Disable Widgets", 4, 506, 353, 550, tocolor(255, 255, 255, 255), 2, "default-bold", "center", "center", false, false, true, false, false)
		
		local add = 70;
		local increment = 0;
		
		for i = self.startPos, self.startPos+self.maxDrawAmount, 1 do
			if(self.components[i]) then
			
				local component_name = self.components[i].name;
				
				local alpha = math.floor(guiScrollBarGetScrollPosition(self.guiEle["scrollbar"..i]));
				local zoom = math.floor(guiScrollBarGetScrollPosition(self.guiEle["zoomscrollbar"..i]));
				local moveable = self.components[i].moveable;
				
				dxDrawText(i..": "..component_name, 40, 579+increment*2, 170, 595, tocolor(252, 252, 252, 255), 1, "default-bold", "left", "center", false, false, true, false, false)
				
				if(tonumber(moveable) == 1) then
					dxDrawRectangle(4, (561+10)+increment, 350, 65, tocolor(0, 0, 0, 124), false)
					dxDrawText("Alpha: "..alpha.."%", 4, 596+increment*2, 351, 616, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
					dxDrawText("Zoom: "..zoom.."%", 4, (596+40)+increment*2, 351, 616, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
				else
					dxDrawRectangle(4, (561+10)+increment, 350, 30, tocolor(0, 0, 0, 124), false)
					
				end
				increment = increment+add;
			end
		end
	end
end	

-- ///////////////////////////////
-- ///// DestroyGui			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:DestroyGui()
	for index, ele in pairs(self.guiEle) do
		--if(isElement(ele)) then
			destroyElement(ele)
		--end
		self.guiEle[index] = nil;
	end
end

-- ///////////////////////////////
-- ///// ResetAll			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

-- Resets all Components

function HudModifier:ResetAll()
	local sx, sy = guiGetScreenSize()
	if(self.state == true) then
		for name, pos in pairs(hud.components) do
			hud.components[name].sx = (sx/2)-hud.components[name].width/2;
			hud.components[name].sy = (sy/2)-hud.components[name].height/2;
		end
		
		self:SaveSettings();
		outputChatBox("Hud Components have been resetted", 255, 255, 0);
		
		playSound(hud.pfade.sounds.."bing.mp3", false)
	else
		outputChatBox("Please open the designer to reset all hud elements", 255, 0, 0)
	end
end

-- ///////////////////////////////
-- ///// RebuildGui			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:RebuildGui()
	self:DestroyGui();
	
	local add = 70;
	local increment = 0;
	
	for i = self.startPos, self.startPos+self.maxDrawAmount, 1 do
		-- CHECKBOX
		if(self.components[i]) then
			self.guiEle["checkbox"..i] = guiCreateCheckBox(174, (562+8)+increment, 177, 32, "Enabled?", true, false)
			guiSetFont(self.guiEle["checkbox"..i], "default-bold-small")

			
			local state = tonumber(hud.components[self.components[i].defaultName].enabled)
			local alpha = hud.components[self.components[i].defaultName].alpha;
			local moveable = hud.components[self.components[i].defaultName].moveable;
			local zoom = hud.components[self.components[i].defaultName].zoom;

			if(tonumber(state) == 1) or (state == nil) then
				state = true;
			else
				state = false;
			end
			
			guiCheckBoxSetSelected(self.guiEle["checkbox"..i], state)
			
			if(self.cantDisable[self.components[i].defaultName]) then
				guiSetEnabled(self.guiEle["checkbox"..i], false)
			end
			
			self.guiEle["scrollbar"..i] = guiCreateScrollBar(3, 597+increment, 349, 21, true, false)
			guiScrollBarSetScrollPosition(self.guiEle["scrollbar"..i], 100.0/255*alpha)
			
			self.guiEle["zoomscrollbar"..i] = guiCreateScrollBar(3, 617+increment, 349, 21, true, false)
			guiScrollBarSetScrollPosition(self.guiEle["zoomscrollbar"..i], zoom*100.0)

			if(moveable == false) or (tonumber(moveable) == 0) then
				guiSetEnabled(self.guiEle["scrollbar"..i], false)
				guiSetEnabled(self.guiEle["zoomscrollbar"..i], false)
			end

			if(self.cantResize[self.components[i].defaultName]) then
				guiSetEnabled(self.guiEle["zoomscrollbar"..i], false)
			end

			
			-- Checkbox
			addEventHandler("onClientGUIClick", self.guiEle["checkbox"..i], function()
				local state = guiCheckBoxGetSelected(source);
				
				local read = 0;
				if(state == true) then
					read = 1;
				end
				
				-- Hier greife ich auf das globale Objekt zu, ganz wichtig
				
				hud.components[self.components[i].defaultName].enabled = read;
				
				hud.hudSaver:UpdateComponent(self.components[i].defaultName, hud.components)
			
				if(hud.hudObjects[self.components[i].defaultName].triggerFunc) then
					hud.hudObjects[self.components[i].defaultName]:triggerFunc();
				end
				outputDebugString("Modifing component visibility: "..self.components[i].defaultName)
			end)
			
			-- Scroll
			addEventHandler("onClientGUIScroll", self.guiEle["scrollbar"..i], function()
				local percent = guiScrollBarGetScrollPosition(source)
				
				local alpha = percent*2.55
				
				hud.components[self.components[i].defaultName].alpha = alpha
				
			--	hud.hudSaver:UpdateComponent(self.components[i].defaultName, hud.components)
			
			--	outputDebugString("Modifing component visibility: "..self.components[i].defaultName)
			end)
			
						-- Scroll
			addEventHandler("onClientGUIScroll", self.guiEle["zoomscrollbar"..i], function()
				local percent = guiScrollBarGetScrollPosition(source)
				
				local zoom = percent/100
				
				local oldzoom = hud.components[self.components[i].defaultName].zoom
				
				local sx1, sy1 = hud.components[self.components[i].defaultName].width, hud.components[self.components[i].defaultName].height
				local sx2, sy2 = hud.components[self.components[i].defaultName].width*zoom, hud.components[self.components[i].defaultName].height*zoom
				
				local addx, addy = sx1-sx2, sy1-sy2
				
				--outputChatBox(sx1..", "..sy1..", "..sx2..", "..sy2)
				
				hud.components[self.components[i].defaultName].zoom = zoom
				
			
				-- Position
				
			--	hud.hudSaver:UpdateComponent(self.components[i].defaultName, hud.components)
			
			--	outputDebugString("Modifing component visibility: "..self.components[i].defaultName)
			end)
			increment = increment+add;
		end
	end
	
	-- DEFAULT THINGS --
	self.guiEle["zoom_scrollbar"] = guiCreateScrollBar(363, 505, 22, 393, false, false);
	guiScrollBarSetScrollPosition(self.guiEle["zoom_scrollbar"], hud.global_zoom*100);
	guiSetEnabled(self.guiEle["zoom_scrollbar"], false);
	
	addEventHandler("onClientGUIScroll", self.guiEle["zoom_scrollbar"], function()

		local percent = guiScrollBarGetScrollPosition(source)
		

		local ammount = percent/100

		hud.hudSaver:SetComponentSetting("global", "global", "zoom", ammount);
		hud.global_zoom = ammount;
		
		--outputChatBox(ammount)
	--	for name, tbl in pairs(hud.components) do
		--	outputChatBox(hud.components[name].zoom)
		--	hud.components[name].zoom = hud.components[name].zoom*ammount;
	--	end
		
	end)
end

-- ///////////////////////////////
-- ///// SaveSettings		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:SaveSettings()
	-- Zum Speichern der Alpha sachen
	for index, components in pairs(hud.components) do
		hud.hudSaver:UpdateComponent(index, hud.components)
	end
	
	hud.hudSaver:SaveRenderReihenfolge(hud.renderReihenfolge);
	
end

-- ///////////////////////////////
-- ///// Toggle				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:Toggle()
	if not(hud.hudObjects["handy"].inputActivated) then
		if(self.state == true) then
			self.state = false;
			
			self:SaveSettings();
			
			self:DestroyGui();
			
			if(self.showRadarAgain == true) then
				setPlayerHudComponentVisible("radar", true)
			end
			
			playSound(hud.pfade.sounds.."menu_close.mp3", false)
			
			hud.hudObjects["handy"]:Toggle(false);
		else
			self.state = true;
			self:DestroyGui();
			self:RebuildGui();
			
			if(isPlayerHudComponentVisible("radar")) then
				self.showRadarAgain = true;
				setPlayerHudComponentVisible("radar", false)
			else
				self.showRadarAgain = false;
			end
			playSound(hud.pfade.sounds.."menu_open.mp3", false)
		
--			triggerServerEvent("onClientUnlockedAchievement", getLocalPlayer(), 12)
			hud.hudObjects["handy"]:Toggle(true);
		end
		
			
	--	showPlayerHudComponent("radar", not self.state)
		showCursor(self.state);
	end
end

-- ///////////////////////////////
-- ///// MoveUpFunc 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:MoveUp()
	if(self.state == true) then
		if(self.startPos > 1) then
			self.startPos = self.startPos-1;
		end
		self:RebuildGui();
	end	
end

-- ///////////////////////////////
-- ///// MoveDownFunc 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:MoveDown()
	if(self.state == true) then
		if(self.startPos < #self.components) then
			self.startPos = self.startPos+1;
		end	
		self:RebuildGui();
	end

end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudModifier:Constructor(components)
	-- Instanzen
	self.triggerKey = _Gsettings.keys.HudDesigner
	self.state = false;
	
	self.startPos = 1;
	self.maxDrawAmount = 5;
	
	self.components = {};
	
	self.defaultComponentNames = {
		["clock"] 		= "Uhr",
		["heartclock"] 	= "Herzschlagmonitor",
		["breath"] 		= "Atem",
		["development"] = "Entwicklungs-Gadged",
		["wanteds"] 	= "Wanteds",
		["money"] 		= "Geld",
		["netstats"] 	= "Netzwerk Statistiken",
		["handy"] 		= "Smartphone",
		["hungerbar"] 	= "Hungerleiste",
		["weather"] 	= "Wetter Widget",
		["ping"] 		= "Ping",
		["postit"] 		= "Changelog",
		["speedo"] 		= "Tacho",
		["radar"] 		= "Minimap", 
		["weapons"] 	= "Waffen",
		["crosshair"] 	= "Crosshair",
		
	}
	
	self.cantDisable	= 
	{
		["handy"]	= true,
	}


	self.cantResize		=
	{
		["scoreboard"] = true,
	}
	
	local i = 1;
	
	for index, component in pairs(components) do
		self.components[i] = component;
		self.components[i].name = (self.defaultComponentNames[index] or index);
		self.components[i].defaultName = index; 

		i = i+1;
	end
	
	self.showRadarAgain = true;
	
	self.guiEle = {}
	
	-- Funktionen
	self.toggleMenu = function() self:Toggle() end;
	self.renderFunc = function() self:Render() end;
	self.moveUpFunc = function() self:MoveUp() end;
	self.moveDownFunc = function() self:MoveDown() end;
	
	-- Events
	
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)
	
	bindKey(self.triggerKey, "down", self.toggleMenu)
	bindKey("mouse_wheel_up", "down", self.moveUpFunc)
	bindKey("mouse_wheel_down", "down", self.moveDownFunc)
	
	
	
-- 	outputDebugString("[CALLING] HudModifier: Constructor");
end

-- EVENT HANDLER --
