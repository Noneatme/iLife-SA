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
-- Date: 01.01.2015
-- Time: 13:18
-- Project: MTA iLife
--
cHallOfGames = {};

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function cHallOfGames:new(...)
	local obj = setmetatable({}, {__index = self});
	if obj.constructor then
		obj:constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// ImportAndReplace	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHallOfGames:importAndReplace()
	--3781 4605
	engineReplaceCOL(engineLoadCOL("res/models/office/LSOffice1.col"), 4587)
--	engineImportTXD(engineLoadTXD("res/models/office/LSOffice1.txd"),4587)
--	engineReplaceModel(engineLoadDFF("res/models/office/LSOffice1.dff", 0), 4587)

	engineReplaceCOL(engineLoadCOL("res/models/office/LSOffice1Floors.col"), 3781)
--	engineImportTXD(engineLoadTXD("res/models/office/LSOffice1Floors.txd"), 3781)
--	engineReplaceModel(engineLoadDFF("res/models/office/LSOffice1Floors.dff", 0), 3781)

	engineReplaceCOL(engineLoadCOL("res/models/office/LSOffice1Glass.col"), 4605)
	engineImportTXD(engineLoadTXD("res/models/office/LSOffice1.txd"), 4605)
	engineReplaceModel(engineLoadDFF("res/models/office/LSOffice1Glass.dff", 0), 4605)


	-- glass_office2


end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function cHallOfGames:constructor(...)
	-- Klassenvariablen --
	
	
	-- Funktionen --
	self:importAndReplace()
	
	-- Events --
end

-- EVENT HANDLER --

cHallOfGames:new()
