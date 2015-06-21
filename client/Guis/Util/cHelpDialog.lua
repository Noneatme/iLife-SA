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
-- ## Name: HelpDialog.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

HelpDialog = {};
HelpDialog.__index = HelpDialog;


--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function HelpDialog:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// SetClickFunc 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HelpDialog:setClickFunc(sAnswer, func)
	if(sAnswer == "yes") then
		self.clickFunc.yes	= func;
	elseif(sAnswer == "no") then
		self.clickFunc.no	= func;
	end
end	

-- ///////////////////////////////
-- ///// Hide		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HelpDialog:hideHelpDialog()
	if(self.guiEle["window"]) then
		self.guiEle["window"]:hide();
		delete(self.guiEle["window"])
		self.guiEle["window"] = false;

	
		if(self.bShowCursor) then
			showCursor(true);
			clientBusy = true;
		end

		self.showing	= false;
	end
end

function HelpDialog:hide()
	return self:hideHelpDialog()
end

function HelpDialog:show(...)
	return self:showHelpDialog(...)
end
-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HelpDialog:showHelpDialog(sText, bShowCursor)
	if not(self.guiEle["window"]) then
		
		self.guiEle["window"] 	= new(CDxWindow, "Hilfe", 336, 167, true, false, "Center|Middle", 0, 0, {tocolor(125, 125, 255, 255), false, "Hilfe"})
		self.guiEle["button1"]	= new(CDxButton, "OK", 9, 99, 139, 29, tocolor(255,255,255,255), self.guiEle["window"])

		self.guiEle["label"]	= new(CDxLabel, (sText or "-"), 10, 0, 318, 93, tocolor(255,255,255,255), 1.25, "default-bold", "center", "center", self.guiEle["window"])

		self.guiEle["window"]:add(self.guiEle["label"]);
		self.guiEle["window"]:add(self.guiEle["button1"]);

				

		self.guiEle["button1"]:addClickFunction(self.hideFunc);

		clientBusy = false;
		self.guiEle["window"]:show();

		self.bShowCursor = bShowCursor

		self.showing	= true;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function HelpDialog:Constructor(...)
	-- Klassenvariablen --
	self.guiEle		= {}
	
	-- Methoden --

	self.hideFunc		= function() self:hideHelpDialog() end;


	self.showing		= false;
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] HelpDialog: Constructor");
end

-- EVENT HANDLER --
