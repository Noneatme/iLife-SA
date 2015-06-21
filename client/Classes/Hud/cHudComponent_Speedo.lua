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
-- ## Name: HudComponent_Speedo.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

HudComponent_Speedo = {};
HudComponent_Speedo.__index = HudComponent_Speedo;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HudComponent_Speedo:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RenderType1		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Speedo:RenderType1()

	local name = "speedo";

	local x, y = hud.components[name].sx, hud.components[name].sy;
	local w, h = hud.components[name].width*hud.components[name].zoom, hud.components[name].height*hud.components[name].zoom;

	local alpha = hud.components[name].alpha
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	local cat = vehicleCategoryManager:getVehicleCategory(theVehicle)

	if(theVehicle) and (isPedInVehicle(localPlayer)) then else
		self.forceRender = false;
	end

	-- Render
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_speedo/Background.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	local color
	if(theVehicle) and (getVehicleEngineState(theVehicle)) then
		color = tocolor(255, 255, 255, alpha)
	else
		color = tocolor(0, 0, 0, alpha/2)
	end

	-- Motor
	dxDrawImage(x+(100*hud.components[name].zoom), y+(80*hud.components[name].zoom), 40*hud.components[name].zoom, 30*hud.components[name].zoom, hud.pfade.images.."component_speedo/Engine.png", 0, 0, 0, color, false)

	-- Licht

	if (theVehicle) and (getVehicleOverrideLights(theVehicle) == 2) then
		color = tocolor(255, 255, 255, alpha)
	else
		color = tocolor(0, 0, 0, alpha/2)
	end
	dxDrawImage(x+(165*hud.components[name].zoom), y+(80*hud.components[name].zoom), 20*hud.components[name].zoom, 30*hud.components[name].zoom, hud.pfade.images.."component_speedo/Light.png", 0, 0, 0, color, false)


	-- Text
	local value = 180;
	local speed = 0;
	if(theVehicle) then
		speed = (getElementRealSpeed(theVehicle)*getGameSpeed())
	end
	dxDrawText(math.round(speed), x+(value*hud.components[name].zoom), y+(value*hud.components[name].zoom), x+(value*hud.components[name].zoom), y+(value*hud.components[name].zoom), tocolor(255, 255, 255, alpha), 0.2*hud.components[name].zoom, hud.fonts.clock, "right", "center", false, false, false, false, false)

	-- Tanknadel

	if not vehicleCategoryManager:isNoFuelVehicleCategory(cat) then
		local fuel = 100;
		local max_fuel = vehicleCategoryManager:getCategoryTankSize(cat)
		local empty_degree = 224
		local full_degree = 136
		if(theVehicle) then
			if(getElementData(theVehicle, "Fuel")) then
				fuel = tonumber(getElementData(theVehicle, "Fuel"));
			end
		end
		if fuel > max_fuel then fuel = max_fuel end

		local fuel_degree = full_degree+(full_degree-empty_degree)*fuel/max_fuel

		dxDrawImage(x+(54*hud.components[name].zoom), y+(152*hud.components[name].zoom), (388/2)*hud.components[name].zoom, (23/2)*hud.components[name].zoom, hud.pfade.images.."component_speedo/Tanknadel.png", fuel_degree, 0, 0, tocolor(255, 255, 255, alpha), false)
	end
	-- Nadel & Punkt

	local npos = 0
	if(theVehicle) then
		if((speed)>182) then
			if (getTickCount()%100> 100) then
				npos= 183
			else
				npos= 182
			end
		else
			npos = speed - 3
		end
	else
		npos = 0;
	end

	dxDrawImage(x+(50*hud.components[name].zoom), y+(140*hud.components[name].zoom), 200*hud.components[name].zoom, 6*hud.components[name].zoom, hud.pfade.images.."component_speedo/Nadel.png", npos, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawImage(x, y, w, h, hud.pfade.images.."component_speedo/Punkt.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
end

-- ///////////////////////////////
-- ///// RenderType2		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Speedo:RenderType2()

	local name = "speedo";
	local x, y = hud.components[name].sx, hud.components[name].sy;
	local w, h = hud.components[name].width*hud.components[name].zoom, hud.components[name].height*hud.components[name].zoom;

	local alpha = hud.components[name].alpha
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())

	if(theVehicle) and (isPedInVehicle(localPlayer)) then
		-- Background --
		local u, v, a, b = unpack(self.v2.positions.background)

		local alpha2 = alpha
		if(getVehicleEngineState(theVehicle) == false) then
			alpha2 = alpha/2
		end
		dxDrawImageSection(x, y, w, h, u, v, a, b, self.v2.texture, 0, 0, 0, tocolor(255, 255, 255, alpha))

		-- Nitro --
		local u, v, a, b = unpack(self.v2.positions.nitro_background)
		dxDrawImageSection(x, y, w, h, u, v, a, b, self.v2.texture, 0, 0, 0, tocolor(255, 255, 255, alpha))


		-- Nadel --
		u, v, a, b = unpack(self.v2.positions.nadel)

		local rotation = -135
		-- Das ist Doof mit der Nadel Textur, spart man sich aber Arbeit

		rotation = rotation + self:GetElementSpeed(theVehicle)*0.5;
		dxDrawImageSection((x+w/2)-9*hud.components[name].zoom, y-9*hud.components[name].zoom, a*hud.components[name].zoom, b*hud.components[name].zoom, u, v, a, b, self.v2.nadelTexture, rotation, 0, 0, tocolor(255, 255, 255, alpha))

		-- Gang
		dxDrawText(getVehicleCurrentGear(theVehicle), x+w-48*hud.components[name].zoom, y+h-98*hud.components[name].zoom, w, h, tocolor(0, 0, 0, alpha), 0.28*hud.components[name].zoom, self.v2.font, "left", "top")
		dxDrawText(getVehicleCurrentGear(theVehicle), x+w-50*hud.components[name].zoom, y+h-100*hud.components[name].zoom, w, h, tocolor(255, 255, 255, alpha), 0.28*hud.components[name].zoom, self.v2.font, "left", "top")

		-- KM/H--
		dxDrawText(math.floor(self:GetElementSpeed(theVehicle)*0.5),  x-w/2, y+h/2+70*hud.components[name].zoom, w/2+x+70*hud.components[name].zoom, h+y, tocolor(0, 0, 0, alpha), 0.35*hud.components[name].zoom, self.v2.font, "right", "top")
		dxDrawText(math.floor(self:GetElementSpeed(theVehicle)*0.5),  x-w/2+6*hud.components[name].zoom, y+h/2+72*hud.components[name].zoom, w/2+x+70*hud.components[name].zoom, h+y, tocolor(255, 150, 0, alpha), 0.35*hud.components[name].zoom, self.v2.font, "right", "top")

		-- Unit --
		dxDrawText("KM/H", x+w-60*hud.components[name].zoom, y+h-38*hud.components[name].zoom, w, h, tocolor(0, 0, 0, alpha), 0.08*hud.components[name].zoom, self.v2.font, "left", "top")
		dxDrawText("KM/H", x+w-62*hud.components[name].zoom, y+h-40*hud.components[name].zoom, w, h, tocolor(255, 150, 0, alpha), 0.08*hud.components[name].zoom, self.v2.font, "left", "top")
	end
end

-- ///////////////////////////////
-- ///// Render				//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Speedo:Render()
	local component_name = "speedo"

	if(self.type == 1) then
		self:RenderType1();
	else
		self:RenderType2();
	end
end

-- ///////////////////////////////
-- ///// Toggle		 		//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Speedo:Toggle(bBool)
	local component_name = "speedo"

	if (bBool == nil) then
		hud.components[component_name].enabled = not (hud.components[component_name].enabled);
	else
		hud.components[component_name].enabled = bBool;
	end
end


-- ///////////////////////////////
-- ///// GetelementSpeed	//////
-- ///// Returns:	void	//////
-- ///////////////////////////////

function HudComponent_Speedo:GetVehicleRPM(uVehicle)

	if(uVehicle) then
		uVehicleGear = getVehicleCurrentGear(uVehicle)

		if isVehicleOnGround(uVehicle) then
			if (getVehicleEngineState(uVehicle) == true) then
				vehicleRPM = math.ceil(self:GetElementSpeed(uVehicle)/vehicleGear)*161

				if vehicleRPM < 650 then
					vehicleRPM = math.random(645, 650)
				elseif vehicleRPM > 8500 then
					vehicleRPM = math.random(8500, 8505)
				end
			end
		else
			if(getVehicleEngineState(uVehicle) == true) then
				vehicleRPM = vehicleRPM - 161

				if vehicleRPM < 650 then
					vehicleRPM = math.random(645, 650)
				elseif vehicleRPM > 8500 then
					vehicleRPM = math.random(8500, 8505)
				end
			end
		end

		return (vehicleRPM or 0)
	end
end

-- ///////////////////////////////
-- ///// SetType	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Speedo:SetType(iType)
	self.type	= iType;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HudComponent_Speedo:Constructor(iType)
	-- Klassenvariablen --
	self.forceRender 	= false;
	self.fuel 			= 55

	self.type			= (iType or 1)

	self.v2				= {};

	self.v2.positions	=
	{
		background 			= {0, 0, 292, 256},
		nadel				= {0, 0, 19, 306},
		nitro_background  	= {0, 256, 292, 256},

	};


	self.v2.texture		= dxCreateTexture(hud.pfade.images.."component_speedo/v2/hud.dds", "argb", true, "clamp" );
	self.v2.nadelTexture= dxCreateTexture(hud.pfade.images.."component_speedo/v2/nadel.dds", "argb", true, "clamp" );
	self.v2.font		= dxCreateFont("res/fonts/racebrannt.ttf", 128);

	-- EVENT HANDLERS --
	addEventHandler("onClientVehicleEnter", getRootElement(), function(enterer)
		if (enterer == getLocalPlayer()) then
			self.forceRender = true;
		end
	end)

	addEventHandler("onClientVehicleExit", getRootElement(), function(exiter)
		if (exiter == getLocalPlayer()) then
			self.forceRender = false;
		end
	end)

	addEventHandler("onClientVehicleStartExit", getRootElement(), function(exiter)
		if (exiter == getLocalPlayer()) then
			self.forceRender = false;
		end
	end)
	-- 	outputDebugString("[CALLING] HudComponent_Speedo: Constructor");
end

-- EVENT HANDLER --
