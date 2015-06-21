--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

TradeGuiSelectedItem = nil

TradeGui = {
    ["Window"] = false,
    ["Image"] = {},
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {}
}

TradeGui_CurrentSelectedCategory = 1

TradePlayer = false

function showTradeGui()
    hideTradeGui()
    
	--Links
	
    TradeGui["Window"] = new(CDxWindow, "Handel - "..getPlayerName(TradePlayer), 600, 540, true, true, "Center|Middle")
	
	TradeGui["Image"][1] = new(CDxImage, 5, 5, 30, 30, "/res/images/left.png",tocolor(255,255,255,255), TradeGui["Window"])
	TradeGui["Image"][2] = new(CDxImage, 265, 5, 30, 30, "/res/images/right.png",tocolor(255,255,255,255), TradeGui["Window"])

	TradeGui["Image"][1]:addClickFunction(
		function()
		    if (TradeGui_CurrentSelectedCategory ~= 1) then
		        TradeGui_CurrentSelectedCategory = TradeGui_CurrentSelectedCategory-1
		    else
		        TradeGui_CurrentSelectedCategory = #ItemCategories 
		    end
		    refreshTradeGui()
		end
    )

    TradeGui["Image"][2]:addClickFunction(
		function()
		    if (TradeGui_CurrentSelectedCategory ~= #ItemCategories) then
		        TradeGui_CurrentSelectedCategory = TradeGui_CurrentSelectedCategory+1
		    else
		        TradeGui_CurrentSelectedCategory =  1
		    end
		    refreshTradeGui()
		end
    )
	
	TradeGui["Label"][1] = new(CDxLabel, ItemCategories[TradeGui_CurrentSelectedCategory]["Name"],40, 5, 220, 50, tocolor(255,255,255,255), 1.0, "pricedown", "center", "top", TradeGui["Window"])
	
	TradeGui["List"][1] = new(CDxList, 5, 40, 290, 330, tocolor(125,125,125,200), TradeGui["Window"])
	TradeGui["List"][1]:addColumn("Name")
	TradeGui["List"][1]:addColumn("Anzahl")
	
	for k,v in ipairs(Items) do
	    if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == TradeGui_CurrentSelectedCategory) ) then
			if (v["Tradeable"] == true) then
				TradeGui["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])     
			end
	   end
	end
	
	TradeGui["Label"][2] = new(CDxLabel, "Anzahl:", 5, 380, 290, 20, tocolor(255,255,255,255), 1, "default", "left", "top", TradeGui["Window"])
	TradeGui["Edit"][1] = new(CDxEdit, "1", 5, 405, 290, 40, "Number", tocolor(0,0,0,255), TradeGui["Window"])  
	TradeGui["Button"][1] = new(CDxButton, "Hinzufügen", 5, 450, 290, 42, tocolor(255,255,255,255), TradeGui["Window"])
  
	TradeGui["Button"][1]:addClickFunction(
		function ()
			if (TradeGui["List"][1]:getRowData(1) == "nil") then
				showInfoBox("error", "Du musst ein Item auswählen.")
				return false
			end
			triggerServerEvent("onPlayerAddTradeItem", getLocalPlayer(), ItemNames[TradeGui["List"][1]:getRowData(1)], TradeGui["Edit"][1]:getText() )
		end
    )
  
	--Rechts
	
	TradeGui["Label"][3] = new(CDxLabel, "Dein Angebot:",300, 15, 300, 45, tocolor(255,255,255,255), 1.0, "default", "center", "top", TradeGui["Window"])

	TradeGui["List"][2] = new(CDxList, 305, 40, 290, 150, tocolor(125,125,125,200), TradeGui["Window"])
	TradeGui["List"][2]:addColumn("Name")
	TradeGui["List"][2]:addColumn("Anzahl")
	
	TradeGui["Label"][4] = new(CDxLabel, "Angebot von "..getPlayerName(TradePlayer)..":",300, 195, 300, 45, tocolor(255,255,255,255), 1.0, "default", "center", "top", TradeGui["Window"])
	
	TradeGui["List"][3] = new(CDxList, 305, 215, 290, 150, tocolor(125,125,125,200), TradeGui["Window"])
	TradeGui["List"][3]:addColumn("Name")
	TradeGui["List"][3]:addColumn("Anzahl")
	
	TradeGui["Button"][2] = new(CDxButton, "Zurücksetzen", 305, 380, 290, 35, tocolor(255,255,255,255), TradeGui["Window"])
	
	TradeGui["Button"][2]:addClickFunction(
		function ()
			-- Clear
		    triggerServerEvent("onPlayerResetTradeItems", getLocalPlayer())
		end
    )
	
	TradeGui["Button"][3] = new(CDxButton, "Akzeptieren", 305, 420, 290, 35, tocolor(255,255,255,255), TradeGui["Window"])
	
	TradeGui["Button"][3]:addClickFunction(
		function ()
			-- Accept
		    triggerServerEvent("onPlayerAcceptTrade", getLocalPlayer())
		end
    )
	
	TradeGui["Button"][4] = new(CDxButton, "Abbrechen", 305, 460, 290, 35, tocolor(255,255,255,255), TradeGui["Window"])
	
	TradeGui["Button"][4]:addClickFunction(
		function ()
			-- Interrupt
			hideTradeGui(true)
		end
    )
	
	TradeGui["Window"]:add(TradeGui["Image"][1])
	TradeGui["Window"]:add(TradeGui["Image"][2])

	TradeGui["Window"]:add(TradeGui["Label"][1])
	TradeGui["Window"]:add(TradeGui["Label"][2])
	TradeGui["Window"]:add(TradeGui["Label"][3])
	TradeGui["Window"]:add(TradeGui["Label"][4])
		
	TradeGui["Window"]:add(TradeGui["List"][1])  
	TradeGui["Window"]:add(TradeGui["List"][2])
	TradeGui["Window"]:add(TradeGui["List"][3])	
	   
	TradeGui["Window"]:add(TradeGui["Button"][1])
	TradeGui["Window"]:add(TradeGui["Button"][2])
	TradeGui["Window"]:add(TradeGui["Button"][3])    
	TradeGui["Window"]:add(TradeGui["Button"][4])
		
	TradeGui["Window"]:add(TradeGui["Edit"][1])
	    
	TradeGui["Window"]:setHideFunction(
		function() 
			hideTradeGui(true)
		end
	)	
		
	TradeGui["Window"]:show()
	
	refreshTradeGui()
end

function refreshTradeGui()
    if (TradeGui["Window"]) then
        TradeGui["List"][1]:clearRows()
        TradeGui["Label"][1]:setText(ItemCategories[TradeGui_CurrentSelectedCategory]["Name"])
        for k,v in ipairs(Items) do
            if ( (InventoryData["Items"][tostring(v["ID"])])  and (v["Category"]["ID"] == TradeGui_CurrentSelectedCategory) ) then
                if (v["Tradeable"] == true) then
					TradeGui["List"][1]:addRow(v["Name"].."|"..InventoryData["Items"][tostring(v["ID"])])    
				end
			end
        end
		
		local color = tocolor(255,0,0)
		if (getElementData(getLocalPlayer(),"Trade")["Accept"]) then
			color = tocolor(0,255,0)
		end
		TradeGui["Label"][3]:setColor(color)
		
		TradeGui["List"][2]:clearRows()
		local ownitems = getElementData(getLocalPlayer(),"Trade")["Items"]
		for k,v in pairs(ownitems) do
            TradeGui["List"][2]:addRow(v["Name"].."|"..v["Count"])    
        end
		
		local color = tocolor(255,0,0)
		if (getElementData(TradePlayer,"Trade")["Accept"]) then
			color = tocolor(0,255,0)
		end
		TradeGui["Label"][4]:setColor(color)
		
		TradeGui["List"][3]:clearRows()
		local plitems = getElementData(TradePlayer,"Trade")["Items"]
		for k,v in pairs(plitems) do
            TradeGui["List"][3]:addRow(v["Name"].."|"..v["Count"])    
        end
	end
end

addEvent("showTradeGui", true)
addEventHandler("showTradeGui", getRootElement(), 
    function(Player)
		TradePlayer = Player
        showTradeGui()
    end
)

function hideTradeGui(ovr)
	if (TradeGui["Window"]) then
		TradeGui["Window"]:hide()
		delete(TradeGui["Window"])
		TradeGui["Window"] = nil
		if (ovr) then
			TradePlayer = false
			triggerServerEvent("onPlayerDeclineTrade", getLocalPlayer())
		end
	end
end
addEvent("hideTradeGui", true)
addEventHandler("hideTradeGui", getRootElement(), hideTradeGui)

addEventHandler("onClientElementDataChange", getRootElement(), 
	function(dataName)
		if (dataName == "Trade") then
			if (source == getLocalPlayer()) or (source == TradePlayer) then
				refreshTradeGui()
			end
		end
	end
 )