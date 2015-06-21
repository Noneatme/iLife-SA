--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Inventories = {}

CInventory = {}

function CInventory:constructor(iID, iType, JSONCategories, JSONItems, iSlots, iMaxGewicht)
    self.ID 			= iID
    self.iType 			= iType
    self.Categories 	= fromJSON(JSONCategories)
    self.Items 			= fromJSON(JSONItems)
    self.Slots 			= iSlots
    self.iMaxGewicht    = (tonumber(iMaxGewicht) or 100000)
	self.iGewicht		= 0

    Inventories[self.ID] = self
end

function CInventory:destructor()

end

function CInventory:setMaxGewicht(iGewicht)
    self.iMaxGewicht    = iGewicht;
end

function CInventory:generateNewInventory()      -- Public Static
    CDatabase:getInstance():query("INSERT INTO  inventory (`ID` ,`Type` ,`Categories` ,`Items` ,`Slots`)VALUES (NULL ,  '1',  ' [ { \"7\": true, \"1\": true, \"2\": true, \"4\": true, \"8\": true, \"9\":  true, \"5\": true, \"3\": true, \"6\": true } ]',  '[ {\"17\": 2 } ]',  '250');")
    local val 		= CDatabase:getInstance():query("SELECT * FROM inventory WHERE ID = (SELECT LAST_INSERT_ID() FROM inventory LIMIT 1)")
    local value 	= val[1]
    local iInventoryID	= tonumber(value["ID"]);
    local Inventory 	= new(CInventory, value["ID"], value["Type"], value["Categories"], value["Items"], value["Slots"])

    return iInventoryID, Inventory
end

function CInventory:refreshGewicht()
    if(Items) and (self.Items) then
        self.iGewicht   = 0;

        for id, count in pairs(self.Items) do
            id          = tonumber(id);
            count       = tonumber(count);

            if(count) and (count > 0) then
                if(Items[id]) then
                    local curWeight     = Items[id].Gewicht
                    if(curWeight) then
                        curWeight = curWeight*tonumber(count)
                    end

                    self.iGewicht = self.iGewicht + (curWeight or 0)
                end
            end
        end
    end
    return self.iGewicht;
end

function CInventory:addItem(Item, count, ovr, bCheckWeight)
	count = tonumber(count)
    if (self:hasItem(Item, 1)) then
		if not (ovr) then
			if not(self:canItemBeAdded(Item, count, bCheckWeight)) then
				self:addItem(Item, count-1 , ovr)
                return false;
			end
		end
        self.Items[tostring(Item:getID())] = self.Items[tostring(Item:getID())]+count
        self:save()
		return true;
    else
        self.Items[tostring(Item:getID())] = count
        self:save()
		return true;
    end
    if (self:hasItem(Item, count)) then
        return true
    end
    self:save()
    return false
end

function CInventory:canItemBeAdded(Item, count, bCheckWeight)
    --[[
	if (self:hasItem(Item, Item:getStacksize()- (count-1))) then
		return false
	end]]
    if(bCheckWeight) then
        self:refreshGewicht();
        if(self.iGewicht+(Item:getGewicht()*count) > self.iMaxGewicht) then
            return false;
        end
    end
	return true;
end

function CInventory:addItems(tblItems)
	for k,v in ipairs(tblItems) do
		self:addItem(v["Item"], v["Count"])
	end
end

function CInventory:getID()
    return self.ID
end

function CInventory:hasItemFullStackWith(Item, count)
	if (self:hasItem(Item, Item:getStacksize()- (count-1))) then
		return true;
	end
	return false;
end


function CInventory:removeItem(Item, count)
	count = tonumber(count)
    if (self:hasItem(Item, count)) then
        self.Items[tostring(Item:getID())] = self.Items[tostring(Item:getID())]-count
        if (self.Items[tostring(Item:getID())] < 1) then
            self.Items[tostring(Item:getID())] = nil
        end
        self:save()
        return true
    end
    self:save()
    return false
end

function CInventory:removeItems(tblItems)
	for k,v in ipairs(tblItems) do
		self:removeItem(v["Item"], v["Count"])
	end
end

function CInventory:hasItem(Item, count)
	count = tonumber(count)
    if(Item) and (count) then
        if (self.Items[tostring(Item:getID())]) then
            if (self.Items[tostring(Item:getID())] >= count) then
                return true
            end
        end
    end
    return false
end

-- Checks the inventoy contains the given Items.
-- Table should look like {{["Item"]= Item, ["Count"] = Integer},...}
function CInventory:hasItems(tblItems)
	for k,v in ipairs(tblItems) do
		if not(self:hasItem(v["Item"], v["Count"])) then
			return false
		end
	end
	return true
end

function CInventory:getCount(Item)
	if (self.Items[tostring(Item:getID())]) then
		return self.Items[tostring(Item:getID())]
	else
		return 0
	end
end

function CInventory:getIllegalItems()
	local illegalItems = {}
	for k,v in pairs(self.Items) do
		if (Items[tonumber(k)].Illegal) then
			illegalItems[tostring(k)] = true
		end
	end
	return illegalItems
end

function CInventory:removeIllegalItems(bIntoKammer)
	for k,v in pairs(self.Items) do
		if (Items[tonumber(k)].Illegal) then
			self:removeItem(Items[tonumber(k)], v)

         if(bIntoKammer) then
            if(cAsservatenkammer:getInstance()) then
               cAsservatenkammer:getInstance():addItem(Items[tonumber(k)], v)
            end
         end
		end
	end
end

function CInventory:save()
    self:refreshGewicht();
    CDatabase:getInstance():query("UPDATE inventory SET Items=?, Slots=? WHERE ID=?", toJSON(self.Items), self.Slots, self.ID)
end
