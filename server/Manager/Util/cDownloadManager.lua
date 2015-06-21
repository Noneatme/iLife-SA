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
-- ## Name: DownloadManager.lua			##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

DownloadManager = {};
DownloadManager.__index = DownloadManager;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function DownloadManager:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// OnRequestFiles		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:OnRequestFiles(player, ...)
	triggerClientEvent(player, "onDownloadManagerRequestFileSucess", player, self.downloadTable, self.sizeTable, self.dontDownloadTBL);
end

-- ///////////////////////////////
-- ///// LoadFiles			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:LoadFiles()
	local resourceName = getResourceName(getThisResource());
	local metaRoot = xmlLoadFile(":"..resourceName.."/meta.xml")
	local badfiles, nonfiles	= 0, 0;
	if(metaRoot) then
		for i, v in ipairs(xmlNodeGetChildren(metaRoot)) do
			if(xmlNodeGetName(v) == "customfile") then
				local path 		= xmlNodeGetAttribute(v,"src")
				local file 		= fileOpen(path);
				local download 	= xmlNodeGetAttribute(v,"download")

				if(download == "false") then
					self.dontDownloadTBL[path] = true;
					nonfiles = nonfiles+1
				end
				if(file) then
					table.insert(self.downloadTable, path)

					self.sizeTable[path] = fileGetSize(file);
					self.dataTable[path] = fileRead(file, fileGetSize(file));
	
					fileClose(file);
				else
					outputDebugString("WARNING: Bad File: "..path)
					badfiles = badfiles+1
				end
			end
		end
	end

	outputDebugString("[DOWNLOADMNRG] Found "..badfiles.." badfiles and "..nonfiles.." nonfiles")
end

-- ///////////////////////////////
-- ///// AddFile			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:AddFile(path)
    if(fileExists(path)) then
	    local file 		= fileOpen(path);
        if(file) and (fileGetSize(file) > 0) then
            table.insert(self.downloadTable , path)
            self.sizeTable[path] = fileGetSize(file);

            self.dataTable[path] = fileRead(file, fileGetSize(file));

            fileClose(file);
        else
            outputDebugString("WARNING: Bad File: "..path)
        end
    else
        outputDebugString("WARNING: Bad File: "..path)
    end
end


-- ///////////////////////////////
-- ///// RequestDownload	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:RequestDownload(player, tblDownload, bAddBytes)
	local bytes = 0;


	for index, path in pairs(tblDownload) do
		bytes = bytes+string.len((self.dataTable[path] or "false"))
	end
	if not(bAddBytes) then
		triggerClientEvent(player, "onDownloadManagerGetTotalBytes", player, bytes);
	else
		triggerClientEvent(player, "onDownloadManagerTotalBytesAdd", player, bytes);
	end
	local last = table.length(tblDownload)
	local current = 1;

	if(bAddBytes) then
		last = 1
		current = 0
	end
	
	for index, path in pairs(tblDownload) do
		triggerLatentClientEvent(player, "onDownloadManagerStartDownload", self.bytesPerSecond, false, player, path, (self.dataTable[path] or "false"), current, last)
		
		current = current+1;
	end

end

-- ///////////////////////////////
-- ///// onPlayerCustomBla	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:onPlayerCustomFileDownload(uPlayer, sPath)
--	sPath		= string.lower(sPath)
	if not(self.m_tblPlayerMaxDownload[uPlayer]) then
		self.m_tblPlayerMaxDownload[uPlayer] = {}
	end
	if(self.dontDownloadTBL[sPath] == true) and not(isTimer(self.m_tblPlayerMaxDownload[uPlayer][sPath])) then	-- Spaeterer Download!
		self:RequestDownload(uPlayer, {sPath}, true)
		outputDebugString("Player "..getPlayerName(uPlayer).." requested download of file: "..sPath..", granted")
		self.m_tblPlayerMaxDownload[uPlayer][sPath] = setTimer(function() end, 5000, 1)
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:Constructor(...)
	-- Klassenvariablen --
	self.downloadTable			= {}
	self.sizeTable				= {}
	self.dataTable				= {}
	self.dontDownloadTBL		= {}
	self.m_tblPlayerMaxDownload	= {}

	self.bytesPerSecond			= 2000000; -- Uebertragungsrate


	-- Methoden --
	addEvent("onDownloadManagerRequestFiles", true)
	addEvent("onDownloadManagerRequestDownload", true)
	addEvent("onDownloadManagerRequestDownloadFile", true)

	self.onRequestFilesFunc 	= function(...) self:OnRequestFiles(source, ...) end;
	self.requestDownloadFunc 	= function(...) self:RequestDownload(source, ...) end;
	self.m_funcOnCustomFileDownload = function(...) self:onPlayerCustomFileDownload(source, ...) end

	-- Events --
	self:LoadFiles();

	-- Handlers --
	addEventHandler("onDownloadManagerRequestDownload", getRootElement(), self.requestDownloadFunc)
	addEventHandler("onDownloadManagerRequestFiles", getRootElement(), self.onRequestFilesFunc)
	addEventHandler("onDownloadManagerRequestDownloadFile", getRootElement(), self.m_funcOnCustomFileDownload)
	--logger:OutputInfo("[CALLING] DownloadManager: Constructor");

	function table.length(T)
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	end
end


-- EVENT HANDLER --
