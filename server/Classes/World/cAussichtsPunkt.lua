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

AussichtsPunkt = inherit(cSingleton);

--[[

]]


-- ///////////////////////////////
-- ///// CreateInOutMarker	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:CreateInOutMarker(marker, x, y, z, event, iInt, iDim)

	addEventHandler("onMarkerHit", marker, function(uElement)
		if(getElementType(uElement) == "player") and (isPedInVehicle(uElement) == false) then
			if not(self.playerEntered[uElement]) then
				self.playerEntered[uElement] = "no";
			end
			fadeCamera(uElement, false);
			setElementFrozen(uElement, true);
			setTimer(function()
				if(self.playerEntered[uElement] == "no") then
					self.playerEntered[uElement] = "yes"
				else
					self.playerEntered[uElement] = "no";
				end

				if(event) and (#event > 1) then
					triggerClientEvent(uElement, event, uElement, self.playerEntered[uElement]);
				end
				setElementPosition(uElement, x, y, z);
				fadeCamera(uElement, true);
				setTimer(function()
					setElementFrozen(uElement, false);
				end, 500, 1)
				setElementDimension(uElement, iDim or 0)
			end, 2000, 1)

			uElement.m_iCurIntID = iInt;
			-- Wasser
			if(marker == self.markerNochWeiterOben) then
				triggerClientEvent(uElement, "onClientAussichtsPunktToggle", uElement, false)
				triggerClientEvent(uElement, "onClientHallOfGamesEnter", uElement, 1, self.m_iDimension)
				uElement:setInSpecial("hallofgames")
			elseif(marker == self.markerUnten) then
				triggerClientEvent(uElement, "onClientAussichtsPunktToggle", uElement, false)
				triggerClientEvent(uElement, "onClientHallOfGamesEnter", uElement, 1, self.m_iDimension)
				uElement:setInSpecial("hallofgames")
			elseif(marker == self.markerNachOben) then
				triggerClientEvent(uElement, "onClientAussichtsPunktToggle", uElement, true)
				triggerClientEvent(uElement, "onClientHallOfGamesEnter", uElement, 0)
				uElement:setInSpecial(false)
			elseif(marker == self.markerNach2Etage) then
				triggerClientEvent(uElement, "onClientHallOfGamesEnter", uElement, 2, self.m_iDimension+1)
				uElement:setInSpecial("hallofgames2")
			elseif(marker == self.marker2EtageObenn) then
				triggerClientEvent(uElement, "onClientHallOfGamesEnter", uElement, 1, self.m_iDimension)
				uElement:setInSpecial("hallofgames")
			end
		end
	end)
end

-- ///////////////////////////////
-- ///// BuyMoxxiDrink 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:BuyMoxxiDrink(...)
	if(client:getMoney() >= 50) then
		boneAttachManager:AttachToPlayerBone(client, 1551, 5, 12, 0.15, 0.05, 0.025, 0, -90, 0)
		boneAttachManager:SetPlayerDrinking(client, true);

		client:addMoney(-50);

	--	BusinessObjects[20]:DepotMoney(50, "Drink Gekauft, Spieler: "..getPlayerName(client));
	else
		client:showInfoBox("error", "Das Kostet $50!");
	end

end

-- ///////////////////////////////
-- ///// getRandomPedSkin   //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:getRandomPedSkin()
    local skins =
    {12, 13, 22, 23, 37, 38, 41, 56, 59, 60, 67,
    68, 93, 106, 122, 142, 147, 156, 161, 160, 168, 170, }

    return (skins[math.random(1, #skins)]);
end

-- ///////////////////////////////
-- ///// createRAPed         //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:createRAPed(what, positions)
    local id        = self.m_iCurPedIndex
    local x, y, z, r = positions[1], positions[2], positions[3], positions[4];

    if(self.m_tblDownPedPositions[what]) then
        z = z-0.4;

        if(what == "sitting_sofa") then
            x, y = getPointFromDistanceRotation(x, y, 0.5, r);
        elseif(what == "sitting") then
            x, y = getPointFromDistanceRotation(x, y, 1, r);
        end
    end
    self.m_tblPeds[id] = Ped(self:getRandomPedSkin(), x, y, z, r);
	self.m_tblPeds[id]:setDimension(self.m_iDimension)
    if(self.m_tblAnimations[what]) then
        local block, anim = self.m_tblAnimations[what][1], self.m_tblAnimations[what][2];
        self.m_tblPedObjects[self.m_tblPeds[id]]    = createObject(1337, x, y, z);
        self.m_tblPedObjects[self.m_tblPeds[id]]:setAlpha(0);
        self.m_tblPeds[id]:attach(self.m_tblPedObjects[self.m_tblPeds[id]])

        setTimer(setPedAnimation, 1000, 1, self.m_tblPeds[id], block, anim, -1, true, false, false);

    end

    self.m_iCurPedIndex = self.m_iCurPedIndex+1;
end

-- ///////////////////////////////
-- ///// generateRandomPeds //////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:generateRandomPeds()
    for _, p in pairs(self.m_tblPeds) do
        if(isElement(p)) then
            if(isElement(self.m_tblPedObjects[p])) then destroyElement(self.m_tblPedObjects[p]) end
            destroyElement(p)
        end
    end
    self.m_tblPeds          = {}
    self.m_iCurPedIndex     = 1;
    self.m_tblPedObjects    = {}
    local max               = math.random(5, 20);
    if(getRealTime().hour > 20) then
        max               = math.random(15, 25);
    end
    local current           = 0;
    for index, positions in pairs(self.m_tblPedPositions) do
        local pob = self.m_tblProbability[index]
        for i, position in pairs(positions) do
            if(cBasicFunctions:calculateProbability(pob)) then
                self:createRAPed(index, position);
                current = current+1;
            end

            if(current == max) then
                break;
            end
        end

    end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function AussichtsPunkt:constructor(...)
	addEvent("onMoxxiBarDrinkBuy", true)

	-- Klassenvariablen --
	self.markerOben 			= createMarker(1786.8297119141, -1300.8167724609, 120.25536346436, "corona", 1.0, 0, 255, 255, 255);
	self.positionOben 			= {1786.724609375, -1298.2926025391, 120.25536346436};

	self.markerUnten 			= createMarker(1788.3035888672, -1298.6081542969, 13.375, "corona", 1.0, 0, 255, 255, 255);
	self.positionUnten			= {1788.1489257813, -1294.9949951172, 13.486227989197};

	self.positionNochWeiterOben = {1787.2067871094, -1300.6540527344, 131.73320007324};
	self.markerNochWeiterOben	= createMarker(1787.1772460938, -1302.3170166016, 131.734375, "corona", 1.0, 0, 255, 255, 255);

	self.markerNachOben 		= createMarker(1787.5081787109, -1306.6733398438, 120.25536346436, "corona", 1.0, 0, 255, 255, 255);
	self.positionNachOben		= {1787.5223388672, -1308.7554931641, 120.25536346436};

	self.markerNach2Etage		= createMarker(1807.181640625, -1311.4830322266, 120.265625, "corona", 1.0, 0, 255, 0, 255)
	self.markerNach2EtageDavor	= {1807.1060791016, -1308.9915771484, 120.265625};

	self.marker2EtageOben		= createMarker(1791.0161132813, -1303.9055175781, 114.8125, "corona", 1.0, 0, 255, 0, 255)
	self.marker2EtageObenDavor	= {1793.3133544922, -1303.3450927734, 114.8125}

	self.blip					= createBlip(1814.0229492188, -1294.1154785156, 120.25536346436, 49)

	self.kartVehicle			= createVehicle(getVehicleModelFromName("Kart"), 1804.5966796875, -1310.9476318359, 119.63937683105, 0, 0, 30);
	cInformationWindowManager:getInstance():addInfoWindow({1804.5966796875, -1310.9476318359, 120.63937683105}, "Lobbybrowser", 10)
	setVehicleDamageProof(self.kartVehicle, true);
	setElementFrozen(self.kartVehicle, true)
	setVehicleEngineState(self.kartVehicle, true);
	addEventHandler("onVehicleStartEnter", self.kartVehicle, function() cancelEvent() end);
	setVehicleColor(self.kartVehicle, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	self.m_iDimension			= 2;

	self.m_tblDimElements		=
	{
		self.markerOben,
		self.markerNachOben,
		self.kartVehicle,
		self.markerNach2Etage,
	}

	self.m_tblDim2Elements		=
	{
		self.marker2EtageOben,
	}

	for _, ele in pairs(self.m_tblDimElements) do
		ele:setDimension(self.m_iDimension);
	end

	for _, ele in pairs(self.m_tblDim2Elements) do
		ele:setDimension(self.m_iDimension+1);
	end

	-- Methoden --

	self:CreateInOutMarker(self.markerOben, self.positionUnten[1], self.positionUnten[2], self.positionUnten[3]);
	self:CreateInOutMarker(self.markerUnten, self.positionOben[1], self.positionOben[2], self.positionOben[3], false, 0, self.m_iDimension);

	self:CreateInOutMarker(self.markerNochWeiterOben, self.positionNachOben[1], self.positionNachOben[2], self.positionNachOben[3], false, 0, self.m_iDimension);
	self:CreateInOutMarker(self.markerNachOben, self.positionNochWeiterOben[1], self.positionNochWeiterOben[2], self.positionNochWeiterOben[3]);

	self:CreateInOutMarker(self.markerNach2Etage, self.marker2EtageObenDavor[1], self.marker2EtageObenDavor[2], self.marker2EtageObenDavor[3], false, 0, self.m_iDimension+1);
	self:CreateInOutMarker(self.marker2EtageOben, self.markerNach2EtageDavor[1], self.markerNach2EtageDavor[2], self.markerNach2EtageDavor[3], false, 0, self.m_iDimension);

	self.moxxiBarFunc = function(...) self:BuyMoxxiDrink(...) end;

	addEventHandler("onMoxxiBarDrinkBuy", getRootElement(), self.moxxiBarFunc)
	addEventHandler("onElementClicked", self.kartVehicle, function(button, state, uElement)
		if(button == "left") and (state == "down") then
			triggerClientEvent(uElement, "onGamemodeBrowserShow", uElement);
		end
	end)


	self.playerEntered	= {}

    self.m_tblPeds          = {}
    self.m_tblPedObjects    = {}
    self.m_tblDownPedPositions  =
    {
        ["sitting"]         = true,
        ["stepsitting"]     = true,
    }

    self.m_tblProbability   =
    {
        ["sitting"]             = 25,
        ["sitting_sofa"]        = 25,
        ["wall_smoking"]        = 15,
        ["looking_for_book"]    = 10,
        ["looking_out"]         = 20,
        ["stepsitting"]         = 20,
        ["lay"]                 = 10,
    }

    self.m_tblAnimations        =
    {
        ["wall_smoking"]        = {"SMOKING", "M_smklean_loop"},
        ["sitting"]             = {"ped", "SEAT_idle"},
        ["sitting_sofa"]         = {"ped", "SEAT_idle"},
        ["looking_for_book"]    = {"COP_AMBIENT", "Copbrowse_loop"},
        ["lay"]                 = {"BEACH", "Lay_Bac_Loop"},
        ["stepsitting"]         = {"Attractors", "Stepsit_loop"},
        ["looking_out"]         = {"cop_ambient", "Coplook_loop"},
    }
    self.m_tblPedPositions  =
    {
        ["sitting"] =
        {
            {1809.5775146484, -1300.7344970703, 120.65418243408, 90},
            {1811.041015625, -1300.7045898438, 120.65418243408, 270},
            {1811.9731445313, -1300.7354736328, 120.65418243408, 90},
            {1813.3663330078, -1300.7305908203, 120.65418243408, 270},
            {1814.2990722656, -1300.8361816406, 120.65418243408, 90},
            {1815.6896972656, -1300.7601318359, 120.65418243408, 270},
            {1816.6245117188, -1300.7408447266, 120.65418243408, 90},
            {1818.0789794922, -1300.7564697266, 120.65418243408, 270},
            -- Reihe 2
            {1809.6209716797, -1306.5905761719, 120.65418243408, 90},
            {1811.0764160156, -1306.599609375, 120.65418243408, 270},
            {1812.0085449219, -1306.5584716797, 120.65418243408, 90},
            {1813.4001464844, -1306.5994873047, 120.65418243408, 270},
            {1814.3352050781, -1306.5770263672, 120.65418243408, 90},
            {1815.72265625, -1306.578125, 120.65418243408, 270},
            {1816.662109375, -1306.6228027344, 120.65418243408, 90},
            {1818.1223144531, -1306.6146240234, 120.65418243408, 270},
        },
        ["sitting_sofa"] =
        {
            -- Sofas --
            {1794.4688720703, -1295.9896240234, 120.79453277588, 180},
            {1793.5446777344, -1296.1655273438, 120.79453277588, 180},
            {1797.697265625, -1295.9013671875, 120.79453277588, 180},
            {1799.046875, -1295.580078125, 120.79453277588, 180},
            {1781.1488037109, -1306.3520507813, 120.8087387085, 19},
        },
        ["wall_smoking"] =
        {
            {1834.3343505859, -1313.7637939453, 120.265625, 55, "wall_smoking"},
            {1835.1231689453, -1293.2283935547, 120.265625, 90, "wall_smoking"},
            {1799.7788085938, -1311.8911132813, 120.265625, 0, "wall_smoking"},
            {1803.7377929688, -1292.3084716797, 120.265625, 0, "wall_smoking"},
            {1791.0180664063, -1302.2888183594, 120.265625, 270, "wall_smoking"},
            {1815.6794433594, -1295.8071289063, 120.265625, 90},
            {1811.2102050781, -1294.1701660156, 120.265625, 180},
        },
        ["looking_for_book"] =
        {
            {1825.0366210938, -1299.1192626953, 120.265625, 90, "looking_for_book"},
            {1825.0377197266, -1296.3393554688, 120.265625, 90, "looking_for_book"},
            {1826.8717041016, -1302.259765625, 120.265625, 180, "looking_for_book"},
        },
        ["looking_out"] =
        {
            {1784.7926025391, -1295.5766601563, 120.265625, 360},
            {1786.7092285156, -1311.8919677734, 120.265625, 180},
            {1824.9975585938, -1318.5948486328, 120.265625, 180},
            {1835.5897216797, -1290.6011962891, 120.265625, 270},
            {1823.3756103516, -1270.6116943359, 120.265625, 0},
            {1812.4837646484, -1280.0660400391, 120.265625, 90},
        },
        ["stepsitting"] =
        {
            {1821.2984619141, -1286.2855224609, 120.70358276367, 0},
            {1824.9014892578, -1288.681640625, 120.70358276367, 270},
            {1825.0639648438, -1310.3366699219, 120.70358276367, 270},
            {1821.9311523438, -1312.5688476563, 120.70358276367, 180},
            {1780.7230224609, -1296.4182128906, 120.80358123779, 180},
            {1784.1591796875, -1311.6635742188, 120.70358276367, 0},
            {1771.6247558594, -1304.7989501953, 120.70358276367, 270},
            {1771.3939208984, -1299.677734375, 120.70358276367, 270},
            {1817.8269042969, -1309.6895751953, 120.70358276367, 90},
        },
        ["lay"]         =       -- BEACH Lay_Bac_Loop
        {
            {1795.5581054688, -1311.2326660156, 120.72783660889, 156},
            {1793.13671875, -1311.4252929688, 120.72783660889, 156},
            {1790.6940917969, -1311.423828125, 120.72783660889, 156},
        }
    }

    self.m_randomVehicleLines   =
    {
        [1] = "Hey, ich verkauf ein Auto. Hast du Interesse?",
        [2] = "Meine Frau will das ich mein Auto verkaufe. Interesse?",

    }

	self.Gamemaker = Ped(187, 1805.1651611328, -1303.7449951172, 120.25536346436 ,90, false)
	self.Gamemaker:setFrozen(true)
	self.Gamemaker:setDimension(self.m_iDimension)
	addEventHandler("onElementClicked", self.Gamemaker,	function(btn, state, thePlayer)
			triggerClientEvent(thePlayer, "onServerSendMaps", thePlayer, ClientMaps)
			triggerClientEvent(thePlayer, "onOpenLobbyBrowser", thePlayer)
	end)


    self:generateRandomPeds()

    self.m_updateTimer  = setTimer(function() self:generateRandomPeds() end, 60*60*1000, 0);
-- Events --

--logger:OutputInfo("[CALLING] AussichtsPunkt: Constructor");
end

-- EVENT HANDLER --



--HungerGames
