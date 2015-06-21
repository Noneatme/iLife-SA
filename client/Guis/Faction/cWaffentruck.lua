--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

--
-- Created by IntelliJ IDEA.
-- User: Noneatme
-- Date: 23.12.2014
-- Time: 22:00
-- Project: MTA iLife
--
--[[
--
self = {
    button = {},
    window = {},
    label = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        self.window[1] = guiCreateWindow(599, 246, 406, 337, "Waffentruck", false)
        guiWindowSetSizable(self.window[1], false)

        self.label[1] = guiCreateLabel(11, 26, 382, 18, "Hey, brauchst du Waffengueter?", false, self.window[1])
        self.label[2] = guiCreateLabel(10, 75, 197, 20, "Anzahl Kisten zum Transportieren:", false, self.window[1])
        self.button[1] = guiCreateButton(10, 101, 159, 41, "Weniger", false, self.window[1])
        guiSetProperty(self.button[1], "NormalTextColour", "FFAAAAAA")
        self.button[2] = guiCreateButton(238, 101, 159, 41, "Mehr", false, self.window[1])
        guiSetProperty(self.button[2], "NormalTextColour", "FFAAAAAA")
        self.label[3] = guiCreateLabel(176, 102, 52, 40, "1", false, self.window[1])
        guiLabelSetHorizontalAlign(self.label[3], "center", false)
        guiLabelSetVerticalAlign(self.label[3], "center")
        self.label[4] = guiCreateLabel(10, 152, 197, 20, "Kosten pro Kiste:", false, self.window[1])
        self.label[5] = guiCreateLabel(10, 172, 197, 20, "Gesammtkosten:", false, self.window[1])
        self.label[6] = guiCreateLabel(10, 192, 197, 20, "Ware pro Kiste: ", false, self.window[1])
        self.label[7] = guiCreateLabel(11, 50, 382, 15, "Es kann momentan kein Waffentruck gestartet werden.", false, self.window[1])
        self.label[8] = guiCreateLabel(10, 225, 393, 49, "Bedenke:\nJe mehr Kisten du Transportierst desto schneller koennen Sie\nvom Laster fallen. Co-Leader koennen ausserdem Ueberladen.", false, self.window[1])
        self.button[3] = guiCreateButton(105, 288, 171, 39, "Waffentruck starten!", false, self.window[1])
        guiSetProperty(self.button[3], "NormalTextColour", "FFAAAAAA")
        self.label[9] = guiCreateLabel(8, 208, 388, 17, "_______________________________________________________________________", false, self.window[1])
        self.label[10] = guiCreateLabel(8, 58, 388, 17, "_______________________________________________________________________", false, self.window[1])
    end
)
 ]]

cWaffentruckGUI = {}


-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cWaffentruckGUI:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Hide          		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckGUI:hideWND()
	self.GUI.window[1]:hide();

	clientBusy = false;
end

-- ///////////////////////////////
-- ///// UpdateWindow  		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckGUI:updateWindow(iMore, iLess)

	self.m_iCurrentKisten = self.m_iCurrentKisten+iMore;
	self.m_iCurrentKisten = self.m_iCurrentKisten-iLess;

	if(self.m_iCurrentKisten < 1) then
		self.m_iCurrentKisten = 1;
	end
	if(self.m_iCurrentKisten > self.m_iMaxKisten) then
		self.m_iCurrentKisten = self.m_iMaxKisten;
	end
	self.GUI.label[2]:setText("Anzahl Kisten zum Transportieren: (Maximal: "..self.m_iMaxKisten..")")
	self.GUI.label[3]:setText(self.m_iCurrentKisten);
	self.GUI.label[4]:setText("Kosten pro Kiste: $"..self.m_iPPK);
	self.GUI.label[5]:setText("Gesammtkosten: $"..(self.m_iPPK*self.m_iCurrentKisten));
	self.GUI.label[6]:setText("Ware pro Kiste: "..self.m_iWPK.." (Gesammt: "..self.m_iWPK*self.m_iCurrentKisten..")");

	if not(self.m_bCanDo) then
		self.GUI.button[3]:setDisabled(true);
		self.GUI.window[1].Height = 110;

		self.GUI.label[7]:setText("Momentan kann kein Waffentruck beladen werden.");

		for index, dx in pairs(self.GUI) do
			for _, d2 in pairs(dx) do
				d2:setVisible(false);
				d2:setDisabled(true);
			end
		end

		self.GUI.window[1]:setVisible(true);
		self.GUI.label[1]:setVisible(true);
		self.GUI.label[7]:setVisible(true);

	else
		self.GUI.button[3]:setDisabled(false);
		self.GUI.window[1].Height = 365;

		for index, dx in pairs(self.GUI) do
			for _, d2 in pairs(dx) do
				d2:setVisible(true);
				d2:setDisabled(false);
			end
		end

		self.GUI.label[7]:setText("Waehle die anzahl der Kisten und los gehts!");
	end
end

-- ///////////////////////////////
-- ///// Show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckGUI:showWND(bCanDo, iMaxKisten, iKistenPreis, iWareProKiste, iStartPos)
	if(self.GUI.window[1]) then
		self.GUI.window[1]:show(iMaxKisten, iKistenPreis, iWareProKiste, iStartPos);
		clientBusy = true;
	else
		self.GUI.window[1]      = new(CDxWindow, "Waffentruck", 406, 365, true, true, "Center|Middle")

		self.GUI.label[1]       = new(CDxLabel, "Hey, brauchst du Waffengueter?", 11, 26, 382, 18, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[2]       = new(CDxLabel, "Anzahl Kisten zum Transportieren: (Maximal: "..iMaxKisten..")", 10, 75, 382, 20, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])

		self.GUI.button[1]      = new(CDxButton, "Weniger", 10, 101, 159, 41, tocolor(255,255,255,255), self.GUI.window[1])
		self.GUI.button[2]      = new(CDxButton, "Mehr", 238, 101, 159, 41, tocolor(255,255,255,255), self.GUI.window[1])

		self.GUI.label[3]       = new(CDxLabel, "1", 176, 102, 52, 40, tocolor(255,255,255,255), 1, "default-bold", "center", "center", self.GUI.window[1])
		self.GUI.label[4]       = new(CDxLabel, "Kosten pro Kiste: $"..iKistenPreis, 10, 152, 197, 20, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[5]       = new(CDxLabel, "Gesammtkosten: $"..iKistenPreis, 10, 172, 197, 20, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[6]       = new(CDxLabel, "Ware pro Kiste: "..iWareProKiste, 10, 192, 382, 20, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[7]       = new(CDxLabel, "Waehle die anzahl der Kisten und los gehts!", 11, 50, 382, 15, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[8]       = new(CDxLabel, "Bedenke:\nJe mehr Kisten du Transportierst desto schneller koennen Sie\nvom Laster fallen. Co-Leader koennen ausserdem Ueberladen.", 10, 225, 393, 49, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])

		self.GUI.button[3]      = new(CDxButton, "Waffentruck Starten", 105, 288, 171, 39, tocolor(255,255,255,255), self.GUI.window[1])

		self.GUI.label[9]       = new(CDxLabel, "_______________________________________________________________________", 8, 208, 388, 17, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])
		self.GUI.label[10]      = new(CDxLabel, "_______________________________________________________________________", 8, 58, 388, 17, tocolor(255,255,255,255), 1, "default-bold", "left", "top", self.GUI.window[1])


		self.GUI.window[1]:add(self.GUI.label[1])
		self.GUI.window[1]:add(self.GUI.label[2])
		self.GUI.window[1]:add(self.GUI.label[3])
		self.GUI.window[1]:add(self.GUI.label[4])
		self.GUI.window[1]:add(self.GUI.label[5])
		self.GUI.window[1]:add(self.GUI.label[6])
		self.GUI.window[1]:add(self.GUI.label[7])
		self.GUI.window[1]:add(self.GUI.label[8])
		self.GUI.window[1]:add(self.GUI.label[9])
		self.GUI.window[1]:add(self.GUI.label[10])

		self.GUI.window[1]:add(self.GUI.button[1])
		self.GUI.window[1]:add(self.GUI.button[2])
		self.GUI.window[1]:add(self.GUI.button[3])

		self.GUI.button[2]:addClickFunction(function()
			self:updateWindow(1, 0)
		end)

		self.GUI.button[1]:addClickFunction(function()
			self:updateWindow(0, 1)
		end)

		self.GUI.button[3]:addClickFunction(function()
			loadingSprite:setEnabled(true);
			triggerServerEvent("onWaffentruckStart", localPlayer, self.m_iCurrentKisten, iStartPos);
			self.GUI.button[3]:setDisabled(true);
		end)

		self.GUI.window[1]:show();
		clientBusy = true;
	end

	self.m_iMaxKisten   = iMaxKisten;
	self.m_iPPK         = iKistenPreis;
	self.m_iWPK         = iWareProKiste;
	self.m_bCanDo       = bCanDo;
	self:updateWindow(0, 0);
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cWaffentruckGUI:constructor(...)
	-- Klassenvariablen --
	self.GUI =
	{
		button = {},
		window = {},
		label = {}
	}

	self.m_iMaxKisten       = 0;
	self.m_iPPK             = 0;
	self.m_iWPK             = 0;
	self.m_iCurrentKisten   = 0;
	self.m_bCanDo           = false;
	
	-- Funktionen --
	self.func_openWND       = function(...) self:showWND(...) end
	self.func_closeWND      = function(...)
		self:hideWND();
		loadingSprite:setEnabled(false);

	end

	-- Events --
	addEvent("onClientWaffentruckGUIStart", true);
	addEvent("onWaffentruckGUIClose", true)

	addEventHandler("onClientWaffentruckGUIStart", getLocalPlayer(), self.func_openWND);
	addEventHandler("onWaffentruckGUIClose", getLocalPlayer(), self.func_closeWND);
end

-- EVENT HANDLER --



