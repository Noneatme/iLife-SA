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
-- ## Name: BankGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

BankGUI = {};
BankGUI.__index = BankGUI;

--[[
	Uebersicht:
	
	GUIEditor = {
	gridlist = {},
	button = {},
	checkbox = {},
	window = {},
	}
	GUIEditor.window[1] = guiCreateWindow(486, 241, 479, 419, "Bank", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	
	GUIEditor.gridlist[1] = guiCreateGridList(10, 27, 277, 383, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "KontoNR", 0.3)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Besitzer", 0.3)
	guiGridListAddColumn(GUIEditor.gridlist[1], "Zugriff", 0.3)
	GUIEditor.button[1] = guiCreateButton(294, 368, 175, 32, "Beenden", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[2] = guiCreateButton(295, 36, 175, 35, "Neues Konto eroeffnen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[3] = guiCreateButton(296, 81, 173, 35, "Konto bearbeiten", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[3], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[4] = guiCreateButton(296, 126, 173, 35, "Einzahlmenu", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[5] = guiCreateButton(297, 196, 172, 35, "Konto Loeschen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[5], "NormalTextColour", "FFAAAAAA")
	GUIEditor.checkbox[1] = guiCreateCheckBox(299, 167, 167, 22, "Bestaetigung", false, false, GUIEditor.window[1])
	
	
	Konto Eroeffnen:
	GUIEditor = 
	{
	    edit = {},
	    button = {},
	    label = {},
	    window = {},
	}
	GUIEditor.window[1] = guiCreateWindow(542, 290, 352, 264, "Konto eroeffnen", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	
	GUIEditor.label[1] = guiCreateLabel(10, 23, 335, 24, "Du hast 0 Konten von maximal 3.", false, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(10, 57, 335, 24, "Kontonummer:", false, GUIEditor.window[1])
	GUIEditor.button[1] = guiCreateButton(11, 222, 117, 33, "Zurueck", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[2] = guiCreateButton(225, 221, 117, 33, "Konto eroeffnen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
	GUIEditor.edit[1] = guiCreateEdit(10, 87, 60, 34, "", false, GUIEditor.window[1])
	GUIEditor.edit[2] = guiCreateEdit(97, 87, 60, 34, "", false, GUIEditor.window[1])
	GUIEditor.edit[3] = guiCreateEdit(186, 87, 118, 34, "", false, GUIEditor.window[1])
	GUIEditor.label[3] = guiCreateLabel(70, 86, 29, 35, "-", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[3], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[3], "center")
	GUIEditor.label[4] = guiCreateLabel(157, 87, 29, 35, "-", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[4], "center")
	GUIEditor.label[5] = guiCreateLabel(11, 128, 58, 28, "1 2", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[5], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[5], "center")
	GUIEditor.label[6] = guiCreateLabel(103, 131, 58, 28, "3 4", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[6], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[6], "center")
	GUIEditor.label[7] = guiCreateLabel(186, 131, 117, 32, "TESTKONTO", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[7], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[7], "center")
	GUIEditor.label[8] = guiCreateLabel(8, 163, 334, 48, "Bitte gebe eine Kombination in diesem Format ein!\nDiese Kombination repraesentiert deine Kontonummer.\nWenn du Fertig bist, klicke auf 'Konto eroeffnen'.", false, GUIEditor.window[1])


	GUIEditor = {
	    button = {},
	    edit = {},
	    window = {},
	    gridlist = {},
	    label = {},
	}
	GUIEditor.window[1] = guiCreateWindow(474, 340, 516, 327, "Konto Bearbeiten", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	
	GUIEditor.label[1] = guiCreateLabel(10, 30, 232, 21, "Kontonummer: 12-34-AAAAAAAA", false, GUIEditor.window[1])
	GUIEditor.gridlist[1] = guiCreateGridList(10, 121, 236, 197, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "Spieler", 0.9)
	GUIEditor.label[2] = guiCreateLabel(241, 30, 276, 81, "Hier kannst du Spieler zu deinem Konto\nhinzufuegen, die Rechte haben sollen. Spieler\ndie Rechte haben, koennen am \nBankautomaten von deinem Konto Geld ein \nund auszahlen.", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
	guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
	GUIEditor.button[2] = guiCreateButton(10, 68, 146, 35, "<- Zurueck", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
	GUIEditor.label[3] = guiCreateLabel(254, 123, 257, 23, "Name:", false, GUIEditor.window[1])
	GUIEditor.edit[1] = guiCreateEdit(252, 146, 255, 35, "", false, GUIEditor.window[1])
	GUIEditor.button[6] = guiCreateButton(254, 192, 255, 36, "Spieler hinzufuegen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[6], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[7] = guiCreateButton(254, 238, 255, 36, "Spieler entfernen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[7], "NormalTextColour", "FFAAAAAA")
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function BankGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function BankGUI:Constructor(...)
-- Klassenvariablen --


-- Methoden --


-- Events --

--logger:OutputInfo("[CALLING] BankGUI: Constructor");
end

-- EVENT HANDLER --
