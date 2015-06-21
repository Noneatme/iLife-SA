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
-- ## Name: CustomWorldTextures.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

CustomWorldTextures = {};
CustomWorldTextures.__index = CustomWorldTextures;

addEvent("onClientDownloadFinnished", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function CustomWorldTextures:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// LoaderCustomWorldTextures
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomWorldTextures:LoadCustomWorldTextures()

	self.m_tblTexs 	= {}
	local function replaceTex(tex, texname)
		if not(texname) then
			texname = tex;
		end
		if(fileExists(self.pfade.textures..texname)) then


			local shader = "texture.fx"

			if(self.scrollTexVert[tex]) then
				self.shaders[tex] = dxCreateShader(self.pfade.shaders..shader);
			else
				self.shaders[tex] = dxCreateShader(self.pfade.shaders..shader, 0, 0, false, "all");
			end

			local texture
			if not(self.m_tblTexs[self.pfade.textures..texname]) then
				if not(DEFINE_DEBUG) then
					texture = dxCreateTexture(self.pfade.textures..texname, "dxt5", true);
				else
					texture = dxCreateTexture(self.pfade.textures..texname);
				end
				self.m_tblTexs[self.pfade.textures..texname] = texture;
			else
				texture = self.m_tblTexs[self.pfade.textures..texname];
			end
			dxSetShaderValue(self.shaders[tex], "Tex", texture);

			local tex2 = tex;
			for index, d in pairs(self.gsubs) do
				tex2 = string.gsub(tex2, d, "");
			end
			engineApplyShaderToWorldTexture(self.shaders[tex], tex2)
		end
	end

	for index, tex in pairs(self.tex) do
		if(type(tex) == "table") then
			local texturename	= self.tex[index][1];

			for index2, texture in pairs(tex) do
				replaceTex(texture, texturename);
			end
		else
			replaceTex(tex);
		end
	end

	for index, tbl in pairs(self.scrollTexVert) do
		self.scrollTextSH[index] = cScrollImageShader:new(unpack(tbl))
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function CustomWorldTextures:Constructor(...)
	-- Klassenvariablen --

	self.gsubs				=
	{".jpg", ".png"}

	self.tex				=
	{
		"veding1_64.png",
		"veding2_64.png",
		"vgsn_scrollsgn.png",
		"plateback1.png",
		"plateback2.png",
		"plateback3.png",
		"platecharset.png",
		"newsvan92decal128.png",
		"cj_hi_fi_1.png",
		"petroltr92decal256.png",
		"ammo_bx.png",
		"frate64_blue.jpg",
		"frate64_red.jpg",
		"frate64_yellow.jpg",
		"frate_doors64yellow.jpg",
		"frate_doors128red.jpg",
		"frate_doors64.jpg",
		"SNIPERcrosshair.png",
		"touristbureaulawn.jpg",
		"sexsign1_lawn.jpg",
		-- Hall of Games
		{"glass_office5.jpg", "glass_office4.jpg"},		-- Floor
		{"glass_office8.jpg", "glass_office2.jpg", "glass_office1.jpg"},		-- Ceiling und Wand
		"nt_bonav1.png",			-- Glass
		--
		"vla2.jpg",
		"vla3.jpg",
		"veg_marijuana.png",
		"mp_cop_name.jpg",
        "vehiclepoldecals128.png",
        "vehiclelights128.png",
        "vehiclelightson128.png",
        "vehiclegeneric256.jpg",
		"sw_fleishberg01.jpg",
		"hotknifebody128b.jpg",
		"hotknifebody128a.jpg",
		"mural06_la.jpg",

	--	"cameracrosshair.png",


	};
	-- veg_marijuana;

	self.scrollTexVert  =
	{
		["sexsign1_lawn.png"] = {"sexsign1_lawn", "res/textures/objects/sexsign1_lawn.jpg", nil, 512, 256, 4},
	}




	self.pfade				= {};
	self.pfade.textures 	= "res/textures/objects/";
	self.pfade.shaders		= "res/shader/";

	self.shaders			= {}
	self.scrollTextSH       = {}

	-- Methoden --
	self.replaceTex			= function(...) self:LoadCustomWorldTextures(...) end;

	-- Events --
	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), self.replaceTex)
	--logger:OutputInfo("[CALLING] CustomWorldTextures: Constructor");
end

-- EVENT HANDLER --
