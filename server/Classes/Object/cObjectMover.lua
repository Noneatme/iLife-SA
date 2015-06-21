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
-- ## Name: ObjectMover.lua				##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

ObjectMover = {};
ObjectMover.__index = ObjectMover;

--[[

]]

-- Events --
addEvent("onClientObjectMovingDone", true)
addEvent("onClientObjectMovingStart", true)
addEvent("onClientObjectMovingPickUp", true)


-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ObjectMover:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ObjectMovingStart	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:ObjectMovingStart(uObject)
	-- Ob es ein erlaubtes Element ist
	if(self.elementsToCheck[getElementType(uObject)]) then
		-- Spieler bekommen
		local uPlayer = client;

		-- Objekt Zwischenspeichern
		self.playerObject[uPlayer] = uObject;


		-- Und Bewegend setzen
		setElementData(uObject, "wa:CurrentMoving", getPlayerName(uPlayer));
		setElementAlpha(uObject, 150);
	end
end

-- ///////////////////////////////
-- ///// ObjectMovingDone	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:ObjectMovingDone(iX, iY, iZ, rX, rY, rZ, bSaved)
	-- Spieler bekommen
	local uPlayer = client;

	-- Wenn das Objekt noch exisitert
	if(isElement(self.playerObject[uPlayer])) then

		-- Das Spielerobjekt bekommen
		local uObject = self.playerObject[uPlayer];

		-- Moven
		local x, y, z	= getElementPosition(uObject);
		local iDistanz 	= getDistanceBetweenPoints3D(iX, iY, iZ, x, y, z);

		local iTime = 1000

		local oRX, oRY, oRZ = getElementRotation(uObject);

		moveObject(uObject, iTime, iX, iY, iZ, rX-oRX, rY-oRY, rZ-oRZ, "InOutQuad");
		setElementAlpha(uObject, 255);
		setElementCollisionsEnabled(uObject, false)


		-- Timer

		if(iTime >= 50) then
			setTimer(function()
				setElementPosition(uObject, iX, iY, iZ);
				setElementCollisionsEnabled(uObject, true)
				if(isElement(uPlayer)) then
					if(getElementInterior(uPlayer) == 0) then
						triggerClientEvent(uPlayer, "onObjectMoverSoundPlay", uPlayer, "obj_place.mp3");
					else
						triggerClientEvent(uPlayer, "onObjectMoverSoundPlay", uPlayer, "obj_place_interior.mp3");
					end
				end
			end, iTime, 1)
			setElementData(uObject, "wa:CurrentMoving", false);
		else
			setElementCollisionsEnabled(uObject, true)
			setElementData(uObject, "wa:CurrentMoving", false);
		end

		uObject:Save(iX, iY, iZ, rX, rY, rZ);

		local zDistance = iZ-z;

		if(zDistance < -5 or zDistance > 5) then
			Achievements[57]:playerAchieved(uPlayer);
		end
		-- Debug Stringen
		outputDebugString(getPlayerName(uPlayer).." moved Object "..tostring(uObject));


		if(bSaved == true) then
			uPlayer:showInfoBox("info", "Dieses Objekt wird auf deinem Grundstück gespeichert!");
		end

	end
end

-- ///////////////////////////////
-- ///// PickObjectUp		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:PickObjectUp(uObject, bDontNotify)
	-- Spieler
	local uPlayer = client;

	-- Wenn das Element noch existiert (Doppeltes Draufdruecken verhindern)
	if(isElement(uObject)) and (uObject.sOwner) then
		if (tonumber(getElementData(uObject, "wa:Owner")) == uPlayer:getID()) or (uPlayer:getAdminLevel() > 0) or (tonumber(getElementData(uObject, "wa:Owner")) == tonumber(getElementData(uPlayer, "p:Fraktion"))) then

	--		if((uPlayer:getAdminLevel() < 1)) then
				local modell = getElementModel(uObject);
				if(modell == 3013) then
					if(tonumber(uObject:GetWAData("geld")) ~= 0) then
						uPlayer:showInfoBox("error", "Diese Geldschachtel ist nicht leer!");
						return
					end
				end

				if(modell == 2046) then
					if(self.co.waffenSchrank:GetWeapons(uObject) > 0) then
						uPlayer:showInfoBox("error", "Dieser Waffenschrank ist nicht leer!");
						return
					end
				end

				if(modell == 2969) then
					if(self.co.storageBox:getItemCount(uObject) > 0) then
						uPlayer:showInfoBox("error", "Diese Kiste ist nicht leer!");
						return
					end
				end
				-- Bekomem das Item aus der Tabelle
				local item = 0;
				for index, mod in pairs(self.objectModels) do
					if(mod == modell) then
						item = index;
						break;
					end
				end
	--		end
			local x, y, z = getElementPosition(uObject);
			local name = "-"
			if(uObject.moClass) and (PlayerNames[uObject.moClass.uObject.sOwner]) then
				name = PlayerNames[uObject.moClass.uObject.sOwner];
			end
			logger:OutputPlayerLog(uPlayer, "Hob Objekt auf", name.."("..(uObject.moClass.uObject.sOwner or "-")..")", getZoneName(x, y, z, false)..", "..getZoneName(x, y, z, true), getElementModel(uObject).."("..uObject.iID..")");

			-- Loesche Objekt
			uObject.moClass:RemoveAllExtras()
			uObject:Delete();

			uPlayer:getInventory():addItem(Items[item], 1);
			uPlayer:refreshInventory();



			-- Gebe es dem Spieler
			if not(bDontNotify) then
				uPlayer:showInfoBox("info", "Du hast dein Objekt aufgehoben!");

				triggerClientEvent(uPlayer, "onObjectMoverSoundPlay", uPlayer, "obj_pickup.mp3");
			end
		else
			if not(bDontNotify) then
				uPlayer:showInfoBox("error", "Dieses Objekt gehört dir nicht!");
			end
		end
	end
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ObjectMover:Constructor(...)
	--[[
	Funktionsweise der Datenbankspeicherung:
	- Bei Objekterstellung - Jedes Objekt wird in die Datenbank bei erstellung Abgespeichert
	- Methode Delete:		- Loescht das Objekt aus der Datenbank
	Bei Serverneustart:
	- Abfrage aller Objekte aus der Datenbank
	-> Wenn sich das Objekt in der naehe eines Hauses befindet, und der Besitzer der Hausbesitzer ist, wird es erstellt
	-> Andererseits wird es aus der Datenbank entfernt.
	]]
	-- Klassenvariablen --
	self.playerObject				= {};

	-- Elements to Check
	self.elementsToCheck 	=
	{
		["object"] = true,
	}


	self.co					= {}
	self.co.geldSchachtel 	= CO_Geldschachtel:New();
	self.co.Radio			= CO_Radio:New();
	self.co.Sodaautomat 	= CO_Sodaautomat:New();
	self.co.Toilette		= CO_Toilette:New();
	self.co.Holz			= CO_Holz:New();
	self.co.Grill			= CO_Grill:New();
	self.co.waffenSchrank	= CO_Waffenschrank:New();
	self.co.storageBox		= new(CStorageBox)



	self.objectModels 		=
	{
		[42] = 1255,
		[43] = 642,
		[44] = 1481,
		[45] = 3461,
		[46] = 1429,
		[47] = 1463,
		[48] = 1432,
		[49] = 1419,
		[50] = 1457,
		[51] = 2103,
		[52] = 1215,
		[53] = 1280,
		[54] = 2190,
		[55] = 640,
		[56] = 792,
		[57] = 644,
		[179] = 1209,
		[180] = 1343,
		[181] = 1334,
		[182] = 1349,
		[183] = 1346,
		[184] = 627,
		[185] = 651,

		-- Polizei --
		[193] = 1459,
		[194] = 1423,
		[195] = 1422,
		[196] = 1427,
		[197] = 3091,
		[198] = 1252,
		[273] = 1772,


		-- Sonstiges --

		-- Badezimmer
		[58] = 2738,
		[59] = 2739,
		[60] = 2528,
		[61] = 2527,
		[62] = 2526,
		[63] = 2525,
		[64] = 2524,
		[65] = 2523,
		[66] = 2522,
		[67] = 2521,
		[68] = 2520,
		[69] = 2519,
		[70] = 2517,
		[71] = 2514,
		-- Kueche
		[72] = 2030,
		[73] = 2125,
		[74] = 2127,
		[75] = 2128,
		[76] = 2129,
		[77] = 2130,
		[78] = 2304,
		[79] = 2131,
		[80] = 2134,
		[81] = 2341,
		[82] = 2141,
		[83] = 2132,
		[84] = 2150,
		[85] = 2121,

		-- Wohnzimmer --
		[86] = 1702,
		[87] = 1703,
		[88] = 1705,
		[89] = 1708,
		[90] = 1709,
		[91] = 1704,
		[92] = 1728,
		[93] = 1735,
		[94] = 1738,
		[95] = 1755,
		[96] = 1760,
		[97] = 1761,
		[98] = 1762,
		[99] = 1778,
		[100] = 2096,
		[101] = 2109,
		[102] = 2291,
		[103] = 2292,
		[104] = 1746,
		[105] = 2295,

		-- Esszimmer --
		[106] = 1720,
		[107] = 1739,
		[108] = 2079,
		[109] = 2115,
		[110] = 2116,
		[111] = 2117,
		[112] = 2118,
		[113] = 2124,

		-- Dekoration --
		[114] = 948,
		[115] = 1744,
		[116] = 1815,
		[117] = 1817,
		[118] = 1818,
		[119] = 1819,
		[121] = 1822,
		[122] = 2011,
		[123] = 2023,
		[124] = 2029,
		[125] = 2069,
		[126] = 2078,
		[127] = 2083,
		[128] = 2084,
		[129] = 2086,
		[130] = 2251,
		[131] = 2108,
		[132] = 2126,
		[133] = 2135,
		[134] = 2297,
		[135] = 2296,
		[186] = 630,
		[187] = 2252,
		[188] = 2253,
		[189] = 2245,
		[190] = 2811,

		-- Haushaltsgeraete --

		[136] = 1747,
		[137] = 1719,
		[138] = 1788,
		[139] = 1809,
		[140] = 2028,
		[141] = 2099,
		[142] = 2102,
		[143] = 2104,
		[144] = 2149,
		[145] = 2186,
		[146] = 2229,
		[147] = 2230,
		[148] = 2231,
		[149] = 2322,
		[150] = 2320,
		[151] = 2316,
		[152] = 2232,
		[153] = 2224,
		[178] = 2779,
		[191] = 2361,
		[192] = 2091,

		-- Schlafzimmer --
		[154] = 1740,
		[155] = 1741,
		[156] = 1742,
		[157] = 1743,
		[158] = 1793,
		[159] = 1794,
		[160] = 1798,
		[161] = 2087,
		[162] = 2090,
		[163] = 2094,
		[164] = 2302,
		[165] = 2301,
		[166] = 2299,
		[167] = 2298,

		-- Arbeitszimmer --
		[168] = 1714,
		[169] = 2161,
		[170] = 2162,
		[171] = 2163,
		[172] = 2164,
		[173] = 2167,
		[174] = 2197,
		[175] = 2356,
		[176] = 1715,
		[177] = 2165,


		-- Fraktionsobjekte --
		-- News --
		[200] =	2773,	-- Absperrband
		[201] = 1286, 	-- Zeitungsstand
		[202] = 2453,	-- Pizzastand
		[203] = 1472,	-- Holztreppe
		[204] = 1471,	-- Holzteil
		[205] = 1470,	-- Holzeck
		[206] = 3927,	-- Schild
		-- 17951


		-- Global --
		[207] = 1300,	-- Muelleimer
		[208] = 1231,	-- Latenre 1
		[209] = 1226,	-- Laterne 2
		[210] = 1211, -- Hydrant
		[211] = 1408, -- Holzzaun 1
		[212] = 1446, -- Holzzaun 2
		[213] = 1460, -- Holzzaun 3
		[214] = 4100, -- Drahtzaun 1
		[215] = 4597, -- Parkbucht
		[216] = 11480, -- Kleines Parkdach 1
		[217] = 17037, -- Kleines Parkdach 2
		[218] = 17950, -- Garage
		[219] = 3626, -- Bauhuette
		[220] = 672, -- Fraktionsbaum 1
		[221] = 671, -- Fraktionsbaum 2

		-- Treppen --
		[222] = 14387,	-- Treppe Klein
		[223] = 11544,	-- Treppe Gross

		-- Waffenbox und Geldkasette --
		[227] = 2046, -- Waffenschrank
		[228] = 3013, -- Geldschachtel
		[259] = 2969, -- StorageBox

        -- Neue Aussenobjekte --

        --[[
                3877    - sf_rooflite
        727     - Weisser Baum
        776     - Weisser Baum 2
        779     - Weisser Baum 3 (Klein)
        889     - Weisser Baum 4
        895     - Weisser Baum 5 (Klein)
        615     - Grosser Baum (Riesig)
        616     - Grosser Baum 2 (Riesig)
        618     - Baum (Normal)
        8572    - Kleine Treppe

        --]]
        [290] = 3877,
		[291] = 727,
		[292] = 776,
		[293] = 779,
		[294] = 889,
		[295] = 895,
		[296] = 615,
		[297] = 616,
		[298] = 618,
		[299] = 8572,

	}
	--[[

	Badezimmer:
	2738	- Toilette
	2739	- Waschbecken
	2528	- Toilette
	2527	- Dusche
	2526	- Badewanne
	2525	- Toilette
	2524	- Waschbecken
	2523	- Waschbecken
	2522	- Badewanne
	2521	- Toilette
	2520	- Dusche
	2519	- Badewanne
	2517	- Dusche
	2514	- Toilette

	Kueche:
	2030	- Esstisch
	2125	- Roter Hocker
	2127	- Roter Kuehlschrank
	2128	- Rote Lange Theke
	2129	- Rote Theke
	2130	- Rote Spuele
	2304	- Rotes Thekeneck
	2131	- Weisser Kuehlschrank
	2134	- Weisse Thenke
	2341	- Weisses Thekeneck
	2141	- Weisser Schrank
	2132	- Weisse Spuele
	2150	- Spuele
	2121	- Klappstuhl



	Wohnzimmer:
	1702	- Braune Couch
	1703	- Schwarze Couch
	1705	- Brauner Sessel
	1708	- Schwarzer Sessel
	1709	- Lange Braune Couch
	1704	- Schwazer Sessel
	1728	- Braune Couch
	1735	- Relaxsessel
	1738	- Heizung
	1755	- Beiger Sessel
	1760	- Beiges Sofa
	1761	- Braunes Sofa
	1762	- Brauner Sessel
	1768	- Blaues Sofa
	2096	- Schaukelstuhl
	2109	- Kaffetisch
	2291	- Braunes Sesselteil
	2292	- Braunes Sesseleck
	1746	- Braunes Flachteil
	2295	- Sitzsack


	Esszimmer:
	1720	- Brauner Stuhl
	1739	- Brauner Stuhl
	2079	- Schwarzer Stuhl
	2115	- Langer Tisch
	2116	- Langer Tisch
	2117	- Brauner Tisch
	2118	- Marmortisch
	2124	- Langer Stuhl


	Dekoration:
	948		- Blumentopf
	1744	- Regal
	1815	- Kaffetisch
	1817	- Kaffetisch
	1818	- Kaffetisch
	1819	- Kaffetisch
	1822	- Beistelltisch
	2011	- Palme
	2023	- Stehlampe
	2029	- Beistelltisch
	2069	- Stehlampe
	2078	- Schrank
	2083	- Kaffetisch
	2084	- Kaffeschrank
	2086	- Tisch
	2251	- Vase
	2108	- Stehlampe
	2126	- Brauner Kaffetisch
	2135	- Ofen
	2297	- TV-Einheit
	2296	- TV-Einheit



	Haushaltsgeraete:
	1747	- Fernseher
	1719	- Spielekonsole
	1788	- Spielekonsole
	1809	- Hi-Fi Geraet
	2028	- Spielekonsole
	2099	- Hi-Fi kommode
	2102	- Radio
	2104	- Hi-Fi
	2149	- Mikrowelle
	2186	- Kopierer
	2229	- Schwarzr Lautsprecher
	2230	- Weisser Lautsprecher
	2231	- Weisser Grosser Lautsprecher
	2322	- Fernseher
	2320	- Fernseher
	2316	- Fernseher
	2232	- Schwarzer Lautsprecher
	2224	- Orangener Fernseher


	Schlafzimmer:
	1740	- Nachttisch
	1741	- Kommode
	1742	- Buecherregal
	1743	- Kommode
	1793	- Madratze
	1794	- Gelbes Bett
	1798	- Blaues Bett
	2087	- Kommode
	2090	- Braunes Bett
	2094	- Kommode
	2302	- Holzbett
	2301	- Blaues Bett
	2299	- Braunes Bett
	2298	- Blaues Bett


	Arbeitszimmer:
	1714	- Schwarzer Stuhl
	2161	- Regal
	2162	- Regal
	2163	- Schrank
	2164	- Schrank
	2167	- Weisser Schrank
	2197	- Aktenschank
	2356	- Stuhl
	1715	- Stuhl
	2165	- Computertisch


    -- NEUE AUSSENOBJEKTE --
    3877    - sf_rooflite
    727     - Weisser Baum
    776     - Weisser Baum 2
    779     - Weisser Baum 3 (Klein)
    889     - Weisser Baum 4
    895     - Weisser Baum 5 (Klein)
    615     - Grosser Baum (Riesig)
    616     - Grosser Baum 2 (Riesig)
    618     - Baum (Normal)
    8572    - Kleine Treppe

	]]


	-- Methoden --
	self.objectMovingDoneFunc		= function(...) self:ObjectMovingDone(...) end;
	self.objectMovingStartFunc		= function(...) self:ObjectMovingStart(...) end
	self.objectPickupFunc			= function(...) self:PickObjectUp(...) end;

	addEventHandler("onClientObjectMovingDone", getRootElement(), self.objectMovingDoneFunc);
	addEventHandler("onClientObjectMovingStart", getRootElement(), self.objectMovingStartFunc);
	addEventHandler("onClientObjectMovingPickUp", getRootElement(), self.objectPickupFunc);




--logger:OutputInfo("[CALLING] ObjectMover: Constructor");
end

-- EVENT HANDLER --
