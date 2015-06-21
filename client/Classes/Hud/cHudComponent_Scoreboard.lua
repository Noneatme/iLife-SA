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
-- ## Name: HudComponent_Scoreboard.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HudComponent_Scoreboard = {};
HudComponent_Scoreboard.__index = HudComponent_Scoreboard;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Scoreboard:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// GetPlayersInFactioN//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:GetOnlinePlayerDatas()
	local iPlayers, iFactionPlayers, iAdmins		= 0, 0, 0;

	for index, player in pairs(getElementsByType("player")) do
		iPlayers = iPlayers+1;

		-- ADMINS --
		local data = "Adminlevel"
		if(getElementData(player, data)) then
			local lvl = tonumber(getElementData(player, data));
			if(lvl) and (lvl > 0) and (lvl <= 5) then
				iAdmins	= iAdmins+1;
			end
		end

		-- FRAKTIONSABFRAGE --
		data = "Fraktion"
		if(getElementData(player, data)) then
			iFactionPlayers	= iFactionPlayers+1;
		end
	end


	return self:GetPlayersCount(), iFactionPlayers, iAdmins;
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:Render()
	if(hud.components[self.sName].enabled ~= 1) then return end;

	local component_name = self.sName

	local xo, yo 		= hud.components[component_name].sx, hud.components[component_name].sy;
	local wo, ho		= hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;
	local alpha			= hud.components[component_name].alpha;

	local x, y, w, h	= xo, yo, wo, ho;

	dxSetRenderTarget(self.renderTarget, true);

	dxSetBlendMode("blend")  -- Set 'modulate_add' when drawing stuff on the render target

	local function drawBackground()
		dxDrawImage(0, 0, wo, ho, self.pfade.images.."background.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	end

	local function drawRectangles()
		-- Oben
		dxDrawRectangle(0, 0, w, 35, tocolor(0, 0, 0, 220));
		dxDrawLine(0, 35, w, 35, tocolor(0, 0, 0, 255));

		-- Unten
		dxDrawRectangle(0, h-35, w, 35, tocolor(0, 0, 0, 220));
		dxDrawLine(0, h-35, w, h-35, tocolor(0, 0, 0, 255));
	end

	local function drawServerInformations()
		dxSetBlendMode("modulate_add")
		-- OBEN --

		-- UNTEN --

		local iPlayers, iFactionPlayers, iAdmins		= self:GetOnlinePlayerDatas();

		local str			=
		{
			"#FFFFFFSpieler Online: "..iPlayers,
			"#FFFFFFZivi: "..self.m_tblFactionPlayers[0],
			"#0000FFLSPD: "..self.m_tblFactionPlayers[1],
			"#B3B3B3SpF: "..self.m_tblFactionPlayers[2],
			"#007D00GS: "..self.m_tblFactionPlayers[3],
			"#9600E6Ballas: "..self.m_tblFactionPlayers[4],
			"#E69100LSV: "..self.m_tblFactionPlayers[5],
			"#0067C7S.A.T: "..self.m_tblFactionPlayers[6],
			"#878787L.S.M: "..self.m_tblFactionPlayers[7],
			"#FFFFFFAdmins: "..iAdmins,
		}
		local fullString	= ""

		for index, part in ipairs(str) do
			if (index == 1) then
				fullString = part
			else
				fullString = fullString.."#FFFFFF | "..part;
			end
		end
		dxSetBlendMode("modulate_add")
		dxDrawText(fullString, 38, h-25, w, h-25, tocolor(255, 255, 255, 255), 0.3, hud.fonts.nunito, "left", "top", false, false, false, true)
		dxDrawText(_Gsettings.boardURL, 5, h-30, w-5, h-35, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito, "right")
		dxSetBlendMode("blend")
		-- Image --
		dxDrawImage(2, h-33, 32, 32, "res/images/mainmenu/logo_umriss.png", getTickCount()/10)
		dxDrawImage(2, h-28, 32, 26, "res/images/mainmenu/logo.png")

		dxSetBlendMode("blend")
	end


	local function drawPlayers()

		local curY		= 45;
		local scale 	= 1.5; -- haelfte
		local curYadd	= 40/scale;

		local function drawTitel()

			dxDrawText("Ping", 7, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);
			dxDrawText("Spielername", 85, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);
			dxDrawText("Corporation", 260, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);
			dxDrawText("Sozialer Status", 460-20, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);
			dxDrawText("Spielzeit", 610, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);

			dxDrawText("Info", 730, 7, 0, 0, tocolor(255, 255, 255, 255), 0.4, hud.fonts.nunito);
		end

		local function player(index)
			local player = self.sortedPlayers[index];
			if not(player) or not(isElement(player)) or not(getPlayerName(player)) then
				self:RefreshPlayers()
				outputConsole("Player "..tostring(player).." not online, refreshing scoreboard");
			end

			local playerOnline	= true;

			if(getElementData(player, "Online") ~= true) then
				-- playerOnline	= false;
			end

			local function draw()
				local function getMinuswertFromWertZwischen0und1(iWert)
					if(iWert < 0.10) then
						return 64-((64/6)*1);
					elseif(iWert < 0.20) then
						return 64-((64/6)*1);
					elseif(iWert < 0.30) then
						return 64-((64/6)*2);
					elseif(iWert < 0.40) then
						return 64-((64/6)*3);
					elseif(iWert < 0.50) then
						return 64-((64/6)*3);
					elseif(iWert < 0.60) then
						return 64-((64/6)*4);
					elseif(iWert < 0.70) then
						return 64-((64/6)*4);
					elseif(iWert < 0.80) then
						return 64-((64/6)*5);
					elseif(iWert < 0.90) then
						return 64-((64/6)*5);
					elseif(iWert < 1) then
						return 64-((64/6)*6);
					end
					return 64;
				end

				-- Linie --
				local factionID		= tonumber(getElementData(player, "Fraktion"))
				local color;
				local alpha			= 125;
				if not(factionID) or (factionID == 0) then
					color = tocolor(0, 0, 0, alpha);
				else
					if(self.factionColors[factionID]) then
						color	= self.factionColors[factionID];
					else
						color	= tocolor(0, 0, 0, alpha);
					end
				end
				dxDrawImage(5, curY, w-10, 35/scale, self.pfade.images.."line.png", 0, 0, 0, color);

				local ping	= getPlayerPing(player);
				local wert 	= 1-(ping / self.m_iBadPing);

				if(wert > 1) then
					wert = 1;
				end

				local drawMinusWert	= getMinuswertFromWertZwischen0und1(wert);

				-- Ping --

				dxDrawImageSection(7.5*scale, curY+(8/scale), (32/scale)-((drawMinusWert/scale)/2), (32/scale), 0, 0, 64-drawMinusWert, 64, self.pfade.images.."ping.png", 0, 0, 0, tocolor(255, 255, 255, 255));
				dxDrawText(getPlayerPing(player), 55/scale, curY+(8/scale), 320/scale, curY+(40/scale), tocolor(255, 255, 255, 255), 0.18/scale, hud.fonts.droidsans, "left", "top", true)
				-- Name --
				local name		= getPlayerName(player)

				dxDrawText(name, 140/scale, curY+(2/scale), 320/scale, curY+(40/scale), tocolor(255, 255, 255, 255), 0.25/scale, hud.fonts.droidsans, "left", "top", true);
				-- Bild --

				local skin		= tonumber(getElementData(player, "p:Skin"));
                if not(skin) then skin = "unknow.jpg" end
				local file		= self.pfade.skins.."unknow.jpg";

				if(fileExists(self.pfade.skins..skin..".jpg")) and (playerOnline) then
					file	= self.pfade.skins..skin..".jpg";
				end
				--dxDrawImageSection(100/scale, curY+2, 15, 20, 15, 150, 135, 130, file)
                dxSetBlendMode("add")
                dxDrawImage(100/scale, curY+2, 20, 20, file)
                dxSetBlendMode("modulate_add")
				-- Fraktion --

				local faction	= (getElementData(player,"Fraktionsname") or "Verbindet...")
                local color222     = tocolor(255, 255, 255, 255)
                if(getElementData(player, "CorporationName")) then
                    faction = (getElementData(player, "CorporationName"))
                    color222   = tocolor(getColorFromString(getElementData(player, "CorporationColor")))
                end


				dxDrawText(faction, 360/scale, curY+(2/scale), 650/scale, curY+(40/scale), color222, 0.25/scale, hud.fonts.droidsans, "left", "top", true);

				-- Status --

				local status	= (getElementData(player, "Status") or "");
				dxDrawText(status, 630/scale, curY+(2/scale), 900/scale, curY+(40/scale), tocolor(255, 255, 255, 255), 0.25/scale, hud.fonts.droidsans, "left", "top", true);


				-- Spielzeit --
				local spielzeit = "";
				if(getElementData(player,"Playtime")) then
					spielzeit	= (math.floor(getElementData(player,"Playtime")/60))..":"..(getElementData(player,"Playtime")%60)
				end
				dxDrawText(spielzeit, 910/scale, curY+(2/scale), 1000/scale, curY+(40/scale), tocolor(255, 255, 255, 255), 0.25/scale, hud.fonts.droidsans, "left", "top", true);

				-- Icons --
				dxSetRenderTarget(nil);
				local icons		= self:GetPlayerValidIcons(player)
				dxSetRenderTarget(self.renderTarget);

				local curAdX	= 0;
				local increm	= 33/scale
				for index, icon in ipairs(icons) do
					local file;
                    if(type(icon) ~= "string") then
                        file = icon;
                    else
                        file = self.pfade.images.."icons/"..icon..".png";
                    end
                    dxSetBlendMode("add")
					dxDrawImage(1050/scale+curAdX, curY+(2/scale), 32/scale, 32/scale, file, 0, 0, 0, tocolor(255, 255, 255, 250));
                    dxSetBlendMode("modulate_add")
					curAdX = curAdX+increm;
				end
			end


			local function variablenPlus()
				curY = curY+curYadd;
			end

			-- DRAW --
			dxSetBlendMode("modulate_add")
			draw();
			variablenPlus();
			dxSetBlendMode("add")
		end
		dxSetBlendMode("modulate_add")
		drawTitel();

		for i = self.m_iStartIndex, self.m_iStartIndex+self.m_iMaxIndexToRender, 1 do
			if(self.sortedPlayers[i]) then
				player(i);
			end
		end
		dxSetBlendMode("add")
	end

	drawBackground();
	drawRectangles();
	drawServerInformations();

	drawPlayers();

	dxSetRenderTarget(nil);

	--[[

	if(bBool == 1) then
		self.m_iStartOpenTick	= getTickCount();
		self.m_bOpenAnimation	= true;
		self.m_bDoAnimation		= true;
	else
		self.m_iStartOpenTick	= getTickCount();
		self.m_bOpenAnimation	= false;
		self.m_bDoAnimation		= true;
	end

	]]

	local alphavalue = 0;

	if(self.m_bDoAnimation) then
		if(self.m_bOpenAnimation) then	-- Oeffnen

			local time = (getTickCount()-self.m_iStartOpenTick)/125;

			alphavalue = getEasingValue(time, "OutQuad");

			if(time > 1) then
				alphavalue = 1
				hud.components[self.sName].enabled = 1;
			end
			if(time < 0) then alphavalue = 0 end

		else										-- Schliessen

			local time = 1-(getTickCount()-self.m_iStartOpenTick)/125;

			alphavalue = getEasingValue(time, "InQuad");

			if(time > 1) then alphavalue = 1 end
			if(time < 0) then
				alphavalue = 0
				hud.components[self.sName].enabled = 0;
			end

		end
	end


	dxDrawImage(xo, yo, wo, ho, self.renderTarget, 0, 0, 0, tocolor(255, 255, 255, alphavalue*alpha))

end

-- ///////////////////////////////
-- ///generatePlayerCorpLogo//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Scoreboard:generatePlayerCorpLogo(uPlayer)
    local tbl = getElementData(uPlayer, "CorporationLogo");
    self.m_tblCorpLogos[uPlayer] = viewCorpGUI:drawLogo(tbl)

end

-- ///////////////////////////////
-- ///// GetPlayerValidIcons//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Scoreboard:GetPlayerValidIcons(player)
	local icons	= {}

	local index	= 1;
	local function addIcon(sName)
		icons[index] = sName;
		index = index+1;
	end


	-- Adminlevel --
	if(getElementData(player, "Adminlevel")) and (tonumber(getElementData(player, "Adminlevel"))> 0) and (tonumber(getElementData(player, "Adminlevel")) <= 5) then
		addIcon("admin");
	else
		addIcon("user")
	end

	-- Medal of Honor --
    --[[
	if(getElementData(player, "VIP")) and (getElementData(player, "VIP") == true) then
		addIcon("vip");
	end--]]

    -- Faction --
    if(getElementData(player, "CorporationLogo")) then
		if(toboolean(config:getConfig("lowrammode")) ~= true) then
	        if not(self.m_tblCorpLogos[player]) then
	            self:generatePlayerCorpLogo(player)
	        end
	        addIcon(self.m_tblCorpLogos[player])
		end
    end
	-- Gaengie Icons --
	-- Ruhemodus
	if(getElementData(player, "Ruhemodus")) and (getElementData(player, "Ruhemodus") == true) then
		addIcon("ruhe");
	else
		if(tonumber(getElementData(player, "Adminlevel")) and (tonumber(getElementData(player, "Adminlevel")) == 4)) then
			addIcon("ruhe")
		end
	end

	-- AFK --
	if(getElementData(player, "p:AFK")) and (getElementData(player, "p:AFK") == true) then
		addIcon("afk");
	end

	return icons;
end

-- ///////////////////////////////
-- ///// RefreshPlayers		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Scoreboard:RefreshPlayers()
	self.sortedPlayers			= {}
	self.m_tblFactionPlayers	= {}

	for index, l in pairs(self.m_tblCorpLogos) do
        if(isElement(l)) then
            destroyElement(l)
        end
    end

    self.m_tblCorpLogos     = {}

	local tblPlayers		= getElementsByType("player")
	local i = 1;

	-- Sort by Playername
	if(self.m_sSortBy == "players") then
		for index, player in ipairs(tblPlayers) do
			self.sortedPlayers[i] = player;
			i = i+1;
		end
	end

	-- Sort by Faction
	if(self.m_sSortBy  == "faction") then
		local playerDone		= {}
		for index = 0, self.m_iMaxFactions, 1 do
			if not(self.m_tblFactionPlayers[index]) then self.m_tblFactionPlayers[index] = 0 end;
			for index2, player in pairs(tblPlayers) do
				if not(playerDone[player]) then
					if((getElementData(player, "Fraktion")) and (tonumber(getElementData(player, "Fraktion")) == index)) then
						self.sortedPlayers[i] = player;
						i = i+1;
						playerDone[player] = true;
						self.m_tblFactionPlayers[index] = self.m_tblFactionPlayers[index]+1;
					else
						if not((getElementData(player, "Fraktion"))) then
							playerDone[player] = true;
							self.sortedPlayers[i] = player;
							i = i+1;
							self.m_tblFactionPlayers[0] = self.m_tblFactionPlayers[0]+1;
						end
					end
				end
			end
		end
		for i = 0, self.m_iMaxFactions, 1 do
			if not(self.m_tblFactionPlayers[i]) then
				self.m_tblFactionPlayers[i] = 0;
			end
		end
	end
	-- Sort by Status --

	if(self.m_sSortBy == "status") then

	end

	if(self.m_iStartIndex+self.m_iMaxIndexToRender > self:GetPlayersCount()) then
		self.m_iStartIndex = 1;
	end
--	outputConsole("Refreshed Scoreboard Players");
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Scoreboard:Toggle(key, state)
	local component_name = "scoreboard"

	local bBool;
	if(state == "down") then
		bBool = 1
		clientBusy = true;
	else
		bBool = 0
		clientBusy = false;
	end


	if (bBool == nil) then
	--	hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else

	--	hud.components[component_name].enabled = bBool;
		if(bBool == 1) then
			self.m_iStartOpenTick	= getTickCount();
			self.m_bOpenAnimation	= true;
			self.m_bDoAnimation		= true;
		else
			self.m_iStartOpenTick	= getTickCount();
			self.m_bOpenAnimation	= false;
			self.m_bDoAnimation		= true;
		end
		hud.components[component_name].enabled = 1
	end

--	outputChatBox(tostring(hud.components[component_name].enabled))
    if(getTickCount()-self.m_iStartTick > 60000) then
        self:RefreshPlayers();
        self.m_iStartTick = getTickCount();
    end


end

-- ///////////////////////////////
-- ///// ScrollUp	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:ScrollUp(...)
	if(hud.components[self.sName].enabled == 1) then
		if(self.m_iStartIndex > 1) then
			self.m_iStartIndex = self.m_iStartIndex-1;
		end
	end
end

-- ///////////////////////////////
-- ///// ScrollDown	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:ScrollDown(...)
	if(hud.components[self.sName].enabled == 1) then
		if(self.m_iStartIndex+self.m_iMaxIndexToRender < self:GetPlayersCount()) then
			self.m_iStartIndex = self.m_iStartIndex+1;
		end
	end
end

-- ///////////////////////////////
-- ///// getPlayersCount	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:GetPlayersCount()
	return #self.sortedPlayers;
end

-- ///////////////////////////////
-- ///// SortBy		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:SortBy(sString)
	self.m_sSortBy		= sString;
	self:RefreshPlayers();
end

-- ///////////////////////////////
-- ///// doUpdate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:doUpdate()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Scoreboard:Constructor(iType)
	-- Klassenvariablen --
	self.sName			= "scoreboard"

	self.toggleFunc		= function(...) self:Toggle(...) end
	self.scrollUp		= function(...) self:ScrollUp(...) end
	self.scrollDown		= function(...) self:ScrollDown(...) end
    self.m_funcRefresh  = function(...) self:doUpdate(...) end

	self.wX				= hud.components[self.sName].width;
	self.wH				= hud.components[self.sName].height;


	self.scoreW, self.scoreH = self.wX, self.wH

	self.factionColors	=
	{
		[0] = tocolor(0, 0, 0, 200),		-- Zivilist
		[1]	= tocolor(0, 50, 0, 200),		-- LSPD
		[2]	= tocolor(0, 50, 50, 200),		-- Special Forces
		[3]	= tocolor(0, 90, 10, 200),		-- Grove Street
		[4] = tocolor(50, 0, 80, 200),		-- Ballas
		[5] = tocolor(70, 50, 0, 200),		-- Vagos
		[6] = tocolor(0, 20, 80, 200),		-- SAT
		[7] = tocolor(50, 50, 50, 200),		-- Mechaniker
	}


	self.m_tblFactionPlayers		= {}
	self.m_tblCorpLogos         = {}

	self.m_iStartIndex			= 1;
	self.m_iMaxIndexToRender	= 12;

	self.m_iMaxFactions	= 7;
	self.m_sSortBy		= "faction";
	self.m_iBadPing		= 500;

	self.sortedPlayers	= {}

	self.pfade			= {}
	self.pfade.images	= "res/images/hud/component_"..self.sName.."/";
	self.pfade.skins	= "res/images/hud/skins/"

	self.renderTarget	= dxCreateRenderTarget(self.scoreW, self.scoreH, true);

    self.m_iStartTick   = getTickCount();

	bindKey("tab", "both", self.toggleFunc)
	bindKey("mouse_wheel_up", "down", self.scrollUp)
	bindKey("mouse_wheel_down", "down", self.scrollDown)

    self:RefreshPlayers();

	addCommandHandler("sortby", function(cmd, sT) self.m_sSortBy = sT end)

	-- 	outputDebugString("[CALLING] HudComponent_Scoreboard: Constructor");
end

-- EVENT HANDLER --
