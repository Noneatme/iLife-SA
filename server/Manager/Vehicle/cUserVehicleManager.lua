--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CUserVehicleManager = inherit(cSingleton)

function CUserVehicleManager:constructor()
	self.BadVehicleSpawns = {
		["998.0048828125|-954.5986328125|41.607006072998|358.18725585938|345.5419921875|99.283447265625"] = true,
		["2136.998046875|-1119.6201171875|25.062469482422|359.67041015625|5.5975341796875|78.782958984375"] = true,
		["725.2607421875|-1520.0546875|-0.46512457728386|2.52685546875|0.076904296875|179.85168457031"] = true,
		["1687.04296875|1867.9501953125|10.368960380554|359.51110839844|355.0341796875|269.90661621094"] = true,
		["1933.0390625|2066.955078125|10.368537902832|359.51110839844|4.9603271484375|179.2529296875"] = true,
		["528.099609375|-1270.73046875|15.985728263855|0.626220703125|354.0673828125|305.88684082031"] = true
	}

	self.loadFunc		= function() self:createVehicles() end

	self.thread			= cThread:new("User_Vehicle_Loading_Thread", self.loadFunc, 5)

end

function CUserVehicleManager:destructor()

end

function CUserVehicleManager:startThread()
	self.thread:start(50);
end


function CUserVehicleManager:packFahrzeugInAndereTabelle(result)
	local id = result["ID"]
	CDatabase:getInstance():query("DELETE FROM vehicles WHERE ID=?", id);
    cBasicFunctions:doArchiveRowIntoDatabaseTable(1, result);
end

function CUserVehicleManager:createVehicles()
	local start = getTickCount()
	result = CDatabase:getInstance():query("SELECT * FROM vehicles")
	local Deleted 	= 0
	local Old		= 0;

	self.m_tblVehicleTrunks	= {}

	local result2 = CDatabase:getInstance():query("SELECT * FROM vehicle_trunk_sizes;")
	if(result2) and (#result2 > 0) then
		for index, row in pairs(result2) do
			self.m_tblVehicleTrunks[tonumber(row['VehicleID'])] = tonumber(row['MaxSize']) or 250000;
		end
	end

	if (#result > 0) then
		local count = 0;
		for key, value in pairs(result) do
			if (self.BadVehicleSpawns[value["Koords"]]) then
				CDatabase:getInstance():query("DELETE FROM vehicles WHERE ID=?", value["ID"])
				Deleted = Deleted + 1
				logger:OutputPlayerLog("Fahrzeug", "War nicht geparkt und wurde gelöscht!", tostring(value["ID"]));
			else
				local ownerID		= value["OwnerID"];
				if(isOwnerInTheLastMonthsActive(tonumber(ownerID))) then
					local theVehicle = createVehicle(value["VID"], gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"), value["Plate"])
					setVehicleRespawnPosition(theVehicle, gettok(value["Koords"],1,"|"), gettok(value["Koords"],2,"|"), gettok(value["Koords"],3,"|"), gettok(value["Koords"],4,"|"), gettok(value["Koords"],5,"|"), gettok(value["Koords"],6,"|"))
					enew(theVehicle, CUserVehicle, value["ID"], value["OwnerID"], value["Int"], value["Dim"], value["VID"], value["Koords"], value["Color"], value["Tuning"], value["Plate"], value["Fuel"],value["KM"], value["Health"], value["LichtFarbe"], value["Dirtlevel"], value["Abstellposition"], value["Paintjob"], value["Spezialtunings"], value["Schluessel"], value["Inventar"], value["MiscSettings"], value["KaufDatum"])
					count = count1
				else
					self:packFahrzeugInAndereTabelle(value)
					Old = Old+1;
				end
			end
			coroutine.yield();
		end
		outputDebugString("USERVEHICLES: "..tostring(count)..", "..Deleted.." deleted, "..Old.." moved (" .. getTickCount() - start .. "ms)")
	else
		outputServerLog("Es wurden keine Fahrzeuge gefunden.")
	end
end
