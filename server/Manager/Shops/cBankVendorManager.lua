--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CBankVendorManager = inherit(cSingleton)

function CBankVendorManager:constructor()
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM bankvendor")
	for key,value in ipairs(result) do
		local int,dim,x,y,z,rx,ry,rz
		int = gettok(value["Koords"],1,"|")
		dim = gettok(value["Koords"],2,"|")
		x = gettok(value["Koords"],3,"|")
		y = gettok(value["Koords"],4,"|")
		z = gettok(value["Koords"],5,"|")
		rx = gettok(value["Koords"],6,"|")
		ry = gettok(value["Koords"],7,"|")
		rz = gettok(value["Koords"],8,"|")
		local vendor = createObject(2942, x,y,z,rx,ry,rz, false)
		enew(vendor, CBankVendor, value["ID"], value["Koords"])
		cInformationWindowManager:getInstance():addInfoWindow({x, y, z+1}, "Geldautomat", 30)
	end
	outputServerLog("Es wurden "..#result.." BankVendors gefunden! (" .. getTickCount() - start .. "ms)")
end

function CBankVendorManager:destructor()

end