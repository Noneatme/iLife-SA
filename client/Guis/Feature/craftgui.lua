--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

isCrafting = false
CraftingTimer = false

CraftingGui = {
    ["Window"] = false,
    ["Button"] = {},
    ["Label"] = {},
    ["Edit"] = {},
    ["List"] = {},
	["Progressbar"] = {}
}

function showCraftingGui(sName, tCraftings)
	if not(clientBusy) then
		hideCraftingGui()
		
		--Links
		
		CraftingGui["Window"] = new(CDxWindow, sName, 600, 500, true, true, "Center|Middle")
		
		CraftingGui["Label"][1] = new(CDxLabel, "Herstellbare Items:",10, 5, 330, 30, tocolor(255,255,255,255), 1.0, "default-bold", "left", "top", CraftingGui["Window"])
		
		CraftingGui["List"][1] = new(CDxList, 5, 40, 340, 300, tocolor(125,125,125,200), CraftingGui["Window"])
		CraftingGui["List"][1]:addColumn("ID")
		CraftingGui["List"][1]:addColumn("Name")
		
		for k,v in ipairs(tCraftings) do
			CraftingGui["List"][1]:addRow(v["ID"].."|"..parseString(v["CraftedItem"]["Name"]))
		end

		CraftingGui["List"][1]:addClickFunction(
			function ()
				CraftingGui["List"][2]:clearRows()
				if (CraftingGui["List"][1]:getRowData(1) ~= "nil") then
					for k,v in ipairs(tCraftings) do
						if v["ID"] == tonumber(CraftingGui["List"][1]:getRowData(1)) then
							
							CraftingGui["Label"][3]:setText("Anzahl: "..v["CraftedItemCount"])
							CraftingGui["Label"][4]:setText("Kosten: "..v["Cost"].."$")
							
							for kk,vv in ipairs(v["Ingredients"]) do
								vv["Item"]["Name"] = parseString(vv["Item"]["Name"])
								local invc = InventoryData["Items"][tostring(vv["Item"]["ID"])]
								if invc == nil then
									invc = 0
								end
								CraftingGui["List"][2]:addRow(vv["Item"]["Name"].."|"..vv["Count"].." ("..tostring(invc)..")")
							end
							break;
						end
					end
				end
			end
		)
		
		CraftingGui["Button"][1] = new(CDxButton, "Herstellen", 5, 350, 340, 42, tocolor(255,255,255,255), CraftingGui["Window"])
		
		CraftingGui["Button"][1]:addClickFunction(
			function ()
				if (CraftingGui["List"][1]:getRowData(1) ~= "nil") then
					if (isCrafting) then
						isCrafting = false
						CraftingGui["Progressbar"][1]:setProgress(0.0)
						if (CraftingTimer and isTimer(CraftingTimer)) then
							killTimer(CraftingTimer)
						end
						CraftingGui["Button"][1]:setText("Herstellen")
						CraftingGui["List"][1]:setDisabled(false)
						CraftingGui["List"][2]:setDisabled(false)
					else
						CraftingGui["List"][1]:setDisabled(true)
						CraftingGui["List"][2]:setDisabled(true)
						isCrafting = true
						CraftingGui["Button"][1]:setText("Abbrechen")
						CraftingTimer = setTimer(
							function() 
								if (isCrafting) then 
									if (CraftingGui["Progressbar"][1]:getProgress() == 1) then 
										isCrafting = false
										CraftingGui["Progressbar"][1]:setProgress(0.0)
										triggerServerEvent("onPlayerCraft", getRootElement(), tonumber(CraftingGui["List"][1]:getRowData(1)))
										if (CraftingTimer and isTimer(CraftingTimer)) then
											killTimer(CraftingTimer)
										end
										CraftingGui["Button"][1]:setText("Herstellen")
										CraftingGui["List"][1]:setDisabled(false)
										CraftingGui["List"][2]:setDisabled(false)
										setTimer(function()
										CraftingGui["List"][2]:clearRows()
										if (CraftingGui["List"][1]:getRowData(1) ~= "nil") then
											for k,v in ipairs(tCraftings) do
												if v["ID"] == tonumber(CraftingGui["List"][1]:getRowData(1)) then
													
													CraftingGui["Label"][3]:setText("Anzahl: "..v["CraftedItemCount"])
													CraftingGui["Label"][4]:setText("Kosten: "..v["Cost"].."$")
													
													for kk,vv in ipairs(v["Ingredients"]) do
														vv["Item"]["Name"] = parseString(vv["Item"]["Name"])
														local invc = InventoryData["Items"][tostring(vv["Item"]["ID"])]
														if invc == nil then
															invc = 0
														end
														CraftingGui["List"][2]:addRow(vv["Item"]["Name"].."|"..vv["Count"].." ("..tostring(invc)..")")
													end
													break;
												end
											end
										end
										end, 500,1)
									else 
										CraftingGui["Progressbar"][1]:setProgress(CraftingGui["Progressbar"][1]:getProgress()+0.01) 
									end 
								end 
							end
						, 100, 101)
					end
				else
					showInfoBox("error", "Wähle ein Crafting aus!")
				end
			end
		)
	  
		CraftingGui["Progressbar"][1] = new(CDxProgressbar, 0.0, 5, 410, 590, 42, tocolor(255,255,255,255), CraftingGui["Window"])
	  
		--Rechts
		
		CraftingGui["Label"][2] = new(CDxLabel, "Inhalt:", 360, 5, 230, 30, tocolor(255,255,255,255), 1, "default-bold", "left", "top", CraftingGui["Window"])
		
		CraftingGui["List"][2] = new(CDxList, 350, 40, 240, 300, tocolor(125,125,125,200), CraftingGui["Window"])
		CraftingGui["List"][2]:addColumn("Name")
		CraftingGui["List"][2]:addColumn("Anzahl")
		
		CraftingGui["Label"][3] = new(CDxLabel, "Anzahl: -", 360, 350, 230, 21, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", CraftingGui["Window"])
		CraftingGui["Label"][4] = new(CDxLabel, "Kosten: -", 360, 372, 230, 21, tocolor(255,255,255,255), 1.0, "default-bold", "left", "center", CraftingGui["Window"])
		
		CraftingGui["Window"]:add(CraftingGui["Label"][1])
		CraftingGui["Window"]:add(CraftingGui["Label"][2])
		CraftingGui["Window"]:add(CraftingGui["Label"][3])
		CraftingGui["Window"]:add(CraftingGui["Label"][4])
		
		CraftingGui["Window"]:add(CraftingGui["List"][1])  
		CraftingGui["Window"]:add(CraftingGui["List"][2])
		   
		CraftingGui["Window"]:add(CraftingGui["Button"][1])

		CraftingGui["Window"]:add(CraftingGui["Progressbar"][1])
			
		CraftingGui["Window"]:show()
		
		refreshCraftingGui()
	end
end

function refreshCraftingGui()
    if (CraftingGui["Window"]) then
		CraftingGui["List"][2]:clearRows()
	end
end

addEvent("showCraftingGui", true)
addEventHandler("showCraftingGui", getRootElement(), 
    function(sName, tCraftings)
        showCraftingGui(sName, tCraftings)
    end
)

function hideCraftingGui()
	if (CraftingGui["Window"]) then
		CraftingGui["Window"]:hide()
		delete(CraftingGui["Window"])
		CraftingGui["Window"] = nil
	end
end
addEvent("hideCraftingGui", true)
addEventHandler("hideCraftingGui", getRootElement(), hideCraftingGui)