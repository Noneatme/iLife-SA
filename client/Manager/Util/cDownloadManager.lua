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
dxDrawRectangle(1175, 5, 255, 70, tocolor(0, 0, 0, 139), true)
dxDrawText("E:\Google Drive\MTA 1.3 Server\server", 1180, 8, 1422, 25, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", false, false, true, false, false)
dxDrawRectangle(1180, 35, 245, 37, tocolor(0, 0, 0, 139), true)
dxDrawRectangle(1180, 28, 245, 37, tocolor(49, 233, 0, 139), true)
dxDrawText("0 KB / 25000 KB", 1180, 35, 1422, 52, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", false, false, true, false, false)
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
-- ///// RequestFiles 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:RequestFiles()
	triggerServerEvent("onDownloadManagerRequestFiles", localPlayer)
end

-- ///////////////////////////////
-- ///// RequestSucess 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:RequestSucess(tblDownload, tblSize, tblDontDownload)
	local needToDownload = {};
	for index, key in pairs(tblDownload) do
		if not(fileExists(key)) then
			if not(tblDontDownload[key]) then
				needToDownload[index] = key;
			end
		else
			local file = fileOpen(key)
			if(file) then
				if(fileGetSize(file) ~= tblSize[key]) then
					outputConsole(fileGetSize(file)..", "..tblSize[key])
					needToDownload[index] = key;
				end
				fileClose(file);
			else
				needToDownload[index] = key;
			end
		end
	end
	outputConsole("[DMNG] Checking Download...");
	outputConsole("[DMNG] "..table.length(needToDownload).." Files needed.")
	
	self.maxFile = table.length(needToDownload);

	if(table.length(needToDownload) < 1) then
		self:FinnishDownload();
	else
		self.downloading = true;
	end
	triggerServerEvent("onDownloadManagerRequestDownload", localPlayer, needToDownload)
end

-- ///////////////////////////////
-- ///// FinnishDownload	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:FinnishDownload()
	outputConsole("[DMNG] Download Finished, Total : "..math.round((self.totalByteDownload/1000)/1024, 2).." MB");
	self.downloading 			= false;
	self.currentByteDownload 	= 0;
	self.totalByteDownload 		= 0;
	if not(self.m_bTriggered) then
		self.m_bTriggered = true;
		triggerEvent("onClientDownloadFinnished", getLocalPlayer())
	end
end

-- ///////////////////////////////
-- ///// DownloadThis 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:DownloadThis(path, data, current, last)
	if(data ~= "false") then

		self.downloading = true;
		if(fileExists(path)) then
			fileDelete(path)
		end
		local file = fileCreate(path);
		fileWrite(file, data);
		fileFlush(file);
		fileClose(file);
		self.currentByteDownload = self.currentByteDownload-string.len(data);

		--	outputConsole("Downloaded: "..path..", Total: "..math.round(string.len(data)/1024, 2).." KB, Remaining: "..math.round(self.currentByteDownload/1024, 2).." KB");
		self.currentPath = "Downloade...";

		if(current == last) then
			self:FinnishDownload()
		else
			if(current == 2) and (last == 1) then
				self.downloading = false;
			end
		end
		
		self.currentFile = self.currentFile+1;


		triggerEvent("onClientFileDownloadFinnished", getLocalPlayer(), path, current, last)

	else
		outputConsole("Download Error: File "..path.." not found");
	end
end

-- ///////////////////////////////
-- ///// GetTotalBytes 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:GetTotalBytes(bytes)
	self.totalByteDownload = (bytes or 0);
	self.currentByteDownload = self.totalByteDownload;
end

-- ///////////////////////////////
-- ///// addTotalBytes 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:addTotalBytes(bytes)
	self.totalByteDownload = self.totalByteDownload+bytes
end

-- ///////////////////////////////
-- ///// Render		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:Render()
	if(self.downloading == true) then
		local sx, sy = guiGetScreenSize()
		local aesx, aesy = 1440, 900;
		dxDrawRectangle(sx-(aesx-1177), 12, 249, 17, tocolor(255, 255, 255, 255), true)
		dxDrawRectangle(sx-(aesx-1177), 72, 249, 17, tocolor(255, 255, 255, 255), true)
		
		dxDrawRectangle(sx-(aesx-1170), 5, 260, 90, tocolor(0, 0, 0, 139), true)
		
		dxDrawText(self.currentPath, sx-(aesx-1180), 12, sx-(aesx-1422), 25, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", false, false, true, false, false)

		local width = -245/self.totalByteDownload*self.currentByteDownload
		if not(width) or (type(width) ~= "number") then width = 0 end;

		if(type(sx-(aesx-1180)) == "number") and (type(width) == "number" and width < 9999)  then
			dxDrawRectangle(sx-(aesx-1180), 35, 245+width, 37, tocolor(0, 0, 0, 139), true)
			dxDrawRectangle(sx-(aesx-1177), 32, 245+width-3, 34, tocolor(49, 233, 0, 139), true)
		end
		--
		dxDrawText(math.round(((self.totalByteDownload-self.currentByteDownload)/1000)/1024, 2).." MB / "..math.round((self.totalByteDownload/1000)/1024, 2).." MB", sx-(aesx-1180), 35, sx-(aesx-1422), 52, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", false, false, true, false, false)
		
		dxDrawText(self.currentFile.." / "..self.maxFile.." Dateien", sx-(aesx-1180), 72, sx-(aesx-1422), 75, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", false, false, true, false, false)

	end
end

-- ///////////////////////////////
-- ///// startCustomDownload//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:addDownloadFile(sPath)
	triggerServerEvent("onDownloadManagerRequestDownloadFile", localPlayer, sPath)

	if not(self.downloading) then
		self.downloading = true;
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function DownloadManager:Constructor(...)
	-- Klassenvariablen --
	self.totalByteDownload		= 0;
	self.currentByteDownload	= 0;
	self.downloading 			= false;
	self.currentPath			= "Warten...";
	self.currentFile			= 0;
	self.maxFile				= 0;

	self.m_tblCustomDownloadTBL	= {}

	self.m_tblPlayerMaxDownload	= {}

	-- Methoden --
	addEvent("onDownloadManagerRequestFileSucess", true);
	addEvent("onDownloadManagerStartDownload", true);
	addEvent("onDownloadManagerGetTotalBytes", true);
	addEvent("onDownloadManagerFinnishDownload", true);
	addEvent("onDownloadManagerTotalBytesAdd", true);

	self.requestSucessFunc	= function(...) self:RequestSucess(...) end;
	self.downloadStartFunc 	= function(...) self:DownloadThis(...) end;
	self.getTotalBytesFunc	= function(...) self:GetTotalBytes(...) end;
	self.finnishDownloadFunc= function(...) self:FinnishDownload(...) end;
	self.m_funcAddTotalBytes= function(...) self:addTotalBytes(...) end
	self.renderFunc			= function(...) self:Render(...) end;

	-- Events --
	addEventHandler("onDownloadManagerRequestFileSucess", getLocalPlayer(), self.requestSucessFunc);
	addEventHandler("onDownloadManagerStartDownload", getLocalPlayer(), self.downloadStartFunc);
	addEventHandler("onDownloadManagerGetTotalBytes", getLocalPlayer(), self.getTotalBytesFunc);
	addEventHandler("onDownloadManagerFinnishDownload", getLocalPlayer(), self.finnishDownloadFunc);
	addEventHandler("onDownloadManagerTotalBytesAdd", getLocalPlayer(), self.m_funcAddTotalBytes)
	addEventHandler("onClientRender", getRootElement(), self.renderFunc)

	self:RequestFiles();
	--logger:OutputInfo("[CALLING] DownloadManager: Constructor");

	function math.round(number, decimals, method)
		decimals = decimals or 0
		local factor = 10 ^ decimals
		if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
		else return tonumber(("%."..decimals.."f"):format(number)) end
	end
	function table.length(T)
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	end
end

-- EVENT HANDLER --
