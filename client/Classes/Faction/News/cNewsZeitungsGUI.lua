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
-- ## Name: NewsZeitungsGUI.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NewsZeitungsGUI = {};
NewsZeitungsGUI.__index = NewsZeitungsGUI;

--[[
GUIEditor = {
label = {},
scrollpane = {},
}
GUIEditor.label[3] = guiCreateLabel(112, 237, 1205, 578, "", false)


GUIEditor.scrollpane[1] = guiCreateScrollPane(110, 237, 1206, 579, false)

addEventHandler("onClientRender", root,
function()
dxDrawRectangle(83, 61, 1260, 771, tocolor(0, 0, 0, 95), false)
dxDrawText("", 111, 107, 1113, 208, tocolor(255, 255, 255, 255), 1, "default", "left", "top", false, false, true, false, false)
end
)
]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NewsZeitungsGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// SaveTextToDisk		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:SaveTextToDisk(sTitle, sText)
	local sFileTitle = getRealTime().monthday.."-"..(getRealTime().month+1).."-"..(getRealTime().year+1900).." "..sTitle..".txt";
	local pfad			= "savedfiles/zeitungen/"..sFileTitle;
	if not(fileExists(pfad)) then
		local file = fileCreate(pfad)
		
		fileWrite(file, sText);
		fileFlush(file);
		fileClose(file);
	end
end

-- ///////////////////////////////
-- ///// SaveText	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:SaveText()
	local sTitel	= guiGetText(self.guiEle.editTitle);
	local sText 	= guiGetText(self.guiEle.editMemo);

	if(#sTitel > 1) and (#sText > 1) then
			
		sText	= "Von "..getPlayerName(localPlayer).."\n\n"..sText;
		
		self:SaveTextToDisk(sTitel, sText)
		
		triggerServerEvent("onNewsfactionZeitungSchreib", localPlayer, sTitel, sText)
		self:Destructor();
	else
		showInfoBox("error", "Bitte gebe einen Titel und einen Text ein!");
	end
end

-- ///////////////////////////////
-- ///// CreateGUI	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:CreateGUI()
	self.guiEle.scrollPane		= guiCreateScrollPane(110/self.aesx*self.sx, 237/self.aesy*self.sy, 1206/self.aesx*self.sx, 579/self.aesy*self.sy, false);

	self.guiEle.label			= guiCreateLabel(0, 0, self.sy*2, self.sy*2, self.sText, false, self.guiEle.scrollPane);
	guiLabelSetColor(self.guiEle.label, 0, 0, 0)
	guiSetFont(self.guiEle.label, self.inhaltFont);

	guiScrollPaneSetScrollBars(self.guiEle.scrollPane, true, true)

	-- Buttons --
	self.guiEle.close			= guiCreateButton(91/self.aesx*self.sx, 65/self.aesy*self.sy, 172/self.aesx*self.sx, 32/self.aesy*self.sy, "", false);

	if(self.sType == "new") then
		self.guiEle.editMemo	= guiCreateMemo(107/self.aesx*self.sx, 234/self.aesy*self.sy, 1217/self.aesx*self.sx, 581/self.aesy*self.sy, "", false);
		self.guiEle.editTitle	= guiCreateEdit(108/self.aesx*self.sx, 125/self.aesy*self.sy, 976/self.aesx*self.sx, 62/self.aesy*self.sy, "", false);

		self.guiEle.save		= guiCreateButton((172+91+10)/self.aesx*self.sx, 65/self.aesy*self.sy, 172/self.aesx*self.sx, 32/self.aesy*self.sy, "", false);


		guiSetFont(self.guiEle.editTitle, self.inhaltFont2)
		guiSetFont(self.guiEle.editMemo, self.inhaltFont);


		addEventHandler("onClientGUIClick", self.guiEle.save, function()
			self:SaveText()
		end, false)
	else
	
		self:SaveTextToDisk(self.sTitel, self.sText)
	end

	for index, ele in pairs(self.guiEle) do
		if(getElementType(ele) == "gui-button") then
			guiSetAlpha(ele, 0)
			addEventHandler("onClientMouseEnter", ele, function()
				self.hover[index] = true;
			end)
			addEventHandler("onClientMouseLeave", ele, function()
				self.hover[index] = false;
			end)
		end
	end


	addEventHandler("onClientGUIClick", self.guiEle.close, function()
		if(isElement(self.guiEle.editMemo)) then
			local sTitel	= guiGetText(self.guiEle.editTitle);
			local sText 	= guiGetText(self.guiEle.editMemo);

			if(#sTitel < 2) and (#sText < 2) then
				self:Destructor()
			end
		else
			self:Destructor()
		end
	end, false)

end

-- ///////////////////////////////
-- ///// DestroyGui	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:DestroyGui()
	for index, ele in pairs(self.guiEle) do
		destroyElement(ele);
	end
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:Render()
	if(self.enabled) then
		dxDrawImage(83/self.aesx*self.sx, 61/self.aesy*self.sy, 1260/self.aesx*self.sx, 771/self.aesy*self.sy, self.pfade.images.."zeitung.jpg", 0, 0, 0, tocolor(255, 255, 255, 225), false)
		dxDrawRectangle(83/self.aesx*self.sx+20, 61/self.aesy*self.sy+10, 1260/self.aesx*self.sx, 771/self.aesy*self.sy, tocolor(255, 255, 255, 55), false)

		dxDrawText(self.sTitel, 111/self.aesx*self.sx, 107/self.aesy*self.sy, 1113/self.aesx*self.sx, 208/self.aesy*self.sy, tocolor(0, 0, 0, 255), 1, self.titelFont, "left", "center", false, false, true, false, false)

		local color = tocolor(0, 0, 0, 111)
		if(self.hover["close"] == true) then
			color = tocolor(0, 0, 0, 200)
		end
		dxDrawRectangle(91/self.aesx*self.sx, 65/self.aesy*self.sy, 172/self.aesx*self.sx, 32/self.aesy*self.sy, color, true)
		dxDrawText("Schliessen", 93/self.aesx*self.sx, 66/self.aesy*self.sy, 262/self.aesx*self.sx, 97/self.aesy*self.sy, tocolor(255, 255, 255, 255), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "default-bold", "center", "center", false, false, true, false, false)


		if(self.sType == "new") then
			-- (172+91+10)
			color = tocolor(0, 0, 0, 111)
			if(self.hover["save"] == true) then
				color = tocolor(0, 0, 0, 200)
			end
			dxDrawRectangle((172+91+10)/self.aesx*self.sx, 65/self.aesy*self.sy, 172/self.aesx*self.sx, 32/self.aesy*self.sy, color, true)
			dxDrawText("Speichern", (172+91+10)/self.aesx*self.sx, 66/self.aesy*self.sy, (262+172+10)/self.aesx*self.sx, 97/self.aesy*self.sy, tocolor(255, 255, 255, 255), 1/(self.aesx+self.aesy)*(self.sx+self.sy), "default-bold", "center", "center", false, false, true, false, false)

		end
		showCursor(true)
	end
end

-- ///////////////////////////////
-- ///// Split		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:Split(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((str:gsub("(.-)r?n", helper)))
	return t
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:Constructor(iID, sType, sTitel, sAuthor, sText)
	-- Klassenvariablen --
	self.renderFunc			= function(...) self:Render() end;
	self.enabled			= true;

	self.pfade				= {};
	self.pfade.images		= "res/images/news/";

	self.guiEle				= {}
	self.hover				= {}

	self.iID				= iID;
	self.sType				= sType;
	self.sTitel				= sTitel;


	self.sAuthor			= sAuthor;
	self.sText				= sText;

	self.sx, self.sy		= guiGetScreenSize()
	self.aesx, self.aesy 	= 1440, 900;
	self.fontSize			= 16/(self.aesx+self.aesy)*(self.sx+self.sy)
	self.fontSize2			= 32/(self.aesx+self.aesy)*(self.sx+self.sy)

	self.titelFont			= dxCreateFont("res/fonts/anthracite.ttf", self.fontSize2);
	self.inhaltFont			= guiCreateFont("res/fonts/typewriter.ttf", self.fontSize);
	self.inhaltFont2		= guiCreateFont("res/fonts/anthracite.ttf", self.fontSize2);

	clientBusy				= true;

	self:CreateGUI();
	-- Methoden --

	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	-- Events --
	
	showChat(false)
	hud:Toggle(false);
	--logger:OutputInfo("[CALLING] NewsZeitungsGUI: Constructor");
end


-- ///////////////////////////////
-- ///// Destructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsZeitungsGUI:Destructor()
	removeEventHandler("onClientRender", getRootElement(), self.renderFunc)

	clientBusy				= false;
	self.enabled			= false;
	self:DestroyGui();

	showCursor(false)

	self					= nil;
	
	showChat(true)
	hud:Toggle(true);
end

-- EVENT HANDLER --
