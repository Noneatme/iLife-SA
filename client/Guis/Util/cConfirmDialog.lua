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
-- ## Name: ConfirmDialog.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

ConfirmDialog = inherit(cSingleton)


--[[

]]

-- ///////////////////////////////
-- ///// SetClickFunc 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ConfirmDialog:setClickFunc(sAnswer, func)
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

function ConfirmDialog:hideConfirmDialog()
	if(self.guiEle["window"]) then
		self.guiEle["window"]:hide();
		delete(self.guiEle["window"])
		self.guiEle["window"] = false;
	end

	if(self.bShowCursor) then
		showCursor(true);
		clientBusy = true;
	end

	self.showing	= false;
end


-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function ConfirmDialog:showConfirmDialog(sText, yesFunc, noFunc, bShowCursor, bEdit, bShowCursorAfterNo)
	if not(self.guiEle["window"]) then

        local text = sText or "-"

        local len = string.len(text)
        local size = 1.25
        local curY = 137+(len)

		if(bEdit) then
			curY = curY+29
		end

		self.guiEle["window"] 	= new(CDxWindow, "Information", 336, 135-((167-curY)/2), true, false, "Center|Middle")
		self.guiEle["button1"]	= new(CDxButton, "Ja", 9, 79-((167-curY)/2), 139, 29, tocolor(255,255,255,255), self.guiEle["window"])
		self.guiEle["button2"]	= new(CDxButton, "Nein", 187, 79-((167-curY)/2), 139, 29, tocolor(255,255,255,255), self.guiEle["window"])

		if(bEdit) then
			self.guiEle["edit"]	= new(CDxEdit, "", 9, 41-((167-curY)/2), 311, 29, "Normal", tocolor(255,255,255,255), self.guiEle["window"])

			self.guiEle["label"]	= new(CDxLabel, text, 10, 0, 318, 60-((167-curY)/2), tocolor(255,255,255,255), size, "default-bold", "center", "center", self.guiEle["window"], true)
			self.guiEle["window"]:add(self.guiEle["edit"]);


			self.guiEle["button1"]:setText("OK")
			self.guiEle["button2"]:setText("Abbrechen")
		else
			self.guiEle["label"]	= new(CDxLabel, text, 10, 0, 318, 93-((167-curY)/2), tocolor(255,255,255,255), size, "default-bold", "center", "center", self.guiEle["window"])

		end

		self.guiEle["window"]:add(self.guiEle["label"]);
		self.guiEle["window"]:add(self.guiEle["button1"]);
		self.guiEle["window"]:add(self.guiEle["button2"]);


		if(yesFunc) then
			self:setClickFunc("yes", yesFunc)
		end

		if(noFunc) then
			self:setClickFunc("no", noFunc)
		else
			self:setClickFunc("no", self.hideFunc)
		end

		self.guiEle["button1"]:addClickFunction(self.clickFunc.yes);
		self.guiEle["button2"]:addClickFunction(self.clickFunc.no);
        if(bShowCursorAfterNo) then
            self.guiEle["button2"]:addClickFunction(function() setTimer(showCursor, 100, 1, true) end)
        end
		self.guiEle["button1"]:addClickFunction(self.hideFunc);
		self.guiEle["button2"]:addClickFunction(self.hideFunc);

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

function ConfirmDialog:constructor(...)
	-- Klassenvariablen --
	self.guiEle		= {}

	-- Methoden --

	self.hideFunc		= function() self:hideConfirmDialog() end;

	self.clickFunc 		= {}
	self.clickFunc.yes	= function() end;
	self.clickFunc.no	= function() end;

	self.showing		= false;

	-- Events --

	--logger:OutputInfo("[CALLING] ConfirmDialog: Constructor");
end

-- EVENT HANDLER --
