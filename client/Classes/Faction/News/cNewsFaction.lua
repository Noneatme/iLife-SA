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
-- ## Name: NewsFaction.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

NewsFaction = {};
NewsFaction.__index = NewsFaction;

addEvent("onClientDownloadFinnished", true);
addEvent("onNewsfactionNewspaperOpen", true);
addEvent("onNewsfactionNewspaperCreate", true);
--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function NewsFaction:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// OpenNewspaper 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:OpenNewspaper(tblNewspaper)

		--iID, sType, sTitel, sAuthor, sText
		self.zeitung = NewsZeitungsGUI:New(tblNewspaper["NewspaperID"], "normal", tblNewspaper["Title"], tblNewspaper["Editor"], tblNewspaper["Content"]);

end

-- ///////////////////////////////
-- ///// BeginNewNewspaper	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:BeginNewNewspaper()

		--iID, sType, sTitel, sAuthor, sText
		self.zeitung = NewsZeitungsGUI:New(0, "new", "", "", "");

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function NewsFaction:Constructor(...)
	-- Klassenvariablen --

	self.Interior			= 5;
	self.Dimension			= 83;

	self.objects 			= {};
	self.objects.chefFrame	= createObject(2266, 983, -1042.0999511719, 177.60000610352, 0, 0, 180)
	self.objects.dingensMarker = createMarker(976.39184570313, -1076.1984863281, 176.95938110352, corona, 1.0, 0, 255, 255)
	
	self.zeitung			= false;
	self.openNewspaperFunc	= function(...) self:OpenNewspaper(...) end;
	self.beginNewspaperFunc	= function(...) self:BeginNewNewspaper(...) end;

	FrameTextur:New(self.objects.chefFrame, "cj_painting14", "logos/chef.jpg");

	setObjectScale(self.objects.chefFrame, 3);

	self.newsWeatherGui		= NewsWeatherGUI:New();

	for index, object in pairs(self.objects) do
		setElementDimension(object, self.Dimension);
		setElementInterior(object, self.Interior)
	end

	addEventHandler("onClientMarkerHit", self.objects.dingensMarker, function(uPlayer) if(uPlayer == localPlayer) then self.newsWeatherGui:Enable()  end end)
	addEventHandler("onClientMarkerLeave", self.objects.dingensMarker, function(uPlayer) if(uPlayer == localPlayer) then self.newsWeatherGui:Disable()  end end)

	-- Methoden --
	

	-- Events --
	
	addEventHandler("onNewsfactionNewspaperOpen", getLocalPlayer(), self.openNewspaperFunc)
	addEventHandler("onNewsfactionNewspaperCreate", getLocalPlayer(), self.beginNewspaperFunc)
	
	--logger:OutputInfo([CALLING] NewsFaction: Constructor);
end

-- EVENT HANDLER --
