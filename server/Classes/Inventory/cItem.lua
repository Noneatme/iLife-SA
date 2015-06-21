--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

Items = {}

CItem = {}

addEvent("onItemPlaceFailure", true)

local lastItemID	= {}

local ItemTimer = {}

local innenKategorien	= {
	[11] = true,
	[12] = true,
	[13] = true,
	[14] = true,
	[15] = true,
	[16] = true,
	[17] = true,
	[18] = true,
}


addEvent("onClientRequestItems", true)
addEventHandler("onClientRequestItems", getRootElement(),
    function()
        triggerClientEvent(source, "onCLientItemsRecieve", source, toJSON(Items))
    end
)

addEventHandler("onItemPlaceFailure", getRootElement(), function(iItemID)
	if(lastItemID[client]) and (lastItemID[client] == iItemID) then
		lastItemID[client] = nil;
		client:getInventory():addItem(Items[iItemID], 1);
		client:showInfoBox("error", "Dieses Item kannst du hier nicht benutzen!");
	end
end)

function CItem:constructor(iID, sName, sDescription, iCategory, iStacksize, iUseable, iConsume, iTradeable, iDeleteable, iIllegal, bJSONTemplate, iCost, iGewicht)
    self.ID 				= iID
    self.Name 				= sName
    self.Description 		= sDescription
    self.Category			= ItemCategories[iCategory]
	self.iCategory			= iCategory;
    self.Stacksize 			= iStacksize
    self.Useable 			= transformNumberInBool(iUseable)
	self.Consume 			= transformNumberInBool(iConsume)
    self.Tradeable 			= transformNumberInBool(iTradeable)
    self.Deleteable 		= transformNumberInBool(iDeleteable)
	self.Illegal 			= transformNumberInBool(iIllegal)
	self.Gewicht			= tonumber(iGewicht) or 0

    if ( (bJSONTemplate) and  (bJSONTemplate ~= "")) then
       self.DataStorage = bJSONTemplate
    end

	self.Cost = iCost

	local pic = fileExists("res/images/items/"..tostring(self.ID)..".png")
	if (pic) then
		downloadManager:AddFile("res/images/items/"..tostring(self.ID)..".png")
	end

    Items[self.ID] = self
end

function CItem:destructor()

end

function CItem:getGewicht()
    return self.Gewicht or 0
end

function CItem:getID()
    return self.ID
end

function CItem:getName()
    return self.Name
end

function CItem:getStacksize()
   return self. Stacksize
end

function CItem:getCost()
	return self.Cost
end

function CItem:delete(thePlayer, Amount)
    if (self.Deleteable) then
        if (thePlayer:getInventory():hasItem(self, Amount)) then
            if (thePlayer:getInventory():removeItem(self, Amount)) then
                triggerClientEvent(thePlayer, "onClientInventoryRecieve", thePlayer ,toJSON(thePlayer:getInventory()))
            end
        else
            thePlayer:showInfoBox("error", "Es ist ein Fehler aufgetreten!")
        end
    else
        thePlayer:showInfoBox("error", "Dieses Item kannst du nicht wegwerfen!")
    end
	thePlayer:setLoading(false)
end

local callback_items	=
{
	[300]	= true,
	[301]	= true,
	[302]	= true,
	[303]	= true;
}

function CItem:use(thePlayer)
	thePlayer:setLoading(false);
    if (self.Useable) then
        if (thePlayer:getInventory():hasItem(self, 1)) then
			if (self.Consume) then
				if (thePlayer:getInventory():removeItem(self, 1)) then
					local sucess = useItem(self.ID, thePlayer)
					if(callback_items[self.ID]) then
						if not(sucess) then
							thePlayer:getInventory():addItem(self, 1)
						end
					end
				end
			else
				useItem(self.ID, thePlayer)
            end
			triggerClientEvent(thePlayer, "onClientInventoryRecieve", thePlayer ,toJSON(thePlayer:getInventory()))
        else
            thePlayer:showInfoBox("error", "Es ist ein Fehler bei der Benutzung aufgetreten!")
        end
    else
        thePlayer:showInfoBox("error", "Dieses Item kannst du so nicht benutzen!")
    end
end

function useItem(ItemID, thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	lastItemID[thePlayer] = ItemID;

	if not(ItemTimer[thePlayer]) then
		ItemTimer[thePlayer] = {}
	end
    if (ItemID == 3) then --Pizza
        thePlayer:eat(60)
        thePlayer:showInfoBox("info", "Du hast eine Pizza gegessen!")
        return true
    end
    if (ItemID == 4) then --Donut
        thePlayer:eat(15)
        thePlayer:showInfoBox("info", "Du hast einen Donut gegessen!")
        return true
    end
    if (ItemID == 5) then --Chicken Burger
        thePlayer:eat(25)
        thePlayer:showInfoBox("info", "Du hast einen Chicken Burger gegessen!")
        return true
    end
    if (ItemID == 6) then --Rubbellos
       local win = math.random(1, 10000)
       local wmoney = 0
       if (win < 2500) then
            if (win<800) then
               if (win< 180) then
                    if (win<20) then
						Achievements[64]:playerAchieved(thePlayer)
                        if (win == 1) then
                            wmoney = 60000
                        else
                            wmoney = 10000
                        end
                    else
                        wmoney = 1337
                    end
                else
                    wmoney = 50
                end
            else
                wmoney = 25
            end
        else
            thePlayer:showInfoBox("info", "Du hast nichts gewonnen!")
            return true
        end
        thePlayer:addMoney(wmoney)
        thePlayer:showInfoBox("info", "Du hast "..wmoney.." $ gewonnen!")
        return true
    end
    if (ItemID == 7) then --Kamera
        thePlayer:showInfoBox("info", "Du hast nun eine Kamera!")
        thePlayer:addWeapon(43, 36, true);
        thePlayer:getInventory():addItem(Items[ItemID], 1);
        return true
    end
    if (ItemID == 8) then --Film
        if(thePlayer:hasWeapon(43)) then
	        thePlayer:showInfoBox("info", "Du hast einen Film benutzt!")
	        thePlayer:addWeapon(43, 36, true);
		else
	        thePlayer:showInfoBox("error", "Du benoetigst eine Kamera um den Film zu benutzen!")
        end
        return true
    end
    if (ItemID == 9) then --Crystal Meth
        thePlayer:showInfoBox("info", "Du hast Meth genommen")
		Achievements[13]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "onClientStartDrugEffect", thePlayer, 9)
        return true
    end
    if (ItemID == 10) then --Cannabis
        thePlayer:showInfoBox("info", "Du hast Cannabis konsumiert!")
		Achievements[13]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "onClientStartDrugEffect", thePlayer, 10)
        return true
    end
    if (ItemID == 11) then --Magic Mushrooms
        thePlayer:showInfoBox("info", "Du hast einen Mushroom gegessen!")
		Achievements[13]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "onClientStartDrugEffect", thePlayer, 11)
        return true
    end
    if (ItemID == 12) then --Ecstasy
        thePlayer:showInfoBox("info", "Du hast Ecstasy genommen!")
		Achievements[13]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "onClientStartDrugEffect", thePlayer, 12)
        return true
    end
    if (ItemID == 13) then --Wundertüte
		local rand = math.random(1, 100000)
		if (rand < 50000) then
			thePlayer:showInfoBox("info", "Du hast eine Pfandflasche erhalten!")
			thePlayer:getInventory():addItem(Items[2],1)
			thePlayer:refreshInventory()
			return true
		end
		if (rand < 70000) then
			thePlayer:showInfoBox("info", "Du hast ein Rubbellos erhalten!")
			thePlayer:getInventory():addItem(Items[6],1)
			thePlayer:refreshInventory()
			return true
		end
		if (rand < 80000) then
			thePlayer:showInfoBox("info", "Du hast einen Donut bekommen!")
			thePlayer:getInventory():addItem(Items[4],1)
			thePlayer:refreshInventory()
			return true
		end

		thePlayer:showInfoBox("info", "Du hast Shrimps bekommen!")
		thePlayer:getInventory():addItem(Items[16],1)
		thePlayer:refreshInventory()
		return true

    end
    if (ItemID == 14) then --Kokain
        thePlayer:showInfoBox("info", "Du hast Kokain genommen!")
		Achievements[13]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "onClientStartDrugEffect", thePlayer, 14)
        return true
    end
    if (ItemID == 15) then --Sprunk
        thePlayer:eat(20)
        thePlayer:showInfoBox("info", "Du hast eine Flasche Sprunk getrunken!")
    return true
    end
    if (ItemID == 16) then --Shrimps
        thePlayer:eat(35)
		Achievements[77]:playerAchieved(thePlayer)
        thePlayer:showInfoBox("info", "Du hast Shrimps gegessen!")
    return true
    end
    if (ItemID == 17) then --Hamburger
        thePlayer:eat(20)
        thePlayer:showInfoBox("info", "Du hast einen Burger gegessen!")
        return true
    end
	if (ItemID == 18) then --Doominator
        thePlayer:showInfoBox("info", "Du hast einen Doominator in die Hand genommen.")
		thePlayer:addWeapon(12, 1, true)
        return true
    end
	if (ItemID == 19) then --Fahrlizenz A
		local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: A")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 20) then --Fahrlizenz B
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: B")
			end
		end
		Achievements[26]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 21) then --Fahrlizenz C
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: C")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 22) then --Fahrlizenz D
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: D")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 23) then --Fahrlizenz M
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: M")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 24) then --Fahrlizenz L
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: L")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 25) then --Fahrlizenz S
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Führerschein gezeigt. Klasse: S")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Führerschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 26) then --Waffenbesitzkarte
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir eine Waffenbesitzkarte gezeigt!")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deine Waffenbesitzkarte gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 27) then --Kleiner Waffenschein
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen kleinen Waffenschein gezeigt!")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Waffenschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 28) then --Erweiterter Waffenschwein
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen erweiteren Waffenschein gezeigt!")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Waffenschein gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 29) then --Personalausweis
        local x,y,z = getElementPosition(thePlayer)
		local Sphere = createColSphere(x,y,z, 4)
		for k,v in ipairs(getElementsWithinColShape(Sphere, "player")) do
			if (v ~= thePlayer) then
				v:showInfoBox("info", thePlayer:getName().." hat dir einen Personalausweis gezeigt!")
			end
		end
		thePlayer:showInfoBox("info", "Du hast deinen Personalausweis gezeigt!")
		destroyElement(Sphere)
        return true
    end
	if (ItemID == 30) then --TODO LSD
		Achievements[13]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "TODO: LSD")
        return true
    end
	if (ItemID == 31) then --Schokoriegel
        thePlayer:eat(10)
        thePlayer:showInfoBox("info", "Du hast einen Schokoriegel gegessen!")
        return true
    end
	if (ItemID == 32) then --Chips
        thePlayer:eat(15)
        thePlayer:showInfoBox("info", "Du hast Chips gegessen!")
        return true
    end
	if (ItemID == 33) then --Werbeantrag (1 Stunde)
		Achievements[61]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Werbeantrag ausfüllen!")
        triggerClientEvent(thePlayer, "onServerAdvertismentAccept", getRootElement(), 1)
        return true
    end
	if (ItemID == 34) then --Werbeantrag (2 Stunden)
		Achievements[61]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Werbeantrag ausfüllen!")
		triggerClientEvent(thePlayer, "onServerAdvertismentAccept", getRootElement(), 2)
        return true
    end
	if (ItemID == 35) then --Werbeantrag (5 Stunden)
		Achievements[61]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Werbeantrag ausfüllen!")
		triggerClientEvent(thePlayer, "onServerAdvertismentAccept", getRootElement(), 3)
        return true
    end
	if (ItemID == 36) then --Werbeantrag (1 Tag)
		Achievements[61]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Werbeantrag ausfüllen!")
		triggerClientEvent(thePlayer, "onServerAdvertismentAccept", getRootElement(), 4)
        return true
    end
	if (ItemID == 37) then --Werbeantrag (1 Woche)
		Achievements[61]:playerAchieved(thePlayer)
		thePlayer:showInfoBox("info", "Werbeantrag ausfüllen!")
		triggerClientEvent(thePlayer, "onServerAdvertismentAccept", getRootElement(), 5)
        return true
    end
	if (ItemID == 38) then --iRace-Kiste
		Achievements[44]:playerAchieved(thePlayer)
        thePlayer:showInfoBox("info", "Noch nicht implementiert!")
        return true
    end
	if (ItemID == 39) then -- Aioli
		thePlayer:eat(10)
        thePlayer:showInfoBox("info", "Du hast Aioli gegessen!")
        return true
    end
	if (ItemID == 40) then -- Doneasty
        thePlayer:showInfoBox("info", "Die Seiten kleben irgendwie zusammen?")
		Achievements[76]:playerAchieved(thePlayer)
		triggerClientEvent(thePlayer, "DoneastyBook", thePlayer)
        return true
    end

	local cat = Items[ItemID].iCategory;

	if(cat) and (cat == 10) or (cat == 19) then	 -- Baumarkt Items & Outside Items
		if(getElementInterior(thePlayer) ~= 0) and (ItemID ~= 259) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Das geht nur in der Aussenwelt!");
			return false;
		else
			local wat 			= true;

			local faction_ID	= 0;
			local using_faction = false;

			--[[if(thePlayer:IsInFactionRange()) then
				wat = false;
				if(thePlayer:IsInFactionRange() == thePlayer:getFaction():getID()) and (thePlayer:getRank() >= 3) then
					faction_ID = thePlayer:getFaction():getID();
					wat = true;
					using_faction = true;
				end
			else--]]

			if(cat == 19) then
				wat = true;
				using_faction = true;
				faction_ID = thePlayer:getFaction():getID();
			end
			--end

			if(wat == true) then
				if(using_faction == true) then
					CBaumarkt:BuyPlayerItem(thePlayer, ItemID, faction_ID);
				else
					CBaumarkt:BuyPlayerItem(thePlayer, ItemID);

				end
				thePlayer:showInfoBox("info", "Klicke auf das Objekt um es zu bewegen!");
			else
				thePlayer:getInventory():addItem(Items[ItemID], 1);
				thePlayer:showInfoBox("error", "Objekte dieses Types kannst du hier nicht platzieren!");
			end
			return true;
		end
	end

	if ((cat) and (innenKategorien[cat]) and (innenKategorien[cat] == true)) then	 -- Innenobjekte
		if(getElementInterior(thePlayer) == 0) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Das geht nur in einem Haus!");
			return false;
		else
			if(getElementDimension(thePlayer) > 10000) then
				CBaumarkt:BuyPlayerItem(thePlayer, ItemID);
				thePlayer:showInfoBox("info", "Klicke auf das Objekt um es zu bewegen!");
				return true;
			else
				thePlayer:getInventory():addItem(Items[ItemID], 1);
				thePlayer:showInfoBox("error", "Das geht nur in einem Haus!");
				return false;
			end
		end
	end
	if(ItemID == 199) then -- Zeitung
		ofactions.News:PreviewNewspaper(thePlayer);
	end

	--Waffen
	if(ItemID == 241) then -- AK-47
		thePlayer:addWeapon(30, 30, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine AK-47!")
	end
	if(ItemID == 242) then -- Deagle
		thePlayer:addWeapon(24, 7, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine Deagle!")
	end
	if(ItemID == 243) then -- M4
		thePlayer:addWeapon(31, 50, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine M4!")
	end
	if(ItemID == 244) then -- 9mm
		thePlayer:addWeapon(22, 17, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine 9mm!")
	end
	if(ItemID == 245) then -- Micro-SMG
		thePlayer:addWeapon(28, 50, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine\nMicro-SMG!")
	end
	if(ItemID == 246) then -- Tec9
		thePlayer:addWeapon(32, 50, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine Tec9!")
	end
	if(ItemID == 247) then -- MP5
		thePlayer:addWeapon(29, 30, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine MP5!")
	end
	if(ItemID == 248) then -- Abg. Schrotflinte
		thePlayer:addWeapon(26, 2, true)
		thePlayer:showInfoBox("info", "Du trägst nun eine\nAbgesägte Schrotflinte!")
	end
	if(ItemID == 249) then -- Gewehr
		thePlayer:addWeapon(33, 10, true)
		thePlayer:showInfoBox("info", "Du trägst nun ein Gewehr!")
	end
	if(ItemID == 250) then -- Sniper
		thePlayer:addWeapon(34, 1, true)
		thePlayer:showInfoBox("info", "Du trägst nun ein\nScharfschützengewehr!")
	end

	if(ItemID == 253) then -- Munition Typ A
		local slot = 2
		if (getPedWeapon(thePlayer, slot) ~= 0) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), getWeaponProperty(getPedWeapon(thePlayer, slot), "pro", "maximum_clip_ammo")*3, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 254) then -- Munition Typ B
		local slot = 3
		if (getPedWeapon(thePlayer, slot) ~= 0) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), getWeaponProperty(getPedWeapon(thePlayer, slot), "pro", "maximum_clip_ammo")*3, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 255) then -- Munition Typ C
		local slot = 4
		if (getPedWeapon(thePlayer, slot) ~= 0) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), getWeaponProperty(getPedWeapon(thePlayer, slot), "pro", "maximum_clip_ammo")*3, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 256) then -- Munition Typ D
		local slot = 5
		if (getPedWeapon(thePlayer, slot) ~= 0) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), getWeaponProperty(getPedWeapon(thePlayer, slot), "pro", "maximum_clip_ammo")*3, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 257) then -- Munition Typ E
		local slot = 6
		if (getPedWeapon(thePlayer, slot) == 33) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), 10, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 258) then -- Munition Typ F
		local slot = 6
		if (getPedWeapon(thePlayer, slot) == 34) then
			thePlayer:addWeapon(getPedWeapon(thePlayer, slot), 1, false)
			thePlayer:showInfoBox("info", "Du hast Munition ausgerüstet!")
		else
			thePlayer:showInfoBox("error", "Diese Munition kannst du nicht nutzen!")
			thePlayer:getInventory():addItem(Items[ItemID], 1)
			thePlayer:refreshInventory()
		end
		return true
	end
	if(ItemID == 260) then -- Benzinkanister
		local x,y,z = getElementPosition(thePlayer)
		local sphere = createColSphere(x,y,z, 3)

		local cars = getElementsWithinColShape(sphere, "vehicle")

		destroyElement(sphere)

		if (#cars ~= 1 ) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Es sind keine oder zu viele Fahrzeuge in diener Nähe!")
			return false
		end
		if vehicleCategoryManager:isNoFuelVehicleCategory(cars[1]) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Dieses Fahrzeug hat keinen Tank!")
			return false
		else
			if (thePlayer.Fraktion:getID() == 7 or (cBasicFunctions:calculateProbability(75))) then
				cars[1]:setFuel(cars[1]:getFuel()+20)
				thePlayer:showInfoBox("warning", "Du hast ein Fahrzeug aufgefüllt!")
			else
				thePlayer:showInfoBox("warning", "Du hast das Benzin verschüttet!")
			end
			return true
		end
	end
	if(ItemID == 261) then -- Reperaturkit
		local x,y,z = getElementPosition(thePlayer)
		local sphere = createColSphere(x,y,z, 3)

		local cars = getElementsWithinColShape(sphere, "vehicle")

		destroyElement(sphere)

		if (#cars ~= 1 ) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Es sind keine oder zu viele Fahrzeuge in diener Nähe!")
			return false
		end

		if (thePlayer.Fraktion:getID() == 7 or (cBasicFunctions:calculateProbability(75))) then
			fixVehicle(cars[1])
			thePlayer:showInfoBox("warning", "Du hast ein Fahrzeug repariert!")
		else
			thePlayer:showInfoBox("warning", "Du hast das Werkzeug zerstört!")
		end
		return true
	end
	if(ItemID == 262) then -- Gangwarpaket
		-- Animation:
		if(thePlayer:getData("jailed") ~= true) then
			setPedAnimation(thePlayer, "shop", "ROB_Shifty", -1, true, false, false)
			toggleAllControls(thePlayer, false)
			setTimer(function()
				thePlayer:addWeapon(29, 180, true)
				thePlayer:addWeapon(31, 200, true)
				thePlayer:addWeapon(24, 49, true)
				if (getElementDimension(thePlayer) ~= 60000) then
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 1000)
				end
				thePlayer:showInfoBox("info", "Du bist nun ausgerüstet! Gib ihnen!")
				setPedAnimation(thePlayer)
				toggleAllControls(thePlayer, true)
			end, 10000, 1)
			return true
		else
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Du bist im Gefaengnis!");
		end
		return false;
	end

	if(ItemID == 263) then -- Namechange
		triggerClientEvent(thePlayer, "onClientNamechangeOpen", getRootElement())
		return true
	end

	if(ItemID == 264) then -- Respawngerät
		if (thePlayer:getRank() >= 4) then
			local FID = thePlayer:getFaction():getID()
			for k,v in pairs(FactionVehicles) do
				if (v:getFaction():getID() == FID) then
					if (isVehicleEmpty(v)) then
						respawnVehicle(v)
					end
				end
			end
			thePlayer:getFaction():sendMessage(getPlayerName(thePlayer).." hat die Fraktionsfahrzeuge respawnt.")
		end
		return true
	end
	if(ItemID == 265) then -- Geldsack
		local geld	= math.random(100, 1000);
		thePlayer:addMoney(geld);
		thePlayer:showInfoBox("sucess", "Du hast $"..geld.." in dem Geldsack gefunden!")
		return true
	end
	if(cat) and (cat == 23) then -- Feuerwerk
		if(getElementInterior(thePlayer) ~= 0) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "Feuerwerk kannst du nur in der Aussenwelt benutzen!")
			return false;
		elseif(isPedInVehicle(thePlayer)) then
			thePlayer:getInventory():addItem(Items[ItemID], 1);
			thePlayer:showInfoBox("error", "In einem Fahrzeug moechtest du ungern Feuerwerk zuenden!")
			return false;
		else
			if(isTimer(ItemTimer[thePlayer][cat])) then
				thePlayer:getInventory():addItem(Items[ItemID], 1);
				thePlayer:showInfoBox("error", "Feuerwerk kannst du nur alle 15 Sekunden platzieren! Bitte warte einen Moment. (Anti-Lag)")
				return false;
			end
			triggerClientEvent(thePlayer, "hideInventoryGui", thePlayer);
			ItemTimer[thePlayer][cat]    = setTimer(function() end, 15000, 1);
			thePlayer:showInfoBox("info", "Feuerwerk wird platziert. Benutze /designer fuer bessere Sicht!")
		end
    end
    if(cat) and (cat == 28) then -- Huete
        if(_Gsettings.huete_models[ItemID]) then
            thePlayer:setHeadObject(unpack(_Gsettings.huete_models[ItemID]))
            thePlayer.HeadItem  = ItemID;
			return
        end
	end
	if(ItemID == 286) then		-- Hutentferner
		thePlayer:setHeadObject(0)
		thePlayer.HeadItem  = 0;
		return
	end
	-- FEUERWERK --
	if(ItemID == 266) then
		fireworkManager:launchPlayerFW(thePlayer, "boeller", {x, y, z});
		return true;
	end
	if(ItemID == 267) then
		fireworkManager:launchPlayerFW(thePlayer, "rakete", {x, y, z});
		return true;
	end
	if(ItemID == 268) then
		fireworkManager:launchPlayerFW(thePlayer, "raketenbatterie", {x, y, z, math.random(5, 8)});
		return true;
	end
	if(ItemID == 269) then
		fireworkManager:launchPlayerFW(thePlayer, "kugelbombe", {x, y, z});
		return true;
	end
	if(ItemID == 270) then
		fireworkManager:launchPlayerFW(thePlayer, "roemischekerze", {x, y, z, math.random(10, 15)});
		return true;
	end
	if(ItemID == 271) then
		fireworkManager:launchPlayerFW(thePlayer, "roemischekerzebatterie", {x, y, z, math.random(10, 15)});
		return true;
	end
	if(ItemID == 272) then
		fireworkManager:launchPlayerFW(thePlayer, "groundshell", {x, y, z});
		return true;
	end
	if(ItemID == 274) then	-- Hanfwurzel
		triggerClientEvent(thePlayer, "onDrugPlaceValid", thePlayer, ItemID);
		triggerClientEvent(thePlayer, "hideInventoryGui", thePlayer);
		return true;
	end
	if(ItemID == 275) then	-- Canabiswurzel
		triggerClientEvent(thePlayer, "onDrugPlaceValid", thePlayer, ItemID);
		triggerClientEvent(thePlayer, "hideInventoryGui", thePlayer);
		return true;
	end
	if (ItemID == 290) then -- Fisch
	--	thePlayer:eat(10)
		thePlayer:showInfoBox("error", "Diese Funktion wird in ca. 5 Monaten implementiert!")
		return false
	end
	if (ItemID == 300) then -- Artifakt
	--	thePlayer:eat(10)
		thePlayer:showInfoBox("info", "Du musst eine Aufladung benutzen, um nach Artefakten zu suchen!")
		return false
	end
	if (ItemID == 301) or (ItemID == 302) or (ItemID == 303) or (ItemID == 304) or (ItemID == 305) then
	--	thePlayer:eat(10)
		if(thePlayer:hasArtifactScanner(ItemID)) then
			if not(isTimer(thePlayer.m_uArtifactTimer)) then
				if not(isPedInVehicle(thePlayer)) then
					thePlayer.m_uArtifactTimer	= setTimer(function() end, 10000, 1)
					cArtifactManager:getInstance():scanForPlayerArtifacts(thePlayer, ItemID)
					triggerClientEvent(thePlayer, "hideInventoryGui", thePlayer);
					return true
				else
					thePlayer:showInfoBox("error", "Du musst aus deinem Fahrzeug aussteigen, um den Scanner zu benutzen!")
				end
			else
				thePlayer:showInfoBox("error", "Du musst 10 Sekunden warten bevor du den Scanner erneut benutzen kannst!")
			end
		else
			thePlayer:showInfoBox("error", "Du benoetigst erst ein Artefaktscanner der geeigneten Klasse!")
		end
		return false
	end
	--[[

		Baumarkt Items:
			1255 	- Liege
			642		- Sonnenschirm
			1481	- Grill
			3461	- Fackel
			1429	- Fernsehgeraet
			1463	- Holz
			1432	- Tisch und Stuhl
			1419	- Eisenzaun
			1457 	- Kleine Huette
			2103	- Radio
			1215	- Standlicht
			1280	- Parkbank
			2190	- Computer
			640		- Strauchtopf
			792		- Strassenbaeumchen
			644		- Blumentopf
	--]]
    return false
end
