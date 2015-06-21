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
-- Date: 27.12.2014
-- Time: 22:58
-- Project: MTA iLife
--

--[[
--
GUIEditor = {
    button = {},
    window = {},
    label = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        GUIEditor.window[1] = guiCreateWindow(610, 300, 434, 131, "Fraktionslager", false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.label[1] = guiCreateLabel(10, 24, 422, 39, "Hier kannst du das Fraktionsinventar benutzen.\nItems zu entfernen ist erst ab Rank 4 moeglich.", false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(9, 67, 190, 42, "Items lagern", false, GUIEditor.window[1])
        guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
        GUIEditor.button[2] = guiCreateButton(227, 67, 190, 42, "Items herausnehmen", false, GUIEditor.window[1])
        guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")    
    end
)

 ]]

cFactionInventoryGui = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cFactionInventoryGui:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// hide        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFactionInventoryGui:hide()
	if(self.GUI.window[1]) then
		self.GUI.window[1]:hide()
		clientBusy = false;
	end
end

-- ///////////////////////////////
-- ///// show        		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFactionInventoryGui:show()
	if(self.GUI.window[1]) then
		self.GUI.window[1]:show();
	else
		self.GUI.window[1]      = new(CDxWindow, "Fraktionsinventar", 434, 151, true, true, "Center|Middle")
		self.GUI.label[1]       = new(CDxLabel, "Hier kannst du das Fraktionsinventar benutzen.\nItems zu entfernen ist erst ab Rank 4 moeglich.", 10, 24, 422, 39, tocolor(255,255,255,255), 1, "default-bold", "left", "center", self.GUI.window[1])

		self.GUI.button[1]      = new(CDxButton, "Items lagern", 9, 67, 190, 42, tocolor(255,255,255,255), self.GUI.window[1])
		self.GUI.button[2]      = new(CDxButton, "Items herausnehmen", 227, 67, 190, 42, tocolor(255,255,255,255), self.GUI.window[1])


		self.GUI.button[1]:addClickFunction(function()
			loadingSprite:setEnabled(true);
			self:hide()
			triggerServerEvent("onPlayerFactionInventoryRequest", localPlayer, 1)
		end)
		self.GUI.button[2]:addClickFunction(function()
			loadingSprite:setEnabled(true);
			self:hide()
			triggerServerEvent("onPlayerFactionInventoryRequest", localPlayer, 2)
		end)
		self.GUI.window[1]:add(self.GUI.label[1])
		self.GUI.window[1]:add(self.GUI.button[1])
		self.GUI.window[1]:add(self.GUI.button[2])

		self.GUI.window[1]:show();

		clientBusy = true;
		showCursor(true);
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cFactionInventoryGui:constructor(...)
	-- Klassenvariablen --
	self.GUI = {
		button = {},
		window = {},
		label = {}
	}
	
	-- Funktionen --
	
	
	-- Events --
end

-- EVENT HANDLER --
