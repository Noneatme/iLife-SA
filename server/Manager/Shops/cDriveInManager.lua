--[[
	/////// //////////////////
	/////// PROJECT: MTA iLife - German Fun Reallife Gamemode
	/////// VERSION: 1.7.2 
	/////// DEVELOPERS: See DEVELOPERS.md in the top folder
	/////// LICENSE: See LICENSE.md in the top folder 
	/////// /////////////////
]]

CDriveInManager = inherit(cSingleton)

function CDriveInManager:constructor()
	local start = getTickCount()
	local qh = CDatabase:getInstance():query("Select * From drivein")
	for i,v in ipairs(qh) do
		local drivein = createMarker(v["X"], v["Y"], v["Z"], "corona", 4, 255, 0, 0)
		enew(drivein, CDriveIn, v["ID"], v["Type"], v["X"], v["Y"], v["Z"], v["Filiale"])
	end
	outputDebugString("Es wurden "..#DriveIns.." Driveins gefunden (" .. getTickCount() - start .. "ms)",3)
end
