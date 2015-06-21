--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

JobOverviewGui = {
	["Window"] = false,
	["Image"] = {},
	["Button"] = {},
	["List"] = {},
	["Label"] = {}
}

Jobs = {
}

function showJobOverviewGui()
	if (not clientBusy) then
		hideJobOverviewGui()
		
		JobOverviewGui["Window"] = new(CDxWindow, "Jobs", 400, 450, true, true, "Center|Middle")
		
		
		JobOverviewGui["List"][1] = new(CDxList, 5, 20, 390, 320, tocolor(125,125,125,200), JobOverviewGui["Window"])
		JobOverviewGui["Button"][1] = new(CDxButton, "Auf Karte anzeigen", 5, 360, 390, 42, tocolor(255,255,255,255), JobOverviewGui["Window"])
		JobOverviewGui["List"][1]:addColumn("ID")
		JobOverviewGui["List"][1]:addColumn("Name")
		
		for k,v in pairs(Jobs) do
			JobOverviewGui["List"][1]:addRow(v["ID"].."|"..v["Name"])
		end

		JobOverviewGui["Button"][1]:addClickFunction(
			function() 
				local x,y,z = gettok(Jobs[tonumber(JobOverviewGui["List"][1]:getRowData(1))]["Koords"], 1, "|"),  gettok(Jobs[tonumber(JobOverviewGui["List"][1]:getRowData(1))]["Koords"], 2, "|"), gettok(Jobs[tonumber(JobOverviewGui["List"][1]:getRowData(1))]["Koords"], 3, "|")
				clearJobBlip()
				JobBlip = createBlip(x,y,z, 41, 5,255,0,0,255,0,999999)
				setElementInterior(JobBlip,0)
				setElementDimension(JobBlip,0)
				JobBlip2 = createBlip(x,y,z, 41, 5,255,0,0,255,0,999999)
				setElementInterior(JobBlip2,3)
				setElementDimension(JobBlip2,20088)
				JobBlipResetTimer = setTimer(clearJobBlip, 300000, 1)
				showInfoBox("info", "Der Job ist nun auf der Karte makiert!")
			end
		)		
		
		JobOverviewGui["Window"]:add(JobOverviewGui["List"][1])
		JobOverviewGui["Window"]:add(JobOverviewGui["Button"][1])
		
		JobOverviewGui["Window"]:show()
	end
end

function clearJobBlip()
	if (isElement(JobBlip)) then
		destroyElement(JobBlip)
	end
	if (isElement(JobBlip2)) then
		destroyElement(JobBlip2)
	end
	if (isTimer(JobBlipResetTimer)) then
		killTimer(JobBlipResetTimer)
	end
end 

function hideJobOverviewGui()
	if (JobOverviewGui["Window"]) then
		JobOverviewGui["Window"]:hide()
		delete(JobOverviewGui["Window"])
		JobOverviewGui["Window"] = false
	end
end

function toggleJobOverviewGui()
	if (JobOverviewGui["Window"]) then
		hideJobOverviewGui()
	else
		showJobOverviewGui()
	end
end

addEventHandler("onClientResourceStart", getRootElement(), function() triggerServerEvent("onClientRequestJobs", getRootElement()) end)

addEvent("onClientJobPickupHit", true)

addEventHandler("onClientJobPickupHit", getRootElement(), 
	function()
		toggleJobOverviewGui()
	end
)

addEvent("onClientRecieveJobs", true)
addEventHandler("onClientRecieveJobs", getRootElement(), 
	function (Data)
		Jobs = Data
	end
)