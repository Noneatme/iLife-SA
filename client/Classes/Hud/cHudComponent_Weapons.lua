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
-- ## Name: HudComponent_Weapons.lua	##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HudComponent_Weapons = {};
HudComponent_Weapons.__index = HudComponent_Weapons;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Weapons:New(...)
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

function HudComponent_Weapons:Toggle(bBool)
	local component_name = "weapons"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weapons:Render()
	local component_name = "weapons"

	local x, y = hud.components[component_name].sx, hud.components[component_name].sy;
	local w, h = hud.components[component_name].width*hud.components[component_name].zoom, hud.components[component_name].height*hud.components[component_name].zoom;

	local alpha = hud.components[component_name].alpha

	-- Hintergrund
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_weapons/background.png", 0, 0, 0, tocolor(0, 134, 134, alpha/1.5))

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, alpha/4));

	local ammo = getPedAmmoInClip(localPlayer)
	local weapon = getPedWeapon(localPlayer)
	local totalammo = getPedTotalAmmo(localPlayer)-ammo;

	-- Image
	if(fileExists(hud.pfade.images.."component_weapons/weapons/"..weapon..".png")) then
		dxDrawImage(x+(5*hud.components[component_name].zoom), y+(5*hud.components[component_name].zoom), (64*1.5)*hud.components[component_name].zoom, (64*1.5)*hud.components[component_name].zoom, hud.pfade.images.."component_weapons/weapons/"..weapon..".png", 0, 0, 0, tocolor(255, 255, 255, alpha));
	end
	dxDrawText(getWeaponNameFromID(weapon), x+5*hud.components[component_name].zoom, y+100*hud.components[component_name].zoom, x+(64*1.5)*hud.components[component_name].zoom, y+(64*1.5)*hud.components[component_name].zoom, tocolor(255, 255, 255, alpha/3), 0.2*hud.components[component_name].zoom, hud.fonts.audirmg, "center", "top", false, true)


	-- Munition

	-- Seite 1
	--[[
	local dingerProSeite = math.round(totalammo/2);

	local offsetX = 0;
	local addOffsetX = 50;
	local offsetY = 20;
	local maxOffsetY = h-10;
	local addOffsetY = totalammo/



	for i = 1, 2, 1 do
	offsetY = 0;
	for i = 1, dingerProSeite, 1 do


	offsetY = offsetY+addOffsetY;
	end

	offsetX = offsetX+addOffsetX
	end]]

	local addx = (94*1.5)*hud.components[component_name].zoom
	local addy = 50*hud.components[component_name].zoom

	dxDrawText(ammo.."\n"..getPedTotalAmmo(localPlayer)-ammo, x+addx, y+addy, x+addx, y+addy, tocolor(255, 255, 255, alpha/3), 0.35*hud.components[component_name].zoom, hud.fonts.audirmg, "center", "top", false, true)

	-- MaxMuninGraph
	addx = addx+60*hud.components[component_name].zoom
	addy = addy-30*hud.components[component_name].zoom
	
	local max = 110

	-- Hintergrund
	dxDrawRectangle(x+addx, y+h-32*hud.components[component_name].zoom, 40*hud.components[component_name].zoom, -max*hud.components[component_name].zoom, tocolor(0, 0, 0, alpha/3))


	-- Was Vorhanden ist

	

	local vorhanden = max/(tonumber(getWeaponProperty(getWeaponNameFromID(weapon), "pro", "maximum_clip_ammo")) or 0)*ammo
	if not (vorhanden) then vorhanden = 0 end

	if(vorhanden > 0) then
		dxDrawRectangle(x+addx, y+h-32*hud.components[component_name].zoom, 40*hud.components[component_name].zoom, -vorhanden*hud.components[component_name].zoom, tocolor(74, 255, 101, alpha/3))
	end
	local prozent = math.round(100/(tonumber(getWeaponProperty(getWeaponNameFromID(weapon), "pro", "maximum_clip_ammo")) or 0)*ammo)
	if(prozent < 0) then
		prozent = 0
	end
	dxDrawText(prozent.."%", x+170*hud.components[component_name].zoom, y+135*hud.components[component_name].zoom, x+(64*1.5)*hud.components[component_name].zoom+170*hud.components[component_name].zoom, y+(64*1.5)*hud.components[component_name].zoom+135*hud.components[component_name].zoom, tocolor(255, 255, 255, alpha/3), 0.2*hud.components[component_name].zoom, hud.fonts.audirmg, "center", "top")



	--[[
	local ammo = getPedAmmoInClip(localPlayer)
	local weapon = getPedWeapon(localPlayer)
	local totalammo = getPedTotalAmmo(localPlayer)-ammo;
	if(ammo < 10) then
	ammo = "0"..ammo
	end

	if(self.enabled or hud.hudModifier.state == true) then
	-- Schrift

	local ammostring = ammo.."/#00B052"..totalammo;

	dxDrawText(string.rep("0", #string.gsub(ammostring, '#%x%x%x%x%x%x', '')), x, y+20*hud.components[component_name].zoom, x+w, y+h, tocolor(255, 255, 255, alpha/5), 0.5*hud.components[component_name].zoom, hud.fonts.audirmg, "center", "top")
	dxDrawText(ammostring, x, y+20*hud.components[component_name].zoom, x+w, y+h, tocolor(255, 255, 255, alpha), 0.5*hud.components[component_name].zoom, hud.fonts.audirmg, "center", "top", false, false, false, true)

	-- Image
	if(fileExists(hud.pfade.images.."component_weapons/weapons/"..weapon..".png")) then
	dxDrawImage(x+55*hud.components[component_name].zoom, y+70*hud.components[component_name].zoom, (286/2)*hud.components[component_name].zoom, (106/2)*hud.components[component_name].zoom, hud.pfade.images.."component_weapons/weapons/"..weapon..".png", 0, 0, 0, tocolor(255, 255, 255, 200));
	end
	end]]
end

-- ///////////////////////////////
-- ///// GetTime			//////
-- ///// Returns: String	//////
-- ///////////////////////////////

function HudComponent_Weapons:GetTime()
	local time = getRealTime()
	local day = time.monthday
	local month = time.month+1
	local year = time.year+1900
	local hour = time.hour
	local minute = time.minute
	local second = time.second;

	if(hour < 10) then
		hour = "0"..hour;
	end

	if(minute < 10) then
		minute = "0"..minute;
	end

	if(second < 10) then
		second = "0"..second;
	end
	return day.."-"..month.."-"..year.." "..hour.."-"..minute.."-"..second;
end

-- ///////////////////////////////
-- ///// ShowComponent			//////
-- ///// Returns: String	//////
-- ///////////////////////////////

function HudComponent_Weapons:ShowComponent(bBool, prevSlot, newSlot)
	if(isTimer(self.showtimer)) then
		killTimer(self.showtimer);
	end
	self.forceRender = true;

	self.showtimer = setTimer(function()
		self.forceRender = false;
	end, 3000, 1)

	if(bBool == true) then
		if(getPedWeapon(getLocalPlayer(),newSlot) == 43) then

			if(hud) and (hud.enabled) then
			--	hud:Toggle(false);
			--	self.showHudAgain = true;
			--	showChat(false);
			end
		elseif(getPedWeapon(getLocalPlayer(),prevSlot) == 43) then
			if(self.showHudAgain) then
				if(hud) then
				--	showChat(true);
				--	hud:Toggle(true);
				end
			end
		end
	elseif(bBool == 43) then
		local x, y = guiGetScreenSize();
		local tex = dxCreateScreenSource(x, y);
		dxUpdateScreenSource(tex);

		-- Screenshots --
		local pixels	= dxGetTexturePixels(tex);
		if(pixels) then
			cancelEvent();

			local image		= dxConvertPixels(pixels, "png");

			local date		= _Gsettings.serverName.."-"..self:GetTime();
			local file		= fileCreate("screenshots/"..date..".png");

			fileWrite(file, image);
			fileFlush(file);
			fileClose(file);
		else
			showInfoBox("error", "Da du deinen Screenshot Upload deaktiviert hast, wird keine Screenshot in deinem ".._Gsettings.serverName.." ordner gespeichert!")
		end

		destroyElement(tex);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Weapons:Constructor(...)
	self.enabled = true;
	self.forceRender = false;

	self.showtimer = nil;
	self.showComponentFunc = function(...) self:ShowComponent(...) end;
	self.showComponentFunc2 = function(...) self:ShowComponent(true, ...) end;


	self.showHudAgain	= false;

	-- Events --
	addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(),self.showComponentFunc)
	addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),self.showComponentFunc)
	addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(),self.showComponentFunc2)

	-- 	outputDebugString("[CALLING] HudComponent_Weapons: Constructor");
end

-- EVENT HANDLER --
