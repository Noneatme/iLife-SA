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
-- ## Name: AussichtsPunkt.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

AussichtsPunkt = {};
AussichtsPunkt.__index = AussichtsPunkt;

addEvent("onClientDownloadFinnished", true);
addEvent("onClientAussichtsPunktToggle", true);

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function AussichtsPunkt:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RenderCoronas 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:RenderCoronas()
	for index, corona in pairs(self.marker) do
		if not(self.markerState[corona]) then
			local r, g, b, alpha = getMarkerColor(corona);
			if(alpha < 5) then
				self.markerState[corona] = true;
				local rand = math.random(1, #self.randomColors)
				r, g, b = self.randomColors[rand][1], self.randomColors[rand][2], self.randomColors[rand][3]
			else
				alpha = alpha-3;
			end
			setMarkerColor(corona, r, g, b, alpha)
		else
			local r, g, b, alpha = getMarkerColor(corona);
			if(alpha > 250) then
				self.markerState[corona] = false;
			else
				alpha = alpha+3;
			end
			setMarkerColor(corona, r, g, b, alpha)
		end
	end

	if(isElementWithinColShape(localPlayer, self.col)) then
		setPedWeaponSlot(localPlayer, 0)
		--self.damageProof = true;
	else
		self.damageProof = false;
	end
end

-- ///////////////////////////////
-- ///// ToggleWater 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:ToggleWater(bBool)
	if not(bBool) then
		setWaterLevel(self.water, 0)
	else
		setWaterLevel(self.water, self.defaultWaterLevel);
	end
end

-- ///////////////////////////////
-- ///// MoxxiDingens 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:MoxxiDingens(uElement)
	if(uElement == localPlayer) then

		toggleAllControls(false);
		setPedAnimation(self.peds["moxxi"][1], "BAR", "Barserve_bottle", -1, true, false, false)
		setTimer(function()
			setPedAnimation(self.peds["moxxi"][1], "BAR", "Barserve_give", -1, true, false, false)

		end, 2000, 1)
		setTimer(function()
			setPedAnimation(self.peds["moxxi"][1], "BAR", "Barserve_loop", -1, true, false, false)
			toggleAllControls( true);
			triggerServerEvent("onMoxxiBarDrinkBuy", localPlayer)
		end, 4000, 1)
	end

end


function AussichtsPunkt:getPointFromDistanceRotation(x, y, dist, angle)

	local a = math.rad(90 - angle);

	local dx = math.cos(a) * dist;
	local dy = math.sin(a) * dist;

	return x+dx, y+dy;

end

-- ///////////////////////////////
-- ///// ReplaceModels 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:replaceModels()
	engineReplaceCOL(engineLoadCOL("res/models/Office/LSOffice1.col"), 4587)
	--	engineImportTXD(engineLoadTXD("res/models/office/LSOffice1.txd"),4587)
	--	engineReplaceModel(engineLoadDFF("res/models/office/LSOffice1.dff", 0), 4587)

	engineReplaceCOL(engineLoadCOL("res/models/Office/LSOffice1Floors.col"), 3781)
	--	engineImportTXD(engineLoadTXD("res/models/office/LSOffice1Floors.txd"), 3781)
	--	engineReplaceModel(engineLoadDFF("res/models/office/LSOffice1Floors.dff", 0), 3781)

	engineReplaceCOL(engineLoadCOL("res/models/Office/LSOffice1Glass.col"), 4605)
	engineImportTXD(engineLoadTXD("res/models/Office/LSOffice1.txd"), 4605)
	engineReplaceModel(engineLoadDFF("res/models/Office/LSOffice1Glass.dff", 0), 4605)


	-- HDW 201 --

	self.m_hallOfGamesSign		= createObject(4988, 1806.8000488281, -1287.9000244141, 20.299999237061, 0, 0, 52);
	setObjectScale(self.m_hallOfGamesSign, 0.40);
	FrameTextur:New(self.m_hallOfGamesSign, "ads003 copy", "paintings/hallofgames.jpg", true);

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:Constructor(...)
	-- Klassenvariablen --
	self.path = "http://noneat.me/sound/iLife/music_moxxys_"..math.random(1, 3)..".ogg";

	self.m_tblDimElements	= {}

	self.soundPos =
	{
	--	{1818.4282226563, -1286.5090332031, 120.5016708374},
		{1810.2058105469, -1293.7911376953, 122.25536346436},
		{1812.3447265625, -1284.6290283203, 120.5016708374},
		{1801.4545898438, -1295.4116210938, 120.5016708374},
		{1805.9984130859, -1301.240234375, 120.5016708374},
	}

	self.randomColors =
	{
		{255, 0, 0},
		{0, 255, 0},
		{0, 0, 255},
		{255, 255, 0},
		{0, 255, 255},
		{255, 0, 255},
	}


	self.marker =
	{
		createMarker(1818, -1290, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1292.4000244141, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1294, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1296, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1298, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1818, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1816, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1814, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1812, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1810, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
		createMarker(1808, -1301, 123.59999847412, "corona", 1.0, 255, 255, 255, math.random(1, 250)),
	}
	for index, corona in pairs(self.marker) do
		table.insert(self.m_tblDimElements, corona)
	end
	self.moxxiMarker = createMarker(1815.8433837891, -1293.4738769531, 120.25536346436, "corona", 0.5, 0, 255, 0, 255);

	table.insert(self.m_tblDimElements, self.moxxiMarker)

	self.paintings =
	{
		{createObject(3410, 1816.4000244141, -1294.4000244141, 124.19999694824, 0, 180, 180), "mp_aldeasign", "moxxis_01.jpg", 1,               -- Moxxis Bar, Schild ueber Bar
			{"Moxxi's Bar!", true}},
		{createObject(2255, 1832.5, -1314.5999755859, 121, 0, 0, 240), "cj_painting9", "borderlands_01.jpg", 3, {"Borderlands 2"}},				                -- Grosses Pornoschild
		{createObject(2289, 1818.3994140625, -1289.099609375, 123, 0, 0, 270), "cj_painting3", "moxxis_02.jpg", 1, {"Moxxis", true}},				                -- Kleines Schild an Bar
		{createObject(2280, 1782.099609375, -1303.69921875, 121, 0, 0, 270), "cj_painting11", "gtav_01.jpg", 3, {"GTA V", true}},				                -- Grosses Ueber Couch
		{createObject(2279, 1817.9000244141, -1291, 122.5, 0, 0, 270), "cj_painting37", "guildwars_01.jpg", 1, {"Guildwars", true}},					                -- Kleines Schild an Bar
		{createObject(2267, 1818.3994140625, -1298.69921875, 122.80000305176, 0, 0, 270), "cj_painting19", "b2s_01.jpg", 1, {"One Piece", true}},                -- Kleines Schild an Bar
		{createObject(2266, 1811.099609375, -1292.599609375, 122, 0, 0, 180), "cj_painting14", "wow_01.jpg", 1, {}},				                -- Kleines Schild an Bar, Pfosten
		{createObject(2266, 1817.5, -1295.69921875, 122.30000305176, 0, 0, 270), "cj_painting14", "dayz_01.jpg", 2, {"DayZ", true}},			                -- Kleines Schild an Bar
		{createObject(2280, 1817.8994140625, -1292.8994140625, 122.59999847412, 0, 0, 270), "cj_painting11", "heartstone_01.jpg", 1, {"Heartstone", true}},	        -- Kleines Schild an Bar
		{createObject(2276, 1774.5, -1306.3994140625, 120.59999847412, 0, 0, 153.24), "cj_painting28", "primal_01.jpg", 3, {"Primal"}},		                -- Grosses Seitenschild, Weisse Bruecke
		{createObject(2276, 1818.8994140625, -1273.099609375, 120.59999847412, 0, 0, 31.245), "cj_painting28", "dotalol_01.jpg", 3, {"Watch_Dogs"}},            -- Grosses Seitenschild, Weisse Bruecke
		{createObject(2279, 1815.19921875, -1275.7998046875, 121.30000305176, 0, 0, 30), "cj_painting37", "pokemon_01.jpg", 4, {"Pokemon"}},		            -- Grosses Schild neben Weisse Bruecke
		{createObject(2279, 1780.7998046875, -1309, 121.30000305176, 0, 0, 154), "cj_painting37", "tlous_01.jpg", 4, {"The Last Of Us"}},			                -- Grosses Schild neben Weisse Bruecke
		{createObject(2261, 1786.8994140625, -1307.3994140625, 120.69999694824, 0, 0, 0), "cj_painting24", "skyrim_01.jpg", 3, {"Skyrim"}},	                -- Schild neben Couch
		{createObject(2261, 1786.9000244141, -1300.0999755859, 121.90000152588, 0, 0, 180), "cj_painting24", "spyro_01.jpg", 3, {"Spyro"}},                -- Gant Bridge Schild
		{createObject(2261, 1821.5, -1285.5, 120.69999694824, 0, 0, 180), "cj_painting24", "minecraft_01.jpg", 3, {"Star Citizen"}},				                -- Gant Bridge Schildr
		{createObject(2262, 1809.7998046875, -1300.099609375, 121.19999694824, 0, 0, 180), "cj_painting20", "portal_01.jpg", 3, {"Portal 2"}},                -- Schild an Bar Rechts
		{createObject(2261, 1815.5, -1300.099609375, 120.90000152588, 0, 0, 180), "cj_painting24", "oni_01.jpg", 3, {"Oni"}},			                -- Schild an Bar Rechts
		{createObject(2263, 1804.9000244141, -1303.5999755859, 121.59999847412, 0, 0, 270), "cj_painting4", "ilife_01.jpg", 3, {}},	                -- Schild an Seite, Docks cj_painting4
		{createObject(2263, 1817, -1308.8994140625, 121.59999847412, 0, 0, 270), "cj_painting4", "godofwar_01.jpg", 3, {"God of War", true}},			                -- Schild an Seite, Docks
		{createObject(2263, 1825.69921875, -1309, 121.59999847412, 0, 0, 90), "cj_painting4", "lbp_01.jpg", 3, {"Code Geass", true}},					                -- Schild an Seite, Docks
		{createObject(2264, 1791.599609375, -1304, 121.19999694824, 0, 0, 90), "cj_painting12", "tetris_01.jpg", 3, {"Tetris", true}},			                -- Schild hinter Couch
		{createObject(2264, 1809.2998046875, -1310.69921875, 121.19999694824, 0, 0, 180), "cj_painting12", "exteel_01.jpg", 3, {"Exteel"}, {613, 270, 4}},	                -- Schild an Wand, Strandhaus
		{createObject(2266, 1832, -1273.599609375, 120.19999694824, 0, 0, 309.49584960938), "cj_painting14", "gtaiv_01.jpg", 4, {"Borderlands: TPS", true}, {634, 468, 4}},                -- Nighttime-Schild an schraege Wand
		{createObject(2266, 1826.19921875, -1292.5, 121.30000305176, 0, 0, 90), "cj_painting14", "rf_01.jpg", 4, {"Final Fantasy VI", true}},				                -- Nighttime-Schild
		{createObject(2266, 1775.8994140625, -1298.7998046875, 121.09999847412, 0, 0, 22.494506835938), "cj_painting14", "torchlight_01.jpg", 4 ,{"CS:GO"}},-- Nighttime-Schild
		{createObject(2261, 1810.1999511719, -1307.4000244141, 121.19999694824, 0, 0, 0), "cj_painting24", "new_1.jpg", 3,{}},                     -- Neues Schild 1
		{createObject(2261, 1815.8000488281, -1307.4000244141, 121.19999694824, 0, 0, 0), "cj_painting24", "new_2.jpg", 3,{}},                     -- Neues Schild 2
		{createObject(2261, 1797.8000488281, -1296.5, 120.69999694824, 0, 0, 4), "cj_painting24", "new_3.jpg", 3, {"Transformers Universe"}, {634, 525, 4}},                              -- Neues Schild 3
		{createObject(2261, 1816.5999755859, -1271.3000488281, 133.30000305176, 0, 0, 30), "cj_painting24", "no_jumping_01.jpg", 2,{}},	        -- Nicht Springen Schild auf Dach

		-- Dawi Noneatme Schild
		--[[{createObject(4729, 1687.5, -1267.0999755859, 131.5, 70, 270, 90), "bobo_2", "dawi_noneatme_01.jpg", 3, "Hier haben sich Dawi & Noneatme verewigt."},
		{createObject(4729, 1687.5, -1225.3000488281, 131.5, 70, 270, 90), "bobo_2", "dawi_noneatme_02.jpg", 3, "Hier haben sich Dawi & Noneatme verewigt."}, ]]
		--{createObject()},

	}

	self.peds =
	{
		["moxxi"] = {createPed(152, 1817.3167724609, -1294.0125732422, 120.25536346436, 90), "BAR", "Barserve_loop"},
	 	["noneatme"] = {createPed(60, 1818.4091796875, -1273.6086425781, 120.25536346436, 136), "COP_AMBIENT", "Coplook_think"},
		["dawi"] = {createPed(155, 1817.4124755859, -1275.0113525391, 120.25536346436, 324.44), "ped", "IDLE_chat"},
	}


	for index, tbl in pairs(self.peds) do
		local ped = tbl[1];
		setElementFrozen(ped, true);
		addEventHandler("onClientPedDamage", ped, cancelEvent);
		if(tbl[2]) then
			setPedAnimation(ped, tbl[2], tbl[3], -1, true, false, false);
		end

		table.insert(self.m_tblDimElements, ped)
	end

	self.col = createColSphere(1811.48828125, -1298.5926513672, 120.25536346436, 55);

	self.water = createWater(1820.9, -1285.2, 131.7, 1835.5, -1295.2, 131.7, 1820, -1272.5, 131.7, 1831.4, -1272.5, 131.7);
	self.defaultWaterLevel = 131.7;

	setWaterLevel(self.water, self.defaultWaterLevel)
	setWaveHeight(0.5, self.water);
	setWaterColor(0, 155, 255, 150, self.water);

	self.shader 				= {}
	self.sound 					= {}
	self.paintingsTable 		= {}

	self.defaultPaintingMessage = "Dieses Gemaelde ist noch frei, frage einen Admin falls du einen Vorschlag hast.";
	self.noPaintingMessage		= "Dieses Gemaelde wurde noch nicht beschriftet.";

	self.markerState = {}

	self.damageProof 			= false;
	self.damageProofFunc 		= function() if(self.damageProof) then cancelEvent() end end;
	self.toggleFunc 			= function(...) self:ToggleWater(...) end;
	self.moxxiMarkerFunc 		= function(...) self:MoxxiDingens(...) end;

	-- Textur: mp_aldeasign
	-- cj_painting9
	addEventHandler("onClientAussichtsPunktToggle", getLocalPlayer(), self.toggleFunc);


	addEventHandler("onClientMarkerHit", self.moxxiMarker, self.moxxiMarkerFunc)
	addEventHandler("onClientPlayerDamage", localPlayer, self.damageProofFunc)
	addEventHandler("onClientDownloadFinnished", getLocalPlayer(), function()

		--[[
		self.shader = dxCreateShader("res/shader/texture.fx");
		dxSetShaderValue(self.shader, "Tex", dxCreateTexture("res/textures/moxxis.png"));
		engineApplyShaderToWorldTexture(self.shader, "mp_aldeasign", self.schild);
		]]

		for i = 1, 1, 1 do
			self.sound[i] = playSound3D(self.path, self.soundPos[i][1], self.soundPos[i][2], self.soundPos[i][3], true)
			setSoundMaxDistance(self.sound[i], 55);

			table.insert(self.m_tblDimElements, self.sound[i])
		end

		-- Paintings --
		for index, tbl in pairs(self.paintings) do
			if(tbl[2] and tbl[3]) then
				if not(tbl[6]) then
					self.shader[index] = dxCreateShader("res/shader/texture.fx");
					dxSetShaderValue(self.shader[index], "Tex", dxCreateTexture("res/textures/paintings/"..tbl[3]));
					engineApplyShaderToWorldTexture(self.shader[index], tbl[2], tbl[1]);
				else
					self.shader[index]  =  cScrollImageShader:new(tbl[2], "res/textures/paintings/"..tbl[3], tbl[1], tbl[6][1], tbl[6][2], tbl[6][3])
				end

				if(tbl[5][1]) then

					local scale         = 1;

					if(tbl[4]) then
						scale           = tbl[4]/3
					end
					local x, y, z       = getElementPosition(tbl[1]);

					local rx, ry, rz    = getElementRotation(tbl[1]);

					if(tbl[5][2]) then
						scale = -scale
					end
					local nx, ny        = getPointFromDistanceRotation(x, y, scale, rz)

					cInformationWindow:new({nx, ny, z+getElementDistanceFromCentreOfMassToBaseOfModel(tbl[1])}, tbl[5][1], 10, false)
				end
			end

			if(tbl[4]) then
				setObjectScale(tbl[1], tbl[4]);
			end

			--[[
			local x, y, z = getElementPosition(tbl[1]);
			local rx, ry, rz = getElementPosition(tbl[1]);
			self.paintings[index]["clickedElement"] = createObject(2190, x, y, z, rx, ry, rz);
			setElementAlpha(self.paintings[index]["clickedElement"], 255);
			setElementCollisionsEnabled(self.paintings[index]["clickedElement"], true)
			setObjectScale(self.paintings[index]["clickedElement"], 0)]]
			setElementCollisionsEnabled(tbl[1], true)

			table.insert(self.m_tblDimElements, tbl[1])

			self.paintingsTable[tbl[1]] = tbl;
		end


		addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
			if(button == "left") and (state == "down") then
				if(self.paintingsTable[clickedElement] ~= nil) then

					local tbl = self.paintingsTable[clickedElement];
					if(tbl[5] ~= nil) then
						outputChatBox(tbl[5], 255, 255, 255)
					else
						if(tbl[3] ~= nil) and (tbl[2] ~= nil) then
							outputChatBox(self.noPaintingMessage, 255, 255, 255)
						else
							outputChatBox(self.defaultPaintingMessage, 255, 255, 255)

						end
					end
				end
			end
		end)

		self:replaceModels()

		local defaultDim = 2
		for _, ele in pairs(self.m_tblDimElements) do
			ele:setDimension(defaultDim)
		end
	end)

	self.renderCoronasFunc = function() self:RenderCoronas() end;
	-- Methoden --
	--

	addEventHandler("onClientRender", getRootElement(), self.renderCoronasFunc);

	addEvent("onAlcoholDrink", true);
	addEventHandler("onAlcoholDrink", localPlayer, function()
		if(insanityShader.enabled) then
			insanityShader:ApplyAlcohol(0.1);
		else
			insanityShader:Enable(true);
		end

		if(isTimer(self.alcTimer)) then
			killTimer(self.alcTimer)
		end
		self.alcTimer	= setTimer(function() if not(isPedDead(localPlayer)) then insanityShader:Disable() end end, 2*60*1000, 1)
	end)

	-- Events --

	addEvent("onClientHallOfGamesEnter", true)
	addEventHandler("onClientHallOfGamesEnter", getLocalPlayer(), function(iID, iDim)
		if(iID == 1) then
			cMapManager:getInstance():loadMap("res/maps/locations/aussichtspunkt.map", 2, 0)
		elseif(iID == 2) then
			cMapManager:getInstance():loadMap("res/maps/locations/hallofgames-2etage.map", 3, 0)
		else
			cMapManager:getInstance():unloadMap("res/maps/locations/aussichtspunkt.map")
			cMapManager:getInstance():unloadMap("res/maps/locations/hallofgames-2etage.map")
		end

		if(iDim) then
			for _, ele in pairs(self.m_tblDimElements) do
				ele:setDimension(2)
			end
		end
	end)

	--logger:OutputInfo("[CALLING] AussichtsPunkt: Constructor");
end

-- EVENT HANDLER --
