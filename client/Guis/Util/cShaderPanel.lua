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
-- ## Name: ShaderPanel.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

ShaderPanel = {};
ShaderPanel.__index = ShaderPanel;

--[[
	GUIEditor = {
	    gridlist = {},
	    button = {},
	    label = {},
	    window = {},
	}
	GUIEditor.window[1] = guiCreateWindow(451, 350, 537, 304, "Shaders", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	
	GUIEditor.label[1] = guiCreateLabel(10, 25, 207, 17, "Hier kannst du Shaders aktivieren.", false, GUIEditor.window[1])
	GUIEditor.gridlist[1] = guiCreateGridList(10, 54, 182, 244, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[1], "Shader", 0.9)
	GUIEditor.gridlist[3] = guiCreateGridList(349, 53, 182, 244, false, GUIEditor.window[1])
	guiGridListAddColumn(GUIEditor.gridlist[3], "Shader", 0.9)
	GUIEditor.button[1] = guiCreateButton(199, 104, 140, 31, "->", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFAAAAAA")
	GUIEditor.button[2] = guiCreateButton(199, 149, 140, 31, "<-", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFAAAAAA")
	GUIEditor.label[2] = guiCreateLabel(352, 25, 175, 24, "Aktiviert:", false, GUIEditor.window[1])
	GUIEditor.button[4] = guiCreateButton(199, 263, 140, 31, "Schliessen", false, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[4], "NormalTextColour", "FFAAAAAA")
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function ShaderPanel:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RefreshPanel		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ShaderPanel:Constructor(...)
	-- Klassenvariablen --
	
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] ShaderPanel: Constructor");
end

-- EVENT HANDLER --
