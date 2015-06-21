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
-- ## Name: StorageBoxGUI.lua			##
-- ## Author: ReWrite					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

StorageBoxGUI = {};
StorageBoxGUI.__index = StorageBoxGUI;

addEvent("onClientStorageBoxInfosRefresh", true)


function StorageBoxGUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

function StorageBoxGUI:RefreshDatas()
	self.guiEle.gridlist[1]:clearRows();

	for id, amount in pairs(self.tblList) do
		self.guiEle.gridlist[1]:addRow(Items[tonumber(id)].Name.."|"..amount);
	end
end

function StorageBoxGUI:CreateGUI()

	self.guiEle.window[1] 		= new(CDxWindow, "StorageBox", 448, 259, true, true, "Center|Middle")
	self.guiEle.gridlist[1] 	= new(CDxList, 10, 23, 276, 180, tocolor(125, 125, 125, 200), self.guiEle.window[1])

	self.guiEle.label[1] 		= new(CDxLabel, "Anzahl:", 297, 25, 136, 17, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", self.guiEle.window[1])

	self.guiEle.edit[1] 		= new(CDxEdit, "1", 296, 48, 141, 34, "Number", tocolor(0, 0, 0, 255), self.guiEle.window[1])

	self.guiEle.button[1] 		= new(CDxButton, "Item auslagern", 296, 90, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])
	self.guiEle.button[2] 		= new(CDxButton, "Items einlagern", 296, 169, 138, 34, tocolor(255, 255, 255, 255), self.guiEle.window[1])

	
	self.guiEle.gridlist[1]:addColumn("Name");
	self.guiEle.gridlist[1]:addColumn("Anzahl");

	self.guiEle.window[1]:add(self.guiEle.gridlist[1]);
	self.guiEle.window[1]:add(self.guiEle.label[1]);
	self.guiEle.window[1]:add(self.guiEle.edit[1]);
	self.guiEle.window[1]:add(self.guiEle.button[1]);
	self.guiEle.window[1]:add(self.guiEle.button[2]);

	self.guiEle.window[1]:hide();

	-- Item remove --
	self.guiEle.button[1]:addClickFunction(function()
		if (self.guiEle.gridlist[1]:getRowData(1) ~= "nil") then
			triggerServerEvent("onClientRemoveItemFromBox", localPlayer, self.uObject, ItemNames[self.guiEle.gridlist[1]:getRowData(1)], tonumber(self.guiEle.edit[1]:getText()))
		else
			showInfoBox("error", "Wähle ein Item aus!")
		end
	end)

	-- Item add --

	self.guiEle.button[2]:addClickFunction(
		function()
			--Einlagern
			self.guiEle.window[1]:hide();
			showStorageBoxInsertGui(self.uObject)
		end
	)
end

-- ///////////////////////////////
-- ///// Show		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function StorageBoxGUI:Show(uObject, tblList)

	self.guiEle.window[1]:show();

	self.uObject = uObject;
	self.tblList = tblList;

	self:RefreshDatas()

end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function StorageBoxGUI:Constructor()
	-- Klassenvariablen --
	self.guiEle = {
		edit = {},
		button = {},
		window = {},
		label = {},
		gridlist = {}
	}

	-- Methoden --
	self:CreateGUI()

	self.uObject	= false;
	self.tblList	= {}

	self.refreshInfosFunc = function(...) self:Show(...) end;
	-- Events --

	addEventHandler("onClientStorageBoxInfosRefresh", getLocalPlayer(), self.refreshInfosFunc)
end

-- EVENT HANDLER --






	--Insert
	
	StorageBoxInsert = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

local StorageBoxInsert_CurrentSelectedCategory = 1
function showStorageBoxInsertGui(uObject)
	if (not clientBusy) then
		hideStorageBoxInsertGui()
		
		StorageBoxInsert["Window"] = new(CDxWindow, "Item auswählen", 502, 427, true, true, "Center|Middle")
		
		
		StorageBoxInsert["Image"][1] = new(CDxImage, 184, 24, 30, 30, "/res/images/left.png",tocolor(255,255,255,255), StorageBoxInsert["Window"])
		StorageBoxInsert["Image"][2] = new(CDxImage, 467, 24, 30, 30, "/res/images/right.png",tocolor(255,255,255,255), StorageBoxInsert["Window"])

		StorageBoxInsert["Image"][3] = new(CDxImage, 60, 70, 64, 64, "/res/images/none.png",tocolor(255,255,255,255), StorageBoxInsert["Window"])

		StorageBoxInsert["Label"][1] = new(CDxLabel, ItemCategories[StorageBoxInsert_CurrentSelectedCategory]["Name"],202, 18, 285, 56, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", StorageBoxInsert["Window"])
		StorageBoxInsert["Label"][2] = new(CDxLabel, "", 9, 140, 175, 80, tocolor(255,255,255,255), 1, "clear", "center", "top", StorageBoxInsert["Window"])
		StorageBoxInsert["Label"][3] = new(CDxLabel, "Anzahl:", 9, 225, 175, 30, tocolor(255,255,255,255), 1, "default", "left", "top", StorageBoxInsert["Window"])
		StorageBoxInsert["List"][1] = new(CDxList, 196, 57, 293, 328, tocolor(125,125,125,200), StorageBoxInsert["Window"])
		
		StorageBoxInsert["Button"][1] = new(CDxButton, "Auswählen", 9, 342, 175, 42, tocolor(255,255,255,255), StorageBoxInsert["Window"])

		StorageBoxInsert["Edit"][1] = new(CDxEdit, "1", 9, 240, 175, 42, "Number", tocolor(0,0,0,255), StorageBoxInsert["Window"])  
		
		StorageBoxInsert["List"][1]:addColumn("Name")
		StorageBoxInsert["List"][1]:addColumn("Anzahl")
		
		for k,v in ipairs(Items) do
			if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == StorageBoxInsert_CurrentSelectedCategory) ) then
				StorageBoxInsert["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])     
			end
		end

		StorageBoxInsert["Button"][1]:addClickFunction(
			function ()
				if (StorageBoxInsert["List"][1]:getRowData(1) == "nil") then
					showInfoBox("error", "Du musst ein Item auswählen.")
					return false
				end
				if (tonumber(StorageBoxInsert["Edit"][1]:getText()) >= 1 ) then
						hideStorageBoxInsertGui()
						triggerServerEvent("onClientStoreItemInBox", localPlayer, uObject, ItemNames[StorageBoxInsert["List"][1]:getRowData(1)], tonumber(StorageBoxInsert["Edit"][1]:getText()))
				else
					showInfoBox("error", "Du musst eine Anzahl > 0 eingeben.")
				end
			end
		)
		
		StorageBoxInsert["List"][1]:addClickFunction(
			function()
				if (StorageBoxInsert["List"][1]:getRowData(1) ~= "nil") then
					local ItemID = ItemNames[StorageBoxInsert["List"][1]:getRowData(1)]		
					StorageBoxInsert["Label"][2]:setText(Items[ItemID]["Description"])
					if (fileExists("res/images/items/"..ItemID..".png")) then
						StorageBoxInsert["Image"][3]:setImage("res/images/items/"..ItemID..".png")  
					else
						StorageBoxInsert["Image"][3]:setImage("res/images/none.png")  
					end
				end
			end
		)

		StorageBoxInsert["Image"][1]:addClickFunction(
			function()
				if (StorageBoxInsert_CurrentSelectedCategory ~= 1) then
					StorageBoxInsert_CurrentSelectedCategory = StorageBoxInsert_CurrentSelectedCategory-1
				else
					StorageBoxInsert_CurrentSelectedCategory = #ItemCategories 
				end
				refreshStorageBoxInsert()
				if ((StorageBoxInsert["List"][1]:getRowCount() == 0) and (StorageBoxInsert_CurrentSelectedCategory ~= 0)) then
					StorageBoxInsert["Image"][1]:onClick("left", "down")
				end
			end
		)

		StorageBoxInsert["Image"][2]:addClickFunction(
			function()
				if (StorageBoxInsert_CurrentSelectedCategory ~= #ItemCategories) then
					StorageBoxInsert_CurrentSelectedCategory = StorageBoxInsert_CurrentSelectedCategory+1
				else
					StorageBoxInsert_CurrentSelectedCategory =  1
				end
				refreshStorageBoxInsert()
				if ((StorageBoxInsert["List"][1]:getRowCount() == 0) and (StorageBoxInsert_CurrentSelectedCategory ~= 0)) then
					StorageBoxInsert["Image"][2]:onClick("left", "down")
				end
			end
		)
		
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Image"][1])
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Image"][2])
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Image"][3])
			
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Label"][1])
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Label"][2])
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Label"][3])
			
		StorageBoxInsert["Window"]:add(StorageBoxInsert["List"][1])    
		   
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Button"][1])
			
		StorageBoxInsert["Window"]:add(StorageBoxInsert["Edit"][1])
			
		StorageBoxInsert["Window"]:show()
	end
end

function refreshStorageBoxInsert()
    if (StorageBoxInsert["Window"]) then
        StorageBoxInsert["List"][1]:clearRows()
        StorageBoxInsert["Label"][2]:setText("")
        StorageBoxInsert["Image"][3]:setImage("/res/images/none.png")  
        StorageBoxInsert["Label"][1]:setText(ItemCategories[StorageBoxInsert_CurrentSelectedCategory]["Name"])
        for k,v in ipairs(Items) do
            if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == StorageBoxInsert_CurrentSelectedCategory) ) then
                StorageBoxInsert["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])    
            end
        end
		
		if (StorageBoxInsertSelectedItem) then
			StorageBoxInsert["List"][1]:setSelectedRow(StorageBoxInsertSelectedItem)
			StorageBoxInsertSelectedItem = nil
			if (StorageBoxInsert["List"][1]:getRowData(1) ~= "nil") then
				local ItemID = ItemNames[StorageBoxInsert["List"][1]:getRowData(1)]		
				StorageBoxInsert["Label"][2]:setText(Items[ItemID]["Description"])
				if (fileExists("res/images/items/"..ItemID..".png")) then
					StorageBoxInsert["Image"][3]:setImage("res/images/items/"..ItemID..".png")  
				else
					StorageBoxInsert["Image"][3]:setImage("res/images/none.png")  
				end
			end
		end
	end
end



function hideStorageBoxInsertGui()
	if (StorageBoxInsert["Window"]) then
		StorageBoxInsert["Window"]:hide()
		delete(StorageBoxInsert["Window"])
		StorageBoxInsert["Window"] = nil
	end
end

