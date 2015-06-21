--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CTrashcanManager = inherit(cSingleton)

function CTrashcanManager:constructor()
	local start = getTickCount()
	local result = CDatabase:getInstance():query("SELECT * FROM trashcan")
	for key,value in ipairs(result) do
		local int,dim,x,y,z,rx,ry,rz
		int = gettok(value["Pos"],1,"|")
		dim = gettok(value["Pos"],2,"|")
		x = gettok(value["Pos"],3,"|")
		y = gettok(value["Pos"],4,"|")
		z = gettok(value["Pos"],5,"|")
		rx = gettok(value["Pos"],6,"|")
		ry = gettok(value["Pos"],7,"|")
		rz = gettok(value["Pos"],8,"|")
		
		local objid = 1359
		
		local can = createObject(objid, x,y,z,rx,ry,rz, false)
		enew(can, CTrashcan, value["ID"], value["Pos"])
	--	cInformationWindowManager:getInstance():addInfoWindow({x, y, z+1}, "Abfalltonne", 30)
	end
	outputServerLog("Es wurden "..#result.." Trashcans gefunden! (" .. getTickCount() - start .. "ms)")
end

function CTrashcanManager:destructor()

end